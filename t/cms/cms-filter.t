#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use JSON;

BEGIN {
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';

    eval 'use Test::Data qw( Array ); 1'
        or plan skip_all => 'Test::Data is not installed';

    eval 'use pQuery; 1'
        or plan skip_all => 'pQuery is not installed';
}

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;
$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        # Website
        my $website
            = MT::Test::Permission->make_website( name => 'my website', );

        # Blog
        my $blog = MT::Test::Permission->make_blog(
            parent_id => $website->id,
            name      => 'my blog',
        );

        my $ct = MT::Test::Permission->make_content_type(
            blog_id => $website->id,
            name    => 'test content type',
        );

        my $cf = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'single text',
            type            => 'single_line_text',
        );
        my $fields = [
            {   id        => $cf->id,
                label     => 1,
                name      => $cf->name,
                order     => 1,
                type      => $cf->type,
                unique_id => $cf->unique_id,
            }
        ];
        $ct->fields($fields);
        $ct->save or die $ct->errstr;

        my @screens = qw/website blog entry page asset log category
            folder author member tag association
            role banlist filter permission template
            category_set content_type content_field
            content_data group group_member/;
        foreach my $key (@screens) {
            if ( $key eq 'content_data' ) {
                $key .= '.content_data_' . $ct->id;
            }

            # scope system
            MT::Test::Permission->make_filter(
                label     => "Test filter $key system",
                object_ds => $key,
                blog_id   => 0,
            );

            # scope website
            MT::Test::Permission->make_filter(
                label     => "Test filter $key website",
                object_ds => $key,
                blog_id   => $website->id,
            );

            # scope blog
            MT::Test::Permission->make_filter(
                label     => "Test filter $key blog",
                object_ds => $key,
                blog_id   => $blog->id,
            );

            # not found blog_id
            MT::Test::Permission->make_filter(
                label     => "Test filter $key not found blog",
                object_ds => $key,
                blog_id   => 999999,
            );
        }

    }
);

my $admin = MT->model('author')->load(1);
my $ct = MT->model('content_type')->load( { name => 'test content type' } );
my @filters = MT->model('filter')->load();

my ( $app, $out );

local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
$app = _run_app(
    'MT::App::CMS',
    {   __test_user      => $admin,
        __request_method => 'POST',
        __mode           => 'filtered_list',
        datasource       => 'filter',
        blog_id          => 0,
        columns          => 'label,author_name,object_ds,created_on',
        fid              => '_allpass',
        limit            => scalar @filters,
    },
);
$out = delete $app->{__test_output};

# diag $out;
ok( $out, "Request: filtered_list" );

my $result = {
    website => {
        system  => 1,
        website => 0,
        blog    => 0,
    },
};

my $link = [

    # website
    'Test filter website system',

    # blog
    'Test filter blog system',
    'Test filter blog website',

    # entry
    'Test filter entry website',
    'Test filter entry blog',

    # page
    'Test filter page website',
    'Test filter page blog',

    # asset
    'Test filter asset system',
    'Test filter asset website',
    'Test filter asset blog',

    # log
    'Test filter log system',
    'Test filter log website',
    'Test filter log blog',

    # category
    'Test filter category website',
    'Test filter category blog',

    # folder
    'Test filter folder website',
    'Test filter folder blog',

    # author
    'Test filter author system',

    # member
    'Test filter member website',
    'Test filter member blog',

    # tag
    'Test filter tag website',
    'Test filter tag blog',

    # association
    'Test filter association system',

    # role
    'Test filter role system',

    # banlist
    'Test filter banlist system',
    'Test filter banlist website',
    'Test filter banlist blog',

    # notification
    'Test filter notification system',
    'Test filter notification website',
    'Test filter notification blog',

    # filter
    'Test filter filter system',

    # permission
    'Test filter permission system',
    'Test filter permission website',
    'Test filter permission blog',

    # template
    'Test filter template system',
    'Test filter template website',
    'Test filter template blog',

    # category_set
    'Test filter category_set website',
    'Test filter category_set blog',

    # content_type
    'Test filter content_type website',
    'Test filter content_type blog',

    # content_field
    'Test filter content_field website',
    'Test filter content_field blog',

    # content_data
    'Test filter content_data.content_data_' . $ct->id . ' website',
    'Test filter content_data.content_data_' . $ct->id . ' blog',

    # group
    'Test filter group system',

    # group_member
    'Test filter group_member system',
];

foreach my $filter (@filters) {
    my $filter_name = $filter->label;
    my $ds          = $filter->object_ds;
    ( my $scope = $filter_name ) =~ s/Test\sfilter\s${ds}\s(\w*)$/$1/;
    if ( grep { $_ eq $filter_name } @$link ) {
        like( $out, qr/"<a.*?>$filter_name<\/a>"/,
            "filter link $ds in $scope scope" );
    }
    else {
        like( $out, qr/"$filter_name"/, "filter unlink $ds in $scope scope" );
    }
}

done_testing();
