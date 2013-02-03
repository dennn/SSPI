<?php

class uploads_model extends CI_Model
{
	function __construct()
	{
		parent::__construct();
	}
	

	public function dump_upload($data)
	{
		$this->load->database();
		if($data['type'] == 2)
		{
			$this->db->insert('textUploads', $data['text']);
			$data['data'] = $this->db->insert_id();
		}
		$this->db->insert('uploads', $data);
		return;
	}

	public function get_upload($id)
	{

	}

}

?>