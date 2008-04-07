package MT::CMS::Template;

use strict;

sub edit {
    my $cb = shift;
    my ($app, $id, $obj, $param) = @_;

    my $q = $app->param;
    my $blog_id = $q->param('blog_id');
    my $type = $q->param('_type');
    my $blog = $app->blog;
    my $cfg = $app->config;
    my $perms = $app->permissions;
    my $can_preview = 0;

    if ($blog) {
        # include_system/include_cache are only applicable
        # to blog-level templates
        $param->{include_system} = $blog->include_system;
        $param->{include_cache} = $blog->include_cache;
    }

    if ($id) {
        # FIXME: Template types should not be enumerated here
        $param->{nav_templates} = 1;
        my $tab;
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
        else {
            $tab = 'system';
            $param->{template_group_trans} = $app->translate('system');
        }
        $param->{template_group} = $tab;
        $blog_id = $obj->blog_id;

        # FIXME: enumeration of types
             $param->{has_name} = $obj->type eq 'index'
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
        $param->{has_rebuild} =
          (      ( $obj->type eq 'index' )
              && ( ( $blog->custom_dynamic_templates || "" ) ne 'all' ) );
        $param->{custom_dynamic} =
          $blog && ( $blog->custom_dynamic_templates || "" ) eq 'custom';
        $param->{has_build_options} =
          ( $param->{custom_dynamic} || $param->{has_rebuild} );

        # FIXME: enumeration of types
             $param->{is_special} = $param->{type} ne 'index'
          && $param->{type} ne 'archive'
          && $param->{type} ne 'category'
          && $param->{type} ne 'page'
          && $param->{type} ne 'individual';
             $param->{has_build_options} = $param->{has_build_options}
          && $param->{type} ne 'custom'
          && $param->{type} ne 'widget'
          && !$param->{is_special};
        $param->{rebuild_me} =
          defined $obj->rebuild_me ? $obj->rebuild_me : 1;
        $param->{search_label} = $app->translate('Templates');
        $param->{object_type}  = 'template';
        my $published_url = $obj->published_url;
        $param->{published_url} = $published_url if $published_url;
        $param->{saved_rebuild} = 1 if $q->param('saved_rebuild');

        $app->load_list_actions( 'template', $param );

        $obj->compile;
        if ( $obj->{errors} && @{ $obj->{errors} } ) {
            $param->{error} = $app->translate(
                "One or more errors were found in this template.");
            $param->{error} .= "<ul>\n";
            foreach my $err ( @{ $obj->{errors} } ) {
                $param->{error} .= "<li>"
                  . MT::Util::encode_html( $err->{message} )
                  . "</li>\n";
            }
            $param->{error} .= "</ul>\n";
        }

        # Populate list of included templates
        if ( my $includes = $obj->getElementsByTagName('Include') ) {
            my @includes;
            my @widgets;
            my %seen;
            foreach my $tag (@$includes) {
                my $include = {};
                my $mod = $include->{include_module} = $tag->[1]->{module} || $tag->[1]->{widget};
                next unless $mod;
                my $type = $tag->[1]->{widget} ? 'widget' : 'custom';
                next if exists $seen{$type}{$mod};
                $seen{$type}{$mod} = 1;
                my $other = MT::Template->load(
                    {
                        blog_id => [ $obj->blog_id, 0 ],
                        name    => $mod,
                        type    => $type,
                    }, {
                        sort      => 'blog_id',
                        direction => 'descend',
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
                }
                else {
                    $include->{create_link} = $app->mt_uri(
                        mode => 'view',
                        args => {
                            blog_id => $obj->blog_id,
                            '_type' => 'template',
                            type    => $type,
                            name    => $mod,
                        }
                    );
                }
                if ($type eq 'widget') {
                    push @widgets, $include;
                } else {
                    push @includes, $include;
                }
            }
            $param->{include_loop} = \@includes if @includes;
            $param->{widget_loop} = \@widgets if @widgets;
        }
        my @sets = ( @{ $obj->getElementsByTagName('WidgetSet') || [] }, @{ $obj->getElementsByTagName('WidgetManager') || [] } );
        if ( @sets ) {
            my @widget_sets;
            my %seen;
            foreach my $set (@sets) {
                my $name = $set->[1]->{name};
                next unless $name;
                next if $seen{$name};
                $seen{$name} = 1;
                push @widget_sets, {
                    include_link => $app->mt_uri(
                        mode => 'edit_widget',
                        args => {
                            blog_id => $obj->blog_id,
                            widgetmanager => $name,
                        },
                    ),
                    include_module => $name,
                };
            }
            $param->{widget_set_loop} = \@widget_sets if @widget_sets;
        }
        $param->{have_includes} = 1 if $param->{widget_set_loop} || $param->{include_loop} || $param->{widget_loop};
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
                @archive_types =
                  sort { MT::App::CMS::archive_type_sorter( $a, $b ) } @archive_types;
            }
            $param->{archive_types} = \@archive_types;

            # Populate template maps for this template
            my $maps = _populate_archive_loop( $app, $blog, $obj );
            $param->{object_loop} = $param->{template_map_loop} = $maps
              if @$maps;
        }
        # publish options
        $param->{publish_queue} = $blog->publish_queue if $blog;
        $param->{build_type} = $obj->build_type;
        $param->{ 'build_type_' . ( $obj->build_type || 0 ) } = 1;
        my ( $period, $interval ) = _get_schedule( $obj->build_interval );
        $param->{ 'schedule_period_' . $period } = 1;
        $param->{schedule_interval} = $interval;
        $param->{type} = 'custom' if $param->{type} eq 'module';
    } else {
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
                my ($tmpl) =
                  grep { $_->{identifier} eq $template_id } @$def_tmpl;
                $param->{text} = $app->translate_templatized( $tmpl->{text} )
                  if $tmpl;
                $param->{type} = $template_type;
            }
        }
        else {
            $template_type = $q->param('type');
            $template_type = 'custom' if 'module' eq $template_type;
            $param->{type}   = $template_type;
        }
        return $app->errtrans("Create template requires type")
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
            $tab                         = 'archive';
            $param->{template_group_trans} = $app->translate('archive');
            $param->{type_archive}         = 1;
            my @types = (
                {
                    key   => 'archive',
                    label => $app->translate('Archive')
                },
                {
                    key   => 'individual',
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
             $param->{has_name} = $template_type eq 'index'
          || $template_type eq 'custom'
          || $template_type eq 'widget'
          || $template_type eq 'archive'
          || $template_type eq 'category'
          || $template_type eq 'page'
          || $template_type eq 'individual';
        $param->{has_outfile} = $template_type eq 'index';
        $param->{has_rebuild} =
          (      ( $template_type eq 'index' )
              && ( ( $blog->custom_dynamic_templates || "" ) ne 'all' ) );
        $param->{custom_dynamic} =
          $blog && $blog->custom_dynamic_templates eq 'custom';
        $param->{has_build_options} =
             $blog && ($blog->custom_dynamic_templates eq 'custom'
          || $param->{has_rebuild});

        # FIXME: enumeration of types
             $param->{is_special} = $param->{type} ne 'index'
          && $param->{type} ne 'archive'
          && $param->{type} ne 'category'
          && $param->{type} ne 'page'
          && $param->{type} ne 'individual';
             $param->{has_build_options} = $param->{has_build_options}
          && $param->{type} ne 'custom'
          && $param->{type} ne 'widget'
          && !$param->{is_special};

        $param->{rebuild_me} = 1;
        $param->{name}       = MT::Util::decode_url( $app->param('name') )
          if $app->param('name');
    }
    my $set = $blog ? $blog->template_set : undef;
    require MT::DefaultTemplates;
    my $tmpls = MT::DefaultTemplates->templates($set);
    my @tmpl_ids;
    foreach my $dtmpl (@$tmpls) {
        if ( !$param->{has_name} ) {
            if ($obj->type eq 'email') {
                if ($dtmpl->{identifier} eq $obj->identifier) {
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
        my $pref_param =
          $app->load_template_prefs( $perms->template_prefs );
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
            $tag_list .= ($tag_list eq '' ? '' : ',') . join(",", keys(%$tags));
        }
        $tag_list =~ s/(^|,)plugin(,|$)/,/;
        if (exists $tag_docs->{$url}) {
            $tag_docs->{$url} .= ',' . $tag_list;
        }
        else {
            $tag_docs->{$url} = $tag_list;
        }
    }
    $param->{tag_docs} = $tag_docs;
    $param->{link_doc} = $app->help_url('appendices/tags/');

    $param->{screen_id} = "edit-template-" . $param->{type};
    if (("custom" == $param->{type}) || ("custom" == $param->{type})) {
        $param->{screen_class} .= "edit-template-cache";
    }

    # template language
    $param->{template_lang} = 'html';
    if ( $obj && $obj->outfile ) {
        if ( $obj->outfile =~ m/\.(css|js|html|php|pl|asp)$/ ) {
            $param->{template_lang} = {
                css => 'css',
                js => 'javascript',
                html => 'html',
                php => 'php',
                pl => 'perl',
                asp => 'asp',
            }->{$1};
        }
    }

    if (($param->{type} eq 'custom') || ($param->{type} eq 'widget')) {
        if ($blog) {
            $param->{include_with_ssi}      = 0;
            $param->{cache_enabled}         = 0;
            $param->{cache_expire_type}     = 0;
            $param->{cache_expire_period}   = '';
            $param->{cache_expire_interval} = 0;
            $param->{ssi_type} = uc $blog->include_system;
        }
        if ($obj) {
            $param->{include_with_ssi} = $obj->include_with_ssi
              if defined $obj->include_with_ssi;
            $param->{cache_enabled} = $obj->use_cache
              if defined $obj->use_cache;
            $param->{cache_expire_type} = $obj->cache_expire_type
              if defined $obj->cache_expire_type;
            my ( $period, $interval ) =
              _get_schedule( $obj->cache_expire_interval );
            $param->{cache_expire_period}   = $period   if defined $period;
            $param->{cache_expire_interval} = $interval if defined $interval;
            my @events = split ',', $obj->cache_expire_event;
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
        if (!$param->{is_special}) && (!$obj || ($obj && $obj->outfile !~ m/\.(css|xml|rss|js)$/));

    1;
}

sub list {
    my $app = shift;

    my $perms = $app->blog ? $app->permissions : $app->user->permissions;
    return $app->return_to_dashboard( redirect => 1 )
      unless $perms || $app->user->is_superuser;
    if ( $perms && !$perms->can_edit_templates ) {
        return $app->return_to_dashboard( permission => 1 );
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
        if ( $type =~ m/^(individual|page|category|archive)$/ ) {
            $template_type = 'archive';
            # populate context with templatemap loop
            my $tblog = $obj->blog_id == $blog->id ? $blog : MT::Blog->load( $obj->blog_id );
            if ($tblog) {
                $row->{archive_types} = _populate_archive_loop( $app, $tblog, $obj );
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
        $row->{template_type} = $template_type;
        $row->{type} = 'entry' if $type eq 'individual';
        my $published_url = $obj->published_url;
        $row->{published_url} = $published_url if $published_url;
    };

    my $params        = {};
    my $filter = $app->param('filter_key');
    my $template_type = $filter || '';
    $template_type =~ s/_templates//;

    $params->{screen_class} = "list-template";
    $params->{listing_screen} = 1;

    $app->load_list_actions( 'template', $params );
    $params->{page_actions} = $app->page_actions('list_templates');
    $params->{search_label} = $app->translate("Templates");
    $params->{blog_view} = 1;
    $params->{refreshed} = $app->param('refreshed');
    $params->{published} = $app->param('published');
    $params->{saved_copied} = $app->param('saved_copied');

    # determine list of system template types:
    my $scope;
    my $set;
    if ( $blog ) {
        $set   = $blog->template_set;
        $scope = 'system';
    }
    else {
        $scope = 'global:system';
    }
    my @tmpl_path = ( $set && ($set ne 'mt_blog')) ? ("template_sets", $set, 'templates', $scope) : ("default_templates", $scope);
    my $sys_tmpl = MT->registry(@tmpl_path) || {};

    my @tmpl_loop;
    my %types;
    if ($template_type ne 'backup') {
        if ($blog) {
            # blog template listings
            %types = ( 
                'index' => {
                    label => $app->translate("Index Templates"),
                    type => 'index',
                    order => 100,
                },
                'archive' => {
                    label => $app->translate("Archive Templates"),
                    type => ['archive', 'individual', 'page', 'category'],
                    order => 200,
                },
                'module' => {
                    label => $app->translate("Template Modules"),
                    type => 'custom',
                    order => 300,
                },
                'system' => {
                    label => $app->translate("System Templates"),
                    type => [ keys %$sys_tmpl ],
                    order => 400,
                },
            );
        } else {
            # global template listings
            %types = ( 
                'module' => {
                    label => $app->translate("Template Modules"),
                    type => 'custom',
                    order => 100,
                },
                'email' => {
                    label => $app->translate("Email Templates"),
                    type => 'email',
                    order => 200,
                },
                'system' => {
                    label => $app->translate("System Templates"),
                    type => [ keys %$sys_tmpl ],
                    order => 300,
                },
            );
        }
    } else {
        # global template listings
        %types = ( 
            'backup' => {
                label => $app->translate("Template Backups"),
                type => 'backup',
                order => 100,
            },
        );
    }
    my @types = sort { $types{$a}->{order} <=> $types{$b}->{order} } keys %types;
    if ($template_type) {
        @types = ( $template_type );
    }
    foreach my $tmpl_type (@types) {
        $app->delete_param('filter_key') if $filter;
        if ( $tmpl_type eq 'index' ) {
            $filter = 'index_templates';
            $app->param( 'filter_key', 'index_templates' );
        }
        elsif ( $tmpl_type eq 'archive' ) {
            $filter = 'archive_templates';
            $app->param( 'filter_key', 'archive_templates' );
        }
        $terms->{type} = $types{$tmpl_type}->{type};
        my $tmpl_param = $app->listing(
            {
                type     => 'template',
                terms    => $terms,
                args     => $args,
                no_limit => 1,
                no_html  => 1,
                code     => $hasher,
            }
        );

        my $template_type_label = $types{$tmpl_type}->{label};
        $tmpl_param->{template_type} = $tmpl_type;
        $tmpl_param->{template_type_label} = $template_type_label;
        push @tmpl_loop, $tmpl_param;
    }

    $params->{template_type_loop} = \@tmpl_loop;
    $params->{screen_id} = "list-template";

    return $app->load_tmpl('list_template.tmpl', $params);
}

sub preview {
    my $app         = shift;
    my $q           = $app->param;
    my $blog_id     = $q->param('blog_id');
    my $blog        = $app->blog;
    my $id          = $q->param('id');
    my $tmpl;
    my $user_id = $app->user->id;

    # We can only do previews on blog templates. Have to publish
    # the preview file somewhere!
    return $app->errtrans("Invalid request.") unless $blog;

    require MT::Template;
    if ($id) {
        $tmpl = MT::Template->load( { id => $id, blog_id => $blog_id } )
            or return $app->errtrans( "Invalid request." );
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

    my $type = $tmpl->type;
    my $preview_tmpl = $tmpl;
    my $archive_file;
    my $archive_url;
    my %param;
    my $blog_path = $blog->site_path;
    my $blog_url = $blog->site_url;

    if (($type eq 'custom') || ($type eq 'widget')) {
        # determine 'host' template
        $preview_tmpl = MT::Template->load({ blog_id => $blog_id, identifier => 'main_index' });
        if (!$preview_tmpl) {
            return $app->errtrans("Can't locate host template to preview module/widget.");
        }
        my $req = $app->request;
        # stash this module so that it is selected through a
        # MTInclude tag instead of the one in the database:
        my $tmpl_name = $tmpl->name;
        $tmpl_name =~ s/^Widget: // if $type eq 'widget';
        my $stash_id = 'template_' . $type . '::' . $blog_id . '::' . $tmpl_name;
        $req->stash($stash_id, [ $tmpl, $tmpl->tokens ]);
    } elsif (($type eq 'individual') || ($type eq 'page')) {
        my $ctx = $preview_tmpl->context;
        my $entry_type = $type eq 'individual' ? 'entry' : 'page';
        my $entry_class = $app->model($entry_type);
        my $obj = $entry_class->load({
            blog_id => $blog_id,
            status => MT::Entry::RELEASE()
        }, {
            limit => 1,
            direction => 'descend',
            'sort' => 'authored_on'
        });
        unless ( $obj ) {
            # create a dummy object
            $obj = $entry_class->new;
            $obj->blog_id($blog_id);
            $obj->id(-1);
            $obj->author_id( $app->user->id );
            $obj->authored_on( $blog->current_timestamp );
            $obj->status( MT::Entry::RELEASE() );
            $obj->basename( $preview_basename );
            $obj->title($app->translate("Lorem ipsum"));
            $obj->text(q{Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut diam quam, accumsan eu, aliquam vel, ultrices a, augue. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Fusce hendrerit, lacus eget bibendum sollicitudin, mi tellus interdum neque, sit amet pretium tortor tellus id erat. Duis placerat justo ac erat. Duis posuere, risus eu elementum viverra, nisl lacus sagittis lorem, ac fermentum neque pede vitae arcu. Phasellus arcu elit, placerat eu, luctus posuere, tristique non, augue. In hac habitasse platea dictumst. Nunc non dolor et ipsum mattis malesuada. Praesent porta orci eu ligula. Ut dui augue, dapibus vitae, sodales in, lobortis non, felis. Aliquam feugiat mollis ipsum.});
            $obj->text_more(q{Integer nunc nulla, vulputate sit amet, varius ac, faucibus ac, lectus. Nulla semper bibendum justo. In hac habitasse platea dictumst. Aliquam auctor pretium ante. Etiam porta consectetuer erat. Phasellus consequat, nisi eu suscipit elementum, metus leo malesuada pede, vel scelerisque lorem ligula in augue. Sed aliquet. Donec malesuada metus sit amet sapien. Integer non libero. Morbi egestas, mauris posuere consequat sodales, augue lectus suscipit velit, eu commodo lacus dolor congue justo. Suspendisse justo. Curabitur sagittis, lorem tincidunt elementum rhoncus, odio dolor mattis odio, quis ultrices ligula ipsum ac lacus. Nam et sapien ac lacus ultrices sollicitudin. Vestibulum ut dolor nec dui malesuada imperdiet. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae;

            Quisque pharetra libero quis nibh. Cras lacus orci, commodo et, fringilla non, lobortis non, mauris. Curabitur dui sapien, tristique imperdiet, ultrices vitae, gravida varius, ante. Maecenas ac arcu nec nibh euismod feugiat. Pellentesque sed orci eget enim egestas faucibus. Aenean laoreet leo ornare velit. Nunc fermentum dolor eget massa. Fusce fringilla, tellus in pellentesque sodales, urna mi hendrerit leo, vel adipiscing ligula odio sit amet risus. Cras rhoncus, mi et posuere gravida, purus sem porttitor nisl, auctor laoreet nisl turpis quis ligula. Aliquam in nisi tristique augue egestas lacinia. Aenean ante magna, facilisis a, faucibus at, aliquam laoreet, dui. Ut tellus leo, tristique a, pellentesque ac, bibendum non, ipsum. Curabitur eu neque pretium arcu accumsan tincidunt. Ut ipsum. Quisque congue accumsan elit. Nulla ligula felis, aliquam ultricies, vestibulum vestibulum, semper vel, sapien. Aenean sodales ligula venenatis tellus. Vestibulum leo. Morbi viverra convallis eros.

            Phasellus rhoncus pulvinar enim. Ut gravida ante nec lectus. Nam luctus gravida odio. Morbi vitae lorem vitae justo fermentum porttitor. Suspendisse vestibulum magna at purus. Cras nec sem. Duis id felis. Mauris hendrerit dapibus est. Donec semper. Praesent vehicula interdum velit. Ut sed tellus et diam venenatis pulvinar.});
            $obj->keywords("sample, entry, preview");
            $obj->tags(qw( lorem ipsum sample preview ));
        }
        $ctx->stash('entry', $obj);
        $ctx->{current_archive_type} = $type eq 'individual' ? 'Individual' : 'Page';
        if (($type eq 'individual') && $blog->archive_path) {
            $blog_path = $blog->archive_path;
            $blog_url = $blog->archive_url;
        }
        $archive_file = File::Spec->catfile( $blog_path, $obj->archive_file );
        $archive_url = $obj->archive_url;
    } elsif ($type eq 'archive') {
        # some variety of archive template
    } elsif ($type eq 'index') {
    } else {
        # for now, only index templates can be previewed
        return $app->errtrans("Invalid request.");
    }

    my $orig_file;
    my $path;

    # Default case; works for index templates (other template types should
    # have defined $archive_file by now).
    $archive_file = File::Spec->catfile( $blog_path, $preview_tmpl->outfile )
        unless defined $archive_file;

    ( $orig_file, $path ) = File::Basename::fileparse( $archive_file );

    $archive_url = MT::Util::caturl( $blog_url, $orig_file )
        unless defined $archive_url;

    my $file_ext;
    require File::Basename;
    $file_ext = $archive_file;
    if ($file_ext =~ m/\.[a-z]+$/) {
        $file_ext =~ s!.+\.!.!;
    } else {
        $file_ext = '';
    }
    $archive_file = File::Spec->catfile( $path, $preview_basename . $file_ext );

    my @data;
    $app->run_callbacks( 'cms_pre_preview.template', $app, $preview_tmpl, \@data );

    my $has_hires = eval 'require Time::HiRes; 1' ? 1 : 0;
    my $start_time = $has_hires ? Time::HiRes::time() : time;

    my $ctx = $preview_tmpl->context;
    my $html = $preview_tmpl->output;

    $param{build_time} = $has_hires ? sprintf("%.3f", Time::HiRes::time() - $start_time ) : "~" . ( time - $start_time );

    unless ( defined($html) ) {
        return $app->error( $app->translate( "Publish error: [_1]",
            MT::Util::encode_html( $preview_tmpl->errstr ) ) );
    }

    # If MT is configured to do 'local' previews, convert all
    # the normal blog URLs into the domain used by MT itself (ie,
    # blog is published to www.example.com, which is a different
    # server from where MT runs, mt.example.com; previews therefore
    # should occur locally, so replace all http://www.example.com/
    # with http://mt.example.com/).
    my ($old_url, $new_url);
    if ($app->config('LocalPreviews')) {
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
        $preview_url =~ s! / \Q$orig_file\E ( /? ) $!/$preview_basename$file_ext$1!x;

        # We also have to translate the URL used for the
        # published file to be on the MT app domain.
        if (defined $new_url) {
            $preview_url =~ s!^\Q$old_url\E!$new_url!;
        }

        $param{preview_url}  = $preview_url;

        $fmgr->put_data( $html, $archive_file );

        # we have to make a record of this preview just in case it
        # isn't cleaned up by re-editing, saving or cancelling on
        # by the user.
        require MT::Session;
        my $sess_obj = MT::Session->get_by_key(
            {
                id   => $preview_basename,
                kind => 'TF',                # TF = Temporary File
                name => $archive_file,
            }
        );
        $sess_obj->start(time);
        $sess_obj->save;
    }
    else {
        return $app->error( $app->translate(
            "Unable to create preview file in this location: [_1]", $path ) );
    }

    $param{id} = $id if $id;
    $param{new_object} = $param{id} ? 0 : 1;
    $param{name} = $tmpl->name;
    my $cols = $tmpl->column_names;
    for my $col (@$cols) {
        push @data,
          {
            data_name  => $col,
            data_value => scalar $q->param($col)
          };
    }
    $param{template_loop} = \@data;
    $param{object_type}  = $type;
    return $app->load_tmpl( 'preview_template_strip.tmpl', \%param );
}

sub reset_blog_templates {
    my $app   = shift;
    my $q     = $app->param;
    my $perms = $app->permissions
      or return $app->error( $app->translate("No permissions") );
    return $app->error( $app->translate("Permission denied.") )
      unless $perms->can_edit_templates;
    $app->validate_magic() or return;
    my $blog = MT::Blog->load( $perms->blog_id );
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
        $val->{name} = $app->translate( $val->{name} );
        $val->{text} = $app->translate_templatized( $val->{text} );
        my $tmpl = MT::Template->new;
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
    $tmpl->param( { object_type => 'templatemap' } );
    $tmpl->param( { object_loop => $maps } ) if @$maps;
    my $html = $tmpl->output();

    if ( $html =~ m/<__trans / ) {
        $html = $app->translate_templatized($html);
    }
    $html;
}

sub _populate_archive_loop {
    my $app = shift;
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
        $map->{ 'archive_type_preferred_' . $blog->archive_type_preferred } = 1
          if $blog->archive_type_preferred;
        $map->{file_template} = $map_obj->file_template
          if $map_obj->file_template;

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
                default => ( $_->{default} || 0 )
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
        if (
            1 < MT::TemplateMap->count(
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
    my $perms = $app->{perms}
      or return $app->error( $app->translate("No permissions") );
    my $q  = $app->param;
    my $id = $q->param('id');

    require MT::TemplateMap;
    MT::TemplateMap->remove( { id => $id } );
    my $html =
      _generate_map_table( $app, $q->param('blog_id'),
        $q->param('template_id') );
    $app->{no_print_body} = 1;
    $app->send_http_header("text/plain");
    $app->print($html);
}

sub add_map {
    my $app = shift;
    $app->validate_magic() or return;
    my $perms = $app->{perms}
      or return $app->error( $app->translate("No permissions") );

    my $q = $app->param;

    require MT::TemplateMap;
    my $blog_id = $q->param('blog_id');
    my $at      = $q->param('new_archive_type');
    my $count   = MT::TemplateMap->count(
        {
            blog_id      => $blog_id,
            archive_type => $at
        }
    );
    my $map = MT::TemplateMap->new;
    $map->is_preferred( $count ? 0 : 1 );
    $map->template_id( scalar $q->param('template_id') );
    $map->blog_id($blog_id);
    $map->archive_type($at);
    $map->save
      or return $app->error(
        $app->translate( "Saving map failed: [_1]", $map->errstr ) );
    my $html =
      _generate_map_table( $app, $blog_id, scalar $q->param('template_id') );
    $app->rebuild(
        BlogID      => $blog_id,
        ArchiveType => $at,
        TemplateMap => $map,
        TemplateID  => scalar $q->param('template_id'),
        NoStatic    => 1
    ) or return $app->publish_error();
    $app->{no_print_body} = 1;
    $app->send_http_header("text/plain");
    $app->print($html);
}

sub can_view {
    my ( $eh, $app, $id ) = @_;
    my $perms = $app->permissions;
    return !$id || ($perms && $perms->can_edit_templates) || (!$app->blog && $app->user->can_edit_templates);
}

sub can_save {
    my ( $eh, $app, $id ) = @_;
    my $perms = $app->permissions;
    return ($perms && $perms->can_edit_templates) || (!$perms && $app->user->can_edit_templates);
}

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    return 1 if $app->user->is_superuser();
    my $perms = $app->permissions;
    return ($perms && $perms->can_edit_templates) || (!$perms && $app->user->can_edit_templates);
}

sub pre_save {
    my $eh = shift;
    my ( $app, $obj ) = @_;

    $obj->rebuild_me(0) 
      if $app->param('current_rebuild_me')
      && !$app->param('rebuild_me');
    $obj->build_dynamic(0)
      if $app->param('current_build_dynamic')
      && !$app->param('build_dynamic');

    ## Strip linefeed characters.
    ( my $text = $obj->text ) =~ tr/\r//d;

    if ($text =~ m/<(MT|_)_trans/i) {
        $text = $app->translate_templatized($text);
    }

    $obj->text($text);

    # update text heights if necessary
    if ( my $perms = $app->permissions ) {
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
    $obj->use_cache( $app->param('cache_enabled')           ? 1 : 0 );
    my $cache_expire_type = $app->param('cache_expire_type');
    $obj->cache_expire_type($cache_expire_type);
    my $period   = $app->param('cache_expire_period');
    my $interval = $app->param('cache_expire_interval');
    my $sec      = _get_interval( $period, $interval );
    $obj->cache_expire_interval($sec);
    my $q = $app->param;
    my @events;

    foreach my $name ( $q->param('cache_expire_event') ) {
        push @events, $name;
    }
    $obj->cache_expire_event( join ',', @events );
    if ( $cache_expire_type == 1 ) {
        return $eh->error(
            $app->translate("You should not be able to enter 0 as the time.") )
          if $interval == 0;
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
    $obj->build_dynamic( $build_type == MT::PublishOption::DYNAMIC() ? 1 : 0 );

    1;
}

sub post_save {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;

    my $sess_obj = $app->autosave_session_obj;
    $sess_obj->remove if $sess_obj;

    require MT::TemplateMap;
    my $q = $app->param;
    my @p = $q->param;
    for my $p (@p) {
        if ( $p =~ /^archive_tmpl_preferred_(\w+)_(\d+)$/ ) {
            my $at     = $1;
            my $map_id = $2;
            my $map    = MT::TemplateMap->load($map_id);
            $map->prefer( $q->param($p) );    # prefer method saves in itself
        }
        elsif ( $p =~ /^archive_file_tmpl_(\d+)$/ ) {
            my $map_id = $1;
            my $map    = MT::TemplateMap->load($map_id);
            $map->file_template( $q->param($p) );
            $map->save;
        }
        elsif ( $p =~ /^map_build_type_(\d+)$/ ) {
            my $map_id     = $1;
            my $map        = MT::TemplateMap->load($map_id);
            my $build_type = $q->param($p);
            require MT::PublishOption;
            $map->build_type($build_type);
            if ( $build_type == MT::PublishOption::SCHEDULED() ) {
                my $period   = $q->param( 'map_schedule_period_' . $map_id );
                my $interval = $q->param( 'map_schedule_interval_' . $map_id );
                my $sec      = _get_interval( $period, $interval );
                $map->build_interval($sec);
            }
            $map->save;
        }
    }

    if ( !$original->id ) {
        $app->log(
            {
                message => $app->translate(
                    "Template '[_1]' (ID:[_2]) created by '[_3]'",
                    $obj->name, $obj->id, $app->user->name
                ),
                level    => MT::Log::INFO(),
                class    => 'template',
                category => 'new',
            }
        );
    }

    if ( $obj->build_dynamic ) {
        if ( $obj->type eq 'index' ) {
            $app->rebuild_indexes(
                BlogID   => $obj->blog_id,
                Template => $obj,
                NoStatic => 1,
            ) or return $app->publish_error();    # XXXX
        }
        else {
            $app->rebuild(
                BlogID     => $obj->blog_id,
                TemplateID => $obj->id,
                NoStatic   => 1,
            ) or return $app->publish_error();
        }
    }
    1;
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {
            message => $app->translate(
                "Template '[_1]' (ID:[_2]) deleted by '[_3]'",
                $obj->name, $obj->id, $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
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
        my $blog = $blogs{ $tmpl->blog_id } ||=
          MT::Blog->load( $tmpl->blog_id );
        my $row = $tmpl->column_values;
        $row->{name} = '' if !defined $row->{name};
        $row->{name} =~ s/^\s+|\s+$//g;
        $row->{name} = "(" . $app->translate("No Name") . ")"
          if $row->{name} eq '';
        my $published_url = $tmpl->published_url;
        $row->{published_url} = $published_url if $published_url;

        # FIXME: enumeration of types
        $row->{can_delete} = 1
          if $tmpl->type =~ m/(custom|index|archive|page|individual|category|widget)/;
        if ($blog) {
            $row->{weblog_name} = $blog->name;
        }
        elsif ($tmpl->blog_id) {
            $row->{weblog_name} = '* ' . $app->translate('Orphaned') . ' *';
        }
        else {
            $row->{weblog_name} = '* ' . $app->translate('Global Templates') . ' *';
        }
        $row->{object} = $tmpl;
        push @data, $row;
        last if defined($limit) && (@data > $limit);
    }
    return [] unless @data;

    $param->{template_table}[0]              = {%$list_pref};
    $param->{template_table}[0]{object_loop} = \@data;
    $param->{template_table}[0]{object_type} = 'template';
    $app->load_list_actions( 'template', $param );
    $param->{object_loop} = \@data;
    \@data;
}

sub dialog_refresh_templates {
    my $app = shift;
    $app->validate_magic or return;

    # permission check
    my $perms = $app->permissions;
    return $app->errtrans("Permission denied.")
        unless $app->user->is_superuser ||
            $perms->can_administer_blog ||
            $perms->can_edit_templates;

    my $param = {};
    my $blog = $app->blog;
    $param->{return_args} = $app->param('return_args');

    if ($blog) {
        $param->{blog_id} = $blog->id;

        my $sets = $app->registry("template_sets");
        $sets->{$_}{key} = $_ for keys %$sets;
        $sets = $app->filter_conditional_list([ values %$sets ]);

        no warnings; # some sets may not define an order
        @$sets = sort { $a->{order} <=> $b->{order} } @$sets;
        $param->{'template_set_loop'} = $sets;

        my $existing_set = $blog->template_set || 'mt_blog';
        foreach (@$sets) {
            if ($_->{key} eq $existing_set) {
                $_->{selected} = 1;
            }
        }
        $param->{'template_set_index'} = $#$sets;
        $param->{'template_set_count'} = scalar @$sets;

        $param->{template_sets} = $sets;
        $param->{screen_id} = "refresh-templates-dialog";
    }

    # load template sets
    $app->build_page('dialog/refresh_templates.tmpl',
        $param);
}

sub refresh_all_templates {
    my ($app) = @_;

    my $backup = 0;
    if ($app->param('backup')) {
        # refresh templates dialog uses a 'backup' field
        $backup = 1;
    }

    my $template_set = $app->param('template_set');
    my $refresh_type = $app->param('refresh_type') || 'refresh';

    my $t = time;

    my @id;
    if ($app->param('blog_id')) {
        @id = ( scalar $app->param('blog_id') );
    }
    else {
        @id = $app->param('id');
        if (! @id) {
            # refresh global templates
            @id = ( 0 );
        }
    }

    require MT::Template;
    require MT::DefaultTemplates;
    require MT::Blog;
    require MT::Permission;
    require MT::Util;

    foreach my $blog_id (@id) {
        my $blog;
        if ($blog_id) {
            $blog = MT::Blog->load($blog_id);
            next unless $blog;
        }
        if ( !$app->user->is_superuser() ) {
            my $perms = MT::Permission->load(
                { blog_id => $blog_id, author_id => $app->user->id } );
            if (
                !$perms
                || (   !$perms->can_edit_templates()
                    && !$perms->can_administer_blog() )
              )
            {
                next;
            }
        }

        my $tmpl_list;
        if ($blog_id) {

            if ($refresh_type eq 'clean') {
                # the user wants to back up all templates and
                # install the new ones

                my @ts = MT::Util::offset_time_list( $t, $blog_id );
                my $ts = sprintf "%04d-%02d-%02d %02d:%02d:%02d",
                    $ts[5] + 1900, $ts[4] + 1, @ts[ 3, 2, 1, 0 ];

                my $tmpl_iter = MT::Template->load_iter({
                    blog_id => $blog_id,
                    type => { not => 'backup' },
                });

                while (my $tmpl = $tmpl_iter->()) {
                    if ($backup) {
                        # zap all template maps
                        require MT::TemplateMap;
                        MT::TemplateMap->remove({
                            template_id => $tmpl->id,
                        });
                        $tmpl->type('backup');
                        $tmpl->name(
                            $tmpl->name . ' (Backup from ' . $ts . ')' );
                        $tmpl->identifier(undef);
                        $tmpl->rebuild_me(0);
                        $tmpl->linked_file(undef);
                        $tmpl->outfile('');
                        $tmpl->save;
                    } else {
                        $tmpl->remove;
                    }
                }

                # This also creates our template mappings
                $blog->create_default_templates( $template_set ||
                    $blog->template_set || 'mt_blog' );

                if ($template_set) {
                    $blog->template_set( $template_set );
                    $blog->save;
                    $app->run_callbacks( 'blog_template_set_change', { blog => $blog } );
                }

                next;
            }

            $tmpl_list = MT::DefaultTemplates->templates($template_set || $blog->template_set) || MT::DefaultTemplates->templates();
        }
        else {
            $tmpl_list = MT::DefaultTemplates->templates();
        }

        foreach my $val (@$tmpl_list) {
            if ($blog_id) {
                # when refreshing blog templates,
                # skip over global templates which
                # specify a blog_id of 0...
                next if $val->{global};
            }
            else {
                next unless exists $val->{global};
            }

            if ( !$val->{orig_name} ) {
                $val->{orig_name} = $val->{name};
                $val->{name}      = $app->translate( $val->{name} );
                $val->{text}      = $app->translate_templatized( $val->{text} );
            }

            my $orig_name = $val->{orig_name};

            my @ts = MT::Util::offset_time_list( $t, ( $blog_id ? $blog_id : undef ) );
            my $ts = sprintf "%04d-%02d-%02d %02d:%02d:%02d", $ts[5] + 1900,
              $ts[4] + 1, @ts[ 3, 2, 1, 0 ];

            my $terms = {};
            $terms->{blog_id} = $blog_id;
            $terms->{type} = $val->{type};
            if ( $val->{type} =~
                m/^(archive|individual|page|category|index|custom|widget)$/ )
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
            if ($tmpl && $backup) {

                # check for default template text...
                # if it is a default template, then outright replace it
                my $text = $tmpl->text;
                $text =~ s/\s+//g;

                my $def_text = $val->{text};
                $def_text =~ s/\s+//g;

                # if it has been customized, back it up to a new tmpl record
                if ($def_text ne $text) {
                    my $backup = $tmpl->clone;
                    delete $backup->{column_values}
                      ->{id};    # make sure we don't overwrite original
                    delete $backup->{changed_cols}->{id};
                    $backup->name(
                        $backup->name . $app->translate( ' (Backup from [_1])', $ts ) );
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
                $tmpl->text( $val->{text} );
                $tmpl->identifier( $val->{identifier} );
                $tmpl->type( $val->{type} )
                  ; # fixes mismatch of types for cases like "archive" => "individual"
                $tmpl->linked_file('');
                $tmpl->save;
            }
            else {
                # create this one...
                my $tmpl = new MT::Template;
                $tmpl->build_dynamic(0);
                $tmpl->set_values(
                    {
                        text       => $val->{text},
                        name       => $val->{name},
                        type       => $val->{type},
                        identifier => $val->{identifier},
                        outfile    => $val->{outfile},
                        rebuild_me => $val->{rebuild_me}
                    }
                );
                $tmpl->blog_id($blog_id);
                $tmpl->save
                  or return $app->error(
                        $app->translate("Error creating new template: ")
                      . $tmpl->errstr );
            }
        }
    }

    $app->add_return_arg( 'refreshed' => 1 );
    $app->call_return;
}

sub refresh_individual_templates {
    my ($app) = @_;

    require MT::Util;

    my $user = $app->user;
    my $perms = $app->permissions;
    return $app->error(
        $app->translate(
            "Permission denied.")
      )
      #TODO: system level-designer permission
      unless $user->is_superuser() || $user->can_edit_templates()
      || ( $perms
        && ( $perms->can_edit_templates()
          || $perms->can_administer_blog ) );

    my $set;
    if ( my $blog_id = $app->param('blog_id') ) {
        my $blog = $app->model('blog')->load($blog_id);
        $set = $blog->template_set()
            if $blog;
    }

    require MT::DefaultTemplates;
    my $tmpl_list = MT::DefaultTemplates->templates($set) or return;

    my $trnames    = {};
    my $tmpl_types = {};
    my $tmpl_ids   = {};
    my $tmpls      = {};
    foreach my $tmpl (@$tmpl_list) {
        $tmpl->{text} = $app->translate_templatized( $tmpl->{text} );
        $tmpl_ids->{ $tmpl->{identifier} } = $tmpl
            if $tmpl->{identifier};
        $trnames->{ $app->translate( $tmpl->{name} ) } = $tmpl->{name};
        if ( $tmpl->{type} !~ m/^(archive|individual|page|category|index|custom|widget)$/ )
        {
            $tmpl_types->{ $tmpl->{type} } = $tmpl;
        }
        else {
            $tmpls->{ $tmpl->{type} }{ $tmpl->{name} } = $tmpl;
        }
    }

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

        my $orig_name = $trnames->{ $tmpl->name } || $tmpl->name;
        my $val = ( $tmpl->identifier ? $tmpl_ids->{ $tmpl->identifier() } : undef )
          || $tmpl_types->{ $tmpl->type() }
          || $tmpls->{ $tmpl->type() }{$orig_name};
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

        if ($text ne $def_text) {
            # if it has been customized, back it up to a new tmpl record
            my $backup = $tmpl->clone;
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
            $tmpl->save;
        } else {
            push @msg, $app->translate("Skipping template '[_1]' since it has not been changed.", $tmpl->name);
        }
    }
    my @msg_loop;
    push @msg_loop, { message => $_ } foreach @msg;

    $app->build_page( 'refresh_results.tmpl',
        { message_loop => \@msg_loop, return_url => $app->return_uri } );
}

sub clone_templates {
    my ($app) = @_;

    my $user = $app->user;
    my $perms = $app->permissions;
    return $app->error(
        $app->translate(
            "Permission denied.")
      )
      #TODO: system level-designer permission
      unless $user->is_superuser() || $user->can_edit_templates()
      || ( $perms
        && ( $perms->can_edit_templates()
          || $perms->can_administer_blog ) );

    my @id = $app->param('id');
    require MT::Template;
    foreach my $tmpl_id (@id) {
        my $tmpl = MT::Template->load($tmpl_id);
        next unless $tmpl;

        my $new_tmpl = $tmpl->clone({
            Except => {
                id => 1,
                name => 1,
                identifier => 1,
            },
        });

        my $new_basename = $app->translate("Copy of [_1]", $tmpl->name);
        my $new_name = $new_basename;
        my $i = 0;
        while (MT::Template->count({ name => $new_name, blog_id => $tmpl->blog_id })) {
            $new_name = $new_basename . ' (' . ++$i . ')';
        }

        $new_tmpl->name($new_name);
        $new_tmpl->save;
    }

    $app->add_return_arg( 'saved_copied' => 1 );
    $app->call_return;
}

sub publish_index_templates {
    my $app = shift;
    $app->validate_magic or return;

    # permission check
    my $perms = $app->permissions;
    return $app->errtrans("Permission denied.")
        unless $app->user->is_superuser ||
            $perms->can_administer_blog ||
            $perms->can_rebuild;

    my $blog = $app->blog;
    my $templates = MT->model('template')->lookup_multi([ $app->param('id') ]);
    TEMPLATE: for my $tmpl (@$templates) {
        next TEMPLATE if !defined $tmpl;
        next TEMPLATE if $tmpl->blog_id != $blog->id;
        $app->rebuild_indexes(
            Blog     => $blog,
            Template => $tmpl,
        );
    }

    $app->call_return( published => 1 );
}

sub publish_archive_templates {
    my $app = shift;
    $app->validate_magic or return;

    # permission check
    my $perms = $app->permissions;
    return $app->errtrans("Permission denied.")
      unless $app->user->is_superuser
      || $perms->can_administer_blog
      || $perms->can_rebuild;

    my $blog = $app->blog;
    my $templates =
      MT->model('template')->lookup_multi( [ $app->param('id') ] );
    use MT::TemplateMap;
    TEMPLATE: for my $tmpl (@$templates) {
        next TEMPLATE if !defined $tmpl;
        next TEMPLATE if $tmpl->blog_id != $blog->id;
        my @tmpl_maps = MT::TemplateMap->load( { template_id => $tmpl->id } );
        foreach my $map (@tmpl_maps) {
            $app->rebuild(
                BlogID      => $blog->id,
                ArchiveType => $map->archive_type,
                NoIndexes   => 1,
            );
        }
    }

    $app->call_return( published => 1 );
}

{
    my @period_options = (
        {
            name => 'minutes',
            expr => 60,
        },
        {
            name => 'hours',
            expr => 60 * 60,
        },
        {
            name => 'days',
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

1;
