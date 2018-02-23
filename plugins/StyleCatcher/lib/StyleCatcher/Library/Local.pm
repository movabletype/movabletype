# Movable Type (r) (C) 2005-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package StyleCatcher::Library::Local;
use strict;
use warnings;
use base qw( StyleCatcher::Library );
use MT;
use StyleCatcher::Util;
use File::Spec;
use HTTP::Response;
use HTML::HeadParser;
use File::Basename qw( dirname );

# pulls a list of themes available from a particular url
sub fetch_themes {
    my $self         = shift;
    my $data         = {};
    my $path         = $self->url;
    my $static_path  = MT->app->static_file_path;
    my $support_path = MT->app->support_directory_path;
    $static_path  .= '/' unless $static_path =~ m!/$!;
    $support_path .= '/' unless $support_path =~ m!/$!;
    $path =~ s/\{\{static}}/$static_path/i;
    $path =~ s/\{\{support}}/$support_path/i;
    $path
        =~ s/\{\{theme_static}}/MT::Theme::static_file_path_from_id($self->key)/ie;

    my $static_webpath = MT->app->static_path;
    my $support_url    = MT->app->support_directory_url;
    $static_webpath .= '/' unless $static_webpath =~ m!/$!;
    $support_url    .= '/' unless $support_url =~ m!/$!;

    my $url = $self->url;
    $url =~ s/\{\{static}}/$static_webpath/i;
    $url =~ s/\{\{support}}/$support_url/i;
    $url
        =~ s/\{\{theme_static}}/MT::Theme::static_file_url_from_id($self->key)/ie;
    if ( $url =~ m!^/! ) {
        $url = MT->app->base . $url;
    }

    my $basedir = dirname($path);
    my $fmgr    = file_mgr();
    my $content = $fmgr->get_data($path)
        or die MT->translate( "Failed to load StyleCatcher Library: [_1]",
        $fmgr->errstr );
    my $hp = HTML::HeadParser->new;
    $hp->parse($content);
    $hp->eof;
    my $response = HTTP::Response->new( 200, 'OK', $hp->header, $content );
    my $type = $path =~ /\.css$/i ? 'css' : 'html';

    if ( $type eq 'css' ) {
        $data->{auto}{path} = $path;
        my $theme = metadata_for_theme(
            path => $path,
            tags => ['collection:auto'],
        );
        $data->{themes} = [$theme];
    }
    else {
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
            my $path = File::Spec->catfile( $basedir, $css );

            # Fix for relative theme locations
            if ( $css !~ m!^https?://! ) {
                my $new_css = $url;
                $new_css =~ s!/[a-z0-9_-]+\.[a-z]+?$|/$!/!;
                $new_css .= $css;
                $css = $new_css;
            }
            push @repo_themes, [ $css, $path ];
        }

        my $themes = [];
        for my $repo_theme (@repo_themes) {
            my $theme = metadata_for_theme(
                url  => $repo_theme->[0],
                path => $repo_theme->[1],
            );
            push @$themes, $theme if $theme;
        }
        $data->{themes} = $themes;
        if ( $data->{repo}{display_name} = $response->headers->{'title'} ) {
            $data->{repo}{name}
                = MT::Util::dirify( $data->{repo}{display_name} );
        }
        else {
            $data->{repo}{display_name} = $path;
            $data->{repo}{name}         = MT::Util::dirify($path);
        }
        $data->{repo}{path} = $path;
    }
    $data;
}

sub download_theme {

    # No task here. Just echo back the given URL.
    return $_[1];
}

1;
