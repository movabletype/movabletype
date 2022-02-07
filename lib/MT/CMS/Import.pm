# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::Import;

use strict;
use warnings;
use MT::I18N qw( const );

sub start_import {
    my $app     = shift;
    my $blog_id = $app->param('blog_id');

    my $perms = $app->permissions;
    return $app->permission_denied()
        unless $perms && $app->can_do('open_start_import_screen');

    my $blog = $app->model('blog')->load($blog_id)
        or return $app->return_to_dashboard(redirect => 1);

    my %param;
    my $status = $app->model('import_export_status')->load({
        blog_id  => $blog_id,
        ended_at => \'IS NULL',
        type     => 0,
    });
    if ($status) {
        $param{status} = $status->as_hashref_for_site($blog);
    }

    # FIXME: This should build a category hierarchy!
    my $cat_class = $app->model('category');
    my $iter      = $cat_class->load_iter({ blog_id => $blog_id, category_set_id => 0 });
    my @data;
    while (my $cat = $iter->()) {
        push @data, {
            category_id    => $cat->id,
            category_label => $cat->label
        };
    }
    @data                 = sort { $a->{category_label} cmp $b->{category_label} } @data;
    $param{category_loop} = \@data;
    $param{nav_import}    = 1;

    #$param{can_edit_authors} = $app->permissions->can_administer_site;
    $param{encoding_names} = const('ENCODING_NAMES');
    require MT::Auth;
    $param{password_needed} = MT::Auth->password_exists;

    my $importer_loop = [];
    require MT::Import;
    my $imp  = MT::Import->new;
    my @keys = $imp->importer_keys;
    for my $key (@keys) {
        my $importer = $imp->importer($key);
        push @$importer_loop, {
            label                 => $importer->{label},
            key                   => $key,
            description           => $importer->{description},
            importer_options_html => $imp->get_options_html($key, $blog_id),
        };
    }

    $param{importer_loop} = $importer_loop;

    $param{text_filters} = $app->load_text_filters($blog->convert_paras, 'entry');

    if (MT->config->ForceBackgroundImport) {
        $param{background_import_is_available} = 1;
        $param{force_background_import}        = 1;
    } elsif (MT->config->EnableBackgroundImport) {
        $param{background_import_is_available} = 1;
    }

    $app->add_breadcrumb($app->translate('Import Site Entries'));
    $app->load_tmpl('import.tmpl', \%param);
}

sub do_import {
    my $app = shift;

    require MT::Blog;
    my $blog_id = $app->param('blog_id')
        or return $app->return_to_dashboard(redirect => 1);

    my $blog = MT::Blog->load($blog_id);
    if (!$blog) {
        return $app->error($app->translate(
            "Loading site '[_1]' failed: [_2]", $blog_id,
            MT::Blog->errstr
        ));
    }

    if ('POST' ne $app->request_method) {
        return $app->redirect($app->uri(
            mode => 'start_import',
            args => { blog_id => $blog_id },
        ));
    }

    return $app->permission_denied()
        unless $app->user->permissions($blog_id)->can_do('import_blog');

    my $import_as_me = $app->param('import_as_me');

    ## Determine the user as whom we will import the entries.
    my $author    = $app->user;
    my $author_id = $author->id;

    $app->can_do('import_blog_as_me')
        or return $app->error($app->translate('You do not have import permission'));
    if (!$import_as_me) {
        $app->can_do('import_blog_with_authors')
            or return $app->error($app->translate('You do not have permission to create users'));
    }

    my $password       = $app->param('password');
    my $default_cat_id = $app->param('default_cat_id');
    my $convert_breaks = $app->param('convert_breaks');

    if (!$import_as_me and !$password and MT::Auth->password_exists) {
        return $app->error($app->translate('You need to provide a password if you are going to create new users for each user listed in your site.'));
    }

    $app->validate_magic() or return;

    my $status = $app->model('import_export_status')->load({
        blog_id  => $blog_id,
        ended_at => \'IS NULL',
        type     => 0,
    });
    if ($status) {
        return $app->redirect($app->uri(
            mode => 'start_import',
            args => { blog_id => $blog_id },
        ));
    }
    $status = $app->model('import_export_status')->new(
        blog_id => $blog_id,
        type    => 0,
    );

    if ($app->param('background_import')) {
        return _register_background_import($app, $status);
    }

    $status->started_at(time);
    $status->save;

    $app->add_breadcrumb(
        $app->translate('Import Site Entries'),
        $app->uri(
            mode => 'start_import',
            args => { blog_id => $blog_id },
        ),
    );
    $app->add_breadcrumb($app->translate('Import'));

    my ($fh)     = $app->upload_info('file');
    my $encoding = $app->param('encoding');
    my $stream   = $fh ? $fh : $app->config('ImportPath');

    $app->{no_print_body} = 1;

    local $| = 1;
    $app->send_http_header('text/html');

    my $param = { import_as_me => $import_as_me, import_upload => ($fh ? 1 : 0) };

    $app->print_encode($app->build_page('include/import_start.tmpl', $param));

    require MT::Entry;
    require MT::Placement;
    require MT::Category;
    require MT::Permission;
    require MT::Comment;
    require MT::TBPing;

    my $import_type = $app->param('import_type') || '';
    require MT::Import;
    my $imp      = MT::Import->new;
    my $importer = $imp->importer($import_type);

    return $app->error($app->translate('Importer type [_1] was not found.', $import_type))
        unless $importer;

    my %options = map { $_ => scalar $app->param($_); } @{ $importer->{options} || [] };

    my $import_result = $imp->import_contents(
        Key      => $import_type,
        Blog     => $blog,
        Stream   => $stream,
        Callback => sub { $app->print_encode(@_) },
        Encoding => $encoding,
        ($import_as_me)
        ? (ImportAs => $author)
        : (ParentAuthor => $author),
        NewAuthorPassword => $password,
        DefaultCategoryID => $default_cat_id,
        ConvertBreaks     => $convert_breaks,
        %options,
    );

    if ($import_result) {
        my $rebuild_url = $app->uri(
            mode => 'rebuild_confirm',
            args => { blog_id => $blog_id, },
        );
        $param->{rebuild_open} = qq!window.open('$rebuild_url', 'rebuild_blog_$blog_id', 'width=400,height=400,resizable=yes'); return false;!;

        $param->{import_success} = $import_result;
        $status->set_data({ success => 1 });
    } else {
        $param->{error} = $importer->{type}->errstr;
        $status->set_data({ error => $param->{error} });
    }

    $app->print_encode($app->build_page("include/import_end.tmpl", $param));

    close $fh if $fh;

    $status->ended_at(time);
    $status->save;
    1;
}

sub _register_background_import {
    my ($app, $status) = @_;

    require MT::TheSchwartz;
    require TheSchwartz::Job;
    require JSON;
    require Digest::MD5;

    my %param;
    for my $key ($app->multi_param) {
        next if $key =~ /\A(?:file|magic_token|__mode)\z/;
        $param{$key} = $app->param($key);
    }

    my $tmpdir = MT->config->ExportTempDir || MT->config->TempDir;
    if (my ($fh) = $app->upload_info('file')) {
        my $name    = join "-", "import", $param{blog_id}, time;    # or $app->param('file')
        my $tmpfile = File::Spec->catfile($tmpdir, $name);
        unless (-d $tmpdir) {
            require File::Path;
            File::Path::mktree($tmpdir);
        }
        open my $out, '>', $tmpfile
            or return $app->error($app->translate("Error writing upload to '[_1]': [_2]", $tmpfile, $!));
        my $buf;
        while ($fh->read($buf, 8192)) {
            print $out $buf;
        }
        $param{file} = $tmpfile;
    }
    $param{author_id} = $app->user->id;

    my $job = TheSchwartz::Job->new;
    $job->funcname('MT::Worker::Import');
    $job->uniqkey(Digest::MD5::md5_hex($param{file}));
    $job->arg(JSON::encode_json(\%param));
    $job->run_after(time);
    MT::TheSchwartz->insert($job);

    $status->job_id($job->jobid);
    $status->save;

    my $blog_id = $app->param('blog_id');
    return $app->redirect($app->uri(
        mode => 'background_import',
        args => {
            blog_id => $blog_id,
            id      => $job->jobid,
            saved   => 1,
        },
    ));
}

sub background_import {
    my $app       = shift;
    my $blog_id   = $app->param('blog_id');
    my $status_id = $app->param('id');

    my $perms = $app->permissions;
    return $app->permission_denied()
        unless $perms && $app->can_do('open_start_import_screen');

    my $blog = $app->model('blog')->load($blog_id)
        or return $app->return_to_dashboard(redirect => 1);

    my %param;
    my $status = $app->model('import_export_status')->load($status_id);
    if (!$status) {
        return $app->redirect($app->uri(
            mode => 'start_import',
            args => {
                blog_id => $blog_id,
            },
        ));
    }
    $param{status} = $status->as_hashref_for_site($blog);

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

    $param{saved} = $app->param('saved');

    $app->add_breadcrumb($app->translate('Background Import Site Entries'));
    $app->load_tmpl('background_import.tmpl', \%param);
}

1;
