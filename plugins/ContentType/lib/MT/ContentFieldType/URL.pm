package MT::ContentFieldType::URL;
use strict;
use warnings;

use MT::Util ();

sub ss_validator {
    my ( $app, $id ) = @_;
    my $q   = $app->param;
    my $str = $q->param( 'content-field-' . $id );
    if ( MT::Util::is_url($str) ) {
        return $str;
    }
    else {
        my $err = MT->translate( "Invalid URL: '[_1]'", $str );
        return $app->error($err) if $err && $app;
    }
}

1;

