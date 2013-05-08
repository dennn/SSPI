<?php

class uploads_model extends CI_Model
{
	function __construct()
	{
		parent::__construct();
	}
	

	public function uploadData($data, $tags)
	{
		$this->load->database();
		$data['location'] = 0;
		if(isset($data['locationname']) != false)
		{
			$locationName = $data['locationname'];
			unset($data['locationname']);
			$this->db->select('id');
			$this->db->where(array('name'=>strtolower($locationName)));
			$q = $this->db->get('locations');
			if($q->num_rows() != 1)
			{
				$this->db->insert('locations', array(	'name'=>strtolower($locationName),
														'long'=>$data['long'],
														'lat' =>$data['lat']));
				$data['location'] = $this->db->insert_id();
			}
			else
			{
				$r = $q->result_array();
				$data['location'] = $r[0]['id'];
			}
		}
		if($data['expires'] == 0 || $data['expires'] == 'never')
			$data['expires'] = 2147483647;

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

	public function parseResults($results)
	{
		$this->load->database();
		if(!count($results))
			return 0;
		$final = array();
		$idArray = array();
		$venueArray = array();
		foreach($results as $k=>$r)
		{
			$idArray[] = $r['id'];
			$final[strval($r['id'])] = array();
			if(array_key_exists('dataLocation', $r))
				$results[$k]['dataLocation'] = 'http://thenicestthing.co.uk/coomko/uploads/'.$r['dataLocation'];
			if(array_key_exists('location', $r))
				$venueArray[] = $r['location'];

		}
		
		if(count($venueArray) != 0)
		{
			$venueNames = array();
			$this->db->where_in('id', $venueArray);
			$this->db->select(array('id', 'name'));
			$q = $this->db->get('locations');
			foreach($q->result_array() as $r)
				$venueNames[strval($r['id'])] = $r['name'];
			foreach($results as $k=>$r)
				if(array_key_exists(strval($r['location']), $venueNames))
					$results[$k]['locationName'] = $venueNames[strval($r['location'])];
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
					{
						if(isset($tagInfo[$k]))
							$final[$l]['tags'][] = $tagInfo[$k];
					}
				}
		}
		$finalN = array();
		foreach($final as $f)
			$finalN[] = $f;
		return array("pins"=>$finalN);
	}

	public function getNearest($lng, $lat, $limit, $type)
	{
		$this->load->database();
		$time = time();
		$extra = "";
		if($type != "all")
			$extra = " AND type = '".$type."'";
		$sql = 'SELECT *, (6371 * acos(cos(radians(' . $lat . ')) * cos(radians(`lat`)) * cos(radians(`long`) - radians(' . $lng . ')) + sin(radians(' . $lat . ')) * sin(radians(`lat`)))) AS distance FROM `uploads` WHERE expires > '.$time.' AND archived = 0 '.$extra.' ORDER BY distance ASC LIMIT '.$limit;
		$q = $this->db->query($sql);
		return $this->parseResults($q->result_array());
	}

	function search($lng, $lat, $limit, $term, $type)
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
			return 0;
		$this->db->where_in('tag', $idArray);
		$this->db->select('upload');
		$this->db->distinct();
		$tagLink = $this->db->get('tagLink');
		$idArray = array();
		foreach($tagLink->result_array() as $r)
			$idArray[] = $r['upload'];
		$time = time();
		$extra = "";
		if($type != "all")
			$extra = " AND type = '".$type."'";

		$sql = 'SELECT *, (6371 * acos(cos(radians(' . $lat . ')) * cos(radians(`lat`)) * cos(radians(`long`) - radians(' . $lng . ')) + sin(radians(' . $lat . ')) * sin(radians(`lat`)))) AS distance FROM `uploads` WHERE id IN ('. implode(',', $idArray) . ') AND archived = 0 '.$extra.' AND expires > '. $time .' HAVING distance<=\''.$limit.'\'  ORDER BY distance ASC LIMIT '.$limit;
		$q = $this->db->query($sql);
		return $this->parseResults($q->result_array());
	}

	function getPinById($id)
	{
		$this->load->database();
		$this->db->where(array('id'=>$id));
		$q = $this->db->get('uploads');
		if($q->num_rows() != 1)
			return 0;
		else
		{
			$d = $q->result_array();
			$data = array(
               'lastAccessed' => time()
            );

			$this->db->where(array('id'=> $id, 'expires >'=>time()));
			$this->db->update('uploads', $data);
			if($d[0]['location'] != 0)
			{
				$this->db->where('id', $d[0]['location']);
				$this->db->select('name');
				$q = $this->db->get('locations');
				$q = $q->result_array();
				$d[0]['locationName'] = $q[0]['name'];
			}
			else
				$d[0]['locationName'] = 'null';
			$d[0]['dataLocation'] = 'http://thenicestthing.co.uk/coomko/uploads/'.$d[0]['dataLocation'];
			return $d[0];
		}
	}

	function getSuggestion($string)
	{
		$this->load->database();
		//$this->db->like('name', $string);
		$q = $this->db->query("SELECT * FROM `tags` WHERE lower(name) LIKE '%$string%' LIMIT 3");
		//$this->db->limit(3);
		//$q = $this->db->get('tags');
		if(!$q->num_rows())
			return 0;
		else
			return $q->result_array();
	}

	function getByVenue($id, $limit)
	{
		$this->load->database();
		$this->db->where(array("location"=>$id));
		$this->db->limit($limit);
		$q = $this->db->get('uploads');
		if($q->num_rows() != 1)
			return 0;
		return $q->result_array();
	}

	function ryanGet()
	{
		$this->load->database();
		$this->db->order_by('id', 'desc');
		$this->db->limit(10);
		$q = $this->db->get('uploads');
		$q = $this->parseResults($q->result_array());
		return $q;
	}

	function ryanGetTags()
	{
		$this->load->database();
		$this->db->order_by('name', 'asc');
		$q = $this->db->get('tags');
		$q = $q->result_array();
		return $q;
	}

	function newsFeed($type)
	{
		$this->load->database();
		$this->db->order_by('id', 'desc');
		if($type == "image")
			$this->db->where('type', 'image');
		else if($type == "text")
			$this->db->where('type', 'text');
		else if($type == "audio")
			$this->db->where('type', 'audio');
		else if($type == "video")
			$this->db->where('type', 'video');
		$this->db->limit('10');
		$this->db->where('expires >', time());
		$q = $this->db->get('uploads');
		return $this->parseResults($q->result_array());
	}

	function getUser($id)
	{
		$this->load->database();
		$this->db->where('id',$id);
		$this->db->select(array('id', 'user'));
		$q = $this->db->get('users');
		if($q->num_rows() == 1)
		{
			$r = $q->result_array();
			return $r[0];
		}
		return 0;
	}


}

?>