# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Template::Tags::Common;

use strict;
use warnings;

use MT::Util qw( encode_html remove_html spam_protect );

sub hdlr_author_link {
    my ( $ctx, $args, $cond, $a ) = @_;

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
    return $displayname;
}

=head2 TextFormat

The function tag which outputs the text format of the data in the current context.

=cut

sub _hdlr_text_format {
    my ( $ctx, $args, $cond ) = @_;

    my $tag_name = $ctx->stash('tag');
    $tag_name = 'mt' . $tag_name unless $tag_name =~ m/^MT/i;

    if (my $field_data = $ctx->stash('content_field_data')) {
        return $ctx->error( MT->translate("You used an '[_1]' tag outside of the context of a 'Multi Line Text' field.", $tag_name) )
            if $field_data->{type} ne 'multi_line_text';
        my $content_data = $ctx->stash('content')
            or return $ctx->_no_content_error;
        my $convert_breaks = MT::Serialize->unserialize( $content_data->convert_breaks );
        return $$convert_breaks->{ $field_data->{id} };
    }
    elsif (my $entry = $ctx->stash('entry')) {
        my $convert_breaks = $entry->convert_breaks;
        if (!defined($convert_breaks) && (my $blog = $ctx->stash('blog'))) {
            $convert_breaks = $blog->convert_paras;
        }
        $convert_breaks = '__default__' if !defined($convert_breaks) || $convert_breaks eq '1';
        return $convert_breaks;
    }
    else {
        return $ctx->error( MT->translate("You used an '[_1]' tag outside of the context of the correct content; ", $tag_name) );
    }
}

1;
