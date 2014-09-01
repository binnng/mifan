<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Feedinfo
 *
 * <pre>
 * 用户动态
 * 
 * @package		CodeIgniter
 * @subpackage	Rest Server
 * @category	Controller
 * @author		xie.hj
 * @link		http://www.mifan.us
 * @response 响应码说明  资源编号+状态+编码
 * @response Feed资源编号为8，0000表示成功
 * @desc 响应编码ret		说明
 * 		 100000			成功
 * 		 804001			较验不通过，用户名或密码为空 、 userid和最后一次登录时间不能为空、邮箱不合法等
 * 		 804002			
 * 		 804003			
 * 		 804004			
 *		 804005			  
 * 		 804006			
 * 		 804007			
 * 		 804009			其他错误
 * </pre>
 */

class Feedinfo extends MF_Controller
{
		
	public function __construct(){
		parent::__construct();
		$this->load->model('user_model');
		$this->load->model('ask_model');
	}
	
	/**
	 * 获取动态
	 * 
	 * 用户动态，包括关注的人的提问和这个提问对应的回答和关注的人的回答和这个回答对应的问题
	 * 
	 * <pre>
	 * 请求参数
	 * 					必选		参数范围			说明
	 * noticeid 		true 	int				消息ID
	 * </pre>
	 * 
	 * @return	json
	 * 
	 */
	public function feeds_get(){
		//$this->hooks->call_hook('acl_auth');
    	
		$data['userid'] = $this->get_post('userid');
		
        if(!$data['userid']){
        	//$message = array( 'ret' => 804001, 'msg' => '请选登录!');
            //$this->response($message, 200);
            list($ret,$result) = $this->ask_model->get_hot_feeds();
        }else{
        	list($ret,$result) = $this->ask_model->get_comments($data['userid'],$data);
        }		
        
		if($ret != '100000'){
			 $message = array( 'ret' => $ret, 'msg' => $result);
             $this->response($message, 200); 
		}
		
		$message = array('ret' => $ret,'msg' => 'ok','result' => $result);
		$this->response($message, 200); 
		
    }
	
}