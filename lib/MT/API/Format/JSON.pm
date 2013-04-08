package MT::API::Format::JSON;

use strict;
use warnings;

use MT::Util;

sub serialize {
    MT::Util::to_json( $_[0], { convert_blessed => 1, ascii => 1 } );
}

sub unserialize {
    MT::Util::from_json( $_[0] );
}

1;
