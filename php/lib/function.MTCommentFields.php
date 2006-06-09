<?php
function smarty_function_MTCommentFields($args, &$ctx) {
    // TODO: new tag
    $blog = $ctx->stash('blog');

    if (!($blog['blog_allow_reg_comments'] || $blog['blog_allow_unreg_comments'])) {
        return '';
    }

    $cfg =& $ctx->mt->config;
    require_once "function.MTCGIPath.php";
    $path = smarty_function_MTCGIPath($args, $ctx);
    $comment_script = $cfg['CommentScript'];
    $e =& $ctx->stash('entry');
    if (!$e) {
        return $ctx->error('No entry available');
    }
    $entry_id = $e['entry_id'];

    $signon_url = $cfg['SignOnURL'];

    $allow_comment_html_note = (($blog['blog_allow_comment_html'])
                                   ? $ctx->mt->translate("(You may use HTML tags for style)") : "");
    $needs_email = $blog['blog_require_comment_emails'] ? "&amp;need_email=1" : "";
    $registration_required = ($blog['blog_allow_reg_comments']
                                 && !$blog['blog_allow_unreg_comments']);
    $registration_allowed = $blog['blog_allow_reg_comments'];
    $unregistered_allowed = $blog['blog_allow_unreg_comments'];

    $static_arg = $args['static'] ? "static=1" : "static=0";
    $static_field = ($args['static'] || !isset($args['static']))
                        ? ('<input type="hidden" name="static" value="1" />')
                        : ('<input type="hidden" name="static" value="0" />');

    $typekey_version = $cfg['TypeKeyVersion'];

    $comment_author = "";
    $comment_email = "";
    $comment_text = "";
    $comment_url = "";
    if ($args['preview']) {
        $ctx->localize(array('tag'));
        $ctx->stash('tag', 'Preview');
        require_once("MTUtil.php");
        $comment_author = encode_html($ctx->tag('CommentAuthor')) || "";
        $comment_email = encode_html($ctx->tag('CommentEmail')) || "";
        $comment_text = encode_html($ctx->tag('CommentBody',array('convert_breaks'=>0))) || "";
        $comment_url = encode_html($ctx->tag('CommentURL')) || "";
        $ctx->restore(array('tag'));
    }

    global $_typekeytoken_cache;
    $blog = $ctx->stash('blog');
    $blog_id = $blog['blog_id'];
    $token = 0;
    if (isset($_typekeytoken_cache[$blog_id])) {
        $token = $_typekeytoken_cache[$blog_id];
    } else {
        $token = $blog['blog_remote_auth_token'];
        if ($token) {
            $_typekeytoken_cache[$blog_id] = $token;
        }
    }

    $rem_auth_token = $token;
    if (!$rem_auth_token && $registration_required) {
        return $ctx->error("To enable comment registration, you need to add a TypeKey token "
            . "in your weblog config or author profile.");
    }

    $tk_version = $cfg['TypeKeyVersion'];

    if ($registration_required) {
#return MT->translate_templatized(<<HTML);
        $tmpl = <<<HTML
<div id="thanks">
<p><MT_TRANS phrase="Thanks for signing in,">
<script>document.write(getCookie("commenter_name"))</script>.
<MT_TRANS phrase="Now you can comment."> (<a href="$path$comment_script?__mode=handle_sign_in&amp;$static_arg&amp;entry_id=$entry_id&amp;logout=1"><MT_TRANS phrase="sign out"></a>)</p>

<MT_TRANS phrase="(If you haven't left a comment here before, you may need to be approved by the site owner before your comment will appear. Until then, it won't appear on the entry. Thanks for waiting.)">

<form method="post" action="$path$comment_script" name="comments_form" onsubmit="if (this.bakecookie[0].checked) rememberMe(this)">
$static_field
<input type="hidden" name="entry_id" value="$entry_id" />

<p><label for="url">URL:</label><br />
<input tabindex="1" type="text" name="url" id="url" value="$comment_url" />

<MT_TRANS phrase="Remember me?">
<input type="radio" id="remember" name="bakecookie" /><label for="bakecookie"><label for="remember"><MT_TRANS phrase="Yes"></label><input type="radio" id="forget" name="bakecookie" onclick="forgetMe(this.form)" value="Forget Info" style="margin-left: 15px;" /><label for="forget"><MT_TRANS phrase="No"></label><br style="clear: both;" /></p>

<p><label for="text"><MT_TRANS phrase="Comments:"></label><br />
<textarea tabindex="2" id="text" name="text" rows="10" cols="50" id="text">$comment_text</textarea></p>

<div align="center">
<input type="submit" name="preview" value="&nbsp;<MT_TRANS phrase="Preview">&nbsp;" />
<input style="font-weight: bold;" type="submit" name="post" value="&nbsp;<MT_TRANS phrase="Post">&nbsp;" />
</div>

</form>
</div>

<script type="text/javascript">
<!--    
if (getCookie("commenter_name")) {
    document.getElementById('thanks').style.display = 'block';
} else {
    document.write('<MT_TRANS phrase="You are not signed in. You need to be registered to comment on this site." escape="singlequotes"> <a href="$signon_url$needs_email&amp;t=$rem_auth_token&amp;v=$tk_version&amp;_return=$path$comment_script%3f__mode=handle_sign_in%26$static_arg%26entry_id=$entry_id"><MT_TRANS phrase="Sign in" escape="singlequotes"></a>');
    document.getElementById('thanks').style.display = 'none';
}// --></script>
HTML;
        return $ctx->mt->translate_templatized($tmpl);
    } else {
        $result = "";
        if ($rem_auth_token) {
            $tmpl = <<<HTML
<script type="text/javascript">
<!--
if (getCookie("commenter_name")) {
    document.write('<MT_TRANS phrase="Thanks for signing in," escape="singlequotes"> ', getCookie("commenter_name"), '<MT_TRANS phrase=". Now you can comment." escape="singlequotes"> (<a href="$path$comment_script?__mode=handle_sign_in&amp;$static_arg&amp;entry_id=$entry_id&amp;logout=1"><MT_TRANS phrase="sign out" escape="singlequotes"></a>)');
} else {
    document.write('<MT_TRANS phrase="If you have a TypeKey identity, you can " escape="singlequotes"><a href="$signon_url$needs_email&amp;t=$rem_auth_token&amp;v=$tk_version&amp;_return=$path$comment_script%3f__mode=handle_sign_in%26$static_arg%26entry_id=$entry_id"> <MT_TRANS phrase="sign in" escape="singlequotes"></a> <MT_TRANS phrase="to use it here." escape="singlequotes">');}
// -->
</script>
HTML;
            $result .= $ctx->mt->translate_templatized($tmpl);
        }
        $tmpl = <<<HTML
<form method="post" action="$path$comment_script" name="comments_form" onsubmit="if (this.bakecookie[0].checked) rememberMe(this)">$static_field
<input type="hidden" name="entry_id" value="$entry_id" />
<div id="name_email">
<p><label for="author"><MT_TRANS phrase="Name:"></label><br />
<input tabindex="1" name="author" id="author" value="$comment_author" /></p>

<p><label for="email"><MT_TRANS phrase="Email Address:"></label><br />
<input tabindex="2" name="email" id="email" value="$comment_email" /></p>
</div>
HTML;
        if ($rem_auth_token) {
            $tmpl = <<<HTML
<script type="text/javascript">
<!--
if (getCookie("commenter_name")) {
    document.getElementById('name_email').style.display = 'none';
}
// -->
</script>
HTML;
            $result .= $ctx->mt->translate_templatized($tmpl);
        }
        $tmpl = <<<HTML
<p><label for="url"><MT_TRANS phrase="URL:"></label><br />
<input tabindex="3" type="text" name="url" id="url" value="$comment_url" />

<MT_TRANS phrase="Remember me?">
<input type="radio" id="remember" name="bakecookie" /><label for="remember"><MT_TRANS phrase="Yes"></label><input type="radio" id="forget" name="bakecookie" onclick="forgetMe(this.form)" value="Forget Info" style="margin-left: 15px;" /><label for="forget"><MT_TRANS phrase="No"></label><br style="clear: both;" /></p>

<p><label for="text"><MT_TRANS phrase="Comments:"></label> $allow_comment_html_note<br />
<textarea tabindex="4" name="text" rows="10" cols="50" id="text">$comment_text</textarea></p>

<div align="center">
<input type="submit" name="preview" value="&nbsp;<MT_TRANS phrase="Preview">&nbsp;" />
<input style="font-weight: bold;" type="submit" name="post" value="&nbsp;<MT_TRANS phrase="Post">&nbsp;" />
</div>

</form>

HTML;
        $result .= $ctx->mt->translate_templatized($tmpl);
        return $result;
    }
}
?>
