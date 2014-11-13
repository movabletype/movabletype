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

use MT::Entry;

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

my $blog  = MT->model('blog')->load(1);
my $entry = MT->model('entry')->load(
    {   blog_id => $blog->id,
        status  => MT::Entry::RELEASE(),
    }
);

my @suite = (

    # search - irregular tests
    {   path   => '/v2/search',
        method => 'GET',
        code   => 400,
        result => sub {
            +{  error => {
                    code    => 400,
                    message => 'A parameter "search" is required.',
                },
            };
        },
    },

    # search - normal tests

    # Tests from 140-app-search.t.
    {    # Found an entry.
        path   => '/v2/search',
        method => 'GET',
        params => {
            search       => $entry->title,
            IncludeBlogs => $blog->id,
            limit        => 20,
        },
        result => sub {
            my @entries = $app->model('entry')->load(
                {   blog_id => $blog->id,
                    status  => MT::Entry::RELEASE(),
                    class   => '*'
                },
                { sort => 'authored_on', direction => 'descend' },
            );

            my $entry_title = $entry->title;
            my @greped_entries;
            for my $e (@entries) {
                if ( grep { $e->$_ && $e->$_ =~ m/$entry_title/ }
                    qw/ title text text_more keywords / )
                {
                    push @greped_entries, $e;
                }
            }

            $app->user($author);
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => scalar @greped_entries,
                items =>
                    MT::DataAPI::Resource->from_object( \@greped_entries ),
            };
        },
    },
    {    # Not found.
        path   => '/v2/search',
        method => 'GET',
        params => {
            search       => 'Search word for no matching',
            IncludeBlogs => $blog->id,
            limit        => 20,
        },
        result => sub {
            return +{
                totalResults => 0,
                items        => [],
            };
        },
    },
    {    # No blog was specified.
        path   => '/v2/search',
        method => 'GET',
        params => {
            search => $entry->title,
            limit  => 20,
        },
        result => sub {
            my @entries = $app->model('entry')->load(
                {   blog_id => $blog->id,
                    status  => MT::Entry::RELEASE(),
                    class   => '*'
                },
                { sort => 'authored_on', direction => 'descend' },
            );

            my $entry_title = $entry->title;
            my @greped_entries;
            for my $e (@entries) {
                if ( grep { $e->$_ && $e->$_ =~ m/$entry_title/ }
                    qw/ title text text_more keywords / )
                {
                    push @greped_entries, $e;
                }
            }

            $app->user($author);
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => scalar @greped_entries,
                items =>
                    MT::DataAPI::Resource->from_object( \@greped_entries ),
            };
        },
    },
    {    # Only "IncludeBlogs=all" is specified.
        path   => '/v2/search',
        method => 'GET',
        params => {
            IncludeBlogs => 'all',
            search       => $entry->title,
            limit        => 20,
        },
        result => sub {
            my @entries = $app->model('entry')->load(
                {   blog_id => $blog->id,
                    status  => MT::Entry::RELEASE(),
                    class   => '*'
                },
                { sort => 'authored_on', direction => 'descend' },
            );

            my $entry_title = $entry->title;
            my @greped_entries;
            for my $e (@entries) {
                if ( grep { $e->$_ && $e->$_ =~ m/$entry_title/ }
                    qw/ title text text_more keywords / )
                {
                    push @greped_entries, $e;
                }
            }

            $app->user($author);
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => scalar @greped_entries,
                items =>
                    MT::DataAPI::Resource->from_object( \@greped_entries ),
            };
        },
    },

    # Original tests for search endpoint.
    {    # limit.
        path   => '/v2/search',
        method => 'GET',
        params => {
            search       => 'a',
            IncludeBlogs => '1,2',
            limit        => 5,
        },
        result => sub {
            my @entries = $app->model('entry')->load(
                {   blog_id => [ 1, 2 ],
                    status  => MT::Entry::RELEASE(),
                    class   => '*'
                },
                { sort => 'authored_on', direction => 'descend' },
            );

            my @greped_entries;
            for my $e (@entries) {
                if ( grep { $e->$_ && $e->$_ =~ m/a/ }
                    qw/ title text text_more keywords / )
                {
                    push @greped_entries, $e;
                }
            }

            $app->user($author);
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => scalar @greped_entries,
                items        => MT::DataAPI::Resource->from_object(
                    [ @greped_entries[ 0 .. 4 ] ]
                ),
            };
        },
    },
    {    # offset.
        path   => '/v2/search',
        method => 'GET',
        params => {
            search       => 'a',
            IncludeBlogs => '1,2',
            limit        => 5,
            offset       => 5,
        },
        result => sub {
            my @entries = $app->model('entry')->load(
                {   blog_id => [ 1, 2 ],
                    status  => MT::Entry::RELEASE(),
                    class   => '*'
                },
                { sort => 'authored_on', direction => 'descend' },
            );

            my @greped_entries;
            for my $e (@entries) {
                if ( grep { $e->$_ && $e->$_ =~ m/a/ }
                    qw/ title text text_more keywords / )
                {
                    push @greped_entries, $e;
                }
            }

            $app->user($author);
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => scalar @greped_entries,
                items        => MT::DataAPI::Resource->from_object(
                    [ @greped_entries[ 5 .. 9 ] ]
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
