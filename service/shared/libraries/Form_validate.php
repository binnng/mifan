<?php
/**
 * Form_Validate class
 *
 * 自动验证表单输入
 *
 * @author  	xie.hj
 * @license		http://mifan.us
 */
class Form_validate {
	private $ci_obj;
	
	private $valid_rules = array();
	private $valid_msg = array();
	private $valid_ret = '104001';
	
	/**
	 * Initialize Form validate Library
	 *
	 * @param	array	$props
	 * @return	void
	 */
	public function __construct($validates = array()){
		log_message('debug', 'Form validate Class Initialized');
		
		$this->ci_obj = & get_instance();
		
		if(!empty($validates)){
			$this->initialize($validates);
		}
	}
	
	/**
	 * initialize Form preferences
	 *
	 * @param	array
	 * @return	bool
	 */
	public function initialize($validates = array())
	{
		if(!empty($validates)){
			$this->valid_rules = $validates['rules'];
			$this->valid_msg = $validates['msg'];
			$this->valid_ret = $validates['ret'];
		}
	}
	
	public function validate($rules = null,$msg = null,$ret = null){
		if(empty($rules)){
			$rules = $this->valid_rules;
		}
		if(empty($msg)){
			$msg = $this->valid_msg;
		}
		if(empty($ret)){
			$ret = $this->valid_ret;
		}
		return $this->_validate($rules, $msg, $ret);
	}
	
	private function _validate($rules,$msg,$ret){
		
		foreach ($rules as $key => $item) {
			
			if(!isset($msg[$key])){
				$msg[$key] = $msg;
			}
			
			//&&$item['required']
			if(isset($item['required'])&&$item['required']){
				if($this->_is_empty($item['content'])){
					return array('ret' => $ret,'msg'=>$msg[$key]['required']);
				}
			}
			if(isset($item['email'])&&$item['email']){
				if(!$this->_is_email($item['content'])){
					return array('ret' => $ret,'msg'=>$msg[$key]['email']);
				}
			}
			if(isset($item['equalTo'])){
				if(!$this->_is_equal($item['content'],$rules[$item['equalTo']]['content'])){
					return array('ret' => $ret,'msg'=>$msg[$key]['equalTo']);
				}
			}
			if(isset($item['minlength'])){
				if($this->_length($item['content'],$item['minlength'],'min')){
					return array('ret' => $ret,'msg'=>$msg[$key]['minlength']);
				}
			}
			if(isset($item['maxlength'])){
				if($this->_length($item['content'],$item['maxlength'],'max')){
					return array('ret' => $ret,'msg'=>$msg[$key]['maxlength']);
				}
			}
		}
		
		return TRUE;
	}

	private function _length($content,$length,$key = 'min'){
		if($key == 'min'){
			return strlen($content) < $length;
		}else{
			return strlen($content) > $length;
		}
	}
	
	/**
	 * 判断是否相同
	 * 
	 * @param mix $content
	 * 
	 * @return true相同，false不相同
	 */
	private function _is_equal($content,$content1){
		return $content === $content1 ? TRUE:FALSE;
	}
	
	/**
	 * 判断是否为空
	 * 
	 * @param mix $content
	 * 
	 * @return true为空，false不为空
	 */
	private function _is_empty($content){
		
		return !(($content === 0 )||($content === '0')|| !empty($content));
	}
	
	/**
	 * 判断是否合法邮箱
	 * 
	 * @param mix $email
	 * 
	 * @return true是否法邮箱，false邮箱不合法
	 */
	private function _is_email($email){
		$this->ci_obj->load->helper('email');
		return valid_email($email);
	}
}

/* End of file Form_Validate.php */
