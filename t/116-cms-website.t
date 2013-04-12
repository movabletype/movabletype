#!/usr/bin/perl
use strict;
use warnings;

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

# Run tests
my ( $app, $out );

diag 'Test cfg_prefs mode';
subtest 'Test cfg_prefs mode' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'cfg_prefs',
            blog_id     => $website->id
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: website general settings" );

    # Modify description. bugid:109613
    like(
        $out,
        qr/Number of revisions per entry\/page/,
        'Has "Number of revisions per entry\/page" description.'
    );
    unlike(
        $out,
        qr/Number of revisions per page/,
        'Has "Number of revisions per page" description.'
    );

    like( $out, qr/Preferred Archive/, 'Has "Preferred Archive" setting.' );

    my $description
        = quotemeta(
        "Used to generate URLs (permalinks) for this website's archived entries. Choose one of the archive type used in this website's archive templates."
        );
    $description = qr/$description/;
    like( $out, qr/$description/,
        'Has a website scope description in Preferred Archive setting.' );

    done_testing();
};

diag 'Test cfg_entry mode';
subtest 'Test cfg_entry mode' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'cfg_entry',
            blog_id     => $website->id
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: website compose settings" );

    like(
        $out,
        qr/Entry Fields/,
        'Has "Entry Fields" in Compose Defaults setting.'
    );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'blog',
            id               => $website->id,
            blog_id          => $website->id,
            return_args      => '__mode=cfg_entry&_type=blog&blog_id='
                . $website->id . '&id='
                . $website->id,
            cfg_screen         => 'cfg_entry',
            entry_custom_prefs => 'title',
            entry_custom_prefs => 'text',
        },
    );
    ok( $out, "Request: save" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'cfg_entry',
            blog_id     => $website->id,
        },
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: website compose settings" );

    my @fields = qw( category excerpt keywords tags feedback assets );
    foreach my $field (@fields) {
        my $input
            = quotemeta(
            "<input type=\"checkbox\" name=\"entry_custom_prefs\" id=\"entry-prefs-$field\" value=\"$field\" class=\"cb\" />"
            );
        $input = qr/$input/;
        like( $out, $input,
            "$field setting in Entry Fields is not checked." );
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'view',
            _type       => 'entry',
            blog_id     => $website->id,
        },
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: view (entry, new)" );

    foreach my $field (@fields) {
        my $input
            = quotemeta(
            "<input type=\"checkbox\" name=\"custom_prefs\" id=\"custom-prefs-$field\" value=\"$field\" class=\"cb\" />"
            );
        $input = qr/$input/;
        like( $out, $input,
            "$field setting in custom prefs is not checked." );
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'blog',
            id               => $website->id,
            blog_id          => $website->id,
            return_args      => '__mode=cfg_entry&_type=blog&blog_id='
                . $website->id . '&id='
                . $website->id,
            cfg_screen         => 'cfg_entry',
            entry_custom_prefs => [ qw( title text ), @fields ],
        },
    );
    ok( $out, "Request: save" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'cfg_entry',
            blog_id     => $website->id,
        },
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: website compose settings" );

    foreach my $field (@fields) {
        my $input
            = quotemeta(
            "<input type=\"checkbox\" name=\"entry_custom_prefs\" id=\"entry-prefs-$field\" value=\"$field\" checked=\"checked\" class=\"cb\" />"
            );
        $input = qr/$input/;
        like( $out, $input, "$field setting in Entry Fields is checked." );
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'view',
            _type       => 'entry',
            blog_id     => $website->id,
        },
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: view (entry, new)" );

    foreach my $field (@fields) {
        my $input
            = quotemeta(
            "<input type=\"checkbox\" name=\"custom_prefs\" id=\"custom-prefs-$field\" value=\"$field\" checked=\"checked\" class=\"cb\" />"
            );
        $input = qr/$input/;
        like( $out, $input, "$field setting in custom prefs is checked." );
    }

    done_testing();
};

done_testing();

