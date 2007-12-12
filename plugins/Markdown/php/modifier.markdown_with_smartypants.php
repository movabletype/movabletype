<?php
# -- Smarty Modifier Interface ------------------------------------------------
function smarty_modifier_markdown_with_smartypants($text) {
	require_once "modifier.markdown.php";
	require_once "smartypants.php";
	return SmartyPants(Markdown($text));
}
?>
