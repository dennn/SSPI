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
			$this->db->insert('textUploads', array('textData'=>$data['data']));
			$data['data'] = $this->db->insert_id();
		}
		$this->db->insert('uploads', $data);
		$insertid = $this->db->insert_id();
		$this->db->where_in('name', $tags);
		$q = $this->db->get('tags');
		$found = array();
		foreach($q->result_array() as $k)
			$found[strtolower($k['name'])] = $k['id'];
		foreach($tags as $t)
		{
			if(array_key_exists(strtolower($t), $found))
			{
				$this->db->insert('tagLink', array("upload"=>$insertid, "tag"=>$found[strtolower($t)]));
			}
			else
			{
				$this->db->insert('tags', array('name'=>$t));
				$this->db->insert('tagLink', array("upload"=>$insertid, "tag"=>$this->db->insert_id()));
			}
		}
		return;
	}

	public function get_uploads($results)
	{
		$this->load->database();
		if(!count($results))
			return;
		$final = array();
		$idArray = array();
		foreach($results as $r)
		{
			$idArray[] = $r['id'];
			$final[strval($r['id'])] = array();
		}
		$this->db->where_in('upload', $idArray);
		$this->db->order_by('upload', 'asc');
		$tagLink = $this->db->get('tagLink');
		$tagsArray = array();
		$tagLinkArray = array();
		$tagLinkHold = array();
		foreach($tagLink->result_array() as $t)
		{
			$tagLinkArray[] = $t['tag'];
			if(isset($tagLinkHold[strval($t['upload'])]))
				$tagLinkHold[strval($t['upload'])][] = $t['tag'];
			else
				$tagLinkHold[strval($t['upload'])] = array($t['tag']);
		}
		$tagLinkArray = array_unique($tagLinkArray);
		$this->db->where_in($tagLinkArray);
		$tagsFetch = $this->db->get('tags');
		$tagInfo = array();
		foreach($tagsFetch->result_array() as $t)
			$tagInfo[strval($t['id'])] = $t['name'];
		$idHold;
		foreach($results as $r)
		{
			$idHold = strval($r['id']);
			$final[$idHold] = $r;
		}
		foreach($final as $l=>$t)
		{
				$final[$l]['tags'] = array();
				if(isset($tagLinkHold[$l]))
				{
					foreach($tagLinkHold[$l] as $k)
						$final[$l]['tags'][] = $tagInfo[$k];
				}
		}
		$finalN = array();
		foreach($final as $f)
			$finalN[] = $f;
		return array("pins"=>$finalN);
	}

	public function get_nearest($lng, $lat, $limit)
	{
		$this->load->database();
		$sql = 'SELECT *, (6371 * acos(cos(radians(' . $lat . ')) * cos(radians(`lat`)) * cos(radians(`long`) - radians(' . $lng . ')) + sin(radians(' . $lat . ')) * sin(radians(`lat`)))) AS distance FROM `uploads` ORDER BY distance ASC LIMIT '.$limit;
		$q = $this->db->query($sql);
		return $this->get_uploads($q->result_array());
	}

	function search($lng, $lat, $limit, $term)
	{
		$this->load->database();
		$limit*=6371;
		$this->db->where_in('name', explode("%7C", $term));
		$this->db->select("id");
		$tags = $this->db->get("tags");
		$idArray = array();
		foreach($tags->result_array() as $r)
			$idArray[] = $r['id'];
		if(!count($idArray))
			return;
		$this->db->where_in('tag', $idArray);
		$this->db->select('upload');
		$this->db->distinct();
		$tagLink = $this->db->get('tagLink');
		$idArray = array();
		foreach($tagLink->result_array() as $r)
			$idArray[] = $r['upload'];
		$sql = 'SELECT *, (6371 * acos(cos(radians(' . $lat . ')) * cos(radians(`lat`)) * cos(radians(`long`) - radians(' . $lng . ')) + sin(radians(' . $lat . ')) * sin(radians(`lat`)))) AS distance FROM `uploads` WHERE id IN ('. implode(',', $idArray) . ') HAVING distance<=\''.$limit.'\'  ORDER BY distance ASC LIMIT '.$limit;
		$q = $this->db->query($sql);
		return $this->get_uploads($q->result_array());
	}


}

?>