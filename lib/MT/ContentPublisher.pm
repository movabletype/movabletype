# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ContentPublisher;

use strict;
use base qw( MT::WeblogPublisher );
our @EXPORT = qw(ArchiveFileTemplate ArchiveType);

use MT::ArchiveType;
use File::Basename;

our %ArchiveTypes;

sub init_archive_types {
    my $types = MT->registry("archive_types") || {};
    my $mt = MT->instance;
    while ( my ( $type, $typedata ) = each %$types ) {
        if ( 'HASH' eq ref $typedata ) {
            $typedata = MT::ArchiveType->new(%$typedata);
        }
        $ArchiveTypes{$type} = $typedata;
    }
}

sub archive_types {
    init_archive_types(@_) unless %ArchiveTypes;
    keys %ArchiveTypes;
}

sub archiver {
    my $mt = shift;
    my ($at) = @_;
    init_archive_types() unless %ArchiveTypes;
    my $archiver = $at ? $ArchiveTypes{$at} : undef;
    if ( $archiver && !ref($archiver) ) {

        # A package name-- load package and instantiate Archiver object
        if ( $archiver =~ m/::/ ) {
            eval("require $archiver; 1;");
            die "Invalid archive type package '$archiver': $@"
                if $@;    # fatal error here
            my $inst = $archiver->new();
            $archiver = $ArchiveTypes{$at} = $inst;
        }
    }
    return $archiver;
}

sub rebuild {
    my $mt = shift;
    $mt->SUPER::rebuild(@_);
}

sub rebuild_categories {
    my $mt = shift;
    $mt->SUPER::rebuild_categories(@_);
}

sub rebuild_authors {
    my $mt = shift;
    $mt->SUPER::rebuild_authors(@_);
}

sub rebuild_deleted_entry {
    my $mt = shift;
    $mt->SUPER::rebuild_deleted_entry(@_);
}

sub rebuild_entry {
    my $mt = shift;
    $mt->SUPER::rebuild_entry(@_);
}

sub rebuild_archives {
    my $mt = shift;
    $mt->SUPER::rebuild_archives(@_);
}

sub rebuild_file {
    my $mt = shift;
    $mt->SUPER::rebuild_file(@_);
}

sub rebuild_indexes {
    my $mt = shift;
    $mt->SUPER::rebuild_indexes(@_);
}

sub rebuild_from_fileinfo {
    my $mt = shift;
    $mt->SUPER::rebuild_from_fileinfo(@_);
}

1;
