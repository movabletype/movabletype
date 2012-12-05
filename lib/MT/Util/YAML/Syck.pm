# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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
    my ($y) = YAML::Syck::Load($str);
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
    return MT::Util::YAML::Syck::Load($yaml);
}

1;
