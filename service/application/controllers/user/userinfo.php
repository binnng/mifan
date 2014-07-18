<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Userinfo
 *
 * 用户类
 * 提供针对用户的增删改查操作
 * @package		CodeIgniter
 * @subpackage	Rest Server
 * @category	Controller
 * @author		xie.hj
 * @link		http://www.mifan.us
 * @response 响应码说明  资源编号+状态+编码
 * @response user资源编号为1，0000表示成功
 * @desc 响应编码ret		说明
 * 		 100000			登录成功
 * 		 104001			较验不通过，用户名或密码为空 、 userid和最后一次登录时间不能为空、邮箱不合法等
 * 		 104002			邮箱不存在或用户不存在
 * 		 104003			密码错误
 * 		 104004			Token时间戳不对
 *		 104005			Token不存在或已过期  
 * 		 104006			
 * 		 104007			邮箱或用户名被占用
 * 		 104009			其他错误
 */

// This can be removed if you use __autoload() in config.php OR use Modular Extensions
require APPPATH.'/libraries/REST_Controller.php';

class Userinfo extends REST_Controller
{
		
	public function __construct(){
		parent::__construct();
		$this->load->helper('email');
		$this->load->model('user_model');
	}
	
	/**
	 * 查找用户资料
	 * 
	 * <pre>
	 * 请求参数
	 * 参数名称			必选		参数范围			说明
	 * user_id			true	int				用户ID
	 * </pre>
	 * 
	 * @return	json	json格式返回用户信息
	 * 
	 */
	public function user_get(){
    	
		$userid = $this->get('id');
		
        if(!$userid){
        	$message = array( 'ret' => 104001, 'msg' => '请选择要查找的用户!');
            $this->response($message, 400); 
        }
		
        list($ret,$result) = $this->user_model->get_user_by_id($userid);
		if($ret != '100000'){
			 $message = array( 'ret' => $ret, 'msg' => $result);
             $this->response($message, 404); 
		}
		
		$message = array('ret' => $ret,'msg' => 'ok','result' => $result);
		$this->response($message, 200); 
		
    }
	
	/**
	 * 添加用户
	 * 
	 * <pre>
	 * 请求参数
	 * 参数名称			必选		参数范围			说明
	 * user_email		true	string			邮箱
	 * user_password	true	string			密码
	 * user_repwd		true	string			重复密码
	 * username			true	string[4,20]	用户名,，长度介于4~20个字节之间
	 * fuserid			false	datetime		邀请人ID
	 * </pre>
	 * 
	 * @return	json
	 * 
	 */
	public function user_post(){
		$data['useremail'] 	= $this->post('user_email');
		$data['password'] 	= $this->post('user_password');
		$data['repwd']   = $this->post('user_repwd');
		$data['username'] = $this->post('username');
		
		$data['fuserid'] = $this->post('fuserid');
		$data['authcode'] = strtoupper($this->post('authcode'));
		
		$this->_valid_input($data);
		
		list($ret,$result) = $this->user_model->post_user($data);
		
		if($ret != '100000'){
			 $message = array( 'ret' => $ret, 'msg' => $result);
             $this->response($message, 400); 
		}
		
		$message = array('ret' => $ret,'msg' => '注册成功','result' => $result);
		$this->response($message, 200); 
	}
	
	//更新用户
	public function user_put(){
		
	}
	
	//删除作户
	public function user_delete(){
		
	}
	
	//验证提交参数是否合法
    function _valid_input($data){
    	if($data['useremail']=='' || $data['password']=='' || $data['repwd']=='' || $data['username']==''){//在前端就用该较验，这里较验只为数据准确，不细分
			$message = array( 'ret' => 104001, 'msg' => '所有必选项都不能为空!');
            $this->response($message, 400); 		
		}		
		if(valid_email($data['useremail']) == false){
			$message = array( 'ret' => 104001, 'msg' => '邮箱格式错误!');
            $this->response($message, 400); 
		}		
		if($data['password'] != $data['repwd'] ){
			$message = array( 'ret' => 104001, 'msg' => '两次输入密码不一致!');
            $this->response($message, 400); 
		}
		if(strlen($data['username']) < 4 || strlen($data['username']) > 20){
			$message = array( 'ret' => 104001, 'msg' => '姓名长度必须在4和20之间!');
            $this->response($message, 400);
		}
		
		return TRUE;
    }
	
}