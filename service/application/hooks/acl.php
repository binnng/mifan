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
 * @license         
 * @link			http://www.mifan.us
 * @version         0.0.1
 */
class Acl{
    
	private $ci_obj;
	private $directory;	//目录
	private $controller;	//控制器名
	private $function;		//方法名
	
	public function __construct(){
		$this->ci_obj = & get_instance();
		$this->ci_obj->load->config('acl');
		$this->ci_obj->load->model('user_model');
	}
	
	
	public function filter(){
				
		if(!$this->ci_obj->config->item('acl_auth_on')){
			return true;
		}
		/*
		//过滤目录
		$this->directory = substr($this->ci_obj->router->fetch_directory(),0,-1);
		if(in_array($this->directory,$this->ci_obj->config->item('acl_notauth_dirc'))){
			return true;
		}
		
		//过滤controller
		$this->controller = $this->directory.'/'.$this->ci_obj->router->fetch_class();
		if(in_array($this->directory,$this->ci_obj->config->item('acl_notauth_dirc'))){
			return true;
		}
		
		//过滤方法
		$this->function = $this->controller.'/'.$this->ci_obj->router->fetch_method();
		if(in_array($this->function,$this->ci_obj->config->item('acl_notauth_dirc'))){
			return true;
		}
		*/
		
		if($this->ci_obj->config->item('acl_auth_type') == 2){
			$data['accesstoken'] = $this->ci_obj->get('access_token');
			$data['userid'] = $this->ci_obj->get('userid');
		
			list($ret,$result) = $this->ci_obj->user_model->check_access_token($data['accesstoken']);
			if($ret != '100000'){
				$message = array( 'ret' => $ret, 'msg' => $result);
	            $this->ci_obj->response($message, 200); 
			}
			
			if($result['userid'] !=$data['userid']){
				$message = array( 'ret' => '104001', 'msg' => '不要乱来哟.');
	            $this->ci_obj->response($message, 200); 
			}
		}
				
		return TRUE;
	}
}
