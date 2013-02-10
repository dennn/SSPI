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
		if($data['type'] == "text")
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
		$idArray = array();
		foreach($results as $r)
		{
			$idArray[] = $r['id'];
		}
		$this->db->where_in($idArray);
		$this->db->order_by('upload', 'asc');
		$tags = $this->db->get('tagLink');
		$tagsArray = array();
		$tagLinkArray = array();
		$tagLinkHold = array();
		foreach($tags->result_array() as $t)
		{
			if(in_array($t['tag'],$tagLinkHold))
			{
				$tagLinkArray[strval($t['upload'])][] = $t['tag'];
			}
			else
			{
				$tagLinkArray[strval($t['upload'])] = array($t['tag']);
				$tagsLinkHold[] = $t['tag'];
			}
			echo "t upload = " . $t['upload'] . '<br />';
		}
		$this->db->where_in($tagsArray);
		$tagGet = $this->db->get('tags');
		$tagInfoArray = array();
		foreach($tagGet->result_array() as $t)
		{
			$tagInfoArray[strval($t['id'])] = $t['name'];
		}
		$res = $q->result_array();
		echo '<br /><br />';
		print_r($tagLinkArray);
		echo '<br /><br />';
		foreach($res as $k=>$r)
		{
			$res[$k]['tags'] = array();
			print_r($r);
			echo '<br />';
			if(is_array($tagLinkArray[strval($r['id'])]))
			{
				foreach($tagLinkArray[strval($r['id'])] as $t)
				{
					$res[$k]['tags'][] = $t;
				}	
			}
		}
		print_r($res);
		echo '<br />';
		print_r($tagInfoArray);
		echo '<br />';
		print_r($tagGet->result_array());
		echo '<br />';
		print_r($q->result_array);
		echo '<br /><br />';	
		return $q->result_array();
	}

}

?>