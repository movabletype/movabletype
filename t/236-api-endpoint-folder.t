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

    # list_folders - irregular tests
    {    # Non-existent site.
        path   => '/v2/sites/5/folders',
        method => 'GET',
        code   => 404,
    },

    # list_folders - normal tests
    {    # Site.
        path      => '/v2/sites/1/folders',
        method    => 'GET',
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.folder',
                count => 2,
            },
        ],
    },
    {    # System.
        path      => '/v2/sites/0/folders',
        method    => 'GET',
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.folder',
                count => 2,
            },
        ],
    },

    # get_folder - irregular tests
    {    # Non-existent folder.
        path   => '/v2/sites/1/folders/100',
        method => 'GET',
        code   => 404,
    },
    {    # Non-existent site.
        path   => '/v2/sites/5/folders/22',
        method => 'GET',
        code   => 404,
    },
    {    # Other site.
        path   => '/v2/sites/2/folders/22',
        method => 'GET',
        code   => 404,
    },
    {    # Other site (system).
        path   => '/v2/sites/0/folders/22',
        method => 'GET',
        code   => 404,
    },
    {    # Not folder (category).
        path   => '/v2/sites/1/folders/3',
        method => 'GET',
        code   => 404,
    },

    # get_folder - normal tests
    {   path      => '/v2/sites/1/folders/22',
        method    => 'GET',
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_view_permission_filter.folder',
                count => 1,
            },
        ],
        result => sub {
            $app->model('folder')->load(22);
        },
    },

    # create_folder - irregular tests
    {    # No resource.
        path     => '/v2/sites/1/folders',
        method   => 'POST',
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body, 'A resource "folder" is required.' );
        },
    },
    {    # No label.
        path     => '/v2/sites/1/folders',
        method   => 'POST',
        params   => { folder => {}, },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"label\" is required.\n" );
        },
    },
    {    # Label is exceeding 100 characters.
        path     => '/v2/sites/1/folders',
        method   => 'POST',
        params   => { folder => { label => ( '1234567890' x 11 ), }, },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "The label '" . ( '1234567890' x 11 ) . "' is too long.\n" );
        },
    },

    # create_folder - normal tests
    {   path      => '/v2/sites/1/folders',
        method    => 'POST',
        params    => { folder => { label => 'create-folder', }, },
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_save_permission_filter.folder',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_save_filter.folder',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_pre_save.folder',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_post_save.folder',
                count => 1,
            },
        ],
        result => sub {
            $app->model('folder')->load(
                {   blog_id => 1,
                    label   => 'create-folder',
                }
            );
        },
    },

    # update_folder - irregular tests
    {    # Non-existent folder.
        path   => '/v2/sites/1/folders/500',
        method => 'PUT',
        code   => 404,
    },
    {    # Non-existent site.
        path   => '/v2/sites/5/folders/22',
        method => 'PUT',
        code   => 404,
    },
    {    # Other site.
        path   => '/v2/sites/2/folders/22',
        method => 'PUT',
        code   => 404,
    },
    {    # Other site (system).
        path   => '/v2/sites/0/folders/22',
        method => 'PUT',
        code   => 404,
    },
    {    # Not folder (category).
        path   => '/v2/sites/1/folders/3',
        method => 'PUT',
        code   => 404,
    },
    {    # No resource.
        path     => '/v2/sites/1/folders/22',
        method   => 'PUT',
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body, 'A resource "folder" is required.' );
        },
    },

    # update_folder - normal tests
    {   path   => '/v2/sites/1/folders/22',
        method => 'PUT',
        params => { folder => { label => 'update-folder', }, },
        result => sub {
            $app->model('folder')->load(
                {   id      => 22,
                    blog_id => 1,
                    label   => 'update-folder',
                    class   => 'folder',
                }
            );
        },
    },

    # permutate_folders - irregular tests
    {    # Non-existent site.
        path   => '/v2/sites/5/folders/permutate',
        method => 'POST',
        code   => 404,
    },
    {    # System.
        path   => '/v2/sites/0/folders/permutate',
        method => 'POST',
        code   => 404,
    },
    {    # No folders parameter.
        path   => '/v2/sites/1/folders/permutate',
        method => 'POST',
        code   => 400,
        result => sub {
            return +{
                error => {
                    code    => 400,
                    message => 'A parameter "folders" is required.',
                },
            };
        },
    },
    {    # Insufficient folders.
        path   => '/v2/sites/1/folders/permutate',
        method => 'POST',
        params => { folders => [ map { +{ id => $_ } } qw/ 23 22 21 / ], },
        code   => 400,
        result => sub {
            +{  error => {
                    code    => 400,
                    message => 'A parameter "folders" is invalid.',
                },
            };
        },
    },

    # permutate_folder - normal tests
    {   path   => '/v2/sites/1/folders/permutate',
        method => 'POST',
        params => { folders => [ map { +{ id => $_ } } qw/ 23 22 21 20 / ], },
        callbacks => [
            {   name  => 'MT::App::DataAPI::data_api_post_bulk_save.folder',
                count => 1,
            },
        ],
        result => sub {
            my $site = $app->model('blog')->load(1);
            my @folder_order = split ',', $site->folder_order;

            $app->user($author);
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return MT::DataAPI::Resource->from_object(
                [ map { $app->model('folder')->load($_) } @folder_order ] );
        },
    },

    # delete_folder - irregular tests
    {    # Non-existent folder.
        path   => '/v2/sites/1/folders/100',
        method => 'DELETE',
        code   => 404,
    },
    {    # Non-existent site.
        path   => '/v2/sites/5/folders/22',
        method => 'DELETE',
        code   => 404,
    },
    {    # Other site.
        path   => '/v2/sites/2/folders/22',
        method => 'DELETE',
        code   => 404,
    },
    {    # Other site (system).
        path   => '/v2/sites/0/folders/22',
        method => 'DELETE',
        code   => 404,
    },
    {    # Not folder (category).
        path   => '/v2/sites/1/folders/3',
        method => 'DELETE',
        code   => 404,
    },

    # delete_folder - normal tests
    {   path      => '/v2/sites/1/folders/22',
        method    => 'DELETE',
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_delete_permission_filter.folder',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_post_delete.folder',
                count => 1,
            },
        ],
        setup => sub {
            die if !$app->model('folder')->load(22);
        },
        complete => sub {
            my $folder = $app->model('folder')->load(22);
            is( $folder, undef, 'Deleted folder.' );
        },
    },

    # list_parent_folders - normal tests
    {   setup => sub {
            my $folder = $app->model('folder')->load(23);
            $folder->parent(21);
            $folder->save or die $folder->errstr;
        },
        path   => '/v2/sites/1/folders/23/parents',
        method => 'GET',
    },

    # list_sibling_folders - normal tests
    {   setup => sub {
            my $folder = $app->model('folder')->load(20);
            $folder->parent(21);
            $folder->save or die $folder->errstr;
        },
        path   => '/v2/sites/1/folders/23/siblings',
        method => 'GET',
    },

    # list_child_folders - normal tests
    {   path   => '/v2/sites/1/folders/21/children',
        method => 'GET',
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
