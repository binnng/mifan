<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
/**
 * Message_model 消息提醒
 * 
 * 封装message相关操作的方法
 * 
 * @package		CodeIgniter
 * @subpackage	Model
 * @category	Controller
 * @author		xie.hj
 * @link		http://www.mifan.us
 * 
 */
class Message_model extends Base_model {
	
	function __construct()
	{
		parent::__construct();
		$this->load->model('user_model');
	}
	
	public function batch_sendmsg($userid,$content = null){
		//向自己关注的人发消息
		$this->send_msg_to_all_follow($userid,$content);
		//向关注自己的人发消息
		$this->send_msg_to_all_followed($userid, $content);
	}
	
	public function send_msg_to_all_follow($userid,$content = null){
		$arrFollow = $this->user_model->_get_follow_users_by_id($userid);
		
		$i = 0;
		foreach ($arrFollow as $key => $item) {
			$arrMsg[$i]['userid'] =	$userid;
			$arrMsg[$i]['touserid'] = $item['userid_follow'];
			$arrMsg[$i]['content'] = $content;
			$arrmsg[$i]['addtime'] = time();
			$i++;
		}
		
		$result = $this->db->insert_batch('message',$arrMsg);
		
		log_message('debug', $this->db->last_query());
		
		return $result;
	}
	
	public function send_msg_to_all_followed($userid,$content = null){
		
	}
	
	public function sendmsg($userid,$touserid,$content = null){
		
		$userid = intval($userid);
		
		$touserid = intval($touserid);
		
		$content = addslashes(trim($content));
		
		if($touserid){
			$messageid = $this->create('message',array(
				'userid'		=> $userid,
				'touserid'		=> $touserid,
				'content'		=> $content,
				'addtime'			=> time(),
			));
		}else{
			$messageid = FALSE;
		}
		
		return $messageid;
	}
}

/* End of file Feed_model.php */
/* Location: ./system/application/models/Feed_model.php */