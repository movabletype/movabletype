<?php
function smarty_block_mtauthors($args, $content, &$ctx, &$repeat) {
    $localvars = array('authors', 'authors_counter', 'blog_id');
    if (!isset($content)) {
        $ctx->localize($localvars);
        $args['blog_id'] = $ctx->stash('blog_id');
        if (isset($args['display_name'])) {
            $args['author_nickname'] = $args['display_name'];
        }
        if (isset($args['sort_by'])) {
            if ($args['sort_by'] == 'display_name') {
                $args['sort_by'] = 'nickname';
            }
            $args['sort_by'] = 'author_'.$args['sort_by'];
        } else {
            $args['sort_by'] = 'author_created_on';
        }
        $authors = $ctx->mt->db->fetch_authors($args);
        $ctx->stash('authors', $authors);
        $counter = 0;
    } else {
        $authors = $ctx->stash('authors');
        $counter = $ctx->stash('authors_counter');
    }
    if ($counter < count($authors)) {
        $author = $authors[$counter];
        $ctx->stash('author', $author);
        $ctx->stash('authors_counter', $counter + 1);
        $repeat = true;
    } else {
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
