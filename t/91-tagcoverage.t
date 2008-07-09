#!/usr/bin/perl

use strict;
use lib 't/extlib', 't/lib', 'extlib', 'lib';
use Test::More;
use MT::Test;
use Data::Dumper;

my @core_docs = qw(
    lib/MT/Template/ContextHandlers.pm
    lib/MT/Template/Context/Search.pm
);

my $mt = MT->instance;
my $tags = $mt->component('core')->registry('tags');

my $tag_count = (scalar keys(%{ $tags->{function} })
    + scalar keys(%{ $tags->{modifier} })
    + scalar keys(%{ $tags->{block} }))
    - 3; # the registry gives us an extra 'plugin' key for each element
plan tests => $tag_count;

my $core_docs = '';
{
    local $/ = undef;
    foreach my $file ( @core_docs ) {
        # core tag docs are embedded as POD
        open DOC, "< $file";
        $core_docs .= <DOC>;
        close DOC;
    }
}

# Determine if the core tags have adequate documentation or not.
my $doc_names = {};
while ($core_docs =~ m/\n=head2[ ]+([\w:]+)[ ]*\n(.*?)?\n=cut[ ]*\n/gs) {
    my $tag = $1;
    my $docs = defined $2 ? $2 : '';
    $docs =~ s/\r//g; # for windows newlines
    # ignore comment lines
    $docs =~ s/^#.*//gm;
    # ignore empty lines
    $docs =~ s/^\s*$//gm;
    # strip any '=for ...', etc. directive. docs should be above this
    $docs =~ s/(^|\n)=\w+.*//s;
    # strip trailing/leading newlines
    $docs =~ s/^\n+//s;
    $docs =~ s/\n+$//s;
    # if documentation block doesn't have anything left, the tag is undocumented
    next if $docs eq '';
    $doc_names->{lc $tag} = 1;
}

foreach my $tag ( keys %{ $tags->{function} } ) {
    next if $tag eq 'plugin';
    ok(exists $doc_names->{lc $tag}, "function tag $tag");
}

foreach my $tag ( keys %{ $tags->{block} } ) {
    next if $tag eq 'plugin';
    $tag =~ s/\?$//;
    ok(exists $doc_names->{lc $tag}, "block tag $tag");
}

foreach my $tag ( keys %{ $tags->{modifier} } ) {
    next if $tag eq 'plugin';
    ok(exists $doc_names->{lc $tag}, "modifier $tag");
}

