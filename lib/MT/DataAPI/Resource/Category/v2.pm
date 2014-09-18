# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::Category::v2;

use strict;
use warnings;

use MT::TBPing;
use MT::Util;
use MT::CMS::Category;
use MT::DataAPI::Resource::Util;

sub updatable_fields {
    [   qw(
            parent
            allowTrackbacks
            pingUrls
            )
    ];
}

sub fields {
    [   {   name             => 'updatable',
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

                    next if $obj->class ne 'category';

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
        {   name                => 'allowTrackbacks',
            alias               => 'allow_pings',
            from_object_default => 0,
            type                => 'MT::DataAPI::Resource::DataType::Boolean',
        },
        {   name        => 'pingUrls',
            alias       => 'ping_urls',
            from_object => sub {
                my ($obj) = @_;

                if ( !_can_view($obj) ) {
                    return;
                }

                return $obj->ping_url_list;
            },
            to_object => sub {
                my ($hash) = @_;

                my $ping_urls = $hash->{pingUrls};
                if ( ref($ping_urls) ne 'ARRAY' ) {
                    $ping_urls = [$ping_urls];
                }

                return join( "\n", @$ping_urls );
            },
        },
        {   name        => 'archiveLink',
            from_object => sub {
                my ($obj) = @_;

                my $blog = MT->model('blog')->load( $obj->blog_id );
                if ( !$blog ) {
                    return;
                }

                my $url = $blog->archive_url;
                $url .= '/' unless $url =~ m/\/$/;
                $url .= MT::Util::archive_file_for( undef, $blog, 'Category',
                    $obj );

                return $url;
            },
        },
        {   name        => 'trackbackUrl',
            from_object => sub {
                my ($obj) = @_;
                my $app = MT->instance;

                if ( !_can_view($obj) ) {
                    return;
                }

                my $tb = MT->model('trackback')->load(
                    {   blog_id     => $obj->blog_id,
                        category_id => $obj->id,
                    }
                );
                if ( !$tb ) {
                    return '';
                }

                my $path = $app->config('CGIPath');
                $path .= '/' unless $path =~ m/\/$/;
                if ( $path =~ m!^/! ) {
                    my $blog = MT->model('blog')->load( $obj->blog_id );
                    return if !$blog;
                    my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
                    $path = $blog_domain . $path;
                }

                my $script = $app->config('TrackbackScript');
                my $tb_url = $path . $script . '/' . $tb->id;

                return $tb_url;
            },
        },
        {   name        => 'passphrase',
            from_object => sub {
                my ($obj) = @_;
                my $app = MT->instance;

                if ( !_can_view($obj) ) {
                    return;
                }

                my $tb = MT->model('trackback')->load(
                    {   blog_id     => $obj->blog_id,
                        category_id => $obj->id,
                    }
                );
                if ( !$tb ) {
                    return '';
                }

                if ( defined $tb->passphrase ) {
                    return $tb->passphrase;
                }
                else {
                    return '';
                }
            },
        },
        {   name        => 'trackbackCount',
            from_object => sub {
                my ($obj) = @_;

                my ( $terms, $args ) = _generate_tb_terms_args($obj);

                my $count = MT::TBPing->count( $terms, $args );
                if ( !defined($count) ) {
                    return;
                }

                return $count;
            },
        },
        {   name        => 'trackbacks',
            from_object => sub {
                my ($obj) = @_;
                my $app = MT->instance;
                my $max
                    = MT::DataAPI::Resource::Util::int_param( $app,
                    'maxTrackbacks' )
                    or return [];

                my ( $terms, $args ) = _generate_tb_terms_args($obj);

                $args->{sort}      = 'id';
                $args->{direction} = 'ascend';
                $args->{limit}     = $max;

                MT::DataAPI::Resource->from_object(
                    MT::TBPing->load( $terms, $args ) || [] );
            },
        },
    ];
}

sub _generate_tb_terms_args {
    my ($obj) = @_;
    my $app   = MT->instance;
    my $user  = $app->user;

    my $can_access_not_published = 0;
    if ($user) {
        if ( $user->is_superuser ) {
            $can_access_not_published = 1;
        }
        else {
            my $perm = $app->model('permission')->load(
                {   author_id => $user->id,
                    blog_id   => $obj->blog_id,
                },
            );
            if (   $perm
                && $perm->can_do('open_category_trackback_edit_screen') )
            {
                $can_access_not_published = 1;
            }
        }
    }

    my %terms;
    if ($can_access_not_published) {
        %terms = ( blog_id => $obj->blog_id );
    }
    else {
        %terms = (
            blog_id     => $obj->blog_id,
            visible     => 1,
            junk_status => MT::TBPing::NOT_JUNK(),
        );
    }

    my %args = (
        join => MT->model('trackback')->join_on(
            undef,
            {   id          => \'= tbping_tb_id',
                blog_id     => $obj->blog_id,
                category_id => $obj->id,
            },
        ),
    );

    return ( \%terms, \%args );
}

sub _can_view {
    my ($obj) = @_;
    my $app = MT->instance;
    my $user = $app->user or return;

    my $perm = MT->model('permission')->load(
        {   author_id => $user->id,
            blog_id   => $obj->blog_id,
        }
    );
    if ( $perm && $perm->can_do('open_category_edit_screen') ) {
        return 1;
    } else {
        return;
    }
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::Category::v2 - Movable Type class for resources definitions of the MT::Category.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
