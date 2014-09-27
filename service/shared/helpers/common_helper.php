<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * 扩展公共函数
 * 
 * Codeigniter 公共函数不能扩展，通过helper输助实现
 * 将此helper配置到autoload.php中自动加载，或者在需要使用这些函数时，手动加载
 * 
 * @author xie.hj
 */
 
//-----------------------------------------------------------------------------
/**
 * 递归创建目录
 * 
 * @access public
 * @param string $path 目录路径
 * @return 裁剪后的图片URI
 */
function createFolders($path)  {    
	if (!file_exists($path)){  
		createFolders(dirname($path));
		mkdir($path, 0777);  
	}  
}

/**
 * 10位MD5值
 * 
 * @access public
 * @param string $str md5加密内容
 * @return 10位MD5值
 */
function md10($str=''){
	return substr(md5($str),10,10);
}

/**
 * 图片裁剪
 * 
 * @access public
 * @param string $file 图片名
 * @param string $app 子模块
 * @param array  $w 宽
 * @param array  $h 高
 * @param array  $path	路径
 * @return 裁剪后的图片URI
 */
if(!function_exists('mfXimg')){
	function mfXimg($file, $app , $w, $h,$path='',$c=0){
		if(!$file) { return;}
		
		$dest = 'uploadfile/'.$app.'/'.$file;
		
		if($w == 0 && $h == 0){
			return base_url().'/'.$dest;
		}
		
		$info = explode('.',$file);	
		$name = md10($file).'_'.$w.'_'.$h.'.'.$info[1];
		
		if(empty($path)){
			$cpath = 'cache/'.$app.'/'.$w.'/'.$name;
		}else{
			$cpath = 'cache/'.$app.'/'.$path.'/'.$w.'/'.$name;
		}
		
		if(!is_file($cpath)){
			createFolders('cache/'.$app.'/'.$path.'/'.$w);
			
			$config['image_library'] = 'gd2';
			$config['source_image'] = $dest;
			$config['new_image'] = $cpath;
			$config['create_thumb'] = FALSE;
			$config['maintain_ratio'] = TRUE;
			$config['width'] = $w;
			$config['height'] = $h;
			$ci_obj = & get_instance();
			$ci_obj->load->library('image_lib');
			$ci_obj->image_lib->clear();
			$ci_obj->image_lib->initialize($config);
			$result = $ci_obj->image_lib->resize();
			if(!$result){
				log_message('error', '图像裁减出错-->'. $ci_obj->image_lib->display_errors());
			}
			unset($ci_obj);
		}
				
		return base_url().'/'.$cpath;
	}
}

