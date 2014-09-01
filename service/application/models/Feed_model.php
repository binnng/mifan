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
	
	function __construct()
	{
		parent::__construct();
	}
	
	public function add_ask_feed($data,$temp_data = null,$template = null){
		
		$result = $this->create('ask_feed', array(
				'userid'	=>	$data['userid'],
				'ftype'	=>	$data['ftype'],
				'askid'	=>	$data['askid'],
				'acid'	=>	$data['acid'],
				'template'	=>	$template,
				'data'	=>	isset($temp_data)?addslashes(serialize($temp_data)):'',//解析用unserialize(stripslashes($item['data']));
				'addtime'	=>	time()
			));	
		return $result;
	}
}

/* End of file Feed_model.php */
/* Location: ./system/application/models/Feed_model.php */