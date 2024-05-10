<?php

$finder = (new PhpCsFixer\Finder())
    ->exclude('php/extlib')
    ->notPath('t/lib/JSON.php')
    ->in('.')
;

return (new PhpCsFixer\Config())
    ->setFinder($finder)
    ->setRules([
        '@PSR2' => true,
        'array_syntax' => ['syntax' => 'long'],
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
        'braces' => [
            'allow_single_line_closure' => true,
            'position_after_anonymous_constructs' => 'same',
            'position_after_control_structures' => 'same',
            'position_after_functions_and_oop_constructs' => 'same',
        ],
    ])
;
