# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::v7::Theme;

use strict;
use warnings;

use File::Spec;

use MT::FileMgr;
use MT::Theme;
use MT::Util qw( dirify );
use MT::CMS::Theme;
use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub _set_default_params {
    my ( $app, $blog ) = @_;

    my @save_params = qw(
        theme_name    theme_id    theme_author_name theme_author_link
        theme_version theme_class description       include
        output        include_all
    );

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
        ( $saved_settings ? () : ( include_all => 1 ) ),
    );

    for my $param (@save_params) {
        next if defined $app->param($param);
        my $val
            = $saved_core_values->{$param}
            || $param_default{$param}
            || '';
        if ( $param eq 'include' ) {
            if ( ref $val ) {
                $app->multi_param( 'include', @$val );
            }
            else {
                my $hdlrs = MT->registry('theme_element_handlers');
                my @exporter_ids;
                for my $hdlr ( keys %$hdlrs ) {
                    my $exporter = MT->registry( theme_element_handlers => $hdlr => 'exporter' );
                    next unless $exporter;

                    my $cond = $exporter->{condition};
                    $cond = MT->handler_to_coderef($cond) unless ref $cond;
                    next if defined $cond && !$cond->($blog);

                    push @exporter_ids, $hdlr;
                }
                $app->multi_param( 'include', @exporter_ids );
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
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            theme_name => {
                                type        => 'string',
                                description => "If not specified, the default value is dynamically generated as 'Theme from <SiteName>', where <SiteName> represents the name of the site."
                            },
                            theme_id => {
                                type        => 'string',
                                description => 'Can only contain letters (a-z, A-Z), numbers (0-9), dashes (-), and underscores (_). Must start with a letter.',
                            },
                            theme_version => {
                                type    => 'string',
                                default => '1.0'
                            },
                            theme_author_name => { type => 'string' },
                            theme_author_link => { type => 'string' },
                            description       => { type => 'string' },
                            include           => {
                                type  => 'array',
                                items => {
                                    type => 'string',
                                    enum => [
                                        'default_folders',
                                        'default_categories',
                                        'default_category_sets',
                                        'default_content_types',
                                        'template_set',
                                        'blog_static_files',
                                    ],
                                },
                                example => [ 'template_set' ],
                                description => "Options for inclusion in the export target can be set. The values defined in the enum are valid options, but they may be considered invalid if they do not meet the system's conditions.",
                            },
                            include_all => {
                                type => 'integer',
                                enum => [0, 1],
                                description => "If '1' is specified, all options will be included in the export target.",
                            },
                            output => {
                                type        => 'string',
                                enum        => ['themedir', 'download.zip'],
                                default     => 'themedir',
                                description => "If 'themedir' is specified, the theme will be installed in the theme directory. If 'download.zip' is specified, the theme will be downloaded as a ZIP archive."
                            },
                            overwrite_yes => {
                                type        => 'integer',
                                enum        => [0, 1],
                                description => "If '1' is specified, an existing theme can be overwritten, or the Basename can be changed. This is valid only when 'themedir' is selected as the output format."
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

    _set_default_params( $app, $blog );

    my $theme_id      = $app->param('theme_id');
    my $theme_name    = $app->param('theme_name');
    my $theme_version = $app->param('theme_version');

    return if !_check_params( $app, $theme_id, $theme_name, $theme_version );

    $theme_id = dirify($theme_id);

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
        unshift @dir_list, $cfg->UserThemesDirectory if $cfg->UserTHemesDirectory;

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
    my %includes = map { $_ => 1 } $app->multi_param('include');
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

    my $include_all = $app->param('include_all');
    for my $exporter_id ( keys %$hdlrs ) {
        next if !$include_all && !$includes{$exporter_id};
        my $exporter = $exporter{$exporter_id};
        next unless $exporter;
        my $code = $exporter->{export};
        if ( !ref $code ) {
            $code = MT->handler_to_coderef($code);
        }
        delete $settings->{$exporter_id} if $include_all;
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
