#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT;
use MT::Test;
use Test::More;
use IO::File;
use File::Spec;
use YAML::Tiny;
my $mt = MT->new;

my @tag_tests = qw( 35-tags.t );
my $io = IO::File->new;
my @test_templates;
for my $test ( @tag_tests ) {
    my $path = File::Spec->catfile( 't', $test );
    $io->open( $path, 'r' );
    my $content = do { local $/; <$io> };
    $io->close;
    die "Can't find __DATA__ section in $test"
        unless $content =~ s/.*__DATA__//s;
    my $suite = YAML::Tiny::Load($content);
    push( @test_templates, grep {$_} map { $_->{template} || $_->{t} } @$suite );
}

my %has_test;
for my $tmpl ( @test_templates ) {
    while ( $tmpl =~ m!<\$?MT:?([\w:]+)!gis ) {
        $has_test{lc $1}++;
    }
}

my @existing_tags = (
    map { lc $_ } keys %{ MT->component('core')->registry( tags => 'block' ) },
    map { lc $_ } keys %{ MT->component('core')->registry( tags => 'function' ) },
);

plan tests => scalar @existing_tags;
for my $tag ( sort @existing_tags ) {
    $tag =~ s/\?$//;
    ok( $has_test{$tag}, "$tag has one or more tests" );
}
