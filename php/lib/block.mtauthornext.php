<?php
function smarty_block_mtauthornext($args, $content, &$ctx, &$repeat) {
    static $_next_cache = array();
    if (!isset($content)) {
        $ctx->localize(array('author', 'conditional', 'else_content'));
        $author = $ctx->stash('author');
        if ($author) {
            $author_id = $author['author_id'];
            if (isset($_next_cache[$author_id])) {
                $next_author = $_next_cache[$author_id];
            } else {
                $name = $author['author_name'];
                $blog_id = $ctx->stash('blog_id');
                $args = array('sort_by' => 'author_name',
                              'sort_order' => 'ascend',
                              'start_string' => $name,
                              'lastn' => 1,
                              'blog_id' => $blog_id,
                              'need_entry' => 1);
                list($next_author) = $ctx->mt->db->fetch_authors($args);
                if ($next_author) $_next_cache[$author_id] = $next_author;
            }
            $ctx->stash('author', $next_author);
        }
        $ctx->stash('conditional', isset($next_author));
        $ctx->stash('else_content', null);
    } else {
        if (!$ctx->stash('conditional')) {
            $content = $ctx->stash('else_content');
        }
        $ctx->restore(array('author', 'conditional', 'else_content'));
    }
    return $content;
}
?>
