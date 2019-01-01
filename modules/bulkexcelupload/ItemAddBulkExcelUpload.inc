<?php
/*
 * Gallery - a web based photo album viewer and editor
 * Copyright (C) 2000-2006 Bharat Mediratta
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street - Fifth Floor, Boston, MA  02110-1301, USA.
 */
/**
 * @version $$ $$
 * @package ItemAdd
 * @subpackage UserInterface
 * @author Orestes Sanchez <miceno.atreides@gmail.com>
 */

function create_excel_row($description, $number, $terms, $media, $place,
			  $author, $date)
{
    
    return array(
	'description' => $description,
	'number' => $number,
	'terms' => $terms,
	'media' => $media,
	'place' => $place,
	'author' => $author,
	'date' => $date
    );
}

/**
 * This controller will handle the addition of a bulk list of files using an
 * excel file for descriptions of the images and a zip file with the images.
 *
 * @package ItemAddBulkExcelUpload
 * @subpackage UserInterface
 */
class ItemAddBulkExcelUpload extends ItemAddPlugin
{
    
    
    /**
     * @see ItemAddPlugin::handleRequest
     *
     * Do not perform data validation. In case form data is not valid, raise
     * errors or exceptions.
     * @param $form
     * @param $item
     * @param $addController
     * @return array
     */
    function handleRequest($form, &$item, &$addController)
    {
	global $gallery;
	$platform =& $gallery->getPlatform();
	$classes_path = 'modules/bulkexcelupload/classes/helpers/';
 
	$status = $error = array();
 
	GalleryCoreApi::requireOnce($classes_path . 'ItemAddBulkExcelUpload_helper.class');
 
	// $gallery->debug( "linea: " );
	
	if (isset($form['action']['add'])) {
	    list ($ret, $module) = GalleryCoreApi::loadPlugin('module', 'bulkexcelupload');
	    if ($ret) {
		return array($ret, null, null);
	    }
	    
	    $gallery->debug_r($form);
	    
	    list($isValidExcel, $warningExcel) =
		ItemAddBulkExcelUpload_helper::_validate_file($form,'excelPath');
	    if (!$isValidExcel){
		$status['addedFiles'][] = array('fileName' => $form['name']['excelPath']?:'Excel file',
		    'id' => null,
		    'warnings' => array($module->translate($warningExcel)));
	    }
	    else {
		$excelFile = array('name' => $form['name']['excelPath'],
		    'type' => $form['type']['excelPath'],
		    'tmp_name' => $form['tmp_name']['excelPath'],
		    'size' => $form['size']['excelPath']);
	    }
	    
	    list($isValidZip, $warningZip) =
		ItemAddBulkExcelUpload_helper::_validate_file($form, 'zipPath');
	    if (!$isValidZip){
		$status['addedFiles'][] = array('fileName' => $form['name']['zipPath']?:'ZIP file',
		    'id' => null,
		    'warnings' => array($module->translate($warningZip)));
	    }
	    else {
		$zipFile = array('name' => $form['name']['zipPath'],
		    'type' => $form['type']['zipPath'],
		    'tmp_name' => $form['tmp_name']['zipPath'],
		    'size' => $form['size']['zipPath']);
	    }
	    
	    $hasHeader = array_key_exists('hasHeader', $form) ? $form['hasHeader']=='on': false;
	    
	    if($isValidExcel && $isValidZip){
		// Set default preview to true.
		$debug = true;
	 
		/**
		 * Create the temporary folder that will hold the images.
		 *
		 */
		$base = $platform->tempnam($gallery->getConfig('data.gallery.tmp'), 'tmp_');
		// TODO: Remove when we are done testing.
		$base = $gallery->getConfig('data.gallery.tmp');
		$baseTmpPath = $base . 'excelupload.dir';
		$gallery->debug("Basepath = $baseTmpPath");
	 
		if (!$platform->is_dir($baseTmpPath)) {
		    if (!$platform->mkdir($baseTmpPath)) {
			return array(GalleryCoreApi::error(ERROR_PLATFORM_FAILURE), null);
		    }
		}
	 
		/**
		 * Read Excel File
		 */
		$rows = ItemAddBulkExcelUpload_helper::_readExcel($excelFile['tmp_name'], $hasHeader);
	 	$gallery->debug("Excel rows");
	 	$gallery->debug_r($rows);
		/**
		 * Read list of files in zip
		 */
		$fileNames = ItemAddBulkExcelUpload_helper::_readZip($zipFile['tmp_name']);
	 	$gallery->debug("Zip files");
	 	$gallery->debug_r($fileNames);
	 
		/**
		 * Create CSV from excel and zip.
		 */
		$data = ItemAddBulkExcelUpload_helper::_createDelimitedData($rows,
		    $fileNames, $baseTmpPath, false, null, $debug);
	    
		/**
		 * Uncompress ZIP file.
		 */
		$ret = ItemAddBulkExcelUpload_helper::_expandZip
		($zipFile['tmp_name'], $baseTmpPath, $debug);
		if ($ret) {
		    return array(GalleryCoreApi::error(ERROR_PLATFORM_FAILURE), null);
		}
		/**
		 * Bulk upload.
		 */
		list ($ret, $lockId) = GalleryCoreApi::acquireReadLock($item->getId());
		if ($ret) {
		    return array($ret, null, null);
		}
	 
		list($ret, $error, $status) = ItemAddBulkExcelUpload_helper::_bulkUpload($data, $baseTmpPath, $item);
		if ($ret) {
		    return array($ret, null, null);
		}
	 
		$ret = GalleryCoreApi::releaseLocks($lockId);
		if ($ret) {
		    return array($ret, null, null);
		}
	    }
	    
	    if(!empty($status)){
		$gallery->debug("Non empty status");
		$gallery->debug_r($status);
		GalleryUtilities::putRequestVariable('ItemAddBulkExcelUploadStatus',
		    $status['addedFiles']);
	    }
	    

	} else {
	    $gallery->error("no valid action");
	}
	$gallery->debug("returning from excel import... ");
	
	return array(null, $error, $status);
    }
    
    
    /**
     * @see ItemAdd:loadTemplate
     *
     * Validate field values.
     *
     */
    function loadTemplate(&$template, &$form, $item)
    {
	global $gallery;
 
	list ($ret, $module) = GalleryCoreApi::loadPlugin('module', 'bulkexcelupload');
	if ($ret) {
	    return array($ret, null, null);
	}
 
	if ($form['formName'] != 'ItemAddBulkExcelUpload') {
	    $form['formName'] = 'ItemAddBulkExcelUpload';
	}
	
	if (empty($form['hasHeader'])) {
	    $form['hasHeader'] = 'on';
	}
 
	$fileUploadsBool = GalleryUtilities::getPhpIniBool('file_uploads');
	$totalUploadSize = ini_get('post_max_size');
	if (preg_match("/(\d+)M/", $totalUploadSize, $matches)) {
	    $totalUploadSize = $matches[1] * 1024 * 1024;
	}
 
	$maxFileSize = ini_get('upload_max_filesize');
	if (preg_match("/(\d+)M/", $maxFileSize, $matches)) {
	    $maxFileSize = $matches[1] * 1024 * 1024;
	}
 
	foreach (array('totalUploadSize', 'maxFileSize') as $key) {
	    if ($$key >= 1024 * 1024) {
		$$key = $module->translate(array('one' => '%d megabyte',
		    'many' => '%d megabytes',
		    'count' => (int)($$key / (1024 * 1024)),
		    'arg1' => (int)($$key / (1024 * 1024))));
	    } else if ($$key >= 1024) {
		$$key = $module->translate(array('one' => '%d kilobytes',
		    'many' => '%d kilobytes',
		    'count' => (int)($$key / (1024)),
		    'arg1' => (int)($$key / (1024))));
	    }
	}
 
	$status = GalleryUtilities::getRequestVariables('ItemAddBulkExcelUploadStatus');
	$template->setVariable('ItemAddBulkExcelUpload',
	    array('totalUploadSize' => $totalUploadSize,
		'maxFileSize' => $maxFileSize,
		'uploadsPermitted' => $fileUploadsBool,
		'status' => $status));
 
	/* Set the ItemAdmin form's encoding type specially since we're uploading binary files */
	if ($template->hasVariable('ItemAdmin')) {
	    $ItemAdmin =& $template->getVariableByReference('ItemAdmin');
	    $ItemAdmin['enctype'] = 'multipart/form-data';
	} else {
	    $ItemAdmin['enctype'] = 'multipart/form-data';
	    $template->setVariable('ItemAdmin', $ItemAdmin);
	}
	return array(null,
	    'modules/bulkexcelupload/templates/ItemAddBulkExcelUpload.tpl',
	    'modules_bulkexcelupload');
    }
    
    /**
     * @see ItemAddPlugin::getTitle
     */
    function getTitle()
    {
	list ($ret, $module) = GalleryCoreApi::loadPlugin('module', 'bulkexcelupload');
	if ($ret) {
	    return array($ret, null);
	}
	
	return array(null, $module->translate('Bulk Excel Upload'));
    }
}

