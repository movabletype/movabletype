# Movable Type (r) (C) 2001-2020 Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ContentFieldType::TextLabel;
use strict;
use warnings;

use MT::Util qw( encode_html );

sub field_html_params {
    my ( $app, $field_data ) = @_;

    my $text = encode_html( $field_data->{options}{text} );
    $text =~ s!(https?://\S+)!<a href="$1" target="_blank" >$1</a>!g;
    return { text => $text, };
}

sub html {
    my $prop = shift;
    my ( $content_data, $app, $load_options ) = @_;
    return '';
}

sub tag_handler {
    my ( $ctx, $args, $cond, $field_data, $value ) = @_;
    return '';
}

sub feed_value_handler {
    my ( $app, $field_data, $values ) = @_;
    return '';
}

sub preview_handler {
    my ( $field_data, $values, $content_data ) = @_;
    return '';
}

1;

