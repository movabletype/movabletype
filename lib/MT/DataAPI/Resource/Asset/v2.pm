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
        $MT::DataAPI::Resource::Common::fields{createdBy},
        $MT::DataAPI::Resource::Common::fields{createdDate},
        $MT::DataAPI::Resource::Common::fields{modifiedBy},
        $MT::DataAPI::Resource::Common::fields{modifiedDate},
        qw(
            class
            parent
            ),
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
        {   name        => 'type',
            from_object => sub {
                my $obj = shift;
                lc $obj->class_label;
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
