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
    my ( $app, $type ) = @_;
    my $types
        = $type eq 'ct'
        ? MT->registry("ct_archive_types") || {}
        : MT->registry("archive_types") || {};
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

sub core_archive_types {
    return {
        'ContentType'         => 'MT::ArchiveType::ContentType',
        'ContentType-Yearly'  => 'MT::ArchiveType::ContentTypeYearly',
        'ContentType-Monthly' => 'MT::ArchiveType::ContentTypeMonthly',
        'ContentType-Weekly'  => 'MT::ArchiveType::ContentTypeWeekly',
        'ContentType-Daily'   => 'MT::ArchiveType::ContentTypeDaily',
        'ContentType_Author'  => 'MT::ArchiveType::ContentTypeAuthor',
        'ContentType_Author-Yearly' =>
            'MT::ArchiveType::ContentTypeAuthorYearly',
        'ContentType_Author-Monthly' =>
            'MT::ArchiveType::ContentTypeAuthorMonthly',
        'ContentType_Author-Weekly' =>
            'MT::ArchiveType::ContentTypeAuthorWeekly',
        'ContentType_Author-Daily' =>
            'MT::ArchiveType::ContentTypeAuthorDaily',
        'ContentType_Category' => 'MT::ArchiveType::ContentTypeCategory',
        'ContentType_Category-Yearly' =>
            'MT::ArchiveType::ContentTypeCategoryYearly',
        'ContentType_Category-Monthly' =>
            'MT::ArchiveType::ContentTypeCategoryMonthly',
        'ContentType_Category-Weekly' =>
            'MT::ArchiveType::ContentTypeCategoryWeekly',
        'ContentType_Category-Daily' =>
            'MT::ArchiveType::ContentTypeCategoryDaily',
    };

}

1;
