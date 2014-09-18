# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::Asset::v2;

use strict;
use warnings;

use MT::DataAPI::Resource::Common;

sub fields {
    [   $MT::DataAPI::Resource::Common::fields{blog},
        qw(
            class
            parent
            ),
        {   name             => 'createdUser',
            bulk_from_object => sub {
                my ( $objs, $hashes ) = @_;

                my @author_ids = grep {$_} map { $_->created_by } @$objs;
                my %authors = ();
                my @authors
                    = @author_ids
                    ? MT->model('author')->load( { id => \@author_ids, } )
                    : ();
                $authors{ $_->id } = $_ for @authors;

                my $size = scalar(@$objs);
                for ( my $i = 0; $i < $size; $i++ ) {
                    my $asset = $objs->[$i];
                    my $a = $authors{ $asset->created_by || 0 } or next;
                    $hashes->[$i]{createdUser}
                        = MT::DataAPI::Resource->from_object( $a,
                        [qw(id displayName userpicUrl)] );
                }
            },
        },
        {   name             => 'modifiedUser',
            bulk_from_object => sub {
                my ( $objs, $hashes ) = @_;

                my @author_ids = grep {$_} map { $_->modified_by } @$objs;
                my %authors = ();
                my @authors
                    = @author_ids
                    ? MT->model('author')->load( { id => \@author_ids, } )
                    : ();
                $authors{ $_->id } = $_ for @authors;

                my $size = scalar(@$objs);
                for ( my $i = 0; $i < $size; $i++ ) {
                    my $asset = $objs->[$i];
                    my $a = $authors{ $asset->modified_by || 0 } or next;
                    $hashes->[$i]{modifiedUser}
                        = MT::DataAPI::Resource->from_object( $a,
                        [qw(id displayName userpicUrl)] );
                }
            },
        },
        {   name  => 'createdDate',
            alias => 'created_on',
            type  => 'MT::DataAPI::Resource::DataType::ISO8601',
        },
        {   name  => 'modifiedDate',
            alias => 'modified_on',
            type  => 'MT::DataAPI::Resource::DataType::ISO8601',
        },
        {   name             => 'fileSize',
            bulk_from_object => sub {
                my ( $objs, $hashes ) = @_;

                require MT::FileMgr;
                my $fmgr = MT::FileMgr->new('Local');

                for ( my $i = 0; $i < scalar @$objs; $i++ ) {
                    my $obj = $objs->[$i];
                    my $file_path = $obj->file_path or next;

                    my $size = $fmgr->file_size($file_path);
                    if ( defined($size) && $size =~ m/^\d+$/ ) {
                        $hashes->[$i]{fileSize} = $size;
                    }
                }
            },
        },
        {   name  => 'imageWidth',
            alias => 'image_width',
            type  => 'MT::DataAPI::Resource::DataType::Integer',
        },
        {   name  => 'imageHeight',
            alias => 'image_height',
            type  => 'MT::DataAPI::Resource::DataType::Integer',
        },
        {   name             => 'updatable',
            type             => 'MT::DataAPI::Resource::DataType::Boolean',
            bulk_from_object => sub {
                my ( $objs, $hashes ) = @_;
                my $app  = MT->instance;
                my $user = $app->user;

                if ( $user->is_superuser ) {
                    $_->{updatable} = 1 for @$hashes;
                    return;
                }

                my %blog_perms;
                for ( my $i = 0; $i < scalar @$objs; $i++ ) {
                    my $obj = $objs->[$i];

                    my $asset_blog_id = $obj->blog_id;
                    if ( !exists $blog_perms{$asset_blog_id} ) {
                        $blog_perms{$asset_blog_id}
                            = $user->permissions($asset_blog_id)
                            ->can_do('save_asset');
                    }

                    if ( $blog_perms{$asset_blog_id} ) {
                        $hashes->[$i]{updatable} = 1;
                    }
                }
            },
        },
        {   name  => 'fileExtension',
            alias => 'file_ext',
        },
        {   name             => 'filePath',
            bulk_from_object => sub {
                my ( $objs, $hashes ) = @_;
                my $app = MT->instance;
                my $user = $app->user or return;

                if ( $user->is_superuser ) {
                    for ( my $i = 0; $i < scalar(@$objs); $i++ ) {
                        $hashes->[$i]{filePath} = $objs->[$i]->file_path;
                    }
                    return;
                }

                my %blog_perms;
                for ( my $i = 0; $i < scalar @$objs; $i++ ) {
                    my $obj = $objs->[$i];

                    my $asset_blog_id = $obj->blog_id;
                    if ( !exists $blog_perms{$asset_blog_id} ) {
                        $blog_perms{$asset_blog_id}
                            = $user->permissions($asset_blog_id)
                            ->can_do('open_asset_edit_screen');
                    }

                    if ( $blog_perms{$asset_blog_id} ) {
                        $hashes->[$i]{filePath} = $objs->[$i]->file_path;
                    }
                }
            },
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::Asset::v2 - Movable Type class for resources definitions of the MT::Asset.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
