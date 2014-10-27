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

use boolean ();

use MT::App::DataAPI;
my $app    = MT::App::DataAPI->new;
my $author = MT->model('author')->load(1);

my $mock_author = Test::MockModule->new('MT::Author');
$mock_author->mock( 'is_superuser', sub {0} );
my $mock_app_api = Test::MockModule->new('MT::App::DataAPI');
$mock_app_api->mock( 'authenticate', $author );
my $version;
$mock_app_api->mock( 'current_api_version',
    sub { $version = $_[1] if $_[1]; $version } );

my $website_page = $app->model('page')->new;
$website_page->set_values(
    {   blog_id   => 2,             # website
        author_id => $author->id,
        status    => 2,             # publish
    }
);
$website_page->save or die $website_page->errstr;

my $blog_page = $app->model('page')->load(20);
$blog_page->status(1);              # draft
$blog_page->save or die $blog_page->errstr;

my @suite = (

    # list_pages - irregualr tests
    {                               # Non-existent site.
        path   => '/v2/sites/5/pages',
        method => 'GET',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Site not found',
                },
            };
        },
    },

    # list_pages - normal tests
    {    # Blog.
        path      => '/v2/sites/1/pages',
        method    => 'GET',
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.page',
                count => 2,
            },
        ],
        result => sub {
            my @pages = $app->model('page')->load( { blog_id => 1 },
                { sort => 'modified_on', direction => 'descend' } );

            $app->user($author);
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => 4,
                items        => MT::DataAPI::Resource->from_object( \@pages ),
            };
        },
    },
    {    # Website.
        path      => '/v2/sites/2/pages',
        method    => 'GET',
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.page',
                count => 2,
            },
        ],
        result => sub {
            my @pages = $app->model('page')->load( { blog_id => 2 },
                { sort => 'modified_on', direction => 'descend' } );

            $app->user($author);
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => 1,
                items        => MT::DataAPI::Resource->from_object( \@pages ),
            };
        },
    },
    {    # Not logged in.
        path      => '/v2/sites/0/pages',
        method    => 'GET',
        setup     => sub { $mock_app_api->unmock('authenticate') },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.page',
                count => 2,
            },
        ],
        result => sub {
            my @pages = $app->model('page')->load( { status => 2 },
                { sort => 'modified_on', direction => 'descend' } );

            $app->user( MT::Author->anonymous );
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => 4,
                items        => MT::DataAPI::Resource->from_object( \@pages ),
            };
        },
        complete => sub { $mock_app_api->mock( 'authenticate', $author ) },
    },
    {    # Search.
        path      => '/v2/sites/1/pages',
        method    => 'GET',
        params    => { search => 'watching', },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.page',
                count => 2,
            },
        ],
        result => sub {
            my $page = $app->model('page')->load(20);

            $app->user($author);
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => 1,
                items        => MT::DataAPI::Resource->from_object( [$page] ),
            };
        },
    },
    {    # Filter by status.
        path      => '/v2/sites/1/pages',
        method    => 'GET',
        params    => { status => 'Draft' },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.page',
                count => 2,
            },
        ],
        result => sub {
            my @pages
                = $app->model('page')->load( { blog_id => 1, status => 1 } );

            $app->user($author);
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => 1,
                items        => MT::DataAPI::Resource->from_object( \@pages ),
            };
        },
    },

    # get_page - irregular tests
    {    # Non-existent page.
        path   => '/v2/sites/1/pages/500',
        method => 'GET',
        code   => 404,
    },
    {    # Non-existent site.
        path   => '/v2/sites/5/pages/23',
        method => 'GET',
        code   => 404,
    },
    {    # Other site.
        path   => '/v2/sites/2/pages/23',
        method => 'GET',
        code   => 404,
    },
    {    # Other site (system).
        path   => '/v2/sites/0/pages/23',
        method => 'GET',
        code   => 404,
    },
    {    # Not page (entry).
        path   => '/v2/sites/1/pages/2',
        method => 'GET',
        code   => 404,
    },
    {    # Not published and not logged in.
        path     => '/v2/sites/1/pages/20',
        method   => 'GET',
        setup    => sub { $mock_app_api->unmock('authenticate') },
        code     => 403,
        complete => sub { $mock_app_api->mock( 'authenticate', $author ) },
    },

    # get_page - normal tests
    {   path      => '/v2/sites/1/pages/23',
        method    => 'GET',
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_view_permission_filter.page',
                count => 1,
            },
        ],
        result => sub {
            $app->model('page')->load(
                {   id    => 23,
                    class => 'page',
                }
            );
        },
    },

    # create_page - irregular tests
    {    # No resource.
        path     => '/v2/sites/1/pages',
        method   => 'POST',
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body, 'A resource "page" is required.' );
        },
    },
    {    # Non-existent site.
        path   => '/v2/sites/5/pages',
        method => 'POST',
        params => {
            page => {
                title => 'create-page-non-existent-site',
                body  => 'create page on non-existent site.',
            },
        },
        code => 404,
    },
    {    # System.
        path   => '/v2/sites/0/pages',
        method => 'POST',
        params => {
            page => {
                title => 'create-page-system',
                body  => 'create page on system.',
            },
        },
        code => 404,
    },

    # create_page - normal tests
    {   path   => '/v2/sites/1/pages',
        method => 'POST',
        params => {
            page => {
                title => 'create-page',
                text  => 'create page',
            },
        },
        result => sub {
            $app->model('page')->load(
                {   blog_id => 1,
                    class   => 'page',
                    title   => 'create-page',
                }
            );
        },
    },

    # update_page - irregular tests
    {    # Non-existent page.
        path   => '/v2/sites/1/pages/100',
        method => 'PUT',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Page not found',
                },
            };
        },
    },
    {    # Non-existent site.
        path   => '/v2/sites/5/pages/23',
        method => 'PUT',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Site not found',
                },
            };
        },
    },
    {    # Other site.
        path   => '/v2/sites/2/pages/23',
        method => 'PUT',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Page not found',
                },
            };
        },
    },
    {    # Other site (system).
        path   => '/v2/sites/0/pages/23',
        method => 'PUT',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Page not found',
                },
            };
        },
    },
    {    # No resource.
        path     => '/v2/sites/1/pages/23',
        method   => 'PUT',
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body, 'A resource "page" is required.' );
        },
    },

    # update_page - normal tests
    {   path   => '/v2/sites/1/pages/23',
        method => 'PUT',
        params => {
            page => {
                title => 'update-page',
                body  => 'update page',
            },
        },
        result => sub {
            $app->model('page')->load(23);
        },
    },

    # delete_page - irregular tests
    {    # Non-existent page.
        path   => '/v2/sites/1/pages/500',
        method => 'DELETE',
        code   => 404,
    },
    {    # Non-existent site.
        path   => '/v2/sites/5/pages/23',
        method => 'DELETE',
        code   => 404,
    },
    {    # Other site.
        path   => '/v2/sites/2/pages/23',
        method => 'DELETE',
        code   => 404,
    },
    {    # Other site (system).
        path   => '/v2/sites/0/pages/23',
        method => 'DELETE',
        code   => 404,
    },
    {    # Not page (entry).
        path   => '/v2/sites/1/pages/2',
        method => 'DELETE',
        code   => 404,
    },

    # delete_page - normal tests
    {   path   => '/v2/sites/1/pages/23',
        method => 'DELETE',
        setup  => sub {
            die if !$app->model('page')->load(23);
        },
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_delete_permission_filter.page',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_post_delete.page',
                count => 1,
            },
        ],
        complete => sub {
            my $page = $app->model('page')->load(23);
            is( $page, undef, 'Deleted page.' );
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
    my $result = $app->current_format->{unserialize}->($body);
    is( $result->{error}{message}, $error, 'Error message: ' . $error );
}
