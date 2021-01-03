<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("archive_lib.php");
function smarty_function_mtentrytrackbackdata($args, &$ctx) {
    $e = $ctx->stash('entry');
    $tb = $e->trackback();
    if (empty($tb))
        return '';
    if ($tb->trackback_is_disabled)
        return '';

    $blog = $ctx->stash('blog');
    $entry = $ctx->stash('entry');
    $blog_accepted = $blog->blog_allow_pings && $ctx->mt->config('AllowPings');
    if ($entry) {
        $accepted = $blog_accepted && $entry->entry_allow_pings;
    } else {
        $accepted = $blog_accepted;
    }
    if (!$accepted)
        return '';

    require_once "function.mtcgipath.php";
    $path = smarty_function_mtcgipath($args, $ctx);
    $path .= $ctx->mt->config('TrackbackScript') . '/' . $tb->trackback_id;

    $at = $ctx->stash('current_archive_type');
    if ($at)
        $at = ArchiverFactory::get_archiver($at);
    if ($at && !( $at instanceof IndividualArchiver )) {
        $url = $ctx->tag('ArchiveLink');
        $url .= '#entry-' . sprintf("%06d", $e->entry_id);
    } else {
        $url = $ctx->tag($e->entry_class.'Permalink', array('archive_type' => 'Individual'));
    }
    $rdf = '';
    $comment_wrap = isset($args['comment_wrap']) ?
        $args['comment_wrap'] : 1;
    if ($comment_wrap) {
        $rdf .= "<!--\n";
    }
    require_once("MTUtil.php");
    ## SGML comments cannot contain double hyphens, so we convert
    ## any double hyphens to single hyphens.
    $title = encode_xml(strip_hyphen($e->entry_title), 1);
    $subject = encode_xml(strip_hyphen($ctx->tag('EntryCategory')), 1);
    $excerpt = encode_xml(strip_hyphen($ctx->tag('EntryExcerpt')), 1);
    $creator = encode_xml(strip_hyphen($ctx->tag('EntryAuthorDisplayName')), 1);
    $date = $ctx->_hdlr_date(array('format' => '%Y-%m-%dT%H:%M:%S'), $ctx) .
            $ctx->tag('BlogTimezone');
    $rdf .= <<<RDF
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:trackback="http://madskills.com/public/xml/rss/module/trackback/"
         xmlns:dc="http://purl.org/dc/elements/1.1/">
<rdf:Description
    rdf:about="$url"
    trackback:ping="$path"
    dc:title="$title"
    dc:identifier="$url"
    dc:subject="$subject"
    dc:description="$excerpt"
    dc:creator="$creator"
    dc:date="$date" />
</rdf:RDF>

RDF;
    if ($comment_wrap) {
        $rdf .= "-->\n";
    }
    return $rdf;
}
?>
