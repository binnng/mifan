<?php defined('BASEPATH') or exit('No direct script access allowed');

/**
 * Acl
 *
 * 权限控制，通过配置，实现某些页面需要登录，或者管理员等不同权限才能操作
 *
 * @package        	CodeIgniter
 * @subpackage    	Libraries
 * @category    	Libraries
 * @author        	xie.hj
 * @license         http://philsturgeon.co.uk/code/dbad-license
 * @link			http://www.mifan.us
 * @version         0.0.1
 */
class Acl {
    
	private $CI;
	
	public function __construct(){
		$this->CI = & get_instance();
	}

	public function filter(){
		
	}
}
