<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * Model基类
 * 
 * 封装通用数据库增删查改方法
 * 
 * @package		CodeIgniter
 * @subpackage	Model
 * @category	Controller
 * @author		xie.hj
 * @link		http://www.mifan.us
 * 
 */
class Base_model extends CI_Model {

	function __construct()
	{	
		parent::__construct();
		log_message('DEBUG','Base_model loaded.');		
		$this->load->driver('cache', array('adapter' => 'memcached', 'backup' => 'file'));
	}
	
	/**
	 * find
	 * 
	 * find function.获取一条符合条件的记录

	 * @param	string 	$table 	 必选，表名
	 * @param	mix		$condition 	可选，条件
	 * @param	string 	$fields 	 可选，查询字段
	 * @param	string 	$sort 	 可选，排序规则
	 * 
	 * @return	array|false	查询结果，以数组形式反回，无符合条件记录返回false
	 */
	function find($table,$condition=array(),$fields="*",$sort=null){
		if( $record = $this->findAll($table,$condition,$fields,$sort, 1) ){
			return array_pop($record);
		}else{
			return FALSE;
		}
	}
	
	/**
	 * findAll
	 * 
	 * findAll function.查找符合条件的若干条记录
	 * 
	 * @param	string 	$table 	 必选，表名
	 * @param	mix		$condition 	可选，条件
	 * @param	string 	$fields 	 可选，查询字段
	 * @param	string 	$sort 	 可选，排序规则
	 * @param 	int		$limit 	 可选，查找记录条数
	 * @param	int		$offset 可选，偏移量
	 * 
	 * @return 	array|false	查询结果，以数组形式反回，无符合条件记录返回false
	 */
	function findAll($table,$condition=array(),$fields="*",$sort=null,$limit=null,$offset = 0){
		$fields = empty($fields) ? "*" : $fields;
		
		$this->db->select($fields);
		
		if (!empty($condition)) {
			$this->db->where($condition);
		}
		
		if (!empty($sort)) {
			$this->db->order_by($sort);
		}
		
		if(!empty($limit)){
			$this->db->limit($limit,$offset);
		}
		
		$query = $this->db->get($table);
		
		$result = $query->result_array();
		
		return empty($result)? FALSE : $result;
	}
	
	/**
	 * findCount
	 * 
	 * findCount function.	查找符合条件的记录数
	 * 
	 * @param	string	$table	必选，表名	 
	 * @param	mix		$condition 可选，条件
	 * 
	 * @return array|false	查询结果，以数组形式反回，无符合条件记录返回false
	 */
	function findCount($table,$condition = null){
		if(!empty($condition)){
			$this->db->where($condition);
		}		
		return $this->db->count_all_results($table);
	}
	
	/**
	 * update
	 * 
	 * update function.	按条件更新记录
	 * 
	 * @param	string	$table	必选，表名	 
	 * @param	mix		$row 	必选，更新内容
	 * @param	mix		$condition 可选，条件
	 * 
	 * @return bool	更新结果
	 */
	public function update($table,$row,$condition = NULL){
		if(!empty($condition)){
			$this->db->where($condition);
		}		
		return $this->db->update($table,$row);
	}
	
	/**
	 * create
	 * 
	 * create function.	添加记录
	 * 
	 * @param	string	$table	必选，表名	 
	 * @param	mix		$row 	必选，添加内容
	 * 
	 * @return	mix			有自增ID返回自增ID，无则返回true/false
	 */
	public function create($table,$row){
		$result = $this->db->insert($table,$row);
		if($result){
			if($id = $this->db->insert_id()){
				return $id;
			}else{
				return TRUE;
			}
		}
		
		return FALSE;
	}
	
	/**
	 * replace
	 * 
	 * replace function.	添加或更新记录。并不是mysql自带的数据库，自己提供条件
	 * 
	 * @param	string	$table	必选，表名	 
	 * @param	mix $row	必选，添加或更新内容
	 * @param	mix	$condition 必选，更新条件
	 * 
	 * @return 	mix	操作结果
	 */
	public function replace($table,$row,$condition = NULL){
		
		if(empty($condition)){
			return FALSE;
		}
		
		if($this->findCount($table,$condition)){
			return $this->update($table, $row, $condition);
		}else{
			return $this->create($table, $row);
		}
	}
	
	/**
	 * delete
	 * 
	 * delete function.	添加记录
	 * 
	 * @param	string	$table	必选，表名
	 * @param	mix	$condition 可选，删除条件,条件为空则truncate表
	 * 
	 * @return 	bool	删除结果
	 */
	public function delete($table,$condition){
		if(!empty($condition)){
			return $this->db->delete($table, $condition);
		}else{
			return $this->db->truncate($table);
		}
	}
	
	/**
	 * get_source_by_id
	 * 
	 * 根据ID获取资源
	 * 
	 * @param	string	$method	必选，实际获取资源的方法名
	 * @param	int $id 可选，资源ID，为空获取第一条资源记录
	 * @param	array $data 可选，错误码和错误提示
	 */
	public function get_source_by_id($method,$id = 1,$data = null){
		
		$ret = isset($data['ret'])?$data['ret']:'104002';
		$msg = isset($data['msg'])?$data['msg']:'查找的资源不存在!';
		
		$strSource = call_user_func(array($this,$method),$id);
		
		if(!$strSource){
			return array($ret,$msg);
		}
		
		return array('100000',$strSource);
		
	}

}

/* End of file base_model.php */
/* Location: ./system/application/models/base_model.php */