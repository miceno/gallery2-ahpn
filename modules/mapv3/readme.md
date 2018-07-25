Map v3
======

This plugin is an partial update of code from map plugin in order to support Google 
Maps v3.

Additional features
===================

In addition, I included new features:

* Lazy load of images.
* Support for responsive themes.

How to upgrade
==============

1. make a backup of database and source code
2. export table g2_mapMap -> export-map.sql
3. manually edit export-map.sql and 
   *  replace references to mapMap by mapv3Map
4. download the zip file of the new repo.
5. deploy code from new repo.
6. navigate to admin site and check everything is working.
    6.1. It will redirect you to Gallery Upgrader.
7. activate new module mapv3 (it creates new tables).
8. import export-map.sql in table mapv3Map.
9. copy map configuration to mapv3: INSERT INTO g2_PluginParameterMap (g_pluginType,g_pluginId, g_itemId, g_parameterName,g_parameterValue)
SELECT 
'module' as g_pluginType,
'mapv3' as g_pluginId, 
g_itemId,
g_parameterName,
g_parameterValue
FROM g2_PluginParameterMap
where g_pluginId='map';
11. Deactivate and uninstall module 'map'.
12. Activate and configure module 'mapv3'
13. Remove Icons module.
13. Manually review new inserted data to make sure 'mapMap' is substituted by 'mapv3Map'. ATTENTION: substitution is not enough, you should review the size of string since it uses PHP serialization.
14. Get new API key for mapv3 and add it to the map admin profiles.
15. Update all the control position *Pos parameters of the mapv3 plugin: I updated the labels from numbers to texts.
16. Update Map link on the "Links in the Head", it should have "mapv3".
17. Configure Global Theme
   18. adjust blocks
   19. set block layout to right.
19. manually copy the Routes folder: 
    * cp -r modules/map/images/routes modules/mapv3/images
17. Open Site admin -> URL Rewrite and save the configuration to force a rewrite of the rules file.
18. Regenerate thumbnails at 300 px.
	* Change size of thumbnail at root album configuration.
	* Propagate change to subalbums.
19. Verification: navigate to the site
20. Review "Migracion gallery" note for regenerate images and derivatives. 
21. Review plugin list and deactive/uninstall:
    * Bulk Item Update
    * Nokia Upload
    * Upload Applet
    * Windows Publishing Wizard
    * Add via Email
    * webdav
    * remote
    * All not used themes.

CHANGELOG
=========

* 0.6: 
	* Lazy load of images.
	* Support for responsive themes.
	
TODO
====

* Improve loading performance.	
* Refactor MarkerSets Feature,
* Refactor Legend Feature.	
* Refactor Filter Feature.	
* Refactor Group Feature.	
* Refactor Route Feature.
* Remove all obsolete code (GZoom, controls, etc.).
