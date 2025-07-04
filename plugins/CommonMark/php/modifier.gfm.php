<?php
require_once __DIR__ . "/vendor/autoload.php";
use League\CommonMark\GithubFlavoredMarkdownConverter;

function GitHubFlavoredMarkdown() {
    global $GFM;
    if (!is_object($GFM)) {
        $GFM = new GitHubFlavoredMarkdownConverter([
            'allow_unsafe_links' => false,
        ]);
    }
    return $GFM;
}

# -- Smarty Modifier Interface ------------------------------------------------
/**
 * @throws \League\CommonMark\Exception\CommonMarkException
 */
function smarty_modifier_gfm($text) {
    $gfm = GitHubFlavoredMarkdown();
    $converter =& $gfm;

    return $converter->convert($text);
}
