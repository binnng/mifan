<?php defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Askinfo
 *
 * <pre>
 * 问题类
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
 * 		 204001			较验不通过，用户名或密码为空 、 userid和最后一次登录时间不能为空、邮箱不合法等
 * 		 204002			邮箱不存在或用户不存在
 * 		 204003			密码错误
 * 		 204004			Token时间戳不对
 *		 204005			Token不存在或已过期  
 * 		 204006			
 * 		 204007			邮箱或用户名被占用
 * 		 204009			其他错误
 * </pre>
 */

class Askinfo extends MF_Controller
{		
	public function __construct(){
		parent::__construct();
		$this->load->model('ask_model');
	}
	
	/**
	 * 查找单一问题
	 * 
	 * <pre>
	 * 请求参数
	 * 参数名称			必选		参数范围			说明
	 * id				true	int				问题ID
	 * </pre>
	 * 
	 * @return	json	json格式返回用户信息
	 * 
	 */
	public function ask_get(){
		
		$askid = $this->get('askid');
		
        if(!$askid){
        	$message = array( 'ret' => 204001, 'msg' => '请选择要查看的问题!');
            $this->response($message, 200); 
        }
		
        list($ret,$result) = $this->ask_model->get_source_by_id('_get_ask_topic_by_id',$askid);
		if($ret != '100000'){
			 $message = array( 'ret' => $ret, 'msg' => $result);
             $this->response($message, 200); 
		}
		
		$message = array('ret' => $ret,'msg' => 'ok','result' => $result);
		$this->response($message, 200); 
		
    }
	/**
	 * 查找问题例表，支持分页
	 * 
	 * <pre>
	 * 请求参数
	 * 参数名称			必选		参数范围			说明
	 * userid			false	int				用户ID
	 * page				false	int				分页ID
	 * type				true	int				获取类型，0是获取最新问题，1是获取关注者问题
	 * </pre>
	 * 
	 * @return	json	json格式返回用户信息
	 * 
	 */
	public function asks_get(){
		$data['userid'] = $this->get('userid');
		$data['page'] = $this->get('page');
		$data['type'] = $this->get('type');
		
		list($ret,$result) = $this->ask_model->get_asks($data['type'],$data);		
		if($ret != '100000'){
			 $message = array( 'ret' => $ret, 'msg' => $result);
             $this->response($message, 200); 
		}
		
		$message = array('ret' => $ret,'msg' => 'ok','result' => $result);
		$this->response($message, 200); 
	}
	
	/**
	 * 添加话题
	 * 
	 * <pre>
	 * 请求参数
	 * 参数名称			必选		参数范围			说明
	 * userid			true	int				用户ID
	 * content			true	string			问题内容
	 * isopen			true	int				是否公开
	 * </pre>
	 * 
	 * @return	json
	 * 
	 */
	public function ask_post(){		
		$this->hooks->call_hook('acl_auth');
		
		$data['userid'] = $this->get_post('userid');
		$data['content'] = $this->post('content');
		$data['isopen'] = $this->post('isopen');
		
		$validates = array(
			'rules'		=>	array(
								'useremail'	=>	array(
									'content'	=>	$data['content'],
									'required'	=>	TRUE,
								)
							),
			'msg'	=>	array(
								'useremail'	=>	array(
									'required'	=>	'问题不能为空',
								),
							),
			'ret'	=>	'204001'
		);
		
		$this->_valid_input($validates, $data);
		
		
		list($ret,$result) = $this->ask_model->post_ask($data);
		if($ret != '100000'){
			 $message = array( 'ret' => $ret, 'msg' => $result);
             $this->response($message, 200); 
		}
		$message = array('ret' => $ret,'msg' => '添加成功','result' => $result);
		$this->response($message, 200); 
	}
	
	//更新话题
	public function ask_put(){
		$this->hooks->call_hook('acl_auth');

	}
	
	//删除作户
	public function ask_delete(){
		$this->hooks->call_hook('acl_auth');
		
	}
	
	/**
	 * 添加回答
	 * 
	 * <pre>
	 * 请求参数
	 * 参数名称			必选		参数范围			说明
	 * askid			true	int				问题ID
	 * content			true	string			回答内容
	 * </pre>
	 * 
	 * @return	json
	 * 
	 */
	public function answer_post(){
		$this->hooks->call_hook('acl_auth');
		
		$data['userid'] = $this->get_post('userid');
		$data['askid'] = $this->post('askid');
		$data['content'] = $this->post('content');
		
		$validates = array(
			'rules'		=>	array(
								'useremail'	=>	array(
									'content'	=>	$data['content'],
									'required'	=>	TRUE,
								)
							),
			'msg'	=>	array(
								'useremail'	=>	array(
									'required'	=>	'回答内容不能为空',
								),
							),
			'ret'	=>	'204001'
		);
		
		$this->_valid_input($validates, $data);
		
		list($ret,$result) = $this->ask_model->post_answer($data);
		if($ret != '100000'){
			 $message = array( 'ret' => $ret, 'msg' => $result);
             $this->response($message, 200); 
		}
		$message = array('ret' => $ret,'msg' => '添加回答成功','result' => $result);
		$this->response($message, 200); 
	}
	
	/**
	 * 添加评论
	 * 
	 * <pre>
	 * 请求参数
	 * 参数名称			必选		参数范围			说明
	 * commentid		true	int				评论ID
	 * content			true	string			评论内容
	 * </pre>
	 * 
	 * @return	json
	 * 
	 */
	public function comment_post(){
		
	}
	
	/**
	 * 点赞
	 * 
	 * <pre>
	 * 请求参数
	 * 参数名称			必选		参数范围			说明
	 * commentid		true	int				评论ID
	 * </pre>
	 * 
	 * @return	json
	 * 
	 */
	public function digg_post(){
		$this->hooks->call_hook('acl_auth');
		
		$data['userid'] = $this->get_post('userid');
		$data['commentid'] = $this->post('commentid');
		
		list($ret,$result) = $this->ask_model->digg($data['commentid'],$data,0);
		if($ret != '100000'){
			 $message = array( 'ret' => $ret, 'msg' => $result);
             $this->response($message, 200); 
		}
		$message = array('ret' => $ret,'msg' => '感谢点赞','result' => $result);
		$this->response($message, 200); 
	}
	
	//验证提交参数是否合法
    function _valid_input($validates,$data){
		
		$this->load->library('form_validate',$validates);
		$message =  $this->form_validate->validate();
		if($message !== TRUE){
			$this->response($message, 200); 
		}
				
		return TRUE;
    }
	
}