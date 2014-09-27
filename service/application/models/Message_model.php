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
	
	public function get_message($userid,$mtype,$data = array()){
		$arrMessage = $this->findAll('message',array(
			'touserid'	=>	$userid,
			'mtype'		=>	$mtype,
		),'messageid,topicid,userid','messageid desc');
		
		if(!$arrMessage){
			return array('904002','无新消息');
		}
		
		return array('100000',$arrMessage);
	}
	
	public function batch_sendmsg($userid,$data = array(),$mtype = 'ask'){
		//向自己关注的人发消息
		$this->send_msg_to_all_follow($userid,$data,$mtype);
		//向关注自己的人发消息
		$result = $this->send_msg_to_all_followed($userid,$data,$mtype);
		
		return $result;
	}
	
	public function send_msg_to_all_follow($userid,$data = array(),$mtype = 'ask'){
		$arrFollow = $this->user_model->_get_follow_users_by_id($userid);
		
		$i = 0;
		foreach ($arrFollow as $key => $item) {
			$arrMsg[$i]['userid'] =	$userid;
			$arrMsg[$i]['touserid'] = $item['userid_follow'];
			$arrMsg[$i]['content'] = addslashes(trim($content));
			$arrMsg[$i]['addtime'] = time();
			$arrMsg[$i]['topicid'] = $data['topicid'];
			$arrMsg[$i]['mtype'] = $mtype;
			$i++;
		}
		
		$result = $this->db->insert_batch('message',$arrMsg);
		
		log_message('debug', $this->db->last_query());
		
		return $result;
	}
	
	public function send_msg_to_all_followed($userid,$data = array(),$mtype = 'ask'){
		$arrFollowed = $this->user_model->_get_followed_users_by_id($userid);
		
		$i = 0;
		foreach ($arrFollowed as $key => $item) {
			$arrMsg[$i]['userid'] =	$userid;
			$arrMsg[$i]['touserid'] = $item['userid'];
			$arrMsg[$i]['content'] = addslashes(trim($content));
			$arrMsg[$i]['addtime'] = time();
			$arrMsg[$i]['topicid'] = $data['topicid'];
			$arrMsg[$i]['mtype'] = $mtype;
			$i++;
		}
		
		$result = $this->db->insert_batch('message',$arrMsg);
		
		log_message('debug', $this->db->last_query());
		
		return $result;
	}
	
	public function sendmsg($userid,$touserid,$data = array(),$mtype = 'answer'){
		
		$userid = intval($userid);
		
		$touserid = intval($touserid);
		
		$content = addslashes(trim($data['content']));
		
		if($touserid){
			$messageid = $this->create('message',array(
				'userid'	=> $userid,
				'touserid'	=> $touserid,
				'content'	=> $data['content'],				
				'topicid' 	=> $data['topicid'],
				'mtype' 	=> $mtype,
				'addtime'	=> time(),
			));
		}else{
			return array('904001','投递失败，米大叔不知道您消息的目的地.');
		}
		
		return array('100000',$messageid);
	}
	
	public function msg_count($userid,$data = array()){
		$msg_count = $this->findCount('message',array(
			'touserid'	=>	$userid,
			'isread'	=>	0
		));
		
		return array('100000',$msg_count);
	}
	
	
	function _get_message_by_id($userid){
		return $this->find('message',array(
			'touserid'	=>	$userid
		));
	}
}

/* End of file Feed_model.php */
/* Location: ./system/application/models/Feed_model.php */