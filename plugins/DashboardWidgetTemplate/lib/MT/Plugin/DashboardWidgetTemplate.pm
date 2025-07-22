package MT::Plugin::DashboardWidgetTemplate;

use strict;
use warnings;
use utf8;

use MT::Util qw( encode_html );

sub component {
    __PACKAGE__ =~ m/::([^:]+)\z/;
}

sub plugin {
    MT->component(component());
}

sub insert_before {
    my ($tmpl, $name, $tokens) = @_;

    my $before = $name ? $tmpl->getElementsByName($name)->[0] : undef;

    if (!ref $tokens) {
        $tokens = plugin()->load_tmpl($tokens)->tokens;
    }

    foreach my $t (@$tokens) {
        $tmpl->insertBefore($t, $before);
    }
}

sub template_param_list_template {
    my ($cb, $app, $param, $tmpl) = @_;

    insert_before(
        $tmpl, undef,
        'dashboard_widget_template_list_template.tmpl'
    );

    return 1 if ($app->param('filter_key') || '') eq 'backup_templates';

    # from MT::CMS::Template
    my $hasher = sub {
        my ($obj, $row) = @_;
        my $template_type;
        my $type = $row->{type} || '';
        my $tblog;
        $tblog = MT::Blog->load($obj->blog_id) if $obj->blog_id;
        if ($type =~ m/^(individual|page|category|archive)$/) {
            $template_type = 'archive';

            # populate context with templatemap loop
            if ($tblog) {
                $row->{archive_types} = _populate_archive_loop($app, $tblog, $obj);
            }
        } elsif ($type eq 'widget') {
            $template_type = 'widget';
        } elsif ($type eq 'index') {
            $template_type = 'index';
        } elsif ($type eq 'custom') {
            $template_type = 'module';
        } elsif ($type eq 'email') {
            $template_type = 'email';
        } elsif ($type eq 'backup') {
            $template_type = 'backup';
        } elsif ($type eq 'ct' || $type eq 'ct_archive') {
            $template_type = 'ct';

            # populate context with templatemap loop
            if ($tblog) {
                $row->{archive_types} = _populate_archive_loop($app, $tblog, $obj);
            }
        } else {
            $template_type = 'system';
        }
        $row->{use_cache} =
            ($tblog && $tblog->include_cache && ($obj->cache_expire_type || 0) != 0) ? 1 : 0;
        $row->{use_ssi} =
            ($tblog && $tblog->include_system && $obj->include_with_ssi)
            ? 1
            : 0;
        $row->{template_type} = $template_type;
        $row->{type}          = 'entry' if $type eq 'individual';
        my $published_url = $obj->published_url;
        $row->{published_url} = $published_url if $published_url;
        $row->{name}          = ''             if !defined $row->{name};
        $row->{name} =~ s/^\s+|\s+$//g;
        $row->{name} = "(" . $app->translate("No Name") . ")"
            if $row->{name} eq '';
    };

    my $tmpl_param = $app->listing({
        type  => 'template',
        terms => {
            blog_id => $app->param('blog_id') || 0,
            type    => 'dashboard_widget',
        },
        args     => { sort => 'name' },
        no_limit => 1,
        no_html  => 1,
        code     => $hasher,
    });
    $tmpl_param->{template_type} = 'dashboard_widget';
    $tmpl_param->{template_type_label} =
        plugin()->translate('Dashboard Widget');

    push @{ $param->{template_type_loop} }, $tmpl_param;
}

sub template_param_edit_template {
    my ($cb, $app, $param, $tmpl) = @_;
    if (my $id = $app->param('id')) {
        my $tmpl = MT->model('template')->load($id);
        return unless $tmpl->type eq 'dashboard_widget';

        $param->{dashboard_widget_pinned} = $tmpl->meta('dashboard_widget_pinned');
    } else {
        return unless $app->param('type') eq 'dashboard_widget';

        $param->{dashboard_widget_pinned} = 1;
    }
    insert_before(
        $tmpl, 'has_outfile',
        'dashboard_widget_template_edit_template_options.tmpl'
    );
    insert_before(
        $tmpl, undef,
        'dashboard_widget_template_edit_template.tmpl'
    );
}

sub template_param_dashboard {
    my ($cb, $app, $param, $tmpl) = @_;
    return 1 if $param->{js_include};    # skip include for layout/dashboard
    insert_before($tmpl, undef, 'dashboard_widget_template_dashboard.tmpl');
}

sub template_param_theme_element_detail {
    my ($cb, $app, $param, $tmpl) = @_;
    my $tmpl_groups = $param->{tmpl_groups}
        or return 1;
    for (my $i = 0; $i < @$tmpl_groups; $i++) {
        my $tmpl_group = $tmpl_groups->[$i];
        next unless $tmpl_group->{template_type} eq 'system';

        my @dashboard_widget_templates;
        for (my $j = @{ $tmpl_group->{templates} } - 1; $j >= 0; $j--) {
            my $tmpl_hash = $tmpl_group->{templates}->[$j];
            my $tmpl      = MT->model('template')->load($tmpl_hash->{tmpl_id});
            next unless $tmpl->type eq 'dashboard_widget';
            unshift @dashboard_widget_templates, $tmpl_hash;
            splice @{ $tmpl_group->{templates} }, $j, 1;
        }

        if (@dashboard_widget_templates) {
            splice @$tmpl_groups, $i + 1, 0,
                {
                order               => $tmpl_group->{order} + 1,
                template_type       => 'dashboard_widget',
                template_type_label => plugin()->translate('Dashboard Widget'),
                object_loop         => [],
                templates           => \@dashboard_widget_templates,
                };
        }

        last;
    }
}

sub pre_save_template {
    my ($cb, $app, $obj) = @_;
    if ($obj->type eq 'dashboard_widget') {
        $obj->meta('dashboard_widget_pinned', $app->param('dashboard_widget_pinned') ? 1 : 0);
    }
    1;
}

sub template_post_save {
    my ($cb, $obj) = @_;
    MT->instance->reboot if $obj->type eq 'dashboard_widget';
}

sub pre_apply_theme {
    my ($cb, $theme, $blog) = @_;
    if (my ($element) = grep { $_->{id} eq 'template_set' } $theme->elements) {
        if (my $dashboard_widget_templates = $element->{data}{templates}{dashboard_widget}) {
            for my $id (keys %$dashboard_widget_templates) {
                if ($dashboard_widget_templates->{$id}{pinned}) {
                    $dashboard_widget_templates->{$id}{dashboard_widget_pinned} = 1;
                }
            }
        }
    }
}
sub init_app {
    require MT::DefaultTemplates;
    require MT::Theme::TemplateSet;
    require Class::Method::Modifiers;
    Class::Method::Modifiers::install_modifier(
        'MT::DefaultTemplates', 'around', 'templates',
        sub {
            my $app = MT->instance;
            if (   ($app->mode eq 'view')
                && (($app->param('_type') || '') eq 'template')
                && (($app->param('type')  || '') eq 'dashboard_widget'))
            {
                return [];
            }
            my $orig = shift;
            return $orig->(@_);
        });
    Class::Method::Modifiers::install_modifier(
        'MT::Theme::TemplateSet', 'around', '_type',
        sub {
            my $orig = shift;
            my ($tmpl) = @_;
            return 'dashboard_widget' if $tmpl->type eq 'dashboard_widget';
            return $orig->(@_);
        });
    Class::Method::Modifiers::install_modifier(
        'MT::Theme::TemplateSet', 'around', 'export',
        sub {
            my $orig   = shift;
            my $result = $orig->(@_);
            if (my $templates = $result->{templates}) {
                for my $obj (@{ $result->{objs} }) {
                    next unless $obj->type eq 'dashboard_widget' && $obj->meta('dashboard_widget_pinned');
                    my $id = $obj->identifier || 'template_' . $obj->id;
                    $templates->{dashboard_widget}{$id}{pinned} = 1;
                }
            }
            return $result;
        });
}

sub cms_widgets {
    my $widgets = {};

    my $iter = MT->model('template')->load_iter({
            type => 'dashboard_widget',
        },
        {
            sort => 'name',
        });
    my $order = 1;
    while (my $tmpl = $iter->()) {
        my $tmpl_id      = $tmpl->id;
        my $tmpl_blog_id = $tmpl->blog_id;
        my $tmpl_name    = $tmpl->name;
        my $pinned       = $tmpl->meta('dashboard_widget_pinned');
        my $id           = 'dashboard_widget_template_' . $tmpl->id . ($pinned ? '_pinned' : '');
        $widgets->{$id} = {
            label => sub {
                (!$tmpl_blog_id || MT->instance->blog)
                    ? $tmpl_name
                    : ($tmpl_name . ' - ' . MT->model('blog')->load($tmpl_blog_id)->name);
            },
            plugin   => plugin(),
            template => 'dashboard_widget_template.tmpl',
            handler  => sub {
                my ($app, $t) = @_;

                my $local_tmpl = MT->model('template')->load($tmpl_id);
                my $ctx        = $local_tmpl->context;
                if (my $blog = $app->blog) {
                    $ctx->stash('blog_id', $blog->id);
                    $ctx->stash('blog',    $blog);
                    $t->param('label', encode_html($local_tmpl->name));
                } elsif (!$tmpl_blog_id) {
                    $t->param('label', encode_html($local_tmpl->name));
                } else {
                    my $tmpl_blog = MT->model('blog')->load($tmpl_blog_id);
                    $t->param(
                        'label',
                        encode_html($local_tmpl->name) . ' - <a href="' . $app->mt_uri(
                            args => {
                                blog_id => $tmpl_blog_id,
                            },
                            )
                            . '">'
                            . encode_html($tmpl_blog->name) . '</a>'
                    );
                }
                $t->param('can_close', $pinned ? 0 : 1);
                require MT::Sanitize;
                $t->param(
                    'content',
                    MT::Sanitize->sanitize(
                        $local_tmpl->output,
                        MT::Sanitize->parse_spec('* class style aria-label aria-labelledby aria-describedby aria-hidden,a href target,br/,img/ src alt,form,input/ type name value,select/ name,option value,button/ type,b,label,legend,strong,em,i,ul,li,ol,p,div,h1,h2,h3,h4,h5,h6,div,span')));
            },
            singular => 1,
            set      => 'main',
            view     => $tmpl_blog_id
            ? $pinned
                    ? ['website', 'blog']
                    : ['user',    'website', 'blog']
            : 'user',
            order     => sprintf("30.%03d", $order++),
            pinned    => $pinned,
            condition => sub {
                my $app     = MT->instance;
                my $blog_id = $app->param('blog_id') || 0;

                return
                      $blog_id      ? $tmpl_blog_id == $blog_id
                    : $tmpl_blog_id ? $app->user->has_perm($tmpl_blog_id)
                    :                 1;
            },
        };
    }
    return $widgets;
}

1;
