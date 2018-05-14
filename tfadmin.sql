/*
Navicat MySQL Data Transfer

Source Server         : 127.0.0.1
Source Server Version : 50553
Source Host           : localhost:3306
Source Database       : tp5

Target Server Type    : MYSQL
Target Server Version : 50553
File Encoding         : 65001

Date: 2018-05-14 16:08:01
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for access
-- ----------------------------
DROP TABLE IF EXISTS `access`;
CREATE TABLE `access` (
  `role_id` int(11) unsigned NOT NULL COMMENT '角色表ID',
  `node_id` int(11) unsigned NOT NULL COMMENT '节点ID',
  `level` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `module` varchar(50) NOT NULL DEFAULT '',
  KEY `groupId` (`role_id`),
  KEY `nodeId` (`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色节点表';

-- ----------------------------
-- Records of access
-- ----------------------------
INSERT INTO `access` VALUES ('1', '200', '0', '');
INSERT INTO `access` VALUES ('1', '213', '0', '');
INSERT INTO `access` VALUES ('1', '214', '0', '');
INSERT INTO `access` VALUES ('1', '215', '0', '');
INSERT INTO `access` VALUES ('1', '216', '0', '');
INSERT INTO `access` VALUES ('1', '225', '0', '');
INSERT INTO `access` VALUES ('1', '226', '0', '');
INSERT INTO `access` VALUES ('1', '217', '0', '');
INSERT INTO `access` VALUES ('1', '218', '0', '');
INSERT INTO `access` VALUES ('1', '219', '0', '');
INSERT INTO `access` VALUES ('1', '220', '0', '');
INSERT INTO `access` VALUES ('1', '221', '0', '');
INSERT INTO `access` VALUES ('1', '222', '0', '');
INSERT INTO `access` VALUES ('1', '223', '0', '');
INSERT INTO `access` VALUES ('1', '224', '0', '');
INSERT INTO `access` VALUES ('1', '231', '0', '');
INSERT INTO `access` VALUES ('1', '232', '0', '');
INSERT INTO `access` VALUES ('1', '233', '0', '');
INSERT INTO `access` VALUES ('1', '234', '0', '');
INSERT INTO `access` VALUES ('2', '200', '0', '');
INSERT INTO `access` VALUES ('2', '217', '0', '');
INSERT INTO `access` VALUES ('2', '218', '0', '');
INSERT INTO `access` VALUES ('2', '219', '0', '');
INSERT INTO `access` VALUES ('2', '220', '0', '');
INSERT INTO `access` VALUES ('2', '221', '0', '');
INSERT INTO `access` VALUES ('2', '222', '0', '');
INSERT INTO `access` VALUES ('2', '223', '0', '');
INSERT INTO `access` VALUES ('2', '224', '0', '');
INSERT INTO `access` VALUES ('2', '235', '0', '');
INSERT INTO `access` VALUES ('2', '236', '0', '');

-- ----------------------------
-- Table structure for log
-- ----------------------------
DROP TABLE IF EXISTS `log`;
CREATE TABLE `log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createtime` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of log
-- ----------------------------
INSERT INTO `log` VALUES ('1', '1525943204');
INSERT INTO `log` VALUES ('2', '1525943211');
INSERT INTO `log` VALUES ('3', '1525943599');
INSERT INTO `log` VALUES ('4', '1525943612');
INSERT INTO `log` VALUES ('5', '1525943687');

-- ----------------------------
-- Table structure for menu
-- ----------------------------
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(40) NOT NULL DEFAULT '' COMMENT '菜单标题',
  `url` varchar(40) NOT NULL DEFAULT '' COMMENT '菜单地址',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '描述',
  `status` int(2) unsigned NOT NULL DEFAULT '0' COMMENT '状态  1 使用 0 禁用',
  `pid` int(2) unsigned NOT NULL COMMENT '父级ID',
  `sort` int(2) NOT NULL COMMENT '排序',
  `create_time` int(11) NOT NULL,
  `level` int(2) NOT NULL COMMENT '菜单分类  1 无跳转类别（一级菜单） 2 可跳转（二级菜单）',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=53 DEFAULT CHARSET=utf8 COMMENT='菜单表';

-- ----------------------------
-- Records of menu
-- ----------------------------
INSERT INTO `menu` VALUES ('29', '权限管理', '#', '权限管理', '1', '0', '1', '1524905926', '1');
INSERT INTO `menu` VALUES ('31', '菜单管理', 'admin/menu/index', '菜单管理', '1', '29', '1', '1524907261', '2');
INSERT INTO `menu` VALUES ('30', '节点管理', 'admin/node/index', '节点管理', '1', '29', '1', '1524906029', '2');
INSERT INTO `menu` VALUES ('40', '用户管理', 'admin/user/index', '用户管理', '1', '29', '99', '1525317067', '2');
INSERT INTO `menu` VALUES ('39', '角色管理', 'admin/role/index', '', '1', '29', '9', '1525242998', '2');
INSERT INTO `menu` VALUES ('52', '修改密码', 'admin/user/editPwd', '修改密码', '1', '51', '10', '1525936617', '2');
INSERT INTO `menu` VALUES ('51', '设置', '#', '一些基础设置', '1', '0', '10', '1525936452', '1');

-- ----------------------------
-- Table structure for node
-- ----------------------------
DROP TABLE IF EXISTS `node`;
CREATE TABLE `node` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL COMMENT '节点名',
  `title` varchar(50) DEFAULT NULL COMMENT '节点标题',
  `status` tinyint(1) DEFAULT '0' COMMENT '节点状态 0 禁用 1 使用',
  `remark` varchar(255) DEFAULT NULL COMMENT '描述',
  `sort` smallint(6) unsigned DEFAULT NULL COMMENT '排序',
  `pid` smallint(6) unsigned NOT NULL COMMENT '父节点',
  `level` tinyint(1) unsigned NOT NULL COMMENT '节点规定 1:表示应用（模块）；2:表示控制器；3：表示方法',
  PRIMARY KEY (`id`),
  KEY `level` (`level`),
  KEY `pid` (`pid`),
  KEY `status` (`status`),
  KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=237 DEFAULT CHARSET=utf8 COMMENT='节点表';

-- ----------------------------
-- Records of node
-- ----------------------------
INSERT INTO `node` VALUES ('200', 'admin', '后台模块', '1', '后台模块', '1000', '0', '1');
INSERT INTO `node` VALUES ('201', 'node', '节点控制器', '1', '节点控制器', '1', '200', '2');
INSERT INTO `node` VALUES ('202', 'index', '节点列表', '1', '节点列表页渲染', '1', '201', '3');
INSERT INTO `node` VALUES ('203', 'addNode', '节点添加', '1', '节点添加页渲染', '1', '201', '3');
INSERT INTO `node` VALUES ('204', 'editNode', '节点编辑', '1', '节点编辑页渲染', '1', '201', '3');
INSERT INTO `node` VALUES ('205', 'menu', '菜单控制器', '1', '菜单管理', '1', '200', '2');
INSERT INTO `node` VALUES ('206', 'index', '菜单列表', '1', '菜单列表页面渲染', '1', '205', '3');
INSERT INTO `node` VALUES ('207', 'addMenu', '添加菜单', '1', '添加菜单页面渲染', '1', '205', '3');
INSERT INTO `node` VALUES ('208', 'editMenu', '编辑菜单', '1', '编辑菜单页面渲染', '1', '205', '3');
INSERT INTO `node` VALUES ('209', 'delNode', '节点删除', '1', '', '1', '201', '3');
INSERT INTO `node` VALUES ('211', 'setStatus', '设置状态', '1', '节点的启用与禁用', '1', '201', '3');
INSERT INTO `node` VALUES ('212', 'getNode', '异步获取节点', '1', '异步 Ajax 获取父节点', '1', '201', '3');
INSERT INTO `node` VALUES ('213', 'role', '角色控制器', '1', '角色管理', '1', '200', '2');
INSERT INTO `node` VALUES ('214', 'index', '角色管理列表', '1', '角色管理列表', '1', '213', '3');
INSERT INTO `node` VALUES ('215', 'addRole', '角色添加', '1', '角色添加、渲染', '1', '213', '3');
INSERT INTO `node` VALUES ('216', 'editRole', '角色编辑', '1', '角色编辑、渲染', '1', '213', '3');
INSERT INTO `node` VALUES ('217', 'user', '用户管理', '1', '用户管理控制器', '1', '200', '2');
INSERT INTO `node` VALUES ('218', 'index', '用户列表', '1', '用户列表页渲染', '1', '217', '3');
INSERT INTO `node` VALUES ('219', 'addUser', '添加用户', '1', '添加用户', '1', '217', '3');
INSERT INTO `node` VALUES ('220', 'editUser', '编辑用户', '1', '编辑用户', '1', '217', '3');
INSERT INTO `node` VALUES ('221', 'delUser', '删除用户', '1', '删除用户', '1', '217', '3');
INSERT INTO `node` VALUES ('222', 'setStatus', '设置状态', '1', '状态设置', '1', '217', '3');
INSERT INTO `node` VALUES ('223', 'assignRole', '分配角色', '1', '分配角色界面渲染', '1', '217', '3');
INSERT INTO `node` VALUES ('224', 'addUserRole', '保存角色', '1', '分配角色保存', '1', '217', '3');
INSERT INTO `node` VALUES ('225', 'delRole', '删除角色', '1', '删除角色', '1', '213', '3');
INSERT INTO `node` VALUES ('226', 'setStatus', '设置状态', '1', '设置角色状态', '1', '213', '3');
INSERT INTO `node` VALUES ('227', 'getMenuList', '获取菜单列表', '1', '获取菜单列表', '1', '205', '3');
INSERT INTO `node` VALUES ('228', 'getParent', '异步获取父级菜单', '1', '异步 Ajax 获取父级菜单', '1', '205', '3');
INSERT INTO `node` VALUES ('229', 'delMenu', '删除菜单', '1', '删除菜单', '1', '205', '3');
INSERT INTO `node` VALUES ('230', 'setStatus', '设置状态', '1', '设置状态', '1', '205', '3');
INSERT INTO `node` VALUES ('231', 'Access', '权限管理', '1', '权限管里控制器', '1', '200', '2');
INSERT INTO `node` VALUES ('232', 'index', '列表页', '1', '列表页面渲染', '1', '231', '3');
INSERT INTO `node` VALUES ('233', 'addAccess', '添加权限', '1', '添加权限', '1', '231', '3');
INSERT INTO `node` VALUES ('234', 'ajaxGetAccessInfo', '权限检测', '1', '页面获取节点权限数据', '1', '231', '3');
INSERT INTO `node` VALUES ('235', 'editPwd', '修改密码', '1', '修改密码', '1', '217', '3');
INSERT INTO `node` VALUES ('236', 'oidPwd', '检测旧密码', '1', '检测旧密码输入是否等同', '1', '217', '3');

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL DEFAULT '' COMMENT '角色名称',
  `pid` smallint(6) unsigned NOT NULL DEFAULT '0' COMMENT '父角色对应ID',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '1' COMMENT '启用状态（同上）',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`),
  KEY `status` (`status`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='角色表';

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES ('1', '后台管理员', '0', '1', '改角色拥有除了节点以外的所有权限');
INSERT INTO `role` VALUES ('2', '编辑a', '0', '1', '');

-- ----------------------------
-- Table structure for role_user
-- ----------------------------
DROP TABLE IF EXISTS `role_user`;
CREATE TABLE `role_user` (
  `user_id` int(11) unsigned NOT NULL COMMENT '用户ID',
  `role_id` int(11) unsigned NOT NULL COMMENT '角色ID',
  KEY `group_id` (`role_id`),
  KEY `user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='用户角色表';

-- ----------------------------
-- Records of role_user
-- ----------------------------
INSERT INTO `role_user` VALUES ('10', '1');
INSERT INTO `role_user` VALUES ('11', '2');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uname` varchar(40) DEFAULT NULL COMMENT '用户名',
  `password` varchar(250) DEFAULT NULL COMMENT '密码',
  `sex` int(1) DEFAULT '1' COMMENT '性别  0  女 1  男  ',
  `phone` int(11) DEFAULT NULL COMMENT '电话',
  `emaii` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `real_name` varchar(100) DEFAULT NULL COMMENT '真实姓名',
  `last_login_time` int(11) DEFAULT NULL COMMENT '最后登入时间',
  `last_login_ip` varchar(40) DEFAULT NULL COMMENT '最后登入ip',
  `login_num` int(5) DEFAULT '0' COMMENT '登入次数',
  `status` int(2) DEFAULT '0' COMMENT '状态  0 禁止  1  启用',
  `createtime` int(11) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='用户表';

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', 'admin', '21232f297a57a5a743894a0e4a801fc3', '1', null, null, '超级管理员', '1526284526', '127.0.0.1', '52', '1', null);
INSERT INTO `user` VALUES ('10', 'admin1', '21232f297a57a5a743894a0e4a801fc3', '1', null, null, '二级管理员', '1525773217', '127.0.0.1', '2', '1', '1525663769');
INSERT INTO `user` VALUES ('11', 'edita', '21232f297a57a5a743894a0e4a801fc3', '1', null, null, '编辑a', '1525939548', '127.0.0.1', '4', '1', '1525934029');
INSERT INTO `user` VALUES ('12', 'editb', '21232f297a57a5a743894a0e4a801fc3', '1', null, null, '编辑b', '1525938453', '127.0.0.1', '0', '1', '1525938453');
