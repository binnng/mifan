<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
/**
 * User_model 用户类
 * 
 * 封装user相关操作的方法
 * 
 * @package		CodeIgniter
 * @subpackage	Model
 * @category	Controller
 * @author		xie.hj
 * @link		http://www.mifan.us
 * 
 */
class User_model extends Base_model {

	function __construct()
	{
		parent::__construct();
		log_message('DEBUG','User_model loaded.');
	}
	
	/**
	 * checkUserLogin
	 *
	 * 通过用户名密码登录,
	 * 首次登录自动分配一个access_token,access_token有效期为一周，一周后分配新的access_token
	 * 
	 * @param string $email      必选，用户邮箱
	 * @param string $password   必选，密码
	 * @param mix    $data       可选，其他信息
	 * 
	 * @return 	mix	成功返回当前用户信息，失败返回错误编码和提示
	 */
	public function checkUserLogin($email,$password,$data = null){
		log_message('DEBUG','Functin --> checkUserLogin');
		
		$strUser = $this->_get_user_by_mail($email);		
		if(!$strUser){
			return array('104002','Email不存在，你可能还没有注册！');
		}
		
		if(md5($strUser['salt'].$password)!==$strUser['pwd']){
			return array('104003','密码错误！');
		}
					
		$strData = $this->_get_user_info_by_id($strUser['userid']);
		if(!$strData){
			return array('104009','网络异常，请稍后再试!');
		}
		
		$strToken = $this->_get_user_access_token_by_id($strUser['userid']);
		if($strToken){//若存在access_token则返回该值
			$sessiondata['accesstoken'] = $strToken['accesstoken'];
			$sessiondata['invalidate'] = $strToken['invalidate'];
		}else{
			$sessiondata['accesstoken'] = $this->_GUID();
			$sessiondata['invalidate'] = time() + 7*24*60*60;
		}
		
		$sessiondata['userid'] = $strUser['userid'];
		$sessiondata['user'] = $strData;
		$sessiondata['lastguid'] = $this->_GUID();
		$sessiondata['lastdate'] = time();
		$this->session->set_userdata($sessiondata);
		
		$this->_update_login_info_by_id($strUser['userid']);
		
		if(@$this->config->item('enable_cache')){
			$this->_update_user_cache_by_access_token($sessiondata['accesstoken'],$sessiondata);
		}
		
		return array('100000',$sessiondata);
	}
	
	/**
	 * checkUserToken
	 *
	 * 通过access_token自动登录
	 * 成功则更新用户登录信息，但不更新access_token和invalidate,
	 * 失败反回错误信息
	 * 
	 * @param string $accesstoken	必选，access_token
	 * @param mix    $data         可选，其他信息
	 * 
	 * @return 	mix	成功返回当前用户信息，失败返回错误编码和提示
	 */
	public function checkUserToken($accesstoken ,$data = null){
		
		$strToken = $this->_get_user_access_token_by_token($accesstoken);
		
		if(!$strToken){
			return array('104005','Token不存在!');
		}
		
		if($strToken['invalidate'] < time()){
			return array('104005','授权的access_token已过期,请重新登录!');
		}
		
		$strData = $this->_get_user_info_by_id($strToken['userid']);
		if(!$strData){
			return array('104004','网络异常，请稍后再试!');
		}
		
		$sessiondata['userid'] = $strToken['userid'];
		$sessiondata['user'] = $strData;
		$sessiondata['lastguid'] = $this->_GUID();
		$sessiondata['lastdate'] = time();
		$sessiondata['accesstoken'] = $strToken['accesstoken'];
		$sessiondata['invalidate'] = $strToken['invalidate'];
		
		$this->session->set_userdata($sessiondata);
		
		return array('100000',$sessiondata);
		
	}
	
	/**
	 * get_users 获取一批用户
	 * 
	 * @param  int  $page 可选，page
	 * @param  int  $pagesize 必选，查找数量
	 * @param  mix	$condition 其他条件，
	 * 
	 * @return 	mix	成功返回当前用户信息，失败返回错误编码和提示
	 */
	public function get_users($pagesize ,$page = 1 ,$condition ,$sort = null){
		$start_limit =  !empty($page) ? ($page - 1) * $pagesize : 0;
		$sort = 'userid desc';
		
		$arrUser = $this->findAll('user_info',$condition,'*',$sort,$pagesize,$start_limit);
		
		return array('100000',$arrUser);
	}
	
	/**
	 * post_user 用户注册
	 * 
	 * @param	array 	$data	用户基础信息，必选
	 * 
	 * @return 	mix
	 */
	public function post_user($data){
		
		if($this->_get_user_by_mail($data['useremail'])){
			return array('104001','邮箱已存在!');
		}
		
		if($this->_get_user_info_by_name($data['username'])){
			return array('104001','用户名已存在!');
		}
		
		$salt = md5(rand());
		
		$this->db->trans_start();
		$userid = $this->create('user', array(
			'pwd'	=> md5($salt.$data['password']),
			'salt'	=> $salt,
			'email' 	=> $data['useremail'],
		));
		
		$this->create('user_info',array(
			'userid'	=> $userid,
			'fuserid'	=> $data['fuserid'],
			'username' 	=> $data['username'],
			'email'		=> $data['useremail'],
			'addtime'	=> time(),
			'uptime'	=> time(),
		));		
		$this->db->trans_complete();
		
		if ($this->db->trans_status() === FALSE){
		    return array('104009','注册失败');
		}
		
		$strData = $this->_get_user_info_by_id($userid);
		if(!$strData){
			return array('104004','注册成功，请登录!');
		}
		
		$sessiondata['userid'] = $userid;	
		$sessiondata['user'] = $strData;
		$sessiondata['lastguid'] = $this->_GUID();
		$sessiondata['lastdate'] = time();
		$sessiondata['accesstoken'] = $this->_GUID();
		$sessiondata['invalidate'] = time() + 7*24*60*60;
		$this->session->set_userdata($sessiondata);
		
		$this->_update_login_info_by_id($userid);
		
		return array('100000',$sessiondata);
	}
	
	/**
	 * check_access_token 验证access_token
	 * 
	 * @param string $access_token	必选，access_token
	 * @param array $data 可选，其他条件
	 */
	public function check_access_token($access_token,$data = null){
		
		if(empty($access_token)){
			return array('104001','access_token不能为空!');
		}
		
		$strToken = $this->_get_user_access_token_by_token($access_token);
		
		if(!$strToken){
			return array('104005','access_token不存在或已过期，请重新登录!');
		}
		
		return array('100000',$strToken);
	}
	
	/**
	 * get_follow_users_by_id 获取关注的用户
	 * 
	 * @param int $userid	必选，用户ID
	 */
	public function get_follow_users_by_id($userid){
		$arrUser = $this->_get_follow_users_by_id($userid);
		
		if(!$arrUser){
			return array('104008','您未注任何用户!');
		}
		
		return array('100000',$arrUser);
	}
	
	/**
	 * get_followed_users_by_id 获取粉丝
	 * 
	 * @param int $userid	必选，用户ID
	 */
	public function get_followed_users_by_id($userid){
		$arrUser = $this->_get_followed_users_by_id($userid);
		
		if(!$arrUser){
			return array('104008','您还没有粉丝，邀请好久一起来玩吧!');
		}
		
		return array('100000',$arrUser);
	}
	
	/**
	 * _get_follow_users_by_id 获取关注的用户
	 * 
	 * @param int $userid	必选，用户ID
	 */
	function _get_follow_users_by_id($userid){
		$arrFollow = $this->findAll('user_follow',array(
			'userid'	=>	$userid,
		),'userid_follow');
		
		return $arrFollow;
	}
	
	/**
	 * _get_followed_users_by_id 获取粉丝
	 * 
	 * @param int $userid	必选，用户ID
	 */
	function _get_followed_users_by_id($userid){
		$arrFollowed = $this->findAll('user_follow',array(
			'userid_follow'	=>	$userid,
		));
		
		return $arrFollowed;
	}
		
	/**
	 * _get_user_by_id 通过userid获取user信息
	 * 
	 * @param	int		$id		必选，用户id
	 * 
	 * @return  mix	成功返回user表信息，失败返回false
	 */
	function _get_user_by_id($id){
		return $this->find('user',array(
			'userid'		=>	$id
		));
	}
	
	/**
	 * _get_user_info_by_id 通过userid获取user_info信息
	 * 
	 * @param	int	$id	必选，用户id
	 * 
	 * @return 	array|false	成功返回user_info表信息，失败返回false
	 */
	function _get_user_info_by_id($id,$fields = null){
		$strUser = $this->find('user_info',array(
			'userid'	=>	$id
		),$fields);
		
		if(!$strUser){
			return FALSE;
		}
		
		if($strUser['face']){
			$strUser['face_120'] =  mfXimg($strUser['face'],'user',120,120,$strUser['path']);
			$strUser['face_60']  =  mfXimg($strUser['face'],'user',60,60,$strUser['path']);
			$strUser['face']	 =  mfXimg($strUser['face'],'user',0,0,$strUser['path']);
		}else{
			$strUser['face_120'] = 'http://mifan.us/public/images/user_large.jpg';
			$strUser['face_60']  = 'http://mifan.us/public/images/user_normal.jpg';
			$strUser['face']	 = 'http://mifan.us/public/images/user_normal.jpg';
		}
		
		return $strUser;
	}
		
	/**
	 * _get_user_by_mail 通过email获取user信息
	 * 
	 * @param	int	$email	必选，登录邮箱
	 * 
	 * @return 	array|false	成功返回user表信息，失败返回false
	 */
	function _get_user_by_mail($email){
		return $this->find('user',array(
			'email'		=>	$email
		));
	}
	
	/**
	 * _get_user_info_by_mail 通过email获取user_info信息
	 * 
	 * @param	int	$email	必选，登录邮箱
	 * 
	 * @return	array|false	成功返回user表信息，失败返回false
	 */
	function _get_user_info_by_mail($email){
		return $this->find('user',array(
			'email'		=>	$email
		));
	}
	
	/**
	 * _get_user_info_by_name 通过username获取user_info信息
	 * 
	 * @param	int $username	必选，登录邮箱
	 * @return 	array|false	成功返回user表信息，失败返回false
	 */
	function _get_user_info_by_name($username){
		return $this->find('user_info',array(
			'username'		=>	$username
		));
	}
	
	/**
	 * _get_user_access_token_by_id 
	 * 
	 * 通过userid获取user_access_token信息
	 * 
	 * @param	int	$id	必选，用户id
	 * 
	 * @return 	array|false	成功返回user_info表信息，失败返回false
	 */
	function _get_user_access_token_by_id($id){
		return $this->find('user_access_token',array(
			'userid'	=>	$id,
			'invalidate >'	=>	time(),
		));
	}
	
	/**
	 * _get_user_access_token_by_token 
	 * 
	 * 通过用户token获取user_access_token信息,支持缓存
	 * 
	 * @param	string	$accesstoken	必选，用户token
	 * 
	 * @return 	array|false	成功返回user_info表信息，失败返回false
	 */
	function _get_user_access_token_by_token($accesstoken){
		if(@$this->config->item('enable_cache')){
			$result =  $this->cache->get($accesstoken);
		}

		if(!$result){
			$result = $this->find('user_access_token',array(
				'accesstoken' => $accesstoken,
				'invalidate >'	=>	time(),
			));
		}
		
		return $result;
	}
	
	/**
	 * _update_login_info_by_id 更新用户登录信息，IP，最后一次登录时间等
	 * 
	 * @param	int	$userid	必选，用户id
	 * @return 	bool	成功返回true，失败返回false
	 */
	function _update_login_info_by_id($userid){
		//更新user_info
		$result = $this->update('user_info',  array(
			'ip'		=>	$this->session->userdata('ip_address'),
			'uptime'	=>	$this->session->userdata('lastdate'),
		),array(
			'userid'	=>	$userid,
		));	
		
		//更新access_token
		$data['userid'] = $userid;
		$data['accesstoken'] = $this->session->userdata('accesstoken');
		$data['ip'] = $this->session->userdata('ip_address');
		$data['user_agent'] = $this->session->userdata('user_agent');
		$data['last_activity'] = $this->session->userdata('last_activity');
		$data['lastdate'] = $this->session->userdata('lastdate');
		$data['lastguid'] = $this->session->userdata('lastguid');
		$data['invalidate'] = 	$this->session->userdata('invalidate');
		
		return $this->replace('user_access_token', $data ,array(
			'userid' => $userid,
		));
	}
	
	function _update_user_cache_by_access_token($access_token,$data = null){		
		return $this->cache->save($access_token, $this->session->userdata, $this->session->userdata('invalidate'));
	}
		
	function _GUID(){

	    if (function_exists('com_create_guid') === true){
	        return trim(com_create_guid(), '{}');
	    }else{
	        mt_srand((double)microtime()*10000);//optional for php 4.2.0 and up.
	        $charid = strtoupper(md5(uniqid(rand(), true)));
	        $hyphen = chr(45);// "-"
	        $uuid = substr($charid, 0, 8).$hyphen
	                .substr($charid, 8, 4).$hyphen
	                .substr($charid,12, 4).$hyphen
	                .substr($charid,16, 4).$hyphen
	                .substr($charid,20,12);
	        return $uuid;
	    }
    }
}

/* End of file user_model.php */
/* Location: ./system/application/models/user_model.php */