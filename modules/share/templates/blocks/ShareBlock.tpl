{*
 * $Revision: 1909 $
 * Read this before changing templates!  http://codex.gallery2.org/Gallery2:Editing_Templates
 *}
{g->callback type="share.ShareBlock"}
{if !($block.share.onlyWhenLoggedIn && $user.isGuest)}
<div class="{$class}">
{* Facebook link *}
<a href="http://www.facebook.com/share.php?u=<url>" class="fb_share_button" onclick="return fbs_click()" target="_blank" style="text-decoration:none;">{g->text text="Share"}</a>
{* End Facebook link *}
</div>
{/if}