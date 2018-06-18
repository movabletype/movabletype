# Movable Type (r) (C) 2007-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Template::Tags::Common;

use strict;
use warnings;

use MT::Util qw( encode_html remove_html spam_protect );

sub hdlr_author_link {
    my ( $ctx, $args, $cond, $a, $archive_type ) = @_;

    my $type = $args->{type} || '';

    my $displayname = encode_html( remove_html( $a->nickname || '' ) );
    my $show_email = $args->{show_email} ? 1 : 0;
    my $show_url;
    $show_url = 1 unless exists $args->{show_url} && !$args->{show_url};

    # Open the link in a new window if requested (with new_window="1").
    my $target = $args->{new_window} ? ' target="_blank"' : '';
    unless ($type) {
        if ( $show_url && $a->url && ( $displayname ne '' ) ) {
            $type = 'url';
        }
        elsif ( $show_email && $a->email && ( $displayname ne '' ) ) {
            $type = 'email';
        }
    }
    if ( $type eq 'url' ) {
        if ( $a->url && ( $displayname ne '' ) ) {

            # Add vcard properties to link if requested (with hcard="1")
            my $hcard = $args->{show_hcard} ? ' class="fn url"' : '';
            return sprintf qq(<a%s href="%s"%s>%s</a>), $hcard,
                encode_html( $a->url ), $target, $displayname;
        }
    }
    elsif ( $type eq 'email' ) {
        if ( $a->email && ( $displayname ne '' ) ) {

            # Add vcard properties to email if requested (with hcard="1")
            my $hcard = $args->{show_hcard} ? ' class="fn email"' : '';
            my $str = "mailto:" . encode_html( $a->email );
            $str = spam_protect($str) if $args->{'spam_protect'};
            return sprintf qq(<a%s href="%s">%s</a>), $hcard, $str,
                $displayname;
        }
    }
    elsif ( $type eq 'archive' && $archive_type ) {
        require MT::Author;
        if ( $a->type == MT::Author::AUTHOR() ) {
            local $ctx->{__stash}{author} = $a;
            local $ctx->{current_archive_type} = undef;
            if (my $link = $ctx->invoke_handler(
                    'archivelink', { type => $archive_type }, $cond
                )
                )
            {
                return sprintf qq{<a href="%s"%s>%s</a>}, $link, $target,
                    $displayname;
            }
        }
    }
    return $displayname;
}

1;
