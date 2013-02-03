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

	public function get_nearest($lng, $lat, $limit)
	{
		$this->load->database();
		$sql = 'SELECT *, (6371 * acos(cos(radians(' . $lat . ')) * cos(radians(`lat`)) * cos(radians(`long`) - radians(' . $lng . ')) + sin(radians(' . $lat . ')) * sin(radians(`lat`)))) AS distance FROM `uploads` ORDER BY distance ASC LIMIT '.$limit;
		$q = $this->db->query($sql);
		return $q->result_array();
	}

}

?>