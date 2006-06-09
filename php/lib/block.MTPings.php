<?php
function smarty_block_MTPings($args, $content, &$ctx, &$repeat) {
    $localvars = array('ping', '_pings', '_pings_counter', 'current_timestamp');
    if (!isset($content)) {
        $ctx->localize($localvars);
        $entry = $ctx->stash('entry');
        if (isset($entry)) {
            $args['entry_id'] = $entry['entry_id'];
        }
        $pings = $ctx->mt->db->fetch_pings($args);
        $ctx->stash('_pings', $pings);
        $counter = 0;
    } else {
        $pings = $ctx->stash('_pings');
        $counter = $ctx->stash('_pings_counter');
    }
    if ($counter < count($pings)) {
        $ping = $pings[$counter];
        $ctx->stash('ping', $ping);
        $ctx->stash('current_timestamp', $ping['tbping_created_on']);
        $ctx->stash('_pings_counter', $counter + 1);
        $repeat = true;
    } else {
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
