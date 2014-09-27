<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * SaeAuth
 *
 * <pre>
 * 检查用户登陆 并返回session信息 
 * 提供登录等方法
 * @package		CodeIgniter
 * @subpackage	Rest Server
 * @category	Controller
 * @author		xie.hj
 * @link		http://www.mifan.us
 * @response 响应码说明  资源编号+状态+编码
 * @response user资源编号为1，0000表示成功
 * @desc 响应编码ret		说明
 * 		 100000			登录成功
 * 		 104001			为空较验，用户名或密码为空 or userid和最后一次登录时间不能为空
 * 		 104002			邮箱不存在或用户不存在
 * 		 104003			密码错误
 * 		 104004			Token时间戳不对
 *		 104005			Token不存在或已过期  
 * 		 104006			
 * 		 104009			其他错误
 *</pre>
 * 
 */

//require_once APPPATH.'/libraries/REST_Controller.php';

class SaeAuth extends MF_Controller
{
	
	public function __construct(){
		parent::__construct();
		
		$this->load->model('user_model');
	}
	
	/**
	 * 
	 * 登录 OR 检查登录 
	 * 
	 * <pre>
	 * 请求参数
	 * 参数名称                         必选		参数范围		说明
	 * user_email   	false	string 		登录邮箱，以用户名/密码方式登录时必填
	 * user_password	false	string 		登录密码，以用户名/密码方式登录时必填
	 * access_token 	false	string 		access_token,以token方式登录时必填
	 * user_id      	false	int     	用户id,以token方式登录时必填
	 * user_lastdate	false	datetime	最后一次登录时间，以token方式登录时必填
	 * </pre>
	 * 
	 * @return	json
	 * 
	 */
	public function user_post(){
		
		$data['useremail'] 	= $this->post('user_email');
        $data['password'] 	= $this->post('user_password');
		
		$data['accesstoken'] = $this->post('access_token');
		
		if($this->post('user_email')){			
			$this->_check_login_by_email_pwd($data);
		}
		
		if($this->post('access_token')){
			$this->_check_login_by_token($data);
		}
		
		//请求中即没email,也没access_token
		 $message = array( 'ret' => 104009, 'msg' => '非法操作!');
         $this->response($message, 200); 
	}
	
	/**
	 * 
	 * 登出
	 * 
	 * 用户delete，表示清除access_token，将token失效时间挃为当前
	 * 
	 * <pre>
	 * 请求参数
	 * 参数名称 		必选             参数类型 	说明
	 * access_token	true     string               
	 * </pre>
	 * 
	 */
    public function user_delete(){
    	$data['accesstoken'] = $this->post('access_token');
    }
	
    
	function _check_login_by_email_pwd($data){
		
		if($data['useremail']=='' || $data['password']==''){
			 $message = array( 'ret' => 104001, 'msg' => '用户名和密码不能为空!');
             $this->response($message, 200); 
		}

		list($ret,$result) = $this->user_model->checkUserLogin($data['useremail'],$data['password'],$data);
		
		if($ret != '100000'){
			 $message = array( 'ret' => $ret, 'msg' => $result);
             $this->response($message, 200); 
		}
		
		$message = array('ret' => $ret,'msg' => 'ok','result' => $result);
		$this->response($message, 200); 
	}
	
	function _check_login_by_token($data){
		
		list($ret,$result) = $this->user_model->checkUserToken($data['accesstoken'],$data);
		
		if($ret != '100000'){
			 $message = array( 'ret' => $ret, 'msg' => $result);
             $this->response($message, 200); 
		}
		
		$message = array('ret' => $ret,'msg' => 'ok','result' => $result);
		$this->response($message, 200); 
	}
}