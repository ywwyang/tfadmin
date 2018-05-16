<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK IT ]
// +----------------------------------------------------------------------
// | Copyright (c) 2009 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------
namespace org;

use think\Db;
use think\Config;
use think\Session;
use think\Request;
use think\Cache;

class Rbac {
	// 认证方法
	public static function authenticate($map, $model = '')
    {
        if (!$model) {
            $model = Config::get('rbac.user_auth_model');
        }
        //使用给定的Map进行认证
        return Db::name($model)->where($map)->find();
    }
	
    // 用于检测用户权限的方法,并保存到Session中
    public static function saveAccessList($authId = null) {
        if(null === $authId) {
            $authId = Session::get(Config::get('rbac.user_auth_key'));
        }
        // 如果使用普通权限模式，保存当前用户的访问权限列表
        // 对管理员开发所有权限
        if(Config::get('rbac.user_auth_type') != 2 && !Session::get(Config::get('rbac.admin_auth_key'))){
            Session::get('_access_list', self::getAccessList($authId));
        }
        return ;
    }

	// 取得模块的所属记录访问权限列表 返回有权限的记录ID数组
	public static function getRecordAccessList($authId = null,$module = '') {
        if(null === $authId)   $authId = Session::get(Config::get('rbac.user_auth_key'));
        if(empty($module))  $module	 = Request::instance()->controller();
        //获取权限访问列表
        $accessList = self::getModuleAccessList($authId,$module);
        return $accessList;
	}

    //检查当前操作是否需要认证
    public static function checkAccess() {
        //如果项目要求认证，并且当前模块需要认证，则进行权限认证
        if( Config::get('rbac.user_auth_on') ){
			$_module = array();
			$_action = array();
            if("" != Config::get('rbac.require_auth_module')) {
                //需要认证的模块
                $_module['yes'] = explode(',',strtoupper(Config::get('rbac.require_auth_module')));
            }else {
                //无需认证的模块
                $_module['no'] = explode(',',strtoupper(Config::get('rbac.not_auth_module')));
            }
            //检查当前控制器是否需要认证
            if((!empty($_module['no']) && !in_array(strtoupper(Request::instance()->controller()),$_module['no'])) || 
            	(!empty($_module['yes']) && in_array(strtoupper(Request::instance()->controller()),$_module['yes']))) {

                
				if("" != Config::get('rbac.require_auth_action')) {
					//需要认证的操作
					$_action['yes'] = explode(',',strtoupper(Config::get('rbac.require_auth_action')));
				}else {
					//无需认证的操作
					$_action['no'] = explode(',',strtoupper(Config::get('rbac.not_auth_action')));
				}

				//检查当前操作是否需要认证
				if((!empty($_action['no']) && !in_array(strtoupper(Request::instance()->action()),$_action['no'])) || 
					(!empty($_action['yes']) && in_array(strtoupper(Request::instance()->action()),$_action['yes']))) {
					return true;
				}else {
					return false;
				}
            }else {
                return false;
            }
        }
        return false;
    }

	// 登录检查
	public static function checkLogin() {
        //检查当前操作是否需要认证
        if(self::checkAccess()) {
            //检查认证识别号
            if(!Session::has(Config::get('rbac.user_auth_key'))) {
                if(Config::get('rbac.guest_auth_on')) {
                    // 开启游客授权访问
                    if(Session::has('_access_list'))
                        // 保存游客权限
                        self::saveAccessList(Config::get('rbac.guest_auth_id'));
                }else{
                    // 禁止游客访问跳转到认证网关
                    redirect(Config::get('rbac.user_auth_gateway'));
                }
            }
        }
        return true;
	}

    //权限认证的过滤器方法
    public static function AccessDecision($appName) {
        //检查是否需要认证
        if(self::checkAccess()) {
            //存在认证识别号，则进行进一步的访问决策
            $accessGuid   =   md5($appName.Request::instance()->controller().Request::instance()->action());

            if(!Session::has(Config::get('rbac.admin_auth_key'))) {
                if(Config::get('rbac.user_auth_type')==2) {
                    //加强验证和即时验证模式 更加安全 后台权限修改可以即时生效
                    //通过数据库进行访问检查
                    $accessList = self::getAccessList(Session::get(Config::get('rbac.user_auth_key')));
                }else {
                    // 如果是管理员或者当前操作已经认证过，无需再次认证
                    if( Session::get($accessGuid)) {
                        return true;
                    }
                    //登录验证模式，比较登录后保存的权限访问列表
                    $accessList = Session::get('_access_list');
                }
                //判断是否为组件化模式，如果是，验证其全模块名
                if(!isset($accessList[strtoupper($appName)][strtoupper(Request::instance()->controller())][strtoupper(Request::instance()->action())])) {
                    Session::set($accessGuid,false);
                    return false;
                }
                else {
                    Session::set($accessGuid,true);
                }
            }else{
                //管理员无需认证
				return true;
			}
        }
        return true;
    }

    /**
     +----------------------------------------------------------
     * 取得当前认证号的所有权限列表
     +----------------------------------------------------------
     * @param integer $authId 用户ID
     +----------------------------------------------------------
     * @access public
     +----------------------------------------------------------
     */
    public static function getAccessList($authId) {
        // Db方式权限数据
        $table  = array(
        	'role'   => Config::get('rbac.rbac_role_table'),
        	'user'	 => Config::get('rbac.rbac_user_table'),
        	'access' => Config::get('rbac.rbac_access_table'),
        	'node'	 => Config::get('rbac.rbac_node_table')
        );
        $sql = "select node.id,node.name from ".
                $table['role']." as role,".
                $table['user']." as user,".
                $table['access']." as access ,".
                $table['node']." as node ".
                "WHERE ".
                "user.user_id='{$authId}' " .
                "and user.role_id=role.id " .
                "and ( access.role_id=role.id or (access.role_id=role.pid and role.pid!=0 ) ) " .
                "and role.status=1 " .
                "and access.node_id=node.id " .
                "and node.level=1 " .
                "and node.status=1";
        $apps   = Db::query($sql);
        $access = array();
        foreach($apps as $key=>$app) {
            $appId	 = $app['id'];
            $appName = $app['name'];
            // 读取项目的模块权限
            $access[strtoupper($appName)] = array();
            $sql = "select node.id,node.name from ".
                    $table['role']." as role,".
                    $table['user']." as user,".
                    $table['access']." as access ,".
                    $table['node']." as node ".
                    "WHERE " .
                    "user.user_id='{$authId}'  " .
                    "and user.role_id=role.id  " .
                    "and ( access.role_id=role.id  or (access.role_id=role.pid and role.pid!=0 ) )  " .
                    "and role.status=1  " .
                    "and access.node_id=node.id  " .
                    "and node.level=2  " .
                    "and node.pid={$appId}  " .
                    "and node.status=1";
            $modules = Db::query($sql);
            // 判断是否存在公共模块的权限
            $publicAction   = array();
            foreach($modules as $key=>$module) {
                $moduleId   = $module['id'];
                $moduleName = $module['name'];
                if('PUBLIC'== strtoupper($moduleName)) {
                $sql    =   "select node.id,node.name from ".
                    $table['role']." as role,".
                    $table['user']." as user,".
                    $table['access']." as access ,".
                    $table['node']." as node ".
                    "where user.user_id='{$authId}' " .
                    "and user.role_id=role.id " .
                    "and ( access.role_id=role.id  or (access.role_id=role.pid and role.pid!=0 ) ) " . 
                    "and role.status=1 " .
                    "and access.node_id=node.id " .
                    "and node.level=3 " .
                    "and node.pid={$moduleId} " .
                    "and node.status=1";
                    $rs = Db::query($sql);
                    foreach ($rs as $a){
                        $publicAction[$a['name']] = $a['id'];
                    }
                    unset($modules[$key]);
                    break;
                }
            }
            // 依次读取模块的操作权限
            foreach($modules as $key=>$module) {
                $moduleId	= $module['id'];
                $moduleName = $module['name'];
                $sql    =   "select node.id,node.name from ".
                    $table['role']." as role,".
                    $table['user']." as user,".
                    $table['access']." as access ,".
                    $table['node']." as node ".
                    "where user.user_id='{$authId}' and user.role_id=role.id and ( access.role_id=role.id  or (access.role_id=role.pid and role.pid!=0 ) ) and role.status=1 and access.node_id=node.id and node.level=3 and node.pid={$moduleId} and node.status=1";
                $rs = Db::query($sql);
                $action = array();
                foreach ($rs as $a){
                    $action[$a['name']] = $a['id'];
                }
                // 和公共模块的操作权限合并
                $action += $publicAction;
                $access[strtoupper($appName)][strtoupper($moduleName)]   =  array_change_key_case($action,CASE_UPPER);
            }
        }
        return $access;
    }

	// 读取模块所属的记录访问权限
	public static function getModuleAccessList($authId,$module) {
        // Db方式
        $table  = array('role'=>Config::get('rbac.rbac_role_table'),'user'=>Config::get('rbac.rbac_user_table'),'access'=>Config::get('rbac.rbac_access_table'));
        $sql    =   "select access.node_id from ".
                    $table['role']." as role,".
                    $table['user']." as user,".
                    $table['access']." as access ".
                    "where user.user_id='{$authId}' and user.role_id=role.id and ( access.role_id=role.id  or (access.role_id=role.pid and role.pid!=0 ) ) and role.status=1 and  access.module='{$module}' and access.status=1";
        $rs 	=   Db::query($sql);
        $access	=	array();
        foreach ($rs as $node){
            $access[]	=	$node['node_id'];
        }
		return $access;
	}
}
/**
 +------------------------------------------------------------------------------
 * 基于角色的数据库方式验证类
 +------------------------------------------------------------------------------
 */
// 配置文件增加设置
// user_auth_on 是否需要认证
// user_auth_type 认证类型
// user_auth_key 认证识别号
// require_auth_module  需要认证模块
// not_auth_module 无需认证模块
// user_auth_gateway 认证网关
// rbac_db_dsn  数据库连接DSN
// rbac_role_table 角色表名称
// rbac_user_table 用户表名称
// rbac_access_table 权限表名称
// rbac_node_table 节点表名称
/*
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS `think_access` (
  `role_id` smallint(6) unsigned NOT NULL,
  `node_id` smallint(6) unsigned NOT NULL,
  `level` tinyint(1) NOT NULL,
  `module` varchar(50) DEFAULT NULL,
  KEY `groupId` (`role_id`),
  KEY `nodeId` (`node_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `think_node` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `title` varchar(50) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '0',
  `remark` varchar(255) DEFAULT NULL,
  `sort` smallint(6) unsigned DEFAULT NULL,
  `pid` smallint(6) unsigned NOT NULL,
  `level` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `level` (`level`),
  KEY `pid` (`pid`),
  KEY `status` (`status`),
  KEY `name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `think_role` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `pid` smallint(6) DEFAULT NULL,
  `status` tinyint(1) unsigned DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`),
  KEY `status` (`status`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 ;

CREATE TABLE IF NOT EXISTS `think_role_user` (
  `role_id` mediumint(9) unsigned DEFAULT NULL,
  `user_id` char(32) DEFAULT NULL,
  KEY `group_id` (`role_id`),
  KEY `user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
*/