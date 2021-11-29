<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function _file_template_format($m) {
    static $f = array(
        'a' => "<MTAuthorBasename DIR>",
        '-a' => "<MTAuthorBasename separator='-'>",
        '_a' => "<MTAuthorBasename separator='_'>",
        'b' => "<MTEntryBasename SEP>",
        '-b' => "<MTEntryBasename separator='-'>",
        '_b' => "<MTEntryBasename separator='_'>",
        'c' => "<MTSubCategoryPath SEP>",
        '-c' => "<MTSubCategoryPath separator='-'>",
        '_c' => "<MTSubCategoryPath separator='_'>",
        'C' => "<MTCategoryBasename DIR>",
        '-C' => "<MTCategoryBasename separator='-'>",
        'd' => "<MTArchiveDate format='%d'>",
        'D' => "<MTArchiveDate format='%e' trim='1'>",
        'e' => "<MTEntryID pad='1'>",
        'E' => "<MTEntryID pad='0'>",
        'f' => "<MTArchiveFile SEP>",
        '-f' => "<MTArchiveFile separator='-'>",
        'F' => "<MTArchiveFile extension='0' SEP>",
        '-F' => "<MTArchiveFile extension='0' separator='-'>",
        'h' => "<MTArchiveDate format='%H'>",
        'H' => "<MTArchiveDate format='%k' trim='1'>",
        'i' => '<MTIndexBasename extension="1">',
        'I' => "<MTIndexBasename>",
        'j' => "<MTArchiveDate format='%j'>",  # 3-digit day of year
        'm' => "<MTArchiveDate format='%m'>",  # 2-digit month
        'M' => "<MTArchiveDate format='%b'>",  # 3-digit month
        'n' => "<MTArchiveDate format='%M'>",  # 2-digit minute
        's' => "<MTArchiveDate format='%S'>",  # 2-digit second
        'x' => "<MTBlogFileExtension>",
        'y' => "<MTArchiveDate format='%Y'>",  # year
        'Y' => "<MTArchiveDate format='%y'>",  # 2-digit year
    );
    return isset($f[$m[1]]) ? $f[$m[1]] : $m[1];
}

function smarty_function_mtfiletemplate($args, &$ctx) {
    static $_file_template_cache = array();
    $at = $ctx->stash('archive_type');
    $at or $at = $ctx->stash('current_archive_type');
    $format = $args['format'];
    if (!$format) {
        $formats = array(
            'Individual' => '%y/%m/%f',
            'Category' => '%c/%f',
            'Monthly' => '%y/%m/%f',
            'Weekly' => '%y/%m/%d-week/%f',
            'Daily' => '%y/%m/%d/%f'
        );
        $format = $formats[ $at ];
    }
    if (!$format) return '';

    #my ($dir, $sep);
    if (!empty($args['separator'])) {
        $dir = "dirify='" . $args['separator'] . "'";
        $sep = "separator='" . $args['separator'] . "'";
    } else {
        $dir = "dirify='1'";
        $sep = "";
    }
    $orig_format = $format;
    $format = preg_replace_callback('/%([_-]?[A-Za-z])/',
        '_file_template_format', $format);
    $format = preg_replace('/SEP/', $sep, $format);
    $format = preg_replace('/DIR/', $dir, $format);

    # now build this template and return result
    if (isset($_file_template_cache[$format])) {
        $_var_compiled = $_file_template_cache[$format];
    } else {
        if ($ctx->_compile_source('evaluated template', $format, $_var_compiled)) {
            $_file_template_cache[$format] = $_var_compiled;
        } else {
            return $ctx->error("Error compiling file template: '$orig_format'");
        }
    }

    ob_start();
    $ctx->_eval('?>' . $_var_compiled);
    $file = ob_get_contents();
    ob_end_clean();

    $file = preg_replace('/\/{2,}/', '/', $file);
    $file = preg_replace('/(^\/|\/$)/', '', $file);
    return $file;
}
?>
