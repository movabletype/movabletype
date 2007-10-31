<?php
function smarty_modifier_spam_protect($text) {
    # defined in mt.php itself
    return spam_protect($text);
}
?>
