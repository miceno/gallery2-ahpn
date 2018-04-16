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
 * @version $Revision: 13704 $ $Date: 2006-05-21 10:08:02 -0700 (Sun, 21 May 2006) $
 * @package ItemAdd
 * @subpackage UserInterface
 * @author Bharat Mediratta <bharat@menalto.com>
 */

/**
 * This controller will handle the addition of an item as a children to another item.
 *
 * @package ItemAdd
 * @subpackage UserInterface
 */
class ItemAddBulkItemUpdate extends ItemAddPlugin {

    /**
     * @see ItemAddPlugin::handleRequest
     */
    function handleRequest($form, &$item) {
        global $gallery;

        $status = $error = array();
        if (isset($form['action']['add'])) {
            if (empty($form['path'])) {
                $error[] = 'form[error][path]';
            }

            if ( empty($error)) {
                $platform =& $gallery->getPlatform();

                if (!$platform->is_readable($form['path'])) {
                    $error[] = 'form[error][path][invalid]';
                }
            }

            if ( empty($error)) {
                $data = $platform->file($form['path']);

                list ($ret, $lockId) = GalleryCoreApi::acquireReadLock($item->getId());
                if ($ret) {
                    return array($ret, null, null);
                }

                /*
                 * Get first line with the name of fields
                 */
                $fields = split("\t", trim(array_shift($data)));
                //echo "campo: '$fields[0]'";


                /*
                 * Read every line of the file
                 */
                $warnings= array();
                foreach ($data as $myline) {
                    /* Split the line and assign the resulting array to $line*/
                    $myline = split("\t", trim($myline));
                    // print_r( $myline);
                    // echo "<br/><hr/>";
                    for ($i = 0; $i < count($fields); $i++) {
                        $line[$fields[$i]] = $myline[$i];
                    }
                    // print_r( $line);
                    // echo "<br/><hr/>";

                    /* get Item ID by title */
                    $parent_id= $item->getId();
                    // TODO: use line['title'] instead of $line[0]
                    $my_title= $line['title'];
                    // print_r( $my_title);
                    // echo "<br/>";
                    /*
                    *   TODO: utilizar parent_id= $item->getId(); En realidad, esta funcion solo se 
                    *         deberia aplicar al album actual.
                    *   list($ret, $ids) = $this->getItemIdByTitle( $my_title, $parent_id);
                    *
                    */
                    list($ret, $ids) = $this->getItemIdByTitle( $my_title);
                    if ($ret) {
                        return array($ret, null, null);
                    }

                    if (empty($ids))
                    {
                        $gallery->debug( "title not found: $my_title");
                        $warnings[]= "Title not found: $my_title";
                        continue;
                    }

                    if ( count($ids) > 1)
                    {
                        /* TODO */
                        /* issue a warning and show all returned ids */
                        $gallery->debug( "More than one title for: $my_title");
                        $warnings[]= "More than one title for: $my_title";
                        $gallery->debug_r( $ids);
                    }

                    $my_id=$ids[0][0];

                    /* TODO: Update $item */
                    updateItem( $my_id, $line, $ids[0][1]);
                    // if ($ret) {
                    // TODO: In case of success: releaseLocks

                    $status['updateEntry'][] = array(
                        'title' => $my_title,
                        'id' => $my_id,
                        'warnings' => $warnings);
                } /* foreach $data */

                $ret = GalleryCoreApi::releaseLocks($lockId);
                if ($ret) {
                    return array($ret, null, null);
                }
            }/* if emtpy */
        }/* if issset */

        return array(null, $error, $status);
    }


    /**
     * @see ItemAdd::loadTemplate
     */
    function loadTemplate(&$template, &$form, $item) {
        if ($form['formName'] != 'ItemAddBulkItemUpdate') {
            $form['formName'] = 'ItemAddBulkItemUpdate';
        }

        return array(null,
                     'modules/bulkitemupdate/templates/ItemAddBulkItemUpdate.tpl',
                     'modules_bulkitemupdate');
    }

    /**
     * @see ItemAddPlugin::getTitle
     */
    function getTitle() {
        list ($ret, $module) = GalleryCoreApi::loadPlugin('module', 'core');
        if ($ret) {
            return array($ret, null);
        }

        return array(null, $module->translate('Bulk Item Update'));
    }


   /**
     * @see ItemAdd::loadTemplate
     * Get ItemId by Title
     * @param string $title
     * @return array of item ids
     */

    function getItemIdByTitle( $title, $parent_id=null)
    {
    /* TODO: use $parent_id to get only the elements whole $title is inside
             a $parent_id.
     */
        global $gallery;

         $query = "SELECT
                         [GalleryItem::id],
                         [GalleryItem::title]
                         FROM [GalleryItem]
                         WHERE
                         [GalleryItem::title]
                         LIKE ?
                         ORDER BY [GalleryItem::id]
                         ";
         // echo "query: ";
         // print_r( $query);
         // echo "<br/>";

         list($ret, $searchResults) = $gallery->search($query, array( "%$title%" ));
         if ($ret) {
                        return array($ret, array());
         }

         $results = array();
         while ($result = $searchResults->nextResult()) {
                     $results[]=array($result[0], $result[1]);
                     /* We are only interested in the first result */
         }
         if (empty($results))
             return array(null, array());

         // TODO: Limit the search to a selected album (the parent_id)
         // Hemos encontrado el elemento.
         if ( $parent_id)
         {
             // Search for the parent of the found item
             list($ret, $parents)= GalleryCoreApi::fetchParentSequence( $results[0]);
             if ($ret) return array($ret, array());
             if (!in_array( $parents, $parent_id))
                return array(null, array());
             $results= $parents;
         }

         return array(null, $results);
    }

}


/*
 *
 * result: array (return code, item)
 *
 *
*/
function updateItem( $id, $line, $mytitle="")
{
  global $gallery;

  $gallery->debug( "linea:");
  $gallery->debug_r( $line);
  list ($ret, $item) = GalleryCoreApi::loadEntitiesById($id);

  if ($ret) {
    return array( $ret, null);
  }

  /* Lock the element */
  list ($ret, $itemLockId) = GalleryCoreApi::acquireWriteLock( $id);
  if ($ret) {
    return array($ret, null);
  }

  // $item = (array)$itemObj;

  // For each field name proceed accordingly
  foreach ( $line as $key => $value )
  {
     $gallery->debug( "setting $key for $mytitle [$id]");
     switch ($key)
     {
        case 'title': 
          // $item->setTitle( $value);
          // TODO: allow changing titles: it requires that another key is used instead (like the ids).
          $gallery->debug( "Title is not allowed to change... by now");
          break;
        case 'summary': 
          $item->setSummary( $value);
          break;
        case 'keywords': 
          $item->setKeywords( $value);
          break;
        case 'description': 
          $item->setDescription( $value);
          break;
        default:
          /* TODO: Fetch Customfields */
          // CustomFieldHelper::saveFieldValues( $my_id, $line);

          $gallery->debug( "Unknown update field: $key");
          break;
     } // switch
  } // foreach

  $ret = $item->save();

  // Release the lock, should the item get updated or not
  $ret= GalleryCoreApi::releaseLocks($itemLockId);
  if ($ret) {
      return array($ret, null);
  }
  return array( null, $item);

}

/*
 *    list ($ret, $itemLockId) =
 *        GalleryCoreApi::acquireWriteLock($newItem->getId());
 *    if ($ret) {
 *        return array($ret, null, null);
 *    }
 *
 *    list ($ret, $newItem) = $newItem->refresh();
 *    if ($ret) {
 *        return array($ret, null, null);
 *    }
 *
 *    $newItem->setKeywords($line['keywords']);
 *    $ret = $newItem->save();
 *    if ($ret) {
 *        return array($ret, null, null);
 *    }
 *
 *    $ret = GalleryCoreApi::releaseLocks($itemLockId);
 *    if ($ret) {
 *        return array($ret, null, null);
 *    }
 *
 *
*/

?>

