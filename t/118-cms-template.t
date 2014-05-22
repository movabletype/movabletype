#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib 't/lib', 'lib', 'extlib', '../lib', '../extlib';
use MT::Test qw( :app :db );
use MT::Test::Permission;
use MT::Association;
use Test::More;

### Make test data

# Website
my $website = MT->model('website')->load();

# Author
my $admin = MT->model('author')->load(1);

# Run tests
subtest 'Manage Website Templates' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'list_template',
            blog_id     => $website->id,
        },
    );
    my $out = delete $app->{__test_output};

    my $entry_archive
        = quotemeta( '<li><a href="'
            . $app->mt_uri
            . '?__mode=view&amp;_type=template&amp;type=individual&amp;blog_id='
            . $website->id
            . '" class="icon-left icon-create">Entry</a></li>' );
    like( $out, qr/$entry_archive/,
        '"Entry" archive template creating link exists in "Manage Website Templates" view'
    );

    my $entry_listing
        = quotemeta( '<li><a href="'
            . $app->mt_uri
            . '?__mode=view&amp;_type=template&amp;type=archive&amp;blog_id='
            . $website->id
            . '" class="icon-left icon-create">Entry Listing</a></li>' );
    like( $out, qr/$entry_listing/,
        '"Entry Listing" archive template creating link exists in "Manage Website Templates" view'
    );

    my $preferred_archive = quotemeta
        '<p><span class="alert-warning-inline">No archives are active</p>';
    unlike( $out, qr/$preferred_archive/,
        '"No archives are active" message is not displayed' );
};

subtest 'Edit archive template in website' => sub {
    my @options = (
        '<option value="Daily">Daily</option>',
        '<option value="Weekly">Weekly</option>',
        '<option value="Monthly">Monthly</option>',
        '<option value="Yearly">Yearly</option>',
        '<option value="Author">Author</option>',
        '<option value="Author-Daily">Author Daily</option>',
        '<option value="Author-Weekly">Author Weekly</option>',
        '<option value="Author-Monthly">Author Monthly</option>',
        '<option value="Author-Yearly">Author Yearly</option>',
        '<option value="Category">Category</option>',
        '<option value="Category-Daily">Category Daily</option>',
        '<option value="Category-Weekly">Category Weekly</option>',
        '<option value="Category-Monthly">Category Monthly</option>',
        '<option value="Category-Yearly">Category Yearly</option>',
    );

    my $tmpl = MT::Test::Permission->make_template(
        blog_id => $website->id,
        type    => 'archive',
    );

    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'view',
            _type       => 'template',
            blog_id     => $website->id,
            id          => $tmpl->id,
        },
    );
    my $out = delete $app->{__test_output};

    foreach my $opt (@options) {
        my $opt_quotemeta = quotemeta $opt;
        like( $out, qr/$opt_quotemeta/,
            'Archive template in website has "' . $opt . '"' );
    }
};

done_testing;
