{*
 * $Revision: 1075 $
 * Read this before changing templates!  http://codex.gallery2.org/Gallery2:Editing_Templates
 *}
{g->callback type="tags.GetTagCloud" totalTagCount=true}
{if !empty($block.tags.taglist)}
{* Get the highest tag count: used for width of number span and graph *}
{assign var="maxRawCount" value="0"}
{foreach from=$block.tags.taglist item=tag key=rawTagName name=tags}
  {if $maxRawCount < $tag.rawCount}
    {assign var="maxRawCount" value=$tag.rawCount}
  {/if}                                                        
{/foreach}
{literal}
<style type="text/css">
#tags {
	margin: 0px;
	margin-top: 5px;
	width: 210px;
	padding: 0px;
}

#tags li {
	list-style-type: none;
	position: relative;
	margin: 0px;
	height: 14px;
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #b1b1b1;
	overflow: hidden;
	font-size: 10px;
	width: 165px;
}

#tags .graph {
	display: inline;
	width: 50px;
	height: 14px;
	position: absolute;
	overflow: hidden;
{/literal}
	background-image: url({g->url href="modules/tags/images/bargraph1.gif"});
{literal}
}

#tags .level{
	display: inline;
	height: 100%;
	position: absolute;
	right: 0px;
	background-position: right top;
{/literal}
	background-image: url({g->url href="modules/tags/images/bargraph2.gif"});
{literal}
}

#tags .number {
	position: absolute;
	font-size: 10px;
	text-align: center;
	line-height: 14px;
	left: 50px;
{/literal}{if $maxRawCount <= 9}width: 9px;{elseif $maxRawCount <= 99}width: 18px;{else}width: 27px;{/if}{literal}
	color: #999999;
	background-color: #cbcbcb;
{/literal}
	{if $showtagquantity|default:'true'}{else}visibility: hidden;{/if}
{literal}
}

#tags .tag {
	{/literal}
	{if $showtagquantity|default:'true'}
	{if $maxRawCount <= 9}left: 61px;{elseif $maxRawCount <= 99}left: 70px;{else}left: 79px;{/if}
	{else}
	left: 53px;
	{/if}
	{literal}
	position: relative;
	width: 145px;
	padding-left: 0px;
}

#tags .tag a:link, #tags .tag a:visited {
	color: #666666;
	text-decoration: none;
	background-color: inherit;
}
#tags .tag a:hover, #tags .tag a:active {
	color: #000000;
	text-decoration: underline;
	background-color: inherit;
}
</style>
{/literal}
<div id="tags_table">
	<ul id="tags">
	{foreach from=$block.tags.taglist item=tag key=rawTagName name=tags}
	{if empty($showAbove) || !is_numeric($showAbove) || $tag.rawCount > $showAbove}
	{if empty($sizeLimit) || !is_numeric($sizeLimit) || $smarty.foreach.tags.iteration < $sizeLimit+1}
	  	<li>
			<span class='graph'>
				<span class='level' style='width:{$tag.rawCount/$maxRawCount*100|round}%'>
				</span> 
			</span>
			<span class='tag'>
			<a href="{g->url arg1="view=tags.VirtualAlbum" arg2="tagName=$rawTagName" htmlEntities=false}">{$tag.name}</a>
			</span>
			<span class='number'>{$tag.rawCount}</span>
		</li>
	{/if}
	{/if}
	{/foreach}
  </ul>
</div>
{/if}