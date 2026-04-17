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
        DefaultLanguage => 'en_US',
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::App;
use MT::Util qw(trim);

$test_env->prepare_fixture('db');

my $website = MT::Test::Permission->make_website(name => 'website');
my $admin   = MT::Author->load(1);
my $entry   = MT::Test::Permission->make_entry(
    blog_id     => $website->id,
    author_id   => $admin->id,
    authored_on => '20260407000000',
    title       => 'entry',
    status      => MT::EntryStatus::HOLD(),
);
my $app = MT::Test::App->new('MT::App::CMS');
$app->login($admin);

subtest 'update entry' => sub {
    $app->get_ok({
        __mode  => 'view',
        _type   => 'entry',
        blog_id => $website->id,
        id      => $entry->id,
    });

    my $form  = $app->form;
    my $input = $form->find_input('__mode');
    $input->readonly(0);
    $input->value('save');
    $input = $form->find_input('text');
    $input->value('UPDATE!');

    $app->post_ok($form->click);
};

subtest 'update revision note' => sub {

    $app->get_ok({
        __mode  => 'list_revision',
        _type   => 'entry',
        blog_id => $website->id,
        id      => $entry->id,
    });
    my $content = $app->content;
    my ($obj_id) = $content =~ qr{\s+id: (\d+)};
    is $obj_id, $entry->id, 'object id';

    my $elems = $app->wq_find('.revision-note');
    is extract_text($elems), '', 'revision note is empty';
    my $rev_id = $elems->first->data('rev-number');

    my $res = $app->js_post_ok({
        __mode          => 'js_save_rev',
        _type           => 'entry',
        blog_id         => $website->id,
        r               => $rev_id,
        id              => $entry->id,
        'revision-note' => 'first',
    });

    is_deeply MT::Util::from_json($res->content), { error => undef, result => { success => 1 } }, 'success';

    $app->get_ok({
        __mode  => 'list_revision',
        _type   => 'entry',
        blog_id => $website->id,
        id      => $entry->id,
    });
    $elems = $app->wq_find('.revision-note');
    is extract_text($elems), 'first', 'updated';
    my $log = MT::Log->load(
        { class => 'MT::Entry::Revision', category => 'edit' },
        { sort  => 'id', direction => 'descend', limit => 1 });
    is $log->metadata, ' => first', 'log';
};

subtest 'update revision note again' => sub {
    MT::Log->remove_all();

    $app->get_ok({
        __mode  => 'list_revision',
        _type   => 'entry',
        blog_id => $website->id,
        id      => $entry->id,
    });
    my $elems = $app->wq_find('.revision-note');

    is extract_text($elems), 'first', 'note';
    my $rev_id = $elems->first->data('rev-number');

    my $res = $app->js_post_ok({
        __mode          => 'js_save_rev',
        _type           => 'entry',
        blog_id         => $website->id,
        r               => $rev_id,
        id              => $entry->id,
        'revision-note' => 'second',
    });

    is_deeply MT::Util::from_json($res->content), { error => undef, result => { success => 1 } }, 'success';

    $app->get_ok({
        __mode  => 'list_revision',
        _type   => 'entry',
        blog_id => $website->id,
        id      => $entry->id,
    });
    $elems = $app->wq_find('.revision-note');

    is extract_text($elems), 'second', 'updated';

    my $log = MT::Log->load(
        { class => 'MT::Entry::Revision', category => 'edit' },
        { sort  => 'id', direction => 'descend', limit => 1 });
    is $log->metadata, 'first => second', 'log';
};

subtest 'error' => sub {

    my $res = $app->js_post_ok({
        __mode          => 'js_save_rev',
        _type           => 'entry',
        blog_id         => $website->id,
        id              => $entry->id,
        'revision-note' => 'FUGAHOGE',
    });

    is_deeply MT::Util::from_json($res->content), { error => "Invalid request." }, 'error';
};

sub extract_text {
    my ($elems) = @_;
    return trim(
        $elems->contents->filter(sub {
            my ($idx, $elem) = @_;
            return unless $elem->get(0)->isTextNode;
            return $elem;
        })->text
    );
}

done_testing;
