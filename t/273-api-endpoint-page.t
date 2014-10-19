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
my $version;
$mock_app_api->mock( 'current_api_version',
    sub { $version = $_[1] if $_[1]; $version } );

my @suite = (

    # list_pages - irregualr tests
    {    # Non-existent site.
        path   => '/v2/sites/5/pages',
        method => 'GET',
        code   => 404,
    },

    # list_pages - normal tests
    {   path      => '/v2/sites/1/pages',
        method    => 'GET',
        callbacks => [
            {   name  => 'data_api_pre_load_filtered_list.page',
                count => 2,
            },
        ],
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

#    {   path      => '/v1/sites/1/entries',
#        method    => 'GET',
#        callbacks => [
#            {   name  => 'data_api_pre_load_filtered_list.entry',
#                count => 2,
#            },
#        ],
#    },
#    {   path   => '/v1/sites/1/entries',
#        method => 'POST',
#        params => {
#            entry => {
#                title  => 'test-api-permission-entry',
#                status => 'Draft',
#            },
#        },
#        callbacks => [
#            {   name =>
#                    'MT::App::DataAPI::data_api_save_permission_filter.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_save_filter.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_pre_save.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_post_save.entry',
#                count => 1,
#            },
#        ],
#        result => sub {
#            require MT::Entry;
#            MT->model('entry')->load(
#                {   title  => 'test-api-permission-entry',
#                    status => MT::Entry::HOLD(),
#                }
#            );
#        },
#        complete => sub {
#            my ( $data, $body ) = @_;
#            require MT::Entry;
#            my $entry = MT->model('entry')->load(
#                {   title  => 'test-api-permission-entry',
#                    status => MT::Entry::HOLD(),
#                }
#            );
#            is( $entry->revision, 1, 'Has created new revision' );
#        },
#    },
#    {   path   => '/v1/sites/1/entries/0',
#        method => 'GET',
#        code   => 404,
#    },
#    {   path      => '/v1/sites/1/entries/1',
#        method    => 'GET',
#        callbacks => [
#            {   name =>
#                    'MT::App::DataAPI::data_api_view_permission_filter.entry',
#                count => 1,
#            },
#        ],
#    },
#    {   path   => '/v1/sites/1/entries/1',
#        method => 'PUT',
#        setup  => sub {
#            my ($data) = @_;
#            $data->{_revision} = MT->model('entry')->load(1)->revision || 0;
#        },
#        params =>
#            { entry => { title => 'update-test-api-permission-entry', }, },
#        callbacks => [
#            {   name =>
#                    'MT::App::DataAPI::data_api_save_permission_filter.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_save_filter.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_pre_save.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_post_save.entry',
#                count => 1,
#            },
#        ],
#        result => sub {
#            MT->model('entry')->load(
#                {   id    => 1,
#                    title => 'update-test-api-permission-entry',
#                }
#            );
#        },
#        complete => sub {
#            my ( $data, $body ) = @_;
#            is( MT->model('entry')->load(1)->revision - $data->{_revision},
#                1, 'Bumped-up revision number' );
#        },
#    },
#    {   path     => '/v1/sites/1/entries/1',
#        method   => 'PUT',
#        params   => { entry => { tags => [qw(a)] }, },
#        complete => sub {
#            is_deeply( [ MT->model('entry')->load(1)->tags ],
#                [qw(a)], "Entry's tag is updated" );
#        },
#    },
#    {   path     => '/v1/sites/1/entries/1',
#        method   => 'PUT',
#        params   => { entry => { tags => [qw(a b)] }, },
#        complete => sub {
#            is_deeply( [ MT->model('entry')->load(1)->tags ],
#                [qw(a b)], "Entry's tag is added" );
#        },
#    },
#    {   path     => '/v1/sites/1/entries/1',
#        method   => 'PUT',
#        params   => { entry => { tags => [] }, },
#        complete => sub {
#            is_deeply( [ MT->model('entry')->load(1)->tags ],
#                [], "Entry's tag is removed" );
#        },
#    },
#    {   path      => '/v1/sites/1/entries/1',
#        method    => 'DELETE',
#        callbacks => [
#            {   name =>
#                    'MT::App::DataAPI::data_api_delete_permission_filter.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_post_delete.entry',
#                count => 1,
#            },
#        ],
#        complete => sub {
#            my $deleted = MT->model('entry')->load(1);
#            is( $deleted, undef, 'deleted' );
#        },
#    },
#    {   path      => '/v1/sites/2/entries',
#        method    => 'GET',
#        callbacks => [
#            {   name  => 'data_api_pre_load_filtered_list.entry',
#                count => 1,
#            },
#        ],
#    },
#    {   path   => '/v2/sites/1/entries',
#        method => 'POST',
#        params => {
#            entry => {
#                title      => 'test-api-attach-categories-to-entry',
#                status     => 'Draft',
#                categories => [ { id => 1 } ],
#            },
#        },
#        callbacks => [
#            {   name =>
#                    'MT::App::DataAPI::data_api_save_permission_filter.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_save_filter.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_pre_save.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_post_save.entry',
#                count => 1,
#            },
#        ],
#        result => sub {
#            require MT::Entry;
#            MT->model('entry')->load(
#                {   title  => 'test-api-attach-categories-to-entry',
#                    status => MT::Entry::HOLD(),
#                }
#            );
#        },
#        complete => sub {
#            my ( $data, $body ) = @_;
#            require MT::Entry;
#            my $entry = MT->model('entry')->load(
#                {   title  => 'test-api-attach-categories-to-entry',
#                    status => MT::Entry::HOLD(),
#                }
#            );
#            is( $entry->revision, 1, 'Has created new revision' );
#            my @categories = @{ $entry->categories };
#            is( scalar @categories, 1, 'Attaches a category' );
#            is( $categories[0]->id, 1, 'Attached category ID is 1' );
#        },
#    },
#    {   path   => '/v2/sites/1/entries/2',
#        method => 'PUT',
#        params => {
#            entry => {
#                title      => 'test-api-update-categories',
#                categories => [ { id => 1 }, { id => 2 }, { id => 3 } ]
#            },
#        },
#        callbacks => [
#            {   name =>
#                    'MT::App::DataAPI::data_api_save_permission_filter.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_save_filter.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_pre_save.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_post_save.entry',
#                count => 1,
#            },
#        ],
#        result => sub {
#            MT->model('entry')->load(
#                {   id    => 2,
#                    title => 'test-api-update-categories',
#                }
#            );
#        },
#        complete => sub {
#            my ( $data, $body ) = @_;
#            my $entry      = MT->model('entry')->load(2);
#            my @categories = @{ $entry->categories };
#            is( scalar @categories, 3, 'Entry has 3 category' );
#        },
#    },
#    {   path   => '/v2/sites/1/entries/2',
#        method => 'PUT',
#        params =>
#            { entry => { categories => [ { id => 2 }, { id => 3 } ] }, },
#        callbacks => [
#            {   name =>
#                    'MT::App::DataAPI::data_api_save_permission_filter.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_save_filter.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_pre_save.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_post_save.entry',
#                count => 1,
#            },
#        ],
#        result => sub {
#            MT->model('entry')->load(
#                {   id    => 2,
#                    title => 'test-api-update-categories',
#                }
#            );
#        },
#        complete => sub {
#            my ( $data, $body ) = @_;
#            my $entry      = MT->model('entry')->load(2);
#            my @categories = @{ $entry->categories };
#            is( scalar @categories, 2, 'Entry has 2 category' );
#        },
#    },
#    {   path   => '/v2/sites/1/entries/2',
#        method => 'PUT',
#        params => { entry => { categories => [ id => 20 ] } },
#        code   => 400,
#    },
#    {   path   => '/v2/sites/1/entries',
#        method => 'POST',
#        params => {
#            entry => {
#                title  => 'test-api-attach-assets-to-entry',
#                status => 'Draft',
#                assets => [ { id => 1 } ],
#            },
#        },
#        callbacks => [
#            {   name =>
#                    'MT::App::DataAPI::data_api_save_permission_filter.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_save_filter.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_pre_save.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_post_save.entry',
#                count => 1,
#            },
#        ],
#        result => sub {
#            require MT::Entry;
#            MT->model('entry')->load(
#                {   title  => 'test-api-attach-assets-to-entry',
#                    status => MT::Entry::HOLD(),
#                }
#            );
#        },
#        complete => sub {
#            my ( $data, $body ) = @_;
#            require MT::Entry;
#            my $entry = MT->model('entry')->load(
#                {   title  => 'test-api-attach-assets-to-entry',
#                    status => MT::Entry::HOLD(),
#                }
#            );
#            is( $entry->revision, 1, 'Has created new revision' );
#            my @assets = MT->model('asset')->load(
#                { class => '*' },
#                {   join => MT->model('objectasset')->join_on(
#                        'asset_id',
#                        {   object_ds => 'entry',
#                            object_id => $entry->id,
#                            asset_id  => 1,
#                        },
#                    ),
#                }
#            );
#            is( scalar @assets, 1, 'Attaches an asset' );
#            is( $assets[0]->id, 1, 'Attached asset ID is 1' );
#        },
#    },
#    {   path   => '/v2/sites/1/entries/2',
#        method => 'PUT',
#        params => {
#            entry => {
#                title  => 'test-api-update-assets',
#                assets => [ { id => 1 }, { id => 2 } ],
#            },
#        },
#        callbacks => [
#            {   name =>
#                    'MT::App::DataAPI::data_api_save_permission_filter.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_save_filter.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_pre_save.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_post_save.entry',
#                count => 1,
#            },
#        ],
#        result => sub {
#            MT->model('entry')->load(
#                {   id    => 2,
#                    title => 'test-api-update-assets',
#                }
#            );
#        },
#        complete => sub {
#            my ( $data, $body ) = @_;
#            my $entry = MT->model('entry')->load(2);
#            my @oa    = MT->model('objectasset')->load(
#                {   object_ds => 'entry',
#                    object_id => $entry->id,
#                }
#            );
#            is( scalar @oa, 2, 'Entry has 2 assets' );
#        },
#    },
#    {   path   => '/v2/sites/1/entries/2',
#        method => 'PUT',
#        params => {
#            entry => {
#                title  => 'test-api-update-assets',
#                assets => [ { id => 2 } ],
#            },
#        },
#        callbacks => [
#            {   name =>
#                    'MT::App::DataAPI::data_api_save_permission_filter.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_save_filter.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_pre_save.entry',
#                count => 1,
#            },
#            {   name  => 'MT::App::DataAPI::data_api_post_save.entry',
#                count => 1,
#            },
#        ],
#        result => sub {
#            MT->model('entry')->load(
#                {   id    => 2,
#                    title => 'test-api-update-assets',
#                }
#            );
#        },
#        complete => sub {
#            my ( $data, $body ) = @_;
#            my $entry = MT->model('entry')->load(2);
#            my @oa    = MT->model('objectasset')->load(
#                {   object_ds => 'entry',
#                    object_id => $entry->id,
#                }
#            );
#            is( scalar @oa, 1, 'Entry has 1 asset' );
#        },
#    },
#    {   path      => '/v2/sites/1/entries/2/assets',
#        method    => 'GET',
#        callbacks => [
#            {   name =>
#                    'MT::App::DataAPI::data_api_view_permission_filter.entry',
#                count => 1,
#            },
#            {   name  => 'data_api_pre_load_filtered_list.asset',
#                count => 2,
#            },
#        ],
#        complete => sub {
#            my ( $data, $body ) = @_;
#            my $result = MT::Util::from_json($body);
#            is( $result->{totalResults}, 1, 'Entry has 1 asset' );
#
#            my $entry  = MT->model('entry')->load(2);
#            my @assets = MT->model('asset')->load(
#                { class => '*' },
#                {   join => MT->model('objectasset')->join_on(
#                        'asset_id',
#                        {   blog_id   => $entry->blog->id,
#                            object_ds => 'entry',
#                            object_id => $entry->id,
#                        },
#                    ),
#                }
#            );
#            my @json_ids
#                = sort { $a <=> $b } map { $_->{id} } @{ $result->{items} };
#            my @asset_ids = sort { $a <=> $b } map { $_->id } @assets;
#            is_deeply( \@json_ids, \@asset_ids, 'Asset IDs are correct' );
#        },
#    },
#    {   path     => '/v2/sites/1/categories/1/entries',
#        method   => 'GET',
#        complete => sub {
#            my ( $data, $body ) = @_;
#            my $result = MT::Util::from_json($body);
#
#            my $cat     = MT->model('category')->load(1);
#            my @entries = MT->model('entry')->load(
#                { class => 'entry' },
#                {   join => MT->model('placement')->join_on(
#                        'entry_id',
#                        {   blog_id     => $cat->blog_id,
#                            category_id => $cat->id,
#                        },
#                    ),
#                }
#            );
#
#            is( $result->{totalResults},
#                scalar @entries,
#                'Category has ' . scalar @entries . 'entries'
#            );
#
#            my @json_ids
#                = sort { $a <=> $b } map { $_->{id} } @{ $result->{items} };
#            my @entry_ids = sort { $a <=> $b } map { $_->id } @entries;
#            is_deeply( \@json_ids, \@entry_ids, 'Entry IDs are correct' );
#            }
#    },
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
