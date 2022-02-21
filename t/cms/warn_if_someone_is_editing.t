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

use MT::Test;
use MT::Test::App;

$test_env->prepare_fixture('archive_type');

my $author1 = MT::Author->load({ name => 'author1' });
my $author2 = MT::Author->load({ name => 'author2' });
my $site    = MT::Website->load({ name => 'site_for_archive_test' });
my $entry   = MT::Entry->load({ title => 'entry_author1_ruler_eraser' });
my $page    = MT::Page->load({ title => 'page_author1_coffee' });
my $cd      = MT::ContentData->load({ label => 'cd_same_apple_orange' });
my $tmpl    = MT::Template->load({ name => 'tmpl_individual' });

$site->server_offset(0);
$site->save;

subtest 'entry' => sub {
    my $app = MT::Test::App->new('CMS');
    $app->login($author1);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'entry',
        blog_id => $site->id,
        id      => $entry->id,
    });
    unlike $app->message_text => qr/is also editing/, "no warning";
    $app->{_app}->user($author1);
    my $entry_epoch = MT::Util::ts2epoch($site, $entry->modified_on);
    ok my $session = $app->{_app}->autosave_session_obj(1);
    $session->save;

    $app->login($author2);
    $app->{_app}->user($author2);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'entry',
        blog_id => $site->id,
        id      => $entry->id,
    });
    like $app->message_text => qr/author1 is also editing the same entry/, "has a warning";

    sleep 1;    # to make sure session for the author2 is newer

    # author2 decides to continue to edit
    $app->{_app}->user($author2);
    ok my $session2 = $app->{_app}->autosave_session_obj(1);
    $session2->save;

    # now author2's autosave is the latest; no need to warn anymore
    $app->login($author2);
    $app->{_app}->user($author2);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'entry',
        blog_id => $site->id,
        id      => $entry->id,
    });
    unlike $app->message_text => qr/author1 is also editing the same entry/, "has no more warning";

    # let author2 update the entry
    $app->post_form_ok();

    $app->{_app}->user($author2);
    ok !$app->{_app}->autosave_session_obj, "no autosave session for author2";

    # now author1 should have a message to recover/discard the saved session
    $app->login($author1);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'entry',
        blog_id => $site->id,
        id      => $entry->id,
    });

    like $app->message_text => qr/A saved version of this entry.+?but it is outdated/, "warned the saved session is outdated";

    $app->{_app}->user($author1);
    ok $app->{_app}->autosave_session_obj, "autosave session for author1 still exists";

    $app->get_ok({
        __mode   => 'view',
        _type    => 'entry',
        blog_id  => $site->id,
        id       => $entry->id,
        _discard => 1,
    });

    $app->{_app}->user($author1);
    ok !$app->{_app}->autosave_session_obj, "autosave session for author1 is discarded";
};

subtest 'page' => sub {
    my $app = MT::Test::App->new('CMS');
    $app->login($author1);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'page',
        blog_id => $site->id,
        id      => $page->id,
    });
    unlike $app->message_text => qr/is also editing/, "no warning";
    $app->{_app}->user($author1);
    my $page_epoch = MT::Util::ts2epoch($site, $page->modified_on);
    ok my $session = $app->{_app}->autosave_session_obj(1);
    $session->save;

    $app->login($author2);
    $app->{_app}->user($author2);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'page',
        blog_id => $site->id,
        id      => $page->id,
    });
    like $app->message_text => qr/author1 is also editing the same page/, "has a warning";

    sleep 1;    # to make sure session for the author2 is newer

    # author2 decides to continue to edit
    $app->{_app}->user($author2);
    ok my $session2 = $app->{_app}->autosave_session_obj(1);
    $session2->save;

    # now author2's autosave is the latest; no need to warn anymore
    $app->login($author2);
    $app->{_app}->user($author2);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'page',
        blog_id => $site->id,
        id      => $page->id,
    });
    unlike $app->message_text => qr/author1 is also editing the same page/, "has no more warning";

    # let author2 update the page
    $app->post_form_ok();

    $app->{_app}->user($author2);
    ok !$app->{_app}->autosave_session_obj, "no autosave session for author2";

    # now author1 should have a message to recover/discard the saved session
    $app->login($author1);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'page',
        blog_id => $site->id,
        id      => $page->id,
    });

    like $app->message_text => qr/A saved version of this page.+?but it is outdated/, "warned the saved session is outdated";

    $app->{_app}->user($author1);
    ok $app->{_app}->autosave_session_obj, "autosave session for author1 still exists";

    $app->get_ok({
        __mode   => 'view',
        _type    => 'page',
        blog_id  => $site->id,
        id       => $page->id,
        _discard => 1,
    });

    $app->{_app}->user($author1);
    ok !$app->{_app}->autosave_session_obj, "autosave session for author1 is discarded";
};

subtest 'template' => sub {
    my $app = MT::Test::App->new('CMS');
    $app->login($author1);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'template',
        blog_id => $site->id,
        id      => $tmpl->id,
    });
    unlike $app->message_text => qr/is also editing/, "no warning";
    $app->{_app}->user($author1);
    my $template_epoch = MT::Util::ts2epoch($site, $tmpl->modified_on);
    ok my $session = $app->{_app}->autosave_session_obj(1);
    $session->save;

    $app->login($author2);
    $app->{_app}->user($author2);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'template',
        blog_id => $site->id,
        id      => $tmpl->id,
    });
    like $app->message_text => qr/author1 is also editing the same template/, "has a warning";

    sleep 1;    # to make sure session for the author2 is newer

    # author2 decides to continue to edit
    $app->{_app}->user($author2);
    ok my $session2 = $app->{_app}->autosave_session_obj(1);
    $session2->save;

    # now author2's autosave is the latest; no need to warn anymore
    $app->login($author2);
    $app->{_app}->user($author2);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'template',
        blog_id => $site->id,
        id      => $tmpl->id,
    });
    unlike $app->message_text => qr/author1 is also editing the same template/, "has no more warning";

    # let author2 update the entry
    $app->post_form_ok();

    $app->{_app}->user($author2);
    ok !$app->{_app}->autosave_session_obj, "no autosave session for author2";

    # now author1 should have a message to recover/discard the saved session
    $app->login($author1);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'template',
        blog_id => $site->id,
        id      => $tmpl->id,
    });

    like $app->message_text => qr/A saved version of this Template.+?but it is outdated/, "warned the saved session is outdated";

    $app->{_app}->user($author1);
    ok $app->{_app}->autosave_session_obj, "autosave session for author1 still exists";

    $app->get_ok({
        __mode   => 'view',
        _type    => 'template',
        blog_id  => $site->id,
        id       => $tmpl->id,
        _discard => 1,
    });

    $app->{_app}->user($author1);
    ok !$app->{_app}->autosave_session_obj, "autosave session for author1 is discarded";
};

subtest 'cd' => sub {
    my $app = MT::Test::App->new('CMS');
    $app->login($author1);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'content_data',
        blog_id => $site->id,
        content_type_id => $cd->content_type_id,
        id      => $cd->id,
    });
    unlike $app->message_text => qr/is also editing/, "no warning";
    $app->{_app}->user($author1);
    my $cd_epoch = MT::Util::ts2epoch($site, $cd->modified_on);
    ok my $session = $app->{_app}->autosave_session_obj(1);
    $session->save;

    $app->login($author2);
    $app->{_app}->user($author2);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'content_data',
        blog_id => $site->id,
        content_type_id => $cd->content_type_id,
        id      => $cd->id,
    });
    like $app->message_text => qr/author1 is also editing the same data/, "has a warning";

    sleep 1;    # to make sure session for the author2 is newer

    # author2 decides to continue to edit
    $app->{_app}->user($author2);
    ok my $session2 = $app->{_app}->autosave_session_obj(1);
    $session2->save;

    # now author2's autosave is the latest; no need to warn anymore
    $app->login($author2);
    $app->{_app}->user($author2);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'content_data',
        blog_id => $site->id,
        content_type_id => $cd->content_type_id,
        id      => $cd->id,
    });
    unlike $app->message_text => qr/author1 is also editing the same data/, "has no more warning";

    # let author2 update the content data
    $app->post_form_ok();

    $app->{_app}->user($author2);
    ok !$app->{_app}->autosave_session_obj, "no autosave session for author2";

    # now author1 should have a message to recover/discard the saved session
    $app->login($author1);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'content_data',
        blog_id => $site->id,
        content_type_id => $cd->content_type_id,
        id      => $cd->id,
    });

    like $app->message_text => qr/A saved version of this content data.+?but it is outdated/, "warned the saved session is outdated";

    $app->{_app}->user($author1);
    ok $app->{_app}->autosave_session_obj, "autosave session for author1 still exists";

    $app->get_ok({
        __mode   => 'view',
        _type    => 'content_data',
        blog_id  => $site->id,
        content_type_id => $cd->content_type_id,
        id      => $cd->id,
        _discard => 1,
    });

    $app->{_app}->user($author1);
    ok !$app->{_app}->autosave_session_obj, "autosave session for author1 is discarded";
};

done_testing;
