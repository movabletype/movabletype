#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib qw( extlib lib t/lib );


use MT::Test qw( :app :db );
use MT::Test::Permission;
use Test::More;
use MT;

my $mt = MT->instance;


note('FormattedText::FormattedText::validate');

my @suite = (
    {   values => {
            label       => 'Label',
            text        => 'Text',
            description => 'Description',
        },
        is_valid => 1,
    },
    {   values => {
            text        => 'Text',
            description => 'Description',
        },
        is_valid => undef,
    },
    {   values => {
            label       => 'Label',
            description => 'Description',
        },
        is_valid => 1,
    },
    {   values => {
            label => 'Label',
            text  => 'Text',
        },
        is_valid => 1,
    },
);

require FormattedText::FormattedText;
foreach my $data (@suite) {
    my $handler = MT::ErrorHandler->new;
    my $status
        = FormattedText::FormattedText::validate( $handler, $data->{values} );
    is( $status, $data->{is_valid},
              ( $data->{is_valid} ? 'Valid params' : 'Invalid params' )
            . ': keys: '
            . join( ',', keys( %{ $data->{values} } ) ) );
}


done_testing;
