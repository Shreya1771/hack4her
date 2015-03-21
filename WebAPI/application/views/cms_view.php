<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Take Care - CMS</title>

  <link rel="stylesheet" href="<?php echo base_url();?>css/style.css" type="text/css" media="screen" charset="utf-8">
  <link rel="stylesheet" href="<?php echo base_url();?>css/reset.css" type="text/css" media="screen" />

  <style>
  .btn:hover {
  	opacity: 0.3; filter: alpha(opacity=30);
  }
  #container{
	  background-image: url('http://takecare.16mb.com//images/BG.png');
	  background-repeat: no-repeat;
	  height: 100%;
      background-size: 999px 100%;
  }
  </style>
</head>
<body>
<div id='container'>
    <img style="position: absolute; left: 100px; top: 25px;" src="<?php echo base_url();?>/images/logo small.png">
    <div style="position: absolute; top: 90px; left: 350px; height: 50px;">
		<a href="<?php echo base_url();?>index.php/api/report_incident" class="login" title="Login"><img class='btn' src="<?php echo base_url();?>/images/report incident pressed.png" /></a>
		<a href="<?php echo base_url();?>index.php/api/identify_safe_space" class="login" title="Login"><img class='btn' src="<?php echo base_url();?>/images/identify space pressed.png" /></a>
	</div>
<br><br>
	<div style="color: white; font-family: 'Verdana'; font-size: 20px; height: 400px; width: 700px; position: absolute;
	top: 230px; left: 200px; overflow-y: scroll;
    word-wrap: break-word;">
		<?php echo isset($table_view)? $this->load->view($table_view): $this->load->view('table_view');?>
	</div>

</div>



</body>
</html>