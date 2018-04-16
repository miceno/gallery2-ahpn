{*
 * $Revision: 10000 $
 * If you want to customize this file, do not edit it directly since future upgrades
 * may overwrite it.  Instead, copy it into a new directory called "local" and edit that
 * version.  Gallery will look for that file first and use it if it exists.
 *}
{*
 * Below is some variables you can change to customize the colors,
 * done in JS because smarty will not translate the  braces.
 *}
 {g->callback type="tags.GetTagCloud" totalTagCount=true}
 {g->callback type="tags.TagsLink"}
  {literal}
 <script type="text/javascript">
 	// Sort can be: 'descending', 'ascending', 'random', null
 	var sortOrder = '{/literal}{$sortOrder|default:'random'}{literal}'
 	// mouse over font color from block settings
 	var fontcolor = '{/literal}{$fontcolor|default:'#000'}{literal}'
 	// color array.  Picked at random
 	var carray = [{r:255,g:197,b:145},{r:255,g:213,b:122},{r:243,g:133,b:99},{r:251,g:158,b:126},{r:254,g:173,b:120}]
 	// color of highlight on mouseover
 	var chighlight = [{r:172,g:207,b:175}]
 </script>
 {/literal}
{if $showTitle|default:'true'}
	<div class="gbBlock gcBackground1">
		<h2> {g->text text="Ishihara Tag Cloud"} </h2>
	</div>
{/if}
<style type="text/css"> v\:* {ldelim} behavior: url(#default#VML); position: absolute;{rdelim}</style>
<script type="text/javascript" src="{g->url href="modules/tags/js/Ishihara-color-cloud.js"}"></script>
<div id="tagcloud" style="position: relative; margin:0 auto;
		width: {$divwidth|default:'500'}px; height: {$divheight|default:'400'}px;
		overflow: {if !isset($overflow)}visible{elseif $overflow=='1'}visible{else}hidden{/if};">
</div>
{if $showinfo|default:'true'}
	<div style="position: relative; width: {$divwidth|default:'400'}px; height: 16px; margin:0 auto;">
  		<img src="{g->url href="modules/tags/images/info.png"}" width="16" height="16" 
       		style="position: absolute; left: 0; bottom: 0; cursor:pointer" 
	   		onclick="window.open('http://en.wikipedia.org/wiki/Ishihara_color_test','wikipedia','status=1,location=1,scrollbars=1,height=700,width=900');" 
	   		alt="{g->text text="Ishihara info"}" title="{g->text text="Ishihara info"}" />
  		<img src="{g->url href="modules/tags/images/refresh.png"}" width="16" height="16" 
       		style="position: absolute; right: 0; bottom: 0; cursor:pointer" onclick="tagcloud.redraw()" 
	   		alt="{g->text text="Redraw"}" title="{g->text text="Redraw"}" />
	</div>
{/if}

{*
 * Add the Javascript to the trailer because IE does not like code
 * inside table cells because the theme might use tables.
 *}
{g->addToTrailer}
	<script type="text/javascript">
		var tagcloud = new TagCloud(document.getElementById('tagcloud'),sortOrder,carray,chighlight,'');
		{foreach from=$block.tags.taglist item=tag key=rawTagName name=tags}
		{if empty($bubbles) || !is_numeric($bubbles) || $smarty.foreach.tags.iteration < $bubbles+1}
			tagcloud.addNode(new Node('{g->url arg1="view=tags.VirtualAlbum" arg2="tagName=$rawTagName" htmlEntities=false}',{$tag.rawCount}));
		{/if}
		{/foreach}
	tagcloud.draw();
	</script>
{/g->addToTrailer}



