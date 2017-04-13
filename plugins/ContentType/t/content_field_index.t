use strict;
use warnings;

use Test::More;

use lib qw( lib extlib t/lib );
use MT;
use MT::Test qw( :db );

use MT::ContentFieldIndex;

subtest 'make_terms' => sub {
    my $prop = { idx_type => 'varchar' };
    my $args = { option => 'contains', string => 'test' };
    my $db_terms = {};
    my $db_args  = {};

    MT::ContentFieldIndex::make_terms( $prop, $args, $db_terms, $db_args );

    my $expected_joins = [
        [   'MT::ContentFieldIndex',
            undef,
            {   value_varchar   => { like => '%test%' },
                content_data_id => \'= content_data_id',
            },
            { alias => 'index_varchar' },
        ]
    ];
    is_deeply( $db_args->{joins}, $expected_joins,
        'make_terms sets hash to $db_args->{joins}' );
};

done_testing;

