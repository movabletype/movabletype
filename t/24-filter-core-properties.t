#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use Test::More;

eval(
    $ENV{SKIP_REINITIALIZE_DATABASE}
    ? "use MT::Test qw(:time); 1;"
    : "use MT::Test qw(:db :data :time); 1;"
) or die $@;

use MT;
use MT::Filter;
use MT::ListProperty;

my $mt = MT->new();
my $entries_count = MT->model('entry')->count;

ok(defined $MT::Test::CORE_TIME, '$MT::Test::CORE_TIME is defined');
ok(defined $Data::ObjectDriver::PROFILE, '$Data::ObjectDriver::PROFILE is defined');

sub setupFilter {
    my ( $id, $items ) = @_;

    my $filter = MT->model('filter')->load($id) || MT->model('filter')->new;
    $filter->set_values( { id => $id, author_id => 1, blog_id => 1 } );
    $filter->items($items);
    $filter->save or die;
}

my @count_specs = (
    {   name       => 'hidden',
        datasource => 'association',
        items      => [
            {   type => 'author_id',
                args => {
                    value => 1,
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            is(scalar @$objs, 1, 'An object is loaded');
            is($objs->[0]->id, 1, 'id');
        },
    },
    {   name       => 'integer : equal (without option) : if match',
        datasource => 'entry',
        items      => [
            {   type => 'id',
                args => {
                    value => 4,
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            is(scalar @$objs, 1, 'An object is loaded');
            is($objs->[0]->id, 4, 'id');
        },
    },
    {   name       => 'integer : equal (without option) : if not match',
        datasource => 'entry',
        items      => [
            {   type => 'id',
                args => {
                    value => 9999,
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            ok(!$objs, 'Any objects are not loaded');
        },
    },
    {   name       => 'integer : equal : if match',
        datasource => 'entry',
        items      => [
            {   type => 'id',
                args => {
                    value => 4,
                    option => 'equal',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            is(scalar @$objs, 1, 'An object is loaded');
            is($objs->[0]->id, 4, 'id');
        },
    },
    {   name       => 'integer : equal : if not match',
        datasource => 'entry',
        items      => [
            {   type => 'id',
                args => {
                    value => 9999,
                    option => 'equal',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            ok(!$objs, 'Any objects are not loaded');
        },
    },
    {   name       => 'integer : not_equal : if match',
        datasource => 'entry',
        items      => [
            {   type => 'id',
                args => {
                    value => 4,
                    option => 'not_equal',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            is(scalar @$objs, $entries_count - 1, 'Loaded count');
        },
    },
    {   name       => 'integer : not_equal : if not match',
        datasource => 'entry',
        items      => [
            {   type => 'id',
                args => {
                    value => 9999,
                    option => 'not_equal',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            is(scalar @$objs, $entries_count, 'Loaded count');
        },
    },
    {   name       => 'integer : greater_than : if match',
        datasource => 'entry',
        items      => [
            {   type => 'id',
                args => {
                    value => 2,
                    option => 'greater_than',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            is(scalar @$objs, $entries_count - 2, 'Loaded count');
        },
    },
    {   name       => 'integer : greater_than : if not match',
        datasource => 'entry',
        items      => [
            {   type => 'id',
                args => {
                    value => 9999,
                    option => 'greater_than',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            ok(!$objs, 'Any objects are not loaded');
        },
    },
    {   name       => 'integer : less_than : if match',
        datasource => 'entry',
        items      => [
            {   type => 'id',
                args => {
                    value => 2,
                    option => 'less_than',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            is(scalar @$objs, 1, 'Loaded count');
        },
    },
    {   name       => 'integer : less_than : if not match',
        datasource => 'entry',
        items      => [
            {   type => 'id',
                args => {
                    value => 1,
                    option => 'less_than',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            ok(!$objs, 'Any objects are not loaded');
        },
    },
    {   name       => 'integer : less_equal : if match',
        datasource => 'entry',
        items      => [
            {   type => 'id',
                args => {
                    value => 2,
                    option => 'less_equal',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            is(scalar @$objs, 2, 'Loaded count');
        },
    },
    {   name       => 'integer : less_equal : if not match',
        datasource => 'entry',
        items      => [
            {   type => 'id',
                args => {
                    value => 0,
                    option => 'less_equal',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            ok(!$objs, 'Any objects are not loaded');
        },
    },
    {   name       => 'string : equal (without option) : if match',
        datasource => 'entry',
        items      => [
            {   type => 'title',
                args => {
                    value => 'A Rainy Day',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            is(scalar @$objs, 1, 'An object is loaded');
            is($objs->[0]->id, 1, 'id');
        },
    },
    {   name       => 'string : equal (without option) : if not match',
        datasource => 'entry',
        items      => [
            {   type => 'title',
                args => {
                    value => 'A Rainy',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            ok(!$objs, 'Any objects are not loaded');
        },
    },
    {   name       => 'string : equal : if match',
        datasource => 'entry',
        items      => [
            {   type => 'title',
                args => {
                    value => 'A Rainy Day',
                    option => 'equal',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            is(scalar @$objs, 1, 'An object is loaded');
            is($objs->[0]->id, 1, 'id');
        },
    },
    {   name       => 'string : equal : if not match',
        datasource => 'entry',
        items      => [
            {   type => 'title',
                args => {
                    value => 'A Rainy',
                    option => 'equal',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            ok(!$objs, 'Any objects are not loaded');
        },
    },
    {   name       => 'string : contains : if match',
        datasource => 'entry',
        items      => [
            {   type => 'title',
                args => {
                    value => 'Rainy',
                    option => 'contains',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            is(scalar @$objs, 1, 'An object is loaded');
            is($objs->[0]->id, 1, 'id');
        },
    },
    {   name       => 'string : contains : if not match',
        datasource => 'entry',
        items      => [
            {   type => 'title',
                args => {
                    value => 'Not A Rainy',
                    option => 'contains',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            ok(!$objs, 'Any objects are not loaded');
        },
    },
    {   name       => 'string : not_contains : if match',
        datasource => 'entry',
        items      => [
            {   type => 'title',
                args => {
                    value => 'A Rainy Day',
                    option => 'not_contains',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            is(scalar @$objs, $entries_count - 1, 'Loaded count');
        },
    },
    {   name       => 'string : not_contains : if not match',
        datasource => 'entry',
        items      => [
            {   type => 'title',
                args => {
                    value => 'Not A Rainy Day',
                    option => 'not_contains',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            is(scalar @$objs, $entries_count, 'Loaded count');
        },
    },
    {   name       => 'string : beginning : if match',
        datasource => 'entry',
        items      => [
            {   type => 'title',
                args => {
                    value => 'A Rainy',
                    option => 'beginning',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            is(scalar @$objs, 1, 'An object is loaded');
            is($objs->[0]->id, 1, 'id');
        },
    },
    {   name       => 'string : beginning : if not match',
        datasource => 'entry',
        items      => [
            {   type => 'title',
                args => {
                    value => 'Rainy Day',
                    option => 'beginning',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            ok(!$objs, 'Any objects are not loaded');
        },
    },
    {   name       => 'string : end : if match',
        datasource => 'entry',
        items      => [
            {   type => 'title',
                args => {
                    value => 'Rainy Day',
                    option => 'end',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            is(scalar @$objs, 1, 'An object is loaded');
            is($objs->[0]->id, 1, 'id');
        },
    },
    {   name       => 'string : end : if not match',
        datasource => 'entry',
        items      => [
            {   type => 'title',
                args => {
                    value => 'A Rainy',
                    option => 'end',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            ok(!$objs, 'Any objects are not loaded');
        },
    },
    {   name       => 'date : equal (without option) : if match : by date-time',
        datasource => 'entry',
        items      => [
            {   type => 'authored_on',
                args => { value => '1978-01-31T07:45:00', },
            }
        ],
        complete => sub {
            my ( $spec, $objs ) = @_;
            my $count = MT->model('entry')
                ->count( { authored_on => '19780131074500' } );
            is( scalar @$objs, $count, 'Loaded count' );
        },
    },
    {   name       => 'date : equal (without option) : if match : by date',
        datasource => 'entry',
        items      => [
            {   type => 'authored_on',
                args => { value => '1978-01-31', },
            }
        ],
        complete => sub {
            my ( $spec, $objs ) = @_;
            my $count = MT->model('entry')->count(
                { authored_on => [ '19780131000000', '19780131235959' ] },
                {   range_incl => { authored_on => 1 },

                }
            );
            is( scalar @$objs, $count, 'Loaded count' );
        },
    },
    {   name       => 'date : equal (without option)range : if not match : by date-time',
        datasource => 'entry',
        items      => [
            {   type => 'authored_on',
                args => { value => '1978-01-31T07:45:10', },
            }
        ],
        complete => sub {
            my ( $spec, $objs ) = @_;
            ok(!$objs, 'Any objects are not loaded');
        },
    },
    {   name       => 'date : range : if match : by date-time',
        datasource => 'entry',
        items      => [
            {   type => 'authored_on',
                args => {
                    option => 'range',
                    from => '1978-01-31T07:45:00',
                    to => '1978-01-31T07:45:00',
                },
            }
        ],
        complete => sub {
            my ( $spec, $objs ) = @_;
            my $count = MT->model('entry')
                ->count( { authored_on => '19780131074500' } );
            is( scalar @$objs, $count, 'Loaded count' );
        },
    },
    {   name       => 'date : range : if match : by date',
        datasource => 'entry',
        items      => [
            {   type => 'authored_on',
                args => {
                    option => 'range',
                    from => '1978-01-31',
                    to => '1978-01-31',
                },
            }
        ],
        complete => sub {
            my ( $spec, $objs ) = @_;
            my $count = MT->model('entry')->count(
                { authored_on => [ '19780131000000', '19780131235959' ] },
                {   range_incl => { authored_on => 1 },

                }
            );
            is( scalar @$objs, $count, 'Loaded count' );
        },
    },
    {   name       => 'date : range : if not match : by date',
        datasource => 'entry',
        items      => [
            {   type => 'authored_on',
                args => {
                    option => 'range',
                    from => '1978-02-01',
                    to => '1978-02-02',
                },
            }
        ],
        complete => sub {
            my ( $spec, $objs ) = @_;
            ok(!$objs, 'Any objects are not loaded');
        },
    },
    {   name       => 'date : days : if match',
        datasource => 'entry',
        setup => sub {
            require Time::Local;
            $MT::Test::CORE_TIME = Time::Local::timegm(0, 0, 0, 1, 1, 1978);
        },
        items      => [
            {   type => 'authored_on',
                args => {
                    option => 'days',
                    days => 1,
                },
            }
        ],
        complete => sub {
            my ( $spec, $objs ) = @_;
            my $count = MT->model('entry')->count(
                { authored_on => [ '19780131000000', '19780131235959' ] },
                {   range_incl => { authored_on => 1 },

                }
            );
            is( scalar @$objs, $count, 'Loaded count' );
        },
    },
    {   name       => 'date : days : if not match',
        datasource => 'entry',
        setup => sub {
            require Time::Local;
            $MT::Test::CORE_TIME = Time::Local::timegm(0, 0, 0, 1, 2, 1978);
        },
        items      => [
            {   type => 'authored_on',
                args => {
                    option => 'days',
                    days => 1,
                },
            }
        ],
        complete => sub {
            my ( $spec, $objs ) = @_;
            ok(!$objs, 'Any objects are not loaded');
        },
    },
    {   name       => 'date : before : if match : by date-time',
        datasource => 'entry',
        items      => [
            {   type => 'authored_on',
                args => {
                    option => 'before',
                    origin => '1978-01-31T07:45:11'
                },
            }
        ],
        complete => sub {
            my ( $spec, $objs ) = @_;
            my $count = MT->model('entry')->count(
                { authored_on => [ undef, '19780131074511' ] },
                {   range => { authored_on => 1 },

                }
            );
            is( scalar @$objs, $count, 'Loaded count' );
        },
    },
    {   name       => 'date : before : if match : by date',
        datasource => 'entry',
        items      => [
            {   type => 'authored_on',
                args => {
                    option => 'before',
                    origin => '1978-02-01'
                },
            }
        ],
        complete => sub {
            my ( $spec, $objs ) = @_;
            my $count = MT->model('entry')->count(
                { authored_on => [ undef, '19780201000000' ] },
                {   range => { authored_on => 1 },

                }
            );
            is( scalar @$objs, $count, 'Loaded count' );
        },
    },
    {   name       => 'date : before : if not match',
        datasource => 'entry',
        items      => [
            {   type => 'authored_on',
                args => {
                    option => 'before',
                    origin => '1878-01-31T07:45:10'
                },
            }
        ],
        complete => sub {
            my ( $spec, $objs ) = @_;
            my $count = MT->model('entry')->count(
                { authored_on => [ undef, '18780131074510' ] },
                {   range => { authored_on => 1 },

                }
            );
            ok(!$objs, 'Any objects are not loaded');
        },
    },
    {   name       => 'date : after : if match : by date-time',
        datasource => 'entry',
        items      => [
            {   type => 'authored_on',
                args => {
                    option => 'after',
                    origin => '1978-01-31T07:44:00'
                },
            }
        ],
        complete => sub {
            my ( $spec, $objs ) = @_;
            my $count = MT->model('entry')->count(
                { authored_on => [ '19780131074400', undef ] },
                {   range => { authored_on => 1 },

                }
            );
            is( scalar @$objs, $count, 'Loaded count' );
        },
    },
    {   name       => 'date : after : if match : by date',
        datasource => 'entry',
        items      => [
            {   type => 'authored_on',
                args => {
                    option => 'after',
                    origin => '1978-01-30'
                },
            }
        ],
        complete => sub {
            my ( $spec, $objs ) = @_;
            my $count = MT->model('entry')->count(
                { authored_on => [ '19780130235959', undef ] },
                {   range => { authored_on => 1 },

                }
            );
            is( scalar @$objs, $count, 'Loaded count' );
        },
    },
    {   name       => 'date : after : if not match',
        datasource => 'entry',
        items      => [
            {   type => 'authored_on',
                args => {
                    option => 'after',
                    origin => '3000-01-31T07:45:10'
                },
            }
        ],
        complete => sub {
            my ( $spec, $objs ) = @_;
            ok(!$objs, 'Any objects are not loaded');
        },
    },
    {   name       => 'date : future : if match',
        datasource => 'entry',
        setup      => sub {
            require Time::Local;
            $MT::Test::CORE_TIME
                = Time::Local::timegm( 0, 44, 7, 31, 0, 1978 );
        },
        items => [
            {   type => 'authored_on',
                args => { option => 'future', },
            }
        ],
        complete => sub {
            my ( $spec, $objs ) = @_;
            my $count = MT->model('entry')->count(
                { authored_on => [ '19780131074400', undef ] },
                {   range => { authored_on => 1 },

                }
            );
            is( scalar @$objs, $count, 'Loaded count' );
        },
    },
    {
        name       => 'date : future : if not match',
        datasource => 'entry',
        setup      => sub {
            require Time::Local;
            $MT::Test::CORE_TIME = Time::Local::timegm( 0, 0, 0, 1, 0, 3000 );
        },
        items => [
            {   type => 'authored_on',
                args => { option => 'future', },
            }
        ],
        complete => sub {
            my ( $spec, $objs ) = @_;
            ok( !$objs, 'Any objects are not loaded' );
        },
    },
    {   name       => 'date : past : if match',
        datasource => 'entry',
        setup      => sub {
            require Time::Local;
            $MT::Test::CORE_TIME
                = Time::Local::timegm( 0, 44, 7, 31, 0, 1978 );
        },
        items => [
            {   type => 'authored_on',
                args => { option => 'past', },
            }
        ],
        complete => sub {
            my ( $spec, $objs ) = @_;
            my $count = MT->model('entry')->count(
                { authored_on => [ undef, '19780131074400' ] },
                {   range => { authored_on => 1 },

                }
            );
            is( scalar @$objs, $count, 'Loaded count' );
        },
    },
    {
        name       => 'date : past : if not match',
        datasource => 'entry',
        setup      => sub {
            require Time::Local;
            $MT::Test::CORE_TIME = Time::Local::timegm( 0, 0, 0, 1, 0, 1000 );
        },
        items => [
            {   type => 'authored_on',
                args => { option => 'past', },
            }
        ],
        complete => sub {
            my ( $spec, $objs ) = @_;
            ok( !$objs, 'Any objects are not loaded' );
        },
    },
    {   name       => 'tag : equal (without option) : if match',
        datasource => 'entry',
        items      => [
            {   type => 'tag',
                args => {
                    value => 'grandpa',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            is(scalar @$objs, 1, 'An object is loaded');
            is($objs->[0]->id, 1, 'id');
        },
    },
    {   name       => 'tag : equal (without option) : if not match',
        datasource => 'entry',
        items      => [
            {   type => 'tag',
                args => {
                    value => 'pa',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            ok(!$objs, 'Any objects are not loaded');
        },
    },
    {   name       => 'tag : contains : if match',
        datasource => 'entry',
        items      => [
            {   type => 'tag',
                args => {
                    option => 'contains',
                    value => 'rand',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            is(scalar @$objs, 1, 'An object is loaded');
            is($objs->[0]->id, 1, 'id');
        },
    },
    {   name       => 'tag : contains : if not match',
        datasource => 'entry',
        items      => [
            {   type => 'tag',
                args => {
                    option => 'contains',
                    value => 'grandma',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            ok(!$objs, 'Any objects are not loaded');
        },
    },
    {   name       => 'tag : not_contains : if match',
        datasource => 'entry',
        items      => [
            {   type => 'tag',
                args => {
                    option => 'not_contains',
                    value => 'grandpa',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            is(scalar @$objs, $entries_count - 1, 'Loaded count');
        },
    },
    {   name       => 'tag : not_contains : if not match',
        datasource => 'entry',
        items      => [
            {   type => 'tag',
                args => {
                    option => 'not_contains',
                    value => 'grandma',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            is(scalar @$objs, $entries_count, 'Loaded count');
        },
    },
    {   name       => 'tag : beginning : if match',
        datasource => 'entry',
        items      => [
            {   type => 'tag',
                args => {
                    option => 'beginning',
                    value => 'grandp',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            is(scalar @$objs, 1, 'An object is loaded');
            is($objs->[0]->id, 1, 'id');
        },
    },
    {   name       => 'tag : beginning : if not match',
        datasource => 'entry',
        items      => [
            {   type => 'tag',
                args => {
                    option => 'beginning',
                    value => 'randpa',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            ok(!$objs, 'Any objects are not loaded');
        },
    },
    {   name       => 'tag : end : if match',
        datasource => 'entry',
        items      => [
            {   type => 'tag',
                args => {
                    option => 'end',
                    value => 'randpa',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            is(scalar @$objs, 1, 'An object is loaded');
            is($objs->[0]->id, 1, 'id');
        },
    },
    {   name       => 'tag : end : if not match',
        datasource => 'entry',
        items      => [
            {   type => 'tag',
                args => {
                    option => 'end',
                    value => 'grandp',
                },
            }
        ],
        complete => sub {
            my ($spec, $objs)    = @_;
            ok(!$objs, 'Any objects are not loaded');
        },
    },
);

$Data::ObjectDriver::PROFILE = 1;
for my $spec (@count_specs) {
    subtest $spec->{name}, sub {
        $spec->{setup}->($spec) if $spec->{setup};

        my $filter = MT::Filter->new;
        $filter->object_ds( $spec->{datasource} || 'entry' );
        Data::ObjectDriver->profiler->reset;

        if ( $spec->{items} ) {
            for my $item ( @{ $spec->{items} } ) {
                my $prop
                    = MT::ListProperty->instance( $spec->{datasource}
                        || 'entry',
                    $item->{type} );
                if ( $prop->has('validate_item') ) {
                    ok( $prop->validate_item($item),
                        'validated:' . MT::Util::to_json($item) );
                }
            }
        }

        $filter->items( $spec->{items} );
        my $objs = $filter->load_objects(
            terms => {},
            args  => {},
            %{ $spec->{options} }
        );
        if ( my $complete = $spec->{complete} ) {
            $complete->($spec, $objs);
        }

        done_testing();
    }
}

done_testing();
