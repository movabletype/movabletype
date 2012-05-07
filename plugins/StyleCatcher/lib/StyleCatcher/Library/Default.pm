# Movable Type (r) Open Source (C) 2005-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package StyleCatcher::Library::Default;
use strict;
use warnings;
use base qw( StyleCatcher::Library );
use StyleCatcher::Util;


# pulls a list of themes available from a particular url
sub fetch_themes {
    my $self = shift;

    my $static_webpath = MT->app->static_path;
    my $support_url    = MT->app->support_directory_url;
    my $url = $self->url;
    $url =~ s/{{static}}/$static_webpath/i;
    $url =~ s/{{support}}/$support_url/i;
    if ( $url =~ m!^/! ) {
        $url = MT->app->base . $url;
    }

    my $data    = {};

# If we have a url then we're specifying a specific theme (css) or repo (html)
# Pick up the file (html with <link>s or a css file with metadata)
    my $user_agent = MT->new_ua;
    my $request    = HTTP::Request->new( GET => $url );
    my $response   = $user_agent->request($request);

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
                $val  =~ s/^['"]|['"]$//g;
                next if $name eq '/';
                $attr{ lc($name) } = $val;
            }
            next unless lc $attr{rel}  eq 'theme';
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

1;
