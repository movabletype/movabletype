package Params::Validate::Constants;

use strict;
use warnings;

our @ISA = 'Exporter';

our @EXPORT = qw(
    SCALAR
    ARRAYREF
    HASHREF
    CODEREF
    GLOB
    GLOBREF
    SCALARREF
    HANDLE
    BOOLEAN
    UNDEF
    OBJECT
    UNKNOWN
);

sub SCALAR ()    { 1 }
sub ARRAYREF ()  { 2 }
sub HASHREF ()   { 4 }
sub CODEREF ()   { 8 }
sub GLOB ()      { 16 }
sub GLOBREF ()   { 32 }
sub SCALARREF () { 64 }
sub UNKNOWN ()   { 128 }
sub UNDEF ()     { 256 }
sub OBJECT ()    { 512 }

sub HANDLE ()  { 16 | 32 }
sub BOOLEAN () { 1 | 256 }

1;
