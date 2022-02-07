# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.

package MT::Worker::Import;

use strict;
use warnings;
use base qw( TheSchwartz::Worker );
use MT::Import;
use MT::ImportExport;
use MT::Mail;
use MT::Util::Log;
use JSON;
use TheSchwartz::Job;

sub work {
    my $class = shift;
    my TheSchwartz::Job $job = shift;

    my $arg = JSON::decode_json($job->arg);

    my $blog_id = $arg->{blog_id};

    MT::Util::Log::init();
    MT::Util::Log->info(MT->translate("Background import entries into site [_1] has started.", $blog_id));

    my $status = MT->model('import_export_status')->load({
        blog_id  => $blog_id,
        job_id   => $job->jobid,
        type     => 0,
    });
    if (!$status) {
        $status = MT->model('import_export_status')->new(
            blog_id => $blog_id,
            job_id  => $job->jobid,
            type    => 0,
        );
    }
    $status->started_at(time);
    $status->save;

    my $res = do_import($arg);

    if ($res->{error}) {
        $job->permanent_failure($res->{error});

        notify(
            %$arg,
            template => 'notify-bg-import-error.tmpl',
            subject  => MT->translate('Import failed'),
            message  => $res->{error},
        );
        $status->set_data({ error => $res->{error} });

        MT::Util::Log->info(MT->translate("Background import entries into site [_1] has failed.", $blog_id));
    } else {
        $job->completed;

        notify(
            %$arg,
            template => 'notify-bg-import.tmpl',
            subject  => MT->translate('Import completed'),
            message  => join "\n", @{ $res->{log} || [] },
        );

        # comment out until $res returns a brief summary as raw log may become too large
        # $status->set_data({ summary => $res->{summary} });

        MT::Util::Log->info(MT->translate("Background import entries into site [_1] has finished.", $blog_id));
    }

    $status->ended_at(time);
    $status->save;
}

sub do_import {
    my $arg = shift;

    my $imp = MT::Import->new;

    my $import_type = $arg->{import_type} || '';
    my $importer    = $imp->importer($import_type)
        or return { error => MT->translate('Importer type [_1] was not found.', $import_type) };

    my $blog = MT->model('blog')->load($arg->{blog_id})
        or return { error => MT->translate("Loading site '[_1]' failed: [_2]", $arg->{blog_id}, MT::Blog->errstr) };

    my $file = $arg->{file};
    unless ($file && -f $file) {
        return { error => MT->translate("Specified file was not found.") };
    }

    if (my $author_id = delete $arg->{author_id}) {
        $arg->{author} = MT->model('author')->load($author_id)
            or return { error => MT->translate("User not found") };
    }

    my %options;
    if ($importer->{options}) {
        %options = map { $_ => scalar $arg->{$_} } @{ $importer->{options} };
    }
    my $res = [];
    my $ok  = $imp->import_contents(
        Key      => $import_type,
        Blog     => $blog,
        Stream   => $file,
        Callback => sub {
            my @lines = @_;
            for my $line (@lines) {
                $line =~ s/\n+$//s;
                next unless $line;
                MT::Util::Log->info($line);
                push @$res, $line;
            }
        },
        Encoding => $arg->{encoding},
        ($arg->{import_as_me})
        ? (ImportAs => $arg->{author})
        : (ParentAuthor => $arg->{author}),
        NewAuthorPassword => $arg->{password},
        DefaultCategoryID => $arg->{default_cat_id},
        ConvertBreaks     => $arg->{convert_breaks},
        %options,
    );

    if ($ok) {
        unlink $file;
        return { log => $res };
    } else {
        return { error => $importer->{type}->errstr || 'Unknown import error' };
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
