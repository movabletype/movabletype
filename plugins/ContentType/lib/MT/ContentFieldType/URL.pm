package MT::ContentFieldType::URL;
use strict;
use warnings;

use MT;
use MT::Util ();

sub ss_validator {
    my ( $app, $field_data ) = @_;
    my $str = $app->param( 'content-field-' . $field_data->{id} );

    # TODO: should check "require" option here.
    if ( !defined $str || $str eq '' || MT::Util::is_url($str) ) {
        return $str;
    }
    else {
        my $err = MT->translate( "Invalid URL: '[_1]'", $str );
        return $app->error($err) if $err && $app;
    }
}

1;

