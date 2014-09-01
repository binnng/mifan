<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Topic
 *
 * 话题类
 * 提供针对话题的增删改查操作
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
//require APPPATH.'/libraries/REST_Controller.php';

class Topic extends MF_Controller
{
		
	public function __construct(){
		parent::__construct();
		$this->load->helper('email');
		$this->load->model('user_model');
	}
	
	/**
	 * 查找用户资料
	 * 请求参数
	 * 					必选		参数范围			说明
	 * user_id 		    true 	int				用户ID
	 * 返回数据	json
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
	
}