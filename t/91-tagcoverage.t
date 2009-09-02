#!/usr/bin/perl

use strict;
use lib 't/extlib', 't/lib', 'extlib', 'lib';
use Test::More;
use MT::Test;
use File::Spec;
use Data::Dumper;

my $components = {
    'core' => {
        paths => [
            'MT/Template/ContextHandlers.pm',
            'MT/Template/Context/Search.pm',
        ],
    },
    'commercial' => {
        paths => [
            'CustomFields/Template/ContextHandlers.pm',
        ],
    },
    'community' => {
        paths => [
            'MT/Community/Tags.pm',
        ],
    },
    'multiblog' => {
        paths => [
            'MultiBlog/Tags.pm',
        ],
    },
    'FeedsAppLite' => {
        paths => [
            'MT/Feeds/Tags.pm',
        ],
    },
};

my $mt = MT->instance;

my $tag_count = 0;
foreach my $c (keys %$components) {
    next unless $mt->component($c);
    my $tags = $mt->component($c)->registry('tags');
    my $fn_count = scalar keys(%{ $tags->{function} });
    $fn_count-- if $fn_count;
    my $mod_count = scalar keys(%{ $tags->{modifier} });
    $mod_count-- if $mod_count;
    my $block_count = scalar keys(%{ $tags->{block} });
    $block_count-- if $block_count;
    my $count = $fn_count + $mod_count + $block_count;
    $tag_count += $count;
}

plan tests => $tag_count;

foreach my $c (keys %$components) {
    next unless $mt->component($c);
    diag("Checking for tag documentation for component $c");
    my $all_docs = '';
    my $tags = $mt->component($c)->registry('tags');
    my $core_tags = $mt->component('core')->registry('tags')
        unless $c eq 'core';

    my $paths = $components->{$c}{paths};
    {
        local $/ = undef;
        FILE: foreach my $file ( @$paths ) {
            # core tag docs are embedded as POD
            foreach my $inc ( @INC ) {
                my $file_path = File::Spec->catfile($inc, $file);
                next unless -e $file_path;

                diag("Reading module $file_path");
                open DOC, "< $file_path"
                    or die "Can't read file $file_path: " . $!;
                $all_docs .= <DOC>;
                close DOC;
                next FILE;
            }
            die "Could not locate $file!";
        }
    }

    # Determine if the core tags have adequate documentation or not.
    my $doc_names = {};
    while ($all_docs =~ m/\n=head2[ ]+([\w:]+)[ ]*\n(.*?)?\n=cut[ ]*\n/gs) {
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
        $doc_names->{$tag} = 1;
    }

    foreach my $tag ( keys %{ $tags->{function} } ) {
        next if $tag eq 'plugin';
        if ($core_tags && $core_tags->{function}{$tag}) {
            ok(1, "component $c, function tag $tag (extends core tag)");
        } else {
            ok(exists $doc_names->{$tag}, "component $c, function tag $tag");
        }
    }

    foreach my $tag ( keys %{ $tags->{block} } ) {
        next if $tag eq 'plugin';
        $tag =~ s/\?$//;
        if ($core_tags && $core_tags->{block}{$tag}) {
            ok(1, "component $c, block tag $tag (extends core tag)");
        } else {
            ok(exists $doc_names->{$tag}, "component $c, block tag $tag");
        }
    }

    foreach my $tag ( keys %{ $tags->{modifier} } ) {
        next if $tag eq 'plugin';
        if ($core_tags && $core_tags->{modifier}{$tag}) {
            ok(1, "component $c, modifier $tag (extends core tag)");
        } else {
            ok(exists $doc_names->{$tag}, "component $c, modifier $tag");
        }
    }
}

