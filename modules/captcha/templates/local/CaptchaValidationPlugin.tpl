{*
 * $Revision: 15342 $
 * If you want to customize this file, do not edit it directly since future upgrades
 * may overwrite it.  Instead, copy it into a new directory called "local" and edit that
 * version.  Gallery will look for that file first and use it if it exists.
 *}
<div class="gbBlock">
  <h3 style="font-size:12px;">
    {g->text text="Type the word appearing in the picture."}
  </h3>
  <div style="margin-bottom: 5px">
    <img src="{g->url arg1="view=captcha.CaptchaImage"}" width="100" height="100" alt=""/>
  </div>
  <input type="text" size="12"
   name="{g->formVar var="form[CaptchaValidationPlugin][word]"}" value=""/>

  {if isset($form.error.CaptchaValidationPlugin)}
    <div class="giError" style="margin-top: 5px;">
      {if isset($form.error.CaptchaValidationPlugin.missing)}
        {g->text text="You must enter the number appearing in the picture."}
      {/if}
      {if isset($form.error.CaptchaValidationPlugin.invalid)}
        {g->text text="Incorrect number."}
      {/if}
    </div>
  {/if}
</div>