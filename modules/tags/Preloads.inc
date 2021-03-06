<?php
/*
 * Gallery - a web based photo album viewer and editor
 * Copyright (C) 2000-2007 Bharat Mediratta
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
 * @package Tags
 * @author  Eric Daniel <ehdaniel@gmail.com>
 * @version $Revision: 1235 $
 */
class TagsPreloads {
    function preload(&$template, $preload, $paramSet) {
	static $loaded;

	if (!empty($loaded[$preload])) {
	    return null;
	}
	
	if ($preload == 'TagLinks') {
	    global $gallery;
	    $urlGenerator =& $gallery->getUrlGenerator();

	    $loaded[$preload] = 1;
	    $template->style($urlGenerator->generateUrl(array('view' => 'tags.TagCloudCss')));
	}

	return null;
    }
}
?>
