<?php
# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtcclicenserdf($args, &$ctx) {
    // status: complete
    // parameters: none
    $blog = $ctx->stash('blog');
    $cc = $blog['blog_cc_license'];
    if (empty($cc)) return '';

    require_once("cc_lib.php");
    require_once("MTUtil.php");
    $cc_url = cc_url($cc);
    $rdf = <<<RDF
<!--
<rdf:RDF xmlns="http://web.resource.org/cc/"
         xmlns:dc="http://purl.org/dc/elements/1.1/"
         xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">

RDF;
    ## SGML comments cannot contain double hyphens, so we convert
    ## any double hyphens to single hyphens.
    $entry = $ctx->stash('entry');
    if ($entry) {
        $permalink = $ctx->tag('EntryPermalink');
        $title = encode_xml(strip_hyphen($entry['entry_title']));
        $desc = encode_xml(strip_hyphen($ctx->tag('EntryExcerpt')));
        $creator = encode_xml(strip_hyphen($entry['entry_author_id'] ? $entry['author_name'] : ''));
        $date = $ctx->_hdlr_date(array('format' => "%Y-%m-%dT%H:%M:%S"), $ctx) . $ctx->tag('BlogTimezone');
        $rdf .= <<<RDF
<Work rdf:about="$permalink">
<dc:title>$title</dc:title>
<dc:description>$desc</dc:description>
<dc:creator>$creator</dc:creator>
<dc:date>$date</dc:date>
<license rdf:resource="$cc_url" />
</Work>

RDF;
    } else {
        $site_url = $blog['blog_site_url'];
        if (!preg_match('!/$!', $site_url))
            $site_url .= '/';

        $title = encode_xml(strip_hyphen($blog['blog_name']));
        $desc = encode_xml(strip_hyphen($blog['blog_description']));
        $rdf .= <<<RDF
<Work rdf:about="$site_url">
<dc:title>$title</dc:title>
<dc:description>$desc</dc:description>
<license rdf:resource="$cc_url" />
</Work>

RDF;
    }
    $rdf .= cc_rdf($cc) . "</rdf:RDF>\n-->\n";
    return $rdf;
}
?>
