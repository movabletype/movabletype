# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::CMS::Template;

use strict;
use MT::Util qw( format_ts );

sub edit {
    my $cb = shift;
    my ( $app, $id, $obj, $param ) = @_;

    my $q       = $app->param;
    my $blog_id = $q->param('blog_id');

    # FIXME: enumeration of types
    unless ($blog_id) {
        my $type = $q->param('type') || ( $obj ? $obj->type : '' );
        return $app->return_to_dashboard( redirect => 1 )
            if $type eq 'archive'
                || $type eq 'individual'
                || $type eq 'category'
                || $type eq 'page'
                || $type eq 'index';
    }

    my $blog = $app->blog;
    if ( defined $blog && !$blog->is_blog ) {
        my $type = $q->param('type') || ( $obj ? $obj->type : '' );
        return $app->return_to_dashboard( redirect => 1 )
            if $type eq 'archive'
                || $type eq 'individual';
    }

    # to trigger autosave logic in main edit routine
    $param->{autosave_support} = 1;

    my $type  = $q->param('_type');
    my $cfg   = $app->config;
    my $perms = $app->blog ? $app->permissions : $app->user->permissions;
    my $can_preview = 0;

    if ( $q->param('reedit') ) {
        $param->{'revision-note'} = $q->param('revision-note');
        if ( $q->param('save_revision') ) {
            $param->{'save_revision'} = 1;
        }
        else {
            $param->{'save_revision'} = 0;
        }
    }
    if ($blog) {

        # include_system/include_cache are only applicable
        # to blog-level templates
        $param->{include_system} = $blog->include_system;
        $param->{include_cache}  = $blog->include_cache;
    }

    if ( $obj && ( $obj->type eq 'widgetset' ) ) {
        return $app->redirect(
            $app->uri(
                'mode' => 'edit_widget',
                args   => { blog_id => $obj->blog_id, id => $obj->id }
            )
        );
    }

    if ($id) {
        if ( $blog && $blog->use_revision ) {
            my $rn = $q->param('r') || 0;
            if ( $obj->current_revision > 0 || $rn != $obj->current_revision )
            {
                my $rev = $obj->load_revision( { rev_number => $rn } );
                if ( $rev && @$rev ) {
                    $obj = $rev->[0];
                    my $values = $obj->get_values;
                    $param->{$_} = $values->{$_} foreach keys %$values;
                    $param->{loaded_revision} = 1;
                }
                $param->{rev_number} = $rn;
                $param->{rev_date}   = format_ts( "%Y-%m-%d %H:%M:%S",
                    $obj->modified_on, $blog,
                    $app->user ? $app->user->preferred_language : undef );
                $param->{no_snapshot} = 1 if $q->param('no_snapshot');
            }
        }
        $param->{nav_templates} = 1;
        my $tab;

        # FIXME: Template types should not be enumerated here
        if ( $obj->type eq 'index' ) {
            $tab = 'index';
            $param->{template_group_trans} = $app->translate('index');
        }
        elsif ($obj->type eq 'archive'
            || $obj->type eq 'individual'
            || $obj->type eq 'category'
            || $obj->type eq 'page' )
        {

            # FIXME: enumeration of types
            $tab = 'archive';
            $param->{template_group_trans} = $app->translate('archive');
        }
        elsif ( $obj->type eq 'custom' ) {
            $tab = 'module';
            $param->{template_group_trans} = $app->translate('module');
        }
        elsif ( $obj->type eq 'widget' ) {
            $tab = 'widget';
            $param->{template_group_trans} = $app->translate('widget');
        }
        elsif ( $obj->type eq 'email' ) {
            $tab = 'email';
            $param->{template_group_trans} = $app->translate('email');
        }
        elsif ( $obj->type eq 'backup' ) {
            $tab = 'backup';
            $param->{template_group_trans} = $app->translate('backup');
        }
        else {
            $tab = 'system';
            $param->{template_group_trans} = $app->translate('system');
        }
        $param->{template_group} = $tab;
        $blog_id = $obj->blog_id;

        # FIXME: enumeration of types
        $param->{has_name} 
            = $obj->type  eq 'index'
            || $obj->type eq 'custom'
            || $obj->type eq 'widget'
            || $obj->type eq 'archive'
            || $obj->type eq 'category'
            || $obj->type eq 'page'
            || $obj->type eq 'individual';
        if ( !$param->{has_name} ) {
            $param->{ 'type_' . $obj->type } = 1;
            $param->{name} = $obj->name;
        }
        $app->add_breadcrumb( $param->{name} );
        $param->{has_outfile} = $obj->type eq 'index';
        $param->{has_rebuild} = ( ( $obj->type eq 'index' )
                && ( ( $blog->custom_dynamic_templates || "" ) ne 'all' ) );

        # FIXME: enumeration of types
        $param->{is_special} 
            = $param->{type}  ne 'index'
            && $param->{type} ne 'archive'
            && $param->{type} ne 'category'
            && $param->{type} ne 'page'
            && $param->{type} ne 'individual';
        $param->{has_build_options} 
            = $param->{has_build_options}
            && $param->{type} ne 'custom'
            && $param->{type} ne 'widget'
            && !$param->{is_special};
        $param->{search_label} = $app->translate('Templates');
        $param->{object_type}  = 'template';
        my $published_url = $obj->published_url;
        $param->{published_url} = $published_url if $published_url;
        $param->{saved_rebuild} = 1 if $q->param('saved_rebuild');
        require MT::PublishOption;
        $param->{static_maps}
            = (    $obj->build_type != MT::PublishOption::DYNAMIC()
                && $obj->build_type != MT::PublishOption::DISABLED() );

        my $filter = $app->param('filter_key');
        if ( $param->{template_group} eq 'email' ) {
            $app->param( 'filter_key', 'email_templates' );
        }
        elsif ( $param->{template_group} eq 'system' ) {
            $app->param( 'filter_key', 'system_templates' );
        }
        elsif ( $obj->type eq 'backup' ) {
            $app->param( 'filter_key', 'backup_templates' );
        }
        $app->load_list_actions( 'template', $param );
        $app->param( 'filter_key', $filter );

        $obj->compile;
        if ( $obj->{errors} && @{ $obj->{errors} } ) {
            $param->{error} = $app->translate(
                "One or more errors were found in this template.");
            $param->{error} .= "<ul>\n";
            foreach my $err ( @{ $obj->{errors} } ) {
                $param->{error}
                    .= "<li>"
                    . MT::Util::encode_html( $err->{message} )
                    . "</li>\n";
            }
            $param->{error} .= "</ul>\n";
        }

        # Populate list of included templates
        foreach my $tag (qw( Include IncludeBlock )) {
            my $includes = $obj->getElementsByTagName($tag);
            if ($includes) {
                my @includes;
                my @widgets;
                my %seen;
                foreach my $tag (@$includes) {
                    my $include = {};
                    my $attr    = $tag->attributes;
                    my $mod     = $include->{include_module} = $attr->{module}
                        || $attr->{widget};
                    next unless $mod;
                    next if $mod =~ /^\$.*/;
                    my $type = $attr->{widget} ? 'widget' : 'custom';
                    if (   $tag->[1]->{blog_id}
                        && $tag->[1]->{blog_id} =~ m/^\$/ )
                    {
                        $include->{include_from} = 'error';
                        $include->{include_blog_name}
                            = $app->translate('Unknown blog');
                    }
                    else {
                        my $inc_blog_id
                            = $tag->[1]->{global}
                            ? 0
                            : $tag->[1]->{blog_id}
                            ? [ $tag->[1]->{blog_id}, 0 ]
                            : $tag->[1]->{parent} ? $obj->blog
                                ? $obj->blog->website->id
                                : 0
                            : [ $obj->blog_id, 0 ];

                        my $mod_id 
                            = $mod . "::"
                            . (
                            ref $inc_blog_id
                            ? $inc_blog_id->[0]
                            : $inc_blog_id
                            );
                        next if exists $seen{$type}{$mod_id};
                        $seen{$type}{$mod_id} = 1;

                        my $other = MT::Template->load(
                            {   blog_id => $inc_blog_id,
                                name    => $mod,
                                type    => $type,
                            },
                            {   limit => 1,
                                ref $inc_blog_id
                                ? ( sort      => 'blog_id',
                                    direction => 'descend',
                                    )
                                : ()
                            }
                        );

                        if ($other) {
                            $include->{include_link} = $app->mt_uri(
                                mode => 'view',
                                args => {
                                    blog_id => $other->blog_id || 0,
                                    '_type' => 'template',
                                    id      => $other->id
                                }
                            );
                            $include->{can_link}
                                = $app->user->is_superuser
                                || $app->user->permissions(0)
                                ->can_do('edit_templates')
                                ? 1
                                : $other->blog_id
                                ? $app->user->permissions( $other->blog_id )
                                ->can_do('edit_templates')
                                    ? 1
                                    : 0
                                : 0;

                            # Try to compile template module
                            # if using MTInclude in this template.
                            $other->compile;
                            if ( $other->{errors} && @{ $other->{errors} } ) {
                                $param->{error} = $app->translate(
                                    "One or more errors were found in the included template module ([_1]).",
                                    $other->name
                                );
                                $param->{error} .= "<ul>\n";
                                foreach my $err ( @{ $other->{errors} } ) {
                                    $param->{error}
                                        .= "<li>"
                                        . MT::Util::encode_html(
                                        $err->{message} )
                                        . "</li>\n";
                                }
                                $param->{error} .= "</ul>\n";
                            }

                            if ( $other->blog_id ) {
                                if ( $other->blog_id eq $blog_id ) {
                                    $include->{include_from}      = 'self';
                                    $include->{include_blog_name} = 'self';
                                }
                                else {
                                    $include->{include_from}
                                        = $other->blog->is_blog
                                        ? 'blog'
                                        : 'website';
                                    $include->{include_blog_name}
                                        = $other->blog->name;
                                }
                            }
                            else {
                                $include->{include_from}
                                    = $blog_id
                                    ? 'global'
                                    : 'self';
                                $include->{include_blog_name}
                                    = $blog_id
                                    ? $app->translate('Global Template')
                                    : 'self';
                            }
                        }
                        else {
                            my $target_blog_id
                                = ref $inc_blog_id
                                ? $inc_blog_id->[0]
                                : $inc_blog_id;
                            $include->{create_link} = $app->mt_uri(
                                mode => 'view',
                                args => {
                                    blog_id => $target_blog_id,
                                    '_type' => 'template',
                                    type    => $type,
                                    name    => $mod,
                                }
                            );

                            my $target_blog;
                            $target_blog
                                = MT->model('blog')->load($target_blog_id)
                                if $target_blog_id;

                            if ($target_blog_id) {
                                if ($target_blog) {
                                    $include->{include_from}
                                        = $target_blog->id eq $blog_id
                                        ? 'self'
                                        : $target_blog->is_blog ? 'blog'
                                        :                         'website';
                                    $include->{include_blog_name}
                                        = $target_blog->name;
                                }
                                else {
                                    $include->{include_from} = 'error';
                                    $include->{include_blog_name}
                                        = $app->translate('Invalid Blog');
                                }
                            }
                            else {
                                $include->{include_from}
                                    = !$blog_id
                                    ? 'self'
                                    : 'global';
                                $include->{include_blog_name}
                                    = !$blog_id
                                    ? 'self'
                                    : $app->translate('Global Template');
                            }
                        }
                    }
                    if ( $type eq 'widget' ) {
                        push @widgets, $include;
                    }
                    else {
                        push @includes, $include;
                    }
                }

                push @{ $param->{include_loop} }, @includes if @includes;
                push @{ $param->{widget_loop} },  @widgets  if @widgets;
            }
        }
        my @sets = (
            @{ $obj->getElementsByTagName('WidgetSet') || [] },
            @{ $obj->getElementsByTagName('WidgetManager') || [] }
        );
        if (@sets) {
            my @widget_sets;
            my %seen;
            foreach my $set (@sets) {
                my $name = $set->attributes->{name};
                next unless $name;
                next if $seen{$name};
                $seen{$name} = 1;
                my $wset = MT::Template->load(
                    {   blog_id => [ $obj->blog_id, 0 ],
                        name    => $name,
                        type    => 'widgetset',
                    },
                    {   sort      => 'blog_id',
                        direction => 'descend',
                    }
                );
                if ($wset) {
                    my $include = {
                        include_link => $app->mt_uri(
                            mode => 'edit_widget',
                            args => {
                                blog_id => $wset->blog_id,
                                id      => $wset->id,
                            },
                        ),
                        include_module => $name,
                    };
                    $include->{include_from}
                        = $wset->blog_id ? 'self'
                        : $blog_id       ? 'global'
                        :                  'self';

                    my $inc_blog;
                    $inc_blog = MT->model('blog')->load( $wset->blog_id )
                        if $wset->blog_id;
                    $include->{include_blog_name}
                        = $inc_blog ? $inc_blog->name
                        : $blog_id  ? $app->translate('Global')
                        :             'self';
                    push @widget_sets, $include;
                }
                else {
                    push @widget_sets,
                        {
                        create_link => $app->mt_uri(
                            mode => 'edit_widget',
                            args => {
                                blog_id => $blog_id,
                                name    => $name
                            },
                        ),
                        include_module    => $name,
                        include_from      => 'self',
                        include_blog_name => $blog ? $blog->name : '',
                        };
                }
            }
            $param->{widget_set_loop} = \@widget_sets if @widget_sets;
        }
        $param->{have_includes} = 1
            if $param->{widget_set_loop}
                || $param->{include_loop}
                || $param->{widget_loop};

        # Populate archive types for creating new map
        my $obj_type = $obj->type;
        if (   $obj_type eq 'individual'
            || $obj_type eq 'page'
            || $obj_type eq 'author'
            || $obj_type eq 'category'
            || $obj_type eq 'archive' )
        {
            my @at = $app->publisher->archive_types;
            my @archive_types;
            for my $at (@at) {
                my $archiver      = $app->publisher->archiver($at);
                my $archive_label = $archiver->archive_label;
                $archive_label = $at unless $archive_label;
                $archive_label = $archive_label->()
                    if ( ref $archive_label ) eq 'CODE';
                if (   ( $obj_type eq 'archive' )
                    || ( $obj_type eq 'author' )
                    || ( $obj_type eq 'category' ) )
                {

                    # only include if it is NOT an entry-based archive type
                    next if $archiver->entry_based;
                }
                elsif ( $obj_type eq 'page' ) {

                   # only include if it is a entry-based archive type and page
                    next unless $archiver->entry_based;
                    next if $archiver->entry_class ne 'page';
                }
                elsif ( $obj_type eq 'individual' ) {

                  # only include if it is a entry-based archive type and entry
                    next unless $archiver->entry_based;
                    next if $archiver->entry_class eq 'page';
                }
                push @archive_types,
                    {
                    archive_type_translated => $archive_label,
                    archive_type            => $at,
                    };
                @archive_types
                    = sort { MT::App::CMS::archive_type_sorter( $a, $b ) }
                    @archive_types;
            }
            $param->{archive_types} = \@archive_types;

            # Populate template maps for this template
            my $maps = _populate_archive_loop( $app, $blog, $obj );
            if (@$maps) {
                $param->{object_loop} = $param->{template_map_loop} = $maps
                    if @$maps;
                my %at;
                foreach my $map (@$maps) {
                    $at{ $map->{archive_label} } = 1;
                    $param->{static_maps}
                        ||= (
                        $map->{map_build_type} != MT::PublishOption::DYNAMIC()
                            && $map->{map_build_type}
                            != MT::PublishOption::DISABLED() );
                }
                $param->{enabled_archive_types} = join( ", ", sort keys %at );
            }
            else {
                $param->{can_rebuild} = 0;
            }
        }

        # publish options
        $param->{build_type} = $obj->build_type;
        $param->{ 'build_type_' . ( $obj->build_type || 0 ) } = 1;

        #my ( $period, $interval ) = _get_schedule( $obj->build_interval );
        #$param->{ 'schedule_period_' . $period } = 1;
        #$param->{schedule_interval} = $interval;
        $param->{type} = 'custom' if $param->{type} eq 'module';
    }
    else {
        my $new_tmpl = $q->param('create_new_template');
        my $template_type;
        if ($new_tmpl) {
            if ( $new_tmpl =~ m/^blank:(.+)/ ) {
                $template_type = $1;
                $param->{type} = $1;
            }
            elsif ( $new_tmpl =~ m/^default:([^:]+):(.+)/ ) {
                $template_type = $1;
                $template_type = 'custom' if $template_type eq 'module';
                my $template_id = $2;
                my $set = $blog ? $blog->template_set : undef;
                require MT::DefaultTemplates;
                my $def_tmpl = MT::DefaultTemplates->templates($set) || [];
                my ($tmpl)
                    = grep { $_->{identifier} eq $template_id } @$def_tmpl;

                my $lang
                    = $blog_id
                    ? $blog->language
                    : MT->config->DefaultLanguage;
                my $current_lang = MT->current_language;
                MT->set_language($lang);
                $param->{text} = $app->translate_templatized( $tmpl->{text} )
                    if $tmpl;
                MT->set_language($current_lang);
                $param->{type} = $template_type;
            }
        }
        else {
            $template_type = $q->param('type');
            $template_type = 'custom' if 'module' eq $template_type;
            $param->{type} = $template_type;
        }
        return $app->errtrans(
            "You must specify a template type when creating a template")
            unless $template_type;
        $param->{nav_templates} = 1;
        my $tab;

        # FIXME: enumeration of types
        if ( $template_type eq 'index' ) {
            $tab = 'index';
            $param->{template_group_trans} = $app->translate('index');
        }
        elsif ($template_type eq 'archive'
            || $template_type eq 'individual'
            || $template_type eq 'category'
            || $template_type eq 'page' )
        {
            $tab                           = 'archive';
            $param->{template_group_trans} = $app->translate('archive');
            $param->{type_archive}         = 1;
            my @types = (
                {   key   => 'archive',
                    label => $app->translate('Archive')
                },
                {   key   => 'individual',
                    label => $app->translate('Entry or Page')
                },
            );
            $param->{new_archive_types} = \@types;
        }
        elsif ( $template_type eq 'custom' ) {
            $tab = 'module';
            $param->{template_group_trans} = $app->translate('module');
        }
        elsif ( $template_type eq 'widget' ) {
            $tab = 'widget';
            $param->{template_group_trans} = $app->translate('widget');
        }
        else {
            $tab = 'system';
            $param->{template_group_trans} = $app->translate('system');
        }
        $param->{template_group} = $tab;
        $app->translate($tab);
        $app->add_breadcrumb( $app->translate('New Template') );

        # FIXME: enumeration of types
        $param->{has_name} 
            = $template_type  eq 'index'
            || $template_type eq 'custom'
            || $template_type eq 'widget'
            || $template_type eq 'archive'
            || $template_type eq 'category'
            || $template_type eq 'page'
            || $template_type eq 'individual';
        $param->{has_outfile} = $template_type eq 'index';
        $param->{has_rebuild} = ( ( $template_type eq 'index' )
                && ( ( $blog->custom_dynamic_templates || "" ) ne 'all' ) );
        $param->{custom_dynamic}
            = $blog && $blog->custom_dynamic_templates eq 'custom';
        $param->{has_build_options} = $blog
            && ( $blog->custom_dynamic_templates eq 'custom'
            || $param->{has_rebuild} );

        # FIXME: enumeration of types
        $param->{is_special} 
            = $param->{type}  ne 'index'
            && $param->{type} ne 'archive'
            && $param->{type} ne 'category'
            && $param->{type} ne 'page'
            && $param->{type} ne 'individual';
        $param->{has_build_options} 
            = $param->{has_build_options}
            && $param->{type} ne 'custom'
            && $param->{type} ne 'widget'
            && !$param->{is_special};
        $param->{name} = $app->param('name') if $app->param('name');
    }
    $param->{publish_queue_available}
        = eval 'require List::Util; require Scalar::Util; 1;';

    my $set = $blog ? $blog->template_set : undef;
    require MT::DefaultTemplates;
    my $tmpls = MT::DefaultTemplates->templates($set);
    my @tmpl_ids;
    foreach my $dtmpl (@$tmpls) {
        if ( !$param->{has_name} ) {
            if ( $obj->type eq 'email' ) {
                if ( $dtmpl->{identifier} eq $obj->identifier ) {
                    $param->{template_name_label} = $dtmpl->{label};
                    $param->{template_name}       = $dtmpl->{name};
                }
            }
            else {
                if ( $dtmpl->{type} eq $obj->type ) {
                    $param->{template_name_label} = $dtmpl->{label};
                    $param->{template_name}       = $dtmpl->{name};
                }
            }
        }
        if ( $dtmpl->{type} eq 'index' ) {
            push @tmpl_ids,
                {
                label    => $dtmpl->{label},
                key      => $dtmpl->{key},
                selected => $dtmpl->{key} eq
                    ( ( $obj ? $obj->identifier : undef ) || '' ),
                };
        }
    }
    $param->{index_identifiers} = \@tmpl_ids;

    $param->{"type_$param->{type}"} = 1;
    if ($perms) {
        my $pref_param = $app->load_template_prefs( $perms->template_prefs );
        %$param = ( %$param, %$pref_param );
    }

    # Populate structure for template snippets
    if ( my $snippets = $app->registry('template_snippets') || {} ) {
        my @snippets;
        for my $snip_id ( keys %$snippets ) {
            my $label = $snippets->{$snip_id}{label};
            $label = $label->() if ref($label) eq 'CODE';
            push @snippets,
                {
                id      => $snip_id,
                trigger => $snippets->{$snip_id}{trigger},
                label   => $label,
                content => $snippets->{$snip_id}{content},
                };
        }
        @snippets = sort { $a->{label} cmp $b->{label} } @snippets;
        $param->{template_snippets} = \@snippets;
    }

    # Populate structure for tag documentation
    my $all_tags = MT::Component->registry("tags");
    my $tag_docs = {};
    foreach my $tag_set (@$all_tags) {
        my $url = $tag_set->{help_url};
        $url = $url->() if ref($url) eq 'CODE';

        # hey, at least give them a google search
        $url ||= 'http://www.google.com/search?q=mt%t';
        my $tag_list = '';
        foreach my $type (qw( block function )) {
            my $tags = $tag_set->{$type} or next;
            $tag_list
                .= ( $tag_list eq '' ? '' : ',' ) . join( ",", keys(%$tags) );
        }
        $tag_list =~ s/(^|,)plugin(,|$)/,/;
        if ( exists $tag_docs->{$url} ) {
            $tag_docs->{$url} .= ',' . $tag_list;
        }
        else {
            $tag_docs->{$url} = $tag_list;
        }
    }
    $param->{tag_docs} = $tag_docs;
    $param->{link_doc} = $app->help_url('appendices/tags/');

    $param->{screen_id} = "edit-template-" . $param->{type};

    # template language
    $param->{template_lang} = 'html';
    if ( $obj && $obj->outfile ) {
        if ( $obj->outfile =~ m/\.(css|js|html|php|pl|asp)$/ ) {
            $param->{template_lang} = {
                css  => 'css',
                js   => 'javascript',
                html => 'html',
                php  => 'php',
                pl   => 'perl',
                asp  => 'asp',
            }->{$1};
        }
    }

    if ( ( $param->{type} eq 'custom' ) || ( $param->{type} eq 'widget' ) ) {
        if ($blog) {
            $param->{include_with_ssi}      = 0;
            $param->{cache_path}            = '';
            $param->{cache_expire_type}     = 0;
            $param->{cache_expire_period}   = '';
            $param->{cache_expire_interval} = 0;
            $param->{ssi_type}
                = defined $blog->include_system
                ? uc $blog->include_system
                : '';
        }
        if ($obj) {
            $param->{include_with_ssi} = $obj->include_with_ssi
                if defined $obj->include_with_ssi;
            $param->{cache_path} = $obj->cache_path
                if defined $obj->cache_path;
            $param->{cache_expire_type} = $obj->cache_expire_type
                if defined $obj->cache_expire_type;
            my ( $period, $interval )
                = _get_schedule( $obj->cache_expire_interval );
            $param->{cache_expire_period}   = $period   if defined $period;
            $param->{cache_expire_interval} = $interval if defined $interval;
            my @events = split ',', ( $obj->cache_expire_event || '' );
            foreach my $name (@events) {
                $param->{ 'cache_expire_event_' . $name } = 1;
            }
        }
    }

    # if unset, default to 30 so if they choose to enable caching,
    # it will be preset to something sane.
    $param->{cache_expire_interval} ||= 30;

    $param->{dirty} = 1
        if $app->param('dirty');

    $param->{can_preview} = 1
        if ( !$param->{is_special} )
        && ( !$obj
        || ( $obj && ( $obj->outfile || '' ) !~ m/\.(css|xml|rss|js)$/ ) )
        && ( !exists $param->{can_preview} );

    if ( $blog && $blog->use_revision ) {
        $param->{use_revision} = 1;

 #TODO: the list of revisions won't appear on the edit screen.
 #$param->{revision_table} = $app->build_page(
 #    MT::CMS::Common::build_revision_table(
 #        $app,
 #        object => $obj || MT::Template->new,
 #        param => {
 #            template => 'include/revision_table.tmpl',
 #            args     => {
 #                sort_order => 'rev_number',
 #                direction  => 'descend',
 #                limit      => 5,              # TODO: configurable?
 #            },
 #            revision => $obj ? $obj->revision || $obj->current_revision : 0,
 #        }
 #    ),
 #    { show_actions => 0, hide_pager => 1 }
 #);
    }
    1;
}

sub list {
    my $app = shift;

    my $perms = $app->blog ? $app->permissions : $app->user->permissions;
    return $app->return_to_dashboard( redirect => 1 )
        unless $perms || $app->user->is_superuser;
    if ( $perms && !$perms->can_edit_templates ) {
        return $app->permission_denied();
    }
    my $blog = $app->blog;

    require MT::Template;
    my $blog_id = $app->param('blog_id') || 0;
    my $terms = { blog_id => $blog_id };
    my $args  = { sort    => 'name' };

    my $hasher = sub {
        my ( $obj, $row ) = @_;
        my $template_type;
        my $type = $row->{type} || '';
        my $tblog = MT::Blog->load( $obj->blog_id ) if $obj->blog_id;
        if ( $type =~ m/^(individual|page|category|archive)$/ ) {
            $template_type = 'archive';

            # populate context with templatemap loop
            if ($tblog) {
                $row->{archive_types}
                    = _populate_archive_loop( $app, $tblog, $obj );
            }
        }
        elsif ( $type eq 'widget' ) {
            $template_type = 'widget';
        }
        elsif ( $type eq 'index' ) {
            $template_type = 'index';
        }
        elsif ( $type eq 'custom' ) {
            $template_type = 'module';
        }
        elsif ( $type eq 'email' ) {
            $template_type = 'email';
        }
        elsif ( $type eq 'backup' ) {
            $template_type = 'backup';
        }
        else {
            $template_type = 'system';
        }
        $row->{use_cache}
            = (    $tblog
                && $tblog->include_cache
                && ( $obj->cache_expire_type || 0 ) != 0 ) ? 1 : 0;
        $row->{use_ssi}
            = ( $tblog && $tblog->include_system && $obj->include_with_ssi )
            ? 1
            : 0;
        $row->{template_type} = $template_type;
        $row->{type} = 'entry' if $type eq 'individual';
        my $published_url = $obj->published_url;
        $row->{published_url} = $published_url if $published_url;
    };

    my $params        = {};
    my $filter        = $app->param('filter_key');
    my $template_type = $filter || '';
    $template_type =~ s/_templates//;

    $params->{screen_class}   = "list-template";
    $params->{listing_screen} = 1;

    $app->load_list_actions( 'template', $params );
    $params->{page_actions}  = $app->page_actions('list_templates');
    $params->{search_label}  = $app->translate("Templates");
    $params->{object_type}   = 'template';
    $params->{blog_view}     = 1;
    $params->{refreshed}     = $app->param('refreshed');
    $params->{published}     = $app->param('published');
    $params->{saved_copied}  = $app->param('saved_copied');
    $params->{saved_deleted} = $app->param('saved_deleted');
    $params->{saved}         = $app->param('saved');

    # determine list of system template types:
    my $scope;
    my $set;
    if ($blog) {
        my $ts = $blog->template_set;
        if ( ref $ts ) {
            $set = $ts->{templates};
        }
        elsif ( $ts ne 'mt_blog' ) {
            $set = MT->registry(
                template_sets => $blog->template_set => 'templates' );
        }
        else {
            $set = MT->registry('default_templates');
        }
        $scope = 'system';
    }
    else {
        $set   = MT->registry('default_templates');
        $scope = 'global:system';
    }

    my $sys_tmpl = $set->{$scope};
    my @tmpl_loop;
    my %types;
    if ( $template_type ne 'backup' ) {
        if ($blog) {

            # blog template listings
            %types = (
                'index' => {
                    label => $app->translate("Index Templates"),
                    type  => 'index',
                    order => 100,
                },
                'archive' => {
                    label => $app->translate("Archive Templates"),
                    type  => [ 'archive', 'individual', 'page', 'category' ],
                    order => 200,
                },
                'module' => {
                    label => $app->translate("Template Modules"),
                    type  => 'custom',
                    order => 300,
                },
                'system' => {
                    label => $app->translate("System Templates"),
                    type  => [ keys %$sys_tmpl ],
                    order => 400,
                },
            );
        }
        else {

            # global template listings
            %types = (
                'module' => {
                    label => $app->translate("Template Modules"),
                    type  => 'custom',
                    order => 100,
                },
                'email' => {
                    label => $app->translate("Email Templates"),
                    type  => 'email',
                    order => 200,
                },
                'system' => {
                    label => $app->translate("System Templates"),
                    type  => [ keys %$sys_tmpl ],
                    order => 300,
                },
            );
        }
    }
    else {

        # global template listings
        %types = (
            'backup' => {
                label => $app->translate("Template Backups"),
                type  => 'backup',
                order => 100,
            },
        );
    }
    my @types
        = sort { $types{$a}->{order} <=> $types{$b}->{order} } keys %types;
    if ($template_type) {
        @types = ($template_type);
    }
    $app->delete_param('filter_key') if $filter;
    foreach my $tmpl_type (@types) {
        if ( $tmpl_type eq 'index' ) {
            $app->param( 'filter_key', 'index_templates' );
        }
        elsif ( $tmpl_type eq 'archive' ) {
            $app->param( 'filter_key', 'archive_templates' );
        }
        elsif ( $tmpl_type eq 'system' ) {
            $app->param( 'filter_key', 'system_templates' );
        }
        elsif ( $tmpl_type eq 'email' ) {
            $app->param( 'filter_key', 'email_templates' );
        }
        elsif ( $tmpl_type eq 'module' ) {
            $app->param( 'filter_key', 'module_templates' );
        }
        elsif ( $tmpl_type eq 'backup' ) {
            $app->param( 'filter_key', 'backup_templates' );
        }
        my $tmpl_param = {};
        unless ( exists( $types{$tmpl_type}->{type} )
            && 'ARRAY' eq ref( $types{$tmpl_type}->{type} )
            && 0 == scalar( @{ $types{$tmpl_type}->{type} } ) )
        {
            $terms->{type} = $types{$tmpl_type}->{type};
            $tmpl_param = $app->listing(
                {   type     => 'template',
                    terms    => $terms,
                    args     => $args,
                    no_limit => 1,
                    no_html  => 1,
                    code     => $hasher,
                }
            );
        }
        my $template_type_label = $types{$tmpl_type}->{label};
        $tmpl_param->{template_type}       = $tmpl_type;
        $tmpl_param->{template_type_label} = $template_type_label;
        push @tmpl_loop, $tmpl_param;
    }
    if ($filter) {
        $params->{filter_key}   = $filter;
        $params->{filter_label} = $types{$template_type}{label}
            if exists $types{$template_type};
        $app->param( 'filter_key', $filter );
    }
    else {

        # restore filter_key param (we modified it for the
        # sake of the individual table listings)
        $app->delete_param('filter_key');
    }

    $params->{template_type_loop} = \@tmpl_loop;
    $params->{screen_id}          = "list-template";

    return $app->load_tmpl( 'list_template.tmpl', $params );
}

sub preview {
    my $app     = shift;
    my $q       = $app->param;
    my $blog_id = $q->param('blog_id');
    my $blog    = $app->blog;
    my $id      = $q->param('id');
    my $tmpl;
    my $user_id = $app->user->id;

    return unless $app->validate_magic;

    my $perms = $app->blog ? $app->permissions : $app->user->permissions;
    return $app->return_to_dashboard( redirect => 1 )
        unless $perms || $app->user->is_superuser;
    if ( $perms && !$perms->can_edit_templates ) {
        return $app->return_to_dashboard( permission => 1 );
    }

    # We can only do previews on blog templates. Have to publish
    # the preview file somewhere!
    return $app->errtrans("Invalid request.") unless $blog;

    require MT::Template;
    if ($id) {
        $tmpl = MT::Template->load( { id => $id, blog_id => $blog_id } )
            or return $app->errtrans("Invalid request.");
    }
    else {
        $tmpl = MT::Template->new;
        $tmpl->id(-1);
        $tmpl->blog_id($blog_id);
    }

    my $names = $tmpl->column_names;
    my %values = map { $_ => scalar $app->param($_) } @$names;
    delete $values{'id'} unless $q->param('id');

    ## Strip linefeed characters.
    for my $col (qw( text )) {
        $values{$col} =~ tr/\r//d if $values{$col};
    }
    $tmpl->set_values( \%values );

    my $preview_basename = $app->preview_object_basename;

    my $type         = $tmpl->type;
    my $preview_tmpl = $tmpl;
    my $archive_file;
    my $archive_url;
    my %param;
    my $blog_path       = $blog->site_path;
    my $blog_url        = $blog->site_url;
    my $use_virtual_cat = 0;

    if ( ( $type eq 'custom' ) || ( $type eq 'widget' ) ) {

        # determine 'host' template
        $preview_tmpl = MT::Template->load(
            { blog_id => $blog_id, identifier => 'main_index' } );
        if ( !$preview_tmpl ) {
            return $app->errtrans(
                "Cannot locate host template to preview module/widget.");
        }
        my $req = $app->request;

        # stash this module so that it is selected through a
        # MTInclude tag instead of the one in the database:
        my $tmpl_name = $tmpl->name;
        $tmpl_name =~ s/^Widget: // if $type eq 'widget';
        my $stash_id
            = 'template_' . $type . '::' . $blog_id . '::' . $tmpl_name;
        $req->stash( $stash_id, [ $tmpl, $tmpl->tokens ] );
    }
    elsif ( ( $type eq 'individual' ) || ( $type eq 'page' ) ) {
        my $ctx = $preview_tmpl->context;
        my $entry_type = $type eq 'individual' ? 'entry' : 'page';
        my ($obj) = create_preview_content( $app, $blog, $entry_type, 1 );
        $obj->basename($preview_basename);
        $ctx->stash( 'entry', $obj );
        $ctx->{current_archive_type}
            = $type eq 'individual' ? 'Individual' : 'Page';
        if ( ( $type eq 'individual' ) && $blog->archive_path ) {
            $blog_path = $blog->archive_path;
            $blog_url  = $blog->archive_url;
        }
        $archive_file = File::Spec->catfile( $blog_path, $obj->archive_file );
        $archive_url = $obj->archive_url;

        my $archiver
            = MT->publisher->archiver( $ctx->{current_archive_type} );
        my $tparams = $archiver->template_params;
        if ($tparams) {
            $ctx->var( $_, $tparams->{$_} ) for keys %$tparams;
        }
    }
    elsif ( $type eq 'archive' ) {

        # some variety of archive template
        my $ctx = $preview_tmpl->context;
        require MT::TemplateMap;
        my $map = MT::TemplateMap->load( { template_id => $id } );
        if ( !$map ) {
            return $app->error(
                $app->translate("Cannot preview without a template map!") );
        }
        $ctx->{current_archive_type} = $map->archive_type;
        my $archiver = MT->publisher->archiver( $map->archive_type );
        my $tparams  = $archiver->template_params;
        if ($tparams) {
            $ctx->var( $_, $tparams->{$_} ) for keys %$tparams;
        }

        my $cat;
        if ( $archiver->category_based ) {
            $cat = MT->model('category')->load(
                { blog_id => $blog_id, },
                {   sort      => 'id',
                    direction => 'ascend',
                }
            );
            unless ($cat) {
                $use_virtual_cat = 1;
                $cat             = new MT::Category;
                $cat->label( $app->translate("Preview") );
                $cat->basename("preview");
                $cat->parent(0);
                $ctx->stash( 'archive_category', $cat );
            }
            $ctx->stash( 'archive_category', $cat );
        }

        my @entries
            = create_preview_content( $app, $blog, $archiver->entry_class, 10,
            $cat );
        $ctx->stash( 'entries', \@entries );

        if ( $archiver->date_based ) {
            $ctx->{current_timestamp}     = $entries[0]->authored_on;
            $ctx->{current_timestamp_end} = $entries[$#entries]->authored_on;
        }
        if ( $archiver->author_based ) {
            $ctx->stash( 'author', $app->user );
        }

        my $file
            = MT->publisher->archive_file_for( $entries[0], $blog,
            $map->archive_type, $cat, $map, $ctx->{current_timestamp},
            $app->user );
        $archive_file = File::Spec->catfile( $blog_path, $file );
        $archive_url = MT::Util::caturl( $blog_url, $file );
    }
    elsif ( $type eq 'index' ) {
    }
    else {

        # for now, only index templates can be previewed
        return $app->errtrans("Invalid request.");
    }

    my $orig_file;
    my $path;

    # Default case; works for index templates (other template types should
    # have defined $archive_file by now).
    my $outfile = $preview_tmpl->outfile;
    my ($path_in_outfile) = $outfile =~ m/^(.*\/)/;
    $archive_file = File::Spec->catfile( $blog_path, $outfile )
        unless defined $archive_file;

    ( $orig_file, $path ) = File::Basename::fileparse($archive_file);

    $archive_url = MT::Util::caturl( $blog_url, $orig_file )
        unless defined $archive_url;

    my $file_ext;
    require File::Basename;
    $file_ext = $archive_file;
    if ( $file_ext =~ m/\.[a-z]+$/ ) {
        $file_ext =~ s!.+\.!.!;
    }
    else {
        $file_ext = '';
    }
    $archive_file
        = File::Spec->catfile( $path, $preview_basename . $file_ext );

    my @data;
    $app->run_callbacks( 'cms_pre_preview.template', $app, $preview_tmpl,
        \@data );

    my $has_hires = eval 'require Time::HiRes; 1' ? 1 : 0;
    my $start_time = $has_hires ? Time::HiRes::time() : time;

    my $ctx = $preview_tmpl->context;
    $ctx->var( 'preview_template', 1 );
    my $html = $preview_tmpl->output;

    $param{build_time}
        = $has_hires
        ? sprintf( "%.3f", Time::HiRes::time() - $start_time )
        : "~" . ( time - $start_time );

    unless ( defined($html) ) {
        return $app->error(
            $app->translate(
                "Publish error: [_1]",
                MT::Util::encode_html( $preview_tmpl->errstr )
            )
        );
    }

    # If MT is configured to do 'local' previews, convert all
    # the normal blog URLs into the domain used by MT itself (ie,
    # blog is published to www.example.com, which is a different
    # server from where MT runs, mt.example.com; previews therefore
    # should occur locally, so replace all http://www.example.com/
    # with http://mt.example.com/).
    my ( $old_url, $new_url );
    if ( $app->config('LocalPreviews') ) {
        $old_url = $blog_url;
        $old_url =~ s!^(https?://[^/]+?/)(.*)?!$1!;
        $new_url = $app->base . '/';
        $html =~ s!\Q$old_url\E!$new_url!g;
    }

    my $fmgr = $blog->file_mgr;

    ## Determine if we need to build directory structure,
    ## and build it if we do. DirUmask determines
    ## directory permissions.
    require File::Basename;
    $path =~ s!/$!!
        unless $path eq '/';    ## OS X doesn't like / at the end in mkdir().
    unless ( $fmgr->exists($path) ) {
        $fmgr->mkpath($path);
    }

    if ( $fmgr->exists($path) && $fmgr->can_write($path) ) {
        $param{preview_file} = $preview_basename;
        my $preview_url = $archive_url;
        $preview_url
            =~ s! / \Q$orig_file\E ( /? ) $!/$path_in_outfile$preview_basename$file_ext$1!x;

        # We also have to translate the URL used for the
        # published file to be on the MT app domain.
        if ( defined $new_url ) {
            $preview_url =~ s!^\Q$old_url\E!$new_url!;
        }

        $param{preview_url} = $preview_url;

        $fmgr->put_data( $html, $archive_file );

        # we have to make a record of this preview just in case it
        # isn't cleaned up by re-editing, saving or cancelling on
        # by the user.
        require MT::Session;
        my $sess_obj = MT::Session->get_by_key(
            {   id   => $preview_basename,
                kind => 'TF',                # TF = Temporary File
                name => $archive_file,
            }
        );
        $sess_obj->start(time);
        $sess_obj->save;
    }
    else {
        return $app->error(
            $app->translate(
                "Unable to create preview file in this location: [_1]", $path
            )
        );
    }

    $param{id} = $id if $id;
    $param{new_object} = $param{id} ? 0 : 1;
    $param{name} = $tmpl->name;
    if ( $type ne 'index' ) {
        $q->param( 'build_dynamic', $tmpl->build_dynamic );
        $q->param( 'build_type',    $tmpl->build_type );
    }
    my $cols = $tmpl->column_names;
    for my $col ( ( @$cols, 'save_revision', 'revision-note' ) ) {
        push @data,
            {
            data_name  => $col,
            data_value => scalar $q->param($col)
            };
    }

    # Set selected archive mapping
    my @p = $q->param;
    for my $p (@p) {
        if ( $p =~ /^archive_file_tmpl_(\d+)$/ ) {
            push @data,
                {
                data_name  => 'archive_file_tmpl_' . $1,
                data_value => scalar $q->param($p)
                };
        }
    }

    $param{template_loop}   = \@data;
    $param{object_type}     = $type;
    $param{use_virtual_cat} = $use_virtual_cat;
    $app->request( 'preview_object', $tmpl );
    return $app->load_tmpl( 'preview_template_strip.tmpl', \%param );
}

sub create_preview_content {
    my ( $app, $blog, $type, $number, $cat ) = @_;

    my $blog_id     = $blog->id;
    my $entry_class = $app->model($type);
    my $cat_args
        = $cat
        ? { join => MT->model('placement')
            ->join_on( 'id', { category_id => $cat->id } ) }
        : {};
    my @obj = $entry_class->load(
        {   blog_id => $blog_id,
            status  => MT::Entry::RELEASE()
        },
        {   limit => $number || 1,
            direction => 'descend',
            'sort'    => 'authored_on',
            %$cat_args,
        }
    );
    unless (@obj) {

        # create a dummy object
        my $obj = $entry_class->new;
        $obj->blog_id($blog_id);
        $obj->id(-1);
        $obj->author_id( $app->user->id );
        $obj->authored_on( $blog->current_timestamp );
        $obj->created_on( $blog->current_timestamp );
        $obj->modified_on( $blog->current_timestamp );
        $obj->status( MT::Entry::RELEASE() );
        $obj->title( $app->translate("Lorem ipsum") );
        my $preview_text = $app->translate('LOREM_IPSUM_TEXT');

        if ( $preview_text eq 'LOREM_IPSUM_TEXT' ) {
            $preview_text
                = q{Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut diam quam, accumsan eu, aliquam vel, ultrices a, augue. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Fusce hendrerit, lacus eget bibendum sollicitudin, mi tellus interdum neque, sit amet pretium tortor tellus id erat. Duis placerat justo ac erat. Duis posuere, risus eu elementum viverra, nisl lacus sagittis lorem, ac fermentum neque pede vitae arcu. Phasellus arcu elit, placerat eu, luctus posuere, tristique non, augue. In hac habitasse platea dictumst. Nunc non dolor et ipsum mattis malesuada. Praesent porta orci eu ligula. Ut dui augue, dapibus vitae, sodales in, lobortis non, felis. Aliquam feugiat mollis ipsum.};
        }
        my $preview_more = $app->translate('LORE_IPSUM_TEXT_MORE');
        if ( $preview_text eq 'LOREM_IPSUM_TEXT_MORE' ) {
            $preview_more
                = q{Integer nunc nulla, vulputate sit amet, varius ac, faucibus ac, lectus. Nulla semper bibendum justo. In hac habitasse platea dictumst. Aliquam auctor pretium ante. Etiam porta consectetuer erat. Phasellus consequat, nisi eu suscipit elementum, metus leo malesuada pede, vel scelerisque lorem ligula in augue. Sed aliquet. Donec malesuada metus sit amet sapien. Integer non libero. Morbi egestas, mauris posuere consequat sodales, augue lectus suscipit velit, eu commodo lacus dolor congue justo. Suspendisse justo. Curabitur sagittis, lorem tincidunt elementum rhoncus, odio dolor mattis odio, quis ultrices ligula ipsum ac lacus. Nam et sapien ac lacus ultrices sollicitudin. Vestibulum ut dolor nec dui malesuada imperdiet. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae;

            Quisque pharetra libero quis nibh. Cras lacus orci, commodo et, fringilla non, lobortis non, mauris. Curabitur dui sapien, tristique imperdiet, ultrices vitae, gravida varius, ante. Maecenas ac arcu nec nibh euismod feugiat. Pellentesque sed orci eget enim egestas faucibus. Aenean laoreet leo ornare velit. Nunc fermentum dolor eget massa. Fusce fringilla, tellus in pellentesque sodales, urna mi hendrerit leo, vel adipiscing ligula odio sit amet risus. Cras rhoncus, mi et posuere gravida, purus sem porttitor nisl, auctor laoreet nisl turpis quis ligula. Aliquam in nisi tristique augue egestas lacinia. Aenean ante magna, facilisis a, faucibus at, aliquam laoreet, dui. Ut tellus leo, tristique a, pellentesque ac, bibendum non, ipsum. Curabitur eu neque pretium arcu accumsan tincidunt. Ut ipsum. Quisque congue accumsan elit. Nulla ligula felis, aliquam ultricies, vestibulum vestibulum, semper vel, sapien. Aenean sodales ligula venenatis tellus. Vestibulum leo. Morbi viverra convallis eros.

            Phasellus rhoncus pulvinar enim. Ut gravida ante nec lectus. Nam luctus gravida odio. Morbi vitae lorem vitae justo fermentum porttitor. Suspendisse vestibulum magna at purus. Cras nec sem. Duis id felis. Mauris hendrerit dapibus est. Donec semper. Praesent vehicula interdum velit. Ut sed tellus et diam venenatis pulvinar.};
        }
        $obj->text($preview_text);
        $obj->text_more($preview_more);
        $obj->keywords( MT->translate("sample, entry, preview") );
        $obj->tags(qw( lorem ipsum sample preview ));
        @obj = ($obj);
    }
    return @obj;
}

## Unused?
sub reset_blog_templates {
    my $app   = shift;
    my $q     = $app->param;
    my $perms = $app->permissions
        or return $app->error( $app->translate("No permissions") );
    return $app->permission_denied()
        unless $perms->can_do('reset_blog_templates');
    $app->validate_magic() or return;
    my $blog = MT::Blog->load( $perms->blog_id )
        or return $app->error(
        $app->translate( 'Cannot load blog #[_1].', $perms->blog_id ) );
    require MT::Template;
    my @tmpl = MT::Template->load( { blog_id => $blog->id } );

    for my $tmpl (@tmpl) {
        $tmpl->remove or return $app->error( $tmpl->errstr );
    }
    my $set = $blog ? $blog->template_set : undef;
    require MT::DefaultTemplates;
    my $tmpl_list = MT::DefaultTemplates->templates($set) || [];
    my @arch_tmpl;
    for my $val (@$tmpl_list) {
        $val->{text} = $app->translate_templatized( $val->{text} );
        my $tmpl = MT::Template->new;
        if (   ( 'widgetset' eq $val->{type} )
            && ( exists $val->{modulesets} ) )
        {
            my $modulesets = delete $val->{modulesets};
            $tmpl->modulesets( join ',', @$modulesets );
        }
        $tmpl->set_values($val);
        $tmpl->build_dynamic(0);
        $tmpl->blog_id( $blog->id );
        $tmpl->save
            or return $app->error(
            $app->translate(
                "Populating blog with default templates failed: [_1]",
                $tmpl->errstr
            )
            );

        # FIXME: enumeration of types
        if (   $val->{type} eq 'archive'
            || $val->{type} eq 'category'
            || $val->{type} eq 'page'
            || $val->{type} eq 'individual' )
        {
            push @arch_tmpl, $tmpl;
        }
    }

    ## Set up mappings from new templates to archive types.
    for my $tmpl (@arch_tmpl) {
        my (@at);

        # FIXME: enumeration of types
        if ( $tmpl->type eq 'archive' ) {
            @at = qw( Daily Weekly Monthly Category );
        }
        elsif ( $tmpl->type eq 'page' ) {
            @at = qw( Page );
        }
        elsif ( $tmpl->type eq 'individual' ) {
            @at = qw( Individual );
        }
        require MT::TemplateMap;
        for my $at (@at) {
            my $map = MT::TemplateMap->new;
            $map->archive_type($at);
            $map->is_preferred(1);
            $map->template_id( $tmpl->id );
            $map->blog_id( $tmpl->blog_id );
            $map->save
                or return $app->error(
                $app->translate(
                    "Setting up mappings failed: [_1]",
                    $map->errstr
                )
                );
        }
    }
    $app->redirect(
        $app->uri(
            'mode' => 'list',
            args =>
                { '_type' => 'template', blog_id => $blog->id, 'reset' => 1 }
        )
    );
}

sub _generate_map_table {
    my $app = shift;
    my ( $blog_id, $template_id ) = @_;

    require MT::Template;
    require MT::Blog;
    my $blog     = MT::Blog->load($blog_id);
    my $template = MT::Template->load($template_id);
    my $tmpl     = $app->load_tmpl('include/archive_maps.tmpl');
    my $maps     = _populate_archive_loop( $app, $blog, $template );
    $tmpl->param( object_type => 'templatemap' );
    $tmpl->param( publish_queue_available => eval
            'require List::Util; require Scalar::Util; 1;' );
    $tmpl->param( object_loop => $maps ) if @$maps;
    my $html = $tmpl->output();

    if ( $html =~ m/<__trans / ) {
        $html = $app->translate_templatized($html);
    }
    $html;
}

sub _populate_archive_loop {
    my $app = shift;
    my $q   = $app->param;
    my ( $blog, $obj ) = @_;

    my $index = $app->config('IndexBasename');
    my $ext = $blog->file_extension || '';
    $ext = '.' . $ext if $ext ne '';

    require MT::TemplateMap;
    my @tmpl_maps = MT::TemplateMap->load( { template_id => $obj->id } );
    my @maps;
    my %types;
    foreach my $map_obj (@tmpl_maps) {
        my $map = {};
        $map->{map_id}           = $map_obj->id;
        $map->{map_is_preferred} = $map_obj->is_preferred;

        # publish options
        $map->{map_build_type} = $map_obj->build_type;
        $map->{ 'map_build_type_' . ( $map_obj->build_type || 0 ) } = 1;
        my ( $period, $interval ) = _get_schedule( $map_obj->build_interval );
        $map->{ 'map_schedule_period_' . $period } = 1
            if defined $period;
        $map->{map_schedule_interval} = $interval
            if defined $interval;

        my $at = $map->{archive_type} = $map_obj->archive_type;
        $types{$at}++;
        $map->{ 'archive_type_preferred_' . $blog->archive_type_preferred }
            = 1
            if $blog->archive_type_preferred;
        my $selected_file_template
            = $q->param( 'archive_file_tmpl_' . $map->{map_id} );
        $map->{file_template}
            = $selected_file_template ? $selected_file_template
            : $map_obj->file_template ? $map_obj->file_template
            :                           '';

        my $archiver = $app->publisher->archiver($at);
        next unless $archiver;
        $map->{archive_label} = $archiver->archive_label;
        my $tmpls     = $archiver->default_archive_templates;
        my $tmpl_loop = [];
        foreach (@$tmpls) {
            my $name = $_->{label};
            $name =~ s/\.html$/$ext/;
            $name =~ s/index$ext$/$index$ext/;
            push @$tmpl_loop,
                {
                name    => $name,
                value   => $_->{template},
                default => ( $_->{default} || 0 ),
                };
        }

        my $custom = 1;

        foreach (@$tmpl_loop) {
            if (   ( !$map->{file_template} && $_->{default} )
                || ( $map->{file_template} eq $_->{value} ) )
            {
                $_->{selected}        = 1;
                $custom               = 0;
                $map->{file_template} = $_->{value}
                    if !$map->{file_template};
            }
        }
        if ($custom) {
            unshift @$tmpl_loop,
                {
                name     => $map->{file_template},
                value    => $map->{file_template},
                selected => 1,
                };
        }

        $map->{archive_tmpl_loop} = $tmpl_loop;
        if (1 < MT::TemplateMap->count(
                { archive_type => $at, blog_id => $obj->blog_id }
            )
            )
        {
            $map->{has_multiple_archives} = 1;
        }

        push @maps, $map;
    }
    @maps = sort { MT::App::CMS::archive_type_sorter( $a, $b ) } @maps;
    return \@maps;
}

sub delete_map {
    my $app = shift;

    $app->validate_magic() or return;
    return $app->error( $app->translate('No permissions') )
        unless $app->can_do('edit_templates');

    my $q           = $app->param;
    my $id          = $q->param('id');
    my $blog_id     = $q->param('blog_id');
    my $template_id = $q->param('template_id');

    $app->model('template')
        ->load( { id => $template_id, blog_id => $blog_id } )
        or
        return $app->errtrans( 'Cannot load template #[_1].', $template_id );

    require MT::TemplateMap;
    my $map = MT::TemplateMap->load( { id => $id, blog_id => $blog_id } )
        or return $app->errtrans('Cannot load templatemap');
    $map->remove;

    my $blog = MT->model('blog')->load($blog_id);
    $blog->flush_has_archive_type_cache();

    my $html = _generate_map_table( $app, $blog_id, $template_id );
    $app->{no_print_body} = 1;
    $app->send_http_header("text/plain");
    $app->print_encode($html);
}

sub add_map {
    my $app = shift;

    $app->validate_magic() or return;
    return $app->error( $app->translate('No permissions') )
        unless $app->can_do('edit_templates');

    my $q = $app->param;

    require MT::TemplateMap;
    my $blog_id     = $q->param('blog_id');
    my $template_id = $q->param('template_id');
    my $at          = $q->param('new_archive_type');
    my $exist       = MT::TemplateMap->exist(
        {   blog_id      => $blog_id,
            archive_type => $at
        }
    );

    $app->model('template')
        ->load( { id => $template_id, blog_id => $blog_id } )
        or
        return $app->errtrans( 'Cannot load template #[_1].', $template_id );

    my $map = MT::TemplateMap->new;
    $map->is_preferred( $exist ? 0 : 1 );
    $map->template_id($template_id);
    $map->blog_id($blog_id);
    $map->archive_type($at);
    $map->save
        or return $app->error(
        $app->translate( "Saving map failed: [_1]", $map->errstr ) );

    my $blog = MT->model('blog')->load($blog_id);
    $blog->flush_has_archive_type_cache();

    my $html = _generate_map_table( $app, $blog_id, $template_id );
    $app->{no_print_body} = 1;
    $app->send_http_header("text/plain");
    $app->print_encode($html);
}

sub can_view {
    my ( $eh, $app, $id, $objp ) = @_;
    return 1 if $app->user->can_edit_templates;
    return 0 unless $app->blog;
    if ($id) {
        my $obj = $objp->force();
        return 0
            unless $app->user->permissions( $obj->blog_id )
                ->can_do('edit_templates');
    }
    else {
        my $perms = $app->permissions;
        return 0
            unless $perms->can_do('edit_templates');
    }
    return 1;
}

sub can_save {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();

    if ( $obj && !ref $obj ) {
        $obj = MT->model('template')->load($obj);
    }
    my $blog_id = $obj ? $obj->blog_id : ( $app->blog ? $app->blog->id : 0 );

    return $author->permissions($blog_id)->can_edit_templates;
}

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();

    my $blog_id = $obj->blog_id;

    return $author->permissions($blog_id)->can_edit_templates;
}

sub pre_save {
    my $eh = shift;
    my ( $app, $obj ) = @_;

    ## Strip linefeed characters.
    ( my $text = $obj->column('text') ) =~ tr/\r//d;

    if ( $text =~ m/<(MT|_)_trans/i ) {
        $text = $app->translate_templatized($text);
    }

    $obj->text($text);

    my $perms = $app->blog ? $app->permissions : $app->user->permissions;

    # update text heights if necessary
    if ($perms) {
        my $prefs = $perms->template_prefs || '';
        my $text_height = $app->param('text_height');
        if ( defined $text_height ) {
            my ($pref_text_height) = $prefs =~ m/\btext:(\d+)\b/;
            $pref_text_height ||= 0;
            if ( $text_height != $pref_text_height ) {
                if ( $prefs =~ m/\btext\b/ ) {
                    $prefs =~ s/\btext(:\d+)\b/text:$text_height/;
                }
                else {
                    $prefs = 'text:' . $text_height . ',' . $prefs;
                }
            }
        }

        if ( $prefs ne ( $perms->template_prefs || '' ) ) {
            $perms->template_prefs($prefs);
            $perms->save;
        }
    }

    # module caching
    $obj->include_with_ssi( $app->param('include_with_ssi') ? 1 : 0 );
    $obj->cache_path( $app->param('cache_path') );
    my $cache_expire_type
        = defined $app->param('cache_expire_type')
        ? $app->param('cache_expire_type')
        : '0';
    $obj->cache_expire_type($cache_expire_type);
    my $period   = $app->param('cache_expire_period');
    my $interval = $app->param('cache_expire_interval');
    my $sec      = _get_interval( $period, $interval );
    $obj->cache_expire_interval($sec) if defined $sec;
    my $q = $app->param;
    my @events;

    foreach my $name ( $q->param('cache_expire_event') ) {
        push @events, $name;
    }
    $obj->cache_expire_event( join ',', @events ) if $#events >= 0;
    if ( $cache_expire_type == 1 ) {
        return $eh->error(
            $app->translate(
                "You should not be able to enter zero (0) as the time.")
        ) if $interval == 0;
    }
    elsif ( $cache_expire_type == 2 ) {
        return $eh->error(
            $app->translate("You must select at least one event checkbox.") )
            if !@events;
    }

    require MT::PublishOption;
    my $build_type = $app->param('build_type');

    if ( $build_type == MT::PublishOption::SCHEDULED() ) {
        my $period   = $app->param('schedule_period');
        my $interval = $app->param('schedule_interval');
        my $sec      = _get_interval( $period, $interval );
        $obj->build_interval($sec);
    }
    my $rebuild_me = 1;
    if (   $build_type == MT::PublishOption::DISABLED()
        || $build_type == MT::PublishOption::MANUALLY() )
    {
        $rebuild_me = 0;
    }
    $obj->rebuild_me($rebuild_me);
    1;
}

sub post_save {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;

    my $sess_obj = $app->autosave_session_obj;
    $sess_obj->remove if $sess_obj;

    my $dynamic = 0;
    my $q       = $app->param;
    my $type    = $q->param('type');

    # FIXME: enumeration of types
    if (   $type eq 'custom'
        || $type eq 'index'
        || $type eq 'widget'
        || $type eq 'widgetset' )
    {
        $dynamic = $obj->build_dynamic;
    }
    else {

        # archive template specific post_save tasks
        require MT::TemplateMap;
        my @p = $q->param;
        my %static_maps;
        for my $p (@p) {
            my $map;
            if ( $p =~ /^archive_tmpl_preferred_([\w-]+)_(\d+)$/ ) {
                my $at     = $1;
                my $map_id = $2;
                $map = MT::TemplateMap->load($map_id)
                    or next;
                $map->prefer( $q->param($p) ); # prefer method saves in itself
            }
            elsif ( $p =~ /^archive_file_tmpl_(\d+)$/ ) {
                my $map_id = $1;
                $map = MT::TemplateMap->load($map_id)
                    or next;
                my $file_template = $q->param($p);
                my $build_type_1  = $q->param("map_build_type_$map_id");

                # Populate maps whose build type is dynamic
                # and file template are changed
                $static_maps{ $map->id } = 1
                    if ( ( $file_template ne $map->file_template )
                    && ( MT::PublishOption::DYNAMIC() eq $build_type_1 ) );
                $map->file_template($file_template);
                $map->save;
            }
            elsif ( $p =~ /^map_build_type_(\d+)$/ ) {
                my $map_id = $1;
                $map = MT::TemplateMap->load($map_id)
                    or next;
                my $build_type = $q->param($p);
                require MT::PublishOption;

                # Populate maps that are changed from static to dynamic
                # This should capture new map as well
                $static_maps{ $map->id } = 1
                    if ( ( $build_type ne $map->build_type )
                    && ( MT::PublishOption::DYNAMIC() eq $build_type ) );
                $map->build_type($build_type);
                if ( $build_type == MT::PublishOption::SCHEDULED() ) {
                    my $period
                        = $q->param( 'map_schedule_period_' . $map_id );
                    my $interval
                        = $q->param( 'map_schedule_interval_' . $map_id );
                    my $sec = _get_interval( $period, $interval );
                    $map->build_interval($sec);
                }
                $map->save;
            }
            if (  !$dynamic
                && $map
                && $map->build_type == MT::PublishOption::DYNAMIC() )
            {
                $dynamic = 1;
            }
        }
        $app->{static_dynamic_maps}
            = %static_maps ? [ keys %static_maps ] : 0;
    }

    if ( !$original->id ) {
        $app->log(
            {   message => $app->translate(
                    "Template '[_1]' (ID:[_2]) created by '[_3]'",
                    $obj->name, $obj->id, $app->user->name
                ),
                level    => MT::Log::INFO(),
                class    => 'template',
                category => 'new',
            }
        );
    }

    if ($dynamic) {
        if ( $obj->type eq 'index' ) {
            $app->rebuild_indexes(
                BlogID   => $obj->blog_id,
                Template => $obj,
                NoStatic => 1,
            ) or return $app->publish_error();    # XXXX
        }
        if ( my $blog = $app->blog ) {
            require MT::CMS::Blog;
            my ( $path, $url );
            if ( $obj->type eq 'index' ) {
                $path = $blog->site_path;
                $url  = $blog->site_url;
            }
            else {

                # must be archive since other types can't be dynamic
                if ( $path = $blog->archive_path ) {
                    $url = $blog->archive_url;
                }
                else {
                    $path = $blog->site_path;
                    $url  = $blog->site_url;
                }
            }

            # specific arguments so not to overwrite mtview and htaccess
            MT::CMS::Blog::prepare_dynamic_publishing( $eh, $blog, undef,
                undef, $path, $url );
        }
    }
    1;
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {   message => $app->translate(
                "Template '[_1]' (ID:[_2]) deleted by '[_3]'",
                $obj->name, $obj->id, $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'template',
            category => 'delete'
        }
    );
}

sub build_template_table {
    my $app = shift;
    my (%args) = @_;

    my $perms     = $app->permissions;
    my $list_pref = $app->list_pref('template');
    my $limit     = $args{limit};
    my $param     = $args{param} || {};
    my $iter;
    if ( $args{load_args} ) {
        my $class = $app->model('template');
        $iter = $class->load_iter( @{ $args{load_args} } );
    }
    elsif ( $args{iter} ) {
        $iter = $args{iter};
    }
    elsif ( $args{items} ) {
        $iter = sub { pop @{ $args{items} } };
        $limit = scalar @{ $args{items} };
    }
    return [] unless $iter;

    my @data;
    my $i;
    my %blogs;
    while ( my $tmpl = $iter->() ) {
        my $blog = $blogs{ $tmpl->blog_id }
            ||= MT::Blog->load( $tmpl->blog_id )
            if $tmpl->blog_id;

        my $row = $tmpl->get_values;
        $row->{name} = '' if !defined $row->{name};
        $row->{name} =~ s/^\s+|\s+$//g;
        $row->{name} = "(" . $app->translate("No Name") . ")"
            if $row->{name} eq '';
        my $published_url = $tmpl->published_url;
        $row->{published_url} = $published_url if $published_url;
        $row->{use_cache}
            = (    $blog
                && $blog->include_cache
                && ( $tmpl->cache_expire_type || 0 ) != 0 ) ? 1 : 0;
        $row->{use_ssi}
            = ( $blog && $blog->include_system && $tmpl->include_with_ssi )
            ? 1
            : 0;

        # FIXME: enumeration of types
        $row->{can_delete} = 1
            if $tmpl->type
                =~ m/(custom|index|archive|page|individual|category|widget)/;
        if ($blog) {
            $row->{weblog_name} = $blog->name;
        }
        elsif ( $tmpl->blog_id ) {
            $row->{weblog_name} = '* ' . $app->translate('Orphaned') . ' *';
        }
        else {
            $row->{weblog_name}
                = '* ' . $app->translate('Global Templates') . ' *';
        }
        $row->{object} = $tmpl;
        push @data, $row;
        last if defined($limit) && ( @data > $limit );
    }
    return [] unless @data;

    $param->{template_table}[0]              = {%$list_pref};
    $param->{template_table}[0]{object_loop} = \@data;
    $param->{template_table}[0]{object_type} = 'template';
    $app->load_list_actions( 'template', $param );
    $param->{object_loop} = \@data;
    \@data;
}

sub dialog_publishing_profile {
    my $app = shift;
    $app->validate_magic or return;

    my $blog = $app->blog;
    $app->assert($blog) or return;

    # permission check
    my $perms = $app->blog ? $app->permissions : $app->user->permissions;
    return $app->permission_denied()
        unless $app->user->is_superuser
            || $perms->can_administer_blog
            || $perms->can_edit_templates;

    my $param = {};
    $param->{dynamicity}  = $blog->custom_dynamic_templates || 'none';
    $param->{screen_id}   = "publishing-profile-dialog";
    $param->{return_args} = $app->param('return_args');

    $app->build_page( 'dialog/publishing_profile.tmpl', $param );
}

sub dialog_refresh_templates {
    my $app = shift;
    $app->validate_magic or return;

    # permission check
    my $perms = $app->blog ? $app->permissions : $app->user->permissions;
    return $app->permission_denied()
        unless $app->user->is_superuser()
            || $app->user->can_edit_templates()
            || ($perms
                && (   $perms->can_edit_templates()
                    || $perms->can_administer_blog()
                    || $perms->can_do('refresh_templates') )
            );

    my $param = {};
    if ( my $blog = $app->blog ) {
        if ( my $theme = $blog->theme ) {
            $param->{current_label} = $theme->label;
        }
        else {
            my $set = $blog->template_set;
            my $tmpl_set = MT->registry( 'template_sets', $set );
            if ($tmpl_set) {
                $param->{current_label} = $tmpl_set->{label};
            }
            else {
                $param->{template_set_not_found} = 1;
            }
        }
    }
    $param->{return_args} = $app->param('return_args');
    $param->{screen_id}   = "refresh-templates-dialog";

    # load template sets
    $app->build_page( 'dialog/refresh_templates.tmpl', $param );
}

sub refresh_all_templates {
    my ($app) = @_;
    $app->validate_magic or return;

    my $backup = 0;
    if ( $app->param('backup') ) {

        # refresh templates dialog uses a 'backup' field
        $backup = 1;
    }
    my $template_set;
    my $refresh_type = $app->param('refresh_type') || 'refresh';
    my $t = time;

    my @id;
    if ( $app->param('blog_id') ) {
        if ( 'refresh_blog_templates' eq $app->param('plugin_action_selector')
            )
        {
            ## called from website wide blog listing screen.
            @id = $app->param('id');
        }
        else {
            ## called from template listing screen of each website/blog.
            @id = ( scalar $app->param('blog_id') );
        }
    }
    else {
        ## if no blog_id, called from system-wide listing screen
        @id = $app->param('id');
        if ( !@id ) {

            # refresh global templates
            @id = (0);
        }
    }

    require MT::Template;
    require MT::DefaultTemplates;
    require MT::Blog;
    require MT::Permission;
    require MT::Util;

    my $user = $app->user;
    my @blogs_not_refreshed;
    my $refreshed;
    my $can_refresh_system = (
               $user->is_superuser()
            or $user->permissions(0)->can_do('refresh_templates')
    ) ? 1 : 0;
    my $default_language = MT->config->DefaultLanguage;
BLOG: for my $blog_id (@id) {
        my $blog;
        if ($blog_id) {
            $blog = MT::Blog->load($blog_id);
            next BLOG unless $blog;
        }
        my $tmpl_lang;
        $tmpl_lang = $blog->language if $blog_id;
        $tmpl_lang ||= $default_language;

        if ( !$can_refresh_system )
        {    # system refreshers can refresh all blogs
            my $perms = MT::Permission->load(
                { blog_id => $blog_id, author_id => $user->id } );
            my $can_refresh_blog
                = !$perms                             ? 0
                : $perms->can_edit_templates()        ? 1
                : $perms->can_administer_blog()       ? 1
                : $perms->can_do('refresh_templates') ? 1
                :                                       0;
            if ( !$can_refresh_blog ) {
                push @blogs_not_refreshed, $blog->id;
                next BLOG;
            }
        }

        my $tmpl_list;

        if ( $refresh_type eq 'clean' ) {

            # the user wants to back up all templates and
            # install the new ones

            my @ts = MT::Util::offset_time_list( $t, $blog_id );
            my $ts = sprintf "%04d-%02d-%02d %02d:%02d:%02d",
                $ts[5] + 1900, $ts[4] + 1, @ts[ 3, 2, 1, 0 ];

            # Backup/delete all the existing templates.
            my $tmpl_iter = MT::Template->load_iter(
                {   blog_id => $blog_id,
                    type    => { not => 'backup' },
                }
            );
            my @removed_tids;
            while ( my $tmpl = $tmpl_iter->() ) {
                push @removed_tids, $tmpl->id;
                if ($backup) {

                    # zap all template maps
                    require MT::TemplateMap;
                    MT::TemplateMap->remove( { template_id => $tmpl->id, } );
                    $tmpl->name( $tmpl->name
                            . ' (Backup from '
                            . $ts . ') '
                            . $tmpl->type );
                    $tmpl->type('backup');
                    $tmpl->identifier(undef);
                    $tmpl->rebuild_me(0);
                    $tmpl->linked_file(undef);
                    $tmpl->outfile('');
                    $tmpl->save;
                }
                else {
                    $tmpl->remove;
                }
            }
            if (@removed_tids) {
                $app->model('fileinfo')
                    ->remove( { template_id => \@removed_tids } );
            }

            if ($blog_id) {

                # Create the default templates and mappings for the selected
                # set here, instead of below.
                if ( my $theme = $blog->theme ) {
                    $theme->apply( $blog,
                        importer_filter => { template_set => 1, } );
                }
                else {
                    $blog->create_default_templates( $blog->template_set
                            || 'mt_blog' );
                    $app->run_callbacks( 'blog_template_set_change',
                        { blog => $blog } );
                }
                next BLOG;
            }
        }

        # Load default templates for the given template set, if any.
        my $current_lang = MT->current_language;
        MT->set_language($tmpl_lang);
        if ($blog_id) {
            if ( my $theme = $blog->theme ) {
                my @elements = $theme->elements;
                my ($set)
                    = grep { $_->{importer} eq 'template_set' } @elements;
                $set = $set->{data};
                $set->{envelope} = $theme->path;
                $theme->__deep_localize_labels($set);
                $tmpl_list = MT::DefaultTemplates->templates($set);
            }
            else {
                $tmpl_list
                    = MT::DefaultTemplates->templates( $blog->template_set );
            }
        }
        $tmpl_list ||= MT::DefaultTemplates->templates();
        MT->set_language($current_lang);

        my $current_component = MT->app->{component};

    TEMPLATE: for my $val (@$tmpl_list) {
            if ($blog_id) {

                # when refreshing blog templates,
                # skip over global templates which
                # specify a blog_id of 0...
                next TEMPLATE if $val->{global};
            }
            else {
                next TEMPLATE unless exists $val->{global};
            }

            if ( !$val->{orig_name} ) {
                $val->{orig_name} = $val->{name};
                my $current_lang = MT->current_language;
                MT->set_language($tmpl_lang);
                MT->app->{component} = $blog->theme->id
                    if $blog && $blog->theme;
                $val->{text} = $app->translate_templatized( $val->{text} );
                MT->set_language($current_lang);
                MT->app->{component} = $current_component;
            }

            my $orig_name = $val->{orig_name};

            my @ts = MT::Util::offset_time_list( $t,
                ( $blog_id ? $blog_id : undef ) );
            my $ts = sprintf "%04d-%02d-%02d %02d:%02d:%02d", $ts[5] + 1900,
                $ts[4] + 1, @ts[ 3, 2, 1, 0 ];

            my $terms = {};
            $terms->{blog_id} = $blog_id;

            # FIXME Enumeration of types
            $terms->{type} = $val->{type};
            if ( $val->{type}
                =~ m/^(archive|individual|page|category|index|custom|widget|widgetset)$/
                )
            {
                $terms->{name} = $val->{name};
            }
            else {
                $terms->{identifier} = $val->{identifier};
            }

            # this should only return 1 template; we're searching
            # within a given blog for a specific type of template (for
            # "system" templates; or for a type + name, which should be
            # unique for that blog.
            my $tmpl = MT::Template->load($terms);
            if ( $tmpl && $backup ) {

                # check for default template text...
                # if it is a default template, then outright replace it
                my $text = $tmpl->text;
                $text =~ s/\s+//g;

                my $def_text = $val->{text};
                $def_text =~ s/\s+//g;

                # if it has been customized, back it up to a new tmpl record
                if ( $def_text ne $text ) {
                    my $backup = $tmpl->clone;
                    delete $backup->{column_values}
                        ->{id};    # make sure we don't overwrite original
                    delete $backup->{changed_cols}->{id};
                    $backup->name( $backup->name
                            . $app->translate( ' (Backup from [_1])', $ts ) );
                    $backup->type('backup');

       # if ( $backup->type !~
       #         m/^(archive|individual|page|category|index|custom|widget)$/ )
       # {
       #     $backup->type('custom')
       #       ;      # system templates can't be created
       # }
                    $backup->outfile('');
                    $backup->linked_file( $tmpl->linked_file );
                    $backup->identifier(undef);
                    $backup->rebuild_me(0);
                    $backup->build_dynamic(0);
                    $backup->save;
                }
            }
            if ($tmpl) {

                # we found that the previous template had not been
                # altered, so replace it with new default template...
                if (   ( 'widgetset' eq $val->{type} )
                    && ( exists $val->{widgets} ) )
                {
                    my $modulesets = delete $val->{widgets};
                    $tmpl->modulesets(
                        MT::Template->widgets_to_modulesets(
                            $modulesets, $blog_id
                        )
                    );
                }
                $tmpl->text( $val->{text} );
                $tmpl->identifier( $val->{identifier} );
                $tmpl->type( $val->{type} )
                    ; # fixes mismatch of types for cases like "archive" => "individual"
                $tmpl->build_type( $val->{build_type} )
                    if defined $val->{build_type};
                $tmpl->linked_file('');
                $tmpl->save;
            }
            else {

                # create this one...
                my $tmpl = new MT::Template;
                if (   ( 'widgetset' eq $val->{type} )
                    && ( exists $val->{widgets} ) )
                {
                    my $modulesets = delete $val->{widgets};
                    $tmpl->modulesets(
                        MT::Template->widgets_to_modulesets(
                            $modulesets, $blog_id
                        )
                    );
                }
                $tmpl->build_dynamic(0);
                $tmpl->set_values(
                    {   text       => $val->{text},
                        name       => $val->{name},
                        type       => $val->{type},
                        identifier => $val->{identifier},
                        outfile    => $val->{outfile},
                        rebuild_me => $val->{rebuild_me},
                        build_type => (
                            defined( $val->{build_type} )
                            ? $val->{build_type}
                            : 1
                        ),
                    }
                );
                $tmpl->blog_id($blog_id);
                $tmpl->save
                    or return $app->error(
                          $app->translate("Error creating new template: ")
                        . $tmpl->errstr );

                # Create template map
                if (   $tmpl->type eq 'archive'
                    || $tmpl->type eq 'page'
                    || $tmpl->type eq 'individual' )
                {
                    my $mappings = $val->{mappings};
                    foreach my $map_key ( keys %$mappings ) {
                        my $m  = $mappings->{$map_key};
                        my $at = $m->{archive_type};

                        require MT::TemplateMap;
                        my $map = MT::TemplateMap->new;
                        $map->archive_type($at);
                        if ( exists $m->{preferred} ) {
                            $map->is_preferred( $m->{preferred} );
                        }
                        else {
                            $map->is_preferred(1);
                        }
                        $map->template_id( $tmpl->id );
                        $map->blog_id( $tmpl->blog_id );
                        $map->build_type( $m->{build_type} )
                            if defined $m->{build_type};
                        $map->save
                            or return $app->error(
                            $app->translate(
                                "Setting up mappings failed: [_1]",
                                $map->errstr
                            )
                            );
                    }
                }
            }
        }
        $refreshed = 1;
    }
    if (@blogs_not_refreshed) {
        $app->add_return_arg( 'not_refreshed' => 1 );
        $app->add_return_arg(
            'error_id' => join( ',', @blogs_not_refreshed ) );
    }
    $app->add_return_arg( 'refreshed' => 1 ) if $refreshed;
    $app->call_return;
}

sub refresh_individual_templates {
    my ($app) = @_;

    require MT::Util;

    my $user = $app->user;
    my $perms = $app->blog ? $app->permissions : $app->user->permissions;
    return $app->permission_denied()

        #TODO: system level-designer permission
        unless $user->is_superuser()
            || $user->can_edit_templates()
            || ($perms
                && (   $perms->can_edit_templates()
                    || $perms->can_administer_blog )
            );

    my $set;
    my $blog_id = $app->param('blog_id');
    my $blog    = $app->blog;

    # force saving the revision when indiv. templates are refreshed.
    $app->param( 'save_revision', 1 );
    $app->param( 'revision-note', $app->translate('Template Referesh') );

    require MT::DefaultTemplates;
    my $tmpl_list;
    my $user_lang = MT->current_language;
    $app->set_language(
        $blog ? $blog->language : MT->config->DefaultLanguage );
    if ($blog_id) {
        if ( my $theme = $blog->theme ) {
            my @elements = $theme->elements;
            my ($set) = grep { $_->{importer} eq 'template_set' } @elements;
            $set = $set->{data};
            $set->{envelope} = $theme->path;
            $theme->__deep_localize_labels($set);
            $tmpl_list = MT::DefaultTemplates->templates($set);
        }
        else {
            $tmpl_list = MT::DefaultTemplates->templates( $blog->template_set
                    || 'mt_blog' );
        }
    }
    $tmpl_list ||= MT::DefaultTemplates->templates();

    my $tmpl_types        = {};
    my $tmpl_ids          = {};
    my $tmpls             = {};
    my $current_component = MT->app->{component};

    foreach my $tmpl (@$tmpl_list) {
        MT->app->{component} = $blog->theme->id if $blog && $blog->theme;
        $tmpl->{text} = $app->translate_templatized( $tmpl->{text} )
            if ( $tmpl->{type} !~ m/^widgetset$/ );
        MT->app->{component} = $current_component;
        $tmpl_ids->{ $tmpl->{identifier} } = $tmpl
            if $tmpl->{identifier};
        if ( $tmpl->{type}
            !~ m/^(archive|individual|page|category|index|custom|widget)$/ )
        {
            $tmpl_types->{ $tmpl->{type} } = $tmpl;
        }
        else {
            $tmpls->{ $tmpl->{type} }{ $tmpl->{name} } = $tmpl;
        }
    }
    $app->set_language($user_lang);

    my $t = time;

    my @msg;
    my @id = $app->param('id');
    require MT::Template;
    foreach my $tmpl_id (@id) {
        my $tmpl = MT::Template->load($tmpl_id);
        next unless $tmpl;
        my $blog_id = $tmpl->blog_id;

        # FIXME: permission check -- for this blog_id

        my @ts = MT::Util::offset_time_list( $t, $blog_id );
        my $ts = sprintf "%04d-%02d-%02d %02d:%02d:%02d", $ts[5] + 1900,
            $ts[4] + 1, @ts[ 3, 2, 1, 0 ];

        my $val
            = (
            $tmpl->identifier ? $tmpl_ids->{ $tmpl->identifier() } : undef )
            || $tmpl_types->{ $tmpl->type() }
            || $tmpls->{ $tmpl->type() }{ $tmpl->name };
        if ( !$val ) {
            push @msg,
                $app->translate(
                "Skipping template '[_1]' since it appears to be a custom template.",
                $tmpl->name
                );
            next;
        }

        my $text = $tmpl->text;
        $text =~ s/\s+//g;

        my $def_text = $val->{text};
        $def_text =~ s/\s+//g;

        if ( $text ne $def_text ) {

            # if it has been customized, back it up to a new tmpl record
            my $backup   = $tmpl->clone;
            my $orig_obj = $tmpl->clone;
            delete $backup->{column_values}
                ->{id};    # make sure we don't overwrite original
            delete $backup->{changed_cols}->{id};
            $backup->name( $backup->name . ' (Backup from ' . $ts . ')' );
            $backup->type('backup');
            $backup->outfile('');
            $backup->linked_file( $tmpl->linked_file );
            $backup->rebuild_me(0);
            $backup->build_dynamic(0);
            $backup->identifier(undef);
            $backup->save;
            push @msg,
                $app->translate(
                'Refreshing template <strong>[_3]</strong> with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>',
                $blog_id, $backup->id, $tmpl->name );

            # we found that the previous template had not been
            # altered, so replace it with new default template...
            $tmpl->text( $val->{text} );
            $tmpl->identifier( $val->{identifier} );
            $tmpl->linked_file('');
            $app->run_callbacks( 'cms_pre_save.template',
                $app, $tmpl, $orig_obj )
                || return $app->error(
                $app->translate(
                    "Saving [_1] failed: [_2]", $tmpl->class_label,
                    $app->errstr
                )
                );
            $tmpl->save;
            $app->run_callbacks( 'cms_post_save.template',
                $app, $tmpl, $orig_obj );
        }
        else {
            push @msg,
                $app->translate(
                "Skipping template '[_1]' since it has not been changed.",
                $tmpl->name );
        }
    }
    my @msg_loop;
    push @msg_loop, { message => $_ } foreach @msg;

    $app->mode('view');    # set mode for blog selector
    $app->build_page( 'refresh_results.tmpl',
        { message_loop => \@msg_loop, return_url => $app->return_uri } );
}

sub clone_templates {
    my ($app) = @_;

    my $user = $app->user;
    my $perms = $app->blog ? $app->permissions : $app->user->permissions;
    return $app->permission_denied()

        #TODO: system level-designer permission
        unless $user->is_superuser()
            || $user->can_edit_templates()
            || ($perms
                && (   $perms->can_edit_templates()
                    || $perms->can_administer_blog )
            );

    my @id = $app->param('id');
    require MT::Template;
    foreach my $tmpl_id (@id) {
        my $tmpl = MT::Template->load($tmpl_id);
        next unless $tmpl;

        my $new_tmpl = $tmpl->clone(
            {   Except => {
                    id         => 1,
                    name       => 1,
                    identifier => 1,
                },
            }
        );

        my $new_basename = $app->translate( "Copy of [_1]", $tmpl->name );
        my $new_name     = $new_basename;
        my $i            = 0;
        while (
            MT::Template->exist(
                { name => $new_name, blog_id => $tmpl->blog_id }
            )
            )
        {
            $new_name = $new_basename . ' (' . ++$i . ')';
        }

        $new_tmpl->name($new_name);
        $new_tmpl->save;
    }

    $app->add_return_arg( 'saved_copied' => 1 );
    $app->call_return;
}

sub publish_templates_from_search {
    my $app  = shift;
    my $blog = $app->blog;
    require MT::Blog;

    my $templates
        = MT->model('template')->lookup_multi( [ $app->param('id') ] );
    my @at_ids;
    $app->param( 'from_search', 1 );
TEMPLATE: for my $tmpl (@$templates) {
        return $app->errtrans("Cannot publish a global template.")
            if ( $tmpl->blog_id == 0 );
        if ( $tmpl->type eq 'index' ) {
            $app->param( 'id', $tmpl->id );
            publish_index_templates($app);
        }
        elsif ($tmpl->type eq 'archive'
            || $tmpl->type eq 'individual'
            || $tmpl eq 'page' )
        {
            push( @at_ids, $tmpl->id );
        }
    }

    if ( scalar(@at_ids) > 0 ) {
        $app->param( 'id', @at_ids );
        publish_archive_templates($app) if ( scalar(@at_ids) > 0 );
    }
    else {
        $app->call_return();
    }
}

sub publish_index_templates {
    my $app = shift;
    $app->validate_magic or return;

    # permission check
    my $perms = $app->blog ? $app->permissions : $app->user->permissions;
    return $app->permission_denied()
        unless $app->user->is_superuser
            || $perms->can_administer_blog
            || $perms->can_rebuild;

    my $blog = $app->blog;

    require MT::Blog;
    my $templates
        = MT->model('template')->lookup_multi( [ $app->param('id') ] );
TEMPLATE: for my $tmpl (@$templates) {
        return $app->errtrans("Cannot publish a global template.")
            if ( $tmpl->blog_id == 0 );
        unless ($blog) {
            $blog = MT::Blog->load( $tmpl->blog_id );
        }
        next TEMPLATE if !defined $tmpl;
        next TEMPLATE if $tmpl->blog_id != $blog->id;
        next TEMPLATE unless $tmpl->build_type;

        $app->rebuild_indexes(
            Blog     => $blog,
            Template => $tmpl,
            Force    => 1,
        );
    }

    $app->call_return( published => 1 ) unless ( $app->param('from_search') );
}

sub publish_archive_templates {
    my $app = shift;
    $app->validate_magic or return;

    # permission check
    my $perms = $app->blog ? $app->permissions : $app->user->permissions;
    return $app->permission_denied()
        unless $app->user->is_superuser
            || $perms->can_administer_blog
            || $perms->can_rebuild;

    my @ids = $app->param('id');
    if ( scalar @ids == 1 ) {

        # we also support a list of comma-delimited ids like this
        @ids = split ",", $ids[0];
    }
    return $app->error( $app->translate("Invalid request.") )
        unless @ids;

    my $tmpl_id;
    my %ats;
    require MT::TemplateMap;
    while ( !$tmpl_id && @ids ) {
        $tmpl_id = shift @ids;
        my @tmpl_maps = MT::TemplateMap->load( { template_id => $tmpl_id } );
        foreach my $map (@tmpl_maps) {
            next unless $map->build_type;
            $ats{ $map->archive_type } = 1;
        }
        undef $tmpl_id unless keys %ats;
    }

    # we have a template and archive types to publish!

    require MT::CMS::Blog;
    my $return_args;
    my $reedit = $app->param('reedit');
    if (@ids) {

        # we have more to do after this, so save the list
        # of remaining archive templates...
        $return_args = $app->uri_params(
            mode => 'publish_archive_templates',
            args => {
                magic_token => $app->current_magic,
                blog_id     => scalar $app->param('blog_id'),
                id          => join( ",", @ids ),
                reedit      => $reedit,
                (   $app->param('from_search')
                    ? ( from_search => $app->param('from_search') )
                    : ()
                ),
                (   $app->return_args ? ( return_args => $app->return_args )
                    : ()
                ),
            }
        );
    }
    else {
        if ( $app->param('from_search') ) {
            $return_args = $app->return_args;
        }
        else {
            my $mode = $reedit ? 'view' : 'list_template';
            $return_args = $app->uri_params(
                mode => $mode,
                args => {
                    ( $reedit ? ( _type => 'template' ) : () ),
                    blog_id   => scalar $app->param('blog_id'),
                    published => 1,
                    ( $reedit ? ( saved => 1 )       : () ),
                    ( $reedit ? ( id    => $reedit ) : () ),
                }
            );
        }
    }
    $return_args =~ s/^\?//;

    $app->return_args($return_args);
    return $app->call_return unless %ats;

    $app->param( 'template_id',     $tmpl_id );
    $app->param( 'single_template', 1 );          # forces fullscreen mode
    $app->param( 'type', join( ",", keys %ats ) );
    return MT::CMS::Blog::start_rebuild_pages($app);
}

sub save_widget {
    my $app = shift;
    my $q   = $app->param;

    $app->validate_magic() or return;
    my $author = $app->user;

    my $id = $q->param('id');

    if ( !$author->is_superuser ) {
        $app->run_callbacks( 'cms_save_permission_filter.template',
            $app, $id )
            || return $app->error(
            $app->translate( "Permission denied: [_1]", $app->errstr() ) );
    }

    my $filter_result
        = $app->run_callbacks( 'cms_save_filter.widgetset', $app );

    if ( !$filter_result ) {
        return edit_widget( $app,
            { error => $app->translate( "Save failed: [_1]", $app->errstr ) }
        );
    }

    my $class = $app->model('template');
    my $obj;
    if ($id) {
        $obj = $class->load($id)
            or
            return $app->error( $app->translate( "Invalid ID [_1]", $id ) );
    }
    else {
        $obj = $class->new;
    }

    my $original = $obj->clone();
    $obj->name( $q->param('name') );
    $obj->type('widgetset');
    $obj->blog_id( $q->param('blog_id') || 0 );
    $obj->modulesets( $q->param('modules') );

    unless (
        $app->run_callbacks( 'cms_pre_save.template', $app, $obj, $original )
        )
    {
        return edit_widget( $app,
            { error => $app->translate( "Save failed: [_1]", $app->errstr ) }
        );
    }

    $obj->save
        or return $app->error(
        $app->translate( "Saving object failed: [_1]", $obj->errstr ) );

    $app->run_callbacks( 'cms_post_save.template', $app, $obj, $original )
        or return $app->error( $app->errstr() );

    $app->redirect(
        $app->uri(
            'mode' => 'edit_widget',
            args   => {
                blog_id => $obj->blog_id,
                'saved' => 1,
                rebuild => 1,
                id      => $obj->id
            }
        )
    );
}

sub edit_widget {
    my $app = shift;
    my (%opt) = @_;

    my $q       = $app->param();
    my $id      = scalar( $q->param('id') ) || $opt{id};
    my $name    = scalar( $q->param('name') );
    my $blog_id = scalar $q->param('blog_id') || 0;

    my $tmpl_class = $app->model('template');
    require MT::Promise;
    my $obj_promise = MT::Promise::delay(
        sub {
            return $tmpl_class->load($id) || undef;
        }
    );

    if ( !$app->user->is_superuser ) {
        $app->run_callbacks( 'cms_view_permission_filter.template',
            $app, $id, $obj_promise )
            || return $app->error(
            $app->translate( "Permission denied: [_1]", $app->errstr() ) );
    }

    my $param = {
        blog_id      => $blog_id,
        search_type  => "template",
        search_label => MT::Template->class_label_plural,
        exists( $opt{rebuild} ) ? ( rebuild => $opt{rebuild} ) : (),
        exists( $opt{error} )   ? ( error   => $opt{error} )   : (),
        exists( $opt{saved} )   ? ( saved   => $opt{saved} )   : (),
        $id                     ? ( id      => $id )
        : $name                 ? ( name    => $name )
        : (),
    };
    $param->{saved} = 1
        if $app->param('saved');

    if ($blog_id) {
        my $blog = $app->blog;

        # include_system/include_cache are only applicable
        # to blog-level templates
        $param->{include_system}        = $blog->include_system;
        $param->{include_cache}         = $blog->include_cache;
        $param->{include_with_ssi}      = 0;
        $param->{cache_path}            = '';
        $param->{cache_enabled}         = 0;
        $param->{cache_expire_type}     = 0;
        $param->{cache_expire_period}   = '';
        $param->{cache_expire_interval} = 0;
        $param->{ssi_type}
            = defined $blog->include_system ? uc $blog->include_system : '';
    }

    my $iter
        = $tmpl_class->load_iter(
        { type => 'widget', blog_id => $blog_id ? [ $blog_id, 0 ] : 0 },
        { sort => 'name', direction => 'ascend' } );

    my %all_widgets;
    while ( my $m = $iter->() ) {
        next unless $m;
        $all_widgets{ $m->id }{name}    = $m->name;
        $all_widgets{ $m->id }{blog_id} = $m->blog_id;
    }

    my @inst_modules;
    my $wtmpl;
    if ($id) {
        $wtmpl = $obj_promise->force()
            or return $app->error(
            $app->translate(
                "Load failed: [_1]",
                $tmpl_class->errstr || $app->translate("(no reason given)")
            )
            );
        return $app->return_to_dashboard( redirect => 1 )
            if $wtmpl->blog_id ne $blog_id;
        $param->{name}             = $wtmpl->name;
        $param->{include_with_ssi} = $wtmpl->include_with_ssi
            if defined $wtmpl->include_with_ssi;
        $param->{cache_path} = $wtmpl->cache_path
            if defined $wtmpl->cache_path;
        $param->{cache_expire_type} = $wtmpl->cache_expire_type
            if defined $wtmpl->cache_expire_type;
        my ( $period, $interval )
            = _get_schedule( $wtmpl->cache_expire_interval );
        $param->{cache_expire_period}   = $period   if defined $period;
        $param->{cache_expire_interval} = $interval if defined $interval;
        my @events = split ',', $wtmpl->cache_expire_event || '';

        foreach my $name (@events) {
            $param->{ 'cache_expire_event_' . $name } = 1;
        }
        my $modulesets = $wtmpl->modulesets;
        if ($modulesets) {
            my @modules = split ',', $modulesets;
            foreach my $mid (@modules) {
                push @inst_modules,
                    {
                    id      => $mid,
                    name    => $all_widgets{$mid}{name},
                    blog_id => $all_widgets{$mid}{blog_id},
                    };
                delete $all_widgets{$mid};
            }
        }
    }
    $param->{installed} = \@inst_modules if @inst_modules;
    my @avail_modules = map {
        {   id      => $_,
            name    => $all_widgets{$_}{name},
            blog_id => $all_widgets{$_}{blog_id}
        }
    } keys %all_widgets;
    @avail_modules = sort { $a->{name} cmp $b->{name} } @avail_modules
        if @avail_modules;
    $param->{available} = \@avail_modules;

    my $res = $app->run_callbacks( 'cms_edit.widgetset', $app, $id, $wtmpl,
        $param );
    if ( !$res ) {
        return $app->error( $app->callback_errstr() );
    }

    $app->load_tmpl( 'edit_widget.tmpl', $param );
}

sub list_widget {
    my $app   = shift;
    my (%opt) = @_;
    my $q     = $app->param;

    my $perms = $app->blog ? $app->permissions : $app->user->permissions;
    return $app->return_to_dashboard( redirect => 1 )
        unless $perms || $app->user->is_superuser;
    if ( $perms && !$perms->can_edit_templates ) {
        return $app->permission_denied();
    }
    my $blog_id = $q->param('blog_id') || 0;

    my $widget_loop = &build_template_table(
        $app,
        load_args => [
            { type => 'widget', blog_id => $blog_id ? [ $blog_id, 0 ] : 0 },
            { sort => 'name', direction => 'ascend' }
        ],
    );

    my $iter
        = $app->model('template')
        ->load_iter(
        { type => 'widgetset', blog_id => $blog_id ? $blog_id : 0 },
        { sort => 'name', direction => 'ascend' } );
    my @widgetmanagers;
    while ( my $widgetset = $iter->() ) {
        next unless $widgetset;
        my $ws = {
            id            => $widgetset->id,
            widgetmanager => $widgetset->name,
        };
        if ( my $modulesets = $widgetset->modulesets ) {
            $ws->{widgets} = $modulesets;
            my @names;
            foreach my $module ( split ',', $modulesets ) {
                my ($widget) = grep { $_->{id} eq $module } @$widget_loop;
                push @names, $widget->{name} if $widget;
            }
            $ws->{names} = join( ', ', @names ) if @names;
        }
        push @widgetmanagers, $ws;
    }

    my @widget_loop;
    if ($blog_id) {

        # Remove system level widgets from the listing
        @widget_loop = grep { $_->{blog_id} == $blog_id } @$widget_loop;
    }
    else {
        @widget_loop = @$widget_loop;
    }

    my $param = {
        @widgetmanagers ? ( object_loop  => \@widgetmanagers ) : (),
        @widget_loop    ? ( widget_table => \@widget_loop )    : (),
        object_type         => "template",
        search_type         => "template",
        search_label        => MT::Template->class_label_plural,
        listing_screen      => 1,
        screen_id           => "list-widget-set",
        object_label        => $app->translate('Widget Template'),
        object_label_plural => $app->translate('Widget Templates'),
        template_type_label => $app->translate('Widget Templates'),
        blog_view           => 1,
        exists( $opt{rebuild} ) ? ( rebuild => $opt{rebuild} ) : (),
        exists( $opt{error} )   ? ( error   => $opt{error} )   : (),
        exists( $opt{deleted} ) ? ( saved   => $opt{deleted} ) : ()
    };
    my $widget_actions = {};
    $app->load_list_actions( 'template', $widget_actions );
    $param->{ 'widget_' . $_ } = $widget_actions->{$_}
        for keys %$widget_actions;
    $param->{page_actions} = $app->page_actions('list_widget');
    $app->load_tmpl( 'list_widget.tmpl', $param );
}

sub delete_widget {
    my $app  = shift;
    my $q    = $app->param;
    my $type = $q->param('_type');

    return $app->errtrans("Invalid request.")
        unless $type;

    return $app->error( $app->translate("Invalid request.") )
        if $app->request_method() ne 'POST';

    $app->validate_magic() or return;

    my $tmpl_class = $app->model('template');

    for my $id ( $q->param('id') ) {
        next unless $id;    # avoid 'empty' ids

        my $obj = $tmpl_class->load($id);
        next unless $obj;
        $app->run_callbacks( 'cms_delete_permission_filter.template',
            $app, $obj )
            || return $app->error(
            $app->translate( "Permission denied: [_1]", $app->errstr() ) );

        $obj->remove
            or return $app->errtrans(
            'Removing [_1] failed: [_2]',
            $app->translate('template'),
            $obj->errstr
            );
        $app->run_callbacks( 'cms_post_delete.template', $app, $obj );
    }
    $app->call_return;
}

sub restore_widgetmanagers {
    my ( $cb, $objects, $deferred, $errors, $callback ) = @_;
    my @keys = grep { $_ =~ /^MT::Template#/ } keys(%$objects);
    foreach my $key (@keys) {
        my $tmpl = $objects->{$key};
        next unless 'widgetset' eq $tmpl->type;
        my $modulesets = $tmpl->modulesets;
        next unless $modulesets;
        $callback->(
            MT->translate( 'Restoring widget set [_1]... ', $tmpl->name ) );

        my @tmpl_ids = split ',', $modulesets;
        my @new_ids;
        foreach my $id (@tmpl_ids) {
            my $new_tmpl = $objects->{"MT::Template#$id"};
            next unless $new_tmpl;
            push @new_ids, $new_tmpl->id;
        }
        if (@new_ids) {
            $tmpl->modulesets( join( ',', @new_ids ) );
            $tmpl->save;
            $callback->( MT->translate("Done.") . "\n" );
        }
        else {
            $callback->( MT->translate("Failed.") . "\n" );
        }
    }
    1;
}

{
    my @period_options = (
        {   name => 'minutes',
            expr => 60,
        },
        {   name => 'hours',
            expr => 60 * 60,
        },
        {   name => 'days',
            expr => 24 * 60 * 60,
        },
    );

    sub _get_schedule {
        my ($sec) = @_;
        return unless defined $sec;
        my ( $period, $interval );
        for (@period_options) {
            last if $sec % $_->{expr};
            $period   = $_->{name};
            $interval = $sec / $_->{expr};
        }
        ( $period, $interval );
    }

    sub _get_interval {
        my ( $period, $interval ) = @_;
        return unless defined $period;
        my $sec = 0;
        for (@period_options) {
            if ( $_->{name} eq $period ) {
                $sec = $interval * $_->{expr};
                last;
            }
        }
        $sec;
    }
}

sub save_template_prefs {
    my $app     = shift;
    my $blog_id = $app->param('blog_id');
    my $perms   = $app->user->permissions($blog_id)
        or return $app->error( $app->translate("No permissions") );
    $app->validate_magic() or return;

    my $prefs = $perms->template_prefs || '';
    my $highlight = $app->param('syntax_highlight');
    if ( defined $highlight ) {
        my ($pref_highlight) = $prefs =~ m/\bsyntax:(\w+)\b/;
        $pref_highlight ||= '';
        if ( $highlight ne $pref_highlight ) {
            if ( $prefs =~ m/\bsyntax\b/ ) {
                $prefs =~ s/\bsyntax(:\w+)\b/syntax:$highlight/;
            }
            else {
                $prefs = 'syntax:' . $highlight . ',' . $prefs;
            }
        }
    }
    $perms->template_prefs($prefs);
    $perms->save
        or return $app->error(
        $app->translate( "Saving permissions failed: [_1]", $perms->errstr )
        );
    $app->send_http_header("text/json");
    return "true";
}

1;
