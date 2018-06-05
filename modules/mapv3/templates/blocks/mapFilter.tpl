{*
 * $Revision: 1253 $
 * Read this before changing templates!  http://codex.gallery2.org/Gallery2:Editing_Templates
 *}

{g->callback type="mapv3.LoadFilters"}
<style>
    {literal}
    .map_thumbs_top{
    }
    .map_filter_wrapper {
        position: relative;
    }
    .filter_select {
        width: 75%;
    }
    .filter_column {
        width: 200px;
    }
    .filter_table {
        width: 400px;
        border: 0;
    }
  {/literal}
</style>
{if !empty($block.mapv3.LoadFilters)}
<div class="{$class}{if $mapv3.ShowFilters eq 2} map_filter_wrapper{/if}{if $mapv3.ShowFilters eq 3} map_thumbs_top{/if}">
  {if isset($mapv3.ShowFilters) and ($mapv3.ShowFilters eq 3 or $mapv3.ShowFilters eq 4)}
  <table class="filter_table">
    <tr>
      <td class="filter_column">
  {/if}
  <h3>{g->text text="Area to show on the Map"}</h3>
  {if isset($mapv3.ShowFilters) and ($mapv3.ShowFilters eq 3 or $mapv3.ShowFilters eq 4)}</td><td class="filter_column">{/if}
    <select class="filter_select" onchange="{literal}if (this.value) { newLocation = this.value; this.options[0].selected = true; location.href= newLocation; }{/literal}">
    {foreach item=option from=$block.mapv3.LoadFilters.filters}
       <option label="{$option.name}" {if $option.params neq ''}value="{g->url params=$option.params}"{/if} {if $option.name eq $block.mapv3.LoadFilters.filterOn}selected{/if}>{$option.name}</option>
    {/foreach}
  </select>
  {if isset($mapv3.ShowFilters) and ($mapv3.ShowFilters eq 3 or $mapv3.ShowFilters eq 4)}{strip}
      </td>
    </tr>
  </table>{/strip}{/if}
</div>
{/if}