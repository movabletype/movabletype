# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v3::Blog;

use strict;
use warnings;

use boolean ();
use File::Spec;

use MT::Entry;
use MT::DataAPI::Resource;
use MT::DataAPI::Resource::Common;

sub updatable_fields {
    [];    # Nothing. Same as v2.
}

sub fields {
    [   {   name        => 'uploadDestination',
            alias       => 'upload_destination',
            from_object => sub {
                my ($obj) = @_;
                my $dest  = $obj->site_path;    # site_path is a default.
                my $raw   = '';
                if ( defined $obj->upload_destination ) {
                    $dest = $raw = $obj->upload_destination;
                    my $root_path;
                    if ( $dest =~ m/^%s/i ) {
                        $root_path = $obj->site_path;
                    }
                    else {
                        $root_path = $obj->archive_path;
                    }
                    $dest = MT::Util::build_upload_destination($dest);
                    $dest = File::Spec->catdir( $root_path, $dest );
                }

                return {
                    raw  => $raw,
                    path => $dest,
                };
            },
            condition => \&can_view,
            schema => {
                type       => 'object',
                properties => {
                    raw  => { type => 'string' },
                    path => { type => 'string' },
                },
            },
        },
        {   name                => 'extraPath',
            alias               => 'extra_path',
            from_object         => sub { $_[0]->extra_path; },
            from_object_default => '',
            condition           => \&can_view,
        },
        {   name                => 'allowToChangeAtUpload',
            alias               => 'allow_to_change_at_upload',
            type                => 'MT::DataAPI::Resource::DataType::Boolean',
            from_object         => sub { $_[0]->allow_to_change_at_upload },
            from_object_default => 1,
            condition           => \&can_view,
        },
        {   name                => 'operationIfExists',
            alias               => 'operation_if_exists',
            type                => 'MT::DataAPI::Resource::DataType::Integer',
            from_object         => sub { $_[0]->operation_if_exists; },
            from_object_default => 1,
            condition           => \&can_view,
        },
        {   name                => 'normalizeOrientation',
            alias               => 'normalize_orientation',
            type                => 'MT::DataAPI::Resource::DataType::Boolean',
            from_object         => sub { $_[0]->normalize_orientation; },
            from_object_default => 1,
            condition           => \&can_view,
        },
        {   name                => 'autoRenameNonAscii',
            alias               => 'auto_rename_non_ascii',
            type                => 'MT::DataAPI::Resource::DataType::Boolean',
            from_object         => sub { $_[0]->auto_rename_non_ascii; },
            from_object_default => 1,
            condition           => \&can_view,
        },
    ];
}

sub can_view {
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

MT::DataAPI::Resource::v3::Blog - Movable Type class for resources definitions of the MT::Blog.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
