#!/usr/bin/perl
# $Id: 22-author.t 1927 2008-04-16 15:36:30Z mpaschal $
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Author;

use MT::Test;

$test_env->prepare_fixture('db_data');

my $mt = MT->new or die MT->errstr;
isa_ok( $mt, 'MT' );

{
    my $author = MT::Author->load( { name => 'Chuck D' } );
    isa_ok( $author, 'MT::Author' );

    $author->set_password('bass');
    $author->save or die $author->errstr;

    ok( $author->is_valid_password('bass'),   'bass is valid' );
    ok( !$author->is_valid_password('wrong'), 'wrong is invalid' );

    ok( $author->can_view_log,       'can view log' );
    ok( $author->can_manage_plugins, 'can manage plugins' );

    # Superuser Chuck D should have permission to do anything, on any blog
    my $perm = $author->blog_perm(1);
    ok( $perm, "$author->blog_perm(1)" ) || die;
    ok( $author->can_edit_entry(1),     'Chuck D can edit entry #1' );
    ok( $author->can_edit_entry(2),     'Chuck D can edit entry #2' );
    ok( $perm->can_comment,             'can_comment' );
    ok( $perm->can_post,                'can_post' );
    ok( $perm->can_create_post,         'can_create_post' );
    ok( $perm->can_publish_post,        'can_publish_post' );
    ok( $perm->can_upload,              'can_upload' );
    ok( $perm->can_edit_all_posts,      'can_edit_all_posts' );
    ok( $perm->can_manage_pages,        'can_manage_pages' );
    ok( $perm->can_edit_templates,      'can_edit_templates' );
    ok( $perm->can_edit_tags,           'can_edit_tags' );
    ok( $perm->can_edit_config,         'can_edit_config' );
    ok( $perm->can_set_publish_paths,   'can_set_publish_paths' );
    ok( $perm->can_rebuild,             'can_rebuild' );
    ok( $perm->can_send_notifications,  'can_send_notifications' );
    ok( $perm->can_edit_categories,     'can_edit_categories' );
    ok( $perm->can_edit_notifications,  'can_edit_notifications' );
    ok( $perm->can_administer_site,     'can_administer_site' );
    ok( $perm->can_edit_assets,         'can_edit_assets' );
    ok( $perm->can_manage_feedback,     'can_manage_feedback' );
}

{
    note('meta field tests');

    my $author = MT::Author->load( { name => 'Chuck D' } );
    ok( eval { $author->widgets(); 1 }, 'Author obj has widgets accessor' );
    ok( !defined $author->widgets,
        "Author's widgets are undefined by default" );
    ok( !defined $author->favorite_blogs,
        "Author's favorite blogs are undefined by default" );

    # same as in MT::CMS::Dashboard, but that's not necessary
    my $default_widgets = {
        'blog_stats' =>
            { param => { tab => 'entry' }, order => 1, set => 'main' },
        'this_is_you-1' => { order => 1, set => 'sidebar' },
        'mt_shortcuts'  => { order => 2, set => 'sidebar' },
        'mt_news'       => { order => 3, set => 'sidebar' },
    };

    my $fav_blogs = [ 1, 7 ];    # not actually a blog #7, but meh

    ok( $author->widgets($default_widgets), "Author's widgets can be set" );
    ok( $author->favorite_blogs($fav_blogs),
        "Author's favorite blogs can be set"
    );
    ok( $author->save(), "Author with modified widgets can be saved" );

    require MT::ObjectDriver::Driver::Cache::RAM;
    MT::ObjectDriver::Driver::Cache::RAM->clear_cache();

    $author = MT::Author->load( { name => 'Chuck D' } );

    ok( $author->widgets, "Modified author has widgets" );
    is_deeply( $author->widgets, $default_widgets,
        "Author's widgets survived being saved accurately" );

    ok( $author->favorite_blogs, "Modified author has favorite blogs" );
    is_deeply( $author->favorite_blogs, $fav_blogs,
        "Author's favorite blogs survived being saved accurately" );
}

{
    my $author = MT::Author->load( { name => 'Bob D' } );
    $author
        = MT::Author->load( $author->id );   # silly ruse to force caching....
    isa_ok( $author, 'MT::Author' );

    # Non-superuser Bob D should only have selected permissions
    my $perm = $author->blog_perm(1);
    ok( $perm, "$author->blog_perm(1)" ) || die;
    ok( !$author->can_view_log,          'can_view_log' );
    ok( !$author->can_manage_plugins,    'can manage plugins' );
    ok( !$author->can_edit_entry(1),     'Bob D can edit entry #1' );
    ok( $author->can_edit_entry(2),      'Bob D can edit entry #2' );
    ok( $perm->can_post,                 'can_post' );
    ok( $perm->can_create_post,          'can_create_post' );
    ok( $perm->can_publish_post,         'can_publish_post' );
    ok( $perm->can_upload,               'Bob D can *not* upload files' );
    ok( !$perm->can_edit_all_posts,      'Bob D can *not* edit all posts' );
    ok( !$perm->can_manage_pages,        'can_manage_pages' );
    ok( !$perm->can_edit_templates,      'Bob D can *not* edit templates' );
    ok( !$perm->can_edit_tags,           'can_edit_tags' );
    ok( !$perm->can_edit_config,         'can_edit_config' );
    ok( !$perm->can_set_publish_paths,   'can_set_publish_paths' );
    ok( !$perm->can_rebuild,             'can_rebuild' );
    ok( $perm->can_send_notifications,   'Bob D can send notifications' );
    ok( !$perm->can_edit_categories,     'can_edit_categories' );
    ok( !$perm->can_edit_notifications,  'can_edit_notifications' );
    ok( !$perm->can_administer_site,     'can_administer_site' );
    ok( !$perm->can_edit_assets,         'can_edit_assets' );
    ok( !$perm->can_manage_feedback,     'can_manage_feedback' );
}

{
# checking that the system verifies the old password, (that is DES or MD5)
# convert them to the new hashing (SHA512), and still verifies them afterwards
    my $author = MT::Author->new();
    $author->name('dummy');
    $author->column( 'password', '6En93Q4gNHIu6' );
    ok( !$author->is_valid_password('wrong'), 'wrong is invalid' );
    ok( $author->is_valid_password('xxxxx'),  'recognize valid password' );
    ok( $author->column('password') !~ m/^\$6\$/,
        'password is now stored as SHA-512'
    );
    $author->set_password('xxxxx');
    ok( $author->column('password') =~ m/^\$6\$/,
        'password is now stored as SHA-512'
    );
    ok( !$author->is_valid_password('wrong'), 'wrong is still invalid' );
    ok( $author->is_valid_password('xxxxx'),
        'still recognize valid password'
    );
}

{
    my $author = MT::Author->new;
    my $perm = sub { $author->permissions(0)->permissions };

    $author->$_(1)
        for
        qw( can_create_site can_edit_templates can_manage_plugins can_view_log );
    is( $perm->(),
        "'create_site','edit_templates','manage_plugins','view_log'",
        'Add 5 permissions.'
    );

    $author->can_create_site(0);
    is( $perm->(),
        "'edit_templates','manage_plugins','view_log'",
        'Delete create_site permission.'
    );

    $author->can_view_log(0);
    is( $perm->(),
        "'edit_templates','manage_plugins'",
        'Delete view_log permission.'
    );

    $author->can_edit_templates(0);
    is( $perm->(),
        "'manage_plugins'",
        'Delete edit_templates permission.'
    );

    $author->can_manage_plugins(0);
    ok( !$perm->(), 'Delete manage_plugins permission.' );
}

done_testing();
