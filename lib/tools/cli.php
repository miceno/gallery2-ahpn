<?php
/**
 * Created by PhpStorm.
 * User: orestes
 * Date: 20/07/2018
 * Time: 10:52
 */

/* Adjust the path to point to your gallery2 folder */
require_once('../gallery2/embed.php');

/*
 * Initialize G2 (includes all necessary classes,
 * puts G2 into a state ready to process your calls)
 */
$ret = GalleryEmbed::init(array('fullInit' => true));
check($ret);

/* Grab the authToken */
global $gallery;
$session =& $gallery->getSession();
$authToken = $session->getAuthToken();
GalleryUtilities::putRequestVariable('authToken', $authToken);

/* Here we could either call any API mehtods or declare the controller request params */
GalleryUtilities::putRequestVariable('controller', 'core.AdminMaintenance');
GalleryUtilities::putRequestVariable('form[action][runTask]', 1);
GalleryUtilities::putRequestVariable('taskId', 'BuildDerivativesTask');

/* Execute the above defined controller request */
$data = GalleryEmbed::handleRequest();

/* $data['bodyHtml'] contains the resulting HTML */
print($data['bodyHtml']);

function check($ret) {
    if ($ret) die($ret->getAsHtml());
}

