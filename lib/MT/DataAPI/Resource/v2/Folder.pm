# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v2::Folder;

use strict;
use warnings;

use MT::DataAPI::Resource::v1::Category;
use MT::DataAPI::Resource::v2::Category;

sub updatable_fields {
    [   @{ MT::DataAPI::Resource::v1::Category::updatable_fields() },
        @{ MT::DataAPI::Resource::v2::Category::updatable_fields() },
    ];
}

sub fields {
    [   @{ MT::DataAPI::Resource::v1::Category::fields() },
        @{ MT::DataAPI::Resource::v2::Category::fields() },
        {   name        => 'archiveLink',
            from_object => sub {return},    # Do nothing.
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

                    next if $obj->is_category;

                    my $cat_blog_id = $obj->blog_id;
                    if ( !exists $blog_perms{$cat_blog_id} ) {
                        $blog_perms{$cat_blog_id}
                            = $user->permissions($cat_blog_id)
                            ->can_do('save_folder');
                    }

                    if ( $blog_perms{$cat_blog_id} ) {
                        $hashes->[$i]{updatable} = 1;
                    }
                }
            },
        },
        {   name        => 'path',
            from_object => sub {
                my ($obj) = @_;
                my $app = MT->instance or return;

                my $site = $app->model('blog')->load( $obj->blog_id )
                    or return;
                my $site_url = $site->site_url;
                $site_url .= '/' unless $site_url =~ m/\/$/;

                my $parent = $obj->parent_category;
                my $path
                    = $site_url . ( $parent ? $parent->publish_path : '' );
                $path .= '/' unless $path =~ m/\/$/;

                # This path
                my $basename = $obj->basename || '';
                $basename =~ s/_/-/g;
                $path .= $basename;
                return $path;
            },
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v2::Folder - Movable Type class for resources definitions of the MT::Folder.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
