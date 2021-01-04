# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Util::ContentType;
use strict;
use warnings;

sub get_content_types {
    my ( $arg, $blog_terms ) = @_;
    my @ct;
    my $class = MT->model('content_type');
    $blog_terms ||= {};

    if ( $arg =~ /^\d+$/ ) {
        my $ct = $class->load($arg);
        push @ct, $ct if $ct;
    }
    unless (@ct) {
        @ct = $class->load( { unique_id => $arg, %{$blog_terms} } );
    }
    unless (@ct) {
        @ct = $class->load( { name => $arg, %{$blog_terms} } );
    }

    @ct;
}

1;

