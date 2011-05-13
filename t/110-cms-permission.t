#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}


use lib 't/lib', 'lib', 'extlib', 'addons/Commercial.pack/lib', 'addons/Enterprise.pack/lib';

use MT;
use MT::Author;
use MT::Blog;
use MT::Test qw( :app :db :data );

# Make additional data
my $mt = MT->instance;
make_data();


# Now, Ready to start test
my $test_count = 112;
$test_count += 4
    if $mt->component('commercial');
$test_count += 4
    if $mt->component('enterprise');

use Test::More;
plan tests => $test_count;

my ($app, $out);
my $blog = MT::Blog->load(1);
my $user = MT::Author->load(999);

# Create a new Asset
# __mode=save&_type=asset&blog_id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'asset', blog_id => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new asset");
ok ($out =~ m!__mode=dashboard&permission=1!i, "Create a new Asset: result");

# Delete Asset
# __mode=delete&_type=asset&blog_id=1&id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'asset', blog_id => 1, id => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Delete asset");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete asset: result");


# Create a new Author
# __mode=save&_type=author&name=new_author&type=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'author', name => 'new_author', type => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new author");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Author: result");

# Delete Author
# __mode=delete&_type=author&id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'author', id => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Delete author");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete author: result");


# Create a new Association
# __mode=save&_type=association&type=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'association', type => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new association");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Association: result");

# Delete Association
# __mode=delete&_type=association&id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'association', id => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Delete association");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete association: result");


# Create a new Blog
# __mode=save&_type=blog&name=BlogName
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'blog', name => 'BlogName' }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new blog");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Blog: result");

# Delete Blog
# __mode=delete&_type=blog&id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'blog', id => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Delete blog");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete blog: result");


# Create a new Website
# __mode=save&_type=website&name=WebsiteName
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'website', name => 'WebsiteName' }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new website");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Website: result");

# Delete Website
# __mode=delete&_type=website&id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'website', id => 2 }
);
$out = delete $app->{__test_output};
ok ($out, "Delete website");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete website: result");


# Create a new Category
# __mode=save&_type=category&label=CategoryName&blog_id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'category', label => 'CategoryName', blog_id => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new category");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Category: result");

# Delete Category
# __mode=delete&_type=category&id=1&blog_id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'category', id => 1, blog_id => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Delete category");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete category: result");


# Create a new Folder
# __mode=save&_type=folder&label=FolderName&blog_id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'folder', label => 'FolderName', blog_id => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new folder");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Folder: result");

# Delete Folder
# __mode=delete&_type=folder&id=20&blog_id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'folder', id => 20, blog_id => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Delete folder");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete folder: result");


# Create a new Comment
# __mode=save&_type=comment&&blog_id=1&entry_id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'comment', blog_id => 1, entry_id => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new comment");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Comment: result");

# Delete Comment
# __mode=delete&_type=comment&id=1&blog_id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'comment', id => 1, blog_id => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Delete comment");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete comment: result");


# Create a new Entry
# __mode=save&_type=entry&&blog_id=1&author_id=1&status=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'entry', blog_id => 1, author_id => 1, status => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new entry");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Entry: result");

# Delete Entry
# __mode=delete&_type=entry&id=1&blog_id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'entry', id => 1, blog_id => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Delete entry");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete entry: result");


# Create a new Page
# __mode=save&_type=page&&blog_id=1&author_id=1&status=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'page', blog_id => 1, author_id => 1, status => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new page");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Page: result");

# Delete Page
# __mode=delete&_type=page&id=20&blog_id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'page', id => 20, blog_id => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Delete page");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete page: result");


# Create a new Banlist
# __mode=save&_type=banlist&&blog_id=1&ip=1.1.1.1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'banlist', blog_id => 1, ip => '1.1.1.1' }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new banlist");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Banlist: result");

# Delete Banlist
# __mode=delete&_type=banlist&id=1&blog_id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'banlist', id => 1, blog_id => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Delete banlist");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete banlist: result");


# Create a new Notification
# __mode=save&_type=notification&&blog_id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'notification', blog_id => 1, }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new notification");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Notification: result");

# Delete Notification
# __mode=delete&_type=notification&id=1&blog_id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'notification', id => 1, blog_id => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Delete notification");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete notification: result");


# Create a new Role
# __mode=save&_type=role&&blog_id=1&name=NewRole
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'role', name => "NewRole" }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new role");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Role: result");

# Delete Role
# __mode=delete&_type=role&id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'role', id => 1, }
);
$out = delete $app->{__test_output};
ok ($out, "Delete role");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete role: result");


# Create a new Config
# __mode=save&_type=config
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'config' }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new config");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Config: result");

# Delete Config
# __mode=delete&_type=config&id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'config', id => 1, }
);
$out = delete $app->{__test_output};
ok ($out, "Delete config");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete config: result");


# Create a new Fileinfo
# __mode=save&_type=fileinfo&blog_id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'fileinfo', blog_id => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new fileinfo");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Fileinfo: result");

# Delete Fileinfo
# __mode=delete&_type=fileinfo&id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'fileinfo', id => 1, }
);
$out = delete $app->{__test_output};
ok ($out, "Delete fileinfo");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete fileinfo: result");


# Create a new Log
# __mode=save&_type=log&blog_id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'log', blog_id => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new log");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Log: result");

# Delete Log
# __mode=delete&_type=log&id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'log', id => 1, }
);
$out = delete $app->{__test_output};
ok ($out, "Delete log");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete log: result");

# Create a new ObjectAsset
# __mode=save&_type=objectasset&asset_id=1&object_id=1&object_ds=entry
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'objectasset', asset_id => 1, object_id => 1, object_ds => 'entry' }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new objectasset");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Objectasset: result");

# Delete Objectasset
# __mode=delete&_type=objectasset&id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'objectasset', id => 1, }
);
$out = delete $app->{__test_output};
ok ($out, "Delete objectasset");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete objectasset: result");


# Create a new Objectscore
# __mode=save&_type=objectscore&namespace=scope_name&object_ds=entry
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'objectscore', namespace => 'scope_name', object_ds => 'entry' }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new objectscore");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Objectscore: result");

# Delete Objectscore
# __mode=delete&_type=objectscore&id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'objectscore', id => 1, }
);
$out = delete $app->{__test_output};
ok ($out, "Delete objectscore");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete objectscore: result");


# Create a new Objecttag
# __mode=save&_type=objecttag&tag_id=1&object_datasource=entry&object_id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'objecttag', object_datasource => 'entry', tag_id => 1, object_id => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new objecttag");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Objecttag: result");

# Delete Objecttag
# __mode=delete&_type=objecttag&id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'objecttag', id => 1, }
);
$out = delete $app->{__test_output};
ok ($out, "Delete objecttag");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete objecttag: result");


# Create a new Permission
# __mode=save&_type=permission&blog_id=1&author_id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'permission', author_id => 1, blog_id => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new permission");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Permission: result");

# Delete Permission
# __mode=delete&_type=permission&id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'permission', id => 1, }
);
$out = delete $app->{__test_output};
ok ($out, "Delete permission");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete permission: result");


# Create a new Placement
# __mode=save&_type=placement&blog_id=1&category_id=1&entry_id=1&is_primary=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'placement', blog_id => 1, category_id => 1, entry_id => 1, is_primary => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new placement");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Placement: result");

# Delete Placement
# __mode=delete&_type=placement&id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'placement', id => 1, }
);
$out = delete $app->{__test_output};
ok ($out, "Delete placement");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete placement: result");

# Create a new Session
# __mode=save&_type=session&id=THIS_IS_A_FAKE_SESSION_2&start=currenttime
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'session', id => 'THIS_IS_A_FAKE_SESSION_2', time => time }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new session");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Session: result");

# Delete Session
# __mode=delete&_type=session&id=THIS_IS_A_FAKE_SESSION
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'session', id => 'THIS_IS_A_FAKE_SESSION', }
);
$out = delete $app->{__test_output};
ok ($out, "Delete session");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete session: result");


# Create a new Tag
# __mode=save&_type=tag&name=NewTag
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'tag', name => 'NewTag' }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new tag");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Tag: result");

# Delete Tag
# __mode=delete&_type=tag&id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'tag', id => 1, }
);
$out = delete $app->{__test_output};
ok ($out, "Delete tag");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete tag: result");


# Create a new Ping
# __mode=save&_type=ping&blog_id=1&ip=1.1.1.1&tb_id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'ping', blog_id => 1, ip => '1.1.1.1', tb_id => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new ping");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Ping: result");

# Delete Ping
# __mode=delete&_type=ping&id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'ping', id => 1, }
);
$out = delete $app->{__test_output};
ok ($out, "Delete ping");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete ping: result");


# Create a new Touch
# __mode=save&_type=touch
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'touch', }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new touch");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Touch: result");

# Delete Touch
# __mode=delete&_type=touch&id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'touch', id => 1, }
);
$out = delete $app->{__test_output};
ok ($out, "Delete touch");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete touch: result");


# Create a new Trackback
# __mode=save&_type=trackback&blog_id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'trackback', blog_id => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new trackback");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Trackback: result");

# Delete Trackback
# __mode=delete&_type=trackback&id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'trackback', id => 1, }
);
$out = delete $app->{__test_output};
ok ($out, "Delete trackback");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete trackback: result");


# Create a new Template
# __mode=save&_type=template&blog_id=1&name=NewTemplate&type=custom
$user = MT::Author->load(3); # Bobd
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'template', blog_id => 1, name => 'NewTemplate', type => 'custom' }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new template");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Template: result");

# Delete Template
# __mode=delete&_type=template&id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'template', id => 1, }
);
$out = delete $app->{__test_output};
ok ($out, "Delete template");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete template: result");


# Create a new Templatemap
# __mode=save&_type=templatemap&blog_id=1&archive_type=Author&template_id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'templatemap', blog_id => 1, archive_type => 'Author', template_id => 1 }
);
$out = delete $app->{__test_output};
ok ($out, "Create a new templatemap");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Templatemap: result");

# Delete Templatemap
# __mode=delete&_type=templatemap&id=1
$app = _run_app(
    'MT::App::CMS',
    { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'templatemap', id => 1, }
);
$out = delete $app->{__test_output};
ok ($out, "Delete templatemap");
ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete templatemap: result");












if ( $mt->component('commercial') ) {
    # Create a new Field
    # __mode=save&_type=field&blog_id=1&name=NewField&object_type=entry&type=SingleLineText&tag=newtag
    $app = _run_app(
        'MT::App::CMS',
        { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'field', blog_id => 1, name => 'NewField', object_type => 'entry', tag => 'newtag', type => 'SingleLineText' }
    );
    $out = delete $app->{__test_output};
    ok ($out, "Create a new field");
    ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Field: result");

    # Delete Field
    # __mode=delete&_type=field&id=1&blog_id=1
    $app = _run_app(
        'MT::App::CMS',
        { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'field', id => 1, blog_id => 1 }
    );
    $out = delete $app->{__test_output};
    ok ($out, "Delete field");
    ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete field: result");
}

if ( $mt->component('enterprise') ) {
    # Create a new Group
    # __mode=save&_type=group&blog_id=1&name=NewGroup
    $app = _run_app(
        'MT::App::CMS',
        { __test_user => $user, __request_method => 'POST', __mode => 'save', _type => 'group', name => 'NewGroup', }
    );
    $out = delete $app->{__test_output};
    ok ($out, "Create a new group");
    ok ($out =~ m/__mode=dashboard&permission=1/i, "Create a new Group: result");

    # Delete Group
    # __mode=delete&_type=group&id=1
    $app = _run_app(
        'MT::App::CMS',
        { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'group', id => 1, }
    );
    $out = delete $app->{__test_output};
    ok ($out, "Delete group");
    ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete group: result");
}








# # Delete Website (different type)
# # __mode=delete&_type=website&id=1
# $app = _run_app(
#     'MT::App::CMS',
#     { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'website', id => 1 }
# );
# $out = delete $app->{__test_output};
# ok ($out, "Delete website");
# ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete website: result");


# # Delete Blog (different type)
# # __mode=delete&_type=blog&id=2
# $app = _run_app(
#     'MT::App::CMS',
#     { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'blog', id => 2 }
# );
# $out = delete $app->{__test_output};
# ok ($out, "Delete blog");
# ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete blog: result");


# # Delete Category (different type)
# # __mode=delete&_type=category&id=20&blog_id=1
# $app = _run_app(
#     'MT::App::CMS',
#     { __test_user => $user, __request_method => 'POST', __mode => 'delete', _type => 'category', id => 20, blog_id => 1 }
# );
# $out = delete $app->{__test_output};
# ok ($out, "Delete category");
# ok ($out =~ m/__mode=dashboard&permission=1/i, "Delete category: result");




sub make_data {

    ### Author
    require MT::Author;
    my $aikawa = MT::Author->new();
    $aikawa->set_values(
        {
            name             => 'aikawa',
            nickname         => 'Ichiro Aikawa',
            email            => 'aikawa@example.com',
            url              => 'http://aikawa.com/',
            api_password     => 'seecret',
            auth_type        => 'MT',
            created_on       => '19780131074500',
        }
    );
    $aikawa->set_password("pass");
    $aikawa->type( MT::Author::AUTHOR() );
    $aikawa->id(999);
    $aikawa->save()
      or die "Couldn't save author record 999: " . $aikawa->errstr;

    MT::ObjectDriver::Driver::Cache::RAM->clear_cache();

    ### Association
    require MT::Role;
    my $designer_role = MT::Role->load( { name => 'Designer' } );

    require MT::Association;
    my $assoc = MT::Association->new();
    $assoc->author_id( $aikawa->id );
    $assoc->blog_id(1);
    $assoc->role_id( $designer_role->id );
    $assoc->type(1);
    $assoc->save();

    MT::ObjectDriver::Driver::Cache::RAM->clear_cache();

    ### IPBanList
    require MT::IPBanList;
    my $banlist = MT::IPBanList->new();
    $banlist->set_values({
        blog_id => 1,
        ip => '1.2.3.4',
    });
    $banlist->save()
        or die "Couldn't save ipbanlist record: 1". $banlist->errstr;

    MT::ObjectDriver::Driver::Cache::RAM->clear_cache();

    ### Notification
    require MT::Notification;
    my $address = MT::Notification->new();
    $address->set_values({
        blog_id => 1,
        name => 'Foo Bar',
        email => 'foo@example.com',
        url => 'http://foo.com',
    });
    $address->save()
        or die "Couldn't save notification record: 1". $address->errstr;

    MT::ObjectDriver::Driver::Cache::RAM->clear_cache();


    ## Session
    require MT::Session;
    my $sess = MT::Session->new();
    $sess->id( 'THIS_IS_A_FAKE_SESSION' );
    $sess->kind('UD');
    $sess->start(time);
    $sess->set( 'remember', 1 );
    $sess->save
        or die "Couldn't save session record". $sess->errstr;


    ### Log
    MT->log({
        message =>  'This is a log message.',
        class    => "system",
        level    => MT::Log::ERROR(),
        category => "test",
    });

    MT::ObjectDriver::Driver::Cache::RAM->clear_cache();



    ### Addons Data
    if ( $mt->component('commercial') ) {
        require CustomFields::Field;
        my $field = CustomFields::Field->new();
        $field->set_values({
            blog_id => 1,
            name => 'SingleLine',
            obj_type => 'entry',
            type => 'SingleLineText',
            tag => 'EntryDataSingleLine',
            basename => 'singleline',
        });
        $field->save()
            or die "Couldn't save custom field record: 1". $field->errstr;
    }

    MT::ObjectDriver::Driver::Cache::RAM->clear_cache();

    if ( $mt->component('enterprise') ) {
        require MT::Group;
        my $group = MT::Group->new();
        $group->set_values({
            name => 'New Group',
            status => 1,
            display_name => 'Group',
        });
        $group->save()
            or die "Couldn't save group record: 1" . $group->errstr;
    }

    MT::ObjectDriver::Driver::Cache::RAM->clear_cache();

}

