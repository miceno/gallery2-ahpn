<?php
/*
 * $RCSfile: module.inc,v $
 *
 * Gallery - a web based photo album viewer and editor
 * Copyright (C) 2000-2005 Bharat Mediratta
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
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */
 
/**
 * 
 * @package LinksInTheHead
 * @author andrabr <n0tablog.wordpress.com>
 * @version $Revision: 1354 $ $Date: 2007/08/09 07:00:00 $
 */
 
/**
 * Add links to the header menu.
 *
 */
class LinksInTheHeadModule extends GalleryModule {

    function LinksInTheHeadModule() {
	global $gallery;		
	$this->setId('linksinthehead');
	$this->setName('Links In The Head');
	$this->setDescription($gallery->i18n('Add links to the header menu.'));
	$this->setVersion('0.1.2');
	$this->setGroup('data', $gallery->i18n('Extra Data'));
	$this->setCallbacks('getSystemLinks|getSiteAdminViews');
	$this->setRequiredCoreApi(array(7, 10));
	$this->setRequiredModuleApi(array(3, 0));
    }

    /**
     * @see GalleryModule::getSiteAdminViews
     */
    function getSiteAdminViews() {
	return array(null, array(array('name' => $this->translate('Links In The Head'),
							   'view' => 'linksinthehead.Admin')));
    }

    /**
     * @see GalleryModule::getSystemLinks
     */

    function getSystemLinks()
    {
	    $links = array();

        list ($ret,$links_in_the_head) = GalleryCoreApi::fetchAllPluginParameters('module', 'linksinthehead');
        if ($ret) {return array($ret->wrap(__FILE__, __LINE__), null);  }

        foreach ($links_in_the_head as $linkname => $redirectURL)
        {
            if (!(strpos($linkname,'_') === 0))
            {
            $links[$linkname] = array(
		    'text' => $this->translate($linkname),
            'params' => array('href' => $redirectURL));
            }
        }

	return array(null, $links);
    }

    /**
     * @see GalleryModule::getConfigurationView
     */
    function getConfigurationView() {
	return 'linksinthehead.Admin';
    }
}
?>
