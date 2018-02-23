#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib";    # t/lib
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

#ok( $mt->component('MultiBlog'), 'Load plugin' );

my %registries = (
    'function tag' => {
        registry => [ 'tags', 'function' ],
        like_any => { 'Include' => qr/CODE/, },
    },
    'application methods' => {
        registry => [ 'applications', 'cms', 'methods' ],
        names    => [ 'add_rebuild_trigger', 'cfg_rebuild_trigger', 'save_rebuild_trigger' ],
    },
    'help_url' => {
        registry => ['tags'],
        names    => ['help_url'],
    },
    'block tag' => {
        registry => [ 'tags', 'block' ],
        like_any => {
            MultiBlog =>
                qr/\$Core::MT::Template::Tags::Website::_hdlr_websites/,
            OtherBlog =>
                qr/\$Core::MT::Template::Tags::Website::_hdlr_websites/,
            MultiBlogLocalBlog =>
                qr/\$Core::MT::Template::Tags::Site::_hdlr_sites_local_site/,
            'MultiBlogIfLocalBlog?' =>
                qr/\$Core::MT::Template::Tags::Site::_hdlr_sites_if_local_site/,
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
        if ( ref($value) ne 'ARRAY' && ref($value) ne 'CODE' ) {
            $value = [$value];
        }
        elsif ( ref($value) eq 'CODE' ) {
            $value = ['CODE'];
        }
        ok( grep( $_ =~ $regexp, @$value ), "$k '$name'" );
    }
}

done_testing;
