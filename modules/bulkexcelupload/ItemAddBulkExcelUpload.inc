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

/**
 * This controller will handle the addition of an item as a children to another item.
 *
 * @package ItemAdd
 * @subpackage UserInterface
 */
class ItemAddBulkExcelUpload extends ItemAddPlugin {
    /**
     * Create a CSV file suitable for import.
     *
     * @param $excelPath string Path to excel file.
     * @param $zipPath string Path to zip file with the images. Images should
     * be in the same order as they appear on the excel file.
     * @param $readHeader boolean Excel file will have a header row.
     * @param $debug boolean Activate debug or verbose mode.
     * @return array Returns a tuple of GalleryStatus, the CSV data, and the
     * verbose or debug output.
     *
     */
    private static function _createCsv($excelPath, $zipPath, $readHeader,
				       $debug)
    {
        // TODO: implement create csv code.
	$error = null;
	$data = array(
	    /* Header */
	    join("\t", array("title", "summary", "description", "keywords", "filename")),
	    join("\t", array("0001 L'Aliança [1900]",
		"Façana del primitiu edifici de la Societat L'Aliança",
		"Façana del primitiu edifici de la Societat L'Aliança.",
		"1,3.1,Entitats,CD/paper,Wad - Ras,Autor: Desconegut,[1900]",
		"/kunden/homepages/8/d228439513/htdocs/private/gallery/bulk/tmpk3XF_5/0001 L'Aliança [1900].jpg")),
	    join("\t", array("0033 L'Aliança 1981",
		"Ball al Casino de L'Aliança",
		"Ball al Casino de L' Aliança.",
		"33,3.1.1,Entitats,CD/paper,Rambla del Poblenou,Autor: El Periódico,07-03-1981",
		"/kunden/homepages/8/d228439513/htdocs/private/gallery/bulk/tmpk3XF_5/0033 L'Aliança 1981.jpg"))
	);
        $output = array();
        global $gallery;
        $gallery->debug_r($data);
        return array($error, $data, $output);
    }
    
    /**
     * Returns if a field contains a valid filename.
     *
     * @param $file_field File field to validate
     * @return boolean File validation. A readable non-directory returns true.
     */
    protected static function _validate_file($file_field)
    {
        global $gallery;
	$platform =& $gallery->getPlatform();
	
	$is_valid = ($platform->is_readable($file_field)
	    && !$platform->is_dir($file_field));
	    
	return $is_valid;
    }
    
    /**
     * Bulk upload code. Parses a CSV text.
     *
     * @param $data string CSV Input data
     * @param $basePath string Base path for the files in the CSV input data
     * @param $item object Item to upload entities to
     * @return array GalleryStatus, errors, warnings.
     */
    static function _bulkUpload($data, $basePath, &$item)
    {
	global $gallery;
	$platform =& $gallery->getPlatform();
	$status = $error = array();
 
	list ($ret, $module) = GalleryCoreApi::loadPlugin('module', 'bulkexcelupload');
	if ($ret) {
	    return array($ret, null, null);
	}
	/* Read header fields */
	$header = explode("\t", trim(array_shift($data)));
	$column_count = count($header);
	
	/* Read line by line */
	foreach ($data as $line) {
	    $warnings = array();
	    
	    $line = explode("\t", trim($line));
	    for ($i = 0; $i < $column_count; $i++) {
		$line[$header[$i]] = $line[$i];
	    }
	    
	    list ($_, $extension) =
		GalleryUtilities::getFileNameComponents(basename($line['filename']));
	    list ($ret, $mimeType) = GalleryCoreApi::convertExtensionToMime($extension);
	    if ($ret) {
		return array($ret, null, null);
	    }
	    
	    $fileName = $line['filename'];
	    if (!($fileName[0] == '/' || $fileName[0] == '\\')) {
		$fileName = dirname($basePath) . '/' . $fileName;
	    }
	    
	    if ($platform->is_readable($fileName)) {
		list ($ret, $newItem) = GalleryCoreApi::addItemToAlbum(
		    $fileName,
		    isset($line['title']) ? $line['title'] : '',
		    isset($line['title']) ? $line['title'] : '',
		    isset($line['summary']) ? $line['summary'] : '',
		    isset($line['description']) ? $line['description'] : '',
		    $mimeType,
		    $item->getId(),
		    false);
		if ($ret) {
		    return array($ret, null, null);
		}
		
		/* Set the keywords by hand, since we don't offer that in the API */
		if (!empty($line['keywords'])) {
		    list ($ret, $itemLockId) =
			GalleryCoreApi::acquireWriteLock($newItem->getId());
		    if ($ret) {
			return array($ret, null, null);
		    }
		    
		    list ($ret, $newItem) = $newItem->refresh();
		    if ($ret) {
			return array($ret, null, null);
		    }
		    
		    $newItem->setKeywords($line['keywords']);
		    $ret = $newItem->save();
		    if ($ret) {
			return array($ret, null, null);
		    }
		    
		    $ret = GalleryCoreApi::releaseLocks($itemLockId);
		    if ($ret) {
			return array($ret, null, null);
		    }
		}
		$newItemId = $newItem->getId();
	    } else {
		$newItemId = null;
		$warnings[] = $module->translate("File does not exist");
	    }
	    
	    $status['addedFiles'][] = array(
		'fileName' => GalleryCoreApi::convertToUtf8($fileName),
		'id' => $newItemId,
		'warnings' => $warnings);
	}
	return array(null, $error, $status);
    }
    
    /**
     * @see ItemAddPlugin::handleRequest
     *
     * Do not perform data validation. In case form data is not valid, raise
     * errors or exceptions.
     *
     */
    function handleRequest($form, &$item, &$addController) {
        global $gallery;
    
	// $gallery->debug( "linea: " );
 
	$status = $error = array();
	if (isset($form['action']['add'])) {
	    $gallery->debug_r($form);
	    
	    $file = array('name' => $form['name']['excelPath'],
		'type' => $form['type']['excelPath'],
		'tmp_name' => $form['tmp_name']['excelPath'],
		'size' => $form['size']['excelPath']);
	    
	    /**
	     * TODO: Read or not the Header
	     */
	    
	    list ($ret, $lockId) = GalleryCoreApi::acquireReadLock($item->getId());
	    if ($ret) {
		return array($ret, null, null);
	    }
	    
	    // Set default preview to true.
	    $debug = true;
	    /**
	     * Create CSV from excel and zip.
	     */
	    list ($ret, $data, $output) = ItemAddBulkExcelUpload::_createCsv
	    ($form['tmp_name']['excelPath'], $form['tmp_name']['zipPath'],
	    $form['readHeader'], $debug);
	    if ($ret) {
		return array($ret, null, null);
	    }
	    /**
	     * Bulk upload.
	     */
	    list($ret, $error, $status) = ItemAddBulkExcelUpload::_bulkUpload
	    ($data, $form['tmp_name']['excelPath'], $item);
	    if ($ret) {
		return array($ret, null, null);
	    }
	    
	    $ret = GalleryCoreApi::releaseLocks($lockId);
	    if ($ret) {
		return array($ret, null, null);
	    }
	}
	else {
	    $gallery->error( "no valid action" );
	}
	$gallery->debug( "returning from excel import... " );

	return array(null, $error, $status);
    }


    /**
     * @see ItemAdd:loadTemplate
     *
     * Validate field values.
     *
     */
    function loadTemplate(&$template, &$form, $item) {
        global $gallery;
        
	if ($form['formName'] != 'ItemAddBulkExcelUpload') {
	    $form['formName'] = 'ItemAddBulkExcelUpload';
	}
	
	if (array_key_exists('excelPath', $form)) {
	    $ret = self::_validate_file($form['excelPath']);
	    if (!$ret) {
		$form['error']['excelPath']['invalid'] = 1;
	    }
	}
	if (array_key_exists('zipPath', $form)) {
	    $ret = self::_validate_file($form['zipPath']);
	    if (!$ret) {
		$form['error']['zipPath']['invalid'] = 1;
	    }
	}
 
	if (empty( $form['readHeader'] )) {
	    $form['readHeader'] = 'on';
	}
 
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
    function getTitle() {
	list ($ret, $module) = GalleryCoreApi::loadPlugin('module', 'core');
	if ($ret) {
	    return array($ret, null);
	}

	return array(null, $module->translate('Bulk Excel Upload'));
    }
}



