<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
/**
 * Feed_model 动态
 * 
 * 封装Feed相关操作的方法
 * 
 * @package		CodeIgniter
 * @subpackage	Model
 * @category	Controller
 * @author		xie.hj
 * @link		http://www.mifan.us
 * 
 */
class Feed_model extends Base_model {
	
	private $user_info_fields = 'userid,username,email,face,path';
	
	function __construct()
	{
		parent::__construct();
		log_message('debug', 'Feed_model loaded.');
		$this->load->model('message_model');
		$this->load->model('ask_model');
		$this->load->model('user_model');
	}
	
	public function get_answerme($userid,$data = array()){
		list($ret,$result) = $this->message_model->get_message($userid,'answer');
		if($ret != '100000'){
			 return array($ret,$result);
		}
		$i = 0;
		foreach ($result as $key => $item) {
			$arrFeed[$i]['feedid']	= $item['messageid'];
			$ask_comment = $this->ask_model->_get_ask_comment_by_id($item['topicid']);
			$arrFeed[$i]['ask_comment'] = $ask_comment;
			$arrFeed[$i]['ask_comment']['user'] = $this->user_model->_get_user_info_by_id($ask_comment['userid'],$this->user_info_fields);
			$arrFeed[$i]['ask'] = $this->ask_model->_get_ask_topic_by_id($ask_comment['askid']);
			$arrFeed[$i]['ask']['user'] = $this->user_model->_get_user_info_by_id($userid,$this->user_info_fields);
			$i++;
		}
		
		return array('100000',$arrFeed);
	}
	
	public function get_replyme($userid,$data = array()){
		list($ret,$result) = $this->message_model->get_message($userid,'comment');
		if($ret != '100000'){
			 return array($ret,$result);
		}
		$i = 0;
		foreach ($result as $key => $item) {
			$arrFeed[$i]['feedid']	= $item['messageid'];
			$ask_comment = $this->ask_model->_get_ask_comment_by_id($item['topicid']);
			$arrFeed[$i]['ask_comment'] = $ask_comment;
			$arrFeed[$i]['ask_comment']['user'] = $this->user_model->_get_user_info_by_id($ask_comment['userid'],$this->user_info_fields);
			$arrFeed[$i]['ask'] = $this->ask_model->_get_ask_topic_by_id($ask_comment['askid']);
			$arrFeed[$i]['ask']['user'] = $this->user_model->_get_user_info_by_id($userid,$this->user_info_fields);
			$i++;
		}
		
		return array('100000',$arrFeed);
	}

	public function get_loveme($userid,$data = array()){
		list($ret,$result) = $this->message_model->get_message($userid,'loveask');
		if($ret != '100000'){
			 return array($ret,$result);
		}
		$i = 0;
		foreach ($result as $key => $item) {
			$arrFeed[$i]['feedid']	= $item['messageid'];
			$arrFeed[$i]['ask'] = $this->ask_model->_get_ask_topic_by_id($item['topicid']);
			$arrFeed[$i]['ask']['user'] = $this->user_model->_get_user_info_by_id($item['userid'],$this->user_info_fields);
			$i++;
		}
		
		return array('100000',$arrFeed);
	}
	
	public function add_feed($data = array()){
		$feedid = $this->create('ask_feed', array(
			'userid'	=>	$data['userid'],
			'ftype'		=>	$data['ftype'],
			'askid'		=>	$data['askid'],
			'acid'		=>	$data['acid'],
			'template'	=>	isset($data['template'])?$data['template']:'',
			'data'	=>	isset($data['temp_data'])?addslashes(serialize($data['temp_data'])):'',
			'addtime'	=>	time()
		));
		
		return array('100000',$feedid);
	}
}

/* End of file Feed_model.php */
/* Location: ./system/application/models/Feed_model.php */