<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

// This can be removed if you use __autoload() in config.php OR use Modular Extensions
require_once APPPATH.'../shared'.'/libraries/REST_Controller.php';

class MF_Controller extends REST_Controller {

	public function __construct()
	{
		log_message('debug', 'MF_Controller loaded..');
		parent::__construct();
	}

}

/* End of file base_controller.php */
/* Location: ./system/application/controllers/base_controller.php */