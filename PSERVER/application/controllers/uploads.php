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
		$config['upload_path'] = './uploads/';
		$config['allowed_types'] = 'jpg|png|jpeg';
		$config['file_name'] = hash ( "sha256" , random_string('alnum', 50) . time());
		$config['overwrite'] = false;
		$this->load->library('upload', $config);
		$field_name = "userfl";
		if ( ! $this->upload->do_upload($field_name))
		{
			$error = array('error' => $this->upload->display_errors());
			//$this->load->view('upload_form', $error);
			echo '0';
		}
		else
		{
			//0 = image
			$data = array('upload_data' => $this->upload->data());
			$info = array("userid"=>1, "type"=>$this->input->post('type'), "long"=>$this->input->post("long"), "lat"=>$this->input->post('lat'), "date"=>time(),
							"dataLocation"=>$data['upload_data']['file_name'], "data"=>"", "pitch"=>"", "heading"=>"");
			if($info['type'] == 0)
			{
				$data['pitch'] = $this->input->post("pitch");
				$data['heading'] = $this->input->post("heading");
			}
			else if($info[type] == 1)
			{

			}
			file_put_contents('data.txt', print_r($data, true));
			file_put_contents('post.txt', print_r($_POST, true));
			$this->load->model('uploads_model', 'uploads');
			$this->uploads->dump_upload($info);
			//$this->load->view('upload_success', $data);
			echo '1';
		}
		file_put_contents('file.txt', print_r($_FILES, true));
		return;
	}

	public function get_pins()
	{
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
}

/* End of file welcome.php */
?>