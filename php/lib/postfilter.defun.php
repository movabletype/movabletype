<?php

function smarty_postfilter_defun($source, $ctx) { 
    $search = '("' . md5('php-5') . '\[\[[0-9a-f]{32}";)'; 
    if ((double)phpversion()>=5.0) { 
        /* filter sourcecode. look for func_keys and replace all $this 
           in-between with $smarty */ 
        while (1) { 
            $new_source = preg_replace_callback('/' . $search . '(.*)\\1/Us', 'smarty_replace_fun', $source); 
            if (strcmp($new_source, $source)==0) break; 
            $source = $new_source; 
        } 
    } else { 
        /* remove func_keys */ 
        $source = preg_replace('/' . $search . '/', '', $source); 
    }
    return $source; 
}


/* callback: replace all $this with $_smarty_tpl */ 
function smarty_replace_fun($match) { 
    $tokens = token_get_all('<?php ' . $match[2]); 
    for ($i=0, $count=count($tokens); $i<$count; $i++) { 
        if (is_array($tokens[$i])) { 
            if ($tokens[$i][0] == T_VARIABLE && $tokens[$i][1] == '$this') { 
                $tokens[$i] = '$_smarty_tpl'; 
            } else {
                $tokens[$i] = $tokens[$i][1]; 
            } 
        } 
    } 
    $result = implode('', $tokens); 
    $result = preg_replace('/^<\?php/', '', $result);
    return $result;
} 

