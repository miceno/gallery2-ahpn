{*
 * $Revision: 16235 $
 * Read this before changing templates!  http://codex.gallery2.org/Gallery2:Editing_Templates
 *}

<script language="JavaScript" type="text/JavaScript">
{literal}
<!--
function MM_jumpMenu(targ,selObj,restore){
eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
if (restore) selObj.selectedIndex=0;
}
-->
{/literal}
</script>


<div class="{$class}">
  {g->text text="Page:"}
  {assign var="lastPage" value=0}
  {foreach name=jumpRange from=$theme.jumpRange item=page}
  {if ($page - $lastPage >= 2)}
  <span>
    {if ($page - $lastPage == 2)}
    <a href="{g->url params=$theme.pageUrl arg1="page=`$page-1`"}">{$page-1}</a>
    {else}
    ...
    {/if}
  </span>
  {/if}

  <span>
    {if ($theme.currentPage == $page)}
    {$page}
    {else}
    <a href="{g->url params=$theme.pageUrl arg1="page=$page"}">{$page}</a>
    {/if}
  </span>
  {assign var="lastPage" value=$page}
  {/foreach}
</div>

<form name="form" id="form">
<div class="{$class}">
  {g->text text="Page:"}
  {assign var="page" value=1}
    <select name="jumpMenu" id="jumpMenu" onchange="MM_jumpMenu('parent',this,0)">
		<option value="#">{$theme.currentPage}</option>
      {section name=selectPage loop=$theme.totalPages}
<option value="{g->url params=$theme.pageUrl arg1="page=$page"}" {if $page==$theme.currentPage}selected="selected"{/if}>{$page}</option>
	    {assign var="page" value=$page+1}
      {/section}
    </select>
</div>
</form>


