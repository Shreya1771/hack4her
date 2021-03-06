<?php
class Tc_model extends CI_Model{

    function __construct(){

        date_default_timezone_set('Asia/Manila');
    }
    function add_account($post){
        $new_image_inset_details = array(
            'username'  => (array_key_exists('username', $post))? urldecode($post['username']): 'sample',
            'pin'     => (array_key_exists('pin', $post))? urldecode($post['pin']): 'sample',
        );
        $insert = $this->db->insert('tc_accounts', $new_image_inset_details);
        if($insert){
            return true;
        }
        else{
            return false;
        }
    }

    function add_story($post){
        $new_image_inset_details = array(
            'story_sender'  => (array_key_exists('story_sender', $post))? urldecode($post['story_sender']): null,
            'story_msg'     => (array_key_exists('story_msg', $post))? urldecode($post['story_msg']): null,
            'story_location'     => (array_key_exists('story_location', $post))? urldecode($post['story_location']): null,
            'story_zone'     => (array_key_exists('story_zone', $post))? ((urldecode($post['story_zone'])==1)? 'safe':'danger'): null,
        );
        $insert = $this->db->insert('tc_stories', $new_image_inset_details);
        if($insert){
            return true;
        }
        else{
            return false;
        }
    }

    function get_story(){
        $date_today =  date('Y-m-d');
        $get = $this->db->query("SELECT * FROM tc_stories where story_timestamp >= '".$date_today."'");//get_where('tc_stories', array('story_timestamp' => $date_today));
        //var_dump($get->result_array());
        if($get->num_rows() > 0 ){
            return $get->result_array();
        }
        else{
            return false;
        }
    }
    function get_message($id){
		$get = $this->db->query("SELECT * FROM tc_stories where story_id = '".$id."'");
		if($get->num_rows() > 0 ){
			return $get->result_array();
		}
		else{
			return false;
		}
    }

    function filter_locations($post){
		$location =  (array_key_exists('location', $post))? '%'.urldecode($post['location']).'%': null;
		$get = $this->db->query("SELECT * FROM tc_stories where story_location LIKE '".$location."' and story_zone='danger'");//get_where('tc_stories', array('story_timestamp' => $date_today));
		//var_dump($get->result_array());
		if($get->num_rows() > 0 ){
			return $get->result_array();
		}
		else{
			return false;
		}
	}

	function get_contacts($post){
		$user =  (array_key_exists('user', $post))? ''.urldecode($post['user']).'': null;
		$get = $this->db->query("SELECT id FROM tc_accounts where username='".$user."'");
        foreach($get->result_array() as $row){
			$get_qry = $this->db->query("SELECT * FROM tc_contact where account_id = '".$row['id']."'");
			if($get_qry->num_rows() > 0 ){
				return $get_qry->result_array();
			}
			else{
				return false;
			}
        }
	}

}