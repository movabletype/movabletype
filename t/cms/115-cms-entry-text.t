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

use MT::Test;
use MT::Test::App;

$test_env->prepare_fixture('db_data');

my $app  = MT->instance;
my $user = $app->model('author')->load(1);
my $blog = $app->model('blog')->load(1);

my @suite = ({
        param => {
            text => 'TinyMCE is used',
        },
        like => qr{TinyMCE6/lib/js/adapter\.js},
    },
    {
        param => {
            id => 1,
        },
        like => qr/On a drizzly day last weekend/,
    },
    {
        param => {
            text => 'Set the text via param',
        },
        like => qr/Set the text via param/,
    },
    {
        param => {
            text_more => 'Set the text more via param',
        },
        like => qr/Set the text more via param/,
    },
    {
        param => {
            text => 'Set the text via param <img src="src_via_param" />',
        },
        like => qr{Set the text via param &lt;img src=&quot;src_via_param&quot; /&gt;},
    },
    {
        param => {
            text_more => 'Set the text more via param <img src="src_via_param" />',
        },
        like => qr{Set the text more via param &lt;img src=&quot;src_via_param&quot; /&gt;},
    },
);

for my $type (qw(entry page)) {
    subtest '_type:' . $type => sub {
        for my $data (@suite) {
            my $p = MT::Util::to_json({
                    param => $data->{param},
                    ($data->{config} ? (config => $data->{config}) : ())
                },
                { canonical => 1 });
            subtest $p => sub {
                local $app->config->{__var}{ lc('GlobalSanitizeSpec') } = $data->{config}{GlobalSanitizeSpec}
                    if exists $data->{config}
                    && exists $data->{config}{GlobalSanitizeSpec};

                my $app = MT::Test::App->new('MT::App::CMS');
                $app->login($user);
                $app->get_ok({
                    __mode  => 'view',
                    blog_id => $blog->id,
                    _type   => 'entry',
                    %{ $data->{param} },
                });

                if ($data->{like}) {
                    $app->content_like($data->{like}, 'contains');
                }
                if ($data->{unlike}) {
                    $app->content_unlike($data->{unlike}, 'not contains');
                }
            };
        }
    };
}

done_testing();
