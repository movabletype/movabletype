package FormattedText;

use strict;
use warnings;

our @EXPORT = qw( plugin translate );
use base qw(Exporter);

sub translate {
    MT->component('FormattedText')->translate( $_[0] );
}

sub plugin {
    MT->component('FormattedText');
}

1;
