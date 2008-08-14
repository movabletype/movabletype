package MT::CMS::Entry;

use strict;
use MT::Util qw( format_ts relative_date remove_html encode_html encode_js
    encode_url archive_file_for offset_time_list );
use MT::I18N qw( substr_text const length_text wrap_text encode_text
    break_up_text first_n_text guess_encoding );

sub edit {
    my $cb = shift;
    my ($app, $id, $obj, $param) = @_;

    my $q = $app->param;
    my $type = $q->param('_type');
    my $perms = $app->permissions;
    my $blog_class = $app->model('blog');
    my $blog = $app->blog;
    my $blog_id = $blog->id;
    my $author = $app->user;
    my $class = $app->model($type);

    # to trigger autosave logic in main edit routine
    $param->{autosave_support} = 1;

    if ($id) {
        return $app->error( $app->translate("Invalid parameter") )
          if $obj->class ne $type;

        $param->{nav_entries} = 1;
        $param->{entry_edit}  = 1;
        if ( $type eq 'entry' ) {
            $app->add_breadcrumb(
                $app->translate('Entries'),
                $app->uri(
                    'mode' => 'list_entries',
                    args   => { blog_id => $blog_id }
                )
            );
        }
        elsif ( $type eq 'page' ) {
            $app->add_breadcrumb(
                $app->translate('Pages'),
                $app->uri(
                    'mode' => 'list_pages',
                    args   => { blog_id => $blog_id }
                )
            );
        }
        $app->add_breadcrumb( $obj->title
              || $app->translate('(untitled)') );
        ## Don't pass in author_id, because it will clash with the
        ## author_id parameter of the author currently logged in.
        delete $param->{'author_id'};
        unless ( defined $q->param('category_id') ) {
            delete $param->{'category_id'};
            if ( my $cat = $obj->category ) {
                $param->{category_id} = $cat->id;
            }
        }
        $blog_id = $obj->blog_id;
        my $blog = $app->model('blog')->load($blog_id);
        my $status = $q->param('status') || $obj->status;
        $param->{ "status_" . MT::Entry::status_text($status) } = 1;
        $param->{ "allow_comments_"
              . ( $q->param('allow_comments') || $obj->allow_comments || 0 )
          } = 1;
        $param->{'authored_on_date'} = $q->param('authored_on_date')
          || format_ts( "%Y-%m-%d", $obj->authored_on, $blog, $app->user ? $app->user->preferred_language : undef );
        $param->{'authored_on_time'} = $q->param('authored_on_time')
          || format_ts( "%H:%M:%S", $obj->authored_on, $blog, $app->user ? $app->user->preferred_language : undef );

        $param->{num_comments} = $id ? $obj->comment_count : 0;
        $param->{num_pings} = $id ? $obj->ping_count : 0;

        # Check permission to send notifications and if the
        # blog has notification list subscribers
        if (   $perms->can_send_notifications
            && $obj->status == MT::Entry::RELEASE() )
        {
            my $not_class = $app->model('notification');
            $param->{can_send_notifications} = 1;
            $param->{has_subscribers} =
              $not_class->exist( { blog_id => $blog_id } );
        }

        ## Load next and previous entries for next/previous links
        if ( my $next = $obj->next ) {
            $param->{next_entry_id} = $next->id;
        }
        if ( my $prev = $obj->previous ) {
            $param->{previous_entry_id} = $prev->id;
        }

        $param->{has_any_pinged_urls} = ( $obj->pinged_urls || '' ) =~ m/\S/;
        $param->{ping_errors}         = $q->param('ping_errors');
        $param->{can_view_log}        = $app->user->can_view_log;
        $param->{entry_permalink}     = $obj->permalink;
        $param->{'mode_view_entry'}   = 1;
        $param->{'basename_old'}      = $obj->basename;

        if ( my $ts = $obj->authored_on ) {
            $param->{authored_on_ts} = $ts;
            $param->{authored_on_formatted} =
              format_ts( MT::App::CMS::LISTING_DATETIME_FORMAT(), $ts, $blog, $app->user ? $app->user->preferred_language : undef );
        }

        $app->load_list_actions( $type, $param );
    } else {
        $param->{entry_edit} = 1;
        if ($blog_id) {
            if ( $type eq 'entry' ) {
                $app->add_breadcrumb(
                    $app->translate('Entries'),
                    $app->uri(
                        'mode' => 'list_entries',
                        args   => { blog_id => $blog_id }
                    )
                );
                $app->add_breadcrumb( $app->translate('New Entry') );
                $param->{nav_new_entry} = 1;
            }
            elsif ( $type eq 'page' ) {
                $app->add_breadcrumb(
                    $app->translate('Pages'),
                    $app->uri(
                        'mode' => 'list_pages',
                        args   => { blog_id => $blog_id }
                    )
                );
                $app->add_breadcrumb( $app->translate('New Page') );
                $param->{nav_new_page} = 1;
            }
        }

        # (if there is no blog_id parameter, this is a
        # bookmarklet post and doesn't need breadcrumbs.)
        delete $param->{'author_id'};
        delete $param->{'pinged_urls'};
        my $blog_timezone = 0;
        if ($blog_id) {
            my $blog = $blog_class->load($blog_id)
                or return $app->error($app->translate('Can\'t load blog #[_1].', $blog_id));
            $blog_timezone = $blog->server_offset();

            # new entry defaults used for new entries AND new pages.
            my $def_status = $q->param('status')
              || $blog->status_default;
            if ($def_status) {
                $param->{ "status_"
                      . MT::Entry::status_text($def_status) } = 1;
            }
            if ( $param->{status} ) {
                $param->{ 'allow_comments_'
                      . $q->param('allow_comments') } = 1;
                $param->{allow_comments} = $q->param('allow_comments');
                $param->{allow_pings}    = $q->param('allow_pings');
            }
            else {
                # new edit
                $param->{ 'allow_comments_'
                      . $blog->allow_comments_default } = 1;
                $param->{allow_comments} = $blog->allow_comments_default;
                $param->{allow_pings}    = $blog->allow_pings_default;
            }
        }

        require POSIX;
        my @now = offset_time_list( time, $blog );
        $param->{authored_on_date} = $q->param('authored_on_date')
          || POSIX::strftime( "%Y-%m-%d", @now );
        $param->{authored_on_time} = $q->param('authored_on_time')
          || POSIX::strftime( "%H:%M:%S", @now );
    }

    ## Load categories and process into loop for category pull-down.
    require MT::Placement;
    my $cat_id = $param->{category_id};
    my $depth  = 0;
    my %places;

    # set the dirty flag in js?
    $param->{dirty} = $q->param('dirty') ? 1 : 0;

    if ($id) {
        my @places =
          MT::Placement->load( { entry_id => $id, is_primary => 0 } );
        %places = map { $_->category_id => 1 } @places;
    }
    my $cats = $q->param('category_ids');
    if ( defined $cats ) {
        if ( my @cats = split /,/, $cats ) {
            $cat_id = $cats[0];
            %places = map { $_ => 1 } @cats;
        }
    }
    if ( $q->param('reedit') ) {
        $param->{reedit} = 1;
        if ( !$q->param('basename_manual') ) {
            $param->{'basename'} = '';
        }
    }
    if ($blog) {
        $param->{file_extension} = $blog->file_extension || '';
        $param->{file_extension} = '.' . $param->{file_extension}
          if $param->{file_extension} ne '';
    }
    else {
        $param->{file_extension} = 'html';
    }

    ## Now load user's preferences and customization for new/edit
    ## entry page.
    if ($perms) {
        my $pref_param = $app->load_entry_prefs( $perms->entry_prefs );
        %$param = ( %$param, %$pref_param );
        $param->{disp_prefs_bar_colspan} = $param->{new_object} ? 1 : 2;

        # Completion for tags
        my $auth_prefs = $author->entry_prefs;
        if ( my $delim = chr( $auth_prefs->{tag_delim} ) ) {
            if ( $delim eq ',' ) {
                $param->{'auth_pref_tag_delim_comma'} = 1;
            }
            elsif ( $delim eq ' ' ) {
                $param->{'auth_pref_tag_delim_space'} = 1;
            }
            else {
                $param->{'auth_pref_tag_delim_other'} = 1;
            }
            $param->{'auth_pref_tag_delim'} = $delim;
        }

        require JSON;
        my $json = JSON->new( autoconv => 0 ); # stringifies numbers this way
        $param->{tags_js} =
          $json->objToJson(
            MT::Tag->cache( blog_id => $blog_id, class => 'MT::Entry', private => 1 )
          );

        $param->{can_edit_categories} = $perms->can_edit_categories;
    }

    my $data = $app->_build_category_list(
        blog_id => $blog_id,
        markers => 1,
        type    => $class->container_type,
    );
    my $top_cat = $cat_id;
    my @sel_cats;
    my $cat_tree = [];
    if ( $type eq 'page' ) {
        push @$cat_tree,
          {
            id    => -1,
            label => '/',
            basename => '/',
            path  => [],
          };
        $top_cat ||= -1;
    }
    foreach (@$data) {
        next unless exists $_->{category_id};
        if ( $type eq 'page' ) {
            $_->{category_path_ids} ||= [];
            unshift @{ $_->{category_path_ids} }, -1;
        }
        push @$cat_tree,
          {
            id => $_->{category_id},
            label => $_->{category_label} . ( $type eq 'page' ? '/' : '' ),
            basename => $_->{category_basename} . ( $type eq 'page' ? '/' : '' ),
            path => $_->{category_path_ids} || [],
          };
        push @sel_cats, $_->{category_id}
          if $places{ $_->{category_id} }
          && $_->{category_id} != $cat_id;
    }
    $param->{category_tree} = $cat_tree;
    unshift @sel_cats, $top_cat if defined $top_cat && $top_cat ne "";
    $param->{selected_category_loop}   = \@sel_cats;
    $param->{have_multiple_categories} = scalar @$data > 1;

    $param->{basename_limit} = ( $blog ? $blog->basename_limit : 0 ) || 30;

    if ( $q->param('tags') ) {
        $param->{tags} = $q->param('tags');
    }
    else {
        if ($obj) {
            my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
            require MT::Tag;
            my $tags = MT::Tag->join( $tag_delim, $obj->tags );
            $param->{tags} = $tags;
        }
    }

    ## Load text filters if user displays them
    my %entry_filters;
    if ( defined( my $filter = $q->param('convert_breaks') ) ) {
        $entry_filters{$filter} = 1;
    }
    elsif ($obj) {
        %entry_filters = map { $_ => 1 } @{ $obj->text_filters };
    }
    elsif ($blog) {
        my $cb = $author->text_format || $blog->convert_paras;
        $cb = '__default__' if $cb eq '1';
        $entry_filters{$cb} = 1;
        $param->{convert_breaks} = $cb;
    }
    my $filters = MT->all_text_filters;
    $param->{text_filters} = [];
    for my $filter ( keys %$filters ) {
        push @{ $param->{text_filters} },
          {
            filter_key      => $filter,
            filter_label    => $filters->{$filter}{label},
            filter_selected => $entry_filters{$filter},
            filter_docs     => $filters->{$filter}{docs},
          };
    }
    $param->{text_filters} =
      [ sort { $a->{filter_key} cmp $b->{filter_key} }
          @{ $param->{text_filters} } ];
    unshift @{ $param->{text_filters} },
      {
        filter_key      => '0',
        filter_label    => $app->translate('None'),
        filter_selected => ( !keys %entry_filters ),
      };

    if ($blog) {
        if ( !defined $param->{convert_breaks} ) {
            my $cb = $blog->convert_paras;
            $cb = '__default__' if $cb eq '1';
            $param->{convert_breaks} = $cb;
        }
        my $ext = ( $blog->file_extension || '' );
        $ext = '.' . $ext if $ext ne '';
        $param->{blog_file_extension} = $ext;
    }

    my $rte;
    if ($param->{convert_breaks} eq 'richtext') {
        ## Rich Text editor
        $rte = lc($app->config('RichTextEditor'));
    }
    else {
        $rte = 'archetype';
    }
    my $editors = $app->registry("richtext_editors");
    my $edit_reg = $editors->{$rte} || $editors->{archetype};
    my $rich_editor_tmpl;
    if ($rich_editor_tmpl = $edit_reg->{plugin}->load_tmpl($edit_reg->{template})) {
        $param->{rich_editor} = $rte;
        $param->{rich_editor_tmpl} = $rich_editor_tmpl;
    }

    $param->{object_type}  = $type;
    $param->{quickpost_js} = MT::CMS::Entry::quickpost_js($app, $type);
    if ( 'page' eq $type ) {
        $param->{search_label} = $app->translate('pages');
        $param->{output}       = 'edit_entry.tmpl';
        $param->{screen_class} = 'edit-page edit-entry';
    }
    $param->{sitepath_configured} = $blog && $blog->site_path ? 1 : 0;
    1;
}

sub list {
    my $app = shift;
    my ($param) = @_;
    $param ||= {};

    require MT::Entry;
    my $type = $param->{type} || MT::Entry->class_type;
    my $pkg = $app->model($type) or return "Invalid request.";

    my $q     = $app->param;
    my $perms = $app->permissions;
    if ( $type eq 'page' ) {
        if ( $perms
            && ( !$perms->can_manage_pages ) )
        {
            return $app->errtrans("Permission denied.");
        }
    }
    else {
        if (
            $perms
            && (   !$perms->can_edit_all_posts
                && !$perms->can_create_post
                && !$perms->can_publish_post )
          )
        {
            return $app->errtrans("Permission denied.");
        }
    }

    my $list_pref = $app->list_pref($type);
    my %param     = %$list_pref;
    my $blog_id   = $q->param('blog_id');
    my %terms;
    $terms{blog_id} = $blog_id if $blog_id;
    $terms{class} = $type;
    my $limit = $list_pref->{rows};
    my $offset = $app->param('offset') || 0;

    if ( !$blog_id && !$app->user->is_superuser ) {
        require MT::Permission;
        $terms{blog_id} = [
            map { $_->blog_id }
              grep { $_->can_create_post || $_->can_edit_all_posts }
              MT::Permission->load( { author_id => $app->user->id } )
        ];
    }

    my %arg;
    my $filter_key = $q->param('filter_key') || '';
    my $filter_col = $q->param('filter')     || '';
    my $filter_val = $q->param('filter_val');

    # check blog_id for deciding to apply category filter or not
    my ( $filter_name, $filter_value );    # human-readable versions
    if ( !exists( $terms{$filter_col} ) ) {
        if ( $filter_col eq 'category_id' ) {
            $filter_name = $app->translate('Category');
            require MT::Category;
            my $cat = MT::Category->load($filter_val);
            return $app->errtrans( "Load failed: [_1]", MT::Category->errstr )
              unless $cat;
            if ( $cat->blog_id != $blog_id ) {
                $filter_key = '';
                $filter_col = '';
                $filter_val = '';
            }
            $filter_value = $cat->label;
        }
        elsif ( $filter_col eq 'asset_id' ) {
            $filter_name = $app->translate('Asset');
            my $asset_class = MT->model('asset');
            my $asset = $asset_class->load($filter_val);
            return $app->errtrans( "Load failed: [_1]", $asset_class->errstr )
              unless $asset;
            if ($asset->blog_id != $blog_id) {
                $filter_key = '';
                $filter_col = '';
                $filter_val = '';
            }
            $filter_value = $param{asset_label} = $asset->label;
        }
    }
    if ( $filter_col && $filter_val ) {
        if ( 'power_edit' eq $filter_col ) {
            $filter_col = 'id';
            unless ( 'ARRAY' eq ref($filter_val) ) {
                my @values = $app->param('filter_val');
                $filter_val = \@values;
            }
        }
        if ( !exists( $terms{$filter_col} ) ) {
            if ( $filter_col eq 'category_id' ) {
                $arg{'join'} = MT::Placement->join_on(
                    'entry_id',
                    { category_id => $filter_val },
                    { unique      => 1 }
                );
            }
            elsif ( $filter_col eq 'asset_id' ) {
                $arg{'join'} = MT->model('objectasset')->join_on(
                    'object_id',
                    { object_ds => $type,
                      asset_id  => $filter_val },
                    { unique    => 1 }
                );
            }
            elsif (( $filter_col eq 'normalizedtag' )
                || ( $filter_col eq 'exacttag' ) )
            {
                my $normalize = ( $filter_col eq 'normalizedtag' );
                require MT::Tag;
                require MT::ObjectTag;
                my $tag_delim   = chr( $app->user->entry_prefs->{tag_delim} );
                my @filter_vals = MT::Tag->split( $tag_delim, $filter_val );
                my @filter_tags = @filter_vals;
                if ($normalize) {
                    push @filter_tags, MT::Tag->normalize($_)
                      foreach @filter_vals;
                }
                my @tags = MT::Tag->load( { name => [@filter_tags] },
                    { binary => { name => 1 } } );
                my @tag_ids;
                foreach (@tags) {
                    push @tag_ids, $_->id;
                    if ($normalize) {
                        my @more = MT::Tag->load(
                            { n8d_id => $_->n8d_id ? $_->n8d_id : $_->id } );
                        push @tag_ids, $_->id foreach @more;
                    }
                }
                @tag_ids = (0) unless @tags;
                $arg{'join'} = MT::ObjectTag->join_on(
                    'object_id',
                    {
                        tag_id            => \@tag_ids,
                        object_datasource => $pkg->datasource
                    },
                    { unique => 1 }
                );
            }
            else {
                $terms{$filter_col} = $filter_val;
            }
            $param{filter_args} = "&filter=" . encode_url($filter_col) . "&filter_val=" . encode_url($filter_val);

            if (   ( $filter_col eq 'normalizedtag' )
                || ( $filter_col eq 'exacttag' ) )
            {
                $filter_name  = $app->translate('Tag');
                $filter_value = $filter_val;
            }
            elsif ( $filter_col eq 'author_id' ) {
                $filter_name = $app->translate('User');
                my $author = MT::Author->load($filter_val);
                return $app->errtrans( "Load failed: [_1]", MT::Author->errstr )
                  unless $author;
                $filter_value = $author->name;
            }
            elsif ( $filter_col eq 'status' ) {
                $filter_name = $app->translate('Entry Status');
                $filter_value =
                  $app->translate( MT::Entry::status_text($filter_val) );
            }
            if ( $filter_name && $filter_value ) {
                $param{filter}                        = $filter_col;
                $param{ 'filter_col_' . $filter_col } = 1;
                $param{filter_val}                    = $filter_val;
            }
        }
        $param{filter_unpub} = $filter_col eq 'status';
    }
    elsif ($filter_key) {
        my $filters = $app->registry("list_filters", "entry") || {};
        if ( my $filter = $filters->{$filter_key} ) {
            if ( my $code = $filter->{code}
                || $app->handler_to_coderef( $filter->{handler} ) )
            {
                $param{filter_key}   = $filter_key;
                $param{filter_label} = $filter->{label};
                $code->( \%terms, \%arg );
            }
        }
    }
    require MT::Category;
    require MT::Placement;

    my $total = $pkg->count( \%terms, \%arg ) || 0;
    $arg{'sort'} = $type eq 'page' ? 'modified_on' : 'authored_on';
    $arg{direction} = 'descend';
    $arg{limit}     = $limit + 1;
    if ( $total <= $limit ) {
        delete $arg{limit};
        $offset = 0;
    }
    elsif ( $total && $offset > $total - 1 ) {
        $arg{offset} = $offset = $total - $limit;
    }
    elsif ( $offset && ( ( $offset < 0 ) || ( $total - $offset < $limit ) ) ) {
        $arg{offset} = $offset = $total - $limit;
    }
    else {
        $arg{offset} = $offset if $offset;
    }

    my $iter = $pkg->load_iter( \%terms, \%arg );

    my $is_power_edit = $q->param('is_power_edit');
    if ($is_power_edit) {
        $param{has_expanded_mode} = 0;
        delete $param{view_expanded};
    }
    else {
        $param{has_expanded_mode} = 1;
    }
    my $data = build_entry_table( $app,
        iter          => $iter,
        is_power_edit => $is_power_edit,
        param         => \%param,
        type          => $type
    );
    delete $_->{object} foreach @$data;
    delete $param{entry_table} unless @$data;

    ## We tried to load $limit + 1 entries above; if we actually got
    ## $limit + 1 back, we know we have another page of entries.
    my $have_next_entry = @$data > $limit;
    pop @$data while @$data > $limit;
    if ($offset) {
        $param{prev_offset}     = 1;
        $param{prev_offset_val} = $offset - $limit;
        $param{prev_offset_val} = 0 if $param{prev_offset_val} < 0;
    }
    if ($have_next_entry) {
        $param{next_offset}     = 1;
        $param{next_offset_val} = $offset + $limit;
    }

    $iter = MT::Author->load_iter(
        { type => MT::Author::AUTHOR() },
        {
            'join' => $pkg->join_on(
                'author_id',
                { $blog_id ? ( blog_id => $blog_id ) : () },
                {
                    'unique'  => 1,
                    'sort'    => 'authored_on',
                    direction => 'descend'
                }
            ),
            limit => 51,
        }
    );
    my %seen;
    my @authors;
    while ( my $au = $iter->() ) {
        next if $seen{ $au->id };
        $seen{ $au->id } = 1;
        my $row = {
            author_name => $au->name,
            author_id   => $au->id
        };
        push @authors, $row;
        if ( @authors == 50 ) {
            $iter->end;
            last;
        }
    }
    $param{entry_author_loop} = \@authors;

    # $iter = $app->model('asset')->load_iter(
    #     { class => '*', blog_id => $blog_id },
    #     {
    #         'join' => MT->model('objectasset')->join_on(
    #             'asset_id',
    #             {},
    #             { unique => 1 }
    #         ),
    #         'sort'    => 'created_on',
    #         direction => 'descend',
    #     }
    # );
    # %seen = ();
    # my @assets;
    # while ( my $asset = $iter->() ) {
    #     next if $seen{ $asset->id };
    #     $seen{ $asset->id } = 1;
    #     my $row = {
    #         asset_label => $asset->label,
    #         asset_id    => $asset->id,
    #     };
    #     push @assets, $row;
    #     if ( @assets == 50 ) {
    #         $iter->end;
    #         last;
    #     }
    # }
    # if ($filter_col eq 'asset_id' && !$seen{$filter_val}) {
    #     push @assets, {
    #         asset_label => $param{asset_label},
    #         asset_id    => $filter_val,
    #     };
    # }
    # $param{entry_asset_loop} = \@assets;

    $param{page_actions}        = $app->page_actions( $app->mode );
    $param{list_filters}        = $app->list_filters('entry');
    $param{can_power_edit}      = $blog_id && !$is_power_edit;
    $param{can_republish}       = $blog_id ? $perms->can_rebuild : 1;
    $param{is_power_edit}       = $is_power_edit;
    $param{saved_deleted}       = $q->param('saved_deleted');
    $param{no_rebuild}          = $q->param('no_rebuild');
    $param{saved}               = $q->param('saved');
    $param{limit}               = $limit;
    $param{offset}              = $offset;
    $param{object_type}         = $type;
    $param{object_label}        = $pkg->class_label;
    $param{object_label_plural} = $param{search_label} =
      $pkg->class_label_plural;
    $param{list_start}  = $offset + 1;
    $param{list_end}    = $offset + scalar @$data;
    $param{list_total}  = $total;
    $param{next_max}    = $param{list_total} - $limit;
    $param{next_max}    = 0 if ( $param{next_max} || 0 ) < $offset + 1;
    $param{nav_entries} = 1;
    $param{feed_label}  = $app->translate( "[_1] Feed", $pkg->class_label );
    $param{feed_url} =
      $app->make_feed_link( $type, $blog_id ? { blog_id => $blog_id } : undef );
    $app->add_breadcrumb( $pkg->class_label_plural );
    $param{listing_screen} = 1;

    unless ($blog_id) {
        $param{system_overview_nav} = 1;
    }
    $param{container_label} = $pkg->container_label;
    unless ( $param{screen_class} ) {
        $param{screen_class} = "list-$type";
        $param{screen_class} .= " list-entry"
          if $param{object_type} eq "page";  # to piggyback on list-entry styles
    }
    $param{mode}            = $app->mode;
    if ( my $blog = MT::Blog->load($blog_id) ) {
        $param{sitepath_unconfigured} = $blog->site_path ? 0 : 1;
    }

    $param->{return_args} ||= $app->make_return_args;
    my @return_args = grep { $_ !~ /offset=\d/ } split /&/, $param->{return_args};
    $param{return_args} = join '&', @return_args;
    $param{return_args} .= "&offset=$offset" if $offset;
    $param{screen_id} = "list-entry";
    $param{screen_id} = "list-page"
      if $param{object_type} eq "page";
    if ( $param{is_power_edit} ) {
        $param{screen_id} = "batch-edit-entry";
        $param{screen_id} = "batch-edit-page"
          if $param{object_type} eq "page";
        $param{screen_class} .= " batch-edit";
    }
    $app->load_tmpl( "list_entry.tmpl", \%param );
}

sub preview {
    my $app         = shift;
    my $q           = $app->param;
    my $type        = $q->param('_type') || 'entry';
    my $entry_class = $app->model($type);
    my $blog_id     = $q->param('blog_id');
    my $blog        = $app->blog;
    my $id          = $q->param('id');
    my $entry;
    my $user_id = $app->user->id;

    if ($id) {
        $entry = $entry_class->load( { id => $id, blog_id => $blog_id } )
            or return $app->errtrans( "Invalid request." );
        $user_id = $entry->author_id;
    }
    else {
        $entry = $entry_class->new;
        $entry->author_id($user_id);
        $entry->id(-1); # fake out things like MT::Taggable::__load_tags
        $entry->blog_id($blog_id);
    }
    my $cat;
    my $names = $entry->column_names;

    my %values = map { $_ => scalar $app->param($_) } @$names;
    delete $values{'id'} unless $q->param('id');
    ## Strip linefeed characters.
    for my $col (qw( text excerpt text_more keywords )) {
        $values{$col} =~ tr/\r//d if $values{$col};
    }
    $values{allow_comments} = 0
      if !defined( $values{allow_comments} )
      || $q->param('allow_comments') eq '';
    $values{allow_pings} = 0
      if !defined( $values{allow_pings} )
      || $q->param('allow_pings') eq '';
    $entry->set_values( \%values );

    my $cat_ids = $q->param('category_ids');
    if ($cat_ids) {
        my @cats = split /,/, $cat_ids;
        if (@cats) {
            my $primary_cat = $cats[0];
            $cat =
              MT::Category->load( { id => $primary_cat, blog_id => $blog_id } );
            my @categories = MT::Category->load( { id => \@cats, blog_id => $blog_id });
            $entry->cache_property('category', undef, $cat);
            $entry->cache_property('categories', undef, \@categories);
        }
    } else {
        $entry->cache_property('category', undef, undef);
        $entry->cache_property('categories', undef, []);
    }
    my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
    my @tag_names = MT::Tag->split( $tag_delim, $q->param('tags') );
    if (@tag_names) {
        my @tags;
        foreach my $tag_name (@tag_names) {
            my $tag = MT::Tag->new;
            $tag->name($tag_name);
            push @tags, $tag;
        }
        $entry->{__tags} = \@tag_names;
        $entry->{__tag_objects} = \@tags;
    }

    my $date = $q->param('authored_on_date');
    my $time = $q->param('authored_on_time');
    my $ts   = $date . $time;
    $ts =~ s/\D//g;
    $entry->authored_on($ts);

    my $preview_basename = $app->preview_object_basename;
    $entry->basename($preview_basename);

    require MT::TemplateMap;
    require MT::Template;
    my $tmpl_map = MT::TemplateMap->load(
        {
            archive_type => ( $type eq 'page' ? 'Page' : 'Individual' ),
            is_preferred => 1,
            blog_id => $blog_id,
        }
    );

    my $tmpl;
    my $fullscreen;
    my $archive_file;
    my $orig_file;
    my $file_ext;
    if ($tmpl_map) {
        $tmpl         = MT::Template->load( $tmpl_map->template_id );
        $file_ext = $blog->file_extension || '';
        $archive_file = $entry->archive_file;

        my $blog_path = $type eq 'page' ?
            $blog->site_path :
            ($blog->archive_path || $blog->site_path);
        $archive_file = File::Spec->catfile( $blog_path, $archive_file );
        require File::Basename;
        my $path;
        ( $orig_file, $path ) = File::Basename::fileparse( $archive_file );
        $file_ext = '.' . $file_ext if $file_ext ne '';
        $archive_file = File::Spec->catfile( $path, $preview_basename . $file_ext );
    }
    else {
        $tmpl       = $app->load_tmpl('preview_entry_content.tmpl');
        $fullscreen = 1;
    }
    return $app->error($app->translate('Can\'t load template.')) unless $tmpl;

    # translates naughty words when PublishCharset is NOT UTF-8
    $app->_translate_naughty_words($entry);

    $entry->convert_breaks( scalar $q->param('convert_breaks') );
        
    my @data = ( { data_name => 'author_id', data_value => $user_id } );
    $app->run_callbacks( 'cms_pre_preview', $app, $entry, \@data );

    my $ctx = $tmpl->context;
    $ctx->stash( 'entry', $entry );
    $ctx->stash( 'blog',  $blog );
    $ctx->stash( 'category', $cat ) if $cat;
    $ctx->{current_timestamp} = $ts;
    $ctx->var('entry_template',    1);
    $ctx->var('archive_template',  1);
    $ctx->var('entry_template',    1);
    $ctx->var('feedback_template', 1);
    $ctx->var('archive_class',     'entry-archive');
    $ctx->var('preview_template',  1);
    my $html = $tmpl->output;
    my %param;
    unless ( defined($html) ) {
        my $preview_error = $app->translate( "Publish error: [_1]",
            MT::Util::encode_html( $tmpl->errstr ) );
        $param{preview_error} = $preview_error;
        my $tmpl_plain = $app->load_tmpl('preview_entry_content.tmpl');
        $tmpl->text( $tmpl_plain->text );
        $html = $tmpl->output;
        defined($html)
          or return $app->error(
            $app->translate( "Publish error: [_1]", $tmpl->errstr ) );
        $fullscreen = 1;
    }

    # If MT is configured to do 'local' previews, convert all
    # the normal blog URLs into the domain used by MT itself (ie,
    # blog is published to www.example.com, which is a different
    # server from where MT runs, mt.example.com; previews therefore
    # should occur locally, so replace all http://www.example.com/
    # with http://mt.example.com/).
    my ($old_url, $new_url);
    if ($app->config('LocalPreviews')) {
        $old_url = $blog->site_url;
        $old_url =~ s!^(https?://[^/]+?/)(.*)?!$1!;
        $new_url = $app->base . '/';
        $html =~ s!\Q$old_url\E!$new_url!g;
    }

    if ( !$fullscreen ) {
        my $fmgr = $blog->file_mgr;

        ## Determine if we need to build directory structure,
        ## and build it if we do. DirUmask determines
        ## directory permissions.
        require File::Basename;
        my $path = File::Basename::dirname($archive_file);
        $path =~ s!/$!!
          unless $path eq '/';    ## OS X doesn't like / at the end in mkdir().
        unless ( $fmgr->exists($path) ) {
            $fmgr->mkpath($path);
        }

        if ( $fmgr->exists($path) && $fmgr->can_write($path) ) {
            $fmgr->put_data( $html, $archive_file );
            $param{preview_file} = $preview_basename;
            my $preview_url = $entry->archive_url;
            $preview_url =~ s! / \Q$orig_file\E ( /? ) $!/$preview_basename$file_ext$1!x;

            # We also have to translate the URL used for the
            # published file to be on the MT app domain.
            if (defined $new_url) {
                $preview_url =~ s!^\Q$old_url\E!$new_url!;
            }

            $param{preview_url}  = $preview_url;

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
            $fullscreen = 1;
            $param{preview_error} = $app->translate(
                "Unable to create preview file in this location: [_1]", $path );
            my $tmpl_plain = $app->load_tmpl('preview_entry_content.tmpl');
            $tmpl->text( $tmpl_plain->text );
            $tmpl->reset_tokens;
            $html = $tmpl->output;
            $param{preview_body} = $html;
        }
    }
    else {
        $param{preview_body} = $html;
    }
    $param{id} = $id if $id;
    $param{new_object} = $param{id} ? 0 : 1;
    $param{title} = $entry->title;
    my $cols = $entry_class->column_names;

    for my $col (@$cols) {
        next
          if $col eq 'created_on'
          || $col eq 'created_by'
          || $col eq 'modified_on'
          || $col eq 'modified_by'
          || $col eq 'authored_on'
          || $col eq 'author_id'
          || $col eq 'pinged_urls'
          || $col eq 'tangent_cache'
          || $col eq 'template_id'
          || $col eq 'class'
          || $col eq 'meta'
          || $col eq 'comment_count'
          || $col eq 'ping_count';
        if ( $col eq 'basename' ) {
            if (   ( !defined $q->param('basename') )
                || ( $q->param('basename') eq '' ) )
            {
                $q->param( 'basename', $q->param('basename_old') );
            }
        }
        push @data,
          {
            data_name  => $col,
            data_value => scalar $q->param($col)
          };
    }
    for my $data (
        qw( authored_on_date authored_on_time basename_manual basename_old category_ids tags )
      )
    {
        push @data,
          {
            data_name  => $data,
            data_value => scalar $q->param($data)
          };
    }

    $param{entry_loop} = \@data;
    my $list_mode;
    my $list_title;
    if ( $type eq 'page' ) {
        $list_title = 'Pages';
        $list_mode  = 'list_pages';
    }
    else {
        $list_title = 'Entries';
        $list_mode  = 'list_entries';
    }
    if ($id) {
        $app->add_breadcrumb(
            $app->translate($list_title),
            $app->uri(
                'mode' => $list_mode,
                args   => { blog_id => $blog_id }
            )
        );
        $app->add_breadcrumb( $entry->title || $app->translate('(untitled)') );
    }
    else {
        $app->add_breadcrumb( $app->translate($list_title),
            $app->uri( 'mode' => $list_mode, args => { blog_id => $blog_id } )
        );
        $app->add_breadcrumb(
            $app->translate( 'New [_1]', $entry_class->class_label ) );
        $param{nav_new_entry} = 1;
    }
    $param{object_type}  = $type;
    $param{object_label} = $entry_class->class_label;
    if ($fullscreen) {
        return $app->load_tmpl( 'preview_entry.tmpl', \%param );
    }
    else {
        $app->request('preview_object', $entry);
        return $app->load_tmpl( 'preview_strip.tmpl', \%param );
    }
}

sub cfg_entry {
    my $app     = shift;
    my $q       = $app->param;
    my $blog_id = scalar $q->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 )
      unless $blog_id;
    $q->param( '_type', 'blog' );
    $q->param( 'id',    scalar $q->param('blog_id') );
    $app->forward("view",
        {
            output       => 'cfg_entry.tmpl',
            screen_class => 'settings-screen entry-screen'
        }
    );
}

sub save {
    my $app = shift;
    $app->validate_magic or return;

    $app->remove_preview_file;

    if ( $app->param('is_power_edit') ) {
        return $app->save_entries(@_);
    }
    my $author = $app->user;
    my $type = $app->param('_type') || 'entry';

    my $class = $app->model($type)
      or retrun $app->errtrans("Invalid parameter");

    my $cat_class = $app->model( $class->container_type );

    my $perms = $app->permissions
      or return $app->errtrans("Permission denied.");

    if ( $type eq 'page' ) {
        return $app->errtrans("Permission denied.")
          unless $perms->can_manage_pages;
    }

    my $id = $app->param('id');
    if ( !$id ) {
        return $app->errtrans("Permission denied.")
          unless ( ( 'entry' eq $type ) && $perms->can_create_post )
          || ( ( 'page' eq $type ) && $perms->can_manage_pages );
    }

    $app->validate_magic() or return;

    # check for autosave
    if ( $app->param('_autosave') ) {
        return $app->autosave_object();
    }

    require MT::Blog;
    my $blog_id = $app->param('blog_id');
    my $blog    = MT::Blog->load($blog_id)
        or return $app->error($app->translate('Can\'t load blog #[_1].', $blog_id));
    
    my $archive_type;

    my ( $obj, $orig_obj, $orig_file );
    if ($id) {
        $obj = $class->load($id)
          || return $app->error(
            $app->translate( "No such [_1].", $class->class_label ) );
        return $app->error( $app->translate("Invalid parameter") )
          unless $obj->blog_id == $blog_id;
        if ( $type eq 'entry' ) {
            return $app->error( $app->translate("Permission denied.") )
              unless $perms->can_edit_entry( $obj, $author );
            return $app->error( $app->translate("Permission denied.") )
              if ( $obj->status ne $app->param('status') )
              && !( $perms->can_edit_entry( $obj, $author, 1 ) );
            $archive_type = 'Individual';
        }
        elsif ( $type eq 'page' ) {
            $archive_type = 'Page';
        }
        $orig_obj = $obj->clone;
        $orig_file = archive_file_for( $orig_obj, $blog, $archive_type );
    }
    else {
        $obj = $class->new;
    }
    my $status_old = $id ? $obj->status : 0;
    my $names = $obj->column_names;

    ## Get rid of category_id param, because we don't want to just set it
    ## in the Entry record; save it for later when we will set the Placement.
    my ( $cat_id, @add_cat ) = split /\s*,\s*/,
      ( $app->param('category_ids') || '' );
    $app->delete_param('category_id');
    if ($id) {
        ## Delete the author_id param (if present), because we don't want to
        ## change the existing author.
        $app->delete_param('author_id');
    }

    my %values = map { $_ => scalar $app->param($_) } @$names;
    delete $values{'id'} unless $app->param('id');
    ## Strip linefeed characters.
    for my $col (qw( text excerpt text_more keywords )) {
        $values{$col} =~ tr/\r//d if $values{$col};
    }
    $values{allow_comments} = 0
      if !defined( $values{allow_comments} )
      || $app->param('allow_comments') eq '';
    delete $values{week_number}
      if ( $app->param('week_number') || '' ) eq '';
    delete $values{basename}
      unless $perms->can_publish_post || $perms->can_edit_all_posts;
    $obj->set_values( \%values );
    $obj->allow_pings(0)
      if !defined $app->param('allow_pings')
      || $app->param('allow_pings') eq '';
    my $ao_d = $app->param('authored_on_date');
    my $ao_t = $app->param('authored_on_time');

    if ( !$id ) {

        #  basename check for this new entry...
        if (   ( my $basename = $app->param('basename') )
            && !$app->param('basename_manual')
            && $type eq 'entry' )
        {
            my $exist =
              $class->exist( { blog_id => $blog_id, basename => $basename } );
            if ($exist) {
                $obj->basename( MT::Util::make_unique_basename($obj) );
            }
        }
    }

    if ( $type eq 'page' ) {

        # -1 is a special id for identifying the 'root' folder
        $cat_id = 0 if $cat_id == -1;
        my $dup_it = $class->load_iter(
            {
                blog_id  => $blog_id,
                basename => $obj->basename,
                class    => 'page',
                ( $id ? ( id => $id ) : () )
            },
            { ( $id ? ( not => { id => 1 } ) : () ) }
        );
        while ( my $p = $dup_it->() ) {
            my $p_folder = $p->folder;
            my $dup_folder_path =
              defined $p_folder ? $p_folder->publish_path() : '';
            my $folder = MT::Folder->load($cat_id) if $cat_id;
            my $folder_path = defined $folder ? $folder->publish_path() : '';
            return $app->error(
                $app->translate(
"Same Basename has already been used. You should use an unique basename."
                )
            ) if ( $dup_folder_path eq $folder_path );
        }

    }

    if ( $type eq 'entry' ) {
        $obj->status( MT::Entry::HOLD() )
          if !$id
          && !$perms->can_publish_post
          && !$perms->can_edit_all_posts;
    }

    my $filter_result = $app->run_callbacks( 'cms_save_filter.' . $type, $app );

    if ( !$filter_result ) {
        my %param = ();
        $param{error}       = $app->errstr;
        $param{return_args} = $app->param('return_args');
        return $app->forward( "view", \%param );
    }

    # check to make sure blog has site url and path defined.
    # otherwise, we can't publish a released entry
    if ( ( $obj->status || 0 ) != MT::Entry::HOLD() ) {
        if ( !$blog->site_path || !$blog->site_url ) {
            return $app->error(
                $app->translate(
"Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined."
                )
            );
        }
    }

    my ( $previous_old, $next_old );
    if (   ( $perms->can_publish_post || $perms->can_edit_all_posts )
        && ($ao_d) )
    {
        my %param = ();
        my $ao = $ao_d . ' ' . $ao_t;
        unless (
            $ao =~ m!^(\d{4})-(\d{1,2})-(\d{1,2})\s+(\d{1,2}):(\d{1,2})(?::(\d{1,2}))?$! )
        {
            $param{error} = $app->translate(
"Invalid date '[_1]'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.",
$ao
            );
        }
        my $s = $6 || 0;
            $param{error} = $app->translate(
                "Invalid date '[_1]'; authored on dates should be real dates.",
                $ao
          )
          if (
               $s > 59
            || $s < 0
            || $5 > 59
            || $5 < 0
            || $4 > 23
            || $4 < 0
            || $2 > 12
            || $2 < 1
            || $3 < 1
            || ( MT::Util::days_in( $2, $1 ) < $3
                && !MT::Util::leap_day( $0, $1, $2 ) )
          );
        $param{return_args} = $app->param('return_args');
        return $app->forward( "view", \%param ) if $param{error};
        if ($obj->authored_on) {
            $previous_old = $obj->previous(1);
            $next_old     = $obj->next(1);
        }
        my $ts = sprintf "%04d%02d%02d%02d%02d%02d", $1, $2, $3, $4, $5, $s;
        $obj->authored_on($ts);
    }
    my $is_new = $obj->id ? 0 : 1;

    $app->_translate_naughty_words($obj);

    $obj->modified_by( $author->id ) unless $is_new;

    $app->run_callbacks( 'cms_pre_save.' . $type, $app, $obj, $orig_obj )
      || return $app->error(
        $app->translate(
            "Saving [_1] failed: [_2]",
            $class->class_label, $app->errstr
        )
      );

    $obj->save
      or return $app->error(
        $app->translate(
            "Saving [_1] failed: [_2]",
            $class->class_label, $obj->errstr
        )
      );

    my $message;
    if ($is_new) {
        $message =
          $app->translate( "[_1] '[_2]' (ID:[_3]) added by user '[_4]'",
            $class->class_label, $obj->title, $obj->id, $author->name );
    }
    elsif ( $orig_obj->status ne $obj->status ) {
        $message = $app->translate(
"[_1] '[_2]' (ID:[_3]) edited and its status changed from [_4] to [_5] by user '[_6]'",
            $class->class_label,
            $obj->title,
            $obj->id,
            $app->translate( MT::Entry::status_text( $orig_obj->status ) ),
            $app->translate( MT::Entry::status_text( $obj->status ) ),
            $author->name
        );

    }
    else {
        $message =
          $app->translate( "[_1] '[_2]' (ID:[_3]) edited by user '[_4]'",
            $class->class_label, $obj->title, $obj->id, $author->name );
    }
    require MT::Log;
    $app->log(
        {
            message => $message,
            level   => MT::Log::INFO(),
            class   => $type,
            $is_new ? ( category => 'new' ) : ( category => 'edit' ),
            metadata => $obj->id
        }
    );

    my $error_string = MT::callback_errstr();

    ## Now that the object is saved, we can be certain that it has an
    ## ID. So we can now add/update/remove the primary placement.
    require MT::Placement;
    my $place =
      MT::Placement->load( { entry_id => $obj->id, is_primary => 1 } );
    if ($cat_id) {
        unless ($place) {
            $place = MT::Placement->new;
            $place->entry_id( $obj->id );
            $place->blog_id( $obj->blog_id );
            $place->is_primary(1);
        }
        $place->category_id($cat_id);
        $place->save;
        my $cat = $cat_class->load($cat_id);
        $obj->cache_property( 'category', undef, $cat );
    }
    else {
        if ( $place ) {
            $place->remove;
            $obj->cache_property( 'category', undef, undef );
        }
    }

    my $placements_updated;

    # save secondary placements...
    my @place = MT::Placement->load(
        {
            entry_id   => $obj->id,
            is_primary => 0
        }
    );
    for my $place (@place) {
        $place->remove;
        $placements_updated = 1;
    }
    my @add_cat_obj;
    for my $cat_id (@add_cat) {
        my $cat = $cat_class->load($cat_id);

        # blog_id sanity check
        next if !$cat || $cat->blog_id != $obj->blog_id;

        my $place = MT::Placement->new;
        $place->entry_id( $obj->id );
        $place->blog_id( $obj->blog_id );
        $place->is_primary(0);
        $place->category_id($cat_id);
        $place->save
          or return $app->error(
            $app->translate( "Saving placement failed: [_1]", $place->errstr )
          );
        $placements_updated = 1;
        push @add_cat_obj, $cat;
    }
    if ($placements_updated) {
        unshift @add_cat_obj, $obj->cache_property('category')
          if $obj->cache_property('category');
        $obj->cache_property( 'categories', undef, [] );
        $obj->cache_property( 'categories', undef, \@add_cat_obj );
    }

    $app->run_callbacks( 'cms_post_save.' . $type, $app, $obj, $orig_obj );

    ## If the saved status is RELEASE, or if the *previous* status was
    ## RELEASE, then rebuild entry archives, indexes, and send the
    ## XML-RPC ping(s). Otherwise the status was and is HOLD, and we
    ## don't have to do anything.
    if ( ( $obj->status || 0 ) == MT::Entry::RELEASE()
        || $status_old eq MT::Entry::RELEASE() )
    {
        if ( $app->config('DeleteFilesAtRebuild') && $orig_obj ) {
            my $file = archive_file_for( $obj, $blog, $archive_type );
            if ( $file ne $orig_file || $obj->status != MT::Entry::RELEASE() ) {
                $app->publisher->remove_entry_archive_file(
                    Entry       => $orig_obj,
                    ArchiveType => $archive_type
                );
            }
        }

        # If there are no static pages, just rebuild indexes.
        if ( $blog->count_static_templates($archive_type) == 0
            || MT::Util->launch_background_tasks() )
        {
            my $res = MT::Util::start_background_task(
                sub {
                    $app->run_callbacks('pre_build');
                    $app->rebuild_entry(
                        Entry             => $obj,
                        BuildDependencies => 1,
                        OldEntry          => $orig_obj,
                        OldPrevious       => ($previous_old)
                        ? $previous_old->id
                        : undef,
                        OldNext => ($next_old) ? $next_old->id : undef
                    ) or return $app->publish_error();
                    $app->run_callbacks( 'rebuild', $blog );
                    $app->run_callbacks( 'post_build' );
                    1;
                }
            );
            return unless $res;
            return ping_continuation($app,
                $obj, $blog,
                OldStatus => $status_old,
                IsNew     => $is_new,
            );
        }
        else {
            return $app->redirect(
                $app->uri(
                    'mode' => 'start_rebuild',
                    args   => {
                        blog_id    => $obj->blog_id,
                        'next'     => 0,
                        type       => 'entry-' . $obj->id,
                        entry_id   => $obj->id,
                        is_new     => $is_new,
                        old_status => $status_old,
                        (
                            $previous_old
                            ? ( old_previous => $previous_old->id )
                            : ()
                        ),
                        ( $next_old ? ( old_next => $next_old->id ) : () )
                    }
                )
            );
        }
    }
    _finish_rebuild_ping( $app, $obj, !$id );
}

sub save_entries {
    my $app   = shift;
    my $perms = $app->permissions;
    my $type  = $app->param('_type');
    return $app->errtrans("Permission denied.")
      unless $perms
      && (
        $type eq 'page'
        ? ( $perms->can_manage_pages )
        : (      $perms->can_publish_post
              || $perms->can_create_post
              || $perms->can_edit_all_posts )
      );

    $app->validate_magic() or return;

    my $q = $app->param;
    my @p = $q->param;
    require MT::Entry;
    require MT::Placement;
    require MT::Log;
    my $blog_id        = $q->param('blog_id');
    my $this_author    = $app->user;
    my $this_author_id = $this_author->id;
    for my $p (@p) {
        next unless $p =~ /^category_id_(\d+)/;
        my $id    = $1;
        my $entry = MT::Entry->load($id)
            or next;
        return $app->error( $app->translate("Permission denied.") )
            unless $perms
              && (
                $type eq 'page'
                ? ( $perms->can_manage_pages )
                : (      $perms->can_publish_post
                      || $perms->can_create_post
                      || $perms->can_edit_all_posts )
              );
        my $orig_obj = $entry->clone;
        if ( $perms->can_edit_entry( $entry, $this_author ) ) {
            my $author_id = $q->param( 'author_id_' . $id );
            $entry->author_id( $author_id ? $author_id : 0 );
            $entry->title( scalar $q->param( 'title_' . $id ) );
        }
        if ( $perms->can_edit_entry( $entry, $this_author, 1 ) )
        {    ## can he/she change status?
            $entry->status( scalar $q->param( 'status_' . $id ) );
            my $co = $q->param( 'created_on_' . $id );
            unless ( $co =~
                m!(\d{4})-(\d{2})-(\d{2})\s+(\d{2}):(\d{2})(?::(\d{2}))?! )
            {
                return $app->error(
                    $app->translate(
"Invalid date '[_1]'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.",
                        $co
                    )
                );
            }
            my $s = $6 || 0;

            # Emit an error message if the date is bogus.
            return $app->error(
                $app->translate(
"Invalid date '[_1]'; authored on dates should be real dates.",
                    $co
                )
              )
              if $s > 59
              || $s < 0
              || $5 > 59
              || $5 < 0
              || $4 > 23
              || $4 < 0
              || $2 > 12
              || $2 < 1
              || $3 < 1
              || ( MT::Util::days_in( $2, $1 ) < $3
                && !MT::Util::leap_day( $0, $1, $2 ) );

            # FIXME: Should be assigning the publish_date field here
            my $ts = sprintf "%04d%02d%02d%02d%02d%02d", $1, $2, $3, $4, $5, $s;
            if ($type eq 'page' ) {
                $entry->modified_on($ts);
            } else {
                $entry->authored_on($ts);
            }
        }
        $app->run_callbacks( 'cms_pre_save.' . $type, $app, $entry, $orig_obj )
          || return $app->error(
            $app->translate(
                "Saving [_1] failed: [_2]",
                $entry->class_label, $app->errstr
            )
          );
        $entry->save
          or return $app->error(
            $app->translate(
                "Saving entry '[_1]' failed: [_2]", $entry->title,
                $entry->errstr
            )
          );
        my $cat_id = $q->param("category_id_$id");
        my $place  = MT::Placement->load(
            {
                entry_id   => $id,
                is_primary => 1
            }
        );
        if ( $place && !$cat_id ) {
            $place->remove
              or return $app->error(
                $app->translate(
                    "Removing placement failed: [_1]",
                    $place->errstr
                )
              );
        }
        elsif ($cat_id) {
            unless ($place) {
                $place = MT::Placement->new;
                $place->entry_id($id);
                $place->blog_id($blog_id);
                $place->is_primary(1);
            }
            $place->category_id( scalar $q->param($p) );
            $place->save
              or return $app->error(
                $app->translate(
                    "Saving placement failed: [_1]",
                    $place->errstr
                )
              );
        }
        my $message;
        if ( $orig_obj->status ne $entry->status ) {
            $message = $app->translate(
"[_1] '[_2]' (ID:[_3]) edited and its status changed from [_4] to [_5] by user '[_6]'",
                $entry->class_label,
                $entry->title,
                $entry->id,
                $app->translate( MT::Entry::status_text( $orig_obj->status ) ),
                $app->translate( MT::Entry::status_text( $entry->status ) ),
                $this_author->name
            );
        }
        else {
            $message =
              $app->translate( "[_1] '[_2]' (ID:[_3]) edited by user '[_4]'",
                $entry->class_label, $entry->title, $entry->id,
                $this_author->name );
        }
        $app->log(
            {
                message  => $message,
                level    => MT::Log::INFO(),
                class    => $entry->class,
                category => 'edit',
                metadata => $entry->id
            }
        );
        $app->run_callbacks( 'cms_post_save.' . $type, $app, $entry, $orig_obj );
    }
    $app->add_return_arg( 'saved' => 1, is_power_edit => 1 );
    $app->call_return;
}

sub send_pings {
    my $app = shift;
    my $q   = $app->param;
    $app->validate_magic() or return;
    require MT::Entry;
    require MT::Blog;
    my $blog  = MT::Blog->load( scalar $q->param('blog_id') );
    my $entry = MT::Entry->load( scalar $q->param('entry_id') );
    ## MT::ping_and_save pings each of the necessary URLs, then processes
    ## the return value from MT::ping to update the list of URLs pinged
    ## and not successfully pinged. It returns the return value from
    ## MT::ping for further processing. If a fatal error occurs, it returns
    ## undef.
    my $results = $app->ping_and_save(
        Blog      => $blog,
        Entry     => $entry,
        OldStatus => scalar $q->param('old_status')
    ) or return;
    my $has_errors = 0;
    require MT::Log;
    for my $res (@$results) {
        $has_errors++,
          $app->log(
            {
                message => $app->translate(
                    "Ping '[_1]' failed: [_2]",
                    $res->{url},
                    encode_text( $res->{error}, undef, undef )
                ),
                class => 'system',
                level => MT::Log::WARNING()
            }
          ) unless $res->{good};
    }
    _finish_rebuild_ping( $app, $entry, scalar $q->param('is_new'),
        $has_errors );
}

sub pinged_urls {
    my $app   = shift;
    my $perms = $app->permissions
      or return $app->error( $app->translate("No permissions") );
    my %param;
    my $entry_id = $app->param('entry_id');
    require MT::Entry;
    my $entry = MT::Entry->load($entry_id)
        or return $app->error($app->translate('Can\'t load entry #[_1].', $entry_id));
    $param{url_loop} = [ map { { url => $_ } } @{ $entry->pinged_url_list } ];
    $param{failed_url_loop} =
      [ map { { url => $_ } }
          @{ $entry->pinged_url_list( OnlyFailures => 1 ) } ];
    $app->load_tmpl( 'popup/pinged_urls.tmpl', \%param );
}

sub save_entry_prefs {
    my $app   = shift;
    my $perms = $app->permissions
      or return $app->error( $app->translate("No permissions") );
    $app->validate_magic() or return;
    my $q     = $app->param;
    my $prefs = $app->_entry_prefs_from_params;
    $perms->entry_prefs($prefs);
    $perms->save
      or return $app->error(
        $app->translate( "Saving permissions failed: [_1]", $perms->errstr ) );
    $app->send_http_header("text/json");
    return "true";
}

sub publish_entries {
    my $app = shift;
    require MT::Entry;
    update_entry_status( $app, MT::Entry::RELEASE(), $app->param('id') );
}

sub draft_entries {
    my $app = shift;
    require MT::Entry;
    update_entry_status( $app, MT::Entry::HOLD(), $app->param('id') );
}

sub open_batch_editor {
    my $app = shift;
    my @ids = $app->param('id');

    $app->param( 'is_power_edit', 1 );
    $app->param( 'filter',        'power_edit' );
    $app->param( 'filter_val',    \@ids );
    $app->mode(
        'list_' . ( 'entry' eq $app->param('_type') ? 'entries' : 'pages' ) );
    $app->forward( "list_entry", { type => $app->param('_type') } );
}

sub build_entry_table {
    my $app = shift;
    my (%args) = @_;

    my $app_author = $app->user;
    my $perms      = $app->permissions;
    my $type       = $args{type};
    my $class      = $app->model($type);

    my $list_pref = $app->list_pref($type);
    if ( $args{is_power_edit} ) {
        delete $list_pref->{view_expanded};
    }
    my $iter;
    if ( $args{load_args} ) {
        $iter = $class->load_iter( @{ $args{load_args} } );
    }
    elsif ( $args{iter} ) {
        $iter = $args{iter};
    }
    elsif ( $args{items} ) {
        $iter = sub { shift @{ $args{items} } };
    }
    return [] unless $iter;
    my $limit         = $args{limit};
    my $is_power_edit = $args{is_power_edit} || 0;
    my $param         = $args{param} || {};

    ## Load list of categories for display in filter pulldown (and selection
    ## pulldown on power edit page).
    my ( $c_data, %cats );
    my $blog_id = $app->param('blog_id');
    if ($blog_id) {
        $c_data = $app->_build_category_list(
            blog_id => $blog_id,
            type    => $class->container_type,
        );
        my $i = 0;
        for my $row (@$c_data) {
            $row->{category_index} = $i++;
            my $spacer = $row->{category_label_spacer} || '';
            $spacer =~ s/\&nbsp;/\\u00A0/g;
            $row->{category_label_js} =
              $spacer . encode_js( $row->{category_label} );
            $cats{ $row->{category_id} } = $row;
        }
        $param->{category_loop} = $c_data;
    }

    my ( $date_format, $datetime_format );

    if ($is_power_edit) {
        $date_format          = "%Y.%m.%d";
        $datetime_format      = "%Y-%m-%d %H:%M:%S";
    }
    else {
        $date_format     = MT::App::CMS::LISTING_DATE_FORMAT();
        $datetime_format = MT::App::CMS::LISTING_DATETIME_FORMAT();
    }

    my @cat_list;
    if ($is_power_edit) {
        @cat_list =
          sort { $cats{$a}->{category_index} <=> $cats{$b}->{category_index} }
          keys %cats;
    }

    my @data;
    my %blogs;
    require MT::Blog;
    my $title_max_len   = const('DISPLAY_LENGTH_EDIT_ENTRY_TITLE');
    my $excerpt_max_len = const('DISPLAY_LENGTH_EDIT_ENTRY_TEXT_FROM_EXCERPT');
    my $text_max_len    = const('DISPLAY_LENGTH_EDIT_ENTRY_TEXT_BREAK_UP');
    my %blog_perms;
    $blog_perms{ $perms->blog_id } = $perms if $perms;
    while ( my $obj = $iter->() ) {
        my $blog_perms;
        if ( !$app_author->is_superuser() ) {
            $blog_perms = $blog_perms{ $obj->blog_id }
              || $app_author->blog_perm( $obj->blog_id );
        }

        my $row = $obj->column_values;
        $row->{text} ||= '';
        if ( my $ts =
            ( $type eq 'page' ) ? $obj->modified_on : $obj->authored_on )
        {
            $row->{created_on_formatted} =
              format_ts( $date_format, $ts, $obj->blog, $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_time_formatted} =
              format_ts( $datetime_format, $ts, $obj->blog, $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_relative} =
              relative_date( $ts, time, $obj->blog );
        }
        my $author = $obj->author;
        $row->{author_name} =
          $author ? $author->name : $app->translate('(user deleted)');
        if ( my $cat = $obj->category ) {
            $row->{category_label}    = $cat->label;
            $row->{category_basename} = $cat->basename;
        }
        else {
            $row->{category_label}    = '';
            $row->{category_basename} = '';
        }
        $row->{file_extension} = $obj->blog ? $obj->blog->file_extension : '';
        $row->{title_short} = $obj->title;
        if ( !defined( $row->{title_short} ) || $row->{title_short} eq '' ) {
            my $title = remove_html( $obj->text );
            $row->{title_short} =
              substr_text( defined($title) ? $title : "", 0, $title_max_len )
              . '...';
        }
        else {
            $row->{title_short} = remove_html( $row->{title_short} );
            $row->{title_short} =
              substr_text( $row->{title_short}, 0, $title_max_len + 3 ) . '...'
              if length_text( $row->{title_short} ) > $title_max_len;
        }
        if ( $row->{excerpt} ) {
            $row->{excerpt} = remove_html( $row->{excerpt} );
        }
        if ( !$row->{excerpt} ) {
            my $text = remove_html( $row->{text} ) || '';
            $row->{excerpt} = first_n_text( $text, $excerpt_max_len );
            if ( length($text) > length( $row->{excerpt} ) ) {
                $row->{excerpt} .= ' ...';
            }
        }
        $row->{text} = break_up_text( $row->{text}, $text_max_len )
          if $row->{text};
        $row->{title_long} = remove_html( $obj->title );
        $row->{status_text} =
          $app->translate( MT::Entry::status_text( $obj->status ) );
        $row->{ "status_" . MT::Entry::status_text( $obj->status ) } = 1;
        $row->{has_edit_access} = $app_author->is_superuser
          || ( ( 'entry' eq $type )
            && $blog_perms
            && $blog_perms->can_edit_entry( $obj, $app_author ) )
          || ( ( 'page' eq $type )
            && $blog_perms
            && $blog_perms->can_manage_pages );
        if ($is_power_edit) {
            $row->{has_publish_access} = $app_author->is_superuser
              || ( ( 'entry' eq $type )
                && $blog_perms
                && $blog_perms->can_edit_entry( $obj, $app_author, 1 ) )
              || ( ( 'page' eq $type )
                && $blog_perms
                && $blog_perms->can_manage_pages );
            $row->{is_editable} = $row->{has_edit_access};

            ## This is annoying. In order to generate and pre-select the
            ## category, user, and status pull down menus, we need to
            ## have a separate *copy* of the list of categories and
            ## users for every entry listed, so that each row in the list
            ## can "know" whether it is selected for this entry or not.
            my @this_c_data;
            my $this_category_id = $obj->category ? $obj->category->id : undef;
            for my $c_id (@cat_list) {
                push @this_c_data, { %{ $cats{$c_id} } };
                $this_c_data[-1]{category_is_selected} = $this_category_id
                  && $this_category_id == $c_id ? 1 : 0;
            }
            $row->{row_category_loop} = \@this_c_data;

            if ( $obj->author ) {
                $row->{row_author_name} = $obj->author->name;
                $row->{row_author_id}   = $obj->author->id;
            } else {
                $row->{row_author_name} = $app->translate(
                    '(user deleted - ID:[_1])',
                    $obj->author_id
                );
                $row->{row_author_id} = $obj->author_id,
             }
        }
        if ( my $blog = $blogs{ $obj->blog_id } ||=
            MT::Blog->load( $obj->blog_id ) )
        {
            $row->{weblog_id}   = $blog->id;
            $row->{weblog_name} = $blog->name;
        }
        if ( $obj->status == MT::Entry::RELEASE() ) {
            $row->{entry_permalink} = $obj->permalink;
        }
        $row->{object} = $obj;
        push @data, $row;
    }
    return [] unless @data;

    $param->{entry_table}[0] = {%$list_pref};
    $param->{object_loop} = $param->{entry_table}[0]{object_loop} = \@data;
    $app->load_list_actions( $type, \%$param )
      unless $is_power_edit;
    \@data;
}

sub quickpost_js {
    my $app     = shift;
    my ($type)  = @_;
    my $blog_id = $app->blog->id;
    my $blog    = $app->model('blog')->load($blog_id)
        or return $app->error($app->translate('Can\'t load blog #[_1].', $blog_id));
    my %args    = ( '_type' => $type, blog_id => $blog_id, qp => 1 );
    my $uri = $app->base . $app->uri( 'mode' => 'view', args => \%args );
    my $script = qq!javascript:d=document;w=window;t='';if(d.selection)t=d.selection.createRange().text;else{if(d.getSelection)t=d.getSelection();else{if(w.getSelection)t=w.getSelection()}}void(w.open('$uri&title='+encodeURIComponent(d.title)+'&text='+encodeURIComponent(d.location.href)+encodeURIComponent('<br/><br/>')+encodeURIComponent(t),'_blank','scrollbars=yes,status=yes,resizable=yes,location=yes'))!;
    # Translate the phrase here to avoid ActivePerl DLL bug.
    $app->translate('<a href="[_1]">QuickPost to [_2]</a> - Drag this link to your browser\'s toolbar then click it when you are on a site you want to blog about.', encode_html($script), $blog->name);
}

sub can_view {
    my ( $eh, $app, $id, $objp ) = @_;
    my $perms = $app->permissions;
    if (   !$id
        && !$perms->can_create_post )
    {
        return 0;
    }
    if ($id) {
        my $obj = $objp->force();
        if ( !$perms->can_edit_entry( $obj, $app->user ) ) {
            return 0;
        }
    }
    1;
}

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();
    my $perms = $app->permissions;
    if ( !$perms || $perms->blog_id != $obj->blog_id ) {
        $perms ||= $author->permissions( $obj->blog_id );
    }
    return $perms && $perms->can_edit_entry( $obj, $author );
}

sub pre_save {
    my $eh = shift;
    my ( $app, $obj ) = @_;

    # save tags
    my $tags = $app->param('tags');
    if ( defined $tags ) {
        my $blog = $app->blog;
        my $fields = $blog->smart_replace_fields;
        if ( $fields =~ m/tags/ig ) {
            $tags = MT::App::CMS::_convert_word_chars( $app, $tags );
        }

        require MT::Tag;
        my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
        my @tags = MT::Tag->split( $tag_delim, $tags );
        if (@tags) {
            $obj->set_tags(@tags);
        }
        else {
            $obj->remove_tags();
        }
    }

    # update text heights if necessary
    if ( my $perms = $app->permissions ) {
        my $prefs = $perms->entry_prefs || $app->load_default_entry_prefs;
        my $text_height = $app->param('text_height');
        if ( defined $text_height ) {
            my ($pref_text_height) = $prefs =~ m/\bbody:(\d+)\b/;
            $pref_text_height ||= 0;
            if ( $text_height != $pref_text_height ) {
                if ( $prefs =~ m/\bbody\b/ ) {
                    $prefs =~ s/\bbody(:\d+)\b/body:$text_height/;
                }
                else {
                    $prefs = 'body:' . $text_height . ',' . $prefs;
                }
            }
        }
        if ( $prefs ne ( $perms->entry_prefs || '' ) ) {
            $perms->entry_prefs($prefs);
            $perms->save;
        }
    }
    $obj->discover_tb_from_entry();
    1;
}

sub post_save {
    my $eh = shift;
    my ( $app, $obj ) = @_;
    my $sess_obj = $app->autosave_session_obj;
    $sess_obj->remove if $sess_obj;
    1;
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    my $sess_obj = $app->autosave_session_obj;
    $sess_obj->remove if $sess_obj;

    $app->log(
        {
            message => $app->translate(
                "Entry '[_1]' (ID:[_2]) deleted by '[_3]'",
                $obj->title, $obj->id, $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'delete'
        }
    );
}

sub update_entry_status {
    my $app = shift;
    my ( $new_status, @ids ) = @_;
    return $app->errtrans("Need a status to update entries")
      unless $new_status;
    return $app->errtrans("Need entries to update status")
      unless @ids;
    my @bad_ids;
    my %rebuild_these;
    require MT::Entry;

    foreach my $id (@ids) {
        my $entry = MT::Entry->load($id)
          or return $app->errtrans(
            "One of the entries ([_1]) did not actually exist", $id );
        if ( $app->config('DeleteFilesAtRebuild')
            && ( MT::Entry::RELEASE() eq $entry->status ) )
        {
            my $archive_type =
              $entry->class eq 'page'
              ? 'Page'
              : 'Individual';
            $app->publisher->remove_entry_archive_file(
                Entry       => $entry,
                ArchiveType => $archive_type
            );
        }
        my $old_status = $entry->status;
        $entry->status($new_status);
        $entry->save() and $rebuild_these{$id} = 1;
        my $message = $app->translate(
            "[_1] '[_2]' (ID:[_3]) status changed from [_4] to [_5]",
            $entry->class_label,
            $entry->title,
            $entry->id,
            $app->translate( MT::Entry::status_text($old_status) ),
            $app->translate( MT::Entry::status_text($new_status) )
        );
        $app->log(
            {
                message  => $message,
                level    => MT::Log::INFO(),
                class    => $entry->class,
                category => 'edit',
                metadata => $entry->id
            }
        );
    }
    $app->rebuild_these( \%rebuild_these, how => MT::App::CMS::NEW_PHASE() );
}

sub _finish_rebuild_ping {
    my $app = shift;
    my ( $entry, $is_new, $ping_errors ) = @_;
    $app->redirect(
        $app->uri(
            'mode' => 'view',
            args   => {
                '_type' => $entry->class,
                blog_id => $entry->blog_id,
                id      => $entry->id,
                ( $is_new ? ( saved_added => 1 ) : ( saved_changes => 1 ) ),
                ( $ping_errors ? ( ping_errors => 1 ) : () )
            }
        )
    );
}

sub ping_continuation {
    my $app = shift;
    my ( $entry, $blog, %options ) = @_;
    my $list = $app->needs_ping(
        Entry     => $entry,
        Blog      => $blog,
        OldStatus => $options{OldStatus}
    );
    require MT::Entry;
    if ( $entry->status == MT::Entry::RELEASE() && $list ) {
        my @urls = map { { url => $_ } } @$list;
        $app->load_tmpl(
            'pinging.tmpl',
            {
                blog_id    => $blog->id,
                entry_id   => $entry->id,
                old_status => $options{OldStatus},
                is_new     => $options{IsNew},
                url_list   => \@urls,
            }
        );
    }
    else {
        _finish_rebuild_ping( $app, $entry, $options{IsNew} );
    }
}

sub delete {
    my $app = shift;
    $app->validate_magic() or return;
    require MT::Blog;
    my $q       = $app->param;
    my $blog_id = $q->param('blog_id');
    my $blog    = MT::Blog->load($blog_id)
        or return $app->error($app->translate('Can\'t load blog #[_1].', $blog_id));

    my $can_background =
        ( $blog->count_static_templates('Individual') == 0
            || MT::Util->launch_background_tasks() ) ? 1 : 0;

    my %rebuild_recip;
    for my $id ( $q->param('id') ) {
        my $class = $app->model("entry");
        my $obj   = $class->load($id);
        return $app->call_return unless $obj;

        $app->run_callbacks( 'cms_delete_permission_filter.entry', $app, $obj )
          || return $app->error(
            $app->translate( "Permission denied: [_1]", $app->errstr() ) );

        my %recip = $app->publisher->rebuild_deleted_entry(
            Entry => $obj,
            Blog  => $blog);

        # Remove object from database
        $obj->remove()
            or return $app->errtrans(
                'Removing [_1] failed: [_2]',
                $app->translate('entry'),
                $obj->errstr
            );
        $app->run_callbacks( 'cms_post_delete.entry', $app, $obj );
    }

    $app->add_return_arg( saved_deleted => 1 );
    if ( $q->param('is_power_edit') ) {
        $app->add_return_arg( is_power_edit => 1 );
    }

    if ( $app->config('RebuildAtDelete') ) {
        if ($can_background) {
            my $res = MT::Util::start_background_task(
                sub {
                    my $res = $app->rebuild_archives(
                        Blog             => $blog,
                        Recip            => \%rebuild_recip,
                    ) or return $app->publish_error();
                    $app->rebuild_indexes( Blog => $blog )
                        or return $app->publish_error();
                    $app->run_callbacks( 'rebuild', $blog );
                    1;
                }
            );
        }
        else {
            $app->rebuild_archives(
                Blog             => $blog,
                Recip            => \%rebuild_recip,
            ) or return $app->publish_error();
            $app->rebuild_indexes( Blog => $blog )
                or return $app->publish_error();

            $app->run_callbacks( 'rebuild', $blog );
        }

        $app->add_return_arg( no_rebuild => 1 );
        my %params = (
            is_full_screen  => 1,
            redirect_target => $app->app_path
              . $app->script . '?'
              . $app->return_args,
        );
        return $app->load_tmpl( 'rebuilding.tmpl', \%params );
    }

    return $app->call_return();
}

1;
