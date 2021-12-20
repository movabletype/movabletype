# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::Blog;

use strict;
use warnings;

use MT::Revisable;
use MT::Theme;
use MT::CMS::Common;
use MT::CMS::Blog;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list_openapi_spec {
    +{
        tags       => ['Sites'],
        summary    => 'Retrieve sites',
        parameters => [
            { '$ref' => '#/components/parameters/site_search' },
            { '$ref' => '#/components/parameters/site_searchFields' },
            { '$ref' => '#/components/parameters/site_limit' },
            { '$ref' => '#/components/parameters/site_offset' },
            { '$ref' => '#/components/parameters/site_sortBy' },
            { '$ref' => '#/components/parameters/site_sortOrder' },
            { '$ref' => '#/components/parameters/site_fields' },
            { '$ref' => '#/components/parameters/site_includeIds' },
            { '$ref' => '#/components/parameters/site_excludeIds' },
        ],
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                totalResults => {
                                    type        => 'integer',
                                    description => 'The total number of sites found.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of sites resource. The list will sorted descending by blog name. ',
                                    items       => {
                                        '$ref' => '#/components/schemas/blog',
                                    }
                                },
                            },
                        },
                    },
                },
            },
        },
    };
}

sub list {
    my ( $app, $endpoint ) = @_;

    my %terms = ( class => '*' );
    my $res = filtered_list( $app, $endpoint, 'blog', \%terms ) or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub list_by_parent_openapi_spec {
    +{
        tags       => ['Sites'],
        summary    => 'Retrieve sites by parent ID',
        parameters => [
            { '$ref' => '#/components/parameters/site_search' },
            { '$ref' => '#/components/parameters/site_searchFields' },
            { '$ref' => '#/components/parameters/site_limit' },
            { '$ref' => '#/components/parameters/site_offset' },
            { '$ref' => '#/components/parameters/site_sortBy' },
            { '$ref' => '#/components/parameters/site_sortOrder' },
            { '$ref' => '#/components/parameters/site_fields' },
            { '$ref' => '#/components/parameters/site_includeIds' },
            { '$ref' => '#/components/parameters/site_excludeIds' },
        ],
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                totalResults => {
                                    type        => 'integer',
                                    description => 'The total number of sites found.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of sites resource. The list will sorted descending by blog name. ',
                                    items       => {
                                        '$ref' => '#/components/schemas/blog',
                                    }
                                },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site not found.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/ErrorContent',
                        },
                    },
                },
            },
        },
    };
}

sub list_by_parent {
    my ( $app, $endpoint ) = @_;

    my ($blog) = context_objects(@_) or return;

    my %terms = ( class => 'blog', parent_id => $blog->id );
    my $res = filtered_list( $app, $endpoint, 'blog', \%terms ) or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub _rebuild_pages {
    my ($site) = @_;
    my $app = MT->instance;

    my $dcty = $site->custom_dynamic_templates || 'none';
    if ( ( $dcty eq 'all' ) || ( $dcty eq 'archives' ) ) {
        my %param = ();
        MT::CMS::Blog::_create_build_order( $app, $site, \%param );
        $app->param( 'single_template', 1 );    # to show tmpl full-screen
        if ( $dcty eq 'all' ) {
            $app->param( 'type', $param{build_order} );
        }
        elsif ( $dcty eq 'archives' ) {
            my @ats
                = map { $_->{archive_type} } @{ $param{archive_type_loop} };
            $app->param( 'type', join( ',', @ats ) );
        }
        MT::CMS::Blog::start_rebuild_pages_directly($app);
    }

    my $site_path = $site->site_path;
    my $fmgr      = $site->file_mgr;
    unless ( $fmgr->exists($site_path) ) {
        $fmgr->mkpath($site_path);
    }
}

sub insert_new_blog_openapi_spec {
    +{
        tags => ['Sites'],
        summary => 'Create a new blog',
        description => <<'DESCRIPTION',
- Authorization is required.

#### Permissions

- create_blog
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            blog => {
                                '$ref' => '#/components/schemas/blog_updatable',
                            },
                        },
                    },
                },
            },
        },
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/blog',
                        },
                    },
                },
            },
            404 => {
                description => 'Site not found.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/ErrorContent',
                        },
                    },
                },
            },
        },
    };
}

# Implemented by reference to MT::CMS::Common::save().
sub insert_new_blog {
    my ( $app, $endpoint ) = @_;

    my ($site) = context_objects(@_);
    return unless $site && $site->id;
    if ( $site->is_blog ) {
        return $app->error(
            $app->translate(
                'Cannot create a blog under blog (ID:[_1]).',
                $site->id
            ),
            400
        );
    }

    my $orig_blog = $app->model('blog')->new;
    $orig_blog->set_values(
        {   language      => MT->config->DefaultLanugage || '',
            date_language => MT->config->DefaultLanguage || '',
            nofollow_urls => 1,
            follow_auth_links        => 1,
            page_layout              => 'layout-wtt',
            commenter_authenticators => _generate_commenter_authenticators(),
            max_revisions_entry      => $MT::Revisable::MAX_REVISIONS,
            max_revisions_template   => $MT::Revisable::MAX_REVISIONS,
        }
    );

    my $new_blog = $app->resource_object( 'blog', $orig_blog ) or return;

    # Set theme if "themeId" parameter not set.
    if ( !defined( $new_blog->theme_id ) ) {
        $new_blog->theme_id( _default_theme( $app, 'blog' ) );
    }

    MT::CMS::Common::run_web_services_save_config_callbacks( $app,
        $new_blog );

    # Generate site_url and set.
    my $blog_json = $app->param('blog');
    my $blog_hash = $app->current_format->{unserialize}->($blog_json);

    my $subdomain = $blog_hash->{subdomain};
    my $path      = $blog_hash->{url};

    if (   !( defined $subdomain && $subdomain ne '' )
        && !( defined $path && $path ne '' ) )
    {
        return $app->error(
            $app->translate(
                'Either parameter of "url" or "subdomain" is required.'),
            400
        );
    }

    $new_blog->created_by( $app->user->id );

    save_object(
        $app, 'blog',
        $new_blog,
        $orig_blog,
        sub {
            $new_blog->touch;
            $_[0]->();
        }
    ) or return;

    if ( $new_blog->is_changed('custom_dynamic_templates') ) {
        _rebuild_pages($new_blog);
    }

    $new_blog;
}

sub _default_theme {
    my ( $app, $type ) = @_ or return;

    my $directive     = 'Default' . ucfirst($type) . 'Theme';
    my $default_theme = $app->config($directive);

    if ( $default_theme && MT::Theme->load($default_theme) ) {

        # default theme is available.
        return $default_theme;
    }
    else {
        # If default theme is not available,
        # select the default theme displayed on Create Website/Blog screen.
        my $loop = MT::Theme->load_theme_loop($type);
        if ( ref($loop) eq 'ARRAY' && @$loop ) {
            return $loop->[0]->{value};
        }
        else {
            return;    # No theme.
        }
    }
}

sub insert_new_website_openapi_spec {
    +{
        tags        => ['Sites'],
        summary     => 'Create a new website',
        description => <<'DESCRIPTION',
- Authorization is required.

#### Permissions

- create_website
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            website => {
                                '$ref' => '#/components/schemas/blog_updatable',
                            },
                        },
                    },
                },
            },
        },
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/blog',
                        },
                    },
                },
            },
            404 => {
                description => 'Site not found.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/ErrorContent',
                        },
                    },
                },
            },
        },
    };
}

# Implemented by reference to MT::CMS::Common::save().
sub insert_new_website {
    my ( $app, $endpoint ) = @_;

    my $orig_website = $app->model('website')->new;
    $orig_website->set_values(
        {   language      => MT->config->DefaultLanugage || '',
            date_language => MT->config->DefaultLanguage || '',
            nofollow_urls => 1,
            follow_auth_links        => 1,
            page_layout              => 'layout-wtt',
            commenter_authenticators => _generate_commenter_authenticators(),
            max_revisions_entry      => $MT::Revisable::MAX_REVISIONS,
            max_revisions_template   => $MT::Revisable::MAX_REVISIONS,
        }
    );

    my $new_website = $app->resource_object( 'website', $orig_website )
        or return;

    # Set theme if "themeId" parameter not set.
    if ( !defined( $new_website->theme_id ) ) {
        $new_website->theme_id( _default_theme( $app, 'website' ) );
    }

    MT::CMS::Common::run_web_services_save_config_callbacks( $app,
        $new_website );

    $new_website->created_by( $app->user->id );

    save_object(
        $app,
        'website',
        $new_website,
        $orig_website,
        sub {
            $new_website->touch;
            $_[0]->();
        }
    ) or return;

    if ( $new_website->is_changed('custom_dynamic_templates') ) {
        _rebuild_pages($new_website);
    }

    $new_website;
}

sub update_openapi_spec {
    +{
        tags        => ['Sites'],
        summary     => 'Update an existing blog or website',
        description => <<'DESCRIPTION',
- Authorization is required.

#### Permissions

- edit_blog_config
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            website => {
                                '$ref' => '#/components/schemas/blog_updatable',
                            },
                        },
                    },
                },
            },
        },
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/blog',
                        },
                    },
                },
            },
            404 => {
                description => 'Site not found.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/ErrorContent',
                        },
                    },
                },
            },
        },
    };
}

sub update {
    my ( $app, $endpoint ) = @_;

    my ($site) = context_objects(@_)
        or return;
    if ( !$site->id ) {
        return $app->error( $app->translate('Site not found'), 404 );
    }

    my $new_site = $app->resource_object( $site->class, $site )
        or return;

    MT::CMS::Common::run_web_services_save_config_callbacks( $app,
        $new_site );

    $new_site->modified_by( $app->user->id );

    save_object(
        $app,
        $new_site->class,
        $new_site,
        $site,
        sub {
            $new_site->touch;
            $_[0]->();
        }
    ) or return;

    if ( $new_site->is_changed('custom_dynamic_templates') ) {
        _rebuild_pages($new_site);
    }

    $new_site;
}

sub delete_openapi_spec {
    +{
        tags        => ['Sites'],
        summary     => 'Delete an existing blog or website',
        description => <<'DESCRIPTION',
- Authorization is required.

#### Permissions

- delete_website (for website)
- delete_blog (for blog)
DESCRIPTION
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/blog',
                        },
                    },
                },
            },
            404 => {
                description => 'Site not found.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/ErrorContent',
                        },
                    },
                },
            },
        },
    };
}

sub delete {
    my ( $app, $endpoint ) = @_;

    my ($site) = context_objects(@_)
        or return;
    if ( !$site->id ) {
        return $app->error( $app->translate('Site not found'), 404 );
    }

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        $site->class, $site )
        or return;

    # If website.
    if ( !$site->is_blog ) {
        my $child_blog_count
            = MT->model('blog')->count( { parent_id => $site->id } );
        if ($child_blog_count) {
            return $app->error(
                $app->translate(
                    'Website "[_1]" (ID:[_2]) was not deleted. You need to delete the blogs under the website first.',
                    ( defined $site->name ? $site->name : '(no name)' ),
                    $site->id,
                ),
                403,
            );
        }
    }

    $site->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $site->class_label,
            $site->errstr
        ),
        500,
        );

    $app->run_callbacks( 'data_api_post_delete.' . $site->class, $app,
        $site );

    $app->run_callbacks( 'rebuild', $site );

    return $site;
}

sub _generate_commenter_authenticators {
    my @authenticators = qw( MovableType );
    my @default_auth = split /,/, MT->config('DefaultCommenterAuth');
    foreach my $auth (@default_auth) {
        my $a = MT->commenter_authenticator($auth);
        if ( !defined $a
            || ( exists $a->{condition} && ( !$a->{condition}->() ) ) )
        {
            next;
        }
        push @authenticators, $auth;
    }
    return join( ',', @authenticators );
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2::Blog - Movable Type class for endpoint definitions about the MT::Blog.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
