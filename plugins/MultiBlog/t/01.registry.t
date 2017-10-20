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

use MT::Test ();
use MT;
use MT::App::CMS;

my $mt = MT::App::CMS->instance;

ok( $mt->component('MultiBlog'), 'Load plugin' );

my %registries = (
    'function tag' => {
        registry => [ 'tags', 'function' ],
        like_any => {
            'Include'           => qr/MultiBlog::preprocess_native_tags/,
            'BlogCategoryCount' => qr/MultiBlog::preprocess_native_tags/,
            'BlogEntryCount'    => qr/MultiBlog::preprocess_native_tags/,
            'BlogPingCount'     => qr/MultiBlog::preprocess_native_tags/,
            'TagSearchLink'     => qr/MultiBlog::preprocess_native_tags/,
        },
    },
    'application methods' => {
        registry => [ 'applications', 'cms', 'methods' ],
        names    => ['multiblog_add_trigger'],
    },
    'help_url' => {
        registry => ['tags'],
        names    => ['help_url'],
    },
    'block tag' => {
        registry => [ 'tags', 'block' ],
        like_any => {
            Entries            => qr/MultiBlog::preprocess_native_tags/,
            Categories         => qr/MultiBlog::preprocess_native_tags/,
            Comments           => qr/MultiBlog::preprocess_native_tags/,
            Pages              => qr/MultiBlog::preprocess_native_tags/,
            Folders            => qr/MultiBlog::preprocess_native_tags/,
            Blogs              => qr/MultiBlog::preprocess_native_tags/,
            Assets             => qr/MultiBlog::preprocess_native_tags/,
            Pings              => qr/MultiBlog::preprocess_native_tags/,
            Authors            => qr/MultiBlog::preprocess_native_tags/,
            Tags               => qr/MultiBlog::preprocess_native_tags/,
            MultiBlog          => qr/MultiBlog::Tags::MultiBlog/,
            OtherBlog          => qr/MultiBlog::Tags::MultiBlog/,
            MultiBlogLocalBlog => qr/MultiBlog::Tags::MultiBlogLocalBlog/,
            'MultiBlogIfLocalBlog?' =>
                qr/MultiBlog::Tags::MultiBlogIfLocalBlog/,
        }
    },
);

for my $k ( keys(%registries) ) {
    my $registry = $mt->registry( @{ $registries{$k}{registry} } );
    for my $name ( @{ $registries{$k}{names} || [] } ) {
        ok( $registry->{$name}, "$k '$name'" );
    }
    for my $name ( keys %{ $registries{$k}{like_any} || {} } ) {
        my $value = $registry->{$name} || undef;
        my $regexp = $registries{$k}{like_any}{$name};
        if ( ref($value) ne 'ARRAY' ) {
            $value = [$value];
        }
        ok( grep( $_ =~ $regexp, @$value ), "$k '$name'" );
    }
}

done_testing;
