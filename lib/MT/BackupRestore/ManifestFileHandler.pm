# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::BackupRestore::ManifestFileHandler;

use strict;
use warnings;
use XML::SAX::Base;

@MT::BackupRestore::ManifestFileHandler::ISA = qw(XML::SAX::Base);

sub new {
    my $class   = shift;
    my (%param) = @_;
    my $self    = bless \%param, $class;
    return $self;
}

sub start_document {
    my $self = shift;
    my $data = shift;

    $self->{start} = 1;

    my $backups = {
        files  => [],
        assets => [],
    };

    $self->{backups} = $backups;

    1;
}

sub start_element {
    my $self = shift;
    my $data = shift;

    my $name  = $data->{LocalName};
    my %attrs = map {
        $data->{Attributes}->{$_}->{LocalName} =>
            $data->{Attributes}->{$_}->{Value}
    } keys( %{ $data->{Attributes} } );
    my $ns = $data->{NamespaceURI};

    if ( $self->{start} ) {
        die MT->translate(
            "The uploaded file was not a valid Movable Type exported manifest file."
            )
            if !( ( 'manifest' eq $name )
            && ( MT::BackupRestore::NS_MOVABLETYPE() eq $ns ) );
        $self->{start} = 0;
    }
    if ( MT::BackupRestore::NS_MOVABLETYPE() eq $ns ) {
        my $backups = $self->{backups};
        if ( ( 'file' eq $name ) && ( 'backup' eq $attrs{type} ) ) {
            push @{ $backups->{files} }, $attrs{name};
        }
        elsif ( ( 'file' eq $name ) && ( 'asset' eq $attrs{type} ) ) {
            push @{ $backups->{assets} },
                {
                name     => $attrs{name},
                asset_id => $attrs{'asset_id'},
                };
        }
        $self->{backups} = $backups;
    }
    1;
}

sub characters {
    my $self = shift;
    my $data = shift;
    1;
}

sub end_element {
    my $self = shift;
    my $data = shift;
    1;
}

1;
