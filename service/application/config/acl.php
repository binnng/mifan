<?php defined('BASEPATH') OR exit('No direct script access allowed');

//游客权限映射
$config['acl']['visitor'] = array(
    '' => array('index'),//首页
    'music' => array('index', 'list'),
    'user' => array('index', 'login', 'register')
);

//管理员
$config['acl']['admin'] = array(

);
 
//-------------配置权限不够的提示信息及跳转url------------------//
$config['acl_info']['visitor'] = array(
    'info' => '需要登录以继续',
    'return_url' => 'user/login'
);
 
$config['acl_info']['more_role'] = array(
    'info' => '需要更高权限以继续',
    'return_url' => 'user/up'
);

/* End of file acl.php */
/* Location: ./system/application/config/acl.php */
