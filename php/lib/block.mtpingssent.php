<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtpingssent($args, $content, &$ctx, &$repeat) {
    $localvars = array('_pinged_urls', '_ping_urls_counter', 'ping_sent_url');
    if (!isset($content)) {
        $ctx->localize($localvars);
        $entry = $ctx->stash('entry');
        $ping_list = $entry['entry_pinged_urls'];
        $pings = preg_split('/\r?\n/', $ping_list);
        $ctx->stash('_pinged_urls', $pings);
        $counter = 0;
    } else {
        $pings = $ctx->stash('_pinged_urls');
        $counter = $ctx->stash('_ping_urls_counter');
    }
    if ($counter < count($pings)) {
        $ping = $pings[$counter];
        $ctx->stash('ping_sent_url', $ping);
        $ctx->stash('_ping_urls_counter', $counter + 1);
        $repeat = true;
    } else {
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
