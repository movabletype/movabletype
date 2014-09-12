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
my $version;
$mock_app_api->mock( 'current_api_version',
    sub { $version = $_[1] if $_[1]; $version } );

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
    {   path   => '/v1/sites/1/categories',
        method => 'GET',
        params => {
            sortBy    => 'label',
            sortOrder => 'ascend',
            limit     => 1,
        },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.category',
                count => 2,
            }
        ],
        result => sub {
            +{  totalResults => 3,
                items        => MT::DataAPI::Resource->from_object(
                    [   MT->model('category')->load(
                            undef,
                            {   sort      => 'label',
                                direction => 'ascend',
                                limit     => 1
                            }
                        )
                    ]
                ),
            };
        },
    },
    {   path   => '/v2/sites/1/categories',
        method => 'POST',
        params =>
            { category => { label => 'test-api-permission-category' }, },
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_save_permission_filter.category',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_save_filter.category',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_pre_save.category',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_post_save.category',
                count => 1,
            },
        ],
        result => sub {
            MT->model('category')
                ->load( { label => 'test-api-permission-category' } );
        },
    },
    {   path   => '/v2/sites/1/categories',
        method => 'POST',
        params => {
            category => {
                label  => 'test-create-category-with-parent',
                parent => 1,
            },
        },
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_save_permission_filter.category',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_save_filter.category',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_pre_save.category',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_post_save.category',
                count => 1,
            },
        ],
        result => sub {
            MT->model('category')
                ->load(
                { label => 'test-create-category-with-parent', parent => 1 }
                );
        },
    },
    {   path     => '/v2/sites/1/categories',
        method   => 'POST',
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            my $error = 'A resource "category" is required.';
            check_error_message( $body, $error );
        },
    },
    {   path     => '/v2/sites/1/categories',
        method   => 'POST',
        params   => { category => {} },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            my $error = 'A parameter "label" is required.' . "\n";
            check_error_message( $body, $error );
        },
    },
    {   path   => '/v2/sites/1/categories',
        method => 'POST',
        params => { category => { label => ( '1234567890' x 11 ) }, }
        ,    # exceeding 100 characters
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            my $error
                = "The label '" . ( '1234567890' x 11 ) . "' is too long.\n";
            check_error_message( $body, $error );
        },
    },
    {   path   => '/v2/sites/1/categories',
        method => 'POST',
        params => { category => { label => 'test-api-permission-category' } },
        code   => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            my $error
                = 'Save failed: The category name \'test-api-permission-category\' conflicts with the name of another category. Top-level categories and sub-categories with the same parent must have unique names.'
                . "\n";
            check_error_message( $body, $error );
        },
    },
    {   path   => '/v2/sites/1/categories',
        method => 'POST',
        params => {
            category => {
                label  => 'test-create-category-with-parent-folder',
                parent => 20,
            },
        },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            my $error = 'Parent category (ID:20) not found.' . "\n";
            check_error_message( $body, $error );
        },
    },
    {   path   => '/v2/sites/1/categories',
        method => 'POST',
        params => {
            category => {
                label  => 'test-create-category-with-invalid-parent',
                parent => 100,
            },
        },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            my $error = 'Parent category (ID:100) not found.' . "\n";
            check_error_message( $body, $error );
        },
    },
    {   path      => '/v2/sites/1/categories/1',
        method    => 'GET',
        code      => 200,
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_view_permission_filter.category',
                count => 1,
            },
        ],
    },
    {   path   => '/v2/sites/2/categories/1',
        method => 'GET',
        code   => 404,
    },
    {   path   => '/v2/sites/1/categories/4',
        method => 'GET',
        code   => 404,
    },
    {   path     => '/v2/sites/1/categories/20',
        method   => 'GET',
        code     => '404',
        complete => sub {
            my ( $data, $body ) = @_;
            my $error = 'Category not found';
            check_error_message( $body, $error );
        },
    },
    {   path   => '/v2/sites/1/categories/1',
        method => 'PUT',
        params => {
            category => { label => 'update-test-api-permission-category' }
        },
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_save_permission_filter.category',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_save_filter.category',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_pre_save.category',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_post_save.category',
                count => 1,
            },
        ],
        result => sub {
            MT->model('category')
                ->load( { label => 'update-test-api-permission-category' } );
        },
    },
    {   path      => '/v2/sites/1/categories/1',
        method    => 'PUT',
        params    => { category => { parent => 2 } },
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_save_permission_filter.category',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_save_filter.category',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_pre_save.category',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_post_save.category',
                count => 1,
            },
        ],
        result => sub {
            MT->model('category')->load( { id => 1, parent => 2 } );
        },
    },
    {   path     => '/v2/sites/1/categories/1',
        method   => 'PUT',
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            my $error = 'A resource "category" is required.';
            check_error_message( $body, $error );
        },
    },
    {   path     => '/v2/sites/1/categories/1',
        method   => 'PUT',
        params   => { category => { label => '' } },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            my $error = 'A parameter "label" is required.' . "\n";
            check_error_message( $body, $error );
        },
    },
    {   path   => '/v2/sites/1/categories/1',
        method => 'PUT',
        params => { category => { label => ( '1234567890' x 11 ) }, }
        ,    # exceeding 100 characters
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            my $error
                = "The label '" . ( '1234567890' x 11 ) . "' is too long.\n";
            check_error_message( $body, $error );
        },
    },
    {   path   => '/v2/sites/1/categories/2',
        method => 'PUT',
        params => {
            category => { label => 'update-test-api-permission-category' }
        },
        setup => sub {
            my $cat = MT->model('category')->load(1);
            $cat->parent(0);
            $cat->save;
        },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            my $error
                = 'Save failed: The category name \'update-test-api-permission-category\' conflicts with the name of another category. Top-level categories and sub-categories with the same parent must have unique names.'
                . "\n";
            check_error_message( $body, $error );
        },
    },
    {   path   => '/v2/sites/1/categories/4',
        method => 'PUT',
        params => {
            category => { label => 'update-test-api-permission-category-2' }
        },
        code => 404,
    },
    {   path   => '/v2/sites/1/categories/20',
        method => 'PUT',
        params =>
            { category => { label => 'update-test-api-permission-folder' }, },
        code     => 404,
        complete => sub {
            my ( $data, $body ) = @_;
            my $error = 'Category not found';
            check_error_message( $body, $error );
        },
    },
    {   path     => '/v2/sites/1/categories/1',
        method   => 'PUT',
        params   => { category => { parent => 20 } },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            my $error = 'Parent category (ID:20) not found.' . "\n";
            check_error_message( $body, $error );
        },
    },
    {   path     => '/v2/sites/1/categories/1',
        method   => 'PUT',
        params   => { category => { parent => 100 } },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            my $error = 'Parent category (ID:100) not found.' . "\n";
            check_error_message( $body, $error );
        },
    },
    {   path   => '/v2/sites/2/categories/1',
        method => 'POST',
        params => {
            category => { label => 'update-test-api-permission-category-2' }
        },
        code => 404,
    },
    {   path   => '/v2/sites/2/categories/2',
        method => 'DELETE',
        code   => 404,
    },
    {   path      => '/v2/sites/1/categories/1',
        method    => 'DELETE',
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_delete_permission_filter.category',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_post_delete.category',
                count => 1,
            },
        ],
        complete => sub {
            my $deleted = MT->model('category')->load(1);
            is( $deleted, undef, 'deleted' );
        },
    },
    {   path   => '/v2/sites/1/categories/1',
        method => 'DELETE',
        code   => 404,
    },
    {   path     => '/v2/sites/1/categories/20',
        method   => 'DELETE',
        code     => 404,
        complete => sub {
            my ( $data, $body ) = @_;
            my $error = 'Category not found';
            check_error_message( $body, $error );
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
    $data->{setup}->($data) if $data->{setup};

    my $path = $data->{path};
    $path
        =~ s/:(?:(\w+)_id)|:(\w+)/ref $data->{$1} ? $data->{$1}->id : $data->{$2}/ge;

    my $params
        = ref $data->{params} eq 'CODE'
        ? $data->{params}->($data)
        : $data->{params};

    my $note = $path;
    if ( lc $data->{method} eq 'get' && $data->{params} ) {
        $note .= '?'
            . join( '&',
            map { $_ . '=' . $data->{params}{$_} }
                keys %{ $data->{params} } );
    }
    $note .= ' ' . $data->{method};
    $note .= ' ' . $data->{note} if $data->{note};
    note($note);

    %callbacks = ();
    _run_app(
        'MT::App::DataAPI',
        {   __path_info      => $path,
            __request_method => $data->{method},
            ( $data->{upload} ? ( __test_upload => $data->{upload} ) : () ),
            (   $params
                ? map {
                    $_ => ref $params->{$_}
                        ? MT::Util::to_json( $params->{$_} )
                        : $params->{$_};
                    }
                    keys %{$params}
                : ()
            ),
        }
    );
    my $out = delete $app->{__test_output};
    my ( $headers, $body ) = split /^\s*$/m, $out, 2;
    my %headers = map {
        my ( $k, $v ) = split /\s*:\s*/, $_, 2;
        $v =~ s/(\r\n|\r|\n)\z//;
        lc $k => $v
        }
        split /\n/, $headers;
    my $expected_status = $data->{code} || 200;
    is( $headers{status}, $expected_status, 'Status ' . $expected_status );
    if ( $data->{next_phase_url} ) {
        like(
            $headers{'x-mt-next-phase-url'},
            $data->{next_phase_url},
            'X-MT-Next-Phase-URL'
        );
    }

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
        $expected_result = $expected_result->( $data, $body )
            if ref $expected_result eq 'CODE';
        if ( UNIVERSAL::isa( $expected_result, 'MT::Object' ) ) {
            MT->instance->user($author);
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
        $complete->( $data, $body );
    }
}

done_testing();

sub check_error_message {
    my ( $body, $error ) = @_;
    my $result = MT::Util::from_json($body);
    is( $result->{error}{message}, $error, 'Error message: ' . $error );
}
