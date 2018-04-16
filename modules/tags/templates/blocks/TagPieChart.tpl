{*
 * $Revision: 11 $
 * Read this before changing templates!  http://codex.gallery2.org/Gallery2:Editing_Templates
 *}
{g->callback type="tags.GetTagCloud" totalTagCount=true}
{if !empty($block.tags.taglist)}
<script type="text/javascript" src="{g->url href="modules/tags/js/swfobject.js"}"></script>
<div id="tag_chart"></div>

<script type="text/javascript">
var so = new SWFObject("{g->url href="modules/tags/flash/open-flash-chart.swf"}", "ofc", "{$divwidth|default:'500'}", "{$divheight|default:'400'}", "9", "#FFFFFF");
so.addVariable("variables","true");
so.addVariable("title","{$title},{ldelim}font-size:{$fontsize|default:'20'}px; color:#{$fontcolor|default:'000000'}{rdelim}");
so.addVariable("pie","90,#9933CC,{ldelim}{if $showtlabels}font-size: 12px; color: {$fontcolor|default:'000000'}{else}display: none;{/if}{rdelim}");
so.addVariable("bg_colour","#{$bgcolor|default:"ffffff"}")
{* comma at after each value but not at end *}
{assign var="comma" value="0"}
so.addVariable("values","{foreach from=$block.tags.taglist item=tag key=rawTagName name=tags}
				{if empty($showAbove) || !is_numeric($showAbove) || $tag.rawCount > $showAbove}
					{if $comma=="0"}{else},{/if}{$tag.rawCount}{assign var="comma" value=$comma+1}
				{/if}
				{/foreach}");
so.addVariable("colours","#d01f3c,#356aa0,#C79810,#901f3c,#35ffa0,#C798ff,#123456,#a1a1a1,#a1b2c3d4");
{assign var="comma" value="0"}
so.addVariable("links","{foreach from=$block.tags.taglist item=tag key=rawTagName name=tags}
				{if empty($showAbove) || !is_numeric($showAbove) || $tag.rawCount > $showAbove}
					{if $comma=="0"}{else},{/if}{capture name=link}{g->url arg1="view=tags.VirtualAlbum" arg2="tagName=$rawTagName" htmlEntities=true}{/capture}{$smarty.capture.link|replace:'&':'%26'|replace:'+':'%2B'|replace:'amp;g2':'g2'}{assign var="comma" value=$comma+1}
				{/if}
				{/foreach}");
{assign var="comma" value="0"}
so.addVariable("pie_labels","{foreach from=$block.tags.taglist item=tag key=rawTagName name=tags}
				{if empty($showAbove) || !is_numeric($showAbove) || $tag.rawCount > $showAbove}
					{if $comma=="0"}{else},{/if}{$rawTagName|replace:" ":"+"|replace:"&":"%26"}{assign var="comma" value=$comma+1}
				{/if}
				{/foreach}");
so.addVariable("x_label_style","25,#9933CC,0");
so.addVariable("tool_tip","#x_label#<br>{g->text text="Items"}:#val#");
so.addParam("allowScriptAccess", "always" );//"sameDomain");
so.write("tag_chart");
</script>
{/if}