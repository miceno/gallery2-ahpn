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
    private static function _createCsv($excelPath, $zipPath, $debug)
    {
        // TODO: implement create csv code.
        $error = null;
        $data = array();
        return array($error, $data);
    }
    
    /**
     * @param $form
     * @param $error
     * @param $gallery
     * @param $platform
     * @return array
     */
    protected static function _validate_file($form, $field)
    {
	global $gallery;
 
	$error = array();
	if (empty($form[$field])) {
	    $error = "form[error][$field]";
	}
	
	if (is_null($error)) {
	    $platform =& $gallery->getPlatform();
	    
	    if (!$platform->is_readable($form[$field])) {
		$error = "form[error][$field][invalid]";
	    }
	}
	return $error;
    }
    
    /**
     * Bulk upload code. Parses a CSV text.
     *
     * @param $data string CSV Input data
     * @param $basePath string Base path for the files in the CSV input data
     * @param $item object Item to upload entities to
     * @return array GalleryStatus
     */
    static function _bulkUpload($data, $basePath, &$item)
    {
	global $gallery;
	$platform =& $gallery->getPlatform();
	$status = $error = array();
 
	$fields = str_split("\t", trim(array_shift($data)));
	$count = count($fields);
	foreach ($data as $line) {
	    $line = str_split("\t", trim($line));
	    for ($i = 0; $i < $count; $i++) {
		$line[$fields[$i]] = $line[$i];
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
	    }
	    
	    $status = array(
		'fileName' => GalleryCoreApi::convertToUtf8($fileName),
		'id' => $newItemId,
		'warnings' => array());
	}
	return array(null, $error, $status);
    }
    
    /**
     * @see ItemAddPlugin::handleRequest
     */
    function handleRequest($form, &$item, &$addController) {
	$status = $error = array();
	if (isset($form['action']['add'])) {
	    
	    /**
	     * Check for the excel file.
	     */
	    $error = self::_validate_file($form, 'excelPath');
	    if (!is_null($error)) {
		return array(null, $error, $status);
	    }
	    
	    /**
	     * Check for the zip file.
	     */
	    $error = self::_validate_file($form, 'zipPath');
	    if (!is_null($error)) {
		return array(null, $error, $status);
	    }
	    
	    // Read Excel file
	    // Read zip file
	    // Transform Excel data into CSV data for bulkupload
	    // Call bulkupload with csv file
	    
	    list ($ret, $lockId) = GalleryCoreApi::acquireReadLock($item->getId());
	    if ($ret) {
		return array($ret, null, null);
	    }
	    
	    // Set default preview to true.
	    $debug = true;
	    // Create CSV from excel and zip.
	    list ($ret, $data, $output) = ItemAddBulkExcelUpload::_createCsv
	    ($form['excelPath'], $form['zipPath'], $debug);
	    if ($ret) {
		return array($ret, null, null);
	    }
	    $ret = ItemAddBulkExcelUpload::_bulkUpload($data, $item);
	    if ($ret) {
		return array($ret, null, null);
	    }
	    
	    $ret = GalleryCoreApi::releaseLocks($lockId);
	    if ($ret) {
		return array($ret, null, null);
	    }
	}

	return array(null, $error, $status);
    }


    /**
     * @see ItemAdd:loadTemplate
     */
    function loadTemplate(&$template, &$form, $item) {
	if ($form['formName'] != 'ItemAddBulkExcelUpload') {
	    $form['formName'] = 'ItemAddBulkExcelUpload';
	}
	if (empty( $form['excelPath'] )) {
            list ($_, $_, $listDir) = fetchListDirectories();
	    $form['excelPath'] = $listDir[0];
	}

	if (empty( $form['zipPath'] )) {
            list ($_, $_, $listDir) = fetchListDirectories();
	    $form['zipPath'] = $listDir[0];
	}

	return array(null,
		     'modules/bulkexcelupload/templates/ItemAddBulk.tpl',
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

function fetchListDirectories(){
        list ($ret, $param) = GalleryCoreApi::fetchAllPluginParameters('module',
 'itemadd');
        if ($ret) {
            return array($ret, null, null);
        }
        $localServerDirList = array();
        $localServerDirListInSystemCharset = array();
        for ($i = 1; !empty($param['uploadLocalServer.dir.' . $i]); $i++) {
            $localServerDirList[] = $param['uploadLocalServer.dir.' . $i];
            $localServerDirListInSystemCharset[] =
                GalleryCoreApi::convertFromUtf8($param['uploadLocalServer.dir.'
. $i]);
        }                                                     
        return array(null, $localServerDirList, $localServerDirListInSystemCharset);
}


