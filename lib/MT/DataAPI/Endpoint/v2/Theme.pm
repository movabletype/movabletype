# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v2::Theme;

use strict;
use warnings;

use File::Spec;

use MT::FileMgr;
use MT::Theme;
use MT::Util qw( dirify );
use MT::CMS::Theme;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub list_openapi_spec {
    +{
        tags        => ['Themes'],
        summary     => 'Retrieve a list of themes',
        description => <<'DESCRIPTION',
- Authentication is required

#### Permissions

- manage_themes
DESCRIPTION
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
                                    description => ' The total number of themes.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of theme resource.',
                                    items       => {
                                        '$ref' => '#/components/schemas/theme',
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

sub list {
    my ( $app, $endpoint ) = @_;

    return $app->error(403) if !$app->can_do('open_theme_listing_screen');

    my $themes        = _load_all_themes();
    my $return_themes = _list_for_system($themes);

    return +{
        totalResults => scalar(@$return_themes),
        items        => $return_themes,
    };
}

sub _load_all_themes {
    my ($args) = @_;

    my @themes = values %{ MT::Theme->load_all_themes };
    if ( $args->{blog_only} ) {
        @themes = grep { ( $_->{class} || '' ) ne 'website' } @themes;
    }

    for (@themes) {
        $_->{label} = $_->{label}->() if ref $_->{label};
        $_->{blog_count} = MT->model('blog')
            ->count( { class => '*', theme_id => $_->id } );
    }
    @themes = sort { ( $a->{label} || '' ) cmp( $b->{label} || '' ) } @themes;

    return \@themes;
}

sub _list_for_system {
    my ($themes) = @_;

    my @themes_in_use    = grep { $_->{blog_count} } @$themes;
    my @themes_available = grep { !$_->{blog_count} } @$themes;

    my @themes_in_use_website
        = grep { ( $_->{class} || '' ) eq 'website' } @themes_in_use;
    my @themes_in_use_blog
        = grep { ( $_->{class} || '' ) ne 'website' } @themes_in_use;

    my @themes_available_website
        = grep { ( $_->{class} || '' ) eq 'website' } @themes_available;
    my @themes_available_blog
        = grep { ( $_->{class} || '' ) ne 'website' } @themes_available;

    return [
        @themes_in_use_website,    @themes_in_use_blog,
        @themes_available_website, @themes_available_blog
    ];
}

sub _list_for_website {
    my ( $website, $themes ) = @_;

    my ( $current_theme, @website_themes, @blog_themes );

    for my $t (@$themes) {
        if (   !$current_theme
            && defined $t->id
            && defined $website->theme_id
            && $t->id eq $website->theme_id )
        {
            $current_theme = $t;
        }
        elsif ( ( $t->{class} || '' ) eq 'website' ) {
            push @website_themes, $t;
        }
        else {
            push @blog_themes, $t;
        }
    }

    return [ $current_theme, @website_themes, @blog_themes ];
}

sub _list_for_blog {
    my ( $blog, $blog_themes ) = @_;

    my ( $current_theme, @blog_themes );

    for my $t (@$blog_themes) {
        if (   !$current_theme
            && defined $t->id
            && defined $blog->theme_id
            && $t->id eq $blog->theme_id )
        {
            $current_theme = $t;
        }
        else {
            push @blog_themes, $t;
        }
    }

    return [ $current_theme, @blog_themes ];
}

sub list_for_site_openapi_spec {
    my $spec = __PACKAGE__->list_openapi_spec();
    $spec->{summary} = 'Retrieve a list of themes for site',
    return $spec;
}

sub list_for_site {
    my ( $app, $endpoint ) = @_;

    return $app->error(403) if !$app->can_do('open_theme_listing_screen');

    my $return_themes;

    if ( $app->blog && $app->blog->id ) {
        my $site = $app->blog;
        if ( $site->is_blog ) {
            my $blog_themes = _load_all_themes( { blog_only => 1 } );
            $return_themes = _list_for_blog( $site, $blog_themes );
        }
        else {
            my $themes = _load_all_themes();
            $return_themes = _list_for_website( $site, $themes );
        }
    }
    else {
        my $themes = _load_all_themes();
        $return_themes = _list_for_system($themes);
    }

    return +{
        totalResults => scalar(@$return_themes),
        items        => $return_themes,
    };
}

sub get_openapi_spec {
    +{
        tags        => ['Themes'],
        summary     => 'Retrieve a single theme by its ID',
        description => <<'DESCRIPTION',
- Authentication is required

#### Permissions

- manage_themes
DESCRIPTION
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/theme',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Theme not found.',
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

sub get {
    my ( $app, $endpoint ) = @_;

    return $app->error(403) if !$app->can_do('open_theme_listing_screen');

    my $theme_id = $app->param('theme_id');
    my $theme    = MT::Theme->load($theme_id)
        or return $app->error( $app->translate('Theme not found'), 404 );

    return $theme;
}

sub get_for_site_openapi_spec {
    my $spec = __PACKAGE__->get_openapi_spec();
    $spec->{summary} = 'Retrieve a single theme by its ID for site';
    return $spec;
}

sub get_for_site {
    my ( $app, $endpoint ) = @_;

    return $app->error(403) if !$app->can_do('open_theme_listing_screen');

    my $site;
    my $site_id = $app->param('site_id');
    if ( defined $site_id && $site_id =~ m/^\d+$/ ) {
        $site = $app->model('blog')->load($site_id);
    }
    if ( $site_id && !$site ) {
        return $app->error( $app->translate('Site not found'), 404 );
    }

    my $theme;
    my $theme_id = $app->param('theme_id');
    if (   defined $theme_id
        && $theme_id ne ''
        && ( !$site_id || ( $theme_id eq ( $site->theme_id || '' ) ) ) )
    {
        $theme = MT::Theme->load($theme_id);
    }
    if ( !$theme ) {
        return $app->error( $app->translate('Theme not found'), 404 );
    }

    return $theme;
}

sub apply_openapi_spec {
    +{
        tags        => ['Themes'],
        summary     => 'Apply a theme to site',
        description => <<'DESCRIPTION',
- Authentication is required

#### Permissions

- manage_themes
DESCRIPTION
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                status => { type => 'string' },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Theme not found',
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

sub apply {
    my ( $app, $endpoint ) = @_;

    return $app->error(403) if !$app->can_do('apply_theme');

    my $site_id = $app->param('site_id');
    my $site    = $app->model('blog')->load($site_id)
        or return $app->error( $app->translate('Site not found'), 404 );

    my $theme_id = $app->param('theme_id');
    my $theme    = MT::Theme->load($theme_id)
        or return $app->error( $app->translate('Theme not found'), 404 );

    if ( $site->is_blog && ( $theme->{class} || '' ) eq 'website' ) {
        return $app->error(
            $app->translate('Cannot apply website theme to blog.'), 400 );
    }

    $site->theme_id( $theme->id );
    $site->theme_export_settings(undef);
    $site->save
        or return $app->error(
        $app->translate( 'Changing site theme failed: [_1]', $site->errstr ),
        500
        );
    $site->apply_theme
        or return $app->error(
        $app->translate( 'Applying theme failed: [_1]', $site->errstr ),
        500 );

    return +{ status => 'success' };
}

sub uninstall_openapi_spec {
    +{
        tags        => ['Themes'],
        summary     => 'Uninstall a specified theme from the MT',
        description => <<'DESCRIPTION',
- Authentication is required
- When successful, you can take Themes Resource that was deleted. However, this theme is already removed from the Movable Type. You cannot apply this theme to.

#### Permissions

- manage_themes
DESCRIPTION
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/theme',
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Theme not found.',
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

sub uninstall {
    my ( $app, $endpoint ) = @_;

    return $app->error(403) if !$app->can_do('uninstall_theme_package');

    my $theme_id = $app->param('theme_id');
    my $theme    = MT::Theme->load($theme_id)
        or return $app->error( $app->translate('Theme not found'), 404 );

    if (   $theme->{type} ne 'package'
        || $theme->{protected}
        || !-e $theme->path
        || !-d $theme->path )
    {
        return $app->error( $app->translate('Cannot uninstall this theme.'),
            403 );
    }

    if ( $app->model('blog')->count( { theme_id => $theme->id } ) ) {
        return $app->error(
            $app->translate(
                'Cannot uninstall theme because the theme is in use.'),
            403
        );
    }

    require File::Path;
    File::Path::rmtree( $theme->path )
        or return $app->error(
        $app->translate( 'Failed to uninstall theme: [_1]', $! ), 500 );

    # Clear cache.
    MT::Theme::_unplug_all_themes();

    return $theme;
}

sub _set_default_params_if_all_params_not_set {
    my ( $app, $blog ) = @_;

    my @save_params = qw(
        theme_name    theme_id    theme_author_name theme_author_link
        theme_version theme_class description       include
        output
    );

    for my $param (@save_params) {
        return if defined $app->param($param);
    }

    my $saved_settings    = $blog->theme_export_settings;
    my $saved_core_values = $saved_settings->{core};
    my $default_basename  = [ File::Spec->splitdir( $blog->site_path ) ]->[-1]
        || dirify( $blog->name );
    my %param_default = (
        theme_name => $app->translate( 'Theme from [_1]', $blog->name ),
        theme_id   => $default_basename
        ? 'theme_from_' . $default_basename
        : 'new_theme',
        theme_author_name => '',
        theme_author_link => '',
        theme_version     => '1.0',
    );
    for my $param (@save_params) {
        my $val
            = $saved_core_values->{$param}
            || $param_default{$param}
            || '';
        if ( $param eq 'include' ) {
            if ( ref $val ) {
                $app->multi_param( 'include', @$val );
            }
            else {
                $app->param( 'include', $val );
            }
        }
        else {
            $app->param( $param, ref $val ? $val->[0] : $val );
        }
    }
}

sub _check_params {
    my ( $app, $theme_id, $theme_name, $theme_version ) = @_;

    if ( !defined($theme_id) || $theme_id eq '' ) {
        return $app->error(
            $app->translate( 'A parameter "[_1]" is required.', 'theme_id' ),
            400
        );
    }
    if ( !defined($theme_name) || $theme_name eq '' ) {
        return $app->error(
            $app->translate(
                'A parameter "[_1]" is required.', 'theme_name'
            ),
            400
        );
    }
    if ( !defined($theme_version) || $theme_version eq '' ) {
        return $app->error(
            $app->translate(
                'A parameter "[_1]" is required.',
                'theme_version'
            ),
            400
        );
    }

    if ( $theme_id !~ m/^[a-zA-Z][a-zA-Z0-9_-]*$/ ) {
        return $app->error(
            $app->translate(
                'theme_id may only contain letters, numbers, and the dash or underscore character. The theme_id must begin with a letter.'
            ),
            400
        );
    }

    if ( $theme_version !~ m/^[\w\._-]+$/ ) {
        return $app->error(
            $app->translate(
                'theme_version may only contain letters, numbers, and the dash or underscore character.'
            ),
            400
        );
    }

    my $all_themes = MT::Theme->load_all_themes;
    for my $t ( values %$all_themes ) {
        next if $t->{type} eq 'package' && !$t->{protected};
        if ( $t->id eq $theme_id ) {
            return $app->error(
                $app->translate(
                    'Cannot install new theme with existing (and protected) theme\'s basename: [_1]',
                    $t->id
                ),
                400
            );
        }
    }

    return 1;
}

sub export_openapi_spec {
    +{
        tags        => ['Themes'],
        summary     => "Export site's theme",
        description => <<'DESCRIPTION',
- Authentication is required
- This endpoint will export current theme elements of specified site into theme directory.

#### Permissions

- manage_themes
DESCRIPTION
        responses => {
            200 => {
                description => 'No Errors.',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                status => { type => 'string' },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Site or Theme not found',
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

sub export {
    my ( $app, $endpoint ) = @_;

    return $app->error(403) if !$app->can_do('do_export_theme');

    my $cfg  = $app->config;
    my $blog = $app->blog;

    if ( !( $blog && $blog->id ) ) {
        return $app->error( $app->translate('Site not found'), 404 );
    }

    _set_default_params_if_all_params_not_set( $app, $blog );

    my $theme_id      = $app->param('theme_id');
    my $theme_name    = $app->param('theme_name');
    my $theme_version = $app->param('theme_version');

    return if !_check_params( $app, $theme_id, $theme_name, $theme_version );

    my $fmgr = MT::FileMgr->new('Local');

    ## $output should have 'themedir' or 'zipdownload'.
    my $output = $app->param('output') || 'themedir';

    ## Abort if theme directory is not okey for output.
    my ( $theme_dir, $output_path );
    if ( $output eq 'themedir' ) {

        my @dir_list = $cfg->ThemesDirectory;
        my ($default_dir) = $cfg->default('ThemesDirectory');
        if ( grep $_ eq $default_dir, @dir_list ) {
            @dir_list
                = ( $default_dir, grep( $_ ne $default_dir, @dir_list ) );
        }

        foreach my $dir (@dir_list) {
            my $path = File::Spec->catdir( $dir, $theme_id );
            if ( $fmgr->can_write($dir) ) {
                $theme_dir = $dir;
                last;
            }
        }
        if ( not defined $theme_dir ) {
            if ( scalar(@dir_list) == 1 ) {
                return $app->error(
                    $app->translate(
                        'Themes directory [_1] is not writable.',
                        $dir_list[0],
                    ),
                    403
                );
            }
            else {
                return $app->error(
                    $app->translate(
                        'All themes directories are not writable.'),
                    403
                );
            }
        }
        $output_path = File::Spec->catdir( $theme_dir, $theme_id );

        if ( $fmgr->exists($output_path) ) {
            if ( $app->param('overwrite_yes') ) {
                use File::Path 'rmtree';
                rmtree($output_path);
            }
            else {
                return $app->error(
                    $app->translate(
                        "Export theme folder already exists '[_1]'. You can overwrite an existing theme with 'overwrite_yes=1' parameter, or change the Basename.",
                        $output_path
                    ),
                    409
                );
            }
        }
    }

    ## Pick up settings.
    my $hdlrs = MT->registry('theme_element_handlers');
    my %includes = map { $_ => 1 } ( $app->multi_param('include') );
    my %exporter;
    my $settings = $blog->theme_export_settings || {};
    my $elements = {};

    for my $exporter_id ( keys %$hdlrs ) {
        my $exporter
            = MT->registry(
            theme_element_handlers => $exporter_id => 'exporter' )
            or next;
        $exporter{$exporter_id} = $exporter;
        next unless $includes{$exporter_id};
    }

    ## Build data.
    my $theme_author_name = $app->param('theme_author_name');
    my $theme_author_link = $app->param('theme_author_link');
    my $description       = $app->param('description');
    my $theme_hash        = {
        id    => $theme_id,
        name  => $theme_name,
        label => $theme_name,
        (   $theme_author_name
            ? ( author_name => $theme_author_name )
            : ()
        ),
        author_link => $theme_author_link || '',
        version => $theme_version,
        class => ( $blog->is_blog ? 'blog' : 'website' ),
        description => $description || '',
    };

    for my $exporter_id ( keys %$hdlrs ) {
        next unless $includes{$exporter_id};
        my $exporter = $exporter{$exporter_id};
        next unless $exporter;
        my $code = $exporter->{export};
        if ( !ref $code ) {
            $code = MT->handler_to_coderef($code);
        }
        my $setting
            = exists $settings->{$exporter_id}
            ? $settings->{$exporter_id}
            : undef;
        my $data;
        eval { $data = $code->( $app, $blog, $setting ); };
        return $app->error(
            $app->translate(
                'Error occurred during exporting [_1]: [_2]', $exporter_id,
                $@
            ),
            500
        ) if $@;
        next unless $data;
        $elements->{$exporter_id} = {
            component => $exporter->{component},
            importer  => $exporter_id,
            data      => $data,
        };
    }
    $theme_hash->{elements} = $elements;
    require File::Temp;
    my $parent = MT->config('ExportTempDir') || MT->config('TempDir');
    $fmgr->mkpath($parent) unless -d $parent;
    my $tmproot = File::Temp::tempdir(
        DIR     => $parent,
        CLEANUP => 1
    );
    my $tmpdir = File::Spec->catdir( $tmproot, $theme_id );
    $fmgr->mkpath($tmpdir);
    my $yaml_path = File::Spec->catfile( $tmpdir, 'theme.yaml' );

    for my $hdlr ( keys %$hdlrs ) {
        my $exporter
            = MT->registry( theme_element_handlers => $hdlr => 'exporter' );
        next unless $exporter;
        my $code = $exporter->{finalize};
        next unless $code;
        if ( !ref $code ) {
            $code = MT->handler_to_coderef($code);
        }
        my $finalize;
        eval {
            $finalize = $code->(
                $app, $blog, $theme_hash, $tmpdir, $settings->{$hdlr}
            );
        };
        if ($@) {
            return $app->error(
                $app->translate(
                    'Error occurred during finalizing [_1]: [_2]', $hdlr,
                    "$@",
                ),
                500
            );
        }
        if ( !defined $finalize ) {
            return $app->error(
                $app->translate(
                    'Error occurred during finalizing [_1]: [_2]', $hdlr,
                    $app->errstr,
                ),
                500
            );
        }
    }

    require MT::Util::YAML;
    $fmgr->put_data( MT::Util::YAML::Dump($theme_hash), $yaml_path )
        or return $app->error(
        $app->translate(
            'Error occurred while publishing theme: [_1]',
            $fmgr->errstr,
        ),
        500
        );

    my $printed;
    if ( $output eq 'themedir' ) {
        require File::Copy::Recursive;
        my $num = File::Copy::Recursive::dircopy( $tmpdir, $output_path );
        return $app->error(
            $app->translate(
                'Themes Directory [_1] is not writable.', $theme_dir,
            ),
            403
        ) unless $num;
    }
    elsif ( $output =~ /^download/ ) {
        my ($arctype) = $output =~ /\.(.*)$/;
        my $arc_info = MT->registry( archivers => $arctype )
            or return $app->error(
            $app->translate( "Unknown archiver type: [_1]", $arctype ), 400 );
        require MT::Util::Archive;
        my $arcfile = File::Temp::tempnam( $tmproot, $theme_id );
        my $arc = MT::Util::Archive->new( $arctype, $arcfile )
            or return $app->error(
            $app->translate(
                "Cannot load archiver : " . MT::Util::Archive->errstr
            ),
            500
            );
        $arc->add_tree($tmproot);
        $arc->close;
        my $newfilename = $theme_id;
        $newfilename .= $theme_version if $theme_version;
        $newfilename .= '.' . $arc_info->{extension};
        open my $fh, "<", $arcfile or die "Couldn't open $arcfile: $!";
        binmode $fh;
        $app->{no_print_body} = 1;
        $app->set_header(
            "Content-Disposition" => "attachment; filename=$newfilename" );
        $app->send_http_header( $arc_info->{mimetype} );
        my $data;

        while ( read $fh, my ($chunk), 8192 ) {
            $data .= $chunk;
        }
        close $fh;
        $app->print($data);
        $printed = 1;
    }

    my @core_params = qw(
        theme_name    theme_id    theme_author_name theme_author_link
        theme_version theme_class description       include
        output
    );
    for my $param (@core_params) {
        $settings->{core}{$param} = [ $app->multi_param($param) ];
    }
    $blog->theme_export_settings($settings);
    $blog->save
        or return $app->error(
        $app->translate(
            'Failed to save theme export info: [_1]',
            $blog->errstr
        ),
        500
        );
    ## if finished with no errors, should return to theme export screen again.
    return if $printed;

    return +{ status => 'success' };
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::v2::Theme - Movable Type class for endpoint definitions about the MT::Theme.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
