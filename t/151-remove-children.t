#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test qw(:db);
use MT::Test::Permission;

# Create test data
my $website = MT::Test::Permission->make_website();
my $entry   = MT::Test::Permission->make_entry( blog_id => $website->id, );
my $page    = MT::Test::Permission->make_page( blog_id => $website->id, );
my $template
    = MT::Test::Permission->make_template( blog_id => $website->id, );
die $template->errstr unless $template;
my $asset = MT::Test::Permission->make_asset( blog_id => $website->id, );
my $category
    = MT::Test::Permission->make_category( blog_id => $website->id, );
my $folder = MT::Test::Permission->make_folder( blog_id => $website->id, );
die $folder->errstr unless $folder;
my $notification
    = MT::Test::Permission->make_notification( blog_id => $website->id, );
die $notification->errstr unless $notification;
my $log = MT::Test::Permission->make_log( blog_id => $website->id, );
my $objtag = MT::Test::Permission->make_objecttag( blog_id => $website->id, );
my $association = MT->model('association')->new;
$association->set_values(
    {   blog_id   => $website->id,
        author_id => 1,
        type      => 1,
    }
);
$association->save or die $association->errstr;
my $comment = MT::Test::Permission->make_comment( blog_id => $website->id, );
my $ping = MT::Test::Permission->make_ping( blog_id => $website->id, );
my $trackback = MT::Test::Permission->make_tb( blog_id => $website->id, );
my $tmplmap
    = MT::Test::Permission->make_templatemap( blog_id => $website->id, );
my $touch = MT::Test::Permission->make_touch( blog_id => $website->id, );
my $formatted_text;

if ( MT->model('formatted_text') ) {
    $formatted_text = MT->model('formatted_text')->new;
    $formatted_text->set_values(
        {   blog_id => $website->id,
            label   => 'Formatted Text',
        }
    );
    $formatted_text->save or die $formatted_text->errstr;
}

# Clear cache
MT->model('entry')->driver->Disabled(1) if MT->model('entry')->driver->can('Disabled');
MT->model('comment')->driver->Disabled(1) if MT->model('comment')->driver->can('Disabled');

# Do tests
$website->remove;
is( MT->model('website')->load( $website->id ),
    undef, 'Website has been deleted.' );
is( MT->model('entry')->load( $entry->id ),
    undef, 'Website entry has been deleted.' );
is( MT->model('page')->load( $page->id ),
    undef, 'Website page has been deleted.' );
is( MT->model('template')->load( $template->id ),
    undef, 'Website template has been deleted.' );
is( MT->model('asset')->load( $asset->id ),
    undef, 'Website asset has been deleted.' );
is( MT->model('category')->load( $category->id ),
    undef, 'Website category has been deleted.' );
is( MT->model('folder')->load( $folder->id ),
    undef, 'Website folder has been deleted.' );
is( MT->model('notification')->load( $notification->id ),
    undef, 'Website notification has been deleted.' );
is( MT->model('log')->load( $log->id ),
    undef, 'Website log has been deleted.' );
is( MT->model('objecttag')->load( $objtag->id ),
    undef, 'Website objecttag has been deleted.' );
is( MT->model('association')->load( $association->id ),
    undef, 'Website association has been deleted.' );
is( MT->model('comment')->load( $comment->id ),
    undef, 'Website comment has been deleted.' );
is( MT->model('tbping')->load( $ping->id ),
    undef, 'Website trackback ping has been deleted.' );
is( MT->model('trackback')->load( $trackback->id ),
    undef, 'Website trackback has been deleted.' );
is( MT->model('templatemap')->load( $tmplmap->id ),
    undef, 'Website template map has been deleted.' );
is( MT->model('touch')->load( $touch->id ),
    undef, 'Website touch has been deleted.' );
SKIP: {
    skip 'Formatted Text plugin is not installed.', 1 unless $formatted_text;
    is( MT->model('formatted_text')->load( $formatted_text->id ),
        undef, 'Website formatted text has been deleted.' );
}

done_testing;
