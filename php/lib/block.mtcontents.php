<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtcontents($args, $res, &$ctx, &$repeat) {
    $localvars = array(array('content', '_contents_counter','contents','current_timestamp','modification_timestamp','_contents_limit', 'current_timestamp_end', 'DateHeader', 'DateFooter', '_contents_glue', 'blog', 'blog_id', 'conditional', 'else_content', '__out'), common_loop_vars());

    if (!isset($res)) {
        $ctx->localize($localvars);

        require_once('multiblog.php');
        multiblog_block_wrapper($args, $res, $ctx, $repeat);

        $content_type = _get_content_type( $ctx, $args );
        if (!is_object($content_type))
            $ctx->error($content_type);
        foreach ( $content_type as $c ) {
            $content_type_id[] = $c->content_type_id;
        }

        if ($ctx->stash('contents') && isset($args['author']) )
            $ctx->__stash['contents'] = null;
        if ($ctx->__stash['contents']) {
            if (isset($args['id']) || isset($args['days']) ) {
                $ctx->__stash['contents'] = null;
            }
            else if (isset($args['sort_by'])) {
                $ids = array();
                foreach ($ctx->__stash['contents'] as $c) {
                    $ids[] = $c->cd_id;
                }
                $ctx->__stash['contents'] = null;
                $args['content_ids'] = $ids;
            }
        }

        $counter = 0;
        $limit = $args['limit'];
        if (!ctype_digit($limit) && $limit === 'none')
            $limit = 0;
        $ctx->stash('_contents_limit', $limit);
        $ctx->stash('__out', false);
    } else {
        $limit = $ctx->stash('_contents_limit');
        $counter = $ctx->stash('_contents_counter');
        $out = $ctx->stash('__out');
    }

    $args['class'] = 'content_data';

    if ( isset($args['offset']) && ($args['offset'] == 'auto') ) {
        $l = 0;
        if ( $args['limit'] )
            $l = $args['limit'];
        $ctx->stash('__pager_limit', $l);
        if ( $_REQUEST['offset'] )
            $ctx->stash('__pager_offset', $_REQUEST['offset']);
    }

    $contents = $ctx->stash('contents');

    if (!isset($contents)) {
        require_once('archive_lib.php');
        $at = $ctx->stash('current_archive_type');
        try {
            $archiver = ArchiverFactory::get_archiver($at);
        } catch (Exception $e ) {
        }
        if (isset($args['id'])) {
            $args['content_id'] = $args['id'];
        }
        $ts = $ctx->stash('current_timestamp');
        $tse = $ctx->stash('current_timestamp_end');
        if ($ts && $tse) {
            # assign date range if we have both
            # start and end date
            $args['current_timestamp'] = $ts;
            $args['current_timestamp_end'] = $tse;
        }
        if (isset($archiver)) {
            $args['limit'] or $args['limit'] = -1;
            $archiver->setup_args($args);
        }

        if ( isset($args['offset']) && ($args['offset'] == 'auto') )
            $total_count = 0;
        $contents = $ctx->mt->db()->fetch_contents($args, $content_type_id, $total_count);
        if ( isset($args['offset']) && ($args['offset'] == 'auto') )
            $ctx->stash('__pager_total_count', $total_count);
        $ctx->stash('contents', $contents);
    }

    $ctx->stash('conditional', empty($contents) ? 0 : 1);
    if (empty($contents)) {
        $ret = $ctx->_hdlr_if($args, $res, $ctx, $repeat, 0);
        if (!$repeat)
              $ctx->restore($localvars);
        return $ret;
    }

    $ctx->stash('_contents_glue', $args['glue']);
    if (($limit > count($contents)) || ($limit == -1)) {
        $limit = count($contents);
        $ctx->stash('_contents_limit', $limit);
    }

    if ($limit ? ($counter < $limit) : ($counter < count($contents))) {
        $blog_id = $ctx->stash('blog_id');
        $content = $contents[$counter];
        if (!empty($content)) {
            if ($blog_id != $content->cd_blog_id) {
                $blog_id = $content->cd_blog_id;
                $ctx->stash('blog_id', $blog_id);
                $ctx->stash('blog', $content->blog());
            }
            if ($counter > 0) {
                $last_content_created_on = $contents[$counter-1]->cd_authored_on;
            } else {
                $last_content_created_on = '';
            }
            if ($counter < count($contents)-1) {
                $next_content_created_on = $contents[$counter+1]->cd_authored_on;
            } else {
                $next_content_created_on = '';
            }
            $content_type = $content->content_type();
            $ctx->stash('content_type', $content_type);
            $ctx->stash('content', $content);
            $ctx->stash('current_timestamp', $content->cd_authored_on);
            $ctx->stash('current_timestamp_end', null);
            $ctx->stash('modification_timestamp', $content->cd_modified_on);
            $ctx->stash('_contents_counter', $counter + 1);
            $_REQUEST['content_ids_published'][$content->cd_id] = 1;
            $glue = $ctx->stash('_contents_glue');
            if (isset($glue) && !empty($res)) {
                if ($out)
                    $res = $glue . $res;
                else
                    $ctx->stash('__out', true);
            }
            $count = $counter + 1;
            $ctx->__stash['vars']['__counter__'] = $count;
            $ctx->__stash['vars']['__odd__'] = ($count % 2) == 1;
            $ctx->__stash['vars']['__even__'] = ($count % 2) == 0;
            $ctx->__stash['vars']['__first__'] = $count == 1;
            $ctx->__stash['vars']['__last__'] = ($count == count($contents));
            $repeat = true;
        }
    } else {
        $glue = $ctx->stash('_contents_glue');
        if (isset($glue) && $out && !empty($res))
            $res = $glue . $res;
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $res;
}

function _get_content_type( $ctx, $args ) {

    $content_types = array();
    $not_found = array();

    $tmpl = $ctx->stash('template');
    if ( $tmpl && $tmpl->template_content_type_id ) {
        $template_ct = $ctx->mt->db()->fetch_content_type( $tmpl->template_content_type_id );
        if (!$template_ct)
            return;
    }

    if ( isset($args['content_type']) && $args['content_type'] !== '' ) {
        $content_types = $ctx->mt->db()->fetch_content_types($args);
        if (!isset($content_types))
            $not_found[] = $ctx->stash('blog_id');
    }
    else {
        if (isset($template_ct)) {
            $ct = $ctx->mt->db()->fetch_content_type( $template_ct->content_type_id );
            if ($ct) {
                $content_types[] = $ct;
            }
            else {
                $not_found[] = $ctx->stash('blog_id');
            }
        }
        else {
            $content_types = $ctx->mt->db()->fetch_content_types($args);
            if (!isset($content_types))
                $not_found[] = $ctx->stash('blog_id');
        }
    }

    return $not_found
        ? $ctx->mt->translate( "Content Type was not found. Blog ID: [_1]",
        array( join( ',', $not_found ) ) )
        : $content_types;
}
?>
