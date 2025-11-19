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
    $ENV{MT_CONFIG} = $test_env->config_file;    ## no critic
}

use File::Spec;
use MT;

MT->instance;
$test_env->prepare_fixture('db_data');

my $site               = MT->model('website')->load or die MT->model('website')->errstr;
my $site_id            = $site->id;
my $common_linked_file = 'linked_file';

subtest '_sync_to_disk' => sub {
    subtest 'use BaseTemplatePath' => sub {
        my $base_template_path = $test_env->path('base');
        MT->config->BaseTemplatePath($base_template_path);
        MT->config->UserTemplatePath(undef);
        my $tmpl = MT->model('template')->new(
            blog_id     => 0,
            linked_file => $common_linked_file,
            name        => 'base_template_path',
            type        => 'index',
        );

        my $text = 'BaseTemplatePath';
        ok $tmpl->_sync_to_disk($text);

        my $linked_file_path = File::Spec->catfile($base_template_path, $common_linked_file);
        is $test_env->slurp($linked_file_path), $text;

        my ($size, $mtime) = (stat $linked_file_path)[7, 9];
        is $tmpl->linked_file_size,  $size;
        is $tmpl->linked_file_mtime, $mtime;
    };

    subtest 'use first UserTemplatePath' => sub {
        plan skip_all => 'Not for Cloud' if $test_env->addon_exists('Cloud.pack');
        my $user_template_path = $test_env->path('user');
        MT->config->BaseTemplatePath(undef);
        MT->config->UserTemplatePath($user_template_path);
        my $tmpl = MT->model('template')->new(
            blog_id     => 0,
            linked_file => $common_linked_file,
            name        => 'user_template_path',
            type        => 'index',
        );

        my $text = 'UserTemplatePath';
        ok $tmpl->_sync_to_disk($text);

        my $linked_file_path = File::Spec->catfile($user_template_path, $common_linked_file);
        is $test_env->slurp($linked_file_path), $text;

        my ($size, $mtime) = (stat $linked_file_path)[7, 9];
        is $tmpl->linked_file_size,  $size;
        is $tmpl->linked_file_mtime, $mtime;
    };

    # load from tmpl/error.tmpl　by empty $tmpl->text because modifying files within server_path could potentially affect other tests
    subtest 'use server_path' => sub {
        plan skip_all => 'Not for Cloud' if $test_env->addon_exists('Cloud.pack');
        MT->config->BaseTemplatePath(undef);
        MT->config->UserTemplatePath([]);
        my $linked_file      = File::Spec->catfile('tmpl',                    'error.tmpl');
        my $linked_file_path = File::Spec->catfile(MT->instance->server_path, $linked_file);

        my $tmpl = MT->model('template')->new(
            blog_id     => 0,
            linked_file => $linked_file,
            name        => 'server_path',
            text        => '',
            type        => 'index',
        );
        ok $tmpl->_sync_to_disk;
        is $tmpl->text, $test_env->slurp($linked_file_path);

        my ($size, $mtime) = (stat $linked_file_path)[7, 9];
        is $tmpl->linked_file_size,  $size;
        is $tmpl->linked_file_mtime, $mtime;
    };
};

subtest '_sync_from_disk' => sub {
    subtest 'use BaseTemplatePath' => sub {
        my $base_template_path = $test_env->path('base');
        MT->config->BaseTemplatePath($base_template_path);
        MT->config->UserTemplatePath(undef);

        my $text = 'BaseTemplatePath';
        $test_env->save_file(File::Spec->catfile('base', $common_linked_file), $text);

        my $tmpl = MT->model('template')->new(
            blog_id     => 0,
            linked_file => $common_linked_file,
            name        => 'base_template_path',
            type        => 'index',
        );
        is $tmpl->_sync_from_disk, $text;

        my $linked_file_path = File::Spec->catfile($base_template_path, $common_linked_file);
        my ($size, $mtime) = (stat $linked_file_path)[7, 9];
        is $tmpl->linked_file_size,  $size;
        is $tmpl->linked_file_mtime, $mtime;
    };

    subtest 'use first UserTemplatePath' => sub {
        plan skip_all => 'Not for Cloud' if $test_env->addon_exists('Cloud.pack');
        my $user_template_path = $test_env->path('user');
        MT->config->BaseTemplatePath(undef);
        MT->config->UserTemplatePath($user_template_path);

        my $text = 'UserTemplatePath';
        $test_env->save_file(File::Spec->catfile('user', $common_linked_file), $text);

        my $tmpl = MT->model('template')->new(
            blog_id     => 0,
            linked_file => $common_linked_file,
            name        => 'user_template_path',
            type        => 'index',
        );
        is $tmpl->_sync_from_disk, $text;

        my $linked_file_path = File::Spec->catfile($user_template_path, $common_linked_file);
        my ($size, $mtime) = (stat $linked_file_path)[7, 9];
        is $tmpl->linked_file_size,  $size;
        is $tmpl->linked_file_mtime, $mtime;
    };

    subtest 'use server_path' => sub {
        plan skip_all => 'Not for Cloud' if $test_env->addon_exists('Cloud.pack');
        MT->config->BaseTemplatePath(undef);
        MT->config->UserTemplatePath([]);
        my $linked_file      = File::Spec->catfile('tmpl',                    'error.tmpl');
        my $linked_file_path = File::Spec->catfile(MT->instance->server_path, $linked_file);

        my $tmpl = MT->model('template')->new(
            blog_id     => 0,
            linked_file => $linked_file,
            name        => 'server_path',
            type        => 'index',
        );
        is $tmpl->text, $test_env->slurp($linked_file_path);

        my ($size, $mtime) = (stat $linked_file_path)[7, 9];
        is $tmpl->linked_file_size,  $size;
        is $tmpl->linked_file_mtime, $mtime;
    };
};

done_testing;
