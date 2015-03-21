<?php
	$get = $this->db->query("SELECT * FROM tc_stories");
	if($get->num_rows() > 0 ){
	  foreach($get->result_array() as $row){
	  	echo '<br>'.$row['story_msg'];
	  	echo "<br><span style='font-style: italic; font-size: 18px;'>Where: ".$row['story_location']."</span>";
	  	echo '<br><hr><br>';
	  }
	}
	else{
	  echo '<br> No Feeds';
	  echo '<br><hr><br>';
	}
  ?>