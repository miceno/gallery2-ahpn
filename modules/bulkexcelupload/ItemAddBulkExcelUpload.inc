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
 * This controller will handle the addition of an item as a children to another item.
 *
 * @package ItemAdd
 * @subpackage UserInterface
 */
class ItemAddBulkExcelUpload extends ItemAddPlugin
{
    
    public static $MAX_SUMMARY = 100;
    
    /**
     * @param $zipFile
     * @return array
     */
    protected static function _readZip($zipFile)
    {
	$zipFiles = array();
	$za = new ZipArchive();
	if ($za->open($zipFile) == true) {
	    for ($i = 0; $i < $za->numFiles; $i++) {
		$zipFiles[] = $za->getNameIndex($i);
	    }
	} else {
	    return array(GalleryCoreApi::error(ERROR_PLATFORM_FAILURE,
		null, null, "Bad zip file."), null);
	}
	return $zipFiles;
    }
    
    private static function _readExcel($tmp_name)
    {
	return array();
    }
    
    /**
     * @param $zipPath
     * @param $basePath
     * @param $debug
     */
    private static function _expandZip($zipPath, $basePath, $debug)
    {
	global $gallery;
	
	if ($basePath == null) {
	    $basePath = '.';
	}
	$za = new ZipArchive();
	$ret = null;
	if ($za->open($zipPath) == TRUE) {
	    $ret = $za->extractTo($basePath);
	    if ($ret == TRUE) {
		$gallery->debug("ZIP file extracted to $basePath.");
		$ret = null;
	    } else {
		$gallery->debug("Error ($ret) extracting file $zipPath.");
	    }
	}
	$za->close();
	return $ret;
    }
    
    /**
     * Create a TSV file suitable for import.
     *
     * @param $rows array Excel rows.
     * @param $files array Image file list. Images should
     * be in the same order as they appear on the excel file.
     * @param $basePath string Base path for the output images file.
     * @param $hasHeader boolean Excel file will have a header row.
     * @param $delimiter string File delimiter.
     * @param $debug boolean Activate debug or verbose mode.
     * @return array Returns TSV rows.
     */
    private static function _createDelimitedData($rows, $files,
						 $basePath, $hasHeader,
						 $delimiter,
						 $debug)
    {
	if ($delimiter == null) {
	    $delimiter = "\t";
	}
	if (true) {
	    // TODO: implement create csv code.
	    $error = null;
	    $data = array(
		/* Header */
		join($delimiter, array("title", "summary", "description", "keywords",
		    "filename")),
		join($delimiter, array("0001 L'Aliança [1900]",
		    "Façana del primitiu edifici de la Societat L'Aliança",
		    "Façana del primitiu edifici de la Societat L'Aliança.",
		    "1,3.1,Entitats,CD/paper,Wad - Ras,Autor: Desconegut,[1900]",
		    "/var/www/vhosts/fotos-ssl.arxiuhistoricpoblenou.cat/gallery2-data/tmp/excelupload.dir/0001 L'Aliança [1900].jpg")),
		join($delimiter, array("0033 L'Aliança 1981",
		    "Ball al Casino de L'Aliança",
		    "Ball al Casino de L' Aliança.",
		    "33,3.1.1,Entitats,CD/paper,Rambla del Poblenou,Autor: El Periódico,07-03-1981",
		    "/var/www/vhosts/fotos-ssl.arxiuhistoricpoblenou.cat/gallery2-data/tmp/excelupload.dir/0033 L'Aliança 1981.jpg"))
	    );
	} else {
	    /**
	     *
	     * 1. Output header
	     * 2. For each row and file
	     * 2.2. format row
	     * 2.3. output csv row
	     */
	    
	    /* 1. Output header */
	    $HEADER = array("title", "summary", "description", "keywords", "filename");
	    $data[] = $HEADER;
	    
	    for ($i = 0; $i < count($rows) - 1; $i++) {
		$current_file = $files[$i];
		$current_row = $rows[$i];
		
		/* 2.2. Format row */
		/* */
		// Initialize empty array for the output line.
		$data_line = array();
		
		// Title is the file name without the extension
		$title = $current_file;
		$data_line[] = $title;
		
		// Summary is a summary of the description column of the excel
		// file. We summarize the description to provide a shorter text.
		$summary = $current_row['description'];
		$data_line[] = substr($summary, 0,
		    ItemAddBulkExcelUpload::$MAX_SUMMARY);
		
		// Description is the description column of the excel file.
		// We summarize the description to provide a shorter text.
		$description = $current_row['description'];
		$data_line[] = $description;
		
		/**
		 * Keywords include:
		 * 1. the image reference number.
		 * 2. the folder code.
		 * 3. the folder code name.
		 * 4. the terms.
		 * 5. the kind of media of the image.
		 * 6. the place the image shows.
		 * 7. the author.
		 *
		 */
		$folder_number = $current_row['folder'];
		$keywords = array($current_row['number'],
		    $current_row['folder'],
		    getFolderName($folder_number),
		    $current_row['terms'],
		    $current_row['media'],
		    $current_row['place'],
		    "Autor: " . $current_row['author'],
		    getDateFromExcel($current_row['date'])
		);
		$data_line[] = join($delimiter, $keywords);
		
		// Add the file with the base path.
		$image_path = $basePath . $current_file;
		$data_line[] = $image_path;
		
		$data[] = $data_line;
	    }
	}
	if ($debug) {
	    global $gallery;
	    $gallery->debug("Output data for createDelimitedFile");
	    $gallery->debug_r($data);
	}
	
	return $data;
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
	
	$gallery->debug('Bulk upload processing...');
	
	list ($ret, $module) = GalleryCoreApi::loadPlugin('module', 'bulkexcelupload');
	if ($ret) {
	    return array($ret, null, null);
	}
	/* Read header fields */
	$header = explode("\t", trim(array_shift($data)));
	$column_count = count($header);
	
	/* Read line by line */
	foreach ($data as $line) {
	    $gallery->debug("Reading header...");
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
		$gallery->debug("About to add the Item: " . join(", ", array(
			$fileName,
			$line['title'],
			$line['summary'],
			$line['description'],
			$mimeType,
			$item->getId())));
		
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
		
		$gallery->debug("Set the keywords by hand, since we don't offer that in the API: " . $line['keywords']);
		
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
		// 'fileName' => GalleryCoreApi::convertToUtf8($fileName),
		'fileName' => basename($fileName),
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
    function handleRequest($form, &$item, &$addController)
    {
	global $gallery;
	$platform =& $gallery->getPlatform();
	
	// $gallery->debug( "linea: " );
	
	$status = $error = array();
	if (isset($form['action']['add'])) {
	    $gallery->debug_r($form);
	    
	    $excelFile = array('name' => $form['name']['excelPath'],
		'type' => $form['type']['excelPath'],
		'tmp_name' => $form['tmp_name']['excelPath'],
		'size' => $form['size']['excelPath']);
	    
	    $zipFile = array('name' => $form['name']['zipPath'],
		'type' => $form['type']['zipPath'],
		'tmp_name' => $form['tmp_name']['zipPath'],
		'size' => $form['size']['zipPath']);
	    
	    $hasHeader = $form['readHeader'];
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
	    $rows = ItemAddBulkExcelUpload::_readExcel($excelFile['tmp_name']);
	    
	    /**
	     * Read list of files in zip
	     */
	    $fileNames = self::_readZip($zipFile['tmp_name']);
	    
	    /**
	     * Create CSV from excel and zip.
	     */
	    $data = ItemAddBulkExcelUpload::_createDelimitedData($rows,
		$fileNames, $baseTmpPath, $hasHeader, null, $debug);
	    
	    /**
	     * Uncompress ZIP file.
	     */
	    $ret = ItemAddBulkExcelUpload::_expandZip
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
	    
	    list($ret, $error, $status) = ItemAddBulkExcelUpload::_bulkUpload($data, $baseTmpPath, $item);
	    if ($ret) {
		return array($ret, null, null);
	    }
	    
	    $ret = GalleryCoreApi::releaseLocks($lockId);
	    if ($ret) {
		return array($ret, null, null);
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
	
	if (empty($form['readHeader'])) {
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
    function getTitle()
    {
	list ($ret, $module) = GalleryCoreApi::loadPlugin('module', 'core');
	if ($ret) {
	    return array($ret, null);
	}
	
	return array(null, $module->translate('Bulk Excel Upload'));
    }
}

function getFolderName($code)
{
    return "FOLDER-CODE-PENDING $code";
}


/**
 * @param $date_value
 */
function getDateFromExcel($date_value)
{
    $date = $date_value;
    /**
     *
     * value = row[ self.DATE ].value
     * if row[ self.DATE ].ctype == xlrd.XL_CELL_DATE:
     * date_tuple = xlrd.xldate_as_tuple( row[ self.DATE ].value, MODE_1900 )
     * date_string = self.tupledate_to_isodate( date_tuple )
     * elif row[ self.DATE ].ctype == xlrd.XL_CELL_TEXT:
     * # It is a year as a number or as a text
     * date_string = value
     * elif row[ self.DATE ].ctype == xlrd.XL_CELL_NUMBER:
     * # It is a year as a number or as a text
     * date_string = str( int( value ) )
     */
    return $date;
}
