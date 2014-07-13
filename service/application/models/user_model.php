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
	 * 登录失败反回false(暂定这样)
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
		$this->session->set_userdata($sessiondata);
		
		$this->_update_login_info_by_id($strUser['userid']);
		
		return array('100000',$this->session->all_userdata());
	}
	
	/**
	 * @method checkUserLogin 通过用户名密码登录
	 * 登录成功则更新token
	 * 登录失败反回false(暂定这样)
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
			return array('104005','授权的access_token已过期!');
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
		$this->session->set_userdata($sessiondata);
		
		$this->_update_login_info_by_id($strToken['userid']);
		
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
	 * @method _get_user_by_mail 通过userid获取user信息
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
	 * @method _update_login_info_by_id 更新用户登录信息，IP，最后一次登录时间
	 * 					必选		参数范围		说明
	 * @param $userid	true	int			用户id
	 * @return 			true	bool		成功返回true，失败返回false
	 */
	function _update_login_info_by_id($userid){
		//更新user_info
		$result = $this->update('user_info',  array(
			'ip'		=>	$this->session->userdata('ip_address'),
			'uptime'	=>	time(),
		),array(
			'userid'	=>	$userid,
		));	
		
		//更新access_token
		$data['userid'] = $userid;
		$data['accesstoken'] = $this->session->userdata('session_id');		
		$data['ip'] = $this->session->userdata('ip_address');
		$data['user_agent'] = $this->session->userdata('user_agent');
		$data['last_activity'] = $this->session->userdata('last_activity');
		$data['lastdate'] = date('Y-m-d H:i:s');
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