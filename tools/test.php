<?php
/* Make sure the webserver user can write to the current directy (chmod 777) */

$pathToG2 = '/var/www/localhost/htdocs';

// echo system("/usr/bin/identify $pathToG2/gallery2/modules/imagemagick/data/test.pdf 2>&1");
echo system("/usr/bin/identify /kunden/homepages/8/d228439513/htdocs/incoming/comerciospn/Pujades.pdf 2>&1");
?>

