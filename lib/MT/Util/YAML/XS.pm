# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Util::YAML::XS;
use strict;
use warnings;
use MT;
use base qw( MT::Util::YAML );
use MT::Util::Encode;

BEGIN {
    eval "require YAML::XS";
    die $@ if $@;
}

sub Dump {
    my ($data) = @_;
    return MT::Util::Encode::decode_utf8_unless_flagged(YAML::XS::Dump($data));
}

sub Load {
    my ($yaml) = @_;
    my ($y)    = YAML::XS::Load(MT::Util::Encode::encode_utf8_if_flagged($yaml));
    if ( ref($y) eq 'ARRAY' ) {

        # skip over non-hash elements
        shift @$y while @$y && ( ref( $y->[0] ) ne 'HASH' );
        return $y->[0] if @$y;
    }
    elsif ( ref($y) eq 'HASH' ) {
        return $y;
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
    return MT::Util::YAML::XS::Load($yaml);
}

1;
