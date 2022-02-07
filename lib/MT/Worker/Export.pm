# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.

package MT::Worker::Export;

use strict;
use warnings;
use base qw( TheSchwartz::Worker );
use MT::ImportExport;
use MT::Mail;
use MT::Util qw(dirify);
use MT::Util::Log;
use JSON;
use File::Spec;
use Encode;
use TheSchwartz::Job;

sub work {
    my $class = shift;
    my TheSchwartz::Job $job = shift;

    my $arg = JSON::decode_json($job->arg);
    my $blog_id = $arg->{blog_id} || 0;

    my $status = MT->model('import_export_status')->load({
        blog_id  => $blog_id,
        job_id   => $job->jobid,
        type     => 1,
    });
    if (!$status) {
        $status = MT->model('import_export_status')->new({
            blog_id  => $blog_id,
            job_id   => $job->jobid,
            type     => 1,
        });
    }

    MT::Util::Log::init();
    MT::Util::Log->info(MT->translate("Background export entries from site [_1] has started.", $blog_id));

    $status->started_at(time);
    $status->save;

    my $res = do_export($arg);

    if ($res->{error}) {
        $job->permanent_failure($res->{error});

        notify(
            %$arg,
            template => 'notify-bg-export-error.tmpl',
            subject  => MT->translate('Export failed'),
            message  => $res->{error},
        );
        $status->set_data({ error => $res->{error} });

        MT::Util::Log->info(MT->translate("Background export entries from site [_1] has failed.", $blog_id));
    } else {
        $job->completed;

        require MT::App::CMS;
        my $app = MT::App::CMS->new;

        my $link = $app->base . $app->mt_uri(
            mode => 'download_export',
            args => {
                blog_id => $blog_id,
                id      => $status->id,
            },
        );
        $status->set_data({ file => $res->{file}, link => $link });

        notify(
            %$arg,
            template => 'notify-bg-export.tmpl',
            subject  => MT->translate('Export completed'),
            message  => $link,
        );

        # comment out until $res returns a brief summary as raw log may become too large
        # $status->data($res->{error});

        MT::Util::Log->info(MT->translate("Background export entries from site [_1] has finished.", $arg->{blog_id}));
    }

    $status->ended_at(time);
    $status->save;
}

sub do_export {
    my $arg = shift;

    my $blog = MT->model('blog')->load($arg->{blog_id})
        or return { error => MT->translate("Loading site '[_1]' failed: [_2]", $arg->{blog_id}, MT::Blog->errstr) };

    my $tmpdir = MT->config->ExportTempDir || MT->config->TempDir;
    if (!-d $tmpdir) {
        require File::Path;
        File::Path::mkpath($tmpdir);
    }

    my @ts = localtime(time);
    my $name = sprintf "export-%06d-%04d%02d%02d%02d%02d%02d.txt",
        $arg->{blog_id}, $ts[5] + 1900, $ts[4] + 1, @ts[ 3, 2, 1, 0 ];
    my $file = File::Spec->catfile($tmpdir, $name);

    open my $fh, '>', $file or return { error => "$file: $!" };
    my $enc = Encode::find_encoding('utf8');

    my $ok = MT::ImportExport->export($blog, sub {
        my @lines = @_;
        for my $line (@lines) {
            print $fh $enc->encode($line);
        }
    });

    close $fh;

    if ($ok) {
        return { file => $file };
    } else {
        return { error => MT::ImportExport->errstr || 'Unknown export error' };
    }
}

sub notify {
    my %params = @_;

    my $author = delete $params{author};
    my $from   = MT->config->EmailAddressMain;
    # XXX: notify_to?
    my $to   = $author && $author->email ? $author->email : $from;
    my %head = (
        From    => $from,
        To      => $to,
        Subject => $params{subject},
    );
    $params{site_id} = $params{blog_id};
    my $template = delete $params{template};
    my $body     = MT->build_email($template, \%params) or return;

    my $sent = MT::Mail->send(\%head, $body);
    if (!$sent) {
        MT->log({
            message  => MT->translate('Error sending mail: [_1]', MT::Mail->errstr),
            level    => MT::Log::ERROR(),
            class    => 'system',
            category => 'email',
        });
    }
}

sub grab_for    { 600 }
sub max_retries { 1 }
sub retry_delay { 60 }

1;
