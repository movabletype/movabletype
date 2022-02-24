<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtentryexcerpt($args, &$ctx) {
    // todo: needs work
    $e = $ctx->stash('entry');
    if ($excerpt = $e->entry_excerpt) {
        if ((!isset($args['convert_breaks'])) || (!$args['convert_breaks'])) {
            return $excerpt;
        }
        $cb = 'convert_breaks';
        return apply_text_filter($ctx, $excerpt, $cb);
    } elseif (!empty($args['no_generate'])) {
        return '';
    }
    if (!isset($args['words'])) {
        $blog = $ctx->stash('blog');
        $words = $blog->blog_words_in_excerpt;
        if (!isset($words) or empty($words)) {
            $words = 40;
        }
        $args['words'] = $words;
    }
    
    $excerpt = $ctx->tag('MTEntryBody', $args);
    if (!$excerpt) {
        return '';
    }
    return $excerpt . '...';
}
/*
    $cb = $entry['entry_convert_breaks'];
    if ($cb) {
        if (($cb == '1') || ($cb == '__default__')) {
            # alter EntryBody, EntryMore in the event that
            # we're doing convert breaks
            $cb = 'convert_breaks';
        }
        if ($cb) {
            # invoke modifier to format
            $ctx->load_modifier($cb);
            $mod = 'smarty_modifier_'.$cb;
            $text = $mod($text);
        }
    }
*/
?>
