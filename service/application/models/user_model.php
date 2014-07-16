<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');
/**
 * User_model 用户类
 */
class User_model extends Base_model {

	function __construct()
	{
		parent::__construct();
	}
	
	/**
	 * @method checkUserLogin 通过用户名密码登录
	 * 登录成功则更新token
	 * 登录失败反回错误信息
	 * 					必选		参数范围		说明
	 * @param email		true	string		邮箱
	 * @param password	true	string		密码
	 * @param data		false	mix
	 * @return 			true	mix
	 */
	public function checkUserLogin($email,$password,$data = null){
		
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
				
		$sessiondata['user'] = $strData;
		$sessiondata['lastguid'] = $this->_GUID();
		$sessiondata['lastdate'] = time();
		$this->session->set_userdata($sessiondata);
		
		$this->_update_login_info_by_id($strUser['userid']);
		
		return array('100000',$this->session->all_userdata());
	}
	
	/**
	 * @method checkUserToken 验证Token是否有效
	 * 成功则更新token
	 * 失败反回错误信息
	 * 					必选		参数范围		说明
	 * @param email		true	string		邮箱
	 * @param password	true	string		密码
	 * @param data		false   mix
	 * @return 			true	mix
	 */
	public function checkUserToken($userid, $accesstoken ,$data = null){
		
		$strToken = $this->find('user_access_token',array(
			'userid' => $userid,
			'accesstoken' => $accesstoken,
		));
		if(!$strToken){
			return array('104005','Token不存在!');
		}
		
		if($strToken['lastdate'] != $data['lastdate']){
			return array('104009','Token时间戳不一致!');
		}
		
		if($strToken['invalidate'] < time()){
			return array('104005','授权的access_token已过期!');
		}
		
		$strData = $this->_get_user_info_by_id($strToken['userid']);
		if(!$strData){
			return array('104004','网络异常，请稍后再试!');
		}
					
		$sessiondata['user'] = $strData;
		$sessiondata['lastguid'] = $this->_GUID();
		$sessiondata['lastdate'] = time();
		$this->session->set_userdata($sessiondata);
		
		$this->_update_login_info_by_id($strToken['userid']);
		
		return array('100000',$this->session->all_userdata());
		
	}
	
	/**
	 * @method get_user_by_id 通过userid获取用户信息
	 * 
	 * 					必选		参数范围		说明
	 * @param userid	true	int			用户ID
	 * @return 			true	mix
	 */
	public function get_user_by_id($userid){
		$strData = $this->_get_user_info_by_id($userid);
		if(!$strData){
			return array('104002','用户不存在!');
		}
		
		return array('100000',$strData);
	}
	
	/**
	 * @method post_user 用户登录
	 * 
	 * 					必选		参数范围		说明
	 * @param value		true	string		验证内容
	 * @param key		false	string		验证类型，默认验证邮箱
	 * @return 			true	mix
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
					
		$sessiondata['user'] = $strData;
		$sessiondata['lastguid'] = $this->_GUID();
		$sessiondata['lastdate'] = time();
		$this->session->set_userdata($sessiondata);
		
		$this->_update_login_info_by_id($userid);
		
		return array('100000',$this->session->all_userdata());
	}
	
	/**
	 * @method _get_user_by_id 通过userid获取user信息
	 * 					必选		参数范围		说明
	 * @param id		true	int			用户id
	 * @return 			true	mix			成功返回user表信息，失败返回false
	 */
	function _get_user_by_id($id){
		return $this->find('user',array(
			'userid'		=>	$id
		));
	}
	
	/**
	 * @method _get_user_info_by_id 通过userid获取user_info信息
	 * 					必选		参数范围		说明
	 * @param id		true	int			用户id
	 * @return 			true	mix			成功返回user_info表信息，失败返回false
	 */
	function _get_user_info_by_id($id){
		return $this->find('user_info',array(
			'userid'		=>	$id
		));
	}
	
	/**
	 * @method _get_user_by_mail 通过email获取user信息
	 * 					必选		参数范围		说明
	 * @param $email	true	int			登录邮箱
	 * @return 			true	mix			成功返回user表信息，失败返回false
	 */
	function _get_user_by_mail($email){
		return $this->find('user',array(
			'email'		=>	$email
		));
	}
	
	/**
	 * @method _get_user_info_by_mail 通过email获取user_info信息
	 * 					必选		参数范围		说明
	 * @param $email	true	int			登录邮箱
	 * @return 			true	mix			成功返回user表信息，失败返回false
	 */
	function _get_user_info_by_mail($email){
		return $this->find('user',array(
			'email'		=>	$email
		));
	}
	
	/**
	 * @method _get_user_info_by_name 通过username获取user_info信息
	 * 					必选		参数范围		说明
	 * @param $email	true	int			登录邮箱
	 * @return 			true	mix			成功返回user表信息，失败返回false
	 */
	function _get_user_info_by_name($username){
		return $this->find('user_info',array(
			'username'		=>	$username
		));
	}
	
	/**
	 * @method _update_login_info_by_id 更新用户登录信息，IP，最后一次登录时间
	 * 					必选		参数范围		说明
	 * @param $userid	true	int			用户id
	 * @return 			true	bool		成功返回true，失败返回false
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
		$data['accesstoken'] = $this->session->userdata('session_id');		
		$data['ip'] = $this->session->userdata('ip_address');
		$data['user_agent'] = $this->session->userdata('user_agent');
		$data['last_activity'] = $this->session->userdata('last_activity');
		$data['lastdate'] = $this->session->userdata('lastdate');
		$data['lastguid'] = $this->session->userdata('lastguid');
		$data['invalidate'] = time() + 7*24*60*60;	//时间戳默认有效期是7天
		
		return $this->replace('user_access_token', $data ,array(
			'userid' => $userid,
		));
	}
		
	function _GUID(){

	    if (function_exists('com_create_guid') === true){
	        return trim(com_create_guid(), '{}');
	    }else{
	        mt_srand((double)microtime()*10000);//optional for php 4.2.0 and up.
	        $charid = strtoupper(md5(uniqid(rand(), true)));
	        $hyphen = chr(45);// "-"
	        $uuid = chr(123)// "{"
	                .substr($charid, 0, 8).$hyphen
	                .substr($charid, 8, 4).$hyphen
	                .substr($charid,12, 4).$hyphen
	                .substr($charid,16, 4).$hyphen
	                .substr($charid,20,12)
	                .chr(125);// "}"
	        return $uuid;
	    }
    }
}

/* End of file user_model.php */
/* Location: ./system/application/models/user_model.php */