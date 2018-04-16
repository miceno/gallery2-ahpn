{*
 * $Revision: 1075 $
 * Read this before changing templates!  http://codex.gallery2.org/Gallery2:Editing_Templates
 *}
{g->callback type="tags.GetTagCloud" totalTagCount=true}
{if !empty($block.tags.taglist)}
{assign var="Magnification" value=$fontmag|default:'5'}
{if $showTitle|default:'true'}
	<div class="gbBlock gcBackground1">
		<h2> {g->text text="Flash Tag Cloud"} </h2>
	</div>
{/if}
	<script type="text/javascript" src="{g->url href="modules/tags/js/swfobject.js"}"></script>
	<div id="tagcloudflash"></div>
	<script type="text/javascript">	 
    	var tags = "<tags>";
    	{foreach from=$block.tags.taglist item=tag key=rawTagName name=tags}
    	{if empty($showAbove) || !is_numeric($showAbove) || $tag.rawCount > $showAbove}
		tags += "%3Ca+href%3D%22{g->url arg1="view=tags.VirtualAlbum" arg2="tagName=$rawTagName" htmlEntities=true}%22+class%3D%22tag-link-66%22+title%3D%22{$tag.name}%22+rel%3D%22tag%22+style=%22font-size:+{$tag.count*$Magnification}pt%3B%22%3E{$tag.name}%3C%2Fa%3E%0A";
		{/if}
		{/foreach}
        
		tags = tags.replace(/\?/g, "%3F");
		tags = tags.replace(/&amp;/g, "%26");
		tags += "</tags>";

		var so = new SWFObject("{g->url href="modules/tags/flash/tagcloud.swf"}", "tagcloudflash", "{$divwidth|default:'500'}", "{$divheight|default:'400'}", "7", "#{$bgcolor|default:'292929'}");
		so.addVariable("tcolor", "0x{$fontcolor|default:'EBAF00'}");
		so.addVariable("tspeed", "{$speed|default:'100'}");
		{if !empty($bgcolor)}{else}so.addParam("wmode", "transparent");{/if}
		so.addVariable("tagcloud", tags);
		so.write("tagcloudflash");
	</script>
{else}
There are no tags!
{/if}
