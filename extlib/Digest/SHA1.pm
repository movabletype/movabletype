package Digest::SHA1;

use strict;
use warnings;

use Digest::SHA qw(sha1 sha1_hex sha1_base64);
use base 'Exporter';
our @EXPORT_OK = qw(sha1 sha1_hex sha1_base64);

1;