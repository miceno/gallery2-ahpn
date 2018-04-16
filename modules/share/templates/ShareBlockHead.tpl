{*
 * $Revision: 1905 $
 * Read this before changing templates!  http://codex.gallery2.org/Gallery2:Editing_Templates
 *}
{* Facebook recommended meta tags *}
<meta name="title" content="{$theme.item.title|default:$theme.item.pathComponent|markup:strip}" />
{if !empty($theme.item.description) || !empty($theme.item.summary)}
<meta name="description" content="{$theme.item.description|default:$theme.item.summary|markup:strip}" />
{/if}
{* End Facebook recommended meta tags *}
{* Facebook share link *}
<script>
  function fbs_click() {ldelim}
    u=location.href;
    t=document.title;
    window.open('http://www.facebook.com/sharer.php?u='+encodeURIComponent(u)+'&t='+encodeURIComponent(t),'sharer','toolbar=0,status=0,width=626,height=436');
    return false;
  {rdelim}
{* Hide the Facebook bar *}
  if (top.location != location) {ldelim}
    top.location.href = document.location.href;
  {rdelim}
</script>
<style>
  html .fb_share_button {ldelim}
    display: -moz-inline-block;
    display:inline-block;
    padding:1px 20px 0 5px;
    height:15px; border:1px solid #d8dfea;
    background:url(http://b.static.ak.fbcdn.net/rsrc.php/zAB5S/hash/4273uaqa.gif) no-repeat top right;
  {rdelim}
  html .fb_share_button:hover {ldelim}
    color:#fff;
    border-color:#295582;
    background:#3b5998 url(http://b.static.ak.fbcdn.net/rsrc.php/zAB5S/hash/4273uaqa.gif) no-repeat top right;
    text-decoration:none;
  {rdelim}
</style>
{* End Facebook share link *}