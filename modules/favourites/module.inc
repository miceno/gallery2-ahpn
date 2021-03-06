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
 * @package Favourites
 * @author Alec Myers <alec@alecmyers.com>
 * @version $Revision: 1372 $
 */

 
class FavouritesModule extends GalleryModule {


    function FavouritesModule() {
	global $gallery;
	$this->setId('favourites');
	$this->setName($gallery->i18n('Favorites'));
	$this->setDescription($gallery->i18n('Stores and displays registered users favorite items'));
	$this->setVersion('0.2.4');
	$this->setGroup('display', $gallery->i18n('Display'));
	$this->setCallbacks('registerEventListeners|getItemLinks|getSystemLinks|getSiteAdminViews');
	$this->setRequiredCoreApi(array(7, 2));
	$this->setRequiredModuleApi(array(3, 0));
    }

    
   /**
     * @see GalleryModule::upgrade
     */
    
   function upgrade($currentVersion) {
	list ($ret, $params) = GalleryCoreApi::fetchAllPluginParameters('module', 'favourites');
	if ($ret) {
	    return $ret;
	}
	foreach (array('themeId' => '', 'offerToGuests' => 1)
		as $key => $value) {
	    if (!isset($params[$key])) {
		$ret = $this->setParameter($key, $value);
		if ($ret) {
		    return $ret;
		}
	    }
	}
	if (!isset($params['themeSettingsId'])) {
	    list ($ret, $entity) =
		GalleryCoreApi::newFactoryInstance('GalleryEntity', 'GalleryEntity');
	    if ($ret) {
		return $ret;
	    }
	    if (!isset($entity)) {
		return GalleryCoreApi::error(ERROR_MISSING_OBJECT, __FILE__, __LINE__,
					     'Unable to get a GalleryEntity instance');
	    }
	    $ret = $entity->create();
	    if ($ret) {
		return $ret;
	    }
	    $ret = $entity->save(false);
	    if ($ret) {
		return $ret;
	    }
	    $ret = $this->setParameter('themeSettingsId', $entity->getId());
	    if ($ret) {
		return $ret;
	    }
	}
	return null;
    }
    
    
   /**
     * @see GalleryModule::registerEventListeners
     */
    function registerEventListeners() {
	GalleryCoreApi::registerEventListener('GalleryEntity::delete', new FavouritesModule());
    }

    /**
     * @see GalleryModule::getItemLinks()
     */
    function getItemLinks($items, $wantsDetailedLinks, $permissions) {
	global $gallery;
	GalleryCoreApi::requireOnce('modules/favourites/classes/FavouritesMapHelper.class');
	$userId = $gallery->getActiveUserId();
 
	
	/*show to guest user for tantalisation purposes?*/
	list ($ret, $params) = GalleryCoreApi::fetchAllPluginParameters('module', 'favourites');
	if ($ret) {
	    return array ($ret,null);
	}
	list ($ret, $anonId) = GalleryCoreApi::getAnonymousUserId();
	if ($ret) {
	     return array ($ret,null);
	}
	if (!$params['offerToGuests'] && ($userId == $anonId)) {
	    return array (null, array());
	}
	$viewingFavourites = false;
	if ('favourites.FavouritesAlbum' == $gallery->getCurrentView()) {
	    $viewingFavourites = true;
	}
	$links = array();
	foreach ($items as $item) {
            
	    /*no link for album items
            if ($item->getCanContainChildren()) {
	        continue;
    	    }*/
	    $itemTypeNames = $item->itemTypeName();
	    $itemId = $item->getId();
	    
	    list ($ret, $alreadyFave) = FavouritesMapHelper::isFavourite($userId,$itemId);
	    if ($ret) {
		return array ($ret, null);
	    }
	    if ($alreadyFave) {
	    	$links[$item->getId()][] =
		  		  array('text' => $this->translate(array('text' => 'Remove %s From Favorites',
									   'arg1' => $itemTypeNames[0])),
		       			    'params' => array('controller' => 'favourites.AddFavourite',
					    'itemId' => $itemId,
					    'command' => 'remove',
					    'return' => 1));
  	    } else   {
	  	$links[$item->getId()][] =
		  		  array('text' => $this->translate(array('text' => 'Add %s To Favorites',
									   'arg1' => $itemTypeNames[0])),
		       			    'params' => array('controller' => 'favourites.AddFavourite',
					    'itemId' => $itemId,
					    'command' => 'add',
					    'return' => 1));
  
	    }
	}
	if ($viewingFavourites) {
		$links[null][] = array('text' => $this->translate(array('text' => 'Clear Favorites')),
		       			    'params' => array('controller' => 'favourites.AddFavourite',
					    'command' => 'clear',
					    'return' => 1));
	}
	return array(null, $links);
    }

    /**
     * @see GalleryModule::getSystemLinks
     */

    function getSystemLinks() {
	global $gallery;
	$links = array();
	GalleryCoreApi::requireOnce('modules/favourites/classes/FavouritesMapHelper.class');
	$userId = $gallery->getActiveUserId();
	list ($ret, $anonymousUserId) = GalleryCoreApi::getAnonymousUserId();
	if ($ret) {
	    return array ($ret, null);
	}
	/* don't offer to show favourites to guests */
	if ($userId == $anonymousUserId) {
	   return array(null, $links);
	}
	/* don't offer to show favourites if there aren't any for this user */
	GalleryCoreApi::requireOnce('modules/favourites/classes/FavouritesMapHelper.class');
	list ($ret,$favourites) = FavouritesMapHelper::fetchFavourites($userId);
	if ($ret) {
	    return array($ret, null);
	}
	if (count($favourites)) {
	    $links['Favourites'] = array(
		'text' => $this->translate('Favorites'),
		'params' => array('view' => 'favourites.FavouritesAlbum' )	);
	}
	return array(null, $links);
    }

    /**
     * @see GalleryModule::getSiteAdminViews
     */
    function getSiteAdminViews() {
	return array(null, array(array('name' => $this->translate('Favorites'),
				       'view' => 'favourites.FavouritesSiteAdmin')));
    }
    /**
     * Event Handler: get rid of any favourites for items that are deleted
     *
     * @see GalleryEventListener::handleEvent
     */
    function handleEvent($event) {
	GalleryCoreApi::requireOnce('modules/favourites/classes/FavouritesMapHelper.class');
	$data = $event->getData();

	if ($event->getEventName() == 'GalleryEntity::delete') {
	    $entity = $event->getEntity();
	    if (GalleryUtilities::isA($entity, 'GalleryItem')) {
	    	FavouritesMapHelper::clearFavourites($entity->getId());
	    }
	}
	return array(null, null);
    }
    
    function getRewriteRules() {
	return array(
      		array('comment' => $this->translate('Favorites Album'),
		      'match' => array('view' => 'favourites.FavouritesAlbum'),
		      'pattern' => 'favourites$',
		      'help' => $this->translate('Shortest URL for album of Favorite Items')
		      ),
		      
		      	array('comment' => $this->translate('Favorites Album'),
		      'match' => array('view' => 'favourites.FavouritesAlbum'),
		      'pattern' => 'favourites/%targetUserId%',
		      'keywords' => array(	'targetUserId' => array( 'pattern' => '([0-9]+)$', 'ignored' => 0 )	),
		      'help' => $this->translate('Shorter URL for album of Favorite Items')
		      ) ,

		array('comment' => $this->translate('Favorites Album'),
		      'match' => array('view' => 'favourites.FavouritesAlbum'),
		      'pattern' => 'favourites/%targetUserId%/%page%',
		      'keywords' => array(	'targetUserId' => array( 'pattern' => '([0-9]+)', 'ignored' => 0 ),
		      				'page' => array(   'pattern' => '([0-9]+)', 'ignored' => 0 ) 	),
		      'help' => $this->translate('Short URL for album of Favorite Items')
		      )
	
		
		     );
    }
      
		     
}
?>
