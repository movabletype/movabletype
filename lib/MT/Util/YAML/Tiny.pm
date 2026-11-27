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
use Data::Visitor::Tiny;

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
    if ( ref($y) eq 'ARRAY' ) {

        # skip over non-hash elements
        shift @$y while @$y && ( ref( $y->[0] ) ne 'HASH' );
        return _fix($y->[0]) if @$y;
    }
    elsif ( ref($y) eq 'HASH' ) {
        return _fix($y);
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

sub _fix {
    my $hashref = shift;
    Data::Visitor::Tiny::visit(
        $hashref,
        sub {
            my ($key, $valueref) = @_;
            if (ref $$valueref eq 'HASH') {
                for my $subkey (keys %{$$valueref}) {
                    next unless substr($subkey, 0, 2) eq ' :';
                    my $newkey = substr($subkey, 1);
                    $$valueref->{$newkey} = delete $$valueref->{$subkey};
                }
            }
        });
    return $hashref;
}

1;
