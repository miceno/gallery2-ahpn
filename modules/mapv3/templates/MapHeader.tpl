{*
 * $Revision: 1264 $
 * Read this before changing templates!  http://codex.gallery2.org/Gallery2:Editing_Templates
 *}
{* Custom navigation needs a IE .png fix
{if (isset($mapv3.MapControlType))}
  {if $mapv3.MapControlType neq "None" and $mapv3.MapControlType neq "Small" and $mapv3.MapControlType neq "Large"}
    <style type="text/css">
    .themap img {ldelim}
    behavior: url("{g->url href="modules/mapv3/pngbehavior.htc"}");
    {rdelim}
    </style>
  {/if}
{/if}  *}
<style type="text/css">
a {ldelim}overflow: hidden;{rdelim}
a:hover {ldelim} outline: none; {rdelim}
</style>
{include file="modules/mapv3/includes/GoogleMap.css"}
<!-- Google Maps script -->
{if isset($mapv3.googleMapKey) and $mapv3.googleMapKey neq 'f'}
<script src="//maps.googleapis.com/maps/api/js?file=api&amp;v=3&amp;key={$mapv3.googleMapKey}"
            type="text/javascript"></script>

<script src="{g->url href="modules/mapv3/GoogleMap.js"}" type="text/javascript"></script>
<!-- This is mostly boilerplate code from Google. See: http://www.google.com/apis/maps/documentation/ -->

<script type="text/javascript">
    //<![CDATA[

    var DEBUGINFO = 1; //set to 1 to view the Glog, 0 otherwise
    var controlname = "{$mapv3.MapControlType}";

    {if $mapv3.mode eq "Normal" and isset($mapv3.ThumbBarPos) and $mapv3.ThumbBarPos neq "0" and $mapv3.fullScreen neq 3}
    /* initialize some variable for the sidebar */
    var sidebarheight = {$mapv3.ThumbHeight+4};
    {* Should this be ThumbWidth? *}
    var sidebarwidth = {$mapv3.ThumbHeight+4};
    {/if}
    var sidebarhtml = '';
    var sidebarsize = 0;

    //Create the Map variable to be used to store the map infos
    var map;
    //Variable for the google map so that we can get it translated
    var _mSiteName = '{g->text text="Google Local" forJavascript=true}';
    var _mZoomIn = '{g->text text="Zoom In" forJavascript=true}';
    var _mZoomOut = '{g->text text="Zoom Out" forJavascript=true}';
    var _mZoomSet = '{g->text text="Click to set zoom level" forJavascript=true}';
    var _mZoomDrag = '{g->text text="Drag to zoom" forJavascript=true}';
    var _mPanWest = '{g->text text="Go left" forJavascript=true}';
    var _mPanEast = '{g->text text="Go right" forJavascript=true}';
    var _mPanNorth = '{g->text text="Go up" forJavascript=true}';
    var _mPanSouth = '{g->text text="Go down" forJavascript=true}';
    var _mLastResult = '{g->text text="Return to the last result" forJavascript=true}';
    var _mGoogleCopy = '{g->text text="(c)2007 Google" forJavascript=true}';
    var _mDataCopy = '{g->text text="Map data (c)2007 " forJavascript=true}';
    var _mNavteq = '{g->text text="NAVTEQ(tm)" forJavascript=true}';
    var _mTeleAtlas = '{g->text text="Tele Atlas" forJavascript=true}';
    var _mZenrin = '{g->text text="ZENRIN" forJavascript=true}';
    var _mZenrinCopy = '{g->text text="Map (c)2007 " forJavascript=true}';
    var _mNormalMap = '{g->text text="Map" forJavascript=true}';
    var _mNormalMapShort = '{g->text text="Map" hint="Short form for Map" forJavascript=true}';
    var _mHybridMap = '{g->text text="Hybrid" forJavascript=true}';
    var _mHybridMapShort = '{g->text text="Hyb" hint="Short form for Hybrid" forJavascript=true}';
    var _mNew = '{g->text text="New!" forJavascript=true}';
    var _mTerms = '{g->text text="Terms of Use" forJavascript=true}';
    var _mKeyholeMap = '{g->text text="Satellite" forJavascript=true}';
    var _mKeyholeMapShort = '{g->text text="Sat" hint="Short form for Satellite" forJavascript=true}';
    var _mKeyholeCopy = '{g->text text="Imagery (c)2007 " forJavascript=true}';
    var _mScale = '{g->text text="Scale at the center of the map" forJavascript=true}';
    var _mKilometers = '{g->text text="km" forJavascript=true}';
    var _mMiles = '{g->text text="mi" forJavascript=true}';
    var _mMeters = '{g->text text="m" forJavascript=true}';
    var _mFeet = '{g->text text="ft" forJavascript=true}';
    var _mDecimalPoint = '{g->text text="." hint="Decimal point" forJavascript=true}';
    var _mThousandsSeparator = '{g->text text="," hint="Thousands separator" forJavascript=true}';
    var _mMapErrorTile = "{g->text text="We are sorry, but we don't have maps at this zoom level for this region. Try zooming out for a broader look." forJavascript=true}";
    var _mKeyholeErrorTile = "{g->text text="We are sorry, but we don't have imagery at this zoom level for this region. Try zooming out for a broader look." forJavascript=true}";
    var _mTermsURL = '{g->text text="https://www.google.com/intl/en_ALL/help/terms_local.html" forJavascript=true}';
    var _mStaticPath = '{g->text text="https://www.google.com/intl/en_ALL/mapfiles/" forJavascript=true}';
    var _mDomain = '{g->text text="google.com" forJavascript=true}';
    var _mApiBadKey = '{g->text text="The Google Maps API key used on this web site was registered for a different web site. You can generate a new key for this web site at http://www.google.com/apis/maps/" forJavascript=true}';
    
    var _divhistorytext = '{g->text text="Move history" forJavascript=true}:'
    var _movetext = '{g->text text="move" forJavascript=true}';
    var _zoomtext = '{g->text text="zoom" forJavascript=true}';
    var _starttext = '{g->text text="start" forJavascript=true}';
    var _windowtext = '{g->text text="window" forJavascript=true}';



    //Functions for the PAN & Zoom Custom controls
    var ZoomOut; //this needs to be global to enable the Map type to change it :-)
    var ZoomSlide = [];

    // ===== Show and Hide markers =====
    function markerDisplay(number,show,type) {ldelim}
      if (type != 'Regroup'){ldelim}
        if ((show) && (!markers[number].onmap)) {ldelim}
           if (DEBUGINFO) console.debug('Normal Icon,show,'+number);
           markers[number].onmap = true;
           map.addOverlay(markers[number]);
        {rdelim}
        if ((!show) && (markers[number].onmap)) {ldelim}
           if (DEBUGINFO) console.debug('Normal Icon,hide,'+number);
           markers[number].onmap = false;
           map.removeOverlay(markers[number]);
        {rdelim}
      {rdelim}else{ldelim}
        if ((show) && (!Rmarkers[number].onmap)) {ldelim}
           if (DEBUGINFO) console.debug('Regroup Icon,show,'+number);
           Rmarkers[number].onmap = true;
           map.addOverlay(Rmarkers[number]);
        {rdelim}
        if ((!show) && (Rmarkers[number].onmap)) {ldelim}
           if (DEBUGINFO) console.debug('Regroup Icon,hide,'+number);
           Rmarkers[number].onmap = false;
           map.removeOverlay(Rmarkers[number]);
        {rdelim}
      {rdelim}
    {rdelim}
    {if $mapv3.fullScreen neq 3}
    // ==== go start & remove history  =======
    function goStart() {ldelim}
      if (DEBUGINFO) console.debug('start of saved position');
      returningToSaved = true;
      map.closeInfoWindow();
      map.returnToSavedPosition();  // takes some time for the map to move so
      setTimeout('removeHistory()',500); // wait for the map to move so that the moveend is not fired
    {rdelim}
    
    function removeHistory() {ldelim}
      var div_history = "";
      view_history = [];  // reset the history
      div_history = _divhistorytext;
      document.getElementById("div_history").innerHTML = div_history;
      returningToSaved = false;
    {rdelim}

    // =========== goHistory ==================
    // goes to a certain place in the view history
    function goHistory(i) {ldelim}
      var x=view_history[i][0];
      var y=view_history[i][1];
      var z=view_history[i][2];
      view_history=view_history.splice(0,i);
      map.setCenter(new GLatLng(x,y),z);
    {rdelim}
    // ====End history functions ========
    {/if} {* end if $mapv3.fullScreen neq 3 *}

    {* Calculate the width and weight of the map div, it permits the use of percentages or fixed pixel size *}
    var myWidth = {$mapv3.mapWidth};
    {if $mapv3.mode eq "Normal"}var minusW = {if $mapv3.sidebar eq 1 and $mapv3.fullScreen eq 0}210{else}20{/if}{if ($mapv3.LegendPos eq 0 and $mapv3.LegendFeature neq '0' and ($mapv3.AlbumLegend or $mapv3.PhotoLegend or (isset($mapv3.regroupItems) and $mapv3.regroupItems))) or ($mapv3.FilterFeature neq '0' and isset($mapv3.ShowFilters) and $mapv3.ShowFilters eq '2')}+155{/if};{/if}
    {if $mapv3.ThumbBarPos eq "3" or $mapv3.ThumbBarPos eq "4"}
      minusW +={$mapv3.ThumbHeight}+30;
      if (IEVersion) minusW += 10;
    {/if}
    {if $mapv3.mode eq "Pick"} var minusW = 410; {/if}
    {if $mapv3.WidthFormat eq "%"} myWidth = getmapwidth(myWidth,minusW); {/if}

    var myHeight = {$mapv3.mapHeight};
    {if $mapv3.mode eq "Normal"}var minusH = 150{if $mapv3.fullScreen eq 2}-120{/if}{if $mapv3.ShowFilters eq 3 or $mapv3.ShowFilters eq 4}+25{/if}{if $mapv3.LegendPos eq 2 or $mapv3.LegendPos eq 3}+90{/if}{if $mapv3.ThumbBarPos eq "1" or $mapv3.ThumbBarPos eq "2"}+{$mapv3.ThumbHeight}+25{/if};{/if}
    {if $mapv3.mode eq "Pick"} var minusH = 155; {/if}
    {if $mapv3.HeightFormat eq "%"} myHeight = getmapheight(myHeight,minusH); {/if}

    var myZoom = {$mapv3.zoomLevel};

    var markers = [];
    var Rmarkers = [];
    var arrowmarker;
    var bounds = new GLatLngBounds();
    var maxZoom = 10; // default to somewhat zoomed-out

    {if $mapv3.fullScreen neq 3}
    /* functions related to the Thumbnail bar */
    function show_arrow(number,xcoord,ycoord,type){ldelim}
      if (DEBUGINFO) console.debug('Show '+number+','+type);
      if (DEBUGINFO) console.debug('Hiding the Icon');
      markerDisplay(number,0,type);
      var Icon = new GIcon();
      Icon.image = "{g->url href="modules/mapv3/images/arrow.png"}";
      Icon.iconSize = new GSize(20, 30);
      Icon.iconAnchor = new GPoint(10, 30);
      Icon.infoWindowAnchor = new GPoint(9, 2);
      var Point = new GLatLng(xcoord, ycoord);
      var newarrow = new GMarker(Point, Icon);
      arrow = newarrow;
      map.addOverlay(newarrow);
    {rdelim}

    function hide_arrow(number,type){ldelim}
      var marker = markers[number];
      if (type != 'normal') marker = Rmarkers[number];
      if (DEBUGINFO) console.debug('hide: '+number+','+type+';myzoom:'+myZoom+'; low:'+marker.showLow+',high:'+marker.showHigh);
      if (myZoom <= marker.showLow && myZoom >= marker.showHigh) {ldelim}
        if (DEBUGINFO) console.debug('Showing the Icon');
        markerDisplay(number,1,type); //marker.display(true);
      {rdelim}
      map.removeOverlay(arrow);
    {rdelim}
    {/if} {* end $mapv3.fullscreen neq 3 *}

    function ShowMeTheMap(){ldelim}

     if (DEBUGINFO) console.debug('Initializing Map');
     var marker_num = 0;
     var Rmarker_num = 0;

    if (DEBUGINFO) console.debug('Create the Map');
    //Google Map implementation
    map = new GMap2(document.getElementById("map"));

   {if $mapv3.MapControlType neq "None" and $mapv3.MapControlType neq "Small" and $mapv3.MapControlType neq "Large"}
     map.addControl(new MyPanZoomControls());
     {if (isset($mapv3.showMapType) and ($mapv3.showMapType))}map.addControl(new MyMapTypeControls());{/if}
   {/if}
    if (DEBUGINFO) console.debug('Add controls');
   
   // ================= infoOpened LISTENER ===========
   GEvent.addListener(map, "infowindowopen", function()  {ldelim}
     infoOpened = true;	// set infoOpened to true to change the history text
   {rdelim});
   // ================= infoClosed LISTENER ===========
   GEvent.addListener(map, "infowindowclose", function()  {ldelim}
     infoOpened = false;	// set infoOpened to false
   {rdelim});

    //Register the key handlers
    new GKeyboardHandler(map);

    //Show and position the MAP Large control
    {if $mapv3.MapControlType eq "Large"} map.addControl(new GLargeMapControl(),new GControlPosition({$mapv3.MapControlPos},new GSize({$mapv3.MapControlPosOffX},{$mapv3.MapControlPosOffY}))); {/if}
    //Show and position the MAP Small control
    {if $mapv3.MapControlType eq "Small"} map.addControl(new GSmallMapControl(),new GControlPosition({$mapv3.MapControlPos},new GSize({$mapv3.MapControlPosOffX},{$mapv3.MapControlPosOffY}))); {/if}
    {if ($mapv3.MapControlType eq "Small" or $mapv3.MapControlType eq "Large") and (isset($mapv3.showMapType) and ($mapv3.showMapType))}map.addControl(new GMapTypeControl());{/if}
    if (DEBUGINFO) console.debug('Controls Added');

     {if isset ($mapv3.GZoom) and $mapv3.GZoom}
       map.addControl(new GZoomControl(),new GControlPosition({$mapv3.GZPos},new GSize({$mapv3.GZPosOffX},{$mapv3.GZPosOffY})));
     {/if}
    //Needed to show the scale
    {if $mapv3.mode eq "Pick" or $mapv3.showScale} map.addControl(new GScaleControl()); {/if}

    //Initialize the zoom and center of the map where it need to be and the Map Type
    var point = new GLatLng ({$mapv3.centerLongLat});
    map.setCenter(point, myZoom,{$mapv3.mapType});
    if (DEBUGINFO) console.debug('Set the center, zoom and map type');
    if (DEBUGINFO) console.debug("{$mapv3.centerLongLat} "+myZoom+" {$mapv3.mapType}");
    {if $mapv3.mode eq "Pick"}
    map.addOverlay(new GMarker(point));
    {/if}
    map.savePosition();

    if (DEBUGINFO) console.debug('done!');

    if (DEBUGINFO) console.debug('Creating the tooltip div');
    tooltip = document.createElement("div");
    map.getPane(G_MAP_FLOAT_PANE).appendChild(tooltip);
    tooltip.style.visibility="hidden";
    if (DEBUGINFO) console.debug('done!');

    {if $mapv3.fullScreen eq 3}
    if (document.all&&window.attachEvent) {ldelim} // IE-Win
      window.attachEvent("onresize", function() {ldelim}this.map.onResize(){rdelim} );
    {rdelim} else if (window.addEventListener) {ldelim} // Others
      window.addEventListener("resize", function() {ldelim}this.map.onResize(){rdelim}, false );
    {rdelim}
    {/if}

    {if $mapv3.mode eq "Normal"}
    //Add a function to update the markers/Slider when the zoom change
    GEvent.addListener(map, "zoomend", function(oldZoom, zoom) {ldelim}
        for (var i=0; i < markers.length; i++) {ldelim} //Updating the normal items
            var marker = markers[i];
            if (zoom <= marker.showLow && zoom >= marker.showHigh) {ldelim}
              markerDisplay(i,1,'normal'); //marker.display(true);
              var CorrectA = document.getElementById('thumb'+i);
              if (CorrectA != null ) CorrectA.style.display = "inline";
            {rdelim}
            else {ldelim}
              markerDisplay(i,0,'normal'); //marker.display(false);
              var CorrectA = document.getElementById('thumb'+i);
              if (CorrectA != null) CorrectA.style.display = "none";
            {rdelim}
        {rdelim}
        for (var i=0; i < Rmarkers.length; i++) {ldelim} //Updating the Regrouped items
            var marker = Rmarkers[i];
            if (zoom <= marker.showLow && zoom >= marker.showHigh) {ldelim}
              markerDisplay(i,1,'Regroup'); //marker.display(true);
            {rdelim}
            else {ldelim}
              markerDisplay(i,0,'Regroup'); //marker.display(false);
            {rdelim}
        {rdelim}
        myZoom = 19-zoom;
        var zoom = 19-zoom;
        var oldZoom = 19-oldZoom;
        {if $mapv3.MapControlType neq "None" and $mapv3.MapControlType neq "Small" and $mapv3.MapControlType neq "Large"}
            if (!IEVersion ||(IEVersion && IEVersion >= 7)) {ldelim}
              document.images['z'+zoom].src = "{g->url href="modules/mapv3/templates/controls/"}{$mapv3.MapControlType}/SlideSel.png";
              document.images['z'+oldZoom].src = "{g->url href="modules/mapv3/templates/controls/"}{$mapv3.MapControlType}/SlideNotch.png";
            {rdelim} else {ldelim}
              document.images['z'+zoom].src = "{g->url href="modules/mapv3/images/blank.gif"}";
              document.images['z'+zoom].style.filter = "filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='{g->url href="modules/mapv3/templates/controls/"}{$mapv3.MapControlType}/SlideSel.png')";
              document.images['z'+oldZoom].src = "{g->url href="modules/mapv3/images/blank.gif"}";
              document.images['z'+oldZoom].style.filter = "filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='{g->url href="modules/mapv3/templates/controls/"}{$mapv3.MapControlType}/SlideNotch.png')";
            {rdelim}
        {/if}
    {rdelim});
    if (DEBUGINFO) console.debug('Zoom Listener entered');

    // Create the overview Map
    {if $mapv3.GoogleOverview}
      map.addControl(new GOverviewMapControl(new GSize({$mapv3.GOSizeX}, {$mapv3.GOSizeY})));
      setTimeout(function() {ldelim}
      var omap=document.getElementById("map_overview");
      var mapdiv = document.getElementById("map");
      omap.style.position = "relative";
      omap.firstChild.style.background = "{$mapv3.bodycolor}";
      omap.firstChild.style.borderTop = "1px solid black";
      omap.firstChild.style.borderLeft = "1px solid black";
      omap.firstChild.firstChild.style.border = "1px solid black";

      {if $mapv3.GOPos eq "3" or $mapv3.GOPos eq "1"}
        omap.style.right = "{$mapv3.GOPosOffX}px";
      {else}
        omap.style.left = "{$mapv3.GOPosOffX}px";
      {/if}
      {if $mapv3.GOPos eq "0" or $mapv3.GOPos eq "1"}
         omap.style.top = "{$mapv3.GOPosOffY}px";
      {else}
         omap.style.bottom = "{$mapv3.GOPosOffY}px";
      {/if}
      mapdiv.appendChild(omap);
      {rdelim}, 1);
    {/if}
    if (DEBUGINFO) console.debug('Overview created');

    function showTooltip(marker) {ldelim}
      tooltip.innerHTML = marker.tooltip;
      var point=map.getCurrentMapType().getProjection().fromLatLngToPixel(map.fromDivPixelToLatLng(new GLatLng(0,0),true),map.getZoom());
      var offset=map.getCurrentMapType().getProjection().fromLatLngToPixel(marker.getPoint(),map.getZoom());
      var anchor=marker.getIcon().iconAnchor;
      var width=marker.getIcon().iconSize.width;
      var height=tooltip.clientHeight;
      var pos = new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(offset.x - point.x - anchor.x + width, offset.y - point.y -anchor.y -height));
      pos.apply(tooltip);
      tooltip.style.visibility="visible";
    {rdelim}

    var BaseIcon = new GIcon();
    BaseIcon.shadow = "{g->url href="modules/mapv3/images/marker_shadow.png"}";
    BaseIcon.iconSize = new GSize({$mapv3.MarkerSizeX},{$mapv3.MarkerSizeY});
    BaseIcon.shadowSize = new GSize({$mapv3.MarkerSizeX}+15,{$mapv3.MarkerSizeY});
    BaseIcon.iconAnchor = new GPoint(6, 20);
    BaseIcon.infoWindowAnchor = new GPoint(5, 1);

    {if (isset($mapv3.regroupItems) and $mapv3.regroupItems)}
    var replaceIcon = new GIcon(BaseIcon);
    replaceIcon.iconSize = new GSize({$mapv3.ReplaceMarkerSizeX},{$mapv3.ReplaceMarkerSizeY});
    replaceIcon.shadowSize = new GSize({$mapv3.ReplaceMarkerSizeX}+15,{$mapv3.ReplaceMarkerSizeY});
    replaceIcon.iconAnchor = new GPoint({$mapv3.replaceAnchorPos});
    replaceIcon.image = "{g->url href="modules/mapv3/images/multi/`$mapv3.regroupIcon`.png"}";

    function CreateRegroup(lat,lon, showLow, showHigh, nbDirect, nbItems, nbGroups){ldelim}
      var point = new GLatLng(lat,lon);
      {if !isset($mapv3.Filter) or (isset($mapv3.Filter) and ($mapv3.Filter|truncate:5:"" neq 'Route'))}bounds.extend(point);{/if}
      var marker = new GMarker(point,replaceIcon)
      marker.onmap = true;
      marker.showHigh = showHigh;
      marker.showLow = showLow;
      GEvent.addListener(marker,"mouseover", function() {ldelim}
        showTooltip(marker);
      {rdelim});
      GEvent.addListener(marker,"mouseout", function() {ldelim}
	tooltip.style.visibility="hidden";
      {rdelim});
      GEvent.addListener(marker, "click", function() {ldelim}
        tooltip.style.visibility="hidden";
        map.setCenter(point,showLow+1);
      {rdelim});
      var directText = nbDirect>0 ? ""+nbDirect+" items and "+ (nbItems-nbDirect) +" more " : "";
      var subgroupText = nbGroups>0 ? " ("+directText+"in "+nbGroups+" subgroups)" : "";
      var title = ''+nbItems+' elements here'+subgroupText+'. Click to zoom in.';
      marker.tooltip = '<div class="tooltip">'+title+'<\/div>';
      marker.type = 'Regroup';
      Rmarkers[Rmarker_num] = marker;
      Rmarker_num++;
      map.addOverlay(marker);
    {rdelim}
    {/if}

    function CreateMarker(lat, lon, itemLink, title, thumbLink, created, zoomlevel, thw, thh, summary, description, icon, showLow, showHigh, hide, type) {ldelim}
      var htmls = [{foreach from=$mapv3.infowindows item=infowindow key=num}{if $num >0},{/if}{$infowindow}{/foreach}];
      var labels = [{foreach from=$mapv3.Labels item=Labels key=num}{if $num >0},{/if}"{$Labels}"{/foreach}];
      var point = new GLatLng(lat,lon);
      {if !isset($mapv3.Filter) or (isset($mapv3.Filter) and ($mapv3.Filter|truncate:5:"" neq 'Route'))}
      bounds.extend(point);
      maxZoom = Math.max(maxZoom, zoomlevel);
      {/if}
      var marker = new GMarker(point, icon);
      marker.onmap = true;
      marker.showHigh = showHigh;
      marker.showLow = showLow;
      GEvent.addListener(marker,"mouseover", function() {ldelim}
        showTooltip(marker);
      {rdelim});
      GEvent.addListener(marker,"mouseout", function() {ldelim}
		tooltip.style.visibility="hidden"
      {rdelim});
      GEvent.addListener(marker, "click", function() {ldelim}
        tooltip.style.visibility="hidden"
        if (htmls.length > 2) {ldelim}
          htmls[0] = '<div style="width:'+htmls.length*88+'px">' + htmls[0] + '<\/div>';
        {rdelim}
        var tabs = [];
        for (var i=0; i<htmls.length; i++) {ldelim}
            tabs.push(new GInfoWindowTab(labels[i],htmls[i]));
        {rdelim}
        marker.openInfoWindowTabsHtml(tabs);
      {rdelim});
      marker.tooltip = '<div class="tooltip">'+title+'<\/div>';
      marker.type = type;
      markers[marker_num] = marker;
      marker_num++;

      map.addOverlay(marker);

      if (hide==1) markerDisplay(marker_num-1,0,'normal');
    {rdelim}

   //Create the base for all icons
   var BaseIcon = new GIcon();
   BaseIcon.shadow = "{g->url href="modules/mapv3/images/marker_shadow.png"}";
   BaseIcon.iconSize = new GSize({$mapv3.MarkerSizeX},{$mapv3.MarkerSizeY});
   BaseIcon.shadowSize = new GSize({$mapv3.MarkerSizeX}+15,{$mapv3.MarkerSizeY});
   BaseIcon.iconAnchor = new GPoint(6, 20);
   BaseIcon.infoWindowAnchor = new GPoint(5, 1);

   var DefaultphotoIcon = new GIcon(BaseIcon);
   DefaultphotoIcon.image = "{g->url href="modules/mapv3/images/markers/`$mapv3.useMarkerSet`/marker_`$mapv3.defaultphotocolor`.png"}";
   DefaultphotoIcon.iconSize = new GSize({$mapv3.MarkerSizeX},{$mapv3.MarkerSizeY});
   DefaultphotoIcon.shadowSize = new GSize({$mapv3.MarkerSizeX}+15,{$mapv3.MarkerSizeY});
   DefaultphotoIcon.iconAnchor = new GPoint({$mapv3.MarkerSizeX}/2, {$mapv3.MarkerSizeY});

   var DefaultalbumIcon = new GIcon(BaseIcon);
   DefaultalbumIcon.image = "{g->url href="modules/mapv3/images/markers/`$mapv3.useAlbumMarkerSet`/marker_`$mapv3.defaultalbumcolor`.png"}";
   DefaultalbumIcon.iconSize = new GSize({$mapv3.AlbumMarkerSizeX},{$mapv3.AlbumMarkerSizeY});
   DefaultalbumIcon.shadowSize = new GSize({$mapv3.AlbumMarkerSizeX}+15,{$mapv3.AlbumMarkerSizeY});
   DefaultalbumIcon.iconAnchor = new GPoint({$mapv3.AlbumMarkerSizeX}/2,{$mapv3.AlbumMarkerSizeY});

   var DefaultgroupIcon = new GIcon(BaseIcon);
   DefaultgroupIcon.image = "{g->url href="modules/mapv3/images/markers/`$mapv3.useGroupMarkerSet`/marker_`$mapv3.defaultgroupcolor`.png"}";
   DefaultgroupIcon.iconSize = new GSize({$mapv3.GroupMarkerSizeX},{$mapv3.GroupMarkerSizeY});
   DefaultgroupIcon.shadowSize = new GSize({$mapv3.GroupMarkerSizeX}+15,{$mapv3.GroupMarkerSizeY});
   DefaultgroupIcon.iconAnchor = new GPoint({$mapv3.GroupMarkerSizeX}/2,{$mapv3.GroupMarkerSizeY});

    {if (isset($mapv3.regroupItems) and $mapv3.regroupItems)}
    /*Loop over the Regroup Markers and show them */
    {foreach from=$mapv3.RegroupItems item=Rpoint}
      CreateRegroup({$Rpoint.gps},{$Rpoint.regroupShowLow},{$Rpoint.regroupShowHigh},{$Rpoint.directItems}, {$Rpoint.items}, {$Rpoint.groups});
    {/foreach}
    {/if}

    /* Loop over gallery items that have GPS coordinates
        and output code to add them to the map. */
    {if (!empty($mapv3.mapPoints))}
    {counter name="num" start=-1 print=false}
    {counter name="num1" start=-1 print=false}
    {counter name="num2" start=-1 print=false}
    {counter name="num3" start=-1 print=false}
    {counter name="num4" start=-1 print=false}
    {foreach from=$mapv3.mapPoints item=point}
      {if $mapv3.ThumbBarPos neq "0" and $mapv3.fullScreen neq 3}
      /* creates the Thumbnail bar as we go */
      var style = "";
      //map.setCenter(new GPoint({$point.gps}));
      sidebarhtml += '<a id="thumb{counter name="num3"}" '+style+' href="#" onclick="GEvent.trigger(markers[{counter name="num2"}],\'click\'); return false;" onmouseover="show_arrow({counter name="num"},{$point.gps},\'normal\');" onmouseout="hide_arrow({counter name="num1"},\'normal\');"><img style="{if $mapv3.ThumbBarPos eq "3" or $mapv3.ThumbBarPos eq "4"}width{else}height{/if}:{$mapv3.ThumbHeight}px;" src="{$point.thumbLink}"/>{if $mapv3.ThumbBarPos eq "3" or $mapv3.ThumbBarPos eq "4"}<br/>{/if}<\/a>';
      sidebarsize +={if $mapv3.ThumbBarPos eq "3" or $mapv3.ThumbBarPos eq "4"}{$point.thumbbarHeight}{else}{$point.thumbbarWidth}{/if}+2;
      {/if}
      {if $point.type eq "GalleryAlbumItem"}
       {assign var=itemType value="album"}
       {assign var=markerSet value="`$mapv3.useAlbumMarkerSet`"}
       {assign var=markerColor value="`$mapv3.defaultalbumcolor`"}
      {elseif $point.type eq "GoogleMapGroup"}
       {assign var=itemType value="group"}
       {assign var=markerSet value="`$mapv3.useGroupMarkerSet`"}
       {assign var=markerColor value="`$mapv3.defaultgroupcolor`"}
      {else}
       {assign var=itemType value="photo"}
       {assign var=markerSet value="`$mapv3.useMarkerSet`"}
       {assign var=markerColor value="`$mapv3.defaultphotocolor`"}
      {/if}
      {assign var=iconDef value="Default"}
      {if $point.color neq "default"}
      var {$itemType}Icon = new GIcon(Default{$itemType}Icon);
      {assign var=iconDef value=""}{* Clear the "Default" and flag that we declared the variable *}
      {assign var=markerColor value="`$point.color`"}
      {$itemType}Icon.image = "{g->url href="modules/mapv3/images/markers/`$markerSet`/marker_`$point.color`.png"}";
      {/if}
      {* quick hacky fix for missing numbered markers *}
      {if $mapv3.EnableRouteNumber}
      {foreach from=$mapv3.routeitem key=name item=items}
       {foreach from=$items item=id key=num}
        {if $point.id == $id}
         {if $iconDef eq "Default"}{* variable hasn't been declared yet *}
          {assign var=iconDef value=""}{* Clear the "Default" text *}
          var {$itemType}Icon = new GIcon(Default{$itemType}Icon);
         {/if}
         {$itemType}Icon.image = "{g->url href="modules/mapv3/images/routes/`$name`/`$num+1`-marker_`$markerColor`.png"}";
        {/if} 
       {/foreach}
      {/foreach}
      {/if}
      {if $point.id|truncate:1:"" neq 'T'}
        CreateMarker({$point.gps}, "{$point.itemLink}", "{$point.title|markup|escape:"javascript"}", "{$point.thumbLink}", "{$point.created}", {$point.zoomlevel}, {$point.thumbWidth}, {$point.thumbHeight},
          {if $mapv3.showItemSummaries && !empty($point.summary)} "{$point.summary|markup|escape:"javascript"}"{else}""{/if}
          ,
          {if $mapv3.showItemDescriptions && !empty($point.description)} "{$point.description|markup|escape:"javascript"}"{else}""{/if}
          ,
          {$iconDef}{$itemType}Icon
          , {$point.regroupShowLow},{$point.regroupShowHigh},0,"{$point.type}");
      {/if}
    {/foreach}

    {if isset($mapv3.ThumbBarPos) and $mapv3.ThumbBarPos neq 0 and $mapv3.fullScreen neq 3}
    var thumbdiv = document.getElementById("thumbs");
    thumbdiv.innerHTML = sidebarhtml;
    var mapdiv = document.getElementById("map");

    {if $mapv3.ThumbBarPos eq "1" or $mapv3.ThumbBarPos eq "2"}
    if (sidebarsize+1 > myWidth)  sidebarheight = {$mapv3.ThumbHeight+25};
    thumbdiv.style.height = sidebarheight+"px";
    {else}
    {* Should this be $mapv3.ThumbWidth? *}
    if (sidebarsize+1 > myHeight)  sidebarwidth = {$mapv3.ThumbHeight+25};
    thumbdiv.style.width = sidebarwidth+"px";
    {/if}

    {/if}

    {/if}

    /* Loop over routes if any and display them */
    {if (!empty($mapv3.Routes))}
    var point;
    {foreach from=$mapv3.Routes item=routes}
      var points = [];
      {if $routes.5 eq "Yes"}
      {foreach from=$routes[7] item=point}
         point = new GLatLng({$point[0]},{$point[1]});
         points.push(point);
         {if (isset($mapv3.Filter) and (($mapv3.Filter|truncate:5:"" eq 'Route')))}bounds.extend(point);{/if}
      {/foreach}
      map.addOverlay(new GPolyline(points,"{$routes[2]}",{$routes[3]},{$routes[4]}));
      {/if}
    {/foreach}
    {/if}
    
    {if $mapv3.AutoCenterZoom and (!isset($mapv3.Filter) or (isset($mapv3.Filter) and (($mapv3.Filter|truncate:5:"" eq 'Route') or ($mapv3.Filter|truncate:5:"" eq 'Album') or ($mapv3.Filter|truncate:5:"" eq 'Group'))))}
      map.setCenter(bounds.getCenter(), Math.min(map.getBoundsZoomLevel(bounds), maxZoom));
      map.savePosition();
    {/if}
    {if $mapv3.fullScreen neq 3}

    // check for movment of the map and add links to the history
    view_history = [];
    returningToSaved = false;
    last_zoom = false;
    last_center = map.getCenter();
    last_zoom = map.getZoom();
    infoOpened = false;	// set to true when an info window is opened.
    GEvent.addListener(map, "moveend", function () {ldelim}
      if (!returningToSaved) {ldelim}
        if (DEBUGINFO) GLog.write('moveend fired');
        center = map.getCenter();
        bounds = map.getBounds();
        zoom = map.getZoom();
        var div_history = _divhistorytext;
        div_history += '<a href="javascript:goStart();">Start</a>';
        var tag = "move";
        if (zoom != last_zoom) {ldelim}
          tag = "zoom";
          last_zoom = map.getZoom();
        {rdelim}
        if (infoOpened) {ldelim}
          tag = "window";
          infoOpened = false;
        {rdelim}
        view_history[view_history.length]=new Array(center.y,center.x,zoom,tag);
        if (view_history.length > 10) {ldelim}  // trim the # of links in history
          view_history.shift();
        {rdelim}
        // loop through the history and write the links
        for (var j=1; j < view_history.length; j++) {ldelim}
          div_history += "-> ";  // text before the link
          div_history += '<a href="javascript:goHistory('+(j-1)+');">'+view_history[j][3]+'</a>';
        {rdelim}
        div_history += ''; // add text to the end if needed
        document.getElementById("div_history").innerHTML = div_history;
      {rdelim}
    {rdelim});
    {/if} {* end $mapv3.fullScreen neq 3}

    {* set the correct zoom slide notch and show/hide the regrouped item *}
    zoom = map.getZoom();
    myZoom = 19-zoom;
   {if $mapv3.MapControlType neq "None" and $mapv3.MapControlType neq "Small" and $mapv3.MapControlType neq "Large"}
      if (!IEVersion ||(IEVersion && IEVersion >= 7)) document.images['z'+myZoom].src = "{g->url href="modules/mapv3/templates/controls/`$mapv3.MapControlType`/SlideSel.png"}";
      else {ldelim}
        document.images['z'+myZoom].src = "{g->url href="modules/mapv3/images/blank.gif"}";
        document.images['z'+myZoom].style.filter = "filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='{g->url href="modules/mapv3/templates/controls/`$mapv3.MapControlType`/SlideSel.png"}')";
      {rdelim}
   {/if}
    for (var i=0; i < markers.length; i++) {ldelim} //Updating the normal items
        var marker = markers[i];
        if (zoom <= marker.showLow && zoom >= marker.showHigh) {ldelim}
          markerDisplay(i,1,'normal'); //marker.display(true);
          var CorrectA = document.getElementById('thumb'+i);
          if (CorrectA != null ) CorrectA.style.display = "inline";
        {rdelim}
        else {ldelim}
          markerDisplay(i,0,'normal'); //marker.display(false);
          var CorrectA = document.getElementById('thumb'+i);
          if (CorrectA != null) CorrectA.style.display = "none";
        {rdelim}
    {rdelim}
    for (var i=0; i < Rmarkers.length; i++) {ldelim} //Updating the normal items
        var marker = Rmarkers[i];
        if (zoom <= marker.showLow && zoom >= marker.showHigh) {ldelim}
          markerDisplay(i,1,'Regroup'); //marker.display(true);
        {rdelim}
        else {ldelim}
          markerDisplay(i,0,'Regroup'); //marker.display(false);
        {rdelim}
    {rdelim}

    {/if}

    {if $mapv3.mode eq "Pick"}
        GEvent.addListener(map, "moveend", function() {ldelim}
        var center = map.getCenter();
        map.clearOverlays();
        map.addOverlay(new GMarker(center));
        var latLngStr = center.toUrlValue(6);
        document.getElementById("message_id").innerHTML = '(' + latLngStr + ')';
        document.getElementById("coord").value = latLngStr;
        {rdelim});

        GEvent.addListener(map, 'click', function(overlay, point) {ldelim}
           map.clearOverlays();
           if (point) {ldelim}
            map.addOverlay(new GMarker(point));
            map.panTo(point);
            var latLngStr = point.toUrlValue(6);
            document.getElementById("message_id").innerHTML = '(' + latLngStr + ')';
            document.getElementById("coord").value = latLngStr;
          {rdelim}
        {rdelim});
        GEvent.addListener(map, 'zoomend', function(oldZoomLevel, newZoomLevel) {ldelim}
          var center = '' + newZoomLevel
          document.getElementById("zoom_id").innerHTML = center;
          document.getElementById("zoom").value = center;
          var zoom = 19-newZoomLevel;
          var oldZoom = 19-oldZoomLevel;
          {if $mapv3.MapControlType neq "None" and $mapv3.MapControlType neq "Small" and $mapv3.MapControlType neq "Large"}
              if (!IEVersion ||(IEVersion && IEVersion >= 7)) {ldelim}
                document.images['z'+zoom].src = "{g->url href="modules/mapv3/templates/controls/"}{$mapv3.MapControlType}/SlideSel.png";
                document.images['z'+oldZoom].src = "{g->url href="modules/mapv3/templates/controls/"}{$mapv3.MapControlType}/SlideNotch.png";
              {rdelim} else {ldelim}
                document.images['z'+zoom].src = "{g->url href="modules/mapv3/images/blank.gif"}";
                document.images['z'+zoom].style.filter = "filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='{g->url href="modules/mapv3/templates/controls/"}{$mapv3.MapControlType}/SlideSel.png')";
                document.images['z'+oldZoom].src = "{g->url href="modules/mapv3/images/blank.gif"}";
                document.images['z'+oldZoom].style.filter = "filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='{g->url href="modules/mapv3/templates/controls/"}{$mapv3.MapControlType}/SlideNotch.png')";
              {rdelim}
          {/if}
        {rdelim});
    {/if}
    {rdelim} /* end ShowMeTheMap() */

    {if $mapv3.mode eq "Normal" and $mapv3.fullScreen neq 3}
    function togglealbumlegend()
    {ldelim}
        if (document.getElementById) {ldelim} // standard
            var displaystyle = document.getElementById("albumlegend").style.display;
            document.getElementById("albumlegend").style.display = (displaystyle == "none" ? "block":"none");
        {rdelim} else if (document.all){ldelim} // old msie versions
            var displaystyle = document.all["albumlegend"].style.display;
            document.all["albumlegend"].style.display = (displaystyle == "none" ? "block":"none");
        {rdelim} else if (document.layers){ldelim} // nn4
            var displaystyle = document.layers["albumlegend"].style.display;
            document.layers["albumlegend"].style.display = (displaystyle == "none" ? "block":"none");
        {rdelim}
        var imgsrc = document.albumarrow.id;
        document.albumarrow.src = (imgsrc  == "down" ? "{g->url href="modules/mapv3/images/up.png"}":"{g->url href="modules/mapv3/images/down.png"}");
        document.albumarrow.id = (imgsrc == "down" ? "up":"down");
    {rdelim}

    function togglephotolegend()
    {ldelim}
        if (document.getElementById) {ldelim} // standard
            var displaystyle = document.getElementById("photolegend").style.display;
            document.getElementById("photolegend").style.display = (displaystyle == "none" ? "block":"none");
        {rdelim} else if (document.all){ldelim} // old msie versions
            var displaystyle = document.all["photolegend"].style.display;
            document.all["photolegend"].style.display = (displaystyle == "none" ? "block":"none");
        {rdelim} else if (document.layers){ldelim} // nn4
            var displaystyle = document.layers["photolegend"].style.display;
            document.layers["photolegend"].style.display = (displaystyle == "none" ? "block":"none");
        {rdelim}
        var imgsrc = document.photoarrow.id;
        document.photoarrow.src = (imgsrc  == "down" ? "{g->url href="modules/mapv3/images/up.png"}":"{g->url href="modules/mapv3/images/down.png"}");
        document.photoarrow.id = (imgsrc == "down" ? "up":"down");
    {rdelim}

    function strLeft(kstr,kchar)
    {ldelim}
      var retVal = "-1";

      if (kstr.indexOf (kchar) > -1)
        retVal =
          kstr.substring (0, kstr.indexOf(kchar));
      return(retVal);

    {rdelim}
    function strRight(kstr, kchar)
    {ldelim}
      var   retVal = "-1";

      if (kstr.indexOf(kchar) > -1 )
        retVal =
          kstr.substring(kstr.indexOf(kchar) + kchar.length,
              kstr.length);
      return(retVal);
    {rdelim}

    function togglemarkers(number)
    {ldelim}
      if (DEBUGINFO) console.debug('Entering Toggle Marker');
      var markercolor;
      var thetd = document.getElementById(number);
      var Itype = number.substring(0,1);
      if (Itype=="A") var thetype = "GalleryAlbumItem";
      else var thetype = "GalleryPhotoItem";
      var thecheckbox = document.getElementsByName("C"+number);
      var clickedcolor = strRight(strLeft(thetd.innerHTML,".png"),"marker_");
      var zoom = map.getZoom();
      if (DEBUGINFO) {ldelim}
         console.debug(clickedcolor+' '+thetype+' '+zoom);
         if (thecheckbox.item(0).checked) console.debug('Showing');
         else console.debug('Hiding');
      {rdelim}
      for (var i=0; i<markers.length; i++) {ldelim}
       var checktype = (markers[i]["type"] == "GalleryAlbumItem") ? "GalleryAlbumItem":"GalleryPhotoItem";
       markercolor = strRight(strLeft(markers[i].getIcon().image,".png"),"marker_");
       if (DEBUGINFO) console.debug('Marker: '+markers[i]["type"]+' '+markercolor+' '+markers[i].showLow+' '+markers[i].showHigh);
       if (markercolor == clickedcolor && (checktype == thetype || markers[i]['type'] == "Regroup")){ldelim}
         if (thecheckbox.item(0).checked && zoom <= markers[i].showLow && zoom >= markers[i].showHigh) markerDisplay(i,1,'normal'); //markers[i].display(true);
         else
         {ldelim}
           if (DEBUGINFO) console.debug('Hiding');
           markerDisplay(i,0,'normal'); //markers[i].display(false);
         {rdelim}
       {rdelim}

      {rdelim}
    {rdelim}
    {/if}

     if (document.all&&window.attachEvent) {ldelim} // IE-Win
         window.attachEvent("onload", ShowMeTheMap);
         window.attachEvent("onunload",GUnload);
      {rdelim} else if (window.addEventListener) {ldelim} // Others
         window.addEventListener("load", ShowMeTheMap, false);
         window.addEventListener("unload", GUnload, false);
      {rdelim}

     var GoogleMap = true;

    //]]>
</script>
{/if}
