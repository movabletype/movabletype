package MT::DataAPI::Format::JSON;

use strict;
use warnings;

use MT::Util;

sub serialize {
    my $s = MT::Util::to_json( $_[0], { convert_blessed => 1, ascii => 1 } );
    $s =~ s/([<>\+])/sprintf("\\u%04x",ord($1))/eg;
    $s;
}

sub unserialize {
    MT::Util::from_json( $_[0] );
}

1;
