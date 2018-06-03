{*
 * $Revision: 1253 $
 * Read this before changing templates!  http://codex.gallery2.org/Gallery2:Editing_Templates
 *}
{if !$mapv3.fullScreen}
<div id="gsContent" class="gcBorder1">
{/if}
  {if $mapv3.fullScreen neq 2 and $mapv3.fullScreen neq 3}
    {if $mapv3.mode eq "Normal"}
      <h2>{g->text text="Photo Map"}{if isset($mapv3.Filter)}<span class="giWarning"> {g->text text="Filtered on"} {$mapv3.Filter}</span>{/if}</h2>
    {else}
      <h2>{g->text text="Grab coordinates from Map"}</h2>
      <table border=0>
      <tr>
      <td rowspan=2>
    {/if}
    {if isset($mapv3.filterhackingerror)}
    <div class="gbBlock">
       <h2 class="giError">{g->text text="There was a hacking attempt on the filter name, please remove the filter option from the address bar."}
    </div>
    {/if}
  {/if}


{if $mapv3.mode eq "Normal"}
    {if $mapv3.useMarkerSet eq "none"}
    <!-- 
    If there are no markers, don't display a map. Instead, show a link to the admin page for the 
    markers to be created 
    -->
    <div class="gbBlock">
    {capture name="mapThemeAdminUrl"}
      {g->url arg1="view=core.SiteAdmin" arg2="subView=mapv3.MapSiteAdmin" arg3="mode=Theme"}
    {/capture}
      <h2 class="giError">{g->text text="There are no markers created or a bad marker set is currently selected. Please review settings in the %scontrol panel%s."
       	arg1="<a href=\"`$smarty.capture.mapThemeAdminUrl`\">" arg2="</a>"}
      </h2>
    </div>
    {/if}

    {if isset($mapv3.nogpscoords) and $mapv3.nogpscoords}
    <!-- If there are no items with GPS coordinate, don't display a map and show a message -->
    <div class="gbBlock">
       <h2 class="giError">{g->text text="There are no items with GPS coordinates"}
       <a href='http://codex.gallery2.org/index.php/Gallery2:Modules:UserGuide'> {g->text text="Check the Wiki for more information"}</a></h2>
       </div>
    {/if}

    {if isset($mapv3.noitemperms) and $mapv3.noitemperms}
    <!-- If there are no items with sufficient permissions to be mapped then display a message -->
    <div class="gbBlock">
        <center><h2 class="giError">{g->text text="There are no items available to be mapped"}<br/><br/>
        <a href='Javascript:history.go(-1);'>Go Back</a></center></h2>
    </div>
    {/if}

    {if isset($mapv3.noiteminalbum) and $mapv3.noiteminalbum}
    <!-- No item in the selected album, hacking attempt ? -->
    <div class="gbBlock">
        <center><h2 class="Warning">
          {g->text text="There were no items found in the selected %s, what would you like to do?"
          arg1=$mapv3.Filter}</h2><br/></center>
        <h2 style="position:relative;left:100px;">1 - {g->text text="%sGo Back%s to the Album and add coordinates to items"
          arg1="<a href='Javascript:history.go(-1);'>" arg2="</a>"}
        </h2>
	{capture name="mapUrl"}
	  {g->url arg1="view=mapv3.ShowMap"}
	{/capture}
	<h2 style="position:relative;left:100px;">2 - {g->text text="Show me the %sdefault map%s"
          arg1="<a href=\"`$smarty.capture.mapUrl`\">" arg2="</a>"}
        </h2>
        <br/>
    </div>
    {/if}
{/if}
    {if !isset($mapv3.googleMapKey) or $mapv3.googleMapKey eq ''}
    <!-- No Google Map Keys were found to suit this install -->
    <div class="gbBlock">
        <center><h2 class="giError">
        {capture name="mapAdminUrl"}
          {g->url arg1="view=core.SiteAdmin" arg2="subView=mapv3.MapSiteAdmin"}
	{/capture}
	{g->text text="You do not have a profile setup for this website to use the Google Map. Review your settings in the %sAdmin Panel%s or %scheck the Wiki%s."
	  arg1="<a href=\"`$smarty.capture.mapAdminUrl`\">" arg2="</a>"
          arg3="<a href=\"http://codex.gallery2.org/Gallery2:Modules:Map:UserGuide\">" arg4="</a>"}
 	</h2></center><br/><br/>
    </div>
    {else}

<!-- Create the Div where the map will be displayed  -->
    {if $mapv3.mode eq "Pick" or ($mapv3.mode eq "Normal" and (!isset($mapv3.noiteminalbum) or !$mapv3.noiteminalbum) and (!isset($mapv3.nogpscoords) or !$mapv3.nogpscoords) and (!isset($mapv3.noitemperms) or !$mapv3.noitemperms) and isset($mapv3.googleMapKey) and $mapv3.googleMapKey neq '')}
    {if $mapv3.mode eq "Pick" or $mapv3.useMarkerSet <> "none"}
        {if $mapv3.mode neq "Pick" and isset($mapv3.ShowFilters) and $mapv3.ShowFilters eq "3" and !$mapv3.fullScreen}
         {g->block type="mapv3.map"}
        {/if}
        {if $mapv3.mode neq "Pick" and (!isset($mapv3.LegendPos) or (isset($mapv3.LegendPos) and $mapv3.LegendPos eq '2')) and $mapv3.fullScreen neq 3}
        {if $mapv3.mode neq "Pick" and ((isset($mapv3.AlbumLegend)) and ($mapv3.AlbumLegend eq "1")) or ((isset($mapv3.PhotoLegend)) and ($mapv3.PhotoLegend eq "1")) or ((isset($mapv3.regroupItems)) and ($mapv3.regroupItems eq "1")) and $mapv3.fullScreen neq 3}
         {g->block type="mapv3.Legend"}
        {/if}{/if }
        {if $mapv3.mode neq "Pick" and $mapv3.fullScreen neq 3}
        {if $mapv3.ThumbBarPos eq "1" or $mapv3.ThumbBarPos eq "3" or $mapv3.ThumbBarPos eq "4"}{g->block type="mapv3.Thumb"}{/if}
        <table align=right style="border-collapse:collapse;">
        {if isset($mapv3.ShowFilters) and $mapv3.ShowFilters eq "2" and !$mapv3.fullScreen}
          <tr><td>
          {g->block type="mapv3.map"}
          <br/>
          </td></tr>
        {/if}
        {if $mapv3.mode neq "Pick" and isset($mapv3.LegendPos) and $mapv3.LegendPos eq '0'}
          <tr><td>
           {g->block type="mapv3.Legend"}
          </td></tr>
        {/if}
        </table>
        {/if} {* end if $mapv3.mode neq "Pick" and $mapv3.fullScreen neq 3 *}
        <script type="text/javascript">
        document.write('<div id="map" {if $mapv3.fullScreen eq 3}style="width: 100%; height: 100%;"{else}class="themap" style="overflow:hidden;width:'+myWidth+'px;height:'+myHeight+'px;color:black;background-color:lightgrey;border:1px solid black;"{/if}>');
        </script>
        {if $mapv3.mode eq "Normal"}
        <center><h3 id="loading">{g->text text="Loading, please wait..."}</h3></center>
        
        {* rewrite custom controls for v2 *}

        {/if}
        <!--
        Preload images to help loading time in IE
        -->
        {if isset($mapv3.preload)}
          {$mapv3.preload}
        {/if}
     <script type="text/javascript">document.write('<\/div>');</script> {* End of the map div *}

    {if $mapv3.fullScreen neq 3}
     <div id="div_history" class="map_history">{g->text text="Move history"}:</div>
    {/if}

     {if $mapv3.mode eq "Normal" and $mapv3.fullScreen neq 3}
      {if $mapv3.ThumbBarPos eq "2"}{g->block type="mapv3.Thumb"}{/if}
      {if isset($mapv3.ShowFilters) and $mapv3.ShowFilters eq "4" and !$mapv3.fullScreen}{g->block type="mapv3.map"}{/if}
       {if $mapv3.mode neq "Pick" and (isset($mapv3.LegendPos) and ($mapv3.LegendPos eq '3'))}
       {if ((isset($mapv3.AlbumLegend)) and ($mapv3.AlbumLegend eq "1")) or ((isset($mapv3.PhotoLegend)) and ($mapv3.PhotoLegend eq "1")) or ((isset($mapv3.regroupItems)) and ($mapv3.regroupItems eq "1"))}
         {g->block type="mapv3.Legend"}
       {/if}
       {/if}
     {/if}
     {if $mapv3.mode eq "Pick"}
      </td>
      <td valign=top>
      <h2 class="giSuccess">{g->text text="MENU"}</h2><br/>
      <!--
        This creates the URL to save the parameters and return to the right place
      -->
      <form action="{g->url}" method="post" id="itemEdit" enctype="application/x-www-form-urlencoded">
      <div>
      {g->hiddenFormVars}
      <input type="hidden" name="{g->formvar var="controller"}" value="{$controller}"/>
      </div>
      <input type="hidden" name="{g->formVar var="form[id]"}" value="{$form.id}"/>
      <input type="hidden" name="{g->formVar var="form[mode]"}" value="{$mapv3.mode}"/>
      <input type="hidden" name="{g->formVar var="form[plugin]"}" value="{$mapv3.plugin}"/>
      <input type="hidden" id="coord" name="{g->formVar var="form[coord]"}" value="{if $mapv3.centerLongLat neq 'none'}{$mapv3.centerLongLat}{else}-12,20{/if}"/>
      <input type="hidden" id="zoom" name="{g->formVar var="form[zoom]"}" value="{if $mapv3.zoomLevel neq 'none'}{$mapv3.zoomLevel}{else}16{/if}"/>
      <input type="submit" name="{g->formVar var="form[save]"}" value="{g->text text="Save these coordinates"}"  class="inputTypeSubmit"/>
      <input type="submit" name="{g->formVar var="form[cancel]"}" value="{g->text text="Cancel" hint="Discard changes"}"  class="inputTypeSubmit"/>
      </form>
      <br/><br/>
        <!--
        Display some very basic help
        -->
      <h2 class="giSuccess">{g->text text="Tips" hint="Hints or suggestions"}</h2>
      <ul><li/>{g->text text="Click on the map to choose the point."}<br/><br/>
      <li/>{g->text text="Each click will create a marker to ease aiming."}<br/><br/>
      <li/>{g->text text="When you are satisfied with the coordinates, click <B>Save</B> above and the center of the map and the zoom level will be copied in the GPS and ZoomLevel fields of the item."}<br/>
      </ul>
      <h2>{$theme.item.title|markup}</h2><br /><img src="{$form.itemthumb}" />
      </td></tr>
      <tr><td>
      <h3>{g->text text="Current Coordinates"}</h3>
      <div id="message_id">({if $mapv3.centerLongLat neq 'none'}{$mapv3.centerLongLat}{else}-12,20{/if})</div><br/>
      <h3>{g->text text="Current Zoomlevel"}</h3>
      <div id="zoom_id">{if $mapv3.zoomLevel neq 'none'}{$mapv3.zoomLevel}{else}16{/if}</div><br/>
      </td></tr>
      </table>

     {/if}
    {/if}
  {/if}
{/if}
{if $mapv3.hasadminrights and $mapv3.fullScreen neq 3}
<a style="position:absolute;right:50px;" href="{g->url arg1="view=core.SiteAdmin" arg2="subView=mapv3.MapSiteAdmin"}">{g->text text="Google Map Administration"}</a>
{/if}
{if !$mapv3.fullScreen}
</div>
{/if}
<!-- #gsContent -->