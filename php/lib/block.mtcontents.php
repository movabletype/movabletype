<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtcontents($args, $res, &$ctx, &$repeat) {
    $localvars = array(array('content', 'content_type', '_contents_counter','contents','current_timestamp','modification_timestamp','_contents_limit', 'current_timestamp_end', 'DateHeader', 'DateFooter', '_contents_glue', 'blog', 'blog_id', 'conditional', 'else_content', '__out'), common_loop_vars());

    $blog_id = isset($args['site_id']) ? $args['site_id'] : null;
    $blog_id or $blog_id = isset($args['blog_id']) ? $args['blog_id'] : null;
    $blog_id or $blog_id = $ctx->stash('blog_id');
    if (!(isset($blog_id) && $blog_id)) {
        return $ctx->mt->translate("You used an '[_1]' tag outside of the context of the site;", 'mtContents');
    }
    $blog_terms = array('blog_id' => $blog_id);

    if (!isset($res)) {
        $ctx->localize($localvars);

        $content_type = _get_content_type( $ctx, $args, $blog_terms );
        if (!is_array($content_type)) {
            $ctx->error($content_type);
            $content_type = [];
        }
        foreach ( $content_type as $c ) {
            $content_type_id[] = $c->content_type_id;
        }

        $tag = $ctx->this_tag();
        if ($tag == 'mtcontents' && isset($args['author']) )
            $ctx->__stash['contents'] = null;
        if (!empty($ctx->__stash['contents'])) {
            if (isset($args['id']) ||
                isset($args['blog_id']) ||
                isset($args['site_id']) ||
                isset($args['unique_id']) ||
                isset($args['content_type']) ||
                isset($args['days']) ||
                isset($args['include_subcategories'])
            ) {
                $ctx->__stash['contents'] = null;
            }
        }
        if (!empty($ctx->__stash['contents'])) {
            foreach ($args as $k => $v) {
                if (!substr_compare($k, 'field___', 0, 8)) {
                    $ctx->__stash['contents'] = null;
                    break;
                }
            }
        }
        if (!empty($ctx->__stash['contents'])) {
            if (isset($args['sort_by'])) {
                $ids = array();
                foreach ($ctx->__stash['contents'] as $c) {
                    $ids[] = $c->cd_id;
                }
                $ctx->__stash['contents'] = null;
                $args['content_ids'] = $ids;
            }
        }

        $counter = 0;
        $limit = $args['limit'] ?? '0';
        if (!ctype_digit($limit) && $limit === 'none') {
            $limit = 0;
            $args['limit'] = 0;
        }
        $ctx->stash('__out', false);

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
            if (preg_match('/^ContentType/', $at ?? '')) {
                $ts = $ctx->stash('current_timestamp');
                $tse = $ctx->stash('current_timestamp_end');
                if ($ts && $tse) {
                    # assign date range if we have both
                    # start and end date
                    $args['current_timestamp'] = $ts;
                    $args['current_timestamp_end'] = $tse;
                }
                if (isset($archiver)) {
                    !empty($args['limit']) or $args['limit'] = -1;
                    $archiver->setup_args($args);
                }
            }

            $cat = $ctx->stash('category');
            if (isset($cat) && $cat->category_class == 'category' && $cat->category_category_set_id > 0) {
                $args['category_set'] = $cat->category_category_set_id;
                $templatemap = $ctx->stash('_fileinfo')->templatemap();
                if ($templatemap) {
                    $cat_field = $templatemap->cat_field();
                    if ($cat_field) {
                        $args['category'] = $cat->label;
                    }
                }
            }

            if ( isset($args['offset']) && ($args['offset'] == 'auto') )
                $total_count = 0;
            $contents = $ctx->mt->db()->fetch_contents($args, isset($content_type_id) ? $content_type_id : null, $total_count);
            if ( isset($args['offset']) && ($args['offset'] == 'auto') )
                $ctx->stash('__pager_total_count', $total_count);
            $ctx->stash('contents', $contents);

        }

        $ctx->stash('_contents_glue', isset($args['glue']) ? $args['glue'] : null);
        if (!isset($contents)) {
            $limit = 0;
        }
        elseif (!$limit || ($limit > count($contents)) || ($limit == -1)) {
            $limit = count($contents);
        }
        $ctx->stash('_contents_limit', $limit);
    } else {
        $contents = $ctx->stash('contents');
        $limit = $ctx->stash('_contents_limit');
        $counter = $ctx->stash('_contents_counter');
        $out = $ctx->stash('__out');
    }

    $ctx->stash('conditional', empty($contents) ? 0 : 1);
    if (empty($contents)) {
        $ret = $ctx->_hdlr_if($args, $res, $ctx, $repeat, 0);
        if (!$repeat)
              $ctx->restore($localvars);
        return $ret;
    }

    if ($counter < $limit) {
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

function _get_content_type( $ctx, $args, $blog_terms ) {

    $content_types = array();
    $not_found_blog_ids = array();
    $blog_ids = $blog_terms['blog_id'];
    if (!is_array($blog_ids)) {
        $blog_ids = array($blog_ids);
    }

    if (isset($args['content_type']) && $args['content_type'] !== '') {
        foreach ($blog_ids as $blog_id) {
            $args['blog_id'] = $blog_id;
            $content_types = $ctx->mt->db()->fetch_content_types(array_merge($args, $blog_terms));
            if (!isset($content_types))
                $not_found_blog_ids[] = $blog_id;
        }
    } else {
        $ct = $ctx->stash('content_type');
        if (!$ct) {
            $tmpl = $ctx->stash('template');
            if ($tmpl && $tmpl->template_content_type_id) {
                $ct = $ctx->mt->db()->fetch_content_type( $tmpl->template_content_type_id );
                if (!$ct)
                    return $ctx->mt->translate('No Content Type could be found.');
            }
        }
        if ($ct) {
            $content_types[] = $ct;
        } else {
            $content_types = $ctx->mt->db()->fetch_content_types($blog_terms);
            if (!isset($content_types))
                $not_found_blog_ids[] = $blog_id;
        }
    }

    if ($not_found_blog_ids) {
        return $ctx->mt->translate(
            "Content Type was not found. Blog ID: [_1]",
            join(',', $not_found_blog_ids)
        );
    }

    if (!$content_types) {
        return $ctx->mt->translate('No Content Type could be found.');
    }

    return $content_types;
}
?>
