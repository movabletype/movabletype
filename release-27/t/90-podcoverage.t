#!/usr/bin/perl
# $Id$

use strict;
use warnings;
use IO::File;
use Pod::Coverage;
use Test::More;
use lib "lib", "../lib";

my @modules = @ARGV ? @ARGV : ();
my @packages = ();
for (@modules) {
    next unless /\.pm$/;
    # Turn lib/MT/module.pm into MT::Module.
    s/^lib\///;
    s/\//::/g;
    s/\.pm$//;
    push @packages, $_;
}
@modules = @packages if @packages;
unless (@modules) {
    # Load the of MT modules to test.
    # FIXME: t/00-compile.t and this routine should load this list from a
    # MANIFEST file instead.
    local $/;
    my $fh = IO::File->new( 't/00-compile.t' );
    my $files = <$fh>;
    $fh->close();
    # Clean up the list, pulling out just the module names themselves
    @modules = split /\n/, $files;
    @modules = grep /^\s*use_ok /, @modules;
    s/^\s*use_ok\s*// for @modules;
    s/['";]//g for @modules; # '
}
die 'No modules to test.' unless @modules;

# Define our test plan now that we have a module list
plan tests => scalar @modules;

# Determine POD coverage for each module
my $covered = 0;
my $uncovered = 0;
foreach my $module (@modules) {
    my $trustme = [];
    my $pod_from = '';
    if ($module eq 'MT::App::CMS') {
        push @$trustme, qr/^CMS/;
    }
    elsif ($module eq 'MT::Callback') {
        $pod_from = 'lib/MT/Callback.pm';
    }
    my $pc = Pod::Coverage->new(
        package => $module,
        trustme => $trustme,
        pod_from => $pod_from,
    );
    my $coverage = $pc->coverage;
    my $c = $coverage || 0; 
    $c = sprintf '%0.2f', $c * 100;
    if (defined $coverage) {
        my @naked = $pc->uncovered;
        my $naked_count = scalar @naked;
        my $cover_count = (scalar $pc->covered) || 0;
        $covered += $cover_count;
        $uncovered += $naked_count;
        is($coverage, 1, $module . ": " . $cover_count . "/" . ($cover_count+$naked_count))
            or diag("pod coverage is $c%. missing pod for: " . join(", ", sort @naked));
    } else {
        SKIP: { skip("$module: " . $pc->why_unrated, 1); }
    }
}

# Show some coverage stats like pod_cover does
my $total = $covered + $uncovered;
my $average = 'unknown';
$average = sprintf '%0.2f', 100 * $covered / $total if $total > 0;

diag("total routines: $total");
diag("covered       : $covered");
diag("uncovered     : $uncovered");
diag("total coverage: $average%");
