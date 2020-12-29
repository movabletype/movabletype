# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v2::Category;

use strict;
use warnings;

use MT::Util;
use MT::DataAPI::Resource::Common;

sub updatable_fields {
    [   qw(
            parent
            )
    ];
}

sub fields {
    [   {   name             => 'updatable',
            type             => 'MT::DataAPI::Resource::DataType::Boolean',
            bulk_from_object => sub {
                my ( $objs, $hashes ) = @_;
                my $app = MT->instance;
                my $user = $app->user or return;

                if ( $user->is_superuser ) {
                    $_->{updatable} = 1 for @$hashes;
                    return;
                }

                my %blog_perms;
                for ( my $i = 0; $i < scalar @$objs; $i++ ) {
                    my $obj = $objs->[$i];

                    next if !$obj->is_category;

                    my $cat_blog_id = $obj->blog_id;
                    if ( !exists $blog_perms{$cat_blog_id} ) {
                        $blog_perms{$cat_blog_id}
                            = $user->permissions($cat_blog_id)
                            ->can_do('save_category');
                    }

                    if ( $blog_perms{$cat_blog_id} ) {
                        $hashes->[$i]{updatable} = 1;
                    }
                }
            },
        },
        {   name        => 'archiveLink',
            from_object => sub {
                my ($obj) = @_;
                my $blog = MT->model('blog')->load( $obj->blog_id ) or return;

                my $url = $blog->archive_url;
                $url .= '/' unless $url =~ m/\/$/;
                $url .= MT::Util::archive_file_for( undef, $blog, 'Category',
                    $obj );

                return $url;
            },
        },
        $MT::DataAPI::Resource::Common::fields{createdBy},
        $MT::DataAPI::Resource::Common::fields{createdDate},
        $MT::DataAPI::Resource::Common::fields{modifiedBy},
        $MT::DataAPI::Resource::Common::fields{modifiedDate},
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v2::Category - Movable Type class for resources definitions of the MT::Category.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
