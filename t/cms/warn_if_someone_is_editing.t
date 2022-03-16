use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use Test::MockTime::HiRes;
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

my $Autosave_Session_Alert_TTL = do {
    require MT::App::CMS;
    no warnings('once');
    $MT::App::CMS::Autosave_Session_Alert_TTL;
};

subtest 'entry' => sub {
    my $app = MT::Test::App->new('CMS');
    $app->login($author1);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'entry',
        blog_id => $site->id,
        id      => $entry->id,
    });
    my @messages = $app->message_text_all;
    is(@messages, 1, 'right number of alerts');
    unlike $messages[0] => qr/is also editing/, "no warning";
    $app->{_app}->user($author1);
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
    @messages = $app->message_text_all;
    is(@messages, 2, 'right number of alerts');
    like $messages[0] => qr/author1 is also editing the same entry/, "has a warning";

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
    @messages = $app->message_text_all;
    is(@messages, 2, 'right number of alerts');
    unlike $messages[0] => qr/author1 is also editing the same entry/, "has no more warning";

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

    @messages = $app->message_text_all;
    is(@messages, 2, 'right number of alerts');
    like $messages[0] => qr/A saved version of this entry.+?but it is outdated/, "warned the saved session is outdated";

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

    # new entry
    $app->get_ok({
        __mode  => 'view',
        _type   => 'entry',
        blog_id => $site->id,
    });

    $app->{_app}->user($author1);
    ok $session = $app->{_app}->autosave_session_obj(1);
    $session->save;

    $app->get_ok({
        __mode  => 'view',
        _type   => 'entry',
        blog_id => $site->id,
    });
    ok !$app->generic_error, "no error";

    $session->remove, $session2->remove;
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
    my @messages = $app->message_text_all;
    is(@messages, 1, 'right number of alerts');
    unlike $messages[0] => qr/is also editing/, "no warning";
    $app->{_app}->user($author1);
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
    @messages = $app->message_text_all;
    is(@messages, 2, 'right number of alerts');
    like $messages[0] => qr/author1 is also editing the same page/, "has a warning";

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
    @messages = $app->message_text_all;
    is(@messages, 2, 'right number of alerts');
    unlike $messages[0] => qr/author1 is also editing the same page/, "has no more warning";

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

    @messages = $app->message_text_all;
    is(@messages, 2, 'right number of alerts');
    like $messages[0] => qr/A saved version of this page.+?but it is outdated/, "warned the saved session is outdated";

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

    # new page
    $app->get_ok({
        __mode  => 'view',
        _type   => 'page',
        blog_id => $site->id,
    });

    $app->{_app}->user($author1);
    ok $session = $app->{_app}->autosave_session_obj(1);
    $session->save;

    $app->get_ok({
        __mode  => 'view',
        _type   => 'page',
        blog_id => $site->id,
    });
    ok !$app->generic_error, "no error";

    $session->remove, $session2->remove;
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
    my @messages = $app->message_text_all;
    is(@messages, 0, 'right number of alerts');
    unlike $messages[0] => qr/is also editing/, "no warning";
    $app->{_app}->user($author1);
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
    @messages = $app->message_text_all;
    is(@messages, 1, 'right number of alerts');
    like $messages[0] => qr/author1 is also editing the same template/, "has a warning";

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
    @messages = $app->message_text_all;
    is(@messages, 1, 'right number of alerts');
    unlike $messages[0] => qr/author1 is also editing the same template/, "has no more warning";

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

    @messages = $app->message_text_all;
    is(@messages, 1, 'right number of alerts');
    like $messages[0] => qr/A saved version of this Template.+?but it is outdated/, "warned the saved session is outdated";

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

    # new template
    $app->get_ok({
        __mode  => 'view',
        _type   => 'template',
        blog_id => $site->id,
        type    => 'index',
    });

    $app->{_app}->user($author1);
    ok $session = $app->{_app}->autosave_session_obj(1);
    $session->save;

    $app->get_ok({
        __mode  => 'view',
        _type   => 'template',
        blog_id => $site->id,
        type    => 'index',
    });
    ok !$app->generic_error, "no error";

    $session->remove, $session2->remove;
};

subtest 'cd' => sub {
    my $app = MT::Test::App->new('CMS');
    $app->login($author1);
    $app->get_ok({
        __mode          => 'view',
        _type           => 'content_data',
        blog_id         => $site->id,
        content_type_id => $cd->content_type_id,
        id              => $cd->id,
    });
    my @messages = $app->message_text_all;
    is(@messages, 1, 'right number of alerts');
    unlike $messages[0] => qr/is also editing/, "no warning";
    $app->{_app}->user($author1);
    ok my $session = $app->{_app}->autosave_session_obj(1);
    $session->save;

    $app->login($author2);
    $app->{_app}->user($author2);
    $app->get_ok({
        __mode          => 'view',
        _type           => 'content_data',
        blog_id         => $site->id,
        content_type_id => $cd->content_type_id,
        id              => $cd->id,
    });
    @messages = $app->message_text_all;
    is(@messages, 2, 'right number of alerts');
    like $messages[0] => qr/author1 is also editing the same data/, "has a warning";

    sleep 1;    # to make sure session for the author2 is newer

    # author2 decides to continue to edit
    $app->{_app}->user($author2);
    ok my $session2 = $app->{_app}->autosave_session_obj(1);
    $session2->save;

    # now author2's autosave is the latest; no need to warn anymore
    $app->login($author2);
    $app->{_app}->user($author2);
    $app->get_ok({
        __mode          => 'view',
        _type           => 'content_data',
        blog_id         => $site->id,
        content_type_id => $cd->content_type_id,
        id              => $cd->id,
    });
    @messages = $app->message_text_all;
    is(@messages, 2, 'right number of alerts');
    unlike $messages[0] => qr/author1 is also editing the same data/, "has no more warning";

    # let author2 update the content data
    $app->post_form_ok();

    $app->{_app}->user($author2);
    ok !$app->{_app}->autosave_session_obj, "no autosave session for author2";

    # now author1 should have a message to recover/discard the saved session
    $app->login($author1);
    $app->get_ok({
        __mode          => 'view',
        _type           => 'content_data',
        blog_id         => $site->id,
        content_type_id => $cd->content_type_id,
        id              => $cd->id,
    });

    @messages = $app->message_text_all;
    is(@messages, 2, 'right number of alerts');
    like $messages[0] => qr/A saved version of this content data.+?but it is outdated/, "warned the saved session is outdated";

    $app->{_app}->user($author1);
    ok $app->{_app}->autosave_session_obj, "autosave session for author1 still exists";

    $app->get_ok({
        __mode          => 'view',
        _type           => 'content_data',
        blog_id         => $site->id,
        content_type_id => $cd->content_type_id,
        id              => $cd->id,
        _discard        => 1,
    });

    $app->{_app}->user($author1);
    ok !$app->{_app}->autosave_session_obj, "autosave session for author1 is discarded";

    # new content data
    $app->get_ok({
        __mode          => 'view',
        _type           => 'content_data',
        content_type_id => $cd->content_type_id,
        blog_id         => $site->id,
    });

    $app->{_app}->user($author1);
    ok $session = $app->{_app}->autosave_session_obj(1);
    $session->save;

    $app->get_ok({
        __mode          => 'view',
        _type           => 'content_data',
        content_type_id => $cd->content_type_id,
        blog_id         => $site->id,
    });
    ok !$app->generic_error, "no error";

    $session->remove, $session2->remove;
};

subtest 'entry autosave session expiration' => sub {
    mock_time sub {
        my $app = MT::Test::App->new('CMS');
        $app->login($author1);
        $app->get_ok({
            __mode  => 'view',
            _type   => 'entry',
            blog_id => $site->id,
            id      => $entry->id,
        });
        my @messages = $app->message_text_all;
        is(@messages, 1, 'right number of alerts');
        unlike $messages[0] => qr/is also editing/, "no warning";
        $app->{_app}->user($author1);
        ok my $session = $app->{_app}->autosave_session_obj(1);
        $session->save;

        # sleep until right before ttl
        sleep $Autosave_Session_Alert_TTL - 1;

        $app->login($author2);
        $app->{_app}->user($author2);
        $app->get_ok({
            __mode  => 'view',
            _type   => 'entry',
            blog_id => $site->id,
            id      => $entry->id,
        });
        @messages = $app->message_text_all;
        is(@messages, 2, 'right number of alerts');
        like $messages[0] => qr/author1 is also editing the same entry/, "has no warning";

        # sleep until right after ttl
        sleep 1;

        $app->login($author2);
        $app->{_app}->user($author2);
        $app->get_ok({
            __mode  => 'view',
            _type   => 'entry',
            blog_id => $site->id,
            id      => $entry->id,
        });
        @messages = $app->message_text_all;
        is(@messages, 1, 'right number of alerts');
        unlike $messages[0] => qr/author1 is also editing the same entry/, "has a warning";

        $session->remove;
    }, time;
};

done_testing;
