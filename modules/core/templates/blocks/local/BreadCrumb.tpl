<div class="{$class}">{foreach name=parent from=$theme.parents item=parent}{if !$smarty.foreach.parent.last}<a href="{g->url params=$parent.urlParams}" class="BreadCrumb-{counter name="BreadCrumb"}">{$parent.title|markup:strip|default:$parent.pathComponent}</a>{else}<a href="{g->url params=$parent.urlParams}" class="BreadCrumb-{counter name="BreadCrumb"}">{$parent.title|markup:strip|default:$parent.pathComponent}</a>{/if}{if isset($separator)} {$separator} {/if}{/foreach}

  {if ($theme.pageType == 'admin' || $theme.pageType == 'module')}
  <a href="{g->url arg1="view=core.ShowItem"
		   arg2="itemId=`$theme.item.id`"}" class="BreadCrumb-{counter name="BreadCrumb"}">
     {$theme.item.title|markup:strip|default:$theme.item.pathComponent}</a>
  {else}
  <span class="BreadCrumb-{counter name="BreadCrumb"}">
     {$theme.item.title|markup:strip|default:$theme.item.pathComponent}</span>
  {/if}
</div>
