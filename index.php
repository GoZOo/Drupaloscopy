<!DOCTYPE html>
<html xml:lang="en" lang="en">
<head>
  <meta charset="UTF-8">
  <title>Get accessible informations about Drupal website | Drupaloscopy</title>
  <link rel="stylesheet" type="text/css" media="screen, projection" href="assets/style.css" />
  <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
  <script src="assets/jquery.formLabels1.0.js" type="text/javascript"></script>
  <script type="text/javascript">
    $(function(){
      $.fn.formLabels();
    });
  </script>
</head>
<body>
<header>
  <div id="sitename">Drupaloscopy</div>
</header>
<h1>Get Drupal Informations on website</h1>
<div id="content">
  <form method="GET">
    <input type="text" name="domain" value="<?php print isset($_GET['domain']) ? $_GET['domain'] : ''; ?>" class="text" title="www.domainename.com">
    <input type="submit" value="submit" class="submit">
    <div class="help">Domain name have to be exact. Don't use www. prefix if your site haven't (and vice versa).</div>
  </form>
  <div id="result">
  <?php
  if(isset($_GET['domain']) && !empty($_GET['domain'])) {
      $domain = $_GET['domain'];
      if(strpos($domain, 'http') === FALSE || strpos($domain, 'http') != 0) {
       $domain = 'http://' . $domain;
      }
      exec('bash drupaloscopy.sh '.escapeshellcmd($domain), $output);

      foreach($output as $json) {
      $result = json_decode($json);
      ?>
      <div class="line <?php print $result->style; ?>">
      <div class="label"><?php print $result->label; ?> : </div>
      <div class="result"><?php print $result->result; ?></div>
      </div>
      <?php
    }
  }
  else {
?>
  <div class="explaination">
    <p>With Drupaloscopy, you can get informations about Drupal Sites depends of how it's protected :</p>
    <ul>
      <li>Is this site is Drupal Site ?</li>
      <li>Which Drupal version is used ?</li>
      <li>Are .txt files protected and readable ?</li>
      <li>Are CSS and JS aggregated ?</li>
      <li>Is Drupal Cache enabled ?</li>
      <li>Is GZIP Compression enabled ?</li>
    </ul>
  </div>
<?php   
  }
  ?>
  </div>
</div>
<footer>
  <div id="author">Developped by <a href="http://blog.fclement.info">GoZ</a> - <a href="http://barbe-rousse.com">Barbe-Rousse, Freelance Developper Drupal Expert on Nantes</a>. Code available on <a href="https://github.com/GoZOo/Drupaloscopy">Github</a></div>
</footer>
<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-29736704-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
</body>
</html>
