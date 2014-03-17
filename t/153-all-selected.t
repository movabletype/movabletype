#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib t/lib);

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use MT;
use MT::Association;
use MT::Author;
use MT::Blog;
use MT::Role;
use MT::Website;
use MT::Test qw(:app :db);
use Test::More;
use MT::ObjectDriver::Driver::Cache::RAM;

my $admin   = MT::Author->load(1);
my $website = MT::Website->load(1);

subtest 'Remove all members with all_selected = 1.' => sub {
    my $role = MT::Role->load(
        { name => MT->translate('Website Administrator') } );

    for ( my $cnt = 0; $cnt < 5; $cnt++ ) {
        my $name   = "user$cnt";
        my $author = _make_author(
            name     => $name,
            nickname => $name,
        );
        MT::Association->link( $author, $role, $website->id );
    }

    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'remove_user_assoc',
            _type            => 'member',
            action_name      => 'remove_user_assoc',
            blog_id          => $website->id,
            all_selected     => 1,
        },
    );
    my $out = delete $app->{__test_output};
    ok( $out =~ m/Status: 302 Found/ && $out =~ m/saved=1/, 'saved' );
};

subtest 'Delete all blogs with all_selected = 1.' => sub {
    foreach my $blog_id ( 0, 1 ) {

        for ( my $cnt = 0; $cnt < 5; $cnt++ ) {
            _make_blog( blog_id => $website->id, );
        }

        my $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'delete',
                _type            => 'blog',
                action_name      => 'delete',
                blog_id          => $blog_id,
                all_selected     => 1,
            },
        );
        my $out = delete $app->{__test_output};
        ok( $out =~ m/Status: 302 Found/ && $out =~ m/saved_deleted=1/,
            'saved_deleted=1' );
        is( MT::Blog->count( { parent_id => $website->id } ),
            0, 'All blog in website have been deleted.' );

    }
};

done_testing;

# Copy from MT::Test::Permission in MT6
# because MT5.1x does not have MT::Test::Permission.

sub _make_author {
    my %params = @_;

    my $values = {
        email        => 'test@example.com',
        url          => 'http://example.com/',
        api_password => 'seecret',
        auth_type    => 'MT',
        created_on   => '19780131074500',
        type         => MT::Author::AUTHOR(),
        is_superuser => 0,
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    my $author = MT::Author->new();
    $author->set_values($values);
    $author->set_password("pass");
    $author->save()
        or die "Couldn't save author record: " . $author->errstr;

    MT::ObjectDriver::Driver::Cache::RAM->clear_cache();

    return $author;
}

sub _make_blog {
    my %params = @_;

    my $values = {
        name         => 'none',
        site_url     => '/::/nana/',
        archive_url  => '/::/nana/archives/',
        site_path    => 'site/',
        archive_path => 'site/archives/',
        archive_type => 'Individual,Monthly,Weekly,Daily,Category,Page',
        archive_type_preferred   => 'Individual',
        description              => "Narnia None Test Blog",
        custom_dynamic_templates => 'custom',
        convert_paras            => 1,
        allow_reg_comments       => 1,
        allow_unreg_comments     => 0,
        allow_pings              => 1,
        sort_order_posts         => 'descend',
        sort_order_comments      => 'ascend',
        remote_auth_token        => 'token',
        convert_paras_comments   => 1,
        google_api_key           => 'r9Vj5K8PsjEu+OMsNZ/EEKjWmbCeQAv1',
        cc_license =>
            'by-nc-sa http://creativecommons.org/licenses/by-nc-sa/2.0/ http://creativecommons.org/images/public/somerights20.gif',
        server_offset        => '-3.5',
        children_modified_on => '20000101000000',
        language             => 'en_us',
        file_extension       => 'html',
        theme_id             => 'classic_blog',
        parent_id            => 1,
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::Blog;
    my $blog = MT::Blog->new();
    $blog->set_values($values);
    $blog->class('blog');
    $blog->commenter_authenticators('enabled_TypeKey');
    $blog->save() or die "Couldn't save blog: " . $blog->errstr;

    my $themedir = File::Spec->catdir( $MT::MT_DIR => 'themes' );
    MT->config->ThemesDirectory($themedir);

    require MT::Theme;
    my $classic_blog = MT::Theme->load('classic_blog')
        or die MT::Theme->errstr;
    $classic_blog->apply($blog);
    $blog->save() or die "Couldn't save blog: " . $blog->errstr;

    MT::ObjectDriver::Driver::Cache::RAM->clear_cache();

    return $blog;
}
