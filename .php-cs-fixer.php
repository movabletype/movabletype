<?php

$finder = (new PhpCsFixer\Finder())
    ->exclude('php/extlib')
    ->exclude('plugins/Markdown')
    ->exclude('plugins/Textile')
    ->notPath('t/lib/JSON.php')
    ->in('.')
;

return (new PhpCsFixer\Config())
    ->setFinder($finder)
    ->setRules([
        '@PSR2' => true,
        'array_syntax' => ['syntax' => 'short'],
        'function_typehint_space' => true,
        'no_unused_imports' => true,
        'no_empty_comment' => true,
        'no_empty_phpdoc' => true,
        'no_whitespace_before_comma_in_array' => true,
        // 'ordered_imports' => true,
        'elseif' => true,
        'return_type_declaration' => true,
        'ternary_operator_spaces' => true,
        'whitespace_after_comma_in_array' => true,
        'braces_position' => [
            'functions_opening_brace' => 'same_line',
            'classes_opening_brace' => 'same_line',
        ],
        'no_whitespace_in_blank_line' => true,
    ])
;
