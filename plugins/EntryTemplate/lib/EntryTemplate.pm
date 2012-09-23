package EntryTemplate;

use strict;
use warnings;

our @EXPORT = qw( plugin translate );
use base qw(Exporter);

sub translate {
    MT->component('EntryTemplate')->translate( $_[0] );
}

sub plugin {
    MT->component('EntryTemplate');
}

1;
