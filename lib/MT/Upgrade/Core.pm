# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Upgrade::Core;

use strict;

MT->add_callback('MT::Upgrade::seed_database', 5, undef, \&seed_database);
MT->add_callback('MT::Upgrade::upgrade_end', 5, undef,
    sub { $_[1]->add_step('core_upgrade_templates') } );

sub upgrade_functions {
    my $self = shift;
    my (%param) = @_;
    return {
        'core_upgrade_templates' => {
            code => \&upgrade_templates,
            priority => 5,
        },
        'core_init_blog_custom_dynamic_templates' => {
            on_field => 'MT::Blog->custom_dynamic_templates',
            priority => 3.1,
            updater => {
                type => 'blog',
                condition => sub { !defined $_[0]->custom_dynamic_templates },
                code => sub { $_[0]->custom_dynamic_templates('none') },
                label => 'Assigning custom dynamic template settings...',
                sql => q{update mt_blog
                            set blog_custom_dynamic_templates = 'none'
                          where blog_custom_dynamic_templates is null},
            }
        },
        'core_init_author_type' => {
            on_field => 'MT::Author->type',
            priority => 3.1,
            updater => {
                type => 'author',
                condition => sub { !$_[0]->type },
                code => sub { $_[0]->type(1) },
                label => 'Assigning user types...',
                sql => 'update mt_author set author_type = 1
                        where author_type is null or author_type = 0',
            }
        },
        'core_init_category_parent' => {
            on_field => 'MT::Category->parent',
            priority => 3.1,
            updater => {
                type => 'category',
                condition => sub { !defined $_[0]->parent },
                code => sub { $_[0]->parent(0) },
                label => 'Assigning category parent fields...',
                sql => 'update mt_category set category_parent = 0
                        where category_parent is null',
            }
        },
        'core_init_template_build_dynamic' => {
            on_field => 'MT::Template->build_dynamic',
            priority => 3.1,
            updater => {
                type => 'template',
                condition => sub { !defined $_[0]->build_dynamic },
                code => sub { $_[0]->build_dynamic(0) },
                label => 'Assigning template build dynamic settings...',
                sql => 'update mt_template set template_build_dynamic = 0
                        where template_build_dynamic is null',
            }
        },
        'core_init_comment_visible' => {
            on_field => 'MT::Comment->visible',
            priority => 3.1,
            updater => {
                type => 'comment',
                condition => sub { !defined $_[0]->visible },
                code => sub { $_[0]->visible(1) },
                label => 'Assigning visible status for comments...',
                sql => 'update mt_comment set comment_visible = 1
                        where comment_visible is null',
            }
        },
        'core_init_tbping_visible' => {
            on_field => 'MT::TBPing->visible',
            priority => 3.1,
            updater => {
                type => 'tbping',
                condition => sub { !defined $_[0]->visible },
                code => sub { $_[0]->visible(1) },
                label => 'Assigning visible status for TrackBacks...',
                sql => 'update mt_tbping set tbping_visible = 1
                        where tbping_visible is null',
            }
        },
        'core_install_default_roles' => {
            code => sub { require MT::Role; return MT::Role->create_default_roles },
            on_class => 'MT::Role',
            priority => 3.1,
        },
    };
}

### Subroutines

sub seed_database {
    my $cb = shift;
    my $self = shift;
    my (%param) = @_;

    require MT::Author;
    return undef if MT::Author->exist;

    $self->progress($self->translate_escape("Creating initial blog and user records..."));

    local $MT::CallbacksEnabled = 1;

    require MT::L10N;
    my $lang = exists $param{user_lang} ? $param{user_lang} : MT->config->DefaultLanguage;
    my $LH = MT::L10N->get_handle($lang);

    # TBD: parameter for username/password provided by user from $app
    use URI::Escape;
    my $author = MT::Author->new;
    $author->name(exists $param{user_name} ? uri_unescape($param{user_name}) : 'Melody');
    $author->type(MT::Author::AUTHOR());
    $author->set_password(exists $param{user_password} ? uri_unescape($param{user_password}) : 'Nelson');
    $author->email(exists $param{user_email} ? uri_unescape($param{user_email}) : '');
    $author->hint(exists $param{user_hint} ? uri_unescape($param{user_hint}) : '');
    $author->nickname(exists $param{user_nickname} ? uri_unescape($param{user_nickname}) : '');
    $author->is_superuser(1);
    $author->can_create_blog(1);
    $author->can_view_log(1);
    $author->can_manage_plugins(1);
    $author->preferred_language($lang);
    $author->external_id(MT::Author->pack_external_id($param{user_external_id})) if exists $param{user_external_id};
    $author->auth_type(MT->config->AuthenticationModule);
    $author->save or return $self->error($self->translate_escape("Error saving record: [_1].", $author->errstr));

    my $App = $MT::Upgrade::App;
    $App->{author} = $author if ref $App;

    require MT::Role;
    MT::Role->create_default_roles(%param)
        or return $self->error($self->translate_escape("Error creating role record: [_1].", MT::Role->errstr));

    require MT::Blog;
    my $blog = MT::Blog->create_default_blog(
        exists $param{blog_name}
          ? uri_unescape($param{blog_name})
          : MT->translate('First Blog'),
        $param{blog_template_set})
            or return $self->error($self->translate_escape("Error saving record: [_1].", MT::Blog->errstr));
    $blog->site_path(exists $param{blog_path} ? uri_unescape($param{blog_path}) : '');
    $blog->site_url(exists $param{blog_url} ? uri_unescape($param{blog_url}) : '');
    $blog->server_offset(exists $param{blog_timezone} ? ($param{blog_timezone} || 0) : 0);
    $blog->template_set($param{blog_template_set});
    $blog->save;
    MT->run_callbacks( 'blog_template_set_change', { blog => $blog } );

    # Create an initial entry and comment for this blog
    require MT::Entry;
    my $entry = MT::Entry->new;
    $entry->blog_id($blog->id);
    $entry->title(MT->translate("I just finished installing Movable Type [_1]!", int(MT->product_version)));
    $entry->text(MT->translate("Welcome to my new blog powered by Movable Type. This is the first post on my blog and was created for me automatically when I finished the installation process. But that is ok, because I will soon be creating posts of my own!"));
    $entry->author_id($author->id);
    $entry->status(MT::Entry::RELEASE());
    $entry->save
        or return $self->error($self->translate_escape("Error saving record: [_1].", MT::Entry->errstr));

    require MT::Comment;
    my $comment = MT::Comment->new;
    $comment->entry_id($entry->id);
    $comment->blog_id($blog->id);
    $comment->text(MT->translate("Movable Type also created a comment for me as well so that I could see what a comment will look like on my blog once people start submitting comments on all the posts I will write."));
    $comment->visible(1);
    $comment->junk_status(1);
    $comment->author(exists $param{user_nickname} ? uri_unescape($param{user_nickname}) : undef);
    $comment->save
        or return $self->error($self->translate_escape("Error saving record: [_1].", MT::Comment->errstr));

    require MT::Association;
    require MT::Role;
    my ($blog_admin_role) = MT::Role->load_by_permission("administer_blog");
    MT::Association->link( $blog => $blog_admin_role => $author );

    1;
}

sub upgrade_templates {
    my $self = shift;
    my (%opt) = @_;

    my $install = $opt{Install} || 0;

    my $updated = 0;

    my $tmpl_list;
    require MT::DefaultTemplates;
    $tmpl_list = MT::DefaultTemplates->templates || [];

    my $mt = MT->instance;
    my @arch_tmpl;

    require MT::Template;
    require MT::Blog;

    my $installer = sub {
        my ($val, $blog_id) = @_;

        my $terms = {};
        $terms->{type} = $val->{type};
        $terms->{name} = $val->{name}
            if $val->{set} ne 'system';
        $terms->{blog_id} = $blog_id;

        return 1 if MT::Template->exist( $terms );

        $self->progress($self->translate_escape("Creating new template: '[_1]'.", $val->{name}));

        my $obj = MT::Template->new;
        $obj->build_dynamic(0);
        if ( ( 'widgetset' eq $val->{type} )
          && ( exists $val->{widgets} ) ) {
            my $modulesets = delete $val->{widgets};
            $obj->modulesets( MT::Template->widgets_to_modulesets($modulesets, $blog_id) );
        }
        foreach my $v (keys %$val) {
            $obj->column($v, $val->{$v}) if $obj->has_column($v);
        }
        $obj->blog_id($blog_id);
        $obj->save or return $self->error($self->translate_escape("Error saving record: [_1].", $obj->errstr));
        $updated = 1;
        if ($val->{mappings}) {
            push @arch_tmpl, {
                template => $obj,
                mappings => $val->{mappings},
            };
        }
        return 1;
    };

    my $Installing = $MT::Upgrade::Installing;

    for my $val (@$tmpl_list) {
        if (!$Installing) {
            next if $val->{type} eq 'search_results';
        }
        if (!$install) {
            if (!$val->{global}) {
                next if $val->{set} ne 'system';
            }
        }

        my $p = $val->{plugin} || $mt;
        $val->{name} = $p->translate($val->{name});
        $val->{text} = $p->translate_templatized($val->{text});

        if ($val->{global}) {
            $installer->($val, 0) or return;
        }
        else {
            my $iter = MT::Blog->load_iter();
            while (my $blog = $iter->()) {
                $installer->($val, $blog->id);
            }
        }
    }

    if (@arch_tmpl) {
        $self->progress($self->translate_escape("Mapping templates to blog archive types..."));
        require MT::TemplateMap;

        for my $map_set (@arch_tmpl) {
            my $tmpl = $map_set->{template};
            my $mappings = $map_set->{mappings};
            foreach my $map_key (keys %$mappings) {
                my $m = $mappings->{$map_key};
                my $at = $m->{archive_type};
                # my $preferred = $mappings->{$map_key}{preferred};
                my $map = MT::TemplateMap->new;
                $map->archive_type($at);
                $map->is_preferred(1);
                $map->template_id($tmpl->id);
                $map->file_template($m->{file_template}) if $m->{file_template};
                $map->blog_id($tmpl->blog_id);
                $map->save;
            }
        }
    }

    $updated;
}

1;
