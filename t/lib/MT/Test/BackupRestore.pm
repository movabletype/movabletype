package MT::Test::BackupRestore;

use strict;
use warnings;
use MT::Test::App;
use MT::Test::Fixture;
use MT::Test;
use File::Path;
use Test::More;
use URI;
use URI::QueryParam;
use Path::Tiny;
use HTML::Entities;
use Module::Find qw(usesub);
use File::Spec;

my $DEBUG = 1;
my @TEST_LIBS;

sub new {
    my $class = shift;
    my $self  = bless {@_}, $class;
    $self->reset;
    $self;
}

sub prepare {
    my $self     = shift;
    my $callback = ref $_[-1] eq 'CODE' ? pop : undef;
    my $spec     = _merge($self->_default_fixture_spec, @_);
    my $objs     = MT::Test::Fixture->prepare($spec);
    if ($callback) {
        $callback->($objs);
    }
    for my $site (values(%{ $objs->{website} || {} }), values(%{ $objs->{blog} || {} })) {
        MT->rebuild(BlogID => $site->id);
    }
    $objs;
}

sub _clear_mt_cache {
    my $self = shift;
    MT::Request->instance->reset;
    require MT::ObjectDriver::Driver::Cache::RAM;
    MT::ObjectDriver::Driver::Cache::RAM->clear_cache;
}

sub reset {
    my $self = shift;
    $self->_clear_mt_cache;
    MT::Test->init_db(not_create_website => 1);
    for my $e (glob "$ENV{MT_TEST_ROOT}/*") {
        next if $e =~ /(?:\.test.log|mt\-config\.cgi)$/;
        if (-d $e) {
            rmtree $e;
        } else {
            unlink $e;
        }
    }
}

sub backup {
    my ($self, %args) = @_;

    note "start backing up";

    $self->{backup_args} = \%args;

    my $admin = MT::Author->load(1);
    my $app   = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({
        __mode  => 'start_backup',
        blog_id => $args{blog_id} || 0,
    });
    my %form;
    if ($args{format}) {
        $form{backup_archive_format} = $args{format};
    }
    $app->post_form_ok(\%form);

    my $dir = $args{dir} || "$ENV{MT_TEST_ROOT}/.backup";
    mkpath($dir) unless -d $dir;
    my %files;
    if ($args{format}) {
        my $res = $app->post_form_ok();
        if ($res->is_success) {
            my $name = 'backup.' . ($args{format} eq 'tgz' ? 'tar.gz' : $args{format});
            my $file = File::Spec->catfile($dir, $name);
            path($file)->spew({ binmode => ':raw' }, $res->decoded_content);
            $files{$name} = $file;
        }
    } else {
        $app->wq_find('#backup-files li a')->each(sub {
            my $link  = $_;
            my $uri   = URI->new($link->attr('href'));
            my $param = $uri->query_form_hash;
            my $name  = $link->text;
            $name =~ s/^\s+Download:\s+//s;
            $name =~ s/\s*$//s;
            my $res = $app->get_ok($param);
            if ($res->is_success) {
                my $file = File::Spec->catfile($dir, $name);
                path($file)->spew({ binmode => ':raw' }, $res->decoded_content);
                $files{$name} = $file;
            }
        });
    }

    # for debugging
    if (my $backup_dir = $ENV{MT_TEST_COPY_BACKUP_FILES}) {
        mkpath($backup_dir) unless -d $backup_dir;
        for my $file (path($backup_dir)->children) {
            $file->remove if $file->stat->mtime < time - 24 * 60 * 60;
        }
        require File::Copy;
        for my $file (keys %files) {
            File::Copy::copy $files{$file} => path($backup_dir, $file);
        }
    }
    \%files;
}

sub restore {
    my ($self, %args) = @_;

    note "start restoring";

    $self->{restore_args} = \%args;

    my $callback = delete $args{callback};

    my $admin = MT::Author->load(1);
    my $app   = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({
        __mode  => 'start_restore',
        blog_id => 0,
    });
    my %files = %{ delete $args{files} || {} };
    my $next_file;
    while (%files) {
        my $form = $app->form or die "NO FORM";
        my $mode = $form->param('__mode');
        if ($form->find_input('file')) {
            if ($mode eq 'restore') {
                if (!$next_file) {
                    if (my ($manifest) = grep /\.manifest$/, keys %files) {
                        $next_file = $manifest;
                    } else {
                        ($next_file) = keys %files;
                    }
                }
            } elsif ($mode eq 'dialog_restore_upload') {
                $next_file = $app->wq_find('em.upload-file')->text;
            }
            my $file = delete $files{$next_file};
            ok $file && -f $file, "$next_file ($file) exists";
            $app->post_form_ok({ %args, file => $file });
        } else {
            my %form;
            for my $input ($app->form->inputs) {
                next if $input->readonly;
                next unless $input->name;
                $form{ $input->name } = $input->value;
            }
            note explain { $app->form->form };
            if ($callback) {
                $callback->(\%form);
            } else {
                my $root = quotemeta($ENV{MT_TEST_ROOT});
                for my $key (keys %form) {
                    if ($key =~ /^site_name_/) {
                        $form{$key} .= ' - Imported';
                    }
                    if ($key =~ /^site_path_/ && $form{$key}) {
                        $form{$key} =~ s!^$root[\\/]([^\\/]+)!$root/${1}_imported!i;
                    }
                    if ($key =~ /^archive_path_/ && $form{$key}) {
                        $form{$key} =~ s!^$root[\\/]([^\\/]+)!$root/${1}_imported!i;
                    }
                }
            }
            $app->post_form_ok(\%form);
        }
        if ($app->content =~ /jQuery.fn.mtModal.open\(\s*(\\?['"])([^)]+?)\1/s) {
            my $uri  = URI->new(HTML::Entities::decode_entities($2));
            my $mode = $uri->query_param('__mode');
            if ($mode eq 'dialog_adjust_sitepath') {
                note 'going to visit dialog_adjust_sitepath';
                $app->get_ok($uri->query_form_hash);
            } elsif ($mode eq 'dialog_restore_upload') {
                note 'going to visit dialog_restore_upload';
                $app->get_ok($uri->query_form_hash);
            } else {
                die "Oops unknown mode: $mode";
            }
            redo;
        }
    }
}

sub test_with {
    my ($self, $objs) = @_;
    $self->_clear_mt_cache;
    my %cache;

    if (!@TEST_LIBS) {
        local @INC = @INC;
        my %seen_inc;
        for my $inc (@INC) {
            my $tlib = File::Spec->catdir($inc, "t/lib");
            next if $seen_inc{$tlib}++;
            push @INC, $tlib if -d $tlib;
        }
        @TEST_LIBS = (__PACKAGE__, usesub __PACKAGE__);
    }

    my $object_types = MT->registry('object_types');
    my $instructions = MT->registry('backup_instructions');

    for my $site_type (qw(website blog)) {
        next unless $objs->{$site_type};
        for my $site (values %{ $objs->{$site_type} }) {
            my $new_name = $site->name . ' - Imported';
            my $new_site = MT->model($site_type)->load({ name => $new_name });
            ok($new_site, "new $site_type ($new_name) exists") or next;
            _column_values_are_ok($site_type, $site, $new_site);
            if ($site->parent_id) {
                my $new_parent = MT->model('website')->load($new_site->parent_id);
                ok $new_parent, "new parent site (@{[$new_parent->name]}) exixts";
            }

            my %seen;
            for my $type (sort keys %$object_types) {
                next if $type =~ /\./;
                next if $type =~ /^(?:website|blog)$/;
                next if $instructions->{$type}{skip};

                # ignore shortcuts
                next if $type =~ /^(?:cd|cf)$/;

                my $model = MT->model($type) or die "No model for $type";
                next if $seen{$model}++;
                next unless $model->can('blog_id');

                # ignore temporal tables (maybe they should not be exported)
                next if $model =~ /^MT::(?:IPBanList|DeleteFileInfo)$/;

                my $method = "_test_$type";
                my $found;
                for my $candidate (@TEST_LIBS) {
                    if ($candidate->can($method)) {
                        $found = $candidate;
                        last;
                    }
                }
                if ($found) {
                    print STDERR "FOUND METHOD $method in $found\n" if $DEBUG;
                    $found->$method($self, $objs, $site, $new_site, \%cache);
                } else {
                    print STDERR "SKIP: test method for $type ($method) does not exist!!!!!!\n";
                }
            }
            next;
        }
    }

    # system stuff
    {
        my %seen;
        for my $type (sort keys %$object_types) {
            next if $type =~ /\./;
            next if $type =~ /^(?:website|blog|site)$/;
            next if $instructions->{$type}{skip};
            my $model = MT->model($type) or die "No model for $type";
            next if $seen{$model}++;
            next if $model->can('blog_id');

            my $method = "_test_$type";
            my $found;
            for my $candidate (@TEST_LIBS) {
                if ($candidate->can($method)) {
                    $found = $candidate;
                    last;
                }
            }
            if ($found) {
                if ($seen{$method}++) {
                    diag "$method is seen twice";
                    next;
                }
                $found->$method($self, $objs, \%cache);
            } else {
                note "SKIP: test method for system $type does not exist!!!!!!";
            }
        }
    }
}

sub _test_entry {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    for my $entry (values %{ $objs->{entry} || {} }) {
        next if $entry->blog_id != $site->id;
        my $title     = $entry->title;
        my $new_entry = MT->model('entry')->load({ title => $title, blog_id => $new_site->id });
        ok($new_entry, "new entry ($title) exists") or next;
        _column_values_are_ok('entry', $entry, $new_entry);
        _relations_are_ok('entry', $entry, $new_entry, $cache);
    }
}

sub _test_page {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    my $count = MT->model('page')->count;
    if (!$count) {
        local $TODO = "Needs fixture";
        pass "No pages";
        return;
    }
    for my $page (values %{ $objs->{page} || {} }) {
        next if $page->blog_id != $site->id;
        my $title    = $page->title;
        my $new_page = MT->model('page')->load({ title => $title, blog_id => $new_site->id });
        ok($new_page, "new page ($title) exists") or next;
        _column_values_are_ok('page', $page, $new_page);
        _relations_are_ok('page', $page, $new_page, $cache);
    }
}

sub _test_category {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    for my $category_hash (values %{ $objs->{category} || {} }) {
        my $category     = $category_hash->{ $site->id } or next;
        my $label        = $category->label;
        my $new_category = MT->model('category')->load({ label => $label, blog_id => $new_site->id });
        ok($new_category, "new category ($label) exists") or next;
        _column_values_are_ok('category', $category, $new_category);
        _relations_are_ok('category', $category, $new_category, $cache);
    }
}

sub _test_folder {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    my $count = MT->model('folder')->count;
    if (!$count) {
        local $TODO = "Needs fixture";
        pass "No folders";
        return;
    }
    for my $folder_hash (values %{ $objs->{folder} || {} }) {
        my $folder     = $folder_hash->{ $site->id } or next;
        my $label      = $folder->label;
        my $new_folder = MT->model('folder')->load({ label => $label, blog_id => $new_site->id });
        ok($new_folder, "new folder ($label) exists") or next;
        _column_values_are_ok('folder', $folder, $new_folder);
        _relations_are_ok('folder', $folder, $new_folder, $cache);
    }
}

sub _test_category_set {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    for my $category_set_hash (values %{ $objs->{category_set} || {} }) {
        my $category_set = $category_set_hash->{category_set} or next;
        next if $category_set->blog_id != $site->id;
        my $name             = $category_set->name;
        my $new_category_set = MT->model('category_set')->load({ name => $name, blog_id => $new_site->id });
        ok($new_category_set, "new category_set ($name) exists") or next;
        _column_values_are_ok('category_set', $category_set, $new_category_set);
        _relations_are_ok('category_set', $category_set, $new_category_set, $cache);
    }
}

sub _test_placement {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    my @placements = MT->model('placement')->load({ blog_id => $new_site->id });
    ok @placements, "placements exist";
    for my $placement (@placements) {
        _relations_are_ok('placement', undef, $placement, $cache);
    }
}

sub _test_image {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    for my $image (values %{ $objs->{image} || {} }) {
        next if $image->blog_id != $site->id;
        my $label     = $image->label;
        my $new_image = MT->model('asset.image')->load({ label => $label, blog_id => $new_site->id });
        ok($new_image, "new image ($label) exists") or next;
        _column_values_are_ok('image', $image, $new_image);
        _relations_are_ok('image', $image, $new_image, $cache);
    }
}

sub _test_asset {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    my $count = MT->model('asset')->count({ class => 'file' });
    if (!$count) {
        local $TODO = "Needs fixture";
        pass "No assets";
        return;
    }
    for my $asset (values %{ $objs->{asset} || {} }) {
        next if $asset->blog_id != $site->id;
        my $label     = $asset->label;
        my $new_asset = MT->model('asset')->load({ label => $label, blog_id => $new_site->id });
        ok($new_asset, "new asset ($label) exists") or next;
        _column_values_are_ok('asset', $asset, $new_asset);
        _relations_are_ok('asset', $asset, $new_asset, $cache);
    }
}

sub _test_video {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    # TODO
}

sub _test_audio {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    # TODO
}

sub _test_objecttag {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    my @object_tags = MT->model('objecttag')->load({ blog_id => $new_site->id });
    ok @object_tags, "object tags exist";
    for my $object_tag (@object_tags) {
        _relations_are_ok('object_tag', undef, $object_tag, $cache);
    }
}

sub _test_objectasset {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    my @object_assets = MT->model('objectasset')->load({ blog_id => $new_site->id });
    ok @object_assets, "object assets exist";
    for my $object_asset (@object_assets) {
        _relations_are_ok('object_asset', undef, $object_asset, $cache);
    }
}

sub _test_objectcategory {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    my @object_categories = MT->model('objectcategory')->load({ blog_id => $new_site->id });
    ok @object_categories, "object categories exist";
    for my $object_category (@object_categories) {
        _relations_are_ok('object_category', undef, $object_category, $cache);
    }
}

sub _test_association {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    my @associations = MT->model('association')->load({ blog_id => $new_site->id });
    ok @associations, "associations exist";
    for my $association (@associations) {
        _relations_are_ok('association', undef, $association, $cache);
    }
}

sub _test_content_data {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    for my $cd (values %{ $objs->{content_data} || {} }) {
        next if $cd->blog_id != $site->id;
        my $label  = $cd->label;
        my $new_cd = MT->model('content_data')->load({ label => $label, blog_id => $new_site->id });
        ok($new_cd, "new content_data ($label) exists") or next;
        _column_values_are_ok('content_data', $cd, $new_cd);
        _relations_are_ok('content_data', $cd, $new_cd, $cache);
        my %old_data   = %{ $cd->data };
        my %new_data   = %{ $new_cd->data };
        my $old_ct     = MT->model('content_type')->load($cd->content_type_id);
        my $new_ct     = MT->model('content_type')->load($new_cd->content_type_id);
        my @old_fields = @{ $old_ct->fields };
        my @new_fields = @{ $new_ct->fields };

        for my $i (0 .. @old_fields - 1) {
            my $old_field  = $old_fields[$i];
            my $new_field  = $new_fields[$i];
            my $field_name = $old_field->{name};
            # TODO: other reference types
            if ($old_field->{type} =~ /^(?:categories)$/) {
                my @old_categories = @{ $old_data{ $old_field->{id} } || [] };
                my @new_categories = @{ $new_data{ $new_field->{id} } || [] };
                for my $c (0 .. @old_categories - 1) {
                    my $old_category = MT->model('category')->load({ id => $old_categories[$c], blog_id => $site->id });
                    my $new_category = MT->model('category')->load({ id => $new_categories[$c], blog_id => $new_site->id });
                    is $old_category->label // '' => $new_category->label // '', "$field_name [$c] for $label is identical";
                }
            } else {
                is $old_data{ $old_field->{id} } // '' => $new_data{ $new_field->{id} } // '', "$field_name for $label is identical";
            }
        }
    }
}

sub _test_content_field {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    for my $ct_name (keys %{ $objs->{content_type} || {} }) {
        my $ct = $objs->{content_type}{$ct_name}{content_type};
        next if $ct->blog_id != $site->id;
        my $new_ct = MT->model('content_type')->load({ name => $ct->name, blog_id => $new_site->id });
        for my $cf (values %{ $objs->{content_type}{$ct_name}{content_field} || {} }) {
            my $name   = $cf->name;
            my $new_cf = MT->model('content_field')->load({ name => $name, content_type_id => $new_ct->id, blog_id => $new_site->id });
            ok($new_cf, "new content_field ($name) exists") or next;
            _column_values_are_ok('content_field', $cf, $new_cf);
            _relations_are_ok('content_field', $cf, $new_cf, $cache);
        }
    }
}

sub _test_content_type {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    for my $ct_name (keys %{ $objs->{content_type} || {} }) {
        my $ct = $objs->{content_type}{$ct_name}{content_type};
        next if $ct->blog_id != $site->id;
        my $new_ct = MT->model('content_type')->load({ name => $ct->name, blog_id => $new_site->id });
        _column_values_are_ok('content_type', $ct, $new_ct);
        _relations_are_ok('content_type', $ct, $new_ct, $cache);
        my @old_fields = @{ $ct->fields };
        my @new_fields = @{ $new_ct->fields };
        for my $i (0 .. @old_fields - 1) {
            my $old_field  = $old_fields[$i];
            my $new_field  = $new_fields[$i];
            my $field_name = $old_field->{name};
            for my $k (sort keys %$old_field) {
                next if $k =~ /(?:unique_)?id$/;
                local $TODO = 'Fragile' if !$self->{backup_args}{format}; # FIXME
                if ($k eq 'options') {
                    # TODO: other reference types
                    for my $o (sort keys %{ $old_field->{$k} }) {
                        if ($o eq 'category_set') {
                            my $new_cs = MT->model('category_set')->load({ id => $new_field->{$k}{$o}, blog_id => $new_site->id });
                            ok $new_cs, "field $k $o of $field_name for $ct_name exists";
                        } else {
                            is $old_field->{$k}{$o} // '' => $new_field->{$k}{$o} // '', "field $k $o of $field_name for $ct_name is identical";
                        }
                    }
                } else {
                    is $old_field->{$k} // '' => $new_field->{$k} // '', "field $k of $field_name for $ct_name is identical";
                }
            }
        }
    }
}

sub _test_fileinfo {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    my @fileinfo = MT->model('fileinfo')->load({ blog_id => $new_site->id });
    ok @fileinfo, "fileinfo exist";
    for my $info (@fileinfo) {
        _relations_are_ok('fileinfo', undef, $info, $cache);
    }
}

sub _test_filter {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    # TODO
}

sub _test_formatted_text {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    # TODO
}

sub _test_notification {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    # TODO
}

sub _test_permission {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    my @permissions = MT->model('permission')->load({ blog_id => $new_site->id });
    ok @permissions, "permissions exist";
    for my $permission (@permissions) {
        _relations_are_ok('permission', undef, $permission, $cache);
    }
}

sub _test_rebuild_trigger {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    # TODO
}

sub _test_template {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    for my $template (values %{ $objs->{template}{ $site->id } || {} }) {
        my $name         = $template->name;
        my $new_template = MT->model('template')->load({ name => $name, blog_id => $new_site->id });
        ok($new_template, "new template ($name) exists") or next;
        _column_values_are_ok('template', $template, $new_template);
        _relations_are_ok('template', $template, $new_template, $cache);
    }
}

sub _test_templatemap {
    my ($class, $self, $objs, $site, $new_site, $cache) = @_;
    for my $template_name (keys %{ $objs->{templatemap}{ $site->id } || {} }) {
        my $new_template = MT->model('template')->load({ name => $template_name, blog_id => $new_site->id });
        ok($new_template, "new template ($template_name) exists") or next;
        my $templatemaps = $objs->{templatemap}{ $site->id }{$template_name};
        for my $templatemap (@$templatemaps) {
            my $file_template   = $templatemap->file_template;
            my $new_templatemap = MT->model('templatemap')->load({ blog_id => $new_site->id, template_id => $new_template->id, file_template => $file_template });
            ok($new_templatemap, "new templatemap ($file_template) exists") or next;
            _column_values_are_ok('templatemap', $templatemap, $new_templatemap);
            _relations_are_ok('templatemap', $templatemap, $new_templatemap, $cache);
        }
    }
}

sub _test_author {
    my ($class, $self, $objs, $cache) = @_;
    for my $author (values %{ $objs->{author} || {} }) {
        my $name       = $author->name;
        my $new_author = MT->model('author')->load({ name => $name }) or note explain [MT::Author->load];
        ok $new_author, "(new) author $name exists";
    }
}

sub _test_group {
    my ($class, $self, $objs, $cache) = @_;
    for my $group (values %{ $objs->{group} || {} }) {
        my $name      = $group->name;
        my $new_group = MT->model('group')->load({ name => $name });
        ok $new_group, "(new) group $name exists";
    }
}

sub _test_objectscore {
    my ($class, $self, $objs, $cache) = @_;
    # TODO
}

sub _test_plugindata {
    my ($class, $self, $objs, $cache) = @_;
    # TODO
}

sub _test_role {
    my ($class, $self, $objs, $cache) = @_;
    for my $role (values %{ $objs->{role} || {} }) {
        my $name     = $role->name;
        my $new_role = MT->model('role')->load({ name => $name });
        ok $new_role, "(new) role $name exists";
        # TODO: role with content_type/field permissions
    }
}

sub _test_tag {
    my ($class, $self, $objs, $cache) = @_;
    for my $tag (values %{ $objs->{tag} || {} }) {
        my $name    = $tag->name;
        my $new_tag = MT->model('tag')->load({ name => $name });
        ok $new_tag, "(new) tag $name exists";
    }
}

sub _column_values_are_ok {
    my ($type, $old, $new) = @_;
    my $defs = $new->column_defs;
    for my $column (keys %$defs) {
        next if $column =~ /(^id|_on|_by)$/;
        if ($column =~ /_id$/ && $column ne 'theme_id') {
            note "$type column $column is ignored";
            next;
        }
        next if $type =~ /^(?:website|blog)$/ && $column =~ /(^name|_path)$/;
        next if $type eq 'content_data'       && $column eq 'data';
        next if $type eq 'content_type'       && $column eq 'fields';
        my $new_value = $new->$column // '';
        is $new_value => $old->$column // '', "$type column $column is identical";
        
        fail "$type column $column has Perl's internal expression: " . $new_value if $new_value =~ /^(?:HASH|ARRAY|CODE|SCALAR|GLOB)\(/;
    }
}

sub _relations_are_ok {
    my ($type, $old, $new, $cache) = @_;
    my $defs = $new->column_defs;
    for my $column (keys %$defs) {
        next unless $column =~ /_id$/;
        next if $column eq 'blog_id';
        next if $column eq 'atom_id' && $type =~ /^(?:entry|page)$/;
        next if $column =~ /^(?:ct_)?unique_id$/ && $type =~ /^(?:content_data|content_field|content_type)$/;
        (my $name = $column) =~ s/_id$//;
        if ($name eq 'object') {
            if ($new->can('object_datasource')) {
                $name = $new->object_datasource;
            } elsif ($new->can('object_ds')) {
                $name = $new->object_ds;
            }
        }
        my $model = MT->model($name);
        if (!$model) {
            note "ignore $column for new $type!!!!!";
            next;
        }
        if ($old) {
            next unless $old->$column && $old->$column =~ /^[0-9]+$/;
        }
        next if !$old && !$new->$column;
        my $id   = $new->$column;
        my %args = (id => $id);
        if ($model->can('blog_id')) {
            $args{blog_id} = $new->blog_id;
        }
        my $cache_id = "$name:$id";
        my $new_obj  = $cache->{$cache_id} //= $model->load(\%args);
    SKIP: {
            local $TODO = "MTC-27497"                                                   if $name eq 'cf'       && $type =~ /^object_(?:asset|tag|category)$/;
            local $TODO = "Only fails when the database is not reset, and at random???" if $name eq 'category' && $type eq 'object_category';
            ok $new_obj, "new $name for new $type exists";
        }
    }
}

sub _merge {
    my $left = shift;
    return $left unless @_;
    return _merge($left, merge(@_)) if @_ > 1;
    my $right = shift;
    return unless defined $right;
    my %merge;
    for my $key (keys %$right) {
        my ($hr, $hl) = map { ref $_->{$key} eq 'HASH' } $right, $left;

        if ($hr and $hl) {
            $merge{$key} = merge($left->{$key}, $right->{$key});
        } else {
            $merge{$key} = $right->{$key};
        }
    }
    \%merge;
}

sub _default_fixture_spec {
    my $self = shift;
    return +{
        author => [{
                name         => 'author1',
                is_superuser => 1,
            }, {
                name  => 'author2',
                roles => [{
                        role    => 'editor',
                        website => 'My Test Site',
                    }, {
                        role => 'editor',
                        blog => 'My Test Child Site',
                    }
                ],
            }
        ],
        group => [qw(group1 group2)],
        role  => {
            editor => ['comment', 'create_post', 'publish_post', 'edit_all_posts', 'edit_categories', 'edit_tags', 'manage_pages', 'rebuild', 'upload', 'send_notifications', 'manage_feedback', 'edit_assets', 'manage_content_data', 'manage_category_set'],
        },
        website => [{
            name         => 'My Test Site',
            theme_id     => 'mont-blanc',
            site_path    => 'TEST_ROOT/site',
            archive_path => 'TEST_ROOT/site/archive',
        }],
        blog => [{
            name         => 'My Test Child Site',
            parent       => 'My Test Site',
            theme_id     => 'mont-blanc',
            site_path    => 'TEST_ROOT/site/blog',
            archive_path => 'TEST_ROOT/site/blog/archive',
        }],
        image => {
            'image1.jpg' => {
                website => 'My Test Site',
            },
            'image2.jpg' => {
                website => 'My Test Site',
            },
            'image3.jpg' => {
                blog => 'My Test Child Site',
            },
        },
        category => [{
                label   => 'cat',
                website => 'My Test Site',
            }, {
                label => 'kitty',
                blog  => 'My Test Child Site',
            }
        ],
        tag   => [qw(tag1 tag2 child_tag1 child_tag2)],
        entry => [{
                website     => 'My Test Site',
                basename    => 'entry1_by_author1',
                title       => 'entry1_by_author1',
                author      => 'author1',
                status      => 'publish',
                authored_on => '20181203121110',
                categories  => [qw(cat)],
                tags        => [qw(tag1 tag2)],
            },
            {
                website     => 'My Test Site',
                basename    => 'entry2_by_author1',
                title       => 'entry2_by_author1',
                author      => 'author1',
                status      => 'publish',
                authored_on => '20171203121110',
                images      => [qw(image1.jpg)],
            },
            {
                blog        => 'My Test Child Site',
                basename    => 'entry1_by_author2',
                title       => 'entry1_by_author2',
                author      => 'author2',
                status      => 'publish',
                authored_on => '20151203121110',
                images      => [qw(image3.jpg)],
                categories  => [qw(kitty)],
            },
            {
                blog        => 'My Test Child Site',
                basename    => 'entry2_by_author1_draft',
                title       => 'entry2_by_author1_draft',
                author      => 'author1',
                status      => 'draft',
                authored_on => '20141203121110',
                tags        => [qw(child_tag1 child_tag2)],
            },
        ],
        category_set => {
            catset_fruit => {
                website    => 'My Test Site',
                categories => [
                    'cat_apple', 'cat_strawberry',
                    { label => 'cat_orange', parent => 'cat_strawberry' },
                    'cat_peach',
                ],
            },
            catset_animal => {
                blog       => 'My Test Child Site',
                categories => [
                    'cat_giraffe',
                    { label => 'cat_dog', parent => 'cat_giraffe' },
                    { label => 'cat_cat', parent => 'cat_dog' },
                    'cat_monkey',
                    'cat_rabbit',
                ],
            },
        },
        content_type => {
            ct_website => {
                website => 'My Test Site',
                fields  => [
                    cf_same_date         => 'date_only',
                    cf_same_datetime     => 'date_and_time',
                    cf_same_catset_fruit => {
                        type         => 'categories',
                        category_set => 'catset_fruit',
                        options      => { multiple => 1 },
                    },
                    cf_same_catset_other_fruit => {
                        type         => 'categories',
                        category_set => 'catset_fruit',
                        options      => { multiple => 1 },
                    },
                ],
            },
            ct_blog => {
                blog   => 'My Test Child Site',
                fields => [
                    cf_other_date          => 'date_only',
                    cf_other_datetime      => 'date_and_time',
                    cf_other_catset_animal => {
                        type         => 'categories',
                        category_set => 'catset_animal',
                        options      => { multiple => 1 },
                    },
                ],
            }
        },
        content_data => {
            cd_same_apple_orange => {
                website      => 'My Test Site',
                content_type => 'ct_website',
                author       => 'author1',
                status       => 'publish',
                authored_on  => '20181031000000',
                data         => {
                    cf_same_date               => '20190926000000',
                    cf_same_datetime           => '20081101121212',
                    cf_same_catset_fruit       => [qw/cat_apple/],
                    cf_same_catset_other_fruit => [qw/cat_orange/],
                },
            },
            cd_same_apple_orange_peach => {
                website      => 'My Test Site',
                content_type => 'ct_website',
                author       => 'author1',
                authored_on  => '20171031000000',
                status       => 'publish',
                data         => {
                    cf_same_date               => '20200926000000',
                    cf_same_datetime           => '20061101121212',
                    cf_same_catset_fruit       => [qw/cat_apple cat_orange/],
                    cf_same_catset_other_fruit => [qw/cat_peach/],
                },
            },
            cd_same_peach => {
                website      => 'My Test Site',
                content_type => 'ct_website',
                author       => 'author2',
                status       => 'publish',
                authored_on  => '20161031000000',
                data         => {
                    cf_same_date               => '20210926000000',
                    cf_same_datetime           => '20041101121212',
                    cf_same_catset_fruit       => [qw/cat_peach/],
                    cf_same_catset_other_fruit => [qw//],
                },
            },
            cd_same_same_date => {
                website      => 'My Test Site',
                content_type => 'ct_website',
                author       => 'author1',
                status       => 'publish',
                authored_on  => '20181031000000',
                data         => {
                    cf_same_date               => '20200926000000',
                    cf_same_datetime           => '20041101121212',
                    cf_same_catset_fruit       => [qw//],
                    cf_same_catset_other_fruit => [qw/cat_peach/],
                },
            },
            cd_same_draft => {
                website      => 'My Test Site',
                content_type => 'ct_website',
                author       => 'author2',
                status       => 'draft',
                authored_on  => '20181031000000',
                data         => {
                    cf_same_date               => '20200926000000',
                    cf_same_datetime           => '20041101121212',
                    cf_same_catset_fruit       => [qw//],
                    cf_same_catset_other_fruit => [qw/cat_peach/],
                },
            },
            cd_other_apple => {
                blog         => 'My Test Child Site',
                content_type => 'ct_blog',
                author       => 'author2',
                authored_on  => '20081101121212',
                status       => 'publish',
                data         => {
                    cf_other_date          => '19990831000000',
                    cf_other_datetime      => '20181031000000',
                    cf_other_catset_animal => [qw//],
                },
            },
            cd_other_apple_orange_dog_cat => {
                blog         => 'My Test Child Site',
                content_type => 'ct_blog',
                author       => 'author2',
                authored_on  => '20061101121212',
                status       => 'publish',
                data         => {
                    cf_other_date          => '19980831000000',
                    cf_other_datetime      => '20161031000000',
                    cf_other_catset_animal => [qw/cat_dog cat_cat/],
                },
            },
            cd_other_all_fruit_rabbit => {
                blog         => 'My Test Child Site',
                content_type => 'ct_blog',
                author       => 'author1',
                authored_on  => '20041101121212',
                status       => 'publish',
                data         => {
                    cf_other_date          => '19970831000000',
                    cf_other_datetime      => '20181031000000',
                    cf_other_catset_animal => [qw/cat_rabbit/],
                },
            },
            cd_other_same_date => {
                blog         => 'My Test Child Site',
                content_type => 'ct_blog',
                author       => 'author1',
                authored_on  => '20041101121212',
                status       => 'publish',
                data         => {
                    cf_other_date          => '19980831000000',
                    cf_other_datetime      => '20181031000000',
                    cf_other_catset_animal => [qw/cat_dog cat_rabbit/],
                },
            },
            cd_other_draft => {
                blog         => 'My Test Child Site',
                content_type => 'ct_blog',
                author       => 'author1',
                authored_on  => '20041101121212',
                status       => 'draft',
                data         => {
                    cf_other_date          => '19980831000000',
                    cf_other_datetime      => '20181031000000',
                    cf_other_catset_animal => [qw/cat_dog cat_rabbit/],
                },
            },
        },
        template => [
            map {
                my $archive_type = $_;
                my @tmpls;
                for my $site ([website => 'My Test Site'], [blog => 'My Test Child Site']) {
                    if ($archive_type =~ /^ContentType/) {
                        push @tmpls, +{
                            archive_type => $archive_type,
                            @$site,
                            content_type => 'ct_' . $site->[0],
                            mapping      => [{
                                build_type => 1,
                            }],
                            text => <<'TMPL',
<MTArchiveType>
TMPL
                        };
                    } else {
                        push @tmpls, +{
                            archive_type => $archive_type,
                            @$site,
                            mapping => [{
                                build_type => 1,
                            }],
                            text => <<'TMPL',
<MTArchiveType>
TMPL
                        };
                    }
                }
                @tmpls;
            } MT->publisher->archive_types
        ],
    };
}

1;
