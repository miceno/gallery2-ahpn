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
 * @version $Revision: 636 $ $Date: 2006-06-20 15:53:04 -0700 (Tue, 20 Jun 2006) $
 * @package Download
 * @author Jack Bates <ms419@freezone.co.uk>
 */

/**
 * Support HTTP compression, partial downloads & resuming using PEAR HTTP_Download package
 *
 * This enables MP3 players like Winamp to skip back & forward without buffering an entire file -
 * http://www.oreillynet.com/pub/a/network/2005/01/07/primetime.html
 *
 * @package Download
 */
class DownloadModule extends GalleryModule {

    function DownloadModule() {
	global $gallery;

	$this->setId('download');
	$this->setName($gallery->i18n('Download'));
	$this->setVersion('0.0.1');
	$this->setDescription($gallery->i18n('Support HTTP compression, partial downloads & resuming'));
	$this->setGroup('gallery', $gallery->i18n('Gallery'));
	$this->setRequiredCoreApi(array(7, 1));
	$this->setRequiredModuleApi(array(3, 0));
    }

    /**
     * @see GalleryModule::upgrade
     */
    function upgade($currentVersion) {

	switch ($currentVersion) {
	case null:

	    /* Initial install */

	case 'end of upgrade path':
	    break;

	default:
	    return GalleryCoreApi::error(ERROR_BAD_PLUGIN, __FILE__, __LINE__,
		sprintf('Unknown module version %s', $currentVersion));
	}
    }
}
?>
