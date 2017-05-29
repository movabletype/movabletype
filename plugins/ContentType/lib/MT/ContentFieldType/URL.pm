package MT::ContentFieldType::URL;
use strict;
use warnings;

use MT;
use MT::Util ();

sub ss_validator {
    my ( $app, $field_data ) = @_;
    my $str = $app->param( 'content-field-' . $field_data->{id} );

    # TODO: should check "require" option here.
    unless ( !defined $str || $str eq '' || MT::Util::is_url($str) ) {
        return $app->translate( "Invalid URL: '[_1]'", $str );
    }

    undef;
}

1;

