package URI::mms;

use strict;
use warnings;

our $VERSION = '5.17';

use parent 'URI::http';

sub default_port { 1755 }

1;
