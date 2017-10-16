#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib qw(t/lib lib extlib);
use Test::More;
use MT::Test qw( :app :db :data );
use MT::Test::Permission;

my $admin = MT::Author->load(1);

my $website = MT->model('website')->load(1);
$website->set_values( { name => 'First Website', } );
$website->save or die $website->errstr;

my $blog = MT::Test::Permission->make_blog(
    name      => 'First Blog',
    parent_id => $website->id,
);

my $ft = MT->model('formatted_text')->new;
$ft->set_values(
    {   blog_id     => $blog->id,
        label       => 'Blog Boilterplate',
        description => 'Description',
    }
);
$ft->save or die $ft->errstr;

my ( $app, $out );
subtest 'In system scope' => sub {
    local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
    subtest 'Blog boilerplate' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'formatted_text',
                blog_id          => 0,
                columns          => 'blog_name',
                fid              => '_allpass',
            },
        );
        $out = delete $app->{__test_output};
        my $blog_name = 'First Website/First Blog';
        like( $out, qr/$blog_name/,
            'blog_name is "First Website/First Blog"' );
    };

    subtest 'Website boilerplate' => sub {
        $ft->set_values(
            {   blog_id => $website->id,
                label   => 'Website Boilerplate',
            }
        );
        $ft->save or die $ft->errstr;
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'formatted_text',
                blog_id          => 0,
                columns          => 'blog_name',
                fid              => '_allpass',
            },
        );
        $out = delete $app->{__test_output};
        my $blog_name = 'First Website/First Blog';
        unlike( $out, qr/$blog_name/,
            'blog_name is not "First Website/First Blog"' );
        $blog_name = 'First Website';
        like( $out, qr/$blog_name/, 'blog_name is "First Website"' );
    };

    subtest 'System boilerplate' => sub {
        $ft->set_values(
            {   blog_id => 0,
                label   => 'System',
            }
        );
        $ft->save or die $ft->errstr;
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'formatted_text',
                blog_id          => 0,
                columns          => 'blog_name',
                fid              => '_allpass',
            },
        );
        $out = delete $app->{__test_output};
        like( $out, qr/\(system\)/, 'blog_name is "(system)"' );
    };

    subtest 'Deleted site/child site boilerplate' => sub {
        $ft->set_values(
            {   blog_id => 10,
                label   => 'Site/Child Site deleted',
            }
        );
        $ft->save or die $ft->errstr;
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'formatted_text',
                blog_id          => 0,
                columns          => 'blog_name',
                fid              => '_allpass',
            },
        );
        $out = delete $app->{__test_output};
        like(
            $out,
            qr/\*Site\/Child Site deleted\*/,
            'blog_name is "*Site/Child Site deleted*"'
        );
    };
};

done_testing;
