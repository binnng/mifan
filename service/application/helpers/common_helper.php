<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * 扩展公共函数
 * Codeigniter 公共函数不能扩展，通过helper输助实现
 * 将此helper配置到autoload.php中自动加载，或者在需要使用这些函数时，手动加载
 * @author xie.hj
 */
 
//-----------------------------------------------------------------------------

/**
 * 获取IP
 * @access public
 * @return ip address
 */
if(!function_exists('get_ip')){
	function get_ip(){
		if(getenv('HTTP_CLIENT_IP') && strcasecmp(getenv('HTTP_CLIENT_IP'), 'unknown')){
			$PHP_IP = getenv('HTTP_CLIENT_IP');
		}else if(getenv('HTTP_X_FORWARDED_FOR') && strcasecmp(getenv('HTTP_X_FORWARDED_FOR'), 'unknown')){
			$PHP_IP = getenv('HTTP_X_FORWARDED_FOR');
		}else if(getenv('REMOTE_ADDR') && strcasecmp(getenv('REMOTE_ADDR'), 'unknown')){
			$PHP_IP = getenv('REMOTE_ADDR');
		}else if(isset($_SERVER['REMOTE_ADDR']) && $_SERVER['REMOTE_ADDR'] && strcasecmp($_SERVER['REMOTE_ADDR'], 'unknown')){
			$PHP_IP = $_SERVER['REMOTE_ADDR'];
		}
		preg_match("/[\d\.]{7,15}/", $PHP_IP, $ipmatches);
		$PHP_IP = $ipmatches[0] ? $ipmatches[0] : 'unknown';
		return $PHP_IP;
	}
}
