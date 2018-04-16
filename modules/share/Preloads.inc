<?php
/*
 * Gallery - a web based photo album viewer and editor
 * Copyright (C) 2000-2008 Bharat Mediratta
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
 * @package Share
 * @author Karl Newman
 * @version $Revision: 1905 $
 */
class SharePreloads {
    function preload(&$template, $preload, $paramSet) {
	global $gallery;
	$itemId = GalleryUtilities::getRequestVariables('itemId');

	switch($preload) {
	case 'ShareBlock':
	    /* Get the thumbnail for the item */
	    list ($ret, $thumb) = GalleryCoreApi::fetchThumbnailsByItemIds(array($itemId));
	    if ($ret) {
		return array ($ret, null);
	    }
	    /* Add image_src link tag for Facebook preview image */
	    $urlgen = $gallery->getUrlGenerator();
	    if (array_key_exists($itemId, $thumb)) {
		$imgurl = $urlgen->generateUrl(array(
			'view' => 'core.DownloadItem',
			'itemId' => $thumb[$itemId]->getId(),
			'serialNumber' => $thumb[$itemId]->getSerialNumber()));
		$template->link(array('rel' => 'image_src', 'href' => $imgurl));
	    }
	    $template->head('modules/share/templates/ShareBlockHead.tpl');
	    return null;
	}

	return GalleryCoreApi::error(ERROR_BAD_PARAMETER);
    }
}
?>
