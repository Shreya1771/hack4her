<form action="<?php echo base_url();?>index.php/api/add_story_2" accept-charset="utf-8" method="post">
	<label for="story_location" id="label_login">Location</label><br>
	<input type="text" name="story_location" value="" placeholder="     Location" id="textbox2" style=""  /><br><br>
	<input type="hidden" name="story_zone" value="1"/>
	<label for="story_sender" id="label_login">Username</label><br>
	<input type="text" name="story_sender" value="" placeholder="     User" id="textbox2" style=""  /><br><br>
	<label for="story_msg" id="label_login">Message</label><br>
	<textarea name="story_msg" value="" placeholder="     Message" style=""  rows="7" cols="60"/></textarea><br><br>
	<br>
	<input type="submit" name="submit" value="Send Report" id="btn_login" style=""  />
</form><br>
<form action='<?php echo base_url();?>index.php/api'>
	<input type="submit" name="submit" value="Cancel" id="btn_login" style=""  />
</form>
