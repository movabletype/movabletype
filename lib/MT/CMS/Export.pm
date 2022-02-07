# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::Export;

use strict;
use warnings;
use MT::Util qw( dirify );
use Encode;

sub start_export {
    my $app = shift;
    my %param;
    my $blog_id = $app->param('blog_id');

    return $app->permission_denied()
        if !$app->can_do('open_blog_export_screen');

    my $blog = $app->model('blog')->load($blog_id);
    return $app->return_to_dashboard( redirect => 1 )
        if !$blog;

    my $status = $app->model('import_export_status')->load({
        blog_id  => $blog_id,
        ended_at => \'IS NULL',
        type     => 1,
    });
    if ($status) {
        $param{status} = $status->as_hashref_for_site($blog);
    }

    if (MT->config->ForceBackgroundExport) {
        $param{background_export_is_available} = 1;
        $param{force_background_export}        = 1;
    } elsif (MT->config->EnableBackgroundExport) {
        $param{background_export_is_available} = 1;
    }

    $param{blog_id} = $blog_id;
    $app->add_breadcrumb( $app->translate('Export Site Entries') );
    $app->load_tmpl( 'export.tmpl', \%param );
}

sub export {
    my $app     = shift;
    my $charset = $app->charset;
    require MT::Blog;
    my $blog_id = $app->param('blog_id')
        or
        return $app->error( $app->translate("Please select a site."), 400 );
    my $blog = MT::Blog->load($blog_id)
        or return $app->error(
        $app->translate(
            "Loading site '[_1]' failed: [_2]", $blog_id,
            MT::Blog->errstr
        ),
        404
        );
    my $perms = $app->permissions;
    return $app->error( $app->translate("You do not have export permissions"),
        403 )
        unless $perms && $perms->can_do('export_blog');
    $app->validate_magic() or return;
    my $status = $app->model('import_export_status')->load({
        blog_id  => $blog_id,
        ended_at => \'IS NULL',
        type     => 1,
    });
    if ($status) {
        return $app->redirect($app->uri(
            mode => 'start_export',
            args => { blog_id => $blog_id },
        ));
    }
    $status = $app->model('import_export_status')->new(
        blog_id => $blog_id,
        type    => 1,
    );

    if ($app->param('background_export')) {
        return _register_background_export($app, $status);
    }

    $status->started_at(time);
    $status->save;

    my $file = dirify( $blog->name ) . ".txt";

    if ( $file eq ".txt" ) {
        my @ts = localtime(time);
        $file = sprintf "export-%06d-%04d%02d%02d%02d%02d%02d.txt",
            $blog_id, $ts[5] + 1900, $ts[4] + 1,
            @ts[ 3, 2, 1, 0 ];
    }

    $app->{no_print_body} = 1;
    local $| = 1;

    $app->set_header( "Content-Disposition" => "attachment; filename=$file" );
    $app->send_http_header(
        $charset
        ? "text/plain; charset=$charset"
        : 'text/plain'
    );
    require MT::ImportExport;
    MT::ImportExport->export( $blog, sub { $app->print_encode(@_) } )
        or return $app->error( MT::ImportExport->errstr, 500 );

    $status->ended_at(time);
    $status->save;

    1;
}

sub _register_background_export {
    my ($app, $status) = @_;

    require MT::TheSchwartz;
    require TheSchwartz::Job;
    require JSON;
    require Digest::MD5;

    my %param;
    for my $key ($app->multi_param) {
        next if $key =~ /\A(?:magic_token|__mode)\z/;
        $param{$key} = $app->param($key);
    }

    my $blog_id = $app->param('blog_id');

    $param{author_id} = $app->user->id;

    my $job = TheSchwartz::Job->new;
    $job->funcname('MT::Worker::Export');
    $job->uniqkey(Digest::MD5::md5_hex(join "-", "export", $blog_id, time));
    $job->arg(JSON::encode_json(\%param));
    $job->run_after(time);
    MT::TheSchwartz->insert($job);

    $status->job_id($job->jobid);
    $status->save;

    return $app->redirect($app->uri(
        mode => 'background_export',
        args => {
            blog_id => $blog_id,
            id      => $status->id,
            saved   => 1,
        },
    ));
}

sub background_export {
    my $app       = shift;
    my $blog_id   = $app->param('blog_id');
    my $status_id = $app->param('id');

    my $perms = $app->permissions;
    return $app->permission_denied()
        unless $perms && $app->can_do('open_start_export_screen');

    my $blog = $app->model('blog')->load($blog_id)
        or return $app->return_to_dashboard(redirect => 1);

    my $status = $app->model('import_export_status')->load($status_id);
    if (!$status) {
        return $app->redirect($app->uri(
            mode => 'start_export',
            args => { blog_id => $blog_id },
        ));
    }

    my %param;
    if ($status->job_id) {
        my $job = $app->model('ts_job')->load($status->job_id);
        if ($job) {
            if ($job->grabbed_until > time) {
                $param{job_is_running} = 1;
            }
            # $param{job_arg} = JSON->new->pretty->canonical->encode(JSON::decode_json($job->arg));
        } else {
            $param{job_is_gone} = 1;
        }
    }

    $param{status} = $status->as_hashref_for_site($blog);

    my $file = $param{status}{file};
    $param{can_download} = 1 if $file && -f $file;

    $param{saved}  = $app->param('saved');

    $app->add_breadcrumb($app->translate('Background Export Site Entries'));
    $app->load_tmpl('background_export.tmpl', \%param);
}

sub download_export {
    my $app       = shift;
    my $blog_id   = $app->param('blog_id');
    my $status_id = $app->param('id');

    my $perms = $app->permissions;
    return $app->permission_denied()
        unless $perms && $app->can_do('open_start_export_screen');

    my $blog = $app->model('blog')->load($blog_id)
        or return $app->return_to_dashboard(redirect => 1);

    my $status = $app->model('import_export_status')->load($status_id);
    if (!$status) {
        return $app->redirect($app->uri(
            mode => 'start_export',
            args => { blog_id => $blog_id },
        ));
    }

    my $file = $status->get_data->{file};
    unless ($file && -f $file) {
        return $app->redirect($app->uri(
            mode => 'start_export',
            args => { blog_id => $blog_id },
        ));
    }

    $app->{no_print_body} = 1;
    local $| = 1;

    my $utf8 = Encode::find_encoding('utf8');
    my $charset = $app->charset;
    $app->set_header("Content-Disposition" => "attachment; filename=$file");
    $app->send_http_header(
        $charset
        ? "text/plain; charset=$charset"
        : 'text/plain'
    );
    open my $fh, '<', $file or return $app->error($app->translate("Cannot open [_1].", $file));
    while(<$fh>) {
        $app->print_encode($utf8->decode($_));
    }
    close $fh;
    1;
}

1;
