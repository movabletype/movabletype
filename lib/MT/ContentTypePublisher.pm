# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ContentTypePublisher;

use strict;
use base qw( MT::WeblogPublisher );
our @EXPORT = qw(ArchiveFileTemplate ArchiveType);

use MT::ArchiveType;
use File::Basename;

our %ArchiveTypes;

sub init_archive_types {
    my $types = MT->registry("ct_archive_types") || {};
    my $mt = MT->instance;
    while ( my ( $type, $typedata ) = each %$types ) {
        if ( 'HASH' eq ref $typedata ) {
            $typedata = MT::ArchiveType->new(%$typedata);
        }
        $ArchiveTypes{$type} = $typedata;
    }
}

sub archive_types {
    init_archive_types() unless %ArchiveTypes;
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

sub core_archive_types {
    return {
        'ContentType'         => 'MT::ArchiveType::ContentType',
        'ContentType-Yearly'  => 'MT::ArchiveType::ContentTypeYearly',
        'ContentType-Monthly' => 'MT::ArchiveType::ContentTypeMonthly',
        'ContentType-Weekly'  => 'MT::ArchiveType::ContentTypeWeekly',
        'ContentType-Daily'   => 'MT::ArchiveType::ContentTypeDaily',
    };

}

1;
