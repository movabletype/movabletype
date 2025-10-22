#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use lib 'addons/Commercial.pack/lib', 'addons/Enterprise.pack/lib';

use MT;
use MT::Author;
use MT::Blog;
use MT::Test;
use MT::Test::App;

my $mt = MT->instance;

# Make additional data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;
    MT::Test->init_data;

    make_data();
});

my $blog  = MT::Blog->load(1);
my $user  = MT::Author->load(999);    # aikawa
my $other = MT::Author->load(998);    # ichikawa

# Create a new Asset
# __mode=save&_type=asset&blog_id=1

my $app = MT::Test::App->new('MT::App::CMS');
$app->login($user);
$app->post_ok({
    __mode  => 'save',
    _type   => 'asset',
    blog_id => 1
});
$app->has_invalid_request("Create a new asset: result");

# Delete Asset
# __mode=delete&_type=asset&blog_id=1&id=1
$app->login($other);
$app->post_ok({
    __mode  => 'delete',
    _type   => 'asset',
    blog_id => 1,
    id      => 1
});
$app->has_permission_error("Update an asset: result");

# Update an asset
# __mode=save&_type=asset&blog_id=1&id=1
$app->login($other);
$app->post_ok({
    __mode  => 'save',
    _type   => 'asset',
    blog_id => 1,
    id      => 1
});
$app->has_permission_error("Update an asset: result");

# Create a new Author
# __mode=save&_type=author&name=new_author&type=1
$app->login($user);
$app->post_ok({
    __mode => 'save',
    _type  => 'author',
    name   => 'new_author',
    type   => 1
});
$app->has_permission_error("Create a new Author: result");

# Delete Author
# __mode=delete&_type=author&id=1
$app->login($user);
$app->post_ok({
    __mode => 'delete',
    _type  => 'author',
    id     => 1
});
$app->has_permission_error("Delete author: result");

# Create a new Association
# __mode=save&_type=association&type=1
$app->login($user);
$app->post_ok({
    __mode => 'save',
    _type  => 'association',
    type   => 1
});
$app->has_invalid_request("Create a new Association: result");

# Delete Association
# __mode=delete&_type=association&id=1
$app->login($user);
$app->post_ok({
    __mode => 'delete',
    _type  => 'association',
    id     => 1
});
$app->has_permission_error("Delete association: result");

# Create a new Blog
# __mode=save&_type=blog&name=BlogName
$app->login($user);
$app->post_ok({
    __mode => 'save',
    _type  => 'blog',
    name   => 'BlogName'
});
$app->has_permission_error("Create a new Blog: result");

# Delete Blog
# __mode=delete&_type=blog&id=1
$app->login($user);
$app->post_ok({
    __mode => 'delete',
    _type  => 'blog',
    id     => 1
});
$app->has_permission_error("Delete blog: result");

# Create a new Website
# __mode=save&_type=website&name=WebsiteName
$app->login($user);
$app->post_ok({
    __mode => 'save',
    _type  => 'website',
    name   => 'WebsiteName'
});
$app->has_permission_error("Create a new Website: result");

# Delete Website
# __mode=delete&_type=website&id=1
$app->login($user);
$app->post_ok({
    __mode => 'delete',
    _type  => 'website',
    id     => 2
});
$app->has_permission_error("Delete website: result");

# Create a new Category
# __mode=save&_type=category&label=CategoryName&blog_id=1
$app->login($user);
$app->post_ok({
    __mode  => 'save',
    _type   => 'category',
    label   => 'CategoryName',
    blog_id => 1
});
$app->has_invalid_request("Create a new Category: result");

# Delete Category
# __mode=delete&_type=category&id=1&blog_id=1
$app->login($user);
$app->post_ok({
    __mode  => 'delete',
    _type   => 'category',
    id      => 1,
    blog_id => 1
});
$app->has_permission_error("Delete category: result");

# Create a new Folder
# __mode=save&_type=folder&label=FolderName&blog_id=1
$app->login($user);
$app->post_ok({
    __mode  => 'save',
    _type   => 'folder',
    label   => 'FolderName',
    blog_id => 1
});
$app->has_invalid_request("Create a new Folder: result");

# Delete Folder
# __mode=delete&_type=folder&id=20&blog_id=1
$app->login($user);
$app->post_ok({
    __mode  => 'delete',
    _type   => 'folder',
    id      => 20,
    blog_id => 1
});
$app->has_permission_error("Delete folder: result");

# Update Folder
# __mode=save&_type=folder&label=FolderName&blog_id=1
$app->login($other);
$app->post_ok({
    __mode  => 'save',
    _type   => 'folder',
    label   => 'FolderName',
    blog_id => 1,
    id      => 1
});
$app->has_permission_error("Update a Folder: result");

# Create a new Comment
# __mode=save&_type=comment&&blog_id=1&entry_id=1
$app->login($user);
$app->post_ok({
    __mode   => 'save',
    _type    => 'comment',
    blog_id  => 1,
    entry_id => 1
});
$app->has_invalid_request("Create a new Comment: result");

# Delete Comment
# __mode=delete&_type=comment&id=1&blog_id=1

$app->login($user);
$app->post_ok({
    __mode  => 'delete',
    _type   => 'comment',
    id      => 1,
    blog_id => 1
});
if ($test_env->plugin_exists('Comments')) {
    $app->has_permission_error("Delete comment: result");
} else {
    $app->has_invalid_request("Delete comment: result");
}

# Create a new Entry
# __mode=save&_type=entry&&blog_id=1&author_id=1&status=1
$app->login($user);
$app->post_ok({
    __mode    => 'save',
    _type     => 'entry',
    blog_id   => 1,
    author_id => 1,
    status    => 1
});
$app->has_permission_error("Create a new Entry: result");

# Delete Entry
# __mode=delete&_type=entry&id=1&blog_id=1
$app->login($user);
$app->post_ok({
    __mode  => 'delete',
    _type   => 'entry',
    id      => 1,
    blog_id => 1
});
$app->has_permission_error("Delete entry: result");

# Update an Entry
# __mode=save&_type=entry&&blog_id=1&author_id=1&status=1&id=1
$app->login($other);
$app->post_ok({
    __mode    => 'save',
    _type     => 'entry',
    blog_id   => 1,
    author_id => 1,
    status    => 1,
    id        => 1
});
$app->has_permission_error("Update anEntry: result");

# Create a new Page
# __mode=save&_type=page&&blog_id=1&author_id=1&status=1
$app->login($user);
$app->post_ok({
    __mode    => 'save',
    _type     => 'page',
    blog_id   => 1,
    author_id => 1,
    status    => 1
});
$app->has_permission_error("Create a new Page: result");

# Delete Page
# __mode=delete&_type=page&id=20&blog_id=1
$app->login($user);
$app->post_ok({
    __mode  => 'delete',
    _type   => 'page',
    id      => 20,
    blog_id => 1
});
$app->has_permission_error("Delete page: result");

# Update a Page
# __mode=save&_type=page&&blog_id=1&author_id=1&status=1&id=20
$app->login($other);
$app->post_ok({
    __mode    => 'save',
    _type     => 'page',
    blog_id   => 1,
    author_id => 1,
    status    => 1,
    id        => 20
});
$app->has_permission_error("Update an Page: result");

# Create a new Banlist
# __mode=save&_type=banlist&&blog_id=1&ip=1.1.1.1
$app->login($user);
$app->post_ok({
    __mode  => 'save',
    _type   => 'banlist',
    blog_id => 1,
    ip      => '1.1.1.1'
});
$app->has_permission_error("Create a new Banlist: result");

# Delete Banlist
# __mode=delete&_type=banlist&id=1&blog_id=1
$app->login($user);
$app->post_ok({
    __mode  => 'delete',
    _type   => 'banlist',
    id      => 1,
    blog_id => 1
});
$app->has_permission_error("Delete banlist: result");

# Create a new Notification
# __mode=save&_type=notification&&blog_id=1
$app->login($user);
$app->post_ok({
    __mode  => 'save',
    _type   => 'notification',
    blog_id => 1,
});
$app->has_permission_error("Create a new Notification: result");

# Delete Notification
# __mode=delete&_type=notification&id=1&blog_id=1
$app->login($user);
$app->post_ok({
    __mode  => 'delete',
    _type   => 'notification',
    id      => 1,
    blog_id => 1
});
$app->has_permission_error("Delete notification: result");

# Create a new Role
# __mode=save&_type=role&&blog_id=1&name=NewRole
$app->login($user);
$app->post_ok({
    __mode => 'save',
    _type  => 'role',
    name   => "NewRole"
});
$app->has_permission_error("Create a new Role: result");

# Delete Role
# __mode=delete&_type=role&id=1
$app->login($user);
$app->post_ok({
    __mode => 'delete',
    _type  => 'role',
    id     => 1,
});
$app->has_permission_error("Delete role: result");

# Create a new Config
# __mode=save&_type=config
$app->login($user);
$app->post_ok({
    __mode => 'save',
    _type  => 'config'
});
$app->has_invalid_request("Create a new Config: result");

# Delete Config
# __mode=delete&_type=config&id=1
$app->login($user);
$app->post_ok({
    __mode => 'delete',
    _type  => 'config',
    id     => 1,
});
$app->has_invalid_request("Delete config: result");

# Create a new Fileinfo
# __mode=save&_type=fileinfo&blog_id=1
$app->login($user);
$app->post_ok({
    __mode  => 'save',
    _type   => 'fileinfo',
    blog_id => 1
});
$app->has_invalid_request("Create a new Fileinfo: result");

# Delete Fileinfo
# __mode=delete&_type=fileinfo&id=1
$app->login($user);
$app->post_ok({
    __mode => 'delete',
    _type  => 'fileinfo',
    id     => 1,
});
$app->has_invalid_request("Delete fileinfo: result");

# Create a new Log
# __mode=save&_type=log&blog_id=1
$app->login($user);
$app->post_ok({
    __mode  => 'save',
    _type   => 'log',
    blog_id => 1
});
$app->has_invalid_request("Create a new Log: result");

# Delete Log
# __mode=delete&_type=log&id=1
$app->login($user);
$app->post_ok({
    __mode => 'delete',
    _type  => 'log',
    id     => 1,
});
$app->has_invalid_request("Delete log: result");

# Create a new ObjectAsset
# __mode=save&_type=objectasset&asset_id=1&object_id=1&object_ds=entry
$app->login($user);
$app->post_ok({
    __mode    => 'save',
    _type     => 'objectasset',
    asset_id  => 1,
    object_id => 1,
    object_ds => 'entry'
});
$app->has_invalid_request("Create a new Objectasset: result");

# Delete Objectasset
# __mode=delete&_type=objectasset&id=1
$app->login($user);
$app->post_ok({
    __mode => 'delete',
    _type  => 'objectasset',
    id     => 1,
});
$app->has_invalid_request("Delete objectasset: result");

# Create a new Objectscore
# __mode=save&_type=objectscore&namespace=scope_name&object_ds=entry
$app->login($user);
$app->post_ok({
    __mode    => 'save',
    _type     => 'objectscore',
    namespace => 'scope_name',
    object_ds => 'entry'
});
$app->has_invalid_request("Create a new Objectscore: result");

# Delete Objectscore
# __mode=delete&_type=objectscore&id=1
$app->login($user);
$app->post_ok({
    __mode => 'delete',
    _type  => 'objectscore',
    id     => 1,
});
$app->has_invalid_request("Delete objectscore: result");

# Create a new Objecttag
# __mode=save&_type=objecttag&tag_id=1&object_datasource=entry&object_id=1
$app->login($user);
$app->post_ok({
    __mode            => 'save',
    _type             => 'objecttag',
    object_datasource => 'entry',
    tag_id            => 1,
    object_id         => 1
});
$app->has_invalid_request("Create a new Objecttag: result");

# Delete Objecttag
# __mode=delete&_type=objecttag&id=1
$app->login($user);
$app->post_ok({
    __mode => 'delete',
    _type  => 'objecttag',
    id     => 1,
});
$app->has_invalid_request("Delete objecttag: result");

# Create a new Permission
# __mode=save&_type=permission&blog_id=1&author_id=1
$app->login($user);
$app->post_ok({
    __mode    => 'save',
    _type     => 'permission',
    author_id => 1,
    blog_id   => 1
});
$app->has_invalid_request("Create a new Permission: result");

# Delete Permission
# __mode=delete&_type=permission&id=1
$app->login($user);
$app->post_ok({
    __mode => 'delete',
    _type  => 'permission',
    id     => 1,
});
$app->has_invalid_request("Delete permission: result");

# Create a new Placement
# __mode=save&_type=placement&blog_id=1&category_id=1&entry_id=1&is_primary=1
$app->login($user);
$app->post_ok({
    __mode      => 'save',
    _type       => 'placement',
    blog_id     => 1,
    category_id => 1,
    entry_id    => 1,
    is_primary  => 1
});
$app->has_invalid_request("Create a new Placement: result");

# Delete Placement
# __mode=delete&_type=placement&id=1
$app->login($user);
$app->post_ok({
    __mode => 'delete',
    _type  => 'placement',
    id     => 1,
});
$app->has_invalid_request("Delete placement: result");

# Create a new Session
# __mode=save&_type=session&id=THIS_IS_A_FAKE_SESSION_2&start=currenttime
$app->login($user);
$app->post_ok({
    __mode => 'save',
    _type  => 'session',
    id     => 'THIS_IS_A_FAKE_SESSION_2',
    time   => time
});
$app->has_invalid_request("Create a new Session: result");

# Delete Session
# __mode=delete&_type=session&id=THIS_IS_A_FAKE_SESSION
$app->login($user);
$app->post_ok({
    __mode => 'delete',
    _type  => 'session',
    id     => 'THIS_IS_A_FAKE_SESSION',
});
$app->has_invalid_request("Delete session: result");

# Create a new Tag
# __mode=save&_type=tag&name=NewTag
$app->login($user);
$app->post_ok({
    __mode => 'save',
    _type  => 'tag',
    name   => 'NewTag'
});
$app->has_invalid_request("Create a new Tag: result");

# Delete Tag
# __mode=delete&_type=tag&id=1
$app->login($user);
$app->post_ok({
    __mode  => 'delete',
    _type   => 'tag',
    blog_id => 1,
    id      => 1,
});
$app->has_permission_error("Delete tag: result");

# Create a new Ping
# __mode=save&_type=ping&blog_id=1&ip=1.1.1.1&tb_id=1
$app->login($user);
$app->post_ok({
    __mode  => 'save',
    _type   => 'ping',
    blog_id => 1,
    ip      => '1.1.1.1',
    tb_id   => 1
});
if ($test_env->plugin_exists('Trackback')) {
    $app->has_permission_error("Create a new Ping: result");
} else {
    $app->has_invalid_request("Create a new ping: result");
}

# Delete Ping
# __mode=delete&_type=ping&id=1
$app->login($user);
$app->post_ok({
    __mode => 'delete',
    _type  => 'ping',
    id     => 1,
});
if ($test_env->plugin_exists('Trackback')) {
    $app->has_permission_error("Delete ping: result");
} else {
    $app->has_invalid_request("Delete ping: result");
}

# Create a new Touch
# __mode=save&_type=touch
$app->login($user);
$app->post_ok({
    __mode => 'save',
    _type  => 'touch',
});
$app->has_invalid_request("Create a new Touch: result");

# Delete Touch
# __mode=delete&_type=touch&id=1
$app->login($user);
$app->post_ok({
    __mode => 'delete',
    _type  => 'touch',
    id     => 1,
});
$app->has_invalid_request("Delete touch: result");

# Create a new Trackback
# __mode=save&_type=trackback&blog_id=1
$app->login($user);
$app->post_ok({
    __mode  => 'save',
    _type   => 'trackback',
    blog_id => 1
});
$app->has_invalid_request("Create a new Trackback: result");

# Delete Trackback
# __mode=delete&_type=trackback&id=1
$app->login($user);
$app->post_ok({
    __mode => 'delete',
    _type  => 'trackback',
    id     => 1,
});
$app->has_invalid_request("Delete trackback: result");

# Create a new Template
# __mode=save&_type=template&blog_id=1&name=NewTemplate&type=custom
$user = MT::Author->load(3);    # Bobd
$app->login($user);
$app->post_ok({
    __mode  => 'save',
    _type   => 'template',
    blog_id => 1,
    name    => 'NewTemplate',
    type    => 'custom'
});
$app->has_permission_error("Create a new Template: result");

# Delete Template
# __mode=delete&_type=template&id=1
$app->login($user);
$app->post_ok({
    __mode => 'delete',
    _type  => 'template',
    id     => 1,
});
$app->has_permission_error("Delete template: result");

# Create a new Templatemap
# __mode=save&_type=templatemap&blog_id=1&archive_type=Author&template_id=1
$app->login($user);
$app->post_ok({
    __mode       => 'save',
    _type        => 'templatemap',
    blog_id      => 1,
    archive_type => 'Author',
    template_id  => 1
});
$app->has_invalid_request("Create a new Templatemap: result");

# Delete Templatemap
# __mode=delete&_type=templatemap&id=1
$app->login($user);
$app->post_ok({
    __mode => 'delete',
    _type  => 'templatemap',
    id     => 1,
});
$app->has_invalid_request("Delete templatemap: result");

### Addons
if ($mt->component('commercial')) {

    # Create a new Field
    # __mode=save&_type=field&blog_id=1&name=NewField&object_type=entry&type=SingleLineText&tag=newtag
    $app->login($user);
    $app->post_ok({
        __mode      => 'save',
        _type       => 'field',
        blog_id     => 1,
        name        => 'NewField',
        object_type => 'entry',
        tag         => 'newtag',
        type        => 'SingleLineText'
    });
    $app->has_permission_error('Create a new Field: result');

    # Delete Field
    # __mode=delete&_type=field&id=1&blog_id=1
    $app->login($user);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'field',
        id      => 1,
        blog_id => 1
    });
    $app->has_permission_error("Delete field: result");
}

if ($mt->component('enterprise')) {

    # Create a new Group
    # __mode=save&_type=group&blog_id=1&name=NewGroup
    $app->login($user);
    $app->post_ok({
        __mode => 'save',
        _type  => 'group',
        name   => 'NewGroup',
    });
    $app->has_permission_error("Create a new Group: result");

    # Delete Group
    # __mode=delete&_type=group&id=1
    $app->login($user);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'group',
        id     => 1,
    });
    $app->has_permission_error("Delete group: result");
}

### Other user
$user = MT::Author->load(999);    #aikawa

# Delete Filter owned by ichikawa
# __mode=delete&_type=filter&blog_id=1&id=1
$app->login($user);
$app->post_ok({
    __mode  => 'delete',
    _type   => 'filter',
    blog_id => 1,
    id      => 1
});
ok($app->json_error =~ m/Permission Denied/i, "Delete filter: result");

### Different type
$user = MT::Author->load(997);    #ukawa

# Delete Website
# __mode=delete&_type=website&id=1
$app->login($user);
$app->post_ok({
    __mode => 'delete',
    _type  => 'website',
    id     => 1
});
$app->has_permission_error("Delete website (different): result");

$user = MT::Author->load(996);    #egawa

# Delete Blog
# __mode=delete&_type=blog&id=2
$app->login($user);
$app->post_ok({
    __mode => 'delete',
    _type  => 'blog',
    id     => 2
});
$app->has_permission_error("Delete blog (different): result");

$user = MT::Author->load(994);    #kagawa

# Update a Category
# __mode=save&_type=category&label=CategoryName&blog_id=1&id=1
$app->login($user);
$app->post_ok({
    __mode  => 'save',
    _type   => 'category',
    label   => 'CategoryName',
    blog_id => 1,
    id      => 20
});
$app->has_permission_error(" Update a category (different): result");

# Delete Category
# __mode=delete&_type=category&id=20&blog_id=1
$app->login($user);
$app->post_ok({
    __mode  => 'delete',
    _type   => 'category',
    id      => 20,
    blog_id => 1
});
$app->has_permission_error("Delete category (different): result");

$user = MT::Author->load(995);    #ogawa

# Update a Folder
# __mode=save&_type=category&label=CategoryName&blog_id=1&id=1
$app->login($user);
$app->post_ok({
    __mode  => 'save',
    _type   => 'folder',
    label   => 'CategoryName',
    blog_id => 1,
    id      => 1
});
$app->has_permission_error(" Update a folder (different): result");

# Delete Folder
# __mode=delete&_type=folder&id=1&blog_id=1
$app->login($user);
$app->post_ok({
    __mode  => 'delete',
    _type   => 'folder',
    id      => 1,
    blog_id => 1
});
$app->has_permission_error("Delete folder (different): result");

$user = MT::Author->load(995);    #ogawa

# Update a Page
# __mode=save&_type=page&&blog_id=1&author_id=1&status=1&id=1
$app->login($user);
$app->post_ok({
    __mode    => 'save',
    _type     => 'page',
    blog_id   => 1,
    author_id => 1,
    status    => 1,
    id        => 1
});
$app->has_permission_error("Update an Page(different): result");

# Delete Page
# __mode=delete&_type=page&id=1&blog_id=1
$app->login($user);
$app->post_ok({
    __mode  => 'delete',
    _type   => 'page',
    id      => 1,
    blog_id => 1
});
$app->has_permission_error("Delete page (different): result");

$user = MT::Author->load(994);    #kagawa

# Update an Entry
# __mode=save&_type=entry&&blog_id=1&author_id=1&status=1&id=20
$app->login($user);
$app->post_ok({
    __mode    => 'save',
    _type     => 'entry',
    blog_id   => 1,
    author_id => 1,
    status    => 1,
    id        => 20
});
$app->has_permission_error("Update an Entry(different): result");

# Delete Entry
# __mode=delete&_type=entry&id=20&blog_id=1
$app->login($user);
$app->post_ok({
    __mode  => 'delete',
    _type   => 'entry',
    id      => 20,
    blog_id => 1
});
$app->has_permission_error("Delete entry (different): result");

done_testing;

sub make_data {

    ### Author
    require MT::Author;
    my $aikawa = MT::Author->new();
    $aikawa->set_values({
        name         => 'aikawa',
        nickname     => 'Ichiro Aikawa',
        email        => 'aikawa@example.com',
        url          => 'http://aikawa.com/',
        auth_type    => 'MT',
        created_on   => '19780131074500',
    });
    $aikawa->set_password("pass");
    $aikawa->type(MT::Author::AUTHOR());
    $aikawa->id(999);
    $aikawa->can_sign_in_cms(1);
    $aikawa->save()
        or die "Couldn't save author record 999: " . $aikawa->errstr;

    $test_env->clear_mt_cache;

    my $ichikawa = MT::Author->new();
    $ichikawa->set_values({
        name         => 'ichikawa',
        nickname     => 'Jiro Ichikawa',
        email        => 'ichikawa@example.com',
        url          => 'http://ichikawa.com/',
        auth_type    => 'MT',
        created_on   => '19780131074500',
    });
    $ichikawa->set_password("pass");
    $ichikawa->type(MT::Author::AUTHOR());
    $ichikawa->id(998);
    $ichikawa->can_sign_in_cms(1);
    $ichikawa->save()
        or die "Couldn't save author record 998: " . $ichikawa->errstr;

    $test_env->clear_mt_cache;

    my $ukawa = MT::Author->new();
    $ukawa->set_values({
        name         => 'ukawa',
        nickname     => 'Saburo Ukawa',
        email        => 'ukawa@example.com',
        url          => 'http://ukawa.com/',
        auth_type    => 'MT',
        created_on   => '19780131074500',
    });
    $ukawa->set_password("pass");
    $ukawa->type(MT::Author::AUTHOR());
    $ukawa->id(997);
    $ukawa->can_sign_in_cms(1);
    $ukawa->save()
        or die "Couldn't save author record 997: " . $ukawa->errstr;

    $test_env->clear_mt_cache;

    my $egawa = MT::Author->new();
    $egawa->set_values({
        name         => 'egawa',
        nickname     => 'Shiro Egawa',
        email        => 'egawa@example.com',
        url          => 'http://egawa.com/',
        auth_type    => 'MT',
        created_on   => '19780131074500',
    });
    $egawa->set_password("pass");
    $egawa->type(MT::Author::AUTHOR());
    $egawa->id(996);
    $egawa->can_sign_in_cms(1);
    $egawa->save()
        or die "Couldn't save author record 996: " . $egawa->errstr;

    $test_env->clear_mt_cache;

    my $ogawa = MT::Author->new();
    $ogawa->set_values({
        name         => 'ogawa',
        nickname     => 'Goro Ogawa',
        email        => 'ogawa@example.com',
        url          => 'http://ogawa.com/',
        auth_type    => 'MT',
        created_on   => '19780131074500',
    });
    $ogawa->set_password("pass");
    $ogawa->type(MT::Author::AUTHOR());
    $ogawa->id(995);
    $ogawa->can_sign_in_cms(1);
    $ogawa->save()
        or die "Couldn't save author record 995: " . $ogawa->errstr;

    $test_env->clear_mt_cache;

    my $kagawa = MT::Author->new();
    $kagawa->set_values({
        name         => 'kagawa',
        nickname     => 'Ichiro Kagawa',
        email        => 'kagawa@example.com',
        url          => 'http://kagawa.com/',
        auth_type    => 'MT',
        created_on   => '19780131074500',
    });
    $kagawa->set_password("pass");
    $kagawa->type(MT::Author::AUTHOR());
    $kagawa->id(994);
    $kagawa->can_sign_in_cms(1);
    $kagawa->save()
        or die "Couldn't save author record 994: " . $kagawa->errstr;

    $test_env->clear_mt_cache;

    ### Role
    require MT::Role;
    my $role = MT::Role->new();
    $role->set_values({
        name  => MT->translate('Entry Editor'),
        perms => [
            'create_post',  'edit_all_posts',
            'edit_tags',    'edit_categories',
            'publish_post', 'comment',
        ],
    });
    $role->id(20);
    $role->save
        or die "Couldn't save role record 20: " . $role->errstr;

    ### Association
    my $designer_role = MT::Role->load({ name => MT->translate('Designer') });
    my $author_role   = MT::Role->load({ name => MT->translate('Author') });
    my $site_role     = MT::Role->load({ name => MT->translate('Site Administrator') });
    my $page_role     = MT::Role->load({ name => MT->translate('Webmaster') });
    my $editor_role   = MT::Role->load({ name => MT->translate('Entry Editor') });

    require MT::Association;
    my $assoc = MT::Association->new();
    $assoc->author_id($aikawa->id);
    $assoc->blog_id(1);
    $assoc->role_id($designer_role->id);
    $assoc->type(1);
    $assoc->save();

    $test_env->clear_mt_cache;

    $assoc = MT::Association->new();
    $assoc->author_id($ichikawa->id);
    $assoc->blog_id(1);
    $assoc->role_id($author_role->id);
    $assoc->type(1);
    $assoc->save();

    $test_env->clear_mt_cache;
    $assoc = MT::Association->new();
    $assoc->author_id($ukawa->id);
    $assoc->blog_id(1);
    $assoc->role_id($site_role->id);
    $assoc->type(1);
    $assoc->save();

    $test_env->clear_mt_cache;

    $assoc = MT::Association->new();
    $assoc->author_id($egawa->id);
    $assoc->blog_id(2);
    $assoc->role_id($site_role->id);
    $assoc->type(1);
    $assoc->save();

    $test_env->clear_mt_cache;

    $assoc = MT::Association->new();
    $assoc->author_id($ogawa->id);
    $assoc->blog_id(1);
    $assoc->role_id($page_role->id);
    $assoc->type(1);
    $assoc->save();

    $test_env->clear_mt_cache;

    $assoc = MT::Association->new();
    $assoc->author_id($kagawa->id);
    $assoc->blog_id(1);
    $assoc->role_id($editor_role->id);
    $assoc->type(1);
    $assoc->save();

    ### Filter
    require MT::Filter;
    my $filter = MT::Filter->new();
    $filter->set_values({
        author_id => $ichikawa->id,
        blog_id   => 1,
        object_ds => 'entry',
    });
    $filter->save()
        or die "Couldn't save filter record: 1" . $filter->errstr;

    $test_env->clear_mt_cache;

    ### IPBanList
    require MT::IPBanList;
    my $banlist = MT::IPBanList->new();
    $banlist->set_values({
        blog_id => 1,
        ip      => '1.2.3.4',
    });
    $banlist->save()
        or die "Couldn't save ipbanlist record: 1" . $banlist->errstr;

    $test_env->clear_mt_cache;

    ### Notification
    require MT::Notification;
    my $address = MT::Notification->new();
    $address->set_values({
        blog_id => 1,
        name    => 'Foo Bar',
        email   => 'foo@example.com',
        url     => 'http://foo.com',
    });
    $address->save()
        or die "Couldn't save notification record: 1" . $address->errstr;

    $test_env->clear_mt_cache;

    ## Session
    require MT::Session;
    my $sess = MT::Session->new();
    $sess->id('THIS_IS_A_FAKE_SESSION');
    $sess->kind('UD');
    $sess->start(time);
    $sess->set('remember', 1);
    $sess->save
        or die "Couldn't save session record" . $sess->errstr;

    ### Log
    MT->log({
        message  => 'This is a log message.',
        class    => "system",
        level    => MT::Log::ERROR(),
        category => "test",
    });

    $test_env->clear_mt_cache;

    ### Addons Data
    if ($mt->component('commercial')) {
        require CustomFields::Field;
        my $field = CustomFields::Field->new();
        $field->set_values({
            blog_id  => 1,
            name     => 'SingleLine',
            obj_type => 'entry',
            type     => 'SingleLineText',
            tag      => 'EntryDataSingleLine',
            basename => 'singleline',
        });
        $field->save()
            or die "Couldn't save custom field record: 1" . $field->errstr;
    }

    $test_env->clear_mt_cache;

    if ($mt->component('enterprise')) {
        require MT::Group;
        my $group = MT::Group->new();
        $group->set_values({
            name         => 'New Group',
            status       => 1,
            display_name => 'Group',
        });
        $group->save()
            or die "Couldn't save group record: 1" . $group->errstr;
    }

    $test_env->clear_mt_cache;

}
