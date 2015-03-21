<?php

class Api extends CI_Controller{

    function __construct(){
        parent::__construct();
        $this->load->model('tc_model');
		date_default_timezone_set('Asia/Manila');//setting the timezone
    }
    function index(){
        //echo base_url();
        $this->load->view('cms_view');
    }

	function fb_share($id){
	        //echo base_url();
		$result = $this->tc_model->get_message($id);
		foreach($result as $row){
			$data['table_view'] = $row['story_msg'].'<br>Where: '.$row['story_location'];

        }
		$this->load->view('cms_view', $data);
    }

    function report_incident(){
        $data['table_view'] = 'report_view';
        $this->load->view('cms_view', $data);
    }

    function identify_safe_space(){
        $data['table_view'] = 'safe_view';
        $this->load->view('cms_view', $data);
    }

    function add_account(){
        $post = $this->input->post(NULL,TRUE);
        $result = $this->tc_model->add_account($post);
        $this->display_output($result);

    }

    function add_story(){
        $post = $this->input->post(NULL,TRUE);
        $result = $this->tc_model->add_story($post);
        $this->display_output($result);
    }

    function add_story_2(){
        $post = $this->input->post(NULL,TRUE);
        $result = $this->tc_model->add_story($post);
        if($result){
        	redirect('api');
        }
    }

    function get_story(){
        $result = $this->tc_model->get_story();
        //var_dump($result);
        if(!empty($result)){
        	foreach($result as $row){
			            $stories[] = array(
			                'story_sender'    => $row['story_sender'],
			                'story_msg'       => $row['story_msg'],
			                'story_location'  => $row['story_location'],
			                'story_zone'      => $row['story_zone'],
			            );

        	}
        }
        else{
        	$stories = null;
        }


        $this->display_output($stories);
    }

    function display_output($result){
        $outputVal['tc_api'] = array(
            'status' => array(
                'result' => '0',
                'message' => 'error'
            )
        );
        //var_dump($result);
        if($result && $result != null) {
            //return true;
            $outputVal['tc_api']['status']['result'] = 1;
            $outputVal['tc_api']['status']['message'] = $result;
        }
        else
        {
            //return false;
            $outputVal['tc_api']['status']['result'] = 0;
            $outputVal['tc_api']['status']['message'] = "error";
        }
        $this->output->set_header("Content-Type: application/json; charset=utf-8");
        $jsonOutput = json_encode($outputVal);
        $this->output->set_output($jsonOutput);
    }


	function send_message(){
        $post = $this->input->post(NULL,TRUE);
		$return = $this->api_call($post);


        $this->display_output($return);

		//for loop of 5 contacts
		//$date = date('Y-m-d');
		//$end_date = date ("Y-m-d", strtotime("+14 day", strtotime($date)));

		//while (strtotime($date) <= strtotime($end_date)) {
		//	$this->api_call($api, $date);
		//	$date = date ("Y-m-d", strtotime("+1 day", strtotime($date)));
		//}
		//return 1;
	}
	function api_call($post){
		$api = 'https://post.chikka.com/smsapi/request';
		$arr_details = array(
			"message_type" 	=> "SEND",
			"mobile_number" => (array_key_exists('mobile_number', $post))? urldecode($post['mobile_number']): '',
			"shortcode" 	=> "29290948061",
			"message_id" 	=> (array_key_exists('message_id', $post))? urldecode($post['message_id']): '',
			"message" 		=> (array_key_exists('message', $post))? urldecode($post['message']): '',
			"client_id" 	=> "5303349d13c2e0d15f40f1c65b900fa39ea3203d47501ec60e119a1b13b48ad0",
			"secret_key" 	=> "8578e3bf970d0197cb961b53b8e3524d7ccfdc6e4e314b3dc855d3973947f465",
		);
		$query_string = '';
		foreach($arr_details as $key => $frow){
			$query_string .= '&'.$key.'='.$frow;
		}
		$ch = curl_init();
		curl_setopt($ch,CURLOPT_URL,$api);
		curl_setopt($ch,CURLOPT_POST,count($arr_details));
		curl_setopt($ch,CURLOPT_POSTFIELDS, $query_string);
		curl_setopt($ch,CURLOPT_RETURNTRANSFER,true);
		$data=curl_exec($ch);
		curl_close($ch);
		return true;
    }

    function filter_locations(){
		$post = $this->input->post(NULL,TRUE);
		$result = $this->tc_model->filter_locations($post);
		$this->display_output($result);
    }

    function get_contacts(){
		$post = $this->input->post(NULL,TRUE);
		$result = $this->tc_model->get_contacts($post);
		$this->display_output($result);
    }
}