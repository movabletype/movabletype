package MT::Plugin::Diagnosis::Util;
use strict;
use warnings;
use utf8;
use base 'Exporter';

our @EXPORT_OK = qw( commify );

sub commify {
    my $text = reverse $_[0];
    $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
    return scalar reverse $text;
}

1;
