# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Util::YAML::Syck;
use strict;
use warnings;
use MT;
use base qw( MT::Util::YAML );

BEGIN {
    eval "require YAML::Syck";
    die $@ if $@;
}

sub Dump {
    require YAML::Syck;
    local $YAML::Syck::ImplicitUnicode = 1;
    YAML::Syck::Dump(shift);
}

sub Load {
    my ($str) = @_;
    require YAML::Syck;
    local $YAML::Syck::ImplicitUnicode = 1;
    my $has_string_sub = $str =~ /\bsub\s*\{/s ? 1 : 0;
    my ($y) = YAML::Syck::Load($str);
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
    return MT::Util::YAML::Syck::Load($yaml);
}

1;
