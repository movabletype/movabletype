#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

BEGIN {
    use Test::More;
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

use lib qw(lib extlib t/lib);

eval(
    $ENV{SKIP_REINITIALIZE_DATABASE}
    ? "use MT::Test qw(:app);"
    : "use MT::Test qw(:app :db :data);"
);

use MT::App::DataAPI;
my $app    = MT::App::DataAPI->new;
my $author = MT->model('author')->load(1);

my $mock_author = Test::MockModule->new('MT::Author');
$mock_author->mock( 'is_superuser', sub {0} );
my $mock_app_api = Test::MockModule->new('MT::App::DataAPI');
$mock_app_api->mock( 'authenticate', $author );

sub result {
    my ( $terms, $args ) = @_;
    my $entry_class = $app->model('entry');
    +{  totalResults => $entry_class->count( $terms, $args ),
        items        => [
            map { +{ id => $_->id, title => $_->title, } }
                $entry_class->load( $terms, $args )
        ],
    };
}

my @suite = (
    {   path   => '/v1/sites/1/entries',
        method => 'GET',
        params => {
            limit  => 1,
            fields => 'id,title',
        },
        result => result(
            { class => 'entry', blog_id => 1 },
            {   limit => 1,
                sort  => [
                    { column => 'authored_on', desc => 'DESC' },
                    { column => "id",          desc => 'DESC' },
                ]
            }
        ),
    },
    {   path   => '/v1/sites/1/entries',
        method => 'GET',
        params => {
            limit  => 1,
            sortBy => 'title',
            fields => 'id,title',
        },
        result => result(
            { class => 'entry', blog_id => 1 },
            {   limit => 1,
                sort  => [ { column => 'title', desc => 'DESC' }, ]
            }
        ),
    },
    {   path   => '/v1/sites/1/entries',
        method => 'GET',
        params => {
            limit     => 1,
            sortBy    => 'title',
            sortOrder => 'ascend',
            fields    => 'id,title',
        },
        result => result(
            { class => 'entry', blog_id => 1 },
            {   limit => 1,
                sort  => [ { column => 'title', desc => 'ASC' }, ]
            }
        ),
    },
    {   path   => '/v1/sites/1/entries',
        method => 'GET',
        params => {
            limit  => 1,
            search => 'Rainy',
            fields => 'id,title',
        },
        result => result(
            {   class   => 'entry',
                blog_id => 1,
                title   => { like => '%Rainy%' },
            },
            {   limit => 1,
                sort  => [
                    { column => 'authored_on', desc => 'DESC' },
                    { column => "id",          desc => 'DESC' },
                ]
            }
        ),
    },
    map( {  +{  path   => '/v1/sites/1/entries',
                method => 'GET',
                params => {
                    limit  => 1,
                    status => $_->[0],
                    fields => 'id,title',
                },
                result => result(
                    {   class   => 'entry',
                        blog_id => 1,
                        status  => $_->[1],
                    },
                    {   limit => 1,
                        sort  => [
                            { column => 'authored_on', desc => 'DESC' },
                            { column => "id",          desc => 'DESC' },
                        ]
                    }
                ),
            }
        } ( [ Publish => MT::Entry::RELEASE(), ],
            [ Draft   => MT::Entry::HOLD(), ],
            [ Review  => MT::Entry::REVIEW(), ],
            [ Future  => MT::Entry::FUTURE(), ],
            [ Spam    => MT::Entry::JUNK(), ],
            ) ),
    {   path   => '/v1/sites/1/entries',
        method => 'GET',
        params => {
            limit      => 1,
            excludeIds => '3,2',
            fields     => 'id,title',
        },
        result => result(
            {   class   => 'entry',
                blog_id => 1,
                id      => { not => [ 3, 2 ] },
            },
            {   limit => 1,
                sort  => [
                    { column => 'authored_on', desc => 'DESC' },
                    { column => "id",          desc => 'DESC' },
                ]
            }
        ),
    },
);

my %callbacks = ();
my $mock_mt   = Test::MockModule->new('MT');
$mock_mt->mock(
    'run_callbacks',
    sub {
        my ( $app, $meth, @param ) = @_;
        $callbacks{$meth} ||= [];
        push @{ $callbacks{$meth} }, \@param;
        $mock_mt->original('run_callbacks')->(@_);
    }
);

my $format = MT::DataAPI::Format->find_format('json');

for my $data (@suite) {
    note(
        $data->{path} . '?'
            . join( '&',
            map { $_ . '=' . $data->{params}{$_} } keys %{ $data->{params} } )
    );

    %callbacks = ();
    _run_app(
        'MT::App::DataAPI',
        {   __path_info      => $data->{path},
            __request_method => $data->{method},
            (   $data->{params}
                ? map {
                    $_ => ref $data->{params}{$_}
                        ? MT::Util::to_json( $data->{params}{$_} )
                        : $data->{params}{$_};
                    }
                    keys %{ $data->{params} }
                : ()
            ),
        }
    );
    my $out = delete $app->{__test_output};
    my ( $status, $content_type, $body ) = split /\n/, $out, 3;
    my ($code) = ( $status =~ m/Status:\s*(\d+)/ );

    is( $code, 200, 'status' );

    foreach my $cb ( @{ $data->{callbacks} } ) {
        my $params_list = $callbacks{ $cb->{name} } || [];
        if ( my $params = $cb->{params} ) {
            for ( my $i = 0; $i < scalar(@$params); $i++ ) {
                is_deeply( $params_list->[$i], $cb->{params}[$i] );
            }
        }

        if ( my $c = $cb->{count} ) {
            is( @$params_list, $c,
                $cb->{name} . ' was called ' . $c . ' time(s)' );
        }
    }

    if ( my $expected_result = $data->{result} ) {
        $expected_result = $expected_result->()
            if ref $expected_result eq 'CODE';
        if ( UNIVERSAL::isa( $expected_result, 'MT::Object' ) ) {
            $expected_result = $format->{unserialize}->(
                $format->{serialize}->(
                    MT::DataAPI::Resource->from_object($expected_result)
                )
            );
        }

        my $result = $format->{unserialize}->($body);
        is_deeply( $result, $expected_result, 'result' );
    }

    if ( my $complete = $data->{complete} ) {
        $complete->();
    }
}

done_testing();
