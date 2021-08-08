#!/usr/bin/perl
# $Id:$
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::App;
use MT::Test::Permission;
use MT::CMS::Tools;
use Data::Dumper;
use MT::Author;
use TheSchwartz::Job;
use MT::TheSchwartz;
use MT::Util;
use MT::Util::Archive;
use File::Temp;
use File::Basename;
use MT::BackupRestore::Session;
use MT::Worker::BackupRestore;

{
    my $job;
    no warnings 'redefine';
    my $create_backup_job = \&MT::CMS::Tools::create_backup_job;
    *MT::CMS::Tools::create_backup_job = sub { $job = $create_backup_job->(@_) };
    my $create_restore_job = \&MT::CMS::Tools::create_restore_job;
    *MT::CMS::Tools::create_restore_job = sub { $job = $create_restore_job->(@_) };

    my $client = MT::TheSchwartz->new();
    $client->can_do('MT::Worker::BackupRestore');

    sub _run_latest_job {
        $client->work_once($job);
    }
}

my $test_cases = [

    {
        name                         => 'ContentData',
        prepare_fixture              => sub { $test_env->prepare_fixture('mt7/multiblog/common1') },
        blog_id                      => '0',
        backup_what                  => '',
        backup_archive_format        => 'zip',
        local_filename               => 'test.zip',
        expected_mime                => qr{^application/zip;},
        expected_content_disposition => qr{attachment; filename="Movable_Type-(.+)-Export.zip},
        assert_progress              => 10,
        expected_dialog_param        => qr{__mode=dialog_adjust_sitepath&blog_ids=4,5,6&tmp_dir=%2Ftmp%2Frestore%3A1&restore_upload=1},
        expect_blog_added            => 6,
        background                   => 1,
    },
    {
        name                         => 'Parent site context zip roundtrip',
        blog_id                      => '1',
        backup_what                  => '1',
        backup_archive_format        => 'zip',
        local_filename               => 'test.zip',
        expected_mime                => qr{^application/zip;},
        expected_content_disposition => qr{attachment; filename="Movable_Type-(.+)-Export.zip},
        assert_progress              => 10,
        expected_dialog_param        => qr{__mode=dialog_adjust_sitepath&blog_ids=4&tmp_dir=%2Ftmp%2Frestore%3A1&restore_upload=1},
        expect_blog_added            => 4,
        background                   => 1,
    },
    {
        name                         => 'Child site context zip roundtrip',
        blog_id                      => '3',
        backup_what                  => '3',
        backup_archive_format        => 'zip',
        local_filename               => 'test.zip',
        expected_mime                => qr{^application/zip;},
        expected_content_disposition => qr{attachment; filename="Movable_Type-(.+)-Export.zip},
        assert_progress              => 10,
        expected_dialog_param        => qr{__mode=dialog_adjust_sitepath&blog_ids=4&tmp_dir=%2Ftmp%2Frestore%3A1&restore_upload=1},
        expect_blog_added            => 4,
        background                   => 1,
    },
    {
        name                         => 'Child site xml roundtrip',
        blog_id                      => '3',
        backup_what                  => '3',
        backup_archive_format        => 0,
        local_filename               => 'test.xml',
        expected_mime                => qr{^text/xml;},
        expected_content_disposition => qr{attachment; filename="Movable_Type-(.+)-Export.xml},
        assert_progress              => 10,
        expected_dialog_param        => qr{__mode=dialog_adjust_sitepath&blog_ids=4&tmp_dir=&restore_upload=1},
        expect_blog_added            => 4,
        background                   => 1,
    },
    {
        name                         => 'child manifest via zip multiple roundtrip',
        blog_id                      => '3',
        backup_what                  => '3',
        backup_archive_format        => 'zip',
        local_filename               => 'test.zip',
        expected_mime                => qr{^application/zip;},
        expected_content_disposition => qr{attachment; filename="Movable_Type-(.+)-Export.zip},
        file_convert                 => sub { get_manifest_from_zip(@_) },
        expected_dialog_param        => qr{__mode=dialog_restore_upload&start=1&files=&assets=&current_file=Movable_Type-(.+)-Export.xml&last=1&schema_version=(.+)&overwrite_templates=0&redirect=1},
        background                   => 1,
    },
    {
        name                         => 'system zip single roundtrip',
        blog_id                      => '0',
        backup_what                  => '1',
        backup_archive_format        => 'zip',
        local_filename               => 'test.zip',
        expected_mime                => qr{^application/zip;},
        expected_content_disposition => qr{attachment; filename="Movable_Type-(.+)-Export.zip},
        assert_progress              => 10,
        expected_dialog_param        => qr{__mode=dialog_adjust_sitepath&blog_ids=4&tmp_dir=%2Ftmp%2Frestore%3A1&restore_upload=1},
        expect_blog_added            => 4,
        background                   => 1,
    },
    {
        name                         => 'system zip single parent with child site roundtrip',
        blog_id                      => '0',
        backup_what                  => '2',
        backup_archive_format        => 'zip',
        local_filename               => 'test.zip',
        expected_mime                => qr{^application/zip;},
        expected_content_disposition => qr{attachment; filename="Movable_Type-(.+)-Export.zip},
        assert_progress              => 10,
        expected_dialog_param        => qr{__mode=dialog_adjust_sitepath&blog_ids=4,5&tmp_dir=%2Ftmp%2Frestore%3A1&restore_upload=1},
        expect_blog_added            => 5,
        background                   => 1,
    },
    {
        name                         => 'system zip single and parent site roundtrip',
        blog_id                      => '0',
        backup_what                  => '1,2',
        backup_archive_format        => 'zip',
        local_filename               => 'test.zip',
        expected_mime                => qr{^application/zip;},
        expected_content_disposition => qr{attachment; filename="Movable_Type-(.+)-Export.zip},
        assert_progress              => 10,
        expected_dialog_param        => qr{__mode=dialog_adjust_sitepath&blog_ids=4,5,6&tmp_dir=%2Ftmp%2Frestore%3A1&restore_upload=1},
        expect_blog_added            => 6,
        background                   => 1,
    },
    {
        name                         => 'system xml multiple roundtrip',
        blog_id                      => '0',
        backup_what                  => '1,2',
        backup_archive_format        => 0,
        local_filename               => 'test.xml',
        expected_mime                => qr{^text/xml;},
        expected_content_disposition => qr{attachment; filename="Movable_Type-(.+)-Export.xml},
        assert_progress              => 10,
        expected_dialog_param        => qr{__mode=dialog_adjust_sitepath&blog_ids=4,5,6&tmp_dir=&restore_upload=1},
        expect_blog_added            => 6,
        background                   => 1,
    },
    {
        name                         => 'system tgz multiple roundtrip',
        blog_id                      => '0',
        backup_what                  => '1,2',
        backup_archive_format        => 'tgz',
        local_filename               => 'test.tar.gz',
        expected_mime                => qr{^application/x-tar-gz;},
        expected_content_disposition => qr{attachment; filename="Movable_Type-(.+)-Export.tar.gz},
        assert_progress              => 10,
        expected_dialog_param        => qr{__mode=dialog_adjust_sitepath&blog_ids=4,5,6&tmp_dir=%2Ftmp%2Frestore%3A1&restore_upload=1},
        expect_blog_added            => 6,
        background                   => 1,
    },
    {
        name                         => 'system manifest via zip multiple roundtrip',
        blog_id                      => '0',
        backup_what                  => '1,2',
        backup_archive_format        => 'zip',
        local_filename               => 'test.zip',
        expected_mime                => qr{^application/zip;},
        expected_content_disposition => qr{attachment; filename="Movable_Type-(.+)-Export.zip},
        file_convert                 => sub { get_manifest_from_zip(@_) },
        expected_dialog_param        => qr{__mode=dialog_restore_upload&start=1&files=&assets=&current_file=Movable_Type-(.+)-Export.xml&last=1&schema_version=(.+)&overwrite_templates=0&redirect=1},
        background                   => 1,
    },
    {
        name            => 'Backup by non-super user',
        prepare_fixture => sub {
            require MT::Role;
            require MT::Association;
            $test_env->prepare_fixture('cms/common1');
            my $aikawa     = MT::Test::Permission->make_author(name => 'aikawa', nickname => 'Ichiro Aikawa');
            my $site_admin = MT::Role->load({ name => MT->translate('Site Administrator') });
            my $site       = MT::Blog->load(1);
            MT::Association->link($aikawa => $site_admin => $site);
        },
        author_id                    => 2,
        blog_id                      => '1',
        backup_what                  => '1',
        backup_archive_format        => 'zip',
        local_filename               => 'test.zip',
        expected_mime                => qr{^application/zip;},
        expected_content_disposition => qr{attachment; filename="Movable_Type-(.+)-Export.zip},
        assert_progress              => 10,
        expected_dialog_param        => qr{__mode=dialog_adjust_sitepath&blog_ids=4&tmp_dir=%2Ftmp%2Frestore%3A1&restore_upload=1},
        expect_blog_added            => 4,
        background                   => 1,
    },
    {
        name                         => 'foreground processing',
        blog_id                      => '1',
        backup_what                  => '1',
        backup_archive_format        => 'zip',
        local_filename               => 'test.zip',
        expected_mime                => qr{^application/zip;},
        expected_content_disposition => qr{attachment; filename="Movable_Type-(.+)-Export.zip},
        assert_progress              => 10,
        expected_dialog_param        => qr{__mode=dialog_adjust_sitepath&blog_ids=4&tmp_dir=%2Ftmp%2Frestore%3A1&restore_upload=1},
        expect_blog_added            => 4,
        background                   => 0,
    },
];

for my $props (@$test_cases) {
    subtest $props->{name} => sub {
        $props->{prepare_fixture} ? $props->{prepare_fixture}->() : $test_env->prepare_fixture('cms/common1');
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login(MT::Author->load($props->{author_id} || 1));
        $app->post_ok({
            __mode                => 'backup', blog_id => $props->{blog_id}, backup_what => $props->{backup_what},
            backup_archive_format => $props->{backup_archive_format}, size_limit => 0,
            background            => $props->{background},
        });
        is($app->page_title, ($props->{blog_id} ? 'Export Site' : 'Export Sites'), 'right title');

        _run_latest_job() if $props->{background};
        note_session('backup:' . $app->{user}->id);

        $app->get_ok({ __mode => 'backup_result' });
        my $json = MT::Util::from_json($app->{res}->content);
        is($json->{result}->{done}, 1, 'marked done');
        ok(@{ $json->{result}->{progress} } > 10, 'progress contain at least 10 entity');
        my $filename = $json->{result}->{urls}->[0]->{filename};
        ok($filename, 'filename is given');

        $app->post_ok({ __mode => 'backup_download', blog_id => $props->{blog_id}, filename => $filename });
        my $res = $app->{res};
        is $res->code, 200, 'right status';
        like $res->header('content-type'),        $props->{expected_mime},                'right content-type';
        like $res->header('content-disposition'), $props->{expected_content_disposition}, 'right content-disposition';

        my $path = write_temp_file($props->{local_filename}, $res->content);
        $path = $props->{file_convert}->($path) if $props->{file_convert};

        # Upload is only allowed for super user
        $app->login(MT::Author->load(1));
        $app->post_ok({ __mode => 'restore', background => $props->{background}, __test_upload => ['file', $path] });

        _run_latest_job() if $props->{background};
        note_session('restore:1');

        $app->get_ok({ __mode => 'restore_result' });
        my $res2  = $app->{res};
        my $json2 = MT::Util::from_json($res2->content);
        is($json2->{result}->{done}, 1, 'marked done');
        ok(@{ $json2->{result}->{progress} } > $props->{assert_progress}, 'progress contain at least 10 entity')
            if $props->{assert_progress};
        like($json2->{result}->{dialog_params}, $props->{expected_dialog_param}, 'right dialog params');

        if ($props->{expect_blog_added}) {
            my $count = MT::Blog->count({ class => '*' });
            is $count, $props->{expect_blog_added}, 'right number of blogs';
        }

        MT::Object->driver->clear_cache;
        MT->instance->request->reset;
        MT::BackupRestore::Session->purge(-1);

        done_testing();
    };
}

#subtest 'pre ftp' => sub {
#    # TODO IMPLEMENT
#};

sub compact_progress {
    my $raw = shift;
    my %messages;
    my @keys;
    my $i = 1;
    for my $e (@$raw) {
        my $id = $e->{id} || $i++;
        push @keys, $id unless exists($messages{$id});
        $messages{$id} = $e->{message};
    }
    return [map { $messages{$_} } @keys];
}

sub note_session {
    my $sess = MT::BackupRestore::Session->load(shift);
    note 'Progress: ' . Dumper(compact_progress($sess->progress));
    note 'Error: ' . $sess->error if $sess->error;
}

sub write_temp_file {
    my ($name, $content) = @_;
    my $path = File::Spec->catfile(File::Temp::tempdir(), $name);
    open(my $fh, '>', $path);
    print $fh $content;
    close($fh);
    return $path;
}

sub get_manifest_from_zip {
    my ($zip) = @_;
    my $arc = MT::Util::Archive->new('zip', $zip);
    ok $arc->is_safe_to_extract, 'zip is safe';
    my $dir = File::Basename::dirname($zip);
    $arc->extract($dir);
    my ($manifest) = grep { $_ =~ /.manifest$/ } $arc->files;
    $arc->close;
    $manifest = File::Spec->catfile($dir, $manifest);
    ok(-f $manifest, 'manifest is found');
    return $manifest;
}

done_testing();
