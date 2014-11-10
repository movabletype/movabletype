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

use MT::Theme;
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

my $tmpl_class = $app->model('template');

my $email_tmpl = $tmpl_class->load( { blog_id => 0, type => 'email' } )
    or die $tmpl_class->errstr;
my $blog_index_tmpl = $tmpl_class->load( { blog_id => 1, type => 'index' } )
    or die $tmpl_class->errstr;
my $blog_tmpl_module = $tmpl_class->load( { blog_id => 1, type => 'custom' } )
    or die $tmpl_class->errstr;
my $website_tmpl_module
    = $tmpl_class->load( { blog_id => 2, type => 'custom' } )
    or die $tmpl_class->errstr;
my $system_tmpl = $tmpl_class->new;
$system_tmpl->set_values(
    {   blog_id    => 0,
        name       => 'system template',
        identifier => 'system_template',
        type       => 'system_template',
    }
);
$system_tmpl->save or die $system_tmpl->errstr;

my @suite = (

    # create_template - irregular tests
    {    # No resource.
        path     => '/v2/sites/2/templates',
        method   => 'POST',
        code     => 400,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                'A resource "template" is required.' );
        },
    },
    {    # No name.
        path     => '/v2/sites/2/templates',
        method   => 'POST',
        params   => { template => {}, },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"name\" is required.\n" );
        },
    },
    {    # No type.
        path     => '/v2/sites/2/templates',
        method   => 'POST',
        params   => { template => { name => 'create-template', }, },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"type\" is required.\n" );
        },
    },
    {    # Invalid type.
        path   => '/v2/sites/2/templates',
        method => 'POST',
        params => {
            template => {
                name => 'create-template',
                type => 'invalid-type',
            },
        },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body, "Invalid type: invalid-type\n" );
        },
    },
    {    # Invalid type (system).
        path   => '/v2/sites/0/templates',
        method => 'POST',
        params => {
            template => {
                name => 'create-template',
                type => 'index',
            },
        },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body, "Invalid type: index\n" );
        },
    },
    {    # No outputFile.
        path   => '/v2/sites/2/templates',
        method => 'POST',
        params => {
            template => {
                name => 'create-template',
                type => 'index',
            },
        },
        code     => 409,
        complete => sub {
            my ( $data, $body ) = @_;
            check_error_message( $body,
                "A parameter \"outputFile\" is required.\n" );
        },
    },

    # create_template - normal tests
    {   path   => '/v2/sites/2/templates',
        method => 'POST',
        setup  => sub {
            die
                if $app->model('template')->exist(
                {   blog_id => 2,
                    name    => 'create-template',
                }
                );
        },
        params => {
            template => {
                name       => 'create-template',
                type       => 'index',
                outputFile => 'create_template.html',
            },
        },
        result => sub {
            $app->model('template')->load(
                {   blog_id => 2,
                    name    => 'create-template',
                    outfile => 'create_template.html',
                }
            );
        },
    },

    # list_templates - irregular tests
    {    # Non-existent site.
        path   => '/v2/sites/5/templates',
        method => 'GET',
        code   => 404,
    },

    # list_templates - normal tests
    {   path   => '/v2/sites/2/templates',
        method => 'GET',
        result => sub {
            my @terms_args = (
                {   blog_id => 2,
                    type    => { not => [qw( backup widget widgetset )] },
                },
                {   sort      => 'name',
                    direction => 'ascend',
                    limit     => 10,
                },
            );

            my $total_results = $app->model('template')->count(@terms_args);
            my @tmpl          = $app->model('template')->load(@terms_args);

            $app->user($author);

            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => $total_results,
                items        => MT::DataAPI::Resource->from_object( \@tmpl ),
            };
        },
    },
    {    # Search name.
        path   => '/v2/sites/2/templates',
        method => 'GET',
        params => {
            searchFields => 'name',
            search       => 'create-template',
        },
        result => sub {
            my @tmpl = $app->model('template')->load(
                {   blog_id => 2,
                    name    => { like => '%create-template%' },
                },
                {   sort      => 'name',
                    direction => 'ascend',
                },
            );

            $app->user($author);

            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => 1,
                items        => MT::DataAPI::Resource->from_object( \@tmpl ),
            };
        },
    },
    {    # Search identifier.
        path   => '/v2/sites/2/templates',
        method => 'GET',
        params => {
            searchFields => 'templateType',
            search       => 'banner_footer',
        },
        result => sub {
            my @tmpl = $app->model('template')->load(
                {   blog_id    => 2,
                    identifier => { like => '%banner_footer%' },
                },
                {   sort      => 'name',
                    direction => 'ascend',
                },
            );

            $app->user($author);

            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => 1,
                items        => MT::DataAPI::Resource->from_object( \@tmpl ),
            };
        },
    },
    {    # Search text.
        path   => '/v2/sites/2/templates',
        method => 'GET',
        params => {
            searchFields => 'text',
            search       => 'DOCTYPE',
        },
        result => sub {
            my @terms_args = (
                {   blog_id => 2,
                    text    => { like => '%DOCTYPE%' },
                },
                {   sort      => 'name',
                    direction => 'ascend',
                    limit     => 10,
                },
            );

            my $total_count = $app->model('template')->count(@terms_args);
            my @tmpl        = $app->model('template')->load(@terms_args);

            $app->user($author);

            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => $total_count,
                items        => MT::DataAPI::Resource->from_object( \@tmpl ),
            };
        },
    },
    {    # Filter by type.
        path   => '/v2/sites/2/templates',
        method => 'GET',
        params => { type => 'index', },
        result => sub {
            my @tmpl = $app->model('template')->load(
                {   blog_id => 2,
                    type    => 'index',
                },
                {   sort      => 'name',
                    direction => 'ascend',
                },
            );

            $app->user($author);

            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => scalar @tmpl,
                items        => MT::DataAPI::Resource->from_object( \@tmpl ),
            };
        },
    },
    {    # Sort by id.
        path   => '/v2/sites/2/templates',
        method => 'GET',
        params => { sortBy => 'id', },
    },
    {    # Sort by created_on.
        path   => '/v2/sites/2/templates',
        method => 'GET',
        params => { sortBy => 'created_on', },
    },
    {    # Sort by modified_on.
        path   => '/v2/sites/2/templates',
        method => 'GET',
        params => { sortBy => 'modified_on', },
    },
    {    # Sort by created_by.
        path   => '/v2/sites/2/templates',
        method => 'GET',
        params => { sortBy => 'created_by', },
    },
    {    # Sort by modified_by.
        path   => '/v2/sites/2/templates',
        method => 'GET',
        params => { sortBy => 'modified_by', },
    },
    {    # Sort by type.
        path   => '/v2/sites/2/templates',
        method => 'GET',
        params => { sortBy => 'type', },
    },

    # list_all_templates - normal tests
    {   path   => '/v2/templates',
        method => 'GET',
        result => sub {
            my @terms_args = (
                { type => { not => [qw/ backup widget widgetset /] }, },
                {   sort      => 'blog_id',
                    direction => 'ascend',
                    limit     => 10,
                },
            );

            my $total_results = $app->model('template')->count(@terms_args);
            my @tmpl          = $app->model('template')->load(@terms_args);

            $app->user($author);

            no warnings 'redefine';
            local *boolean::true  = sub {'true'};
            local *boolean::false = sub {'false'};

            return +{
                totalResults => $total_results,
                items        => MT::DataAPI::Resource->from_object( \@tmpl ),
            };
        },
    },

    # get_template - irregular tests
    {    # Non-existent template.
        path   => '/v2/sites/2/templates/300',
        method => 'GET',
        code   => 404,
    },
    {    # Non-existent site.
        path   => '/v2/sites/5/templates/' . $website_tmpl_module->id,
        method => 'GET',
        code   => 404,
    },
    {    # Other site.
        path   => '/v2/sites/1/templates/' . $website_tmpl_module->id,
        method => 'GET',
        code   => 404,
    },
    {    # Other site (system).
        path   => '/v2/sites/0/templates/' . $website_tmpl_module->id,
        method => 'GET',
        code   => 404,
    },

    # get_template - normal tests
    {   path   => '/v2/sites/2/templates/' . $website_tmpl_module->id,
        method => 'GET',
        result => sub {
            $website_tmpl_module;
        },
    },

    # update_template - irregular tests
    {    # Non-existent template.
        path   => '/v2/sites/2/templates/500',
        method => 'PUT',
        params => {
            template => {
                name => 'update-template',
                type => 'custom',
            },
        },
        code => 404,
    },

    # update_template - normal tests
    {   path   => '/v2/sites/2/templates/' . $website_tmpl_module->id,
        method => 'PUT',
        params => { template => { name => 'update-template', }, },
        result => sub {
            $app->model('template')->load( $website_tmpl_module->id );
        },
    },

    # delete_template - irregular tests
    {    # Non-existent template.
        path   => '/v2/sites/2/templates/300',
        method => 'DELETE',
        code   => 404,
    },
    {    # Non-existent site.
        path   => '/v2/sites/5/templates/' . $website_tmpl_module->id,
        method => 'DELETE',
        code   => 404,
    },
    {    # Other site.
        path   => '/v2/sites/1/templates/' . $website_tmpl_module->id,
        method => 'DELETE',
        code   => 404,
    },
    {    # Other site (system).
        path   => '/v2/sites/0/templates/' . $website_tmpl_module->id,
        method => 'DELETE',
        code   => 404,
    },
    {    # Email template.
        path   => '/v2/sites/0/templates/' . $email_tmpl->id,
        method => 'DELETE',
        code   => 403,
    },
    {    # System template.
        path   => '/v2/sites/0/templates/' . $system_tmpl->id,
        method => 'DELETE',
        code   => 403,
    },

    # delete_template - normal tests
    {   path   => '/v2/sites/2/templates/' . $website_tmpl_module->id,
        method => 'DELETE',
        setup  => sub {
            die if !$app->model('template')->load( $website_tmpl_module->id );
        },
        complete => sub {
            my $tmpl
                = $app->model('template')->load( $website_tmpl_module->id );
            is( $tmpl, undef, 'Deleted template.' );
        },
    },

    # publish_template - irregular tests
    {    # Template module.
        path => '/v2/sites/1/templates/' . $blog_tmpl_module->id . '/publish',
        method => 'POST',
        code   => 400,
    },

    # publish_template - normal tests
    {    # Index template.
        path => '/v2/sites/1/templates/' . $blog_index_tmpl->id . '/publish',
        method => 'POST',
        result => sub {
            return +{ status => 'success' };
        },
    },

    # refresh_template - irregular tests
    {   path   => '/v2/sites/1/templates/300/refresh',
        method => 'POST',
        code   => 404,
    },

    # refresh_template - normal tests
    {   path => '/v2/sites/1/templates/' . $blog_index_tmpl->id . '/refresh',
        method => 'POST',
    },

    # refresh_templates_for_site - irregular tests
    {    # Non-existent site.
        path   => '/v2/sites/5/refresh_templates',
        method => 'POST',
        code   => 404,
        result => sub {
            +{  error => {
                    code    => 404,
                    message => 'Site not found',
                },
            };
        },
    },
    {    # Invalid parameter.
        path   => '/v2/sites/2/refresh_templates',
        method => 'POST',
        params => { refresh_type => 'dummy', },
        code   => 400,
        result => sub {
            +{  error => {
                    code    => 400,
                    message => 'A parameter "refresh_type" is invalid: dummy',
                },
            };
        },
    },

    # refresh_templates_for_site - normal tests
    {    # Website.
        path   => '/v2/sites/2/refresh_templates',
        method => 'POST',
        result => sub {
            +{ status => 'success' };
        },
    },
    {    # Blog.
        path   => '/v2/sites/1/refresh_templates',
        method => 'POST',
        result => sub {
            +{ status => 'success' };
        },
    },
    {    # System.
        path   => '/v2/sites/0/refresh_templates',
        method => 'POST',
        result => sub {
            +{ status => 'success' };
        },
    },

    {    # Back up.
        path   => '/v2/sites/2/refresh_templates',
        method => 'POST',
        params => { backup => 1, },
        result => sub {
            +{ status => 'success' };
        },
    },
    {    # Refresh.
        path   => '/v2/sites/2/refresh_templates',
        method => 'POST',
        params => { refresh_type => 'refresh', },
        result => sub {
            +{ status => 'success' };
        },
    },
    {    # Reset.
        path   => '/v2/sites/2/refresh_templates',
        method => 'POST',
        params => { refresh_type => 'clean', },
        result => sub {
            +{ status => 'success' };
        },
    },

    # clone_template - irregular tests
    {    # Email template.
        path   => '/v2/sites/0/templates/' . $email_tmpl->id . '/clone',
        method => 'POST',
        code   => 400,
    },
    {    # System template.
        path   => '/v2/sites/0/templates/' . $system_tmpl->id . '/clone',
        method => 'POST',
        code   => 400,
    },

    # clone_template - normal tests
    {   path   => '/v2/sites/1/templates/' . $blog_index_tmpl->id . '/clone',
        method => 'POST',
        result => sub {
            return +{ status => 'success' };
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
