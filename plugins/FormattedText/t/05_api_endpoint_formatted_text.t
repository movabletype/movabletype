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

my $ft_blog = $app->model('formatted_text')->new;
$ft_blog->set_values(
    {   blog_id     => 1,
        label       => 'formatted_text_blog',
        text        => 'formatted_text_blog_text',
        description => 'formatted_text_blog_description',
    }
);
$ft_blog->save or die $ft_blog->errstr;

my $ft_website = $app->model('formatted_text')->new;
$ft_website->set_values(
    {   blog_id     => 2,
        label       => 'formatted_text_website',
        text        => 'formatted_text_website_text',
        description => 'formatted_text_website_description',
    }
);
$ft_website->save or die $ft_website->errstr;

my %callbacks = ();

my @suite = (

    # get_formatted_text - irregular tests
    {    # Non-existent formatted text.
        path   => '/v2/sites/1/formattted_texts/100',
        method => 'GET',
        code   => 404,
    },
    {    # Non-existent site.
        path   => '/v2/sites/5/formattted_texts/' . $ft_blog->id,
        method => 'GET',
        code   => 404,
    },
    {    # Other site.
        path   => '/v2/sites/2/formattted_texts/' . $ft_blog->id,
        method => 'GET',
        code   => 404,
    },
    {    # Other site (system).
        path   => '/v2/sites/0/formattted_texts/' . $ft_blog->id,
        method => 'GET',
        code   => 404,
    },

    # get_formatted_text - normal tests
    {   path      => '/v2/sites/1/formatted_texts/' . $ft_blog->id,
        method    => 'GET',
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_view_permission_filter.formatted_text',
                count => 1,
            },
        ],
        results => sub {
            $app->model('formatted_text')->load( $ft_blog->id );
        },
    },

    # create_formatted_text - irregular tests
    {    # No resource.
        path     => '/v2/sites/1/formatted_texts',
        method   => 'POST',
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                'A resource "formatted_text" is required.' );
        },
    },
    {    # No label.
        path     => '/v2/sites/1/formatted_texts',
        method   => 'POST',
        params   => { formatted_text => {}, },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"label\" is required.\n" );
        },
    },
    {    # Duplicated label.
        path   => '/v2/sites/1/formatted_texts',
        method => 'POST',
        params => { formatted_text => { label => 'formatted_text_blog', }, },
        code   => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "The boilerplate 'formatted_text_blog' is already in use in this site.\n"
            );
        },
    },
    {    # System.
        path   => '/v2/sites/0/formatted_texts',
        method => 'POST',
        params => {
            formatted_text => {
                label       => 'create-formatted-text',
                text        => 'create-formatted-text-text',
                description => 'create-formatted-text-description',
            },
        },
        code   => 404,
        result => sub {
            {   error => {
                    code    => 404,
                    message => 'Site not found',
                },
            };
        },
    },

    # create_formatted_text - normal tests
    {   path   => '/v2/sites/1/formatted_texts',
        method => 'POST',
        params => {
            formatted_text => {
                label       => 'create-formatted-text',
                text        => 'create-formatted-text-text',
                description => 'create-formatted-text-description',
            },
        },
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_save_permission_filter.formatted_text',
                count => 1,
            },
            {   name =>
                    'MT::App::DataAPI::data_api_save_filter.formatted_text',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_pre_save.formatted_text',
                count => 1,
            },
            {   name => 'MT::App::DataAPI::data_api_post_save.formatted_text',
                count => 1,
            },
        ],
        result => sub {
            $app->model('formatted_text')->load(
                {   blog_id => 1,
                    label   => 'create-formatted-text',
                }
            );
        },
    },

    # list_formatted_texts - irregular tests
    {    # Non-existent site.
        path   => '/v2/sites/5/formatted_texts',
        method => 'GET',
        code   => 404,
    },

    # list_formatted_texts - normal tests
    {   path      => '/v2/sites/1/formatted_texts',
        method    => 'GET',
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.formatted_text',
                count => 2,
            },
        ],
    },
    {    # System.
        path      => '/v2/sites/0/formatted_texts',
        method    => 'GET',
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.formatted_text',
                count => 2,
            },
        ],
    },
    {    # search label in blog scope.
        path      => '/v2/sites/1/formatted_texts',
        method    => 'GET',
        params    => { search => 'blog', },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.formatted_text',
                count => 2,
            },
        ],
        result => sub {
            $app->user($author);

            my @fts = $app->model('formatted_text')->load(
                { blog_id => 1 },
                { sort    => 'created_on', direction => 'descend' },
            );

            my @greped_fts;
            for my $ft (@fts) {
                if ( grep { $ft->$_() && $ft->$_() =~ m/blog/ }
                    qw/ label text description / )
                {
                    push @greped_fts, $ft;
                }
            }

            require boolean;
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};
            return +{
                totalResults => scalar @greped_fts,
                items => MT::DataAPI::Resource->from_object( \@greped_fts ),
            };
        },
    },
    {    # search label in system scope.
        path      => '/v2/sites/0/formatted_texts',
        method    => 'GET',
        params    => { search => 'blog', },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.formatted_text',
                count => 2,
            },
        ],
        result => sub {
            $app->user($author);

            my @fts
                = $app->model('formatted_text')
                ->load( undef,
                { sort => 'created_on', direction => 'descend' },
                );

            my @greped_fts;
            for my $ft (@fts) {
                if ( grep { $ft->$_() && $ft->$_() =~ m/blog/ }
                    qw/ label text description / )
                {
                    push @greped_fts, $ft;
                }
            }

            require boolean;
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};
            return +{
                totalResults => scalar @greped_fts,
                items => MT::DataAPI::Resource->from_object( \@greped_fts ),
            };
        },
    },
    {    # search text in blog scope.
        path      => '/v2/sites/1/formatted_texts',
        method    => 'GET',
        params    => { search => 'blog_text', },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.formatted_text',
                count => 2,
            },
        ],
        result => sub {
            $app->user($author);

            my @fts = $app->model('formatted_text')->load(
                { blog_id => 1 },
                { sort    => 'created_on', direction => 'descend' },
            );

            my @greped_fts;
            for my $ft (@fts) {
                if ( grep { $ft->$_() && $ft->$_() =~ m/blog_text/ }
                    qw/ label text description / )
                {
                    push @greped_fts, $ft;
                }
            }

            require boolean;
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};
            return +{
                totalResults => scalar @greped_fts,
                items => MT::DataAPI::Resource->from_object( \@greped_fts ),
            };
        },
    },
    {    # search description in blog scope.
        path      => '/v2/sites/1/formatted_texts',
        method    => 'GET',
        params    => { search => 'blog_description', },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.formatted_text',
                count => 2,
            },
        ],
        result => sub {
            $app->user($author);

            my @fts = $app->model('formatted_text')->load(
                { blog_id => 1 },
                { sort    => 'created_on', direction => 'descend' },
            );

            my @greped_fts;
            for my $ft (@fts) {
                if ( grep { $ft->$_() && $ft->$_() =~ m/blog_description/ }
                    qw/ label text description / )
                {
                    push @greped_fts, $ft;
                }
            }

            require boolean;
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};
            return +{
                totalResults => scalar @greped_fts,
                items => MT::DataAPI::Resource->from_object( \@greped_fts ),
            };
        },
    },
    {    # Can sort by id.
        path      => '/v2/sites/1/formatted_texts',
        method    => 'GET',
        params    => { sortBy => 'id', sortOrder => 'ascend' },
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.formatted_text',
                count => 2,
            },
        ],
        result => sub {
            $app->user($author);

            my @fts = $app->model('formatted_text')->load(
                { blog_id => 1 },
                { sort    => 'id', direction => 'ascend' },
            );

            require boolean;
            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};
            return +{
                totalResults => scalar @fts,
                items        => MT::DataAPI::Resource->from_object( \@fts ),
            };
        },
    },
    {    # Can sort by blog_id.
        path   => '/v2/sites/1/formatted_texts',
        method => 'GET',
        params => { sortBy => 'blog_id' },
    },
    {    # Can sort by created_by.
        path   => '/v2/sites/1/formatted_texts',
        method => 'GET',
        params => { sortBy => 'created_by' },
    },
    {    # Can sort by label.
        path   => '/v2/sites/1/formatted_texts',
        method => 'GET',
        params => { sortBy => 'label' },
    },
    {    # Can sort by modified_on.
        path   => '/v2/sites/1/formatted_texts',
        method => 'GET',
        params => { sortBy => 'modified_on' },
    },

    # update_formatted_text - irregular tests
    {    # Non-existent formatted text.
        path   => '/v2/sites/1/formatted_texts/10',
        method => 'PUT',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Formatted_text not found',
                },
            };
        },
    },
    {    # Non-existent site.
        path   => '/v2/sites/5/formatted_texts/' . $ft_blog->id,
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
        path   => '/v2/sites/1/formatted_texts/' . $ft_website->id,
        method => 'PUT',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Formatted_text not found',
                },
            };
        },
    },
    {    # Other site (system).
        path   => '/v2/sites/0/formatted_texts/' . $ft_blog->id,
        method => 'PUT',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Formatted_text not found',
                },
            };
        },
    },
    {    # No resource.
        path   => '/v2/sites/1/formatted_texts/' . $ft_blog->id,
        method => 'PUT',
        code   => 400,
        result => sub {
            +{  error => {
                    code    => 400,
                    message => 'A resource "formatted_text" is required.',
                },
            };
        },
    },
    {    # Duplicated.
        path   => '/v2/sites/1/formatted_texts/' . $ft_blog->id,
        method => 'PUT',
        params =>
            { formatted_text => { label => 'create-formatted-text', }, },
        code   => 409,
        result => sub {
            +{  error => {
                    code => 409,
                    message =>
                        "The boilerplate 'create-formatted-text' is already in use in this site.\n",
                },
            };
        },
    },

    # update_formatted_text - normal tests
    {   path   => '/v2/sites/1/formatted_texts/' . $ft_blog->id,
        method => 'PUT',
        params =>
            { formatted_text => { label => 'update-formatted-text', }, },
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_save_permission_filter.formatted_text',
                count => 1,
            },
            {   name =>
                    'MT::App::DataAPI::data_api_save_filter.formatted_text',
                count => 1,
            },
            {   name  => 'MT::App::DataAPI::data_api_pre_save.formatted_text',
                count => 1,
            },
            {   name => 'MT::App::DataAPI::data_api_post_save.formatted_text',
                count => 1,
            },
        ],
        result => sub {
            $app->model('formatted_text')->load(
                {   id      => $ft_blog->id,
                    blog_id => 1,
                    label   => 'update-formatted-text',
                }
            );
        },
    },

    # delete_formatted_text - irregular tests
    {    # Non-existent formatted text.
        path   => '/v2/sites/1/formatted_texts/100',
        method => 'DELETE',
        code   => 404,
    },
    {    # Non-existent site.
        path   => '/v2/sites/5/formatted_texts/' . $ft_blog->id,
        method => 'DELETE',
        code   => 404,
    },
    {    # Other site.
        path   => '/v2/sites/2/formatted_texts/' . $ft_blog->id,
        method => 'DELETE',
        code   => 404,
    },
    {    # Other site (system).
        path   => '/v2/sites/0/formatted_texts/' . $ft_blog->id,
        method => 'DELETE',
        code   => 404,
    },

    # delete_formatted_text - normal tests
    {   path   => '/v2/sites/1/formatted_texts/' . $ft_blog->id,
        method => 'DELETE',
        setup  => sub {
            die if !$app->model('formatted_text')->load( $ft_blog->id );
        },
        callbacks => [
            {   name =>
                    'MT::App::DataAPI::data_api_delete_permission_filter.formatted_text',
                count => 1,
            },
        ],
        complete => sub {
            my $deleted_ft
                = $app->model('formatted_text')->load( $ft_blog->id );
            is( $deleted_ft, undef, 'Deleted formatted text.' );
        },
    },

);

my $mock_mt = Test::MockModule->new('MT');
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
