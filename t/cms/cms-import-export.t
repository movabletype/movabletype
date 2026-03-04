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

use MT;
use MT::Author;
use MT::CMS::Export;
use MT::Blog;
use MT::Comment;
use MT::Entry;
use MT::Import;
use MT::ImportExport;
use MT::Test;
use MT::Test::App;
use MT::Test::Permission;

$test_env->prepare_fixture('db_data');

my $blog = MT::Blog->load(1);
my $user = MT::Author->load(2);

# export entries from a valid blog
my $app = MT::Test::App->new('MT::App::CMS');
$app->login($user);

subtest 'export with invalid blog id' => sub {
    # export entries for an invalid blog
    my $res = eval { $app->post_ok({ __mode => 'export', blog_id => 1000 }); };
    my $error = $@ || $app->generic_error;
    like($error, qr/Invalid request/i, "Failed as expected");
};

subtest 'basic' => sub {

    my $export_file;

    subtest 'export' => sub {
        $app->post_ok({ __mode => 'export', blog_id => $blog->id });
        my $good_out = $app->content;
        note $good_out;
        $export_file = $test_env->save_file('test_export1.txt', $good_out);
    };

    my @entries  = MT::Entry->load({ blog_id => $blog->id });
    my @comments;
    for my $entry (@entries) {
        push @comments, @{$entry->comments({visible => 1})};
        $entry->remove;
    }
    MT::Comment->remove({ blog_id => $blog->id });
    ok(MT::Entry->count({ blog_id => $blog->id }) == 0,   "Got rid of all entries");
    ok(MT::Comment->count({ blog_id => $blog->id }) == 0, "Got rid of all comments");

    subtest 'import back to same site' => sub {
        test_import($blog, $user, $export_file);
        is(MT::Entry->count({ blog_id => $blog->id }), scalar @entries, 'same number of entries found');

        subtest 'comment' => sub {
            $test_env->skip_unless_plugin_exists('Comments');
            is(MT::Comment->count({ blog_id => $blog->id }), scalar(@comments), 'same number of comments found');
        };
    };

    subtest 'import to new site' => sub {
        my $site = MT::Test::Permission->make_website(name => 'import test');
        test_import($site, $user, $export_file);
        is(MT::Entry->count({ blog_id => $site->id }), scalar @entries, 'same number of entries found');

        subtest 'comment' => sub {
            $test_env->skip_unless_plugin_exists('Comments');
            is(MT::Comment->count({ blog_id => $site->id }), scalar(@comments), 'same number of comments found');
        };
        $site->remove;
    };
};

subtest 'delimiters appear in export data by chance' => sub {

    my $SEP     = $MT::ImportExport::SEP;
    my $SUB_SEP = $MT::ImportExport::SUB_SEP;
    my $TAB     = $MT::ImportExport::TAB;

    for my $sep ($SEP, $SUB_SEP) {

        subtest qq!test for "$sep"! => sub {

            my $site = MT::Test::Permission->make_website(name => 'import test');

            my $entry_text = <<"ENTRY_TEXT";
We will be helding the CMS conference. See the information below.
quote until $sep
bla bla
$sep
Best regards,
ENTRY_TEXT

            my $entry = MT::Test::Permission->make_entry(
                blog_id   => $site->id,
                author_id => $user->id,
                title     => 'Upcoming CMS conference',
                text      => $entry_text,
            );

            my $comment_text = <<"COMMENT_TEXT";
I'd like to participate in the conference.
$sep
Best regards,
COMMENT_TEXT

            my $comment = MT::Test::Permission->make_comment(
                blog_id      => $site->id,
                entry_id     => $entry->id,
                commenter_id => $user->id,
                text         => $comment_text,
            );

            my $export_file;

            subtest 'export' => sub {
                $app->post_ok({ __mode => 'export', blog_id => $site->id });
                my $good_out = $app->content;
                like $good_out, qr/^$sep$TAB$/m, 'delimiters are escaped';
                $export_file = $test_env->save_file('test_export2.txt', $good_out);
            };

            $site->remove;
            my $site2 = MT::Test::Permission->make_website(name => 'import test2');

            subtest 'import' => sub {
                test_import($site2, $user, $export_file);
                my @entries = MT::Entry->load({ blog_id => $site2->id });
                is @entries, 1, 'right number of entries';
                note $entries[0]->text;
                like $entries[0]->text, qr/^$sep$/m,          'separator like string appears';
                like $entries[0]->text, qr/^Best regards,$/m, 'following line alives';

                subtest 'comment' => sub {
                    $test_env->skip_unless_plugin_exists('Comments');
                    my @comments = MT::Comment->load({ blog_id => $site2->id, entry_id => $entries[0]->id });
                    is @comments, 1, 'right number of comments';
                    note $comments[0]->text;
                    like $comments[0]->text, qr/^$sep$/m,          'separator like string appears';
                    like $comments[0]->text, qr/^Best regards,$/m, 'following line alives';
                };
            };

            $site2->remove;
        };
    }
};

sub test_import {
    my ($site, $user, $file) = @_;

    # use the file as the input to the import script
    my $impt = MT::Import->new;
    my $ie   = MT::ImportExport->new;
    my $iter = $impt->_get_stream_iterator($file, sub {
        my ($string) = @_;
        print STDERR "[cb_iterator] $string\n";
        1;
    });

    my %param = ();
    $param{'Iter'}              = $iter;
    $param{'Blog'}              = $site;
    $param{'Callback'}          = 1;
    $param{'ParentAuthor'}      = $user;
    $param{'NewAuthorPassword'} = 'PASSWORD';
    $param{'ConvertBreaks'}     = '';
    $param{'Callback'}          = sub {
        my ($string) = @_;
        print " $string\n";
        1;
    };
    my $result = $ie->import_contents(%param);
}

done_testing;
