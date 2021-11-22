# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Util::YAML::Tiny;
use strict;
use warnings;
use MT;
use base qw( MT::Util::YAML );

BEGIN {
    eval "require YAML::Tiny";
    die $@ if $@;
}

sub Dump {
    my ($data) = @_;
    return YAML::Tiny::Dump($data);
}

sub Load {
    my ($yaml) = @_;
    my ($y)    = YAML::Tiny::Load($yaml);
    my $has_string_sub = $yaml =~ /\bsub\s*\{/s;
    if ( ref($y) eq 'ARRAY' ) {

        # skip over non-hash elements
        shift @$y while @$y && ( ref( $y->[0] ) ne 'HASH' );
        if (@$y) {
            return $has_string_sub ? MT::Util::YAML::_codify_string_sub($y->[0]) : $y->[0];
        }
    }
    elsif ( ref($y) eq 'HASH' ) {
        return $has_string_sub ? MT::Util::YAML::_codify_string_sub($y) : $y;
    }
    return {};
}

sub LoadFile {
    my ($file) = @_;
    require MT::FileMgr;
    my $fmgr = MT::FileMgr->new('Local');
    if ( !$fmgr->exists($file) ) {
        return MT->error( MT->translate( 'File not found: [_1]', $file ) );
    }
    my $yaml = $fmgr->get_data( $file, 'output' );
    return MT::Util::YAML::Tiny::Load($yaml);
}

1;
