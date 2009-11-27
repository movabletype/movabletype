# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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
    my ($y) = YAML::Tiny::Load($yaml);
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
        return MT->error(
            MT->translate('File not found: [_1]', $file)
        );
    }
    my $yaml = $fmgr->get_data($file, 'output');
    return MT::Util::YAML::Tiny::Load($yaml);
}

1;
