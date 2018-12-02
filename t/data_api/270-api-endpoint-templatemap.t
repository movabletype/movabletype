#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;

BEGIN {
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::DataAPI;
use MT::Test::Permission;

$test_env->prepare_fixture('db_data');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

# preparation.
my $mock_perm   = Test::MockModule->new('MT::Permission');
my $mock_author = Test::MockModule->new('MT::Author');

my $author = MT->model('author')->load(1);
$author->email('melody@example.com');
$author->save;

my $ct1 = MT::Test::Permission->make_content_type( blog_id => 1 );
my $ct2 = MT::Test::Permission->make_content_type( blog_id => 1 );

my $template_class = $app->model('template');

my $blog_individual_tmpl
    = $template_class->load( { blog_id => 1, type => 'individual' } )
    or die $template_class->errstr;
my $blog_individual_tmpl_id = $blog_individual_tmpl->id;

my $blog_index_tmpl
    = $template_class->load( { blog_id => 1, type => 'index' } )
    or die $template_class->errstr;
my $blog_index_tmpl_id = $blog_index_tmpl->id;

my $tmplmap_class = $app->model('templatemap');

my $blog_tmplmap
    = $tmplmap_class->load(
    { blog_id => 1, template_id => $blog_individual_tmpl_id } )
    or die $tmplmap_class->errstr;
my $blog_tmplmap_id = $blog_tmplmap->id;

my $blog_other_tmplmap
    = $tmplmap_class->load(
    { blog_id => 1, template_id => { not => $blog_individual_tmpl_id } } )
    or die $tmplmap_class->errstr;
my $blog_other_tmplmap_id = $blog_other_tmplmap->id;

my $blog_other_site_tmplmap = $tmplmap_class->load( { blog_id => 2 } )
    or die $tmplmap_class->errstr;
my $blog_other_site_tmplmap_id = $blog_other_site_tmplmap->id;

my $blog_ct1_tmpl = MT::Test::Permission->make_template(
    blog_id         => 1,
    content_type_id => $ct1->id,
    type            => 'ct',
);
my $blog_ct1_archive_tmpl = MT::Test::Permission->make_template(
    blog_id         => 1,
    content_type_id => $ct1->id,
    type            => 'ct_archive',
);
my $blog_ct1_tmpl_id         = $blog_ct1_tmpl->id;
my $blog_ct1_archive_tmpl_id = $blog_ct1_archive_tmpl->id;

my $blog_ct1_tmplmap = MT::Test::Permission->make_templatemap(
    archive_type => 'ContentType',
    blog_id => 1,
    is_preferred => 1,
    template_id => $blog_ct1_tmpl_id,
);
my $blog_ct1_archive_tmplmap = MT::Test::Permission->make_templatemap(
    archive_type => 'ContentType-Daily',
    blog_id => 1,
    is_preferred => 1,
    template_id => $blog_ct1_archive_tmpl_id,
);
my $blog_ct1_tmplmap_id = $blog_ct1_tmplmap->id,;
my $blog_ct1_archive_tmplmap_id = $blog_ct1_archive_tmpl->id;

my $blog_ct2_tmpl = MT::Test::Permission->make_template(
    blog_id         => 1,
    content_type_id => $ct2->id,
    type            => 'ct',
);
my $blog_ct2_archive_tmpl = MT::Test::Permission->make_template(
    blog_id         => 1,
    content_type_id => $ct2->id,
    type            => 'ct_archive',
);
my $blog_ct2_tmpl_id         = $blog_ct2_tmpl->id;
my $blog_ct2_archive_tmpl_id = $blog_ct2_archive_tmpl->id;

my $blog_ct2_tmplmap = MT::Test::Permission->make_templatemap(
    archive_type => 'ContentType',
    blog_id => 1,
    is_preferred => 1,
    template_id => $blog_ct2_tmpl_id,
);
my $blog_ct2_archive_tmplmap = MT::Test::Permission->make_templatemap(
    archive_type => 'ContentType-Author-Monthly',
    blog_id => 1,
    is_preferred => 1,
    template_id => $blog_ct2_archive_tmpl_id,
);
my $blog_ct2_tmplmap_id = $blog_ct2_tmplmap->id;
my $blog_ct2_archive_tmplmap_id = $blog_ct2_archive_tmplmap->id;


# test.
my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

        # create_templatemap - irregular tests
        {    # Non-existent template.
            path   => '/v2/sites/1/templates/500/templatemaps',
            method => 'POST',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Template not found',
                    },
                };
            },
        },
        {    # Non-existent site.
            path =>
                "/v2/sites/5/templates/$blog_individual_tmpl_id/templatemaps",
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
        {    # Other site.
            path =>
                "/v2/sites/2/templates/$blog_individual_tmpl_id/templatemaps",
            method => 'POST',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Template not found',
                    },
                };
            },
        },
        {    # Other site (system).
            path =>
                "/v2/sites/0/templates/$blog_individual_tmpl_id/templatemaps",
            method => 'POST',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Template not found',
                    },
                };
            },
        },
        {    # Not archive template.
            path => "/v2/sites/1/templates/$blog_index_tmpl_id/templatemaps",
            method => 'POST',
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'Template "'
                            . $blog_index_tmpl->name
                            . '" is not an archive template.',
                    },
                };
            },
        },
        {    # No resource.
            path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps",
            method => 'POST',
            code   => 400,
            error  => 'A resource "templatemap" is required.',
        },
        {    # No arhichiveType.
            path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps",
            method => 'POST',
            params => { templatemap => {}, },
            code   => 409,
            error  => "A parameter \"archiveType\" is required.\n",
        },
        {    # Invalid archiveType.
            path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps",
            method => 'POST',
            params => { templatemap => { archiveType => 'invalid', }, },
            code   => 409,
            error  => "Invalid archive type: invalid\n",
        },
        {    # Not logged in.
            path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps",
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps",
            method => 'POST',
            params => {
                templatemap => {
                    archiveType => 'Individual',
                    buildType   => 'Static',
                },
            },
            restrictions => {
                0 => [qw/ edit_templates /],
                1 => [qw/ edit_templates /],
            },
            code  => 403,
            error => 'Do not have permission to create a templatemap.',
        },

        # create_templatemap - normal tests
        {   path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps",
            method => 'POST',
            setup  => sub {
                die
                    if $app->model('templatemap')->exist(
                    {   blog_id      => 1,
                        template_id  => $blog_individual_tmpl_id,
                        is_preferred => { not => 1 },
                    }
                    );
            },
            params => {
                templatemap => {
                    archiveType => 'Individual',
                    buildType   => 'Static',
                },
            },
            result => sub {
                $app->model('templatemap')->load(
                    {   blog_id      => 1,
                        template_id  => $blog_individual_tmpl_id,
                        is_preferred => { not => 1 },
                    }
                );
            },
        },
        {
            note => 'create content type archive for $ct1',
            path   => "/v2/sites/1/templates/$blog_ct1_tmpl_id/templatemaps",
            method => 'POST',
            params => {
                templatemap => {
                    archiveType => 'ContentType',
                    buildType   => 'Static',
                },
            },
            result => sub {
                $app->model('templatemap')->load(
                    {   blog_id      => 1,
                        template_id  => $blog_ct1_tmpl_id,
                        is_preferred => { not => 1 },
                    }
                );
            },
            complete => sub {
                my @maps = $app->model('templatemap')->load(
                    {   blog_id     => 1,
                        template_id => $blog_ct1_tmpl_id,
                    }
                );
                is( scalar( grep { $_->is_preferred } @maps ),  1 );
                is( scalar( grep { !$_->is_preferred } @maps ), 1 );
            },
        },
        {   note => 'create content type archive for ct2',
            path   => "/v2/sites/1/templates/$blog_ct2_tmpl_id/templatemaps",
            method => 'POST',
            params => {
                templatemap => {
                    archiveType => 'ContentType',
                    buildType   => 'Static',
                },
            },
            result => sub {
                $app->model('templatemap')->load(
                    {   blog_id      => 1,
                        template_id  => $blog_ct2_tmpl_id,
                        is_preferred => { not => 1 },
                    }
                );
            },
            complete => sub {
                my @maps_for_ct1 = $app->model('templatemap')->load(
                    {   blog_id     => 1,
                        template_id => $blog_ct1_tmpl_id,
                    }
                );
                is( scalar( grep { $_->is_preferred } @maps_for_ct1 ),  1 );
                is( scalar( grep { !$_->is_preferred } @maps_for_ct1 ), 1 );

                my @maps_for_ct2 = $app->model('templatemap')->load(
                    {   blog_id     => 1,
                        template_id => $blog_ct2_tmpl_id,
                    }
                );
                is( scalar( grep { $_->is_preferred } @maps_for_ct2 ),  1 );
                is( scalar( grep { !$_->is_preferred } @maps_for_ct2 ), 1 );
            },
        },
        {   note => 'create content type archive listing for $ct2',
            path =>
                "/v2/sites/1/templates/$blog_ct2_archive_tmpl_id/templatemaps",
            method => 'POST',
            params => {
                templatemap => {
                    archiveType => 'ContentType-Author-Daily',
                    buildType   => 'Static',
                },
            },
            result => sub {
                $app->model('templatemap')->load(
                    {   blog_id      => 1,
                        template_id  => $blog_ct2_archive_tmpl_id,
                        is_preferred => { not => 1 },
                    }
                );
            },
            complete => sub {
                my @maps_for_ct1 = $app->model('templatemap')->load(
                    {   blog_id     => 1,
                        template_id => $blog_ct1_tmpl_id,
                    }
                );
                is( scalar( grep { $_->is_preferred } @maps_for_ct1 ),  1 );
                is( scalar( grep { !$_->is_preferred } @maps_for_ct1 ), 1 );

                my @maps_for_ct2 = $app->model('templatemap')->load(
                    {   blog_id     => 1,
                        template_id => $blog_ct2_tmpl_id,
                    }
                );
                is( scalar( grep { $_->is_preferred } @maps_for_ct2 ),  1 );
                is( scalar( grep { !$_->is_preferred } @maps_for_ct2 ), 1 );

                my @maps_for_ct2_archive = $app->model('templatemap')->load(
                    {   blog_id     => 1,
                        template_id => $blog_ct2_archive_tmpl_id,
                    }
                );
                is( scalar( grep { $_->is_preferred } @maps_for_ct2_archive ),  1 );
                is( scalar( grep { !$_->is_preferred } @maps_for_ct2_archive ), 1 );
            },
        },

        # list_templatemaps - irregular tests
        {    # Non-existent template.
            path   => '/v2/sites/1/templates/500/templatemaps',
            method => 'GET',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Template not found',
                    },
                };
            },
        },
        {    # Non-existent site.
            path =>
                "/v2/sites/5/templates/$blog_individual_tmpl_id/templatemaps",
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
        {    # Other site.
            path =>
                "/v2/sites/2/templates/$blog_individual_tmpl_id/templatemaps",
            method => 'GET',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Template not found',
                    },
                };
            },
        },
        {    # Other site (system).
            path =>
                "/v2/sites/0/templates/$blog_individual_tmpl_id/templatemaps",
            method => 'GET',
            code   => 404,
            result => sub {
                +{  error => {
                        code    => 404,
                        message => 'Template not found',
                    },
                };
            },
        },
        {    # Not archive template.
            path => "/v2/sites/1/templates/$blog_index_tmpl_id/templatemaps",
            method => 'GET',
            code   => 400,
            result => sub {
                +{  error => {
                        code    => 400,
                        message => 'Template "'
                            . $blog_index_tmpl->name
                            . '" is not an archive template.',
                    },
                };
            },
        },
        {    # Not logged in.
            path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps",
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps",
            method       => 'GET',
            restrictions => {
                0 => [qw/ edit_templates /],
                1 => [qw/ edit_templates /],
            },
            code => 403,
            error =>
                'Do not have permission to retrieve the list of templatemaps.',
        },

        # list_templatemaps - normal tests
        {   path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps",
            method => 'GET',
            result => sub {
                my @tm = $app->model('templatemap')
                    ->load( { template_id => $blog_individual_tmpl_id, } );

                $app->user($author);

                return +{
                    totalResults => 2,
                    items => MT::DataAPI::Resource->from_object( \@tm ),
                };
            },
        },
        {    # Filtered by archiveType.
            path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps",
            method => 'GET',
            params => { archiveType => 'Category' },
            result => sub {
                +{  totalResults => 0,
                    items        => [],
                };
            },
        },
        {    # Filtered by buildType.
            path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps",
            method => 'GET',
            params => { buildType => 'Static' },
            result => sub {
                require MT::PublishOption;
                my @tm = $app->model('templatemap')->load(
                    {   template_id => $blog_individual_tmpl_id,
                        build_type  => MT::PublishOption::ONDEMAND(),
                    }
                );

                $app->user($author);

                return +{
                    totalResults => 2,
                    items => MT::DataAPI::Resource->from_object( \@tm ),
                };
            },
        },
        {    # Filtered by isPreferred.
            path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps",
            method => 'GET',
            params => { isPreferred => 'true' },
            result => sub {
                my @tm = $app->model('templatemap')->load(
                    {   template_id  => $blog_individual_tmpl_id,
                        is_preferred => 1,
                    }
                );

                $app->user($author);

                return +{
                    totalResults => 1,
                    items => MT::DataAPI::Resource->from_object( \@tm ),
                };
            },
        },
        {    # ct1 content type archive
            path   => "/v2/sites/1/templates/$blog_ct1_tmpl_id/templatemaps",
            method => 'GET',
            result => sub {
                my @tm = $app->model('templatemap')
                    ->load( { template_id => $blog_ct1_tmpl_id, } );
                return +{
                    totalResults => scalar(@tm),
                    items => MT::DataAPI::Resource->from_object( \@tm ),
                };
            },
        },
        {    # ct2 content type archive listing
            path =>
                "/v2/sites/1/templates/$blog_ct2_archive_tmpl_id/templatemaps",
            method => 'GET',
            result => sub {
                my @tm = $app->model('templatemap')
                    ->load( { template_id => $blog_ct2_archive_tmpl_id, } );
                return +{
                    totalResults => scalar(@tm),
                    items => MT::DataAPI::Resource->from_object( \@tm ),
                };
            },
        },

        # get_templatemap - irregular tests
        {    # Non-existent templatemap.
            path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps/20",
            method => 'GET',
            code   => 404,
        },
        {    # Non-existent template.
            path => "/v2/sites/1/templates/300/templatemaps/$blog_tmplmap_id",
            method => 'GET',
            code   => 404,
        },
        {    # Non-existent site.
            path => "/v2/sites/5/templates/96/templatemaps/$blog_tmplmap_id",
            method => 'GET',
            code   => 404,
        },
        {    # Other template's templatemap.
            path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps/$blog_other_tmplmap_id",
            method => 'GET',
            code   => 404,
        },
        {    # Other site's templatemap.
            path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps/$blog_other_site_tmplmap_id",
            method => 'GET',
            code   => 404,
        },
        {    # Other template.
            path =>
                "/v2/sites/1/templates/$blog_index_tmpl_id/templatemaps/$blog_tmplmap_id",
            method => 'GET',
            code   => 404,
        },
        {    # Other site.
            path =>
                "/v2/sites/2/templates/$blog_individual_tmpl_id/templatemaps/$blog_tmplmap_id",
            method => 'GET',
            code   => 404,
        },
        {    # Nog logged in.
            path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps/$blog_tmplmap_id",
            method    => 'GET',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps/$blog_tmplmap_id",
            method       => 'GET',
            restrictions => {
                0 => [qw/ edit_templates /],
                1 => [qw/ edit_templates /],
            },
            code => 403,
            error =>
                'Do not have permission to retrieve the requested templatemap.',
        },

        # get_templatemap - normal tests
        {   path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps/$blog_tmplmap_id",
            method => 'GET',
            result => sub {
                $blog_tmplmap;
            },
        },
        {
            path => "/v2/sites/1/templates/$blog_ct1_tmpl_id/templatemaps/$blog_ct1_tmplmap_id",
            method => 'GET',
            result => sub { $blog_ct1_tmplmap },
        },

        # update_templatemap - irregular test.
        {    # Not logged in.
            path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps/$blog_tmplmap_id",
            method    => 'PUT',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps/$blog_tmplmap_id",
            method => 'PUT',
            params => { templatemap => { fileTemplate => 'foobarbaz', }, },
            restrictions => {
                0 => [qw/ edit_templates /],
                1 => [qw/ edit_templates /],
            },
            code  => 403,
            error => 'Do not have permission to update a templatemap.',
        },

        # update_templatemap - normal tests
        {   path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps/$blog_tmplmap_id",
            method => 'PUT',
            params => { templatemap => { fileTemplate => 'foobarbaz', }, },
            result => sub {
                $app->model('templatemap')->load($blog_tmplmap_id);
            },
        },

        # delete_templatemap - irregular tests
        {    # Non-existent templatemap.
            path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps/20",
            method => 'DELETE',
            code   => 404,
        },
        {    # Non-existent template.
            path => "/v2/sites/1/templates/300/templatemaps/$blog_tmplmap_id",
            method => 'DELETE',
            code   => 404,
        },
        {    # Non-existent site.
            path =>
                "/v2/sites/5/templates/$blog_individual_tmpl_id/templatemaps/$blog_tmplmap_id",
            method => 'DELETE',
            code   => 404,
        },
        {    # Other template's templatemap.
            path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps/$blog_other_tmplmap_id",
            method   => 'DELETE',
            code     => 404,
            complete => sub {
                my $map = $app->model('templatemap')
                    ->load($blog_other_tmplmap_id);
                is( ref $map, 'MT::TemplateMap',
                    'Does not deleted templatemap.' );
            },
        },
        {    # Other site's templatemap.
            path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps/$blog_other_site_tmplmap_id",
            method   => 'DELETE',
            code     => 404,
            complete => sub {
                my $map = $app->model('templatemap')
                    ->load($blog_other_site_tmplmap_id);
                is( ref $map, 'MT::TemplateMap',
                    'Does not deleted templatemap.' );
            },
        },
        {    # Other template.
            path =>
                "/v2/sites/1/templates/$blog_index_tmpl_id/templatemaps/$blog_tmplmap_id",
            method   => 'DELETE',
            code     => 404,
            complete => sub {
                my $map = $app->model('templatemap')->load($blog_tmplmap_id);
                is( ref $map, 'MT::TemplateMap',
                    'Does not deleted templatemap.' );
            },
        },
        {    # Other site.
            path =>
                "/v2/sites/2/templates/$blog_individual_tmpl_id/templatemaps/$blog_tmplmap_id",
            method   => 'DELETE',
            code     => 404,
            complete => sub {
                my $map = $app->model('templatemap')->load($blog_tmplmap_id);
                is( ref $map, 'MT::TemplateMap',
                    'Does not deleted templatemap.' );
            },
        },
        {    # Not logged in.
            path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps/$blog_tmplmap_id",
            method    => 'DELETE',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps/$blog_tmplmap_id",
            method       => 'DELETE',
            restrictions => {
                0 => [qw/ edit_templates /],
                1 => [qw/ edit_templates /],
            },
            code  => 403,
            error => 'Do not have permission to delete a templatemap.',
        },

        # delete_templatemap - normal tests
        {   path =>
                "/v2/sites/1/templates/$blog_individual_tmpl_id/templatemaps/$blog_tmplmap_id",
            method => 'DELETE',
            setup  => sub {
                die if !$app->model('templatemap')->load($blog_tmplmap_id);
            },
            complete => sub {
                my $map = $app->model('templatemap')->load($blog_tmplmap_id);
                is( $map, undef, 'Deleted templatemap.' );
            },
        },
    ];
}

