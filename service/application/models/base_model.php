<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * Model基类
 */
class Base_model extends CI_Model {

	function __construct()
	{
		parent::__construct();
	}
	
	/**
	 * @method find
	 * @desc find function.获取一条符合条件的记录
	 * 					 必选		参数范围		说明
	 * @param $table 	 true		string		表名
	 * @param $condition false		mix			条件
	 * @param $fields	 false 		string		查询字段	
	 * @param $sort 	 false		string		排序规则
	 * @return			 true		mix			 查询结果，以数据形式反回，无符合条件记录返回false
	 */
	function find($table,$condition=array(),$fields="*",$sort=null){
		if( $record = $this->findAll($table,$condition,$fields,$sort, 1) ){
			return array_pop($record);
		}else{
			return FALSE;
		}
	}
	
	/**
	 * @method findAll
	 * @desc findAll function.查找符合条件的若干条记录
	 * 					  必选		参数范围		说明
	 * @param $table 	 true		string		表名
	 * @param $condition false		mix			条件
	 * @param $fields	 false 		string		查询字段	
	 * @param $sort 	 false		string		排序规则
	 * @param $limit 	 false		int			查找记录条数
	 * @param $offset 	 false		int			偏移量
	 * @return 			 true		mix			查询结果，以数组形式反回
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
	 * @method findCount
	 * @desc findCount function.	查找符合条件的记录数
	 * 				  	  必选		参数范围		说明
	 * @param $table 	 true		string		表名	 
	 * @param $condition false		mix			条件
	 * @return 			 true    	int			记录条数
	 */
	function findCount($table,$condition = null){
		if(!empty($condition)){
			$this->db->where($condition);
		}		
		return $this->db->count_all_results($table);
	}
	
	/**
	 * @method update
	 * @desc update function.	按条件更新记录
	 * 				  	  必选		参数范围		说明
	 * @param $table 	 true		string		表名	 
	 * @param $row 		 true		mix			更新内容
	 * @param $condition false		mix			条件
	 * @return 			 true    	bool
	 */
	public function update($table,$row,$condition = NULL){
		if(!empty($condition)){
			$this->db->where($condition);
		}		
		return $this->db->update($table,$row);
	}
	
	/**
	 * @method create
	 * @desc create function.	添加记录
	 * 				  	  必选		参数范围		说明
	 * @param $table 	 true		string		表名	 
	 * @param $row 		 true		mix			添加内容
	 * @return 			 true    	mix			有自增ID返回自增ID，无则返回true/false
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
	 * @method replace
	 * @desc replace function.	添加或更新记录。并不是mysql自带的数据库，自己提供条件
	 * 				  	  必选		参数范围		说明
	 * @param $table 	 true		string		表名	
	 * @param $row 		 true		mix			添加内容
	 * @param $condition true		mix			更新条件
	 * @return 			 true    	mix
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
	 * @method delete
	 * @desc delete function.	添加记录
	 * 				  	  必选		参数范围		说明
	 * @param $table 	 true		string		表名	 
	 * @param $condition false		mix			删除条件,条件为空则truncate表
	 * @return 			 true    	bool
	 */
	public function delete($table,$condition){
		if(!empty($condition)){
			return $this->db->delete($table, $condition);
		}else{
			return $this->db->truncate($table);
		}
	}
		
}

/* End of file base_model.php */
/* Location: ./system/application/models/base_model.php */