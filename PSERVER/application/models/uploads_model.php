<?php

class uploads_model extends CI_Model
{
	function __construct()
	{
		parent::__construct();
	}
	

	public function dump_upload($data, $tags)
	{
		$this->load->database();
		if($data['type'] == 2)
		{
			$this->db->insert('textUploads', $data['text']);
			$data['data'] = $this->db->insert_id();
		}
		$this->db->insert('uploads', $data);
		$insertid = $this->db->insert_id();
		$this->db->where_in('name', $tags);
		$q = $this->db->get('tags');
		$found = array();
		foreach($q->result_array() as $k)
			$found[$k['name']] = $k['id'];
		foreach($tags as $t)
		{
			if(array_key_exists($t, $found))
			{
				$this->db->insert('tagLink', array("upload"=>$insertid, "tag"=>$found[$t]));
			}
			else
			{
				$this->db->insert('tags', array('name'=>$t));
				$this->db->insert('tagLink', array("upload"=>$insertid, "tag"=>$this->db->insert_id()));
			}
		}
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
		$results = $q->result_array();
		return $q->result_array();
	}

}

?>