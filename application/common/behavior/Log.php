<?php
namespace app\common\behavior;
use think\Db;

/**
 * Created by PhpStorm.
 * User: v_ywwyang
 * Date: 2018/5/8
 * Time: 17:44
 */
class Log
{
    public function appLog(){
        Db::table('log')->insert(['createtime'=>time()]);
        echo 'hello word! 123123';die;
    }

    public function appUserLog(){
        Db::table('log')->insert(['createtime'=>time()]);
        echo 'hello word! 123123';die;
    }
}