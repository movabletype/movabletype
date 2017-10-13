#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
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

use lib 't/lib', 'lib', 'extlib', '../lib', '../extlib';
use MT::Test qw( :app :db );
use MT::Test::Permission;
use Test::More;

### Make test data

# Website
my $website = MT::Test::Permission->make_website();

# Author
my $admin = MT->model('author')->load(1);

# Entry
my $website_entry = MT::Test::Permission->make_entry(
    blog_id   => $website->id,
    author_id => $admin->id,
);
$website_entry->tags('@entry');
$website_entry->save;

# Page
my $website_page = MT::Test::Permission->make_page(
    blog_id   => $website->id,
    author_id => $admin->id,
);
$website_page->tags('@page');
$website_page->save;

# Asset
my $website_asset = MT::Test::Permission->make_asset(
    class   => 'image',
    blog_id => $website->id,
    url     => 'http://narnia.na/nana/images/test.jpg',
    file_path =>
        File::Spec->catfile( $ENV{MT_HOME}, "t", 'images', 'test.jpg' ),
    file_name    => 'test.jpg',
    file_ext     => 'jpg',
    image_width  => 640,
    image_height => 480,
    mime_type    => 'image/jpeg',
    label        => 'Userpic A',
    description  => 'Userpic A',
);
$website_asset->tags('@asset');
$website_asset->save;

# Run tests
my ( $app, $out );

note 'Test in website scope';
subtest 'Test in website scope' => sub {

    note 'Build in filter check';
    subtest 'Built in filter check' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $admin,
                __mode      => 'list',
                _type       => 'tag',
                blog_id     => $website->id,
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: list" );

        like(
            $out,
            qr/Tags with Entries/,
            'System filter "Tags with Entries" exists'
        );

        local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'tag',
                blog_id          => $website->id,
                columns          => 'name',
                fid              => '_allpass',
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: filtered_list" );

        my @tags = qw( @entry @page @asset );
        foreach my $t (@tags) {
            like( $out, qr/$t/, "Got \"$t\" in website" );
        }

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'tag',
                blog_id          => $website->id,
                columns          => 'name',
                fid              => 'entry',
                items =>
                    "[{\"type\":\"for_entry\",\"args\":{\"value\":\"\",\"label\":\"\"}}]",
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: filtered_list" );

        like( $out, qr/\@entry/, "Got \"\@entry\" in website" );
        unlike( $out, qr/\@page/,  "Did not get \"\@page\" in website" );
        unlike( $out, qr/\@asset/, "Did not get \"\@asset\" in website" );

        done_testing();
    };

    note 'Display options check';
    subtest 'Display options check' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $admin,
                __mode      => 'list',
                _type       => 'tag',
                blog_id     => $website->id,
            },
        );
        $out = delete $app->{__test_output};
        ok( $out, "Request: list" );

        my $checkbox = quotemeta(
            '<label for="custom-prefs-entry_count">Entries</label>');
        $checkbox = qr/$checkbox/;
SKIP: {
        skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
        like( $out, $checkbox, 'Has "Entries" setting in Display Options' );
}

        done_testing();
    };

    done_testing();
};

done_testing();
