#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../t/lib";
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

$test_env->prepare_fixture('db');


subtest 'empty list' => sub {
    my $app   = MT::Test::App->new;
    my $admin = MT::Author->load(1);
    my $blog  = MT::Blog->load(1);

    my $ct = MT::Test::Permission->make_content_type(
        blog_id => $blog->id,
        name    => 'A%%b',
    );
    my $cf = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'single text',
        type            => 'single_line_text',
    );

    $ct->fields([{
        id        => $cf->id,
        name      => $cf->name,
        options   => { label => $cf->name, },
        order     => 1,
        type      => $cf->type,
        unique_id => $cf->unique_id,
    }]);
    $ct->save or die $ct->errstr;

    my $label;
    my $plugin = MT::Plugin->new({name => "MTC-31073.t"});

    MT->add_callback('MT::App::CMS::template_output.list_common', 1, $plugin, sub {
        my ( $cb, $app, $output_ref, $params, $tmpl ) = @_;
        $$output_ref =~ qr{zeroStateLabel\s*=\s*'(.+?)';}s;
        $label = $1;
    } );


    $app->login($admin);
    $app->get_ok({
        __mode      => 'list',
        _type       => 'content_data',
        type        => 'content_data_' . $ct->id,
        blog_id     => $blog->id,
    });

    is $label, 'A%%b', 'as is';
};


done_testing;
