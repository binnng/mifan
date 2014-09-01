<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
/**
 * Ask_model 问答类
 * 
 * 封装ask相关操作的方法
 * 
 * @package		CodeIgniter
 * @subpackage	Model
 * @category	Controller
 * @author		xie.hj
 * @link		http://www.mifan.us
 * 
 */
class Ask_model extends Base_model {
	
	private $user_info_fields = 'userid,username,email,face,path';
	
	function __construct()
	{
		parent::__construct();
		$this->load->model('user_model');
		$this->load->model('feed_model');
		$this->load->model('message_model');
	}
	
	/**
	 * get_hot_feeds 获取热门动态
	 * 
	 * 在用户未登录的情况下，给用户推送热门动态
	 * 
	 */
	public function get_hot_feeds(){
		$arrFeeds = $this->_get_hot_feeds();
		
		if(empty($arrFeeds)){
			return array('204002','恭喜你进入蛮夷之地，全站无任何动态');
		}
		
		//3.获取问答对应的问题
		$i = 0;		
		foreach ($arrFeeds as $row ) {
			$arrFeed[$i]['feedid']	= $row->feedid;
			$strAsk = $this->_get_ask_topic_by_id($row->askid);
			$arrFeed[$i]['ask'] = $strAsk;
			$arrFeed[$i]['ask']['user'] = $this->user_model->_get_user_info_by_id($strAsk['userid'],$this->user_info_fields);
			$arrFeed[$i]['ask_comment'] = $this->_get_ask_comment_by_id($row->acid);
			$arrFeed[$i]['ask_comment']['user'] = $this->user_model->_get_user_info_by_id($row->userid,$this->user_info_fields);
			$i++;
		}
		
		return array('100000',$arrFeed);
	}
	
	/**
	 * get_comments 获取用户动态
	 * 
	 * 查找关注的人的提问和这个提问对应的回答和关注的人的回答和这个回答对应的问题
	 * 
	 * @param int $userid 必选，用户ID
	 * @param array $data 可选，其他条件
	 */
	public function get_comments($id,$data){
		//1.获取关注的人
		$arrFollow = $this->user_model->_get_follow_users_by_id($id);
		if(!$arrFollow){
			return array('204002','你还未关注任何人');
		}
		
		//2.根据条件，从feed表取出前100条动态，按ID倒序排例（获取关注的人的回答和这个回答对应的话题）	
		foreach ($arrFollow as $key => $item) {
			$condition[] = $item['userid_follow'];
		}
		$sort = 'feedid desc';
		$limit = 100;
		$offset = 0;
		$arrFeeds = $this->_get_feed_by_condition($condition,1,$sort,$limit,$offset);
		
		if(empty($arrFeeds)){//好友无动态，获取热门Feeds
			//return array('204002','你的朋友未回答任何问题');
			return $this->get_hot_feeds();
		}
		
		//3.获取问答对应的问题
		$i = 0;		
		foreach ($arrFeeds as $row ) {
			$arrFeed[$i]['feedid']	= $row->feedid;
			//$arrFeed[$i]['user'] = $this->user_model->_get_user_info_by_id($row->userid);
			$strAsk = $this->_get_ask_topic_by_id($row->askid);
			$arrFeed[$i]['ask'] = $strAsk;
			$arrFeed[$i]['ask']['user'] = $this->user_model->_get_user_info_by_id($strAsk['userid'],$this->user_info_fields);
			$arrFeed[$i]['ask_comment'] = $this->_get_ask_comment_by_id($row->acid);
			$arrFeed[$i]['ask_comment']['user'] = $this->user_model->_get_user_info_by_id($row->userid,$this->user_info_fields);
			$i++;
		}
		
		return array('100000',$arrFeed);
	}
		
	/**
	 * post_ask 发表问题
	 * 
	 * @param	array 	$data	必选，问题内容
	 * 
	 * @return 	mix
	 */
	public function post_ask($data){
		$data['addtime'] = time();
		$data['uptime'] = time();
		
		$result = $this->create('ask_topic',$data);
		
		if(!$result){
			 return array('204009','问题发表失败.');
		}
		
		$data['ftype'] = 0;
		$data['askid'] = $result;
		$data['acid'] = 0;
		
		if(!function_exists('pcntl_fork')){
			//添加动态
			/*$this->create('ask_feed', array(
				'userid'	=>	$data['userid'],
				'ftype'	=>	0,
				'askid'	=>	$result,
				'addtime'	=>	time()
			));*/
			$this->feed_model->add_ask_feed($data);
			
			//添加消息
			$this->message_model->send_msg_to_all_follow($data['userid'],$data['content']);
			
			log_message('error', '当前环境不支持fork.');
			return array('100000',$result);
		}
		
		$pid = pcntl_fork();
		if ($pid == -1) {
			log_message('error', '创建进程失败.'.time());
			//添加动态
			$this->feed_model->add_ask_feed($data);			
			//添加消息
			$this->message_model->send_msg_to_all_follow($data['userid'],$data['content']);
			
			return array('100000',$result);	
		} else if ($pid) {			
			pcntl_waitpid($pid,$status,WUNTRACED);//主进程很闲时，可以用这个方法，当关闭主线程子，回收子进程，但是主进程很忙，要关才的主线程也很多，这不是个好方法
			log_message('debug', '主线程执行完成,直接返回.');
		    return array('100000',$result);
		} else {//子进程
			log_message('debug', '子进程'.getmypid().'开始创建孙进程');
			$pid = pcntl_fork();
			if($pid == -1){
				log_message('debug', '创建孙子进程失败');
				$this->feed_model->add_ask_feed($data);
				exit(-1);
			}else if($pid == 0){				
				posix_setsid();//把子进程session设为当前会话头，防止主进程exit时把子进程杀死
				sleep(1);
				log_message('debug', '孙进程开始处理业务逻辑.');
				
				//添加动态
				$this->feed_model->add_ask_feed($data);
				
				//添加消息
				$this->message_model->send_msg_to_all_follow($data['userid'],$data['content']);
					
				log_message('debug', '孙进线程执行完成.'.time().'孙进程id'.posix_getpid());
				posix_kill(posix_getpid(),SIGTERM);
				//exit(0);
			}else{
				log_message('debug', '子进程直接退出'.posix_getpid());
				posix_kill(posix_getpid(),SIGTERM);
				//exit(0);
			}
			
		}
	}
	
	/**
	 * post_answer 添加回答
	 * 
	 * @param	array 	$data	必选，问题内容
	 * 
	 * @return 	mix
	 */
	public function post_answer($data){
		$data['addtime'] = time();
		
		$result = $this->create('ask_comment',$data);
		
		if(!$result){
			 return array('204009','问题发表失败.');
		}
		//添加动态
		$this->create('ask_feed', array(
			'userid'	=>	$data['userid'],
			'ftype'		=>	1,
			'askid'		=>	$data['askid'],
			'acid'		=>	$result,
			'addtime'	=>	time()
		));
		
		//更新评论信息
		$this->db->set('comment_cout', 'comment_cout+1', FALSE);
		$this->db->update('ask_topic',array(
			'pid'			=>	$result,
		),array(
			'askid'		=>	$data['askid']
		));
		
		return array('100000',$result);
	}
	
	/**
	 * digg_comment 赞
	 * 
	 * @param	int		$commentid	必选，评论ID
	 * @param	array 	$data	可选，其他信息
	 * @param	int		$type	可选,默认是赞评论
	 * 
	 * @return 	mix
	 */
	public function digg($commentid,$data = null,$type = 0){
		//1.判断是否已经赞过，若赞过，不允许重复点赞
		$ifdigg = $this->_if_digg($commentid,$data['userid'],$type);
		if($ifdigg){
			 return array('204003','赞一次就够啦.');
		}
		
		$data['type'] = $type;
		if($type == 0){
			$result = $this->_digg_comment($data);
			if(!$result){
				 return array('204009','系统异常，点赞失败.');
			}
			$digg_count = $this->_get_comment_digg_count_by_id($commentid);
		}
		
		return array('100000',$digg_count);
	}

	/**
	 * get_asks 获取用户问题动态
	 * 
	 * 查找问题
	 * 
	 * @param int $type 必选，查找类型，0是获取最新问题，1是获取发送给我的问题（关注我的人的问题和单独发送给我的问题）
	 * @param array $data 可选，其他条件
	 */
	public function get_asks($type = 1,$data = null){
		if($type == 1 && isset($data['userid'])){
			return $this->get_followed_asks($data['userid'],$data);
		}else{
			return $this->get_latest_asks($data);
		}	
		
	}
	
	public function get_followed_asks($userid,$data){
		//1.获取关注我的人
		$arrFollow = $this->user_model->_get_followed_users_by_id($userid);
		if(!$arrFollow){
			return array('204002','你还未被任何人关注.');
		}
		foreach ($arrFollow as $key => $item) {
			$arrUserid[] = $item['userid'];
		}
		
		$this->db->where_in('userid',$arrUserid);
		$this->db->or_where('foruser',$userid);
		$query = $this->db->get('ask_topic');		
		$arrAsks = $query->result_array();
		
		if(empty($arrAsks)){
			return array('204003','还没有人向你提问题.');
		}
		
		foreach( $arrAsks as $key=>$item ) :
			$arrAsks[$key]['user'] = $this->user_model->_get_user_info_by_id($item['userid'],$this->user_info_fields);
		endforeach;
		
		return array('100000',$arrAsks);
	}
	
	function _get_comment_digg_count_by_id($commentid){
		$comment = $this->find('ask_comment',array(
			$commentid	=>	$commentid,
		),'digg');
		
		return isset($comment['digg'])?$comment['digg']:0;
	}
	
	function _if_digg($id,$userid,$type){		
		return $this->findCount('ask_operate',array(
			'commentid'	=>	$id,
			'userid'	=>	$userid,
			'type'		=>	$type
		));
	}
	
	/**
	 * _digg 喜欢，赞回答或者喜欢问题
	 * 
	 * @param	int[0,1]	$type	必选，0为赞评论，2为喜欢问题
	 * @param	array 	$data	必选，其他信息
	 * 
	 * @return 	mix
	 */
	function _digg_comment($data){
		
		//更新评论信息
		$this->db->set('digg', 'digg+1', FALSE);
		$this->db->where('commentid',$data['commentid']);
		$result = $this->db->update('ask_comment');
		
		if($result){
			$this->_record_operate_log($data);
		}
		
		return $result;
	}
	
	function _record_operate_log($data){
		
		$data['uptime'] = time();
		
		return $this->create('ask_operate', $data);
		
	}
	
	/**
	 * _get_hot_feeds 获取热门动态
	 * 
	 */
	function _get_hot_feeds(){
		return $this->_get_feed_by_condition(null,1,'feedid dsec',100,0);
	}
	
	/**
	 * _get_feed_by_condition 根据条件查询指定数量的feed
	 * 
	 * @param int 	$ftype	必选，查询类型，0为提问，1为回答
	 * @param array $condition	必选，查询条件
	 * @param mix	$sort	可选，排序规则
	 * @param int	$limit	可选，查询数量
	 * @param int	$offset	可选，偏移量 
	 * 
	 * @return mix	
	 */
	function _get_feed_by_condition($condition = array(),$ftype = 1 ,$sort = null,$limit = null,$offset = 0){
		
		if(!empty($condition)){
			$this->db->where_in('userid',$condition);
		}
		
		if(!empty($condition)){
			$this->db->where('ftype',$ftype);
		}
		if(!empty($sort)){
			$this->db->order_by($sort);
		}
		
		if(!empty($limit)){
			$this->db->limit($limit,$offset);
		}
		
		$query = $this->db->get('ask_feed');
		print_r($this->db->last_query());
		$result = $query->result();
		
		
		return empty($result)?false:$result;
		
	}
	
	/**
	 * _get_ask_topic_by_id 通过askid获取ask_topic信息
	 * 
	 * @param	int	$askid	必选，问题id
	 * 
	 * @return 	array|false	成功返回user_topic表信息，失败返回false
	 */
	function _get_ask_topic_by_id($askid){
		return $this->find('ask_topic',array(
			'askid'	=>	$askid
		));
	}
	
	/**
	 * _get_ask_comment_by_id 通过commentid获取ask_comment信息
	 * 
	 * @param	int	$commentid	必选，问题id
	 * 
	 * @return 	array|false	成功返回user_comment表信息，失败返回false
	 */
	function _get_ask_comment_by_id($commentid){
		return $this->find('ask_comment',array(
			'commentid'	=>	$commentid
		));
	}
}

/* End of file Ask_model.php */
/* Location: ./system/application/models/Ask_model.php */