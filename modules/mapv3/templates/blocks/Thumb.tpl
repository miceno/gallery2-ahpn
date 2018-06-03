{*
 * $Revision: 1253 $
 * Read this before changing templates!  http://codex.gallery2.org/Gallery2:Editing_Templates
 *}
{if $mapv3.ThumbBarPos eq "1" or $mapv3.ThumbBarPos eq "2"}
<script type="text/javascript">
document.write('<div id="thumbs" class="thumbbar" style="{if $mapv3.ThumbBarPos eq "1"}margin-bottom:{else}margin-top:{/if}4px;width: '+myWidth+'px;"><\/div>');
</script>
{/if}
{if $mapv3.ThumbBarPos eq "3" or $mapv3.ThumbBarPos eq "4"}
<script type="text/javascript">
document.write('<div id="thumbs" class="thumbbar gcBackground1" style="{if $mapv3.ThumbBarPos eq "3"}position:absolute;right:{if ($mapv3.LegendPos eq '2' and $mapv3.LegendFeature neq '0' and ($mapv3.AlbumLegend or $mapv3.PhotoLegend or $mapv3.regroupItems)) or ($mapv3.FilterFeature neq '0' and isset($mapv3.ShowFilters) and $mapv3.ShowFilters eq '2')}205{else}10{/if}px;margin-left:4px;{/if}height: '+myHeight+'px;"><\/div>');
</script>
{/if}