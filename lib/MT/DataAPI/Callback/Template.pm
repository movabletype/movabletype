# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Callback::Template;

use strict;
use warnings;

sub save_filter {
    my ( $eh, $app, $obj, $orig ) = @_;

    my @not_empty_columns = qw( name type );
    for my $col (@not_empty_columns) {
        if ( !defined( $obj->$col ) || $obj->$col eq '' ) {
            return $app->errtrans( 'A parameter "[_1]" is required.', $col );
        }
    }

    if ( !$obj->id ) {
        if ($obj->blog_id
            && !(
                grep { $obj->type eq $_ }
                qw/ index archive individual page category custom /
            )
            )
        {
            return $app->errtrans( 'Invalid type: [_1]', $obj->type );
        }

        if (  !$obj->blog_id
            && $obj->type ne 'custom' )
        {
            return $app->errtrans( 'Invalid type: [_1]', $obj->type );
        }
    }

    if ( $obj->type eq 'index'
        && ( !defined( $obj->outfile ) || $obj->outfile eq '' ) )
    {
        return $app->errtrans('A parameter "outputFile" is required.');
    }

    return 1;
}

1;

__END__

=head1 NAME

MT::DataAPI::Callback::Template - Movable Type class for Data API's callbacks about the MT::Template.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
