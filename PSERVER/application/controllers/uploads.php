<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class uploads extends CI_Controller {

	/**
	 * Index Page for this controller.
	 *
	 * Maps to the following URL
	 * 		http://example.com/index.php/welcome
	 *	- or -  
	 * 		http://example.com/index.php/welcome/index
	 *	- or -
	 * Since this controller is set as the default controller in 
	 * config/routes.php, it's displayed at http://example.com/
	 *
	 * So any other public methods not prefixed with an underscore will
	 * map to /index.php/welcome/<method_name>
	 * @see http://codeigniter.com/user_guide/general/urls.html
	 */
	public function index()
	{
		$this->load->view('welcome_message');
	}

	public function run()
	{
		$this->load->helper('string');
		$error = 0;
		if($this->input->post('type') == 'text')
		{
			if($this->input->post('text') != '')
				$error = 1;
			$data['upload_data'] = array('file_name'=>'');
		}
		else
		{
			$config['upload_path'] = './uploads/';
			$config['allowed_types'] = 'jpg|png|jpeg|mp3|mp4';
			$config['file_name'] = hash ( "sha256" , random_string('alnum', 50) . time());
			$config['overwrite'] = false;
			$this->load->library('upload', $config);
			$field_name = "userfl";
			if ( ! $this->upload->do_upload($field_name))
			{
				$error = array('error' => $this->upload->display_errors());
				//$this->load->view('upload_form', $error);
				
			}
			else
			{
				//0 = image
				//2 = text
				//$this->load->view('upload_success', $data);
				$data = array('upload_data' => $this->upload->data());
			}
		}
		if(!$error)
		{
			echo 0;
		}
		else
		{
			$info = array("userid"=>1, "type"=>$this->input->post('type'), "long"=>$this->input->post("long"), "lat"=>$this->input->post('lat'), "date"=>time(),
							"dataLocation"=>$data['upload_data']['file_name'], "data"=>$this->input->post('text'), "pitch"=>"", "heading"=>"");
			file_put_contents('data.txt', print_r($data, true));
			file_put_contents('post.txt', print_r($_POST, true));
			$this->load->model('uploads_model', 'uploads');
			$this->uploads->dump_upload($info, explode(' ', $this->input->post("tags")));
			echo 1;
		}
		file_put_contents('file.txt', print_r($_FILES, true));
		return;
	}

	public function get_pins()
	{
		header('Content-Type:application/json');
		$this->load->model("uploads_model", "uploads");
		$long = $this->uri->segment(3);
		$lat = $this->uri->segment(4);
		if(!$long || !$lat)
		{
			echo 0;
			return;
		}
		$results = $this->uploads->get_nearest($long, $lat, 10);
		echo json_encode($results);
		return;
	}

	public function search()
	{
		header('Content-Type:application/json');
		$long = $this->uri->segment(3);
		$lat = $this->uri->segment(4);
		$limit = $this->uri->segment(5);
		$term = $this->uri->segment(6);
		//echo "long = " . $long . ", lat = " . $lat . ", limit = " . $limit . ", term = " . $term ;
		$this->load->model('uploads_model', 'uploads');
		if(!$long || !$lat || !$term || !$limit)
		{
			echo 0;
			return;
		}
		$results = $this->uploads->search($long, $lat, $limit, $term);
		echo json_encode($results);
		return;

	}

	public function foursquarecurl()
	{

		$long = $this->uri->segment(4);
		$lat = $this->uri->segment(3);
		echo $long .' - ' . $lat;
		$url = 'https://api.foursquare.com/v2/venues/search?ll='.$lat.','.$long.'&client_id=EHARTDNZ154FB4FUOD5ZO2ZFFG01SGL3HD1DHSL15EWIBOC1&client_secret=HR5MN2SKGQZFSY1WOONM5NHJKFU1BGC0SBFK0QCNXVHNGU5H&v='.date("Ydm");
		// call to https://foursquare.com/oauth2/access_token with $code
		$data = file_get_contents($url);
        $results = json_decode($data, true);
        $final = array();
        foreach($results['response']['venues'] as $v)
        {
        	$final[] = array("id"=>$v['id'], "name"=>$v['name']);
        }
		header('Content-Type:application/json');
        echo json_encode(($final));
	}
}

/* End of file welcome.php */
?>