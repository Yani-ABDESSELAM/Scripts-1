<?php
/*
 * Generate xkcd style password from /usr/share/dict/words
 *
 * http://xkcd.com/936/
 * apt-get install wamerican
 */
function xkcd_password_generator() {
  $lines = file('/usr/share/dict/words', FILE_IGNORE_NEW_LINES);
  $length = count($lines);
  $pw = '';
  for ($i = 1; $i <= 4; $i++) {
    $plain = FALSE;
    while (!$plain) {
      // Get random word from $lines
      $key = mt_rand(0, $length);
      if ((preg_match("/^[a-z]+$/", $lines[$key]) == 1) && (strlen($lines[$key]) < 9)) {
        // String only contains a to z characters
        $plain = TRUE;
        $pw = $pw . $lines[$key];
      }
    }
  }
  return $pw;
}
echo xkcd_password_generator() . "\n";
?>