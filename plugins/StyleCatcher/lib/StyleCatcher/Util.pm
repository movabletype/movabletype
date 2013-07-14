# Movable Type (r) Open Source (C) 2005-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package StyleCatcher::Util;
use strict;
use warnings;
use MT;
use base qw( Exporter );
use File::Basename qw( basename dirname );
use MT::Util qw( remove_html decode_html );

our @EXPORT = qw( metadata_for_theme file_mgr files_from_response );

sub metadata_for_theme {
    my %param = @_;
    my ( $url, $path, $tags, $default_metadata )
        = @param{qw( url path tags metadata )};

    # Update a path, if present, from a theme directory to the real full
    # stylesheet path.
    if ( $path && -d $path ) {
        $path =~ s{ / \z }{}xms;
    FILESTEM: for my $filestem ( basename($path), "screen", "style" ) {
            my $full_path = File::Spec->catfile( $path, "$filestem.css" );
            if ( $full_path && -f $full_path ) {
                $path = $param{path} = $full_path;

                $url =~ s{ / \z }{}xms;
                $url = $param{url} = "$url/$filestem.css";

                last FILESTEM;
            }
        }
    }

    my %theme      = theme_for_url(%param);
    my %metadata   = metadata_for_stylesheet( %param, %theme );
    my %thumbnails = thumbnails_for_theme( %param, metadata => \%metadata );

    my $data = {
        name        => $theme{id},
        description => $metadata{description} || q{},
        title       => $metadata{title}
            || MT->component('StyleCatcher')->translate('(Untitled)'),
        url        => $url,
        imageSmall => $thumbnails{thumbnail},
        imageBig   => $thumbnails{thumbnail_large},
        layouts    => $metadata{layouts} || q{},
        sort       => lc( $metadata{title} || $theme{id} || q{} ),
        tags => $tags || [],
        blogs              => [],
        author             => $metadata{author},
        author_url         => $metadata{author_url},
        template_set       => $metadata{template_set},
        author_affiliation => $metadata{author_affiliation} || q{},
    };
    $data;
}

sub metadata_for_stylesheet {
    my %param = @_;
    my ($stylesheet) = @param{qw( stylesheet )};

    # Pick up the metadata from the css
    my @css_lines = split( /\r?\n/, $stylesheet || '' );
    my $commented = 0;
    my @comments;
    for my $line (@css_lines) {
        my $pos;
        $pos = index( $line, "/*" );
        unless ( $pos == -1 ) {
            $line = substr( $line, $pos + 2 );
            $commented = 1;
        }
        if ($commented) {
            $pos = index( $line, "*/" );
            unless ( $pos == -1 ) {
                $line = substr( $line, 0, $pos );
                $commented = 0;
            }
            push @comments, $line;
        }
    }

    my %metadata;

    # Trim me white space, yarr
    for my $comment (@comments) {

        # Strip any null bytes
        $comment =~ tr/\x00//d;
        $comment =~ s/^\s+|\s+$//g;

        my ( $key, $value ) = split( /:/, $comment, 2 ) or next;
        next unless defined $value;
        $value =~ s/^\s+//;
        $metadata{ lc $key } = $value;
    }

    my %field_map = (
        title        => [ 'name',         'theme name' ],
        author       => [ 'designer',     'author' ],
        author_url   => [ 'designer_url', 'author_url', 'author uri' ],
        template_set => [ 'template_set', 'template' ],
        description => ['description'],
    );
    while ( my ( $best_name, $possible_names ) = each %field_map ) {
        ( $metadata{$best_name} )
            = grep {defined} delete @metadata{@$possible_names}, q{};

        # TODO: do html mashing later
        $metadata{$best_name} = decode_html(
            remove_html( Encode::decode_utf8( $metadata{$best_name} ) ) );
    }

    return %metadata;
}

sub theme_for_url {
    my %param = @_;
    my ( $url, $path, $baseurl, $basepath )
        = @param{qw( url path baseurl basepath )};

    my %theme;
    if ( $path && -e $path ) {
        $theme{stylesheet} = file_mgr()->get_data($path);
        $theme{id}         = basename( dirname($path) );
    }
    elsif ($url) {
        my $user_agent = MT->new_ua;
        my $response   = $user_agent->get($url);
        return if !$response->is_success();
        $theme{stylesheet} = $response->content;

        my $id = $url;
        $id =~ s{ / (?:screen|style) \.css \z }{}xms;
        $id =~ s/.*[\\\/]//;
        $theme{id} = $id;
    }

    return %theme;
}

sub thumbnails_for_theme {
    my %param = @_;
    my ( $url, $path, $metadata ) = @param{qw( url path metadata )};

    my %thumbnails;
THUMB: for my $thumb (qw( thumbnail thumbnail_large )) {
        $thumbnails{$thumb} = $metadata->{$thumb};
        next THUMB if $thumbnails{$thumb};

        my $thumb_filename = $thumb;
        $thumb_filename =~ tr/_/-/;
        $thumb_filename .= '.gif';

        require URI;
        if ($path) {
            my ( $volume, $dir, $theme_filename )
                = File::Spec->splitpath($path);
            my $thumb_path
                = File::Spec->catpath( $volume, $dir, $thumb_filename );
            my $url_uri = URI->new_abs( $thumb_filename, $url );
            $thumbnails{$thumb} = $url_uri->as_string();
        }
        elsif ($url) {
            my $url_uri = URI->new_abs( $thumb_filename, $url );
            my $thumb_url = $url_uri->as_string();
            $thumbnails{$thumb} = $thumb_url;
        }
    }

    return %thumbnails;
}

sub files_from_response {
    my ( $res, %param ) = @_;

    my $extensions
        = $param{css}
        ? qr{ (?:gif|jpe?g|png|css) }xms
        : qr{ (?:gif|jpe?g|png)     }xms;

    my $stylesheet = $res->content;
    $stylesheet =~ s!/\*.*?\*/!!gs;    # strip all comments first
    my @images = $stylesheet =~ m{
        \b url\( \s*                          # opening url() reference
        ['"]?
        ( [\w\.\-/]+\.$extensions )  # a filename ending in an image extension
        ['"]?
        \s* \)                                # close of url() reference
    }xmsgi;

    return @images;
}

sub file_mgr {
    require MT::FileMgr;
    my $filemgr = MT::FileMgr->new('Local')
        or die MT::FileMgr->errstr;
    $filemgr;
}

sub load_meta_fields {

    # Load blog_meta
    my $blog = MT->model('blog');
    $blog->install_meta(
        {   column_defs => {
                'current_style'  => 'string meta',
            }
        }
    );

    # Load website_meta
    my $website = MT->model('website');
    $website->install_meta(
        {   column_defs => {
                'current_style'  => 'string meta',
            }
        }
    );
}

1;
