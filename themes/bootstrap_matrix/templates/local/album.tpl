{*
 * $Revision: 16349 $
 * Read this before changing templates!  http://codex.gallery2.org/Gallery2:Editing_Templates
 *}
<div class="theme-body pure-g">
    {if !empty($theme.params.sidebarBlocks)}
    <div id="gsSidebarCol" class="pure-u-md-1-5">
      {g->theme include="sidebar.tpl"}
    </div>
    {/if}
    <div class="theme-content pure-u-md-4-5">
      {if !empty($theme.params.sidebarBlocks)}
      <script type="text/javascript">
         {* hide the sidebar if there-s nothing in it *}
         // <![CDATA[
         var el = document.getElementById("gsSidebarCol");
         var text = el.innerText;  // IE
         if (!text) text = el.textContent; // Firefox
         if (!text || !text.match(/\S/)) el.style.display = 'none';
         // ]]>
      </script>
      {/if}
      <div id="gsContent" class="gcBorder1">
        <div class="gbBlock gcBackground1">
              <div class="header">
                {if !empty($theme.item.title)}
                <h2> {$theme.item.title|markup} </h2>
                {/if}
                {if !empty($theme.item.description)}
                <p class="giDescription">
                  {$theme.item.description|markup}
                </p>
                {/if}
              </div>
                {g->block type="core.ItemInfo"
                          item=$theme.item
                          showDate=false
                          showSize=true
                          showOwner=$theme.params.showAlbumOwner
                          class="giInfo"}
        </div>

        {if !empty($theme.navigator)}
        <div class="gbBlock gcBackground2 gbNavigator">
          {g->block type="core.Navigator" navigator=$theme.navigator reverseOrder=true}
        </div>
        {/if}

		{if !count($theme.children)}
		<div class="gbBlock giDescription gbEmptyAlbum">
			<h3 class="emptyAlbum">
				{g->text text="This album is empty."}
				{if isset($theme.permissions.core_addDataItem)}
				<br/>
				<a href="{g->url arg1="view=core.ItemAdmin" arg2="subView=core.ItemAdd" arg3="itemId=`$theme.item.id`"}"> {g->text text="Add a photo!"} </a>
				{/if}
			</h3>
		</div>
		{else}

		<div class="gbBlock pure-g">
			<div id="gsThumbMatrix">
				{foreach from=$theme.children item=child}

				{assign var=childrenInColumnCount value="`$childrenInColumnCount+1`"}
				<div class="{if $child.canContainChildren}giAlbumCell gcBackground1{else}giItemCell{/if} pure-u-lg-6-24 pure-u-md-8-24"{* style="width: {$theme.columnWidthPct}%" *}>
				{if ($child.canContainChildren || $child.entityType == 'GalleryLinkItem')}
				{assign var=frameType value="albumFrame"}
				{capture assign=linkUrl}{g->url arg1="view=core.ShowItem"
				arg2="itemId=`$child.id`"}{/capture}
				{else}
				{assign var=frameType value="itemFrame"}
				{capture assign=linkUrl}{strip}
				{if $theme.params.dynamicLinks == 'jump'}
				{g->url arg1="view=core.ShowItem" arg2="itemId=`$child.id`"}
				{else}
				{g->url params=$theme.pageUrl arg1="itemId=`$child.id`"}
				{/if}
				{/strip}{/capture}
				{/if}
					<div class="thumbnail-wrapper">
						{if isset($theme.params.$frameType) && isset($child.thumbnail)}
						{g->container type="imageframe.ImageFrame" frame=$theme.params.$frameType
						width=$child.thumbnail.width height=$child.thumbnail.height}
						<a href="{$linkUrl}">
							{g->image id="%ID%" item=$child image=$child.thumbnail
							class="%CLASS% giThumbnail"}
						</a>
						{/g->container}
						{elseif isset($child.thumbnail)}
						<a href="{$linkUrl}">
							{g->image item=$child image=$child.thumbnail class="giThumbnail"}
						</a>
						{else}
						<a href="{$linkUrl}" class="giMissingThumbnail">
							{g->text text="no thumbnail"}
						</a>
						{/if}
						<div class="thumbnail-description-wrapper opensans">
							{if !empty($child.title)}
							<p class="giTitle">
							{if $child.canContainChildren && (!isset($theme.params.albumFrame)
								|| $theme.params.albumFrame == $theme.params.itemFrame)}
								{* Add prefix for albums unless imageframe will differentiate *}
								{g->text text="Album: %s" arg1=$child.title|markup}
							{else}
								{$child.title|markup}
							{/if}
							</p>
							{/if}

							{if !empty($child.summary)}
							<p class="giDescription">
								{$child.summary|markup|entitytruncate:256}
							</p>
							{/if}

							{if ($child.canContainChildren && $theme.params.showAlbumOwner) ||
								(!$child.canContainChildren && $theme.params.showImageOwner)}
							{assign var="showOwner" value=true}
							{else}
							{assign var="showOwner" value=false}
							{/if}
							{g->block type="core.ItemInfo"
								item=$child
								showDate=false
								showOwner=$showOwner
								showSize=true
								showViewCount=false
								showSummaries=true
								class="giInfo"}
						</div>{* thumbnail-description-wrapper *}
						{g->block type="core.ItemLinks" item=$child links=$child.itemLinks}
					</div> {* gallery-thumbnail *}
				</div> <!-- giAlbumCell --> {* giAlbumCell *}
				{/foreach}
			</div> <!-- gsThumbMatrix -->
		</div> <!-- gbBlock -->
		{/if} {* count theme children *}

        {if !empty($theme.navigator)}
        <div class="gbBlock gcBackground2 gbNavigator">
          {g->block type="core.Navigator" navigator=$theme.navigator reverseOrder=true}
        </div>
        {/if}

        {if !empty($theme.jumpRange)}
        <div id="gsPages" class="gbBlock gcBackground1">
          {g->block type="core.Pager"}
        </div>
        {/if}

        {g->block type="core.GuestPreview" class="gbBlock"}

	{* Our emergency edit link, if the user removes all blocks containing edit links *}
	{g->block type="core.EmergencyEditItemLink" class="gbBlock" checkBlocks="sidebar,album"}

        {* Show any other album blocks (comments, etc) *}
        {foreach from=$theme.params.albumBlocks item=block}
          {g->block type=$block.0 params=$block.1}
        {/foreach}
      </div>
    </div>
</div>
