#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Template;
use MT::Template::Node ':constants';
MT->instance;

subtest '_upgrade recursion' => sub {
    require Test::MockModule;
    my $mock = Test::MockModule->new('MT::Template::Node');
    my ($max, $total, $recurse);

    $mock->redefine(
        '_upgrade',
        sub {
            $total++;
            $recurse++;
            $max = $recurse if $max < $recurse;
            $mock->original('_upgrade')->(@_);
            $recurse--;
        });

    subtest '50 mt:if recursion' => sub {
        ($max, $total, $recurse) = (0, 0, 0);
        my $block_reursion = 50;
        my $tmpl_str       = '';
        $tmpl_str .= '<mt:If name="bar">' x $block_reursion;
        $tmpl_str .= '</mt:If>' x $block_reursion;
        my $tmpl = MT::Template->new_string(\$tmpl_str);
        my $ret  = $tmpl->build;
        ok 1;
        note 'total _upgrade call:' . $total;
        note 'max recursion depth:' . $max;
    };

    subtest '50 mt:setvarblock recursion' => sub {
        ($max, $total, $recurse) = (0, 0, 0);
        my $block_reursion = 50;
        my $tmpl_str       = '';
        $tmpl_str .= '<mt:SetVarBlock name="foo">' x $block_reursion;
        $tmpl_str .= '</mt:SetVarBlock>' x $block_reursion;
        my $tmpl = MT::Template->new_string(\$tmpl_str);
        my $ret  = $tmpl->build;
        ok 1;
        note 'total _upgrade call:' . $total;
        note 'max recursion depth:' . $max;
    };

    subtest '50 mt:if with mt:BlockEditorBlocks recursion' => sub {
        ($max, $total, $recurse) = (0, 0, 0);
        my $block_reursion = 50;
        my $tmpl_str       = '';
        $tmpl_str .= '<mt:If name="bar"><mt:BlockEditorBlocks>' x $block_reursion;
        $tmpl_str .= '<mt:BlockEditorBlocks></mt:If>' x $block_reursion;
        my $tmpl = MT::Template->new_string(\$tmpl_str);
        my $ret  = $tmpl->build;
        ok 1;
        note 'total _upgrade call:' . $total;
        note 'max recursion depth:' . $max;
    };
};

done_testing();
