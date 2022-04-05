# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v2::Asset;

use strict;
use warnings;

use MT::DataAPI::Resource::Common;

sub updatable_fields {
    [];    # Nothing. Same as v1.
}

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
        {   name        => 'parent',
            from_object => sub {
                my ($obj) = @_;
                return $obj->parent ? +{ id => $obj->parent } : undef;
            },
        },
        {   name             => 'meta',
            bulk_from_object => sub {
                my ( $objs, $hashes ) = @_;

                require MT::FileMgr;
                my $fmgr = MT::FileMgr->new('Local');

                for my $i ( 0 .. ( scalar(@$objs) - 1 ) ) {
                    my $obj  = $objs->[$i];
                    my $hash = $hashes->[$i];

                    my $size;
                    if ( my $file_path = $obj->file_path ) {
                        $size = $fmgr->file_size($file_path);
                    }

                    $hash->{meta} = +{
                        width => $obj->has_meta('image_width')
                        ? $obj->image_width + 0
                        : undef,
                        height => $obj->has_meta('image_height')
                        ? $obj->image_height + 0
                        : undef,
                        fileSize => $size,
                    };
                }
            },
            schema => {
                type       => 'object',
                properties => {
                    fileSize => { type => 'integer' },
                    height   => { type => 'integer' },
                    width    => { type => 'integer' },
                },
            },
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

MT::DataAPI::Resource::v2::Asset - Movable Type class for resources definitions of the MT::Asset.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
