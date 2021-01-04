# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package FormattedText::DataAPI::Callback::FormattedText;

use strict;
use warnings;

sub save_filter {
    my ( $eh, $app, $obj, $orig ) = @_;

    if ( !defined( $obj->label ) || $obj->label eq '' ) {
        return $app->errtrans( 'A parameter "[_1]" is required.', 'label' );
    }

    if ($app->model('formatted_text')->exist(
            {   $obj->id ? ( id => { not => $obj->id } ) : (),
                blog_id => $obj->blog_id,
                label   => $obj->label,
            }
        )
        )
    {
        return $app->errtrans(
            'The boilerplate \'[_1]\' is already in use in this site.',
            $obj->label, );
    }

    return 1;
}

1;

__END__

=head1 NAME

FormattedText::DataAPI::Callback::FormattedText - Movable Type class for Data API's callbacks
about the FormattedText::FormattedText.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
