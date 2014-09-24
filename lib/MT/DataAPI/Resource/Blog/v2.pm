# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::Blog::v2;

use strict;
use warnings;

sub updatable_fields {
    [
        # v1 fields
        qw(
            name
            description
            url
            archiveUrl
            ),

        # v2 fields
        qw(
            themeId
            sitePath
            serverOffset
            language

            fileExtension
            archiveTypePreferred
            publishEmptyArchive
            includeSystem
            includeCache
            useRevision
            maxRevisionsEntry
            maxRevisionsTemplate

            dateLanguage
            ),
    ];
}

sub fields {
    [
        # Create Blog screen
        {   name      => 'themeId',
            alias     => 'theme_id',
            condition => \&_can_view,
        },
        {   name      => 'sitePath',
            alias     => 'site_path',
            condition => \&_can_view,
        },
        {   name      => 'archivePath',
            alias     => 'archive_path',
            condition => \&_can_view,
        },
        qw(
            serverOffset
            language
            ),

        # General Settings screen
        {   name      => 'fileExtension',
            alias     => 'file_extension',
            condition => \&_can_view,
        },
        {   name      => 'archiveTypePreferred',
            alias     => 'archive_type_preferred',
            condition => \&_can_view,
        },
        {   name        => 'publishEmptyArchive',
            alias       => 'publish_empty_archive',
            type        => 'MT::DataAPI::Resource::DataType::Boolean',
            from_object => sub { $_[0]->publish_empty_archive },
            condition   => \&_can_view,
        },
        {   name        => 'includeSystem',
            alias       => 'include_system',
            from_object => sub { $_[0]->include_system },
            condition   => \&_can_view,
        },
        {   name        => 'includeCache',
            alias       => 'include_cache',
            type        => 'MT::DataAPI::Resource::DataType::Boolean',
            from_object => sub { $_[0]->include_cache },
            condition   => \&_can_view,
        },
        {   name      => 'useRevision',
            alias     => 'use_revision',
            type      => 'MT::DataAPI::Resource::DataType::Boolean',
            condition => \&_can_view,
        },
        {   name        => 'maxRevisionsEntry',
            alias       => 'max_revisions_entry',
            from_object => sub { $_[0]->max_revisions_entry },
            condition   => \&_can_view,
        },
        {   name        => 'maxRevisionsTemplate',
            alias       => 'max_revisions_template',
            from_object => sub { $_[0]->max_revisions_template },
            condition   => \&_can_view,
        },

        # template tags
        {   name        => 'ccLicenseImage',
            from_object => sub {
                my ($obj) = @_;
                my $cc = $obj->cc_license or return '';
                my ( $code, $license, $image_url )
                    = $cc =~ /(\S+) (\S+) (\S+)/;
                return $image_url if $image_url;
                "http://creativecommons.org/images/public/"
                    . ( $cc eq 'pd' ? 'norights' : 'somerights' );
            },
        },
        'ccLicenseUrl',
        'dateLanguage',
        {   name        => 'host',
            from_object => sub {
                my ($obj) = @_;
                my $host = $obj->site_url;
                if ( $host =~ m!^https?://([^/:]+)(:\d+)?/?! ) {
                    return $1 . ( $2 || '' );
                }
                else {
                    return '';
                }
            },
        },
        {   name        => 'relativeUrl',
            from_object => sub {
                my ($obj) = @_;
                my $host = $obj->site_url;
                return '' unless defined $host;
                if ( $host =~ m{^https?://[^/]+(/.*)$} ) {
                    return $1;
                }
                else {
                    return '';
                }
            },
        },
        {   name        => 'timezone',
            from_object => sub {
                my ($obj)               = @_;
                my $so                  = $obj->server_offset;
                my $partial_hour_offset = 60 * abs( $so - int($so) );
                return sprintf( "%s%02d:%02d",
                    $so < 0 ? '-' : '+',
                    abs($so),, $partial_hour_offset );
            },
        },
    ];
}

sub _can_view {
    my $app  = MT->instance;
    my $user = $app->user;

    require MT::CMS::Blog;
    if (!(  $user && ( $user->is_superuser
                || $app->can_do('access_to_blog_config_screen')
                || MT::CMS::Blog::can_view( undef, $app, 1 ) )
        )
        )
    {
        return;
    }

    return 1;
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::Blog::v2 - Movable Type class for resources definitions of the MT::Blog.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
