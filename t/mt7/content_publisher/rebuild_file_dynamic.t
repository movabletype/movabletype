#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use utf8;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete      => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use IPC::Run3 'run3';

use MT::Test::ArchiveType;
use MT::Test::Fixture::ArchiveType;

use MT;
use MT::Template::Context;
my $app = MT->instance;

$test_env->prepare_fixture('archive_type');
my $objs = MT::Test::Fixture::ArchiveType->load_objs;
my $blog_id = $objs->{blog_id} or die;

MT::Request->instance->reset;
MT::ObjectDriver::Driver::Cache::RAM->clear_cache;

my @ct_maps = grep { $_->archive_type =~ /^ContentType/ }
    MT::Test::ArchiveType->template_maps;
for my $map ( sort { $a->archive_type cmp $b->archive_type } @ct_maps ) {

    $map->build_type(3);
    $map->save or die;

    $app->publisher->rebuild(
        ArchiveType => $map->archive_type,
        BlogID      => $blog_id,
        TemplateMap => $map,
    ) or die;

    my $fileinfo
        = $app->model('fileinfo')->load( { templatemap_id => $map->id } );
    if ( !$fileinfo ) {
        # FIXME: https://movabletype.atlassian.net/browse/MTC-26200
        warn 'skip: ' . $map->archive_type;
        next;
    }
    my $request_uri = $fileinfo->url;

    my $tmpl = $app->model('template')->load( $map->template_id ) or die;
    $tmpl->text(
        'content stash <MTIf tag="contentid">exists<MTElse>does not exist</MTIf>'
    );
    $tmpl->save or die;

    my $test_script = <<PHP;
<?php

\$MT_HOME   = '@{[ $ENV{MT_HOME} ? $ENV{MT_HOME} : '.' ]}';
\$MT_CONFIG = '@{[ MT->instance->find_config ]}';
\$blog_id   = '$blog_id';

\$_SERVER['REQUEST_URI'] = '$request_uri';
PHP

    $test_script .= <<'PHP';
include_once($MT_HOME . '/php/mt.php');
include_once($MT_HOME . '/php/lib/MTUtil.php');

$mt = MT::get_instance($blog_id, $MT_CONFIG);
$mt->view();

set_error_handler(function($error_no, $error_msg, $error_file, $error_line, $error_vars) {
    print($error_msg."\n");
}, E_USER_ERROR );

$ctx = $mt->context();
if ($ctx->_compile_source('evaluated template', $tmpl, $_var_compiled)) {
    $ctx->_eval('?>' . $_var_compiled);
} else {
    print('Error compiling template module.');
}
PHP

    run3 [ 'php', '-q' ], \$test_script, \my $result, undef,
        { binmode_stdin => 1 }
        or die $?;
    $result =~ s/^(\r\n|\r|\n|\s)+|(\r\n|\r|\n|\s)+\z//g;

    my $test_name;
    if ( $tmpl->content_type_id ) {
        my $ct_name = $tmpl->content_type->name;
        $test_name = $map->archive_type . " ($ct_name)";
    }
    else {
        $test_name = $map->archive_type;
    }

    my $expected
        = $map->archive_type eq 'ContentType'
        ? 'content stash exists'
        : 'content stash does not exist';
    is( $result, $expected, $test_name );
}

done_testing;

