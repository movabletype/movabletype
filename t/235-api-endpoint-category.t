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
$author->email('melody@example.com');
$author->save;

my $mock_author = Test::MockModule->new('MT::Author');
$mock_author->mock( 'is_superuser', sub {0} );
my $mock_app_api = Test::MockModule->new('MT::App::DataAPI');
$mock_app_api->mock( 'authenticate', $author );

my @suite = (
    {   path      => '/v1/sites/1/categories',
        method    => 'GET',
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.category',
                count => 2,
            },
        ],
        setup => sub {
            my $blog = MT->model('blog')->load(1);
            $blog->category_order('1,2');
            $blog->save;

        },
        result => sub {
            +{  'totalResults' => '3',
                'items'        => MT::DataAPI::Resource->from_object(
                    [ map { MT->model('category')->load($_) } 1, 3, 2 ]
                ),
            };
        },
    },
    {   path      => '/v1/sites/1/categories',
        method    => 'GET',
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.category',
                count => 2,
            },
        ],
        setup => sub {
            my $blog = MT->model('blog')->load(1);
            $blog->category_order('2,1');
            $blog->save;
        },
        result => sub {
            +{  'totalResults' => '3',
                'items'        => MT::DataAPI::Resource->from_object(
                    [ map { MT->model('category')->load($_) } 2, 1, 3 ]
                ),
            };
        },
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
    note( $data->{path} );

    $data->{setup}->() if $data->{setup};

    %callbacks = ();
    _run_app(
        'MT::App::DataAPI',
        {   __path_info      => $data->{path},
            __request_method => $data->{method},
            (   $data->{params}
                ? map { $_ => MT::Util::to_json( $data->{params}{$_} ); }
                    keys %{ $data->{params} }
                : ()
            ),
        }
    );
    my $out = delete $app->{__test_output};
    my ( $status, $content_type, $body ) = split /\n/, $out, 3;
    my ($code) = ( $status =~ m/Status:\s*(\d+)/ );
    is( $code, $data->{code} || 200, 'Status is OK' );

    foreach my $cb ( @{ $data->{callbacks} } ) {
        my $params_list = $callbacks{ $cb->{name} } || [];
        if ( my $params = $cb->{params} ) {
            for ( my $i = 0; $i < scalar(@$params); $i++ ) {
                is_deeply( $params_list->[$i], $cb->{params}[$i] );
            }
        }

        if ( my $c = $cb->{count} ) {
            ok( @$params_list == $c,
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
