# Movable Type (r) (C) 2005-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package StyleCatcher::Library::Default;
use strict;
use warnings;
use base qw( StyleCatcher::Library );
use StyleCatcher::Util;
use MT::Util qw( caturl );

# pulls a list of themes available from a particular url
sub fetch_themes {
    my $self = shift;
    my $url  = shift;

    my $static_webpath = MT->app->static_path;
    my $support_url    = MT->app->support_directory_url;
    $url ||= $self->url || '';
    $url =~ s/\{\{static}}/$static_webpath/i;
    $url =~ s/\{\{support}}/$support_url/i;
    $url
        =~ s/\{\{theme_static}}/MT::Theme::static_file_url_from_id($self->key)/ie;
    if ( $url =~ m!^/! ) {
        $url = MT->app->base . $url;
    }

    my $data = {};

# If we have a url then we're specifying a specific theme (css) or repo (html)
# Pick up the file (html with <link>s or a css file with metadata)
    my $user_agent = MT->new_ua;

    # Do not verify SSL certificate because accessing to oneself.
    $user_agent->ssl_opts( verify_hostname => 0 );

    my $request = HTTP::Request->new( GET => $url );
    my $response = $user_agent->request($request);

    # Make a repo if you've got a ton of links or an automatic entry if
    # you're a css file
    my $type = $response->headers->{'content-type'};
    $type = shift @$type if ref $type eq 'ARRAY';
    if ( $type =~ m!^text/css! ) {
        $data->{auto}{url} = $url;
        my $theme = metadata_for_theme(
            url  => $url,
            tags => ['collection:auto'],
        );
        $data->{themes} = [$theme];
    }
    elsif ( $type =~ m!^text/html! ) {
        my @repo_themes;
        for my $link (
            ref( $response->headers->{'link'} ) eq 'ARRAY'
            ? @{ $response->headers->{'link'} }
            : $response->headers->{'link'}
            )
        {
            my ( $css, @parsed_link ) = split( /;/, $link );
            $css =~ s/[<>]//g;
            my %attr;
            foreach (@parsed_link) {
                my ( $name, $val ) = split /=/, $_, 2;
                $name =~ s/^ //;
                $val =~ s/^['"]|['"]$//g;
                next if $name eq '/';
                $attr{ lc($name) } = $val;
            }
            next unless lc $attr{rel} eq 'theme';
            next unless lc $attr{type} eq 'text/x-theme';

            # Fix for relative theme locations
            if ( $css !~ m!^https?://! ) {
                my $new_css = $url;
                $new_css =~ s!/[a-z0-9_-]+\.[a-z]+?$|/$!/!;
                $new_css .= $css;
                $css = $new_css;
            }
            push @repo_themes, $css;
        }

        my $themes = [];
        for my $repo_theme (@repo_themes) {
            my $theme = metadata_for_theme( url => $repo_theme, );
            push @$themes, $theme if $theme;
        }
        $data->{themes} = $themes;
        if ( $data->{repo}{display_name} = $response->headers->{'title'} ) {
            $data->{repo}{name}
                = MT::Util::dirify( $data->{repo}{display_name} );
        }
        else {
            $data->{repo}{display_name} = $url;
            $data->{repo}{name}         = MT::Util::dirify($url);
        }
        $data->{repo}{url} = $url;
    }
    else {
        return $self->error( $self->translate( 'Invalid URL: [_1]', $url ) );
    }

    $data;
}

sub download_theme {
    my $self = shift;
    my ($url) = @_;

    my $support_path = MT->app->support_directory_path;
    my $themeroot    = File::Spec->catdir( $support_path, 'themes' );
    my $ua           = MT->new_ua( { max_size => 500_000 } );

    # Do not verify SSL certificate because accessing to oneself.
    $ua->ssl_opts( verify_hostname => 0 );

    my $filemgr = file_mgr()
        or return;

    my @url                 = split( /\//, $url );
    my $stylesheet_filename = pop @url;
    my $theme_url           = join( q{/}, @url ) . '/';

    my ( $basename, $extension ) = split /\./, $stylesheet_filename;
    if ( $basename eq 'screen' || $basename eq 'style' ) {
        $basename = $url[-1];
    }

    # Pick up the stylesheet
    my $stylesheet_res = $ua->get($url);

    my @images = files_from_response( $stylesheet_res, css => 1 );

    my $theme_path = File::Spec->catdir( $themeroot, $basename );
    if ( !$filemgr->mkpath($theme_path) ) {
        my $error = $self->translate(
            "Could not create [_1] folder - Check that your 'themes' folder is webserver-writable.",
            $basename
        );
        return $self->error($error);
    }

    $filemgr->put_data( $stylesheet_res->content,
        File::Spec->catfile( $theme_path, $basename . '.css' ) );

    # Pick up the images we parsed earlier and write them to the theme folder
    my %got_files;
    my @files = ( 'thumbnail.gif', 'thumbnail-large.gif', @images );
FILE: while ( my $rel_url = shift @files ) {

        # Is this safe to get?
        require URI;
        my $full_url = URI->new_abs( $rel_url, $theme_url );
        next FILE if !$full_url;
        my $url = $full_url->as_string();
        next FILE if $url !~ m{ \A \Q$theme_url\E }xms;

        next FILE if $got_files{$url};
        $got_files{$url} = 1;
        my $res = $ua->get($url);

      # Skip files that don't download; we were accidentally doing so already.
        next FILE if !$res->is_success();

        my $canon_rel_url  = URI->new($rel_url)->rel($theme_url);
        my @image_path     = split /\//, $canon_rel_url->as_string();
        my $image_filename = pop @image_path;

        my $image_path = File::Spec->catdir( $theme_path, @image_path );
        if (   !$filemgr->exists($image_path)
            && !$filemgr->mkpath($image_path) )
        {
            my $error = $self->translate(
                "Could not create [_1] folder - Check that your 'themes' folder is webserver-writable.",
                $basename
            );
            return $self->error($error);
        }

        my $image_full_path
            = File::Spec->catfile( $image_path, $image_filename );
        $filemgr->put_data( $res->content, $image_full_path, 'upload' )
            or return $self->error( $filemgr->errstr );

        if ( $image_filename =~ m{ \.css \z }xmsi ) {
            my @new_files = files_from_response( $res, css => 0 );

            # Schedule these as full URLs so relative references aren't
            # misabsolved relative to the theme directory.
            @new_files = map {
                my $uri = URI->new_abs( $_, $url );
                $uri ? $uri->as_string() : ();
            } @new_files;
            push @files, @new_files;
        }
    }

    return caturl( MT->app->support_directory_url,
        'themes', $basename, "$basename.css" );
}

1;
