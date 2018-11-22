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
use MT;
use MT::Test::Permission;

$test_env->prepare_fixture('db');

my $mt = MT->instance;

my @archive_types = sort $mt->publisher->archive_types;

my $website = MT->model('website')->load or die;
my $blog = MT::Test::Permission->make_blog( parent_id => $website->id );

my $ct1 = MT::Test::Permission->make_content_type(
    blog_id => $blog->id,
    name    => 'ct1',
);
my $ct2 = MT::Test::Permission->make_content_type(
    blog_id => $blog->id,
    name    => 'ct2',
);
my $tmpl_ct1 = MT::Test::Permission->make_template(
    blog_id         => $blog->id,
    content_type_id => $ct1->id,
);
my $tmpl_ct1_listing = MT::Test::Permission->make_template(
    blog_id         => $blog->id,
    content_type_id => $ct1->id,
);
MT::Test::Permission->make_templatemap(
    archive_type => 'ContentType',
    blog_id      => $blog->id,
    template_id  => $tmpl_ct1->id,
);
MT::Test::Permission->make_templatemap(
    archive_type => 'ContentType-Daily',
    blog_id      => $blog->id,
    template_id  => $tmpl_ct1_listing->id,
);

my $cache_key = 'has_archive_type::blog:' . $blog->id;

subtest 'some archive type with content_type_id' => sub {
    $mt->request->reset;

    my %blog_archive_type = map { $_ => 1 } split ',', $blog->archive_type;

    for my $type (@archive_types) {
        if ( $blog_archive_type{$type} ) {
            ok( $blog->has_archive_type( $type, $ct1->id ), "$type exists" );
        }
        else {
            ok( !$blog->has_archive_type( $type, $ct2->id ),
                "$type does not exist" );
        }
    }

    is_deeply(
        $mt->request->cache($cache_key),
        +{ map { $_ => { 0 => 1 } } keys %blog_archive_type },
        'check cache'
    );
};

subtest 'no archive type' => sub {
    $mt->request->reset;

    $blog->archive_type('');

    for my $type (@archive_types) {
        ok( !$blog->has_archive_type($type), "$type does not exist" );
    }

    is( $mt->request->cache($cache_key), undef, 'check cache' );
};

subtest 'content_type related archive type' => sub {
    $mt->request->reset;

    $blog->archive_type('ContentType,ContentType-Daily');

    for my $type (@archive_types) {
        if ( $type eq 'ContentType' || $type eq 'ContentType-Daily' ) {
            ok( $blog->has_archive_type($type), "$type exists (no ct_id)" );
            ok( $blog->has_archive_type( $type, $ct1->id ),
                "$type exists (\$ct1->id)" );
            ok( !$blog->has_archive_type( $type, $ct2->id ),
                "$type does not exist (\$ct2->id)"
            );
        }
        else {
            ok( !$blog->has_archive_type($type), "$type does not exist" );
        }
    }

    is_deeply(
        $mt->request->cache($cache_key),
        {   ContentType => {
                0        => 1,
                $ct1->id => 1,
                $ct2->id => 0,
            },
            'ContentType-Daily' => {
                0        => 1,
                $ct1->id => 1,
                $ct2->id => 0,
            },
        },
        'check cache'
    );
};

done_testing;

