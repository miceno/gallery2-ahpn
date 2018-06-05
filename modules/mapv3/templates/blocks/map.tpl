{*
 * $Revision: 1253 $
 * Read this before changing templates!  http://codex.gallery2.org/Gallery2:Editing_Templates
 *}

{g->callback type="mapv3.LoadFilters"}
{if !empty($block.mapv3.LoadFilters)}
<div class="{$class}" {if $mapv3.ShowFilters eq 2}style="right:10px;{if $mapv3.ThumbBarPos eq '1'}position:relative;top:-{$mapv3.ThumbHeight}px;{/if}"{/if}>
  {if isset($mapv3.ShowFilters) and ($mapv3.ShowFilters eq 3 or $mapv3.ShowFilters eq 4)}
  <table border=0 width=400px><tr><td width=200px>
  {/if}
  <h3>{g->text text="Area to show on the Map"}</h3>
  {if isset($mapv3.ShowFilters) and ($mapv3.ShowFilters eq 3 or $mapv3.ShowFilters eq 4)}</td><td width=200px>{/if}
    <select style="width:75%;" onchange="{literal}if (this.value) { newLocation = this.value; this.options[0].selected = true; location.href= newLocation; }{/literal}">
    {foreach item=option from=$block.mapv3.LoadFilters.filters}
       <option label="{$option.name}" {if $option.params neq ''}value="{g->url params=$option.params}"{/if} {if $option.name eq $block.mapv3.LoadFilters.filterOn}selected{/if}>{$option.name}</option>
    {/foreach}
  </select>
  {if isset($mapv3.ShowFilters) and ($mapv3.ShowFilters eq 3 or $mapv3.ShowFilters eq 4)}</td></tr></table>{/if}
</div>
{/if}