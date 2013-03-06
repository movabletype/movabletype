# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::CMS::Entry;

use strict;
use MT::Util qw( format_ts relative_date remove_html encode_html encode_js
    encode_url archive_file_for offset_time_list break_up_text first_n_words );
use MT::I18N qw( const wrap_text );

sub edit {
    my $cb = shift;
    my ( $app, $id, $obj, $param ) = @_;

    my $q          = $app->param;
    my $type       = $q->param('_type');
    my $perms      = $app->permissions;
    my $blog_class = $app->model('blog');
    my $blog       = $app->blog;
    my $blog_id    = $blog->id;
    my $author     = $app->user;
    my $class      = $app->model($type);

    if ($blog_id) {
        my $blog_class = $app->model('blog');
        my $blog       = $blog_class->load($blog_id);
        return $app->return_to_dashboard( redirect => 1 )
            if ( !$blog || ( !$blog->is_blog && $type eq 'entry' ) );
    }

    # to trigger autosave logic in main edit routine
    $param->{autosave_support} = 1;

    my $original_revision;
    if ($id) {
        return $app->error( $app->translate("Invalid parameter") )
            if $obj->class ne $type;

        if ( $blog->use_revision ) {
            $original_revision = $obj->revision;
            my $rn = $q->param('r');
            if ( defined($rn) && $rn != $obj->current_revision ) {
                my $status_text = MT::Entry::status_text( $obj->status );
                $param->{current_status_text} = $status_text;
                $param->{current_status_label}
                    = $app->translate($status_text);
                my $rev = $obj->load_revision( { rev_number => $rn } );
                if ( $rev && @$rev ) {
                    $obj = $rev->[0];
                    my $values = $obj->get_values;
                    $param->{$_} = $values->{$_} foreach keys %$values;
                    $param->{loaded_revision} = 1;
                }
                $param->{rev_number}       = $rn;
                $param->{no_snapshot}      = 1 if $q->param('no_snapshot');
                $param->{missing_cats_rev} = 1
                    if exists( $obj->{__missing_cats_rev} )
                        && $obj->{__missing_cats_rev};
                $param->{missing_tags_rev} = 1
                    if exists( $obj->{__missing_tags_rev} )
                        && $obj->{__missing_tags_rev};
            }
            $param->{rev_date} = format_ts( "%Y-%m-%d %H:%M:%S",
                $obj->modified_on, $blog,
                $app->user ? $app->user->preferred_language : undef );
        }

        $param->{nav_entries} = 1;
        $param->{entry_edit}  = 1;
        if ( $type eq 'entry' ) {
            $app->add_breadcrumb(
                $app->translate('Entries'),
                $app->uri(
                    'mode' => 'list',
                    args   => {
                        '_type' => 'entry',
                        blog_id => $blog_id
                    }
                )
            );
        }
        elsif ( $type eq 'page' ) {
            $app->add_breadcrumb(
                $app->translate('Pages'),
                $app->uri(
                    'mode' => 'list',
                    args   => {
                        '_type' => 'page',
                        blog_id => $blog_id
                    }
                )
            );
        }
        $app->add_breadcrumb( $obj->title || $app->translate('(untitled)') );
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
        $status =~ s/\D//g;
        $param->{status} = $status;
        $param->{ "status_" . MT::Entry::status_text($status) } = 1;
        if ((      $obj->status == MT::Entry::JUNK()
                || $obj->status == MT::Entry::REVIEW()
            )
            && $obj->junk_log
            )
        {
            build_junk_table( $app, param => $param, object => $obj );
        }
        $param->{ "allow_comments_"
                . ( $q->param('allow_comments') || $obj->allow_comments || 0 )
            } = 1;
        $param->{'authored_on_date'} = $q->param('authored_on_date')
            || format_ts( "%Y-%m-%d", $obj->authored_on, $blog,
            $app->user ? $app->user->preferred_language : undef );
        $param->{'authored_on_time'} = $q->param('authored_on_time')
            || format_ts( "%H:%M:%S", $obj->authored_on, $blog,
            $app->user ? $app->user->preferred_language : undef );

        $param->{num_comments} = $id ? $obj->comment_count : 0;
        $param->{num_pings}    = $id ? $obj->ping_count    : 0;

        # Check permission to send notifications and if the
        # blog has notification list subscribers
        if (   $perms->can_do('send_notifications')
            && $obj->status == MT::Entry::RELEASE() )
        {
            my $not_class = $app->model('notification');
            $param->{can_send_notifications} = 1;
            $param->{has_subscribers}
                = $not_class->exist( { blog_id => $blog_id } );
        }

        ## Load next and previous entries for next/previous links
        my $nextprev_option = {};
        if ( $type eq 'entry' ) {
            $nextprev_option->{author_id} = $author->id
                if !$app->can_do('edit_all_posts');
        }
        elsif ( $type eq 'page' ) {
            $nextprev_option->{author_id} = $author->id
                if !$app->can_do('edit_all_pages');
        }
        if ( my $next = $obj->next($nextprev_option) ) {
            $param->{next_entry_id} = $next->id;
        }
        if ( my $prev = $obj->previous($nextprev_option) ) {
            $param->{previous_entry_id} = $prev->id;
        }

        $param->{has_any_pinged_urls} = ( $obj->pinged_urls || '' ) =~ m/\S/;
        $param->{ping_errors}         = $q->param('ping_errors');
        $param->{can_view_log}        = $app->can_do('view_log');
        $param->{entry_permalink} = MT::Util::encode_html( $obj->permalink );
        $param->{'mode_view_entry'} = 1;
        $param->{'basename'}        = $obj->basename;

        if ( my $ts = $obj->authored_on ) {
            $param->{authored_on_ts} = $ts;
            $param->{authored_on_formatted}
                = format_ts( MT::App::CMS::LISTING_DATETIME_FORMAT(),
                $ts, $blog,
                $app->user ? $app->user->preferred_language : undef );
        }
        if ( my $id = $obj->author_id ) {
            my $obj_author = MT::Author->load($id);
            $param->{authored_by}
                = $obj_author
                ? $obj_author->name
                : MT->translate('*User deleted*');
        }

        $app->load_list_actions( $type, $param );
    }
    else {
        $param->{entry_edit} = 1;
        if ($blog_id) {
            if ( $type eq 'entry' ) {
                $app->add_breadcrumb(
                    $app->translate('Entries'),
                    $app->uri(
                        'mode' => 'list',
                        args   => {
                            '_type' => 'entry',
                            blog_id => $blog_id
                        }
                    )
                );
                $app->add_breadcrumb( $app->translate('New Entry') );
                $param->{nav_new_entry} = 1;
            }
            elsif ( $type eq 'page' ) {
                $app->add_breadcrumb(
                    $app->translate('Pages'),
                    $app->uri(
                        'mode' => 'list',
                        args   => {
                            '_type' => 'page',
                            blog_id => $blog_id
                        }
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
                or return $app->error(
                $app->translate( 'Cannot load blog #[_1].', $blog_id ) );
            $blog_timezone = $blog->server_offset();

            # new entry defaults used for new entries AND new pages.
            my $def_status;
            if ( $param->{status} ) {
                $def_status = $param->{status};
                $def_status =~ s/\D//g;
                $param->{status} = $def_status;
                $param->{ 'allow_comments_' . $q->param('allow_comments') }
                    = 1;
                $param->{allow_comments} = $q->param('allow_comments');
                $param->{allow_pings}    = $q->param('allow_pings');
            }
            else {

                # new edit
                $def_status = $blog->status_default;
                $param->{ 'allow_comments_' . $blog->allow_comments_default }
                    = 1;
                $param->{allow_comments} = $blog->allow_comments_default;
                $param->{allow_pings}    = $blog->allow_pings_default;
            }
            $param->{ "status_" . MT::Entry::status_text($def_status) } = 1;
        }

        require POSIX;
        my @now = offset_time_list( time, $blog );
        $param->{authored_on_date} = $q->param('authored_on_date')
            || POSIX::strftime( "%Y-%m-%d", @now );
        $param->{authored_on_time} = $q->param('authored_on_time')
            || POSIX::strftime( "%H:%M:%S", @now );
    }

    ## show the necessary associated assets
    if ( $type eq 'entry' || $type eq 'page' ) {
        require MT::Asset;
        require MT::ObjectAsset;
        my $assets = ();
        if ( $q->param('reedit') && $q->param('include_asset_ids') ) {
            my $include_asset_ids = $app->param('include_asset_ids');
            my @asset_ids = split( ',', $include_asset_ids );
            foreach my $asset_id (@asset_ids) {
                my $asset = MT::Asset->load($asset_id);
                if ($asset) {
                    my $asset_1;
                    if ( $asset->class eq 'image' ) {
                        $asset_1 = {
                            asset_id   => $asset->id,
                            asset_name => $asset->file_name,
                            asset_thumb =>
                                $asset->thumbnail_url( Width => 100 )
                        };
                    }
                    else {
                        $asset_1 = {
                            asset_id   => $asset->id,
                            asset_name => $asset->file_name
                        };
                    }
                    push @{$assets}, $asset_1;
                }
            }
        }
        elsif ( $q->param('asset_id') && !$id ) {
            my $asset   = MT::Asset->load( $q->param('asset_id') );
            my $asset_1 = {
                asset_id   => $asset->id,
                asset_name => $asset->file_name,
                asset_type => $asset->class
            };
            push @{$assets}, $asset_1;
        }
        elsif ($id) {
            my @assets = MT::Asset->load(
                { class => '*' },
                {   join => MT::ObjectAsset->join_on(
                        undef,
                        {   asset_id => \
                                '= asset_id',    # coloring editors hack'
                            object_ds => 'entry',
                            object_id => $id
                        }
                    )
                }
            );
            foreach my $asset (@assets) {
                my $asset_1;
                if ( $asset->class eq 'image' ) {
                    $asset_1 = {
                        asset_id    => $asset->id,
                        asset_name  => $asset->file_name,
                        asset_thumb => $asset->thumbnail_url( Width => 100 ),
                        asset_type  => $asset->class
                    };
                }
                else {
                    $asset_1 = {
                        asset_id   => $asset->id,
                        asset_name => $asset->file_name,
                        asset_type => $asset->class
                    };
                }
                push @{$assets}, $asset_1;
            }
        }
        $param->{asset_loop} = $assets;
    }

    ## Load categories and process into loop for category pull-down.
    require MT::Placement;
    my $cat_id = $param->{category_id};
    my $depth  = 0;
    my %places;

    # set the dirty flag in js?
    $param->{dirty} = $q->param('dirty') ? 1 : 0;

    if ($id) {
        my $cats = $obj->categories;
        %places = map { $_->id => 1 } @$cats;
    }
    my $cats = $q->param('category_ids');
    if ( defined $cats ) {
        if ( my @cats = grep { $_ =~ /^\d+/ } split /,/, $cats ) {
            $cat_id = $cats[0];
            %places = map { $_ => 1 } @cats;
        }
    }
    if ( $q->param('reedit') ) {
        $param->{reedit}          = 1;
        $param->{'basename'}      = $q->param('basename');
        $param->{'revision-note'} = $q->param('revision-note');
        if ( $q->param('save_revision') ) {
            $param->{'save_revision'} = 1;
        }
        else {
            $param->{'save_revision'} = 0;
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
    my $pref_param;
    if ($perms) {
        my $prefs_type = $type . '_prefs';
        $pref_param = $app->load_entry_prefs(
            { type => $type, prefs => $perms->$prefs_type } );
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

        require MT::ObjectTag;
        my $tags_js = MT::Util::to_json(
            [   map { $_->name } MT::Tag->load(
                    undef,
                    {   join => [
                            'MT::ObjectTag', 'tag_id',
                            { blog_id => $blog_id }, { unique => 1 }
                        ]
                    }
                )
            ]
        );
        $tags_js =~ s!/!\\/!g;
        $param->{tags_js} = $tags_js;

        $param->{can_edit_categories} = $perms->can_do('edit_categories');
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
            id       => -1,
            label    => '/',
            basename => '/',
            path     => [],
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
            id       => $_->{category_id},
            label    => $_->{category_label} . ( $type eq 'page' ? '/' : '' ),
            basename => $_->{category_basename}
                . ( $type eq 'page' ? '/' : '' ),
            path   => $_->{category_path_ids} || [],
            fields => $_->{category_fields}   || [],
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
        my @filters = split /\s*,\s*/, $filter;
        $entry_filters{$_} = 1 for @filters;
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
        if ( my $cond = $filters->{$filter}{condition} ) {
            $cond = MT->handler_to_coderef($cond) if !ref($cond);
            next unless $cond->($type);
        }
        push @{ $param->{text_filters} },
            {
            filter_key      => $filter,
            filter_label    => $filters->{$filter}{label},
            filter_selected => $entry_filters{$filter},
            filter_docs     => $filters->{$filter}{docs},
            };
    }
    $param->{text_filters} = [ sort { $a->{filter_key} cmp $b->{filter_key} }
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

    $app->setup_editor_param($param);

    $param->{object_type}  = $type;
    $param->{object_label} = $class->class_label;

    my @ordered = qw( title text tags excerpt keywords );
    if ($pref_param) {
        if ( my $disp_field = $pref_param->{disp_prefs_custom_fields} ) {
            my %order;
            my $i = 1;
            foreach (@$disp_field) {
                $order{ $_->{name} } = $i++;
            }
            foreach (@ordered) {
                $order{$_} = $i++ if !$order{$_};
            }
            @ordered = sort { $order{$a} <=> $order{$b} } @ordered;
        }
    }

    $param->{field_loop} ||= [
        map {
            {   field_name => $_,
                field_id   => $_,
                lock_field => ( $_ eq 'title' or $_ eq 'text' ),
                show_field => ( $_ eq 'title' or $_ eq 'text' )
                ? 1
                : $param->{"disp_prefs_show_$_"},
                field_label => $app->translate( ucfirst($_) ),
            }
            } @ordered
    ];

    $param->{quickpost_js} = MT::CMS::Entry::quickpost_js( $app, $type );
    if ( 'page' eq $type ) {
        $param->{search_label} = $app->translate('pages');
        $param->{output}       = 'edit_entry.tmpl';
        $param->{screen_class} = 'edit-page edit-entry';
    }
    $param->{sitepath_configured} = $blog && $blog->site_path ? 1 : 0;
    if ( $blog->use_revision ) {
        $param->{use_revision} = 1;

      #TODO: the list of revisions won't appear on the edit screen.
      #    $param->{revision_table} = $app->build_page(
      #        MT::CMS::Common::build_revision_table(
      #            $app,
      #            object => $obj || $class->new,
      #            param => {
      #                template => 'include/revision_table.tmpl',
      #                args     => {
      #                    sort_order => 'rev_number',
      #                    direction  => 'descend',
      #                    limit      => 5,              # TODO: configurable?
      #                },
      #                revision => $original_revision
      #                  ? $original_revision
      #                  : $obj
      #                    ? $obj->revision || $obj->current_revision
      #                    : 0,
      #            }
      #        ),
      #        { show_actions => 0, hide_pager => 1 }
      #    );
    }
    1;
}

sub build_junk_table {
    my $app = shift;
    my (%args) = @_;

    my $param = $args{param};
    my $obj   = $args{object};

    # if ( defined $obj->junk_score ) {
    #     $param->{junk_score} =
    #       ( $obj->junk_score > 0 ? '+' : '' ) . $obj->junk_score;
    # }
    my $log = $obj->junk_log || '';
    my @log = split /\r?\n/, $log;
    my @junk;
    for ( my $i = 0; $i < scalar(@log); $i++ ) {
        my $line = $log[$i];
        $line =~ s/(^\s+|\s+$)//g;
        next unless $line;
        last if $line =~ m/^--->/;
        my ( $test, $score, $log );
        ($test) = $line =~ m/^([^:]+?):/;
        if ( defined $test ) {
            ($score) = $test =~ m/\(([+-]?\d+?(?:\.\d*?)?)\)/;
            $test =~ s/\(.+\)//;
        }
        if ( defined $score ) {
            $score =~ s/\+//;
            $score .= '.0' unless $score =~ m/\./;
            $score = ( $score > 0 ? '+' : '' ) . $score;
        }
        $log = $line;
        $log =~ s/^[^:]+:\s*//;
        $log = encode_html($log);
        for ( my $j = $i + 1; $j < scalar(@log); $j++ ) {
            my $line = encode_html( $log[$j] );
            if ( $line =~ m/^\t+(.*)$/s ) {
                $i = $j;
                $log .= "<br />" . $1;
            }
            else {
                last;
            }
        }
        push @junk, { test => $test, score => $score, log => $log };
    }
    $param->{junk_log_loop} = \@junk;
    \@junk;
}

sub list {
    my $app = shift;
    my ($param) = @_;
    $param ||= {};

    require MT::Entry;
    my $type = $app->param('type') || MT::Entry->class_type;
    my $pkg = $app->model($type) or return "Invalid request.";

    my $q     = $app->param;
    my $perms = $app->permissions;

    my $list_pref = $app->list_pref($type);
    my %param     = %$list_pref;
    my $blog_id   = $q->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 )
        unless $blog_id;
    my $blog = $app->model('blog')->load($blog_id);
    return $app->return_to_dashboard( redirect => 1 )
        unless $blog;

    my $perm_action
        = $type eq 'page'
        ? 'access_to_page_list'
        : 'access_to_entry_list';
    my $perm_action_all
        = $type eq 'page'
        ? 'edit_all_pages'
        : 'edit_all_entries';
PERMCHECK: {
        if ($blog_id) {
            last PERMCHECK if $app->can_do($perm_action);
        }
        else {
            last PERMCHECK
                if $app->user->can_do( $perm_action, at_least_one => 1 );
        }
        return $app->permission_denied();
    }

    my %terms;
    my $blog_ids;
    if ($blog_id) {
        $blog_ids = $app->_load_child_blog_ids($blog_id);
        push @$blog_ids, $blog_id;
    }
    my $terms_ref = \%terms;

    if ($app->user->is_superuser) {
        $terms{blog_id} = $blog_ids;
    }
    else {
        my @permissions = 
            grep { $_->can_do($perm_action) }
            $app->model('permission')->load( 
                { 
                    author_id => $app->user->id, 
                    ( $blog_id ? ( blog_id => $blog_ids ) : () ),
                } );
        my @full_perms = 
            grep { $_->can_do($perm_action_all) } 
            @permissions;
        my @self_perms = 
            grep { not $_->can_do($perm_action_all) } 
            @permissions;
        if (0 == @self_perms) {
            $terms{blog_id} = [ map { $_->blog_id } @full_perms ];
        }
        elsif (0 == @full_perms) {
            $terms{blog_id} = [ map { $_->blog_id } @self_perms ];
            $terms{author_id} = $app->user->id;
        }
        else {
            $terms_ref = 
                [ 
                    \%terms, 
                    '-and',
                    [
                        { 
                            blog_id => [ map { $_->blog_id } @full_perms ],
                        },
                        '-or',
                        {
                            blog_id => [ map { $_->blog_id } @self_perms ],
                            author_id => $app->user->id,
                        }
                    ],  
                ];
        }
    }

    $terms{class}   = $type;
    my $limit = $list_pref->{rows};
    my $offset = $app->param('offset') || 0;

    my %arg;
    $arg{'sort'} = $type eq 'page' ? 'modified_on' : 'authored_on';
    $arg{direction} = 'descend';
    my $filter_key = $q->param('filter_key') || '';
    my $filter_col = $q->param('filter')     || '';
    my $filter_val = $q->param('filter_val');
    my $iter_method;
    my $total;

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
            my $asset       = $asset_class->load($filter_val);
            return $app->errtrans( "Load failed: [_1]", $asset_class->errstr )
                unless $asset;
            if ( $asset->blog_id != $blog_id ) {
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
                    {   object_ds => $type,
                        asset_id  => $filter_val
                    },
                    { unique => 1 }
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
                my @tags = MT::Tag->load(
                    { name   => [@filter_tags] },
                    { binary => { name => 1 } }
                );
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
                    {   tag_id            => \@tag_ids,
                        object_datasource => $pkg->datasource
                    },
                    { unique => 1 }
                );
            }
            else {
                if ( $pkg->is_meta_column($filter_col) ) {
                    my $meta_rec
                        = MT::Meta->metadata_by_name( $pkg, $filter_col );
                    my $type_col   = $meta_rec->{type};
                    my $type_id    = $meta_rec->{name};
                    my $meta_terms = {
                        $type_col => $filter_val,
                        type      => $type_id,
                    };
                    $total = $pkg->meta_pkg->count($meta_terms);
                    my @result
                        = $pkg->search_by_meta( $filter_col, $filter_val, {},
                        \%arg );
                    $iter_method = sub {
                        return shift @result;
                    };
                }
                elsif ( $pkg->has_column($filter_col) ) {
                    $terms{$filter_col} = $filter_val;
                }
            }
            $param{filter_args} = "&filter=" . encode_url($filter_col);
            if ( ref($filter_val) eq 'ARRAY' ) {
                foreach my $_v (@$filter_val) {
                    $param{filter_args} .= "&filter_val=" . encode_url($_v);
                }
            }
            else {
                $param{filter_args}
                    .= "&filter_val=" . encode_url($filter_val);
            }

            if (   ( $filter_col eq 'normalizedtag' )
                || ( $filter_col eq 'exacttag' ) )
            {
                $filter_name  = $app->translate('Tag');
                $filter_value = $filter_val;
            }
            elsif ( $filter_col eq 'author_id' ) {
                $filter_name = $app->translate('User');
                my $author = MT::Author->load($filter_val);
                return $app->errtrans( "Load failed: [_1]",
                    MT::Author->errstr )
                    unless $author;
                $filter_value = $author->name;

                # Special case, set author name as well as filter_val
                $param{filter_value} = $filter_value;
            }
            elsif ( $filter_col eq 'status' ) {
                $filter_name = $app->translate('Entry Status');
                $filter_value
                    = $app->translate( MT::Entry::status_text($filter_val) );
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
        my $filters = $app->registry( "list_filters", "entry" ) || {};
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

    if ( !exists( $terms{status} ) ) {
        $terms{status} = { not => MT->model('entry')->JUNK };
    }

    require MT::Category;
    require MT::Placement;

    $total = $pkg->count( $terms_ref, \%arg ) || 0
        unless defined $total;
    $arg{limit} = $limit + 1;
    if ( $total <= $limit ) {
        delete $arg{limit};
        $offset = 0;
    }
    else {
        $arg{offset} = $offset if $offset;
    }

    my $iter = $iter_method || $pkg->load_iter( $terms_ref, \%arg );

    my $is_power_edit = $q->param('is_power_edit');
    if ($is_power_edit) {
        $param{has_expanded_mode} = 0;
        delete $param{view_expanded};
    }
    else {
        $param{has_expanded_mode} = 1;
    }
    my $data = build_entry_table(
        $app,
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
        {   'join' => $pkg->join_on(
                'author_id',
                { $blog_id ? ( blog_id => $blog_id ) : () },
                {   'unique'  => 1,
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

    $param{page_actions}   = $app->page_actions( $app->mode );
    $param{list_filters}   = $app->list_filters('entry');
    $param{can_power_edit} = $blog_id && !$is_power_edit;
    $param{can_republish}
        = $blog_id
        ? $perms->can_do('rebuild')
        : $app->user->is_superuser;
    $param{blog_view}           = 1 if $blog->is_blog;
    $param{is_power_edit}       = $is_power_edit;
    $param{saved_deleted}       = $q->param('saved_deleted');
    $param{no_rebuild}          = $q->param('no_rebuild');
    $param{saved}               = $q->param('saved');
    $param{limit}               = $limit;
    $param{offset}              = $offset;
    $param{object_type}         = $type;
    $param{object_label}        = $pkg->class_label;
    $param{object_label_plural} = $param{search_label}
        = $pkg->class_label_plural;
    $param{list_start} = $offset + 1;
    $param{list_end}   = $offset + scalar @$data;
    $param{list_total} = $total;
    $param{next_max}
        = $param{next_offset}
        ? int( $param{list_total} / $limit ) * $limit
        : 0;
    $param{nav_entries} = 1;
    $param{feed_label}  = $app->translate( "[_1] Feed", $pkg->class_label );
    $param{feed_url}    = $app->make_feed_link( $type,
        $blog_id ? { blog_id => $blog_id } : undef );
    $app->add_breadcrumb( $pkg->class_label_plural );
    $param{listing_screen} = 1;

    unless ($blog_id) {
        $param{system_overview_nav} = 1;
    }
    $param{container_label} = $pkg->container_label;
    unless ( $param{screen_class} ) {
        $param{screen_class} = "list-$type";
        $param{screen_class} .= " list-entry"
            if $param{object_type} eq
                "page";    # to piggyback on list-entry styles
    }
    $param{mode} = $app->mode;
    if ( my $blog = MT::Blog->load($blog_id) ) {
        $param{sitepath_unconfigured} = $blog->site_path ? 0 : 1;
    }

    $param->{return_args} ||= $app->make_return_args;
    my @return_args = grep { $_ !~ /offset=\d/ } split /&/,
        $param->{return_args};
    $param{return_args} = join '&', @return_args;
    $param{screen_id}   = "list-entry";
    $param{screen_id}   = "list-page"
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
    my $app = shift;

    $app->validate_magic or return;

    my $entry = _create_temp_entry($app);

    return _build_entry_preview( $app, $entry );
}

sub _create_temp_entry {
    my $app         = shift;
    my $type        = $app->param('_type') || 'entry';
    my $entry_class = $app->model($type);
    my $blog_id     = $app->param('blog_id');
    my $blog        = $app->blog;
    my $id          = $app->param('id');
    my $entry;
    my $user_id = $app->user->id;

    if ($id) {
        $entry = $entry_class->load( { id => $id, blog_id => $blog_id } )
            or return $app->errtrans("Invalid request.");
        $user_id = $entry->author_id;
    }
    else {
        $entry = $entry_class->new;
        $entry->author_id($user_id);
        $entry->id(-1);    # fake out things like MT::Taggable::__load_tags
        $entry->blog_id($blog_id);
    }

    return $app->return_to_dashboard( permission => 1 )
        unless $app->permissions->can_edit_entry( $entry, $app->user );

    my $names = $entry->column_names;
    my %values = map { $_ => scalar $app->param($_) } @$names;
    delete $values{'id'} unless $app->param('id');
    ## Strip linefeed characters.
    for my $col (qw( text excerpt text_more keywords )) {
        $values{$col} =~ tr/\r//d if $values{$col};
    }
    $values{allow_comments} = 0
        if !defined( $values{allow_comments} )
            || $app->param('allow_comments') eq '';
    $values{allow_pings} = 0
        if !defined( $values{allow_pings} )
            || $app->param('allow_pings') eq '';
    $entry->set_values( \%values );

    return $entry;
}

sub _build_entry_preview {
    my $app = shift;
    my ( $entry, %param ) = @_;
    my $q           = $app->param;
    my $type        = $q->param('_type') || 'entry';
    my $entry_class = $app->model($type);
    my $blog_id     = $q->param('blog_id');
    my $blog        = $app->blog;
    my $id          = $q->param('id');
    my $user_id     = $app->user->id;
    my $cat;
    my $cat_ids = $q->param('category_ids');

    if ($cat_ids) {
        my @cats = split /,/, $cat_ids;
        if (@cats) {
            my $primary_cat = $cats[0];
            $cat = MT::Category->load(
                { id => $primary_cat, blog_id => $blog_id } );
            my @categories
                = MT::Category->load( { id => \@cats, blog_id => $blog_id } );
            $entry->cache_property( 'category',   undef, $cat );
            $entry->cache_property( 'categories', undef, \@categories );
        }
    }
    else {
        $entry->cache_property( 'category', undef, undef );
        $entry->cache_property( 'categories', undef, [] );
    }
    my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
    my @tag_names = MT::Tag->split( $tag_delim, $q->param('tags') );
    if (@tag_names) {
        my @tags;
        foreach my $tag_name (@tag_names) {
            my $tag = MT::Tag->new;
            $tag->name($tag_name);
            $tag->is_private( $tag_name =~ m/^@/ ? 1 : 0 );
            push @tags, $tag;
        }
        $entry->{__tags}        = \@tag_names;
        $entry->{__tag_objects} = \@tags;
    }

    my $date = $q->param('authored_on_date');
    my $time = $q->param('authored_on_time');
    my $ts   = $date . $time;
    $ts =~ s/\D//g;
    $entry->authored_on($ts);

    my $preview_basename = $app->preview_object_basename;
    $entry->basename( $q->param('basename') || $preview_basename );

    # translates naughty words when PublishCharset is NOT UTF-8
    MT::Util::translate_naughty_words($entry);

    $entry->convert_breaks( scalar $q->param('convert_breaks') );

    my @data = ( { data_name => 'author_id', data_value => $user_id } );
    $app->run_callbacks( 'cms_pre_preview', $app, $entry, \@data );

    require MT::TemplateMap;
    require MT::Template;
    my $at = $type eq 'page' ? 'Page' : 'Individual';
    my $tmpl_map = MT::TemplateMap->load(
        {   archive_type => $at,
            is_preferred => 1,
            blog_id      => $blog_id,
        }
    );

    my $tmpl;
    my $fullscreen;
    my $archive_file;
    my $orig_file;
    my $file_ext;
    if ($tmpl_map) {
        $tmpl         = MT::Template->load( $tmpl_map->template_id );
        $file_ext     = $blog->file_extension || '';
        $archive_file = $entry->archive_file;

        my $blog_path
            = $type eq 'page'
            ? $blog->site_path
            : ( $blog->archive_path || $blog->site_path );
        $archive_file = File::Spec->catfile( $blog_path, $archive_file );
        require File::Basename;
        my $path;
        ( $orig_file, $path ) = File::Basename::fileparse($archive_file);
        $file_ext = '.' . $file_ext if $file_ext ne '';
        $archive_file
            = File::Spec->catfile( $path, $preview_basename . $file_ext );
    }
    else {
        $tmpl       = $app->load_tmpl('preview_entry_content.tmpl');
        $fullscreen = 1;
    }
    return $app->error( $app->translate('Cannot load template.') )
        unless $tmpl;

    my $ctx = $tmpl->context;
    $ctx->stash( 'entry',    $entry );
    $ctx->stash( 'blog',     $blog );
    $ctx->stash( 'category', $cat ) if $cat;
    $ctx->{current_timestamp}    = $ts;
    $ctx->{current_archive_type} = $at;
    $ctx->var( 'preview_template', 1 );

    my $archiver = MT->publisher->archiver($at);
    if ( my $params = $archiver->template_params ) {
        $ctx->var( $_, $params->{$_} ) for keys %$params;
    }

    my $html = $tmpl->output;

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
    my ( $old_url, $new_url );
    if ( $app->config('LocalPreviews') ) {
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
            unless $path eq '/'; ## OS X doesn't like / at the end in mkdir().
        unless ( $fmgr->exists($path) ) {
            $fmgr->mkpath($path);
        }

        if ( $fmgr->exists($path) && $fmgr->can_write($path) ) {
            $fmgr->put_data( $html, $archive_file );
            $param{preview_file} = $preview_basename;
            my $preview_url = $entry->archive_url;
            $preview_url
                =~ s! / \Q$orig_file\E ( /? ) $!/$preview_basename$file_ext$1!x;

            # We also have to translate the URL used for the
            # published file to be on the MT app domain.
            if ( defined $new_url ) {
                $preview_url =~ s!^\Q$old_url\E!$new_url!;
            }

            $param{preview_url} = $preview_url;

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
            $fullscreen = 1;
            $param{preview_error}
                = $app->translate(
                "Unable to create preview files in this location: [_1]",
                $path );
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
    $param{title}      = $entry->title;
    $param{status}     = $entry->status;
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
                || $col eq 'ping_count'
                || $col eq 'current_revision';
        push @data,
            {
            data_name  => $col,
            data_value => scalar $q->param($col)
            };
    }
    for my $data (
        qw( authored_on_date authored_on_time basename_manual basename_old category_ids tags include_asset_ids save_revision revision-note )
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
        $list_mode  = 'page';
    }
    else {
        $list_title = 'Entries';
        $list_mode  = 'entry';
    }
    if ($id) {
        $app->add_breadcrumb(
            $app->translate($list_title),
            $app->uri(
                'mode' => 'list',
                args   => {
                    '_type' => $list_mode,
                    blog_id => $blog_id
                }
            )
        );
        $app->add_breadcrumb( $entry->title
                || $app->translate('(untitled)') );
    }
    else {
        $app->add_breadcrumb(
            $app->translate($list_title),
            $app->uri(
                'mode' => 'list',
                args   => {
                    '_type' => $list_mode,
                    blog_id => $blog_id
                }
            )
        );
        $app->add_breadcrumb(
            $app->translate( 'New [_1]', $entry_class->class_label ) );
        $param{nav_new_entry} = 1;
    }
    $param{object_type}  = $type;
    $param{object_label} = $entry_class->class_label;

    $param{diff_view} = $app->param('rev_numbers')
        || $app->param('collision');
    $param{collision} = 1;
    if ( my @rev_numbers = split /,/, $app->param('rev_numbers') ) {
        $param{comparing_revisions} = 1;
        $param{rev_a}               = $rev_numbers[0];
        $param{rev_b}               = $rev_numbers[1];
    }
    $param{dirty} = $q->param('dirty') ? 1 : 0;

    if ($fullscreen) {
        return $app->load_tmpl( 'preview_entry.tmpl', \%param );
    }
    else {
        $app->request( 'preview_object', $entry );
        return $app->load_tmpl( 'preview_strip.tmpl', \%param );
    }
}

sub cfg_entry {
    my $app     = shift;
    my $q       = $app->param;
    my $blog_id = scalar $q->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 )
        unless $blog_id;
    return $app->permission_denied()
        unless $app->can_do('edit_config');
    $q->param( '_type', 'blog' );
    $q->param( 'id',    scalar $q->param('blog_id') );
    $app->forward(
        "view",
        {   output       => 'cfg_entry.tmpl',
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
        or return $app->errtrans("Invalid parameter");

    my $cat_class = $app->model( $class->container_type );

    my $perms = $app->permissions
        or return $app->permission_denied();

    my $id = $app->param('id');
    if ( !$id ) {
        if ( $type eq 'page' ) {
            return $app->permission_denied()
                unless $perms->can_do('create_new_page');
        }
        elsif ( $type eq 'entry' ) {
            return $app->permission_denied()
                unless $perms->can_do('create_new_entry');
        }
        else {
            return $app->errtrans("Invalid request.");
        }
    }
    else {
        if ( $type eq 'page' ) {
            return $app->permission_denied()
                unless $perms->can_do('edit_all_pages');
        }
    }

    # check for autosave
    if ( $app->param('_autosave') ) {
        return $app->autosave_object();
    }

    require MT::Blog;
    my $blog_id = $app->param('blog_id');
    my $blog    = MT::Blog->load($blog_id)
        or return $app->error(
        $app->translate( 'Cannot load blog #[_1].', $blog_id ) );

    my $archive_type;

    my ( $obj, $orig_obj, $orig_file );
    if ($id) {
        $obj = $class->load($id)
            || return $app->error(
            $app->translate( "No such [_1].", $class->class_label ) );
        return $app->error( $app->translate("Invalid parameter") )
            unless $obj->blog_id == $blog_id;
        if ( $type eq 'entry' ) {
            return $app->permission_denied()
                unless $perms->can_edit_entry( $obj, $author );
            return $app->permission_denied()
                if ( $obj->status ne $app->param('status') )
                && !( $perms->can_edit_entry( $obj, $author, 1 ) );
            $archive_type = 'Individual';
        }
        elsif ( $type eq 'page' ) {
            $archive_type = 'Page';
        }
        else {
            return $app->errtrans("Invalid request.");
        }
        $orig_obj = $obj->clone;
        $orig_file = archive_file_for( $orig_obj, $blog, $archive_type );
    }
    else {
        $obj      = $class->new;
        $orig_obj = $obj->clone;
    }

    my $primary_category_old = $orig_obj->category;
    my $categories_old       = $orig_obj->categories;
    my $status_old           = $id ? $obj->status : 0;
    my $names                = $obj->column_names;

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
        unless $perms->can_do("edit_${type}_basename");
    require MT::Entry;
    $values{status} = MT::Entry::FUTURE() if $app->param('scheduled');
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
            my $exist = $class->exist(
                { blog_id => $blog_id, basename => $basename } );
            if ($exist) {
                $obj->basename( MT::Util::make_unique_basename($obj) );
            }
        }
    }

    # Cut a basename by blog settings
    if ( $app->param('basename_manual') ) {
        first_n_words( $obj->basename, $blog->basename_limit );
    }

    if ( $type eq 'page' ) {

        # -1 is a special id for identifying the 'root' folder
        $cat_id = 0 if $cat_id == -1;
        my $dup_it = $class->load_iter(
            {   blog_id  => $blog_id,
                basename => $obj->basename,
                class    => 'page',
                ( $id ? ( id => $id ) : () )
            },
            { ( $id ? ( not => { id => 1 } ) : () ) }
        );
        while ( my $p = $dup_it->() ) {
            my $p_folder = $p->folder;
            my $dup_folder_path
                = defined $p_folder ? $p_folder->publish_path() : '';
            my $folder = MT::Folder->load($cat_id) if $cat_id;
            my $folder_path = defined $folder ? $folder->publish_path() : '';
            return $app->error(
                $app->translate(
                    "This basename has already been used. You should use an unique basename."
                )
            ) if ( $dup_folder_path eq $folder_path );
        }

    }

    if ( $type eq 'entry' ) {
        $obj->status( MT::Entry::HOLD() )
            if !$id
                && !$perms->can_do('publish_own_entry')
                && !$perms->can_do('publish_all_entry');
    }

    my $filter_result
        = $app->run_callbacks( 'cms_save_filter.' . $type, $app );

    if ( !$filter_result ) {
        my %param = ();
        $param{error}       = $app->errstr;
        $param{return_args} = $app->param('return_args');
        $app->param( 'reedit', 1 );
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
    if ( $perms->can_do("edit_${type}_authored_on") && ($ao_d) ) {
        my %param = ();
        my $ao    = $ao_d . ' ' . $ao_t;
        unless ( $ao
            =~ m!^(\d{4})-(\d{1,2})-(\d{1,2})\s+(\d{1,2}):(\d{1,2})(?::(\d{1,2}))?$!
            )
        {
            $param{error} = $app->translate(
                "Invalid date '[_1]'; 'Published on' dates must be in the format YYYY-MM-DD HH:MM:SS.",
                $ao
            );
        }
        unless ( $param{error} ) {
            my $s = $6 || 0;
            $param{error} = $app->translate(
                "Invalid date '[_1]'; 'Published on' dates should be real dates.",
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
        }
        $param{return_args} = $app->param('return_args');
        return $app->forward( "view", \%param ) if $param{error};
        if ( $obj->authored_on ) {
            $previous_old = $obj->previous(1);
            $next_old     = $obj->next(1);
        }
        my $ts = sprintf "%04d%02d%02d%02d%02d%02d", $1, $2, $3, $4, $5,
            ( $6 || 0 );
        $obj->authored_on($ts);
    }
    my $is_new = $obj->id ? 0 : 1;

    MT::Util::translate_naughty_words($obj);

    $app->run_callbacks( 'cms_pre_save.' . $type, $app, $obj, $orig_obj )
        || return $app->error(
        $app->translate(
            "Saving [_1] failed: [_2]",
            $class->class_label, $app->errstr
        )
        );

    # Setting modified_by updates modified_on which we want to do before
    # a save but after pre_save callbacks fire.
    $obj->modified_by( $author->id ) unless $is_new;

    $obj->save
        or return $app->error(
        $app->translate(
            "Saving [_1] failed: [_2]",
            $class->class_label, $obj->errstr
        )
        );

    ## look if any assets have been included/removed from this entry
    require MT::Asset;
    require MT::ObjectAsset;
    my $include_asset_ids = $app->param('include_asset_ids');
    my @asset_ids         = split( ',', $include_asset_ids );
    my $obj_assets        = ();
    my @obj_assets        = MT::ObjectAsset->load(
        { object_ds => 'entry', object_id => $obj->id } );
    foreach my $obj_asset (@obj_assets) {
        my $asset_id = $obj_asset->asset_id;
        $obj_assets->{$asset_id} = 1;
    }
    my $seen = ();
    foreach my $asset_id (@asset_ids) {
        my $obj_asset = MT::ObjectAsset->load(
            {   asset_id  => $asset_id,
                object_ds => 'entry',
                object_id => $obj->id
            }
        );
        unless ($obj_asset) {
            my $obj_asset = new MT::ObjectAsset;
            $obj_asset->blog_id($blog_id);
            $obj_asset->asset_id($asset_id);
            $obj_asset->object_ds('entry');
            $obj_asset->object_id( $obj->id );
            $obj_asset->save;
        }
        $seen->{$asset_id} = 1;
    }
    foreach my $asset_id ( keys %{$obj_assets} ) {
        unless ( $seen->{$asset_id} ) {
            my $obj_asset = MT::ObjectAsset->load(
                {   asset_id  => $asset_id,
                    object_ds => 'entry',
                    object_id => $obj->id
                }
            );
            $obj_asset->remove;
        }
    }

    my $message;
    if ($is_new) {
        $message
            = $app->translate( "[_1] '[_2]' (ID:[_3]) added by user '[_4]'",
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
        $message
            = $app->translate( "[_1] '[_2]' (ID:[_3]) edited by user '[_4]'",
            $class->class_label, $obj->title, $obj->id, $author->name );
    }
    require MT::Log;
    $app->log(
        {   message => $message,
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
    my $place
        = MT::Placement->load( { entry_id => $obj->id, is_primary => 1 } );
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
        if ($place) {
            $place->remove;
            $obj->cache_property( 'category', undef, undef );
        }
    }

    my $placements_updated;

    # save secondary placements...
    my @place = MT::Placement->load(
        {   entry_id   => $obj->id,
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
            $app->translate(
                "Saving placement failed: [_1]", $place->errstr
            )
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
            if ( $file ne $orig_file || $obj->status != MT::Entry::RELEASE() )
            {
                $app->publisher->remove_entry_archive_file(
                    Entry       => $orig_obj,
                    ArchiveType => $archive_type,
                    Category    => $primary_category_old,
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
                        Entry => $obj,
                        (   $obj->is_entry
                            ? ( BuildDependencies => 1 )
                            : ( BuildIndexes => 1 )
                        ),
                        ( $obj->is_entry ? ( OldEntry => $orig_obj ) : () ),
                        (   $obj->is_entry
                            ? ( OldPrevious => ($previous_old)
                                ? $previous_old->id
                                : undef
                                )
                            : ()
                        ),
                        (   $obj->is_entry
                            ? ( OldNext => ($next_old)
                                ? $next_old->id
                                : undef
                                )
                            : ()
                        ),
                    ) or return $app->publish_error();
                    $app->run_callbacks( 'rebuild', $blog );
                    $app->run_callbacks('post_build');
                    1;
                }
            );
            return unless $res;
            return ping_continuation(
                $app,
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
                        old_categories =>
                            join( ',', map { $_->id } @$categories_old ),
                        (   $previous_old
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
    my $app     = shift;
    my $perms   = $app->permissions;
    my $type    = $app->param('_type');
    my $blog_id = $app->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 )
        unless $blog_id;
    my $blog = $app->model('blog')->load($blog_id);
    return $app->return_to_dashboard( redirect => 1 )
        unless $blog;

PERMCHECK: {
        my $action
            = $type eq 'page'
            ? 'save_multiple_pages'
            : 'save_multiple_entries';
        if ($blog_id) {
            if ( $blog->is_blog ) {
                last PERMCHECK if $app->can_do($action);
            }
            else {
                my $blogs = $blog->blogs;
                my $blog_ids;
                my @map = map { $_->id } @$blogs;
                push @$blog_ids, map { $_->id } @{ $blog->blogs };

                my $terms = {
                    author_id => $app->user->id,
                    ( $blog_ids ? ( blog_id => $blog_ids ) : () ),
                };
                my $iter = MT->model('permission')->load_iter($terms);
                if ($iter) {
                    my $cond = 1;
                    while ( my $p = $iter->() ) {
                        last if !$p->can_do($action);
                    }
                    last PERMCHECK if $cond;
                }
            }
        }
        else {
            last PERMCHECK
                if $app->user->can_do( $action, at_least_one => 1 );
        }
        return $app->permission_denied();
    }

    $app->validate_magic() or return;

    my $q = $app->param;
    my @p = $q->param;
    require MT::Entry;
    require MT::Placement;
    require MT::Log;
    my $this_author    = $app->user;
    my $this_author_id = $this_author->id;
    my @objects;

    for my $p (@p) {
        next unless $p =~ /^author_id_(\d+)/;
        my $id    = $1;
        my $entry = MT::Entry->load($id)
            or next;
        my $old_status = $entry->status;
        my $orig_obj   = $entry->clone;
        $perms = $app->user->permissions( $entry->blog_id );
        if ( $perms->can_edit_entry( $entry, $this_author ) ) {
            my $author_id = $q->param( 'author_id_' . $id );
            $entry->author_id( $author_id ? $author_id : 0 );
            $entry->title( scalar $q->param( 'title_' . $id )
                    || scalar $q->param( 'no_title_' . $id ) );
        }
        else {
            return $app->permission_denied();
        }
        if ( $perms->can_edit_entry( $entry, $this_author, 1 ) )
        {    ## can he/she change status?
            $entry->status( scalar $q->param( 'status_' . $id ) );

            my $date_closure = sub {
                my ( $val, $col, $name ) = @_;
                unless ( $val
                    =~ m!(\d{4})-(\d{2})-(\d{2})\s+(\d{2}):(\d{2})(?::(\d{2}))?!
                    )
                {
                    return $app->error(
                        $app->translate(
                            "Invalid date '[_1]'; [_2] dates must be in the format YYYY-MM-DD HH:MM:SS.",
                            $val,
                            $name
                        )
                    );
                }
                my $s = $6 || 0;

                # Emit an error message if the date is bogus.
                return $app->error(
                    $app->translate(
                        "Invalid date '[_1]'; [_2] dates should be real dates.",
                        $val,
                        $name
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
                my $ts = sprintf "%04d%02d%02d%02d%02d%02d", $1, $2, $3, $4,
                    $5, $s;
                $entry->$col($ts);
            };

            my $co = $q->param( 'created_on_' . $id );
            $date_closure->(
                $co, 'authored_on', MT->translate('authored on')
            ) or return;
            $co = $q->param( 'modified_on_' . $id );
            $date_closure->(
                $co, 'modified_on', MT->translate('modified on')
            ) or return;
        }
        $app->run_callbacks( 'cms_pre_save.' . $type,
            $app, $entry, $orig_obj )
            || return $app->error(
            $app->translate(
                "Saving [_1] failed: [_2]", $entry->class_label,
                $app->errstr
            )
            );
        $entry->save
            or return $app->error(
            $app->translate(
                "Saving entry '[_1]' failed: [_2]", $entry->title,
                $entry->errstr
            )
            );

        # If Status was changed from PUBLISH to others,
        # Let's remove archive files.
        if (   ( $entry->status || 0 ) != MT::Entry::RELEASE()
            && $old_status == MT::Entry::RELEASE()
            && $app->config('DeleteFilesAtRebuild') )
        {
            if ( my $blog = $entry->blog ) {
                my $archive_type = 'entry' eq $type ? 'Individual' : 'Page';
                my $file = archive_file_for( $entry, $blog, $archive_type );
                $app->publisher->remove_entry_archive_file(
                    Entry       => $entry,
                    ArchiveType => $archive_type,
                );
            }
        }

        my $cat_id = $q->param("category_id_$id");
        my $place  = MT::Placement->load(
            {   entry_id   => $id,
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
            $place->category_id($cat_id);
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
                $app->translate(
                    MT::Entry::status_text( $orig_obj->status )
                ),
                $app->translate( MT::Entry::status_text( $entry->status ) ),
                $this_author->name
            );
        }
        else {
            $message
                = $app->translate(
                "[_1] '[_2]' (ID:[_3]) edited by user '[_4]'",
                $entry->class_label, $entry->title, $entry->id,
                $this_author->name );
        }
        $app->log(
            {   message  => $message,
                level    => MT::Log::INFO(),
                class    => $entry->class,
                category => 'edit',
                metadata => $entry->id
            }
        );
        push( @objects, { current => $entry, original => $orig_obj } );
    }
    $app->run_callbacks(
        'cms_post_bulk_save.' . ( $type eq 'entry' ? 'entries' : 'pages' ),
        $app, \@objects );
    $app->add_return_arg( 'saved' => 1, is_power_edit => 1 );
    $app->call_return;
}

sub send_pings {
    my $app = shift;
    my $q   = $app->param;
    $app->validate_magic() or return;
    require MT::Entry;
    require MT::Blog;
    my $blog = MT::Blog->load( scalar $q->param('blog_id') )
        or return $app->errtrans('Invalid request');
    my $entry = MT::Entry->load( scalar $q->param('entry_id') )
        or return $app->errtrans('Invalid request');

    return $app->permission_denied()
        unless $app->user->permissions( $entry->blog->id )
            ->can_do( 'send_update_pings_' . $entry->class );

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
            {   message => $app->translate(
                    "Ping '[_1]' failed: [_2]", $res->{url},
                    $res->{error}
                ),
                class    => 'ping',
                level    => MT::Log::WARNING(),
                category => 'send_ping',
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
        or return $app->error(
        $app->translate( 'Cannot load entry #[_1].', $entry_id ) );
    return $app->errtrans("Invalid request.")
        unless $entry->blog_id == $app->blog->id;
    my $author = $app->user;
    return $app->permission_denied()
        if $entry->class eq 'entry'
        ? (     $entry->author_id == $author->id
                ? !$app->can_do('edit_own_entry')
                : !$app->can_do('edit_all_entries')
            )
        : !$app->can_do('edit_all_pages');
    $param{url_loop} = [ map { { url => $_ } } @{ $entry->pinged_url_list } ];
    $param{failed_url_loop} = [ map { { url => $_ } }
            @{ $entry->pinged_url_list( OnlyFailures => 1 ) } ];
    $app->load_tmpl( 'popup/pinged_urls.tmpl', \%param );
}

sub save_entry_prefs {
    my $app = shift;

    my $perms = $app->permissions
        or return $app->error( $app->translate("No permissions") );
    $app->validate_magic() or return;
    my $q          = $app->param;
    my $prefs      = $app->_entry_prefs_from_params;
    my $disp       = $q->param('entry_prefs');
    my $sort_only  = $q->param('sort_only');
    my $prefs_type = $q->param('_type') . '_prefs';

    if ( $disp && lc $disp eq 'custom' && lc $sort_only eq 'true' ) {
        my $current = $perms->$prefs_type;
        $prefs =~ s/\|.*$//;
        my $pos;
        ( $current, $pos ) = split '\\|', $current;
        my %current = map { $_ => 1 } split ',', $current;
        my @new = split ',', $prefs;
        $prefs = '';
        foreach my $p (@new) {
            $prefs .= ',' if $prefs;
            $prefs .= $p;
            $prefs .= ':s' unless $current{$p};
        }
        $prefs .= "|$pos" if defined $pos;
    }

    $perms->$prefs_type($prefs);
    $perms->save
        or return $app->error(
        $app->translate( "Saving permissions failed: [_1]", $perms->errstr )
        );
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
    my ($param) = @_;
    $param ||= {};
    my @ids = $app->param('id')
        or return "Invalid request.";
    my %dupe;
    @ids = grep { !$dupe{$_}++ } @ids;

    require MT::Entry;
    my $type = $app->param('_type') || MT::Entry->class_type;
    my %type_allowed = (
        entry => 1,
        page  => 1,
    );
    return $app->errtrans("Invalid request.")
        unless $type_allowed{$type};
    my $pkg = $app->model($type) or return "Invalid request.";

    my $q       = $app->param;
    my $blog_id = $q->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 )
        unless $blog_id;
    my $blog = $app->model('blog')->load($blog_id);
    return $app->return_to_dashboard( redirect => 1 )
        unless $blog;

    my @blog_ids;
    my $action
        = $type eq 'page'
        ? 'open_batch_page_editor_via_list'
        : 'open_batch_entry_editor_via_list';
    if ( $blog->is_blog ) {
        return $app->permission_denied()
            unless $app->can_do($action);
        push @blog_ids, $blog_id;
    }
    else {
        my $blogs = $blog->blogs;
        @blog_ids = map { $_->id } @$blogs;
        push @blog_ids, $blog->id
            if $type eq 'page';
    }

    if ( !$app->user->is_superuser ) {
        my $terms = {
            author_id => $app->user->id,
            blog_id   => \' = entry_blog_id',
        };
        my $perms = MT::Permission->load_permissions_from_action($action);
        if ($perms) {
            my @perms_term;
            foreach my $perm (@$perms) {
                $perm =~ m/\.(.*)/;
                push @perms_term, '-or' if @perms_term;
                push @perms_term, { permissions => { like => "%'$1'%" } };
            }
            $terms = [ $terms, '-and', \@perms_term, ];
        }

        my $cnt = $pkg->count(
            {   class   => $type,
                id      => \@ids,
                blog_id => \@blog_ids
            },
            {   join => MT::Permission->join_on(
                    undef, $terms, { unique => 1, }
                ),
                unique => 1,
            }
        );

        return $app->permission_denied()
            if scalar @ids != $cnt;
    }

    # Loading objects
    my $iter = $pkg->load_iter(
        { class => $type, id => \@ids, blog_id => \@blog_ids },
        { sort => 'authored_on', direction => 'descend' }
    );

    my $list_pref = $app->list_pref($type);
    my %param     = %$list_pref;
    $param{has_expanded_mode} = 0;
    delete $param{view_expanded};

    my $data = build_entry_table(
        $app,
        iter          => $iter,
        is_power_edit => 1,
        param         => \%param,
        type          => $type
    );
    delete $_->{object} foreach @$data;
    delete $param{entry_table} unless @$data;

    $param{saved}               = $q->param('saved');
    $param{object_type}         = $type;
    $param{object_label}        = $pkg->class_label;
    $param{object_label_plural} = $param{search_label}
        = $pkg->class_label_plural;
    $param{list_start}            = 1;
    $param{list_end}              = scalar @$data;
    $param{listing_screen}        = 1;
    $param{blog_view}             = 1;
    $param{container_label}       = $pkg->container_label;
    $param{mode}                  = $app->mode;
    $param{sitepath_unconfigured} = $blog->site_path ? 0 : 1;

    $param->{return_args} ||= $app->make_return_args;
    my @return_args
        = grep { $_ !~ /^(?:offset|__mode|id)=/ } split /&/,
        $param->{return_args};
    push @return_args, '__mode=open_batch_editor';
    push @return_args, "id=$_" foreach (@ids);

    $param{return_args} = join '&', @return_args;
    $param{screen_id}   = "batch-edit-entry";
    $param{screen_id}   = "batch-edit-page"
        if $param{object_type} eq "page";
    $param{screen_class} .= " batch-edit";

    $app->load_tmpl( "edit_entry_batch.tmpl", \%param );
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
            $row->{category_label_js}
                = $spacer . encode_js( $row->{category_label} );
            $cats{ $row->{category_id} } = $row;
        }
        $param->{category_loop} = $c_data;
    }

    my ( $date_format, $datetime_format );

    if ($is_power_edit) {
        $date_format     = "%Y.%m.%d";
        $datetime_format = "%Y-%m-%d %H:%M:%S";
    }
    else {
        $date_format     = MT::App::CMS::LISTING_DATE_FORMAT();
        $datetime_format = MT::App::CMS::LISTING_DATETIME_FORMAT();
    }

    my @cat_list;
    if ($is_power_edit) {
        @cat_list = sort {
            $cats{$a}->{category_index} <=> $cats{$b}->{category_index}
            }
            keys %cats;
    }

    my @data;
    my %blogs;
    require MT::Blog;
    my $title_max_len = const('DISPLAY_LENGTH_EDIT_ENTRY_TITLE');
    my $excerpt_max_len
        = const('DISPLAY_LENGTH_EDIT_ENTRY_TEXT_FROM_EXCERPT');
    my $text_max_len = const('DISPLAY_LENGTH_EDIT_ENTRY_TEXT_BREAK_UP');
    my %blog_perms;
    $blog_perms{ $perms->blog_id } = $perms if $perms;

    while ( my $obj = $iter->() ) {
        my $blog_perms;
        if ( !$app_author->is_superuser() ) {
            $blog_perms = $blog_perms{ $obj->blog_id }
                || $app_author->blog_perm( $obj->blog_id );
        }

        my $row = $obj->get_values;
        $row->{text} ||= '';
        if ( my $ts = $obj->authored_on ) {
            $row->{created_on_formatted}
                = format_ts( $date_format, $ts, $obj->blog,
                $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_time_formatted}
                = format_ts( $datetime_format, $ts, $obj->blog,
                $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_relative}
                = relative_date( $ts, time, $obj->blog );
        }
        if ( my $ts = $obj->modified_on ) {
            $row->{modified_on_formatted}
                = format_ts( $date_format, $ts, $obj->blog,
                $app->user ? $app->user->preferred_language : undef );
            $row->{modified_on_time_formatted}
                = format_ts( $datetime_format, $ts, $obj->blog,
                $app->user ? $app->user->preferred_language : undef );
            $row->{modified_on_relative}
                = relative_date( $ts, time, $obj->blog );
        }
        my $author = $obj->author;
        $row->{author_name}
            = $author ? $author->name : $app->translate('(user deleted)');
        if ( my $cat = $obj->category ) {
            $row->{category_label}    = $cat->label;
            $row->{category_basename} = $cat->basename;
            $row->{category_id}       = $cat->id;
        }
        else {
            $row->{category_label}    = '';
            $row->{category_basename} = '';
            $row->{category_id}       = '';
        }
        $row->{file_extension} = $obj->blog ? $obj->blog->file_extension : '';
        $row->{title_short} = $obj->title;
        if ( !defined( $row->{title_short} ) || $row->{title_short} eq '' ) {
            my $title = remove_html( $obj->text );
            $row->{title_short}
                = substr( defined($title) ? $title : "", 0, $title_max_len )
                . '...';
        }
        else {
            $row->{title_short} = remove_html( $row->{title_short} );
            $row->{title_short}
                = substr( $row->{title_short}, 0, $title_max_len + 3 ) . '...'
                if length( $row->{title_short} ) > $title_max_len;
        }
        if ( $row->{excerpt} ) {
            $row->{excerpt} = remove_html( $row->{excerpt} );
        }
        if ( !$row->{excerpt} ) {
            my $text = remove_html( $row->{text} ) || '';
            $row->{excerpt} = first_n_words( $text, $excerpt_max_len );
            if ( length($text) > length( $row->{excerpt} ) ) {
                $row->{excerpt} .= ' ...';
            }
        }
        $row->{text} = break_up_text( $row->{text}, $text_max_len )
            if $row->{text};
        $row->{title_long} = remove_html( $obj->title );
        $row->{status_text}
            = $app->translate( MT::Entry::status_text( $obj->status ) );
        $row->{ "status_" . MT::Entry::status_text( $obj->status ) } = 1;
        $row->{has_edit_access} = $app_author->is_superuser
            || ( ( 'entry' eq $type )
            && $blog_perms
            && $blog_perms->can_edit_entry( $obj, $app_author ) )
            || (
               ( 'page' eq $type )
            && $blog_perms
            && (  $app_author->id == $obj->author_id
                ? $blog_perms->can_do('edit_own_page')
                : $blog_perms->can_do('edit_all_pages')
            )
            );
        if ($is_power_edit) {
            $row->{has_publish_access} = $app_author->is_superuser
                || ( $blog_perms
                && $blog_perms->can_edit_entry( $obj, $app_author, 1 ) );
            $row->{is_editable} = $row->{has_edit_access};

            ## This is annoying. In order to generate and pre-select the
            ## category, user, and status pull down menus, we need to
            ## have a separate *copy* of the list of categories and
            ## users for every entry listed, so that each row in the list
            ## can "know" whether it is selected for this entry or not.
            my @this_c_data;
            my $this_category_id
                = $obj->category ? $obj->category->id : undef;
            for my $c_id (@cat_list) {
                push @this_c_data, { %{ $cats{$c_id} } };
                $this_c_data[-1]{category_is_selected} = $this_category_id
                    && $this_category_id == $c_id ? 1 : 0;
            }
            $row->{row_category_loop} = \@this_c_data;

            if ( $obj->author ) {
                $row->{row_author_name} = $obj->author->name;
                $row->{row_author_id}   = $obj->author->id;
            }
            else {
                $row->{row_author_name}
                    = $app->translate( '(user deleted - ID:[_1])',
                    $obj->author_id );
                $row->{row_author_id} = $obj->author_id,;
            }

            $row->{entry_blog_id} = $obj->blog_id;
        }
        if ( my $blog = $blogs{ $obj->blog_id }
            ||= MT::Blog->load( $obj->blog_id ) )
        {
            $row->{weblog_id}   = $blog->id;
            $row->{weblog_name} = $blog->name;
        }
        if ( $obj->status == MT::Entry::RELEASE() ) {
            $row->{entry_permalink}
                = MT::Util::encode_html( $obj->permalink );
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
        or return $app->error(
        $app->translate( 'Cannot load blog #[_1].', $blog_id ) );
    my %args = ( '_type' => $type, blog_id => $blog_id, qp => 1 );
    my $uri = $app->base . $app->uri( 'mode' => 'view', args => \%args );
    my $script
        = qq!javascript:d=document;w=window;t='';if(d.selection)t=d.selection.createRange().text;else{if(d.getSelection)t=d.getSelection();else{if(w.getSelection)t=w.getSelection()}}void(w.open('$uri&title='+encodeURIComponent(d.title)+'&text='+encodeURIComponent(d.location.href)+encodeURIComponent('<br/><br/>')+encodeURIComponent(t),'_blank','scrollbars=yes,status=yes,resizable=yes,location=yes'))!;

    # Translate the phrase here to avoid ActivePerl DLL bug.
    $app->translate(
        '<a href="[_1]">QuickPost to [_2]</a> - Drag this bookmarklet to your browser\'s toolbar, then click it when you are visiting a site that you want to blog about.',
        encode_html($script),
        encode_html( $blog->name )
    );
}

sub can_view {
    my ( $eh, $app, $id, $objp ) = @_;
    my $perms = $app->permissions;
    if (   !$id
        && !$perms->can_do('access_to_new_entry_editor') )
    {
        return 0;
    }
    if ($id) {
        my $obj = $objp->force();
        return 0 unless $obj->is_entry;
        if ( !$app->user->permissions( $obj->blog_id )
            ->can_edit_entry( $obj, $app->user ) )
        {
            return 0;
        }
    }
    1;
}

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();

    return $author->permissions( $obj->blog_id )
        ->can_edit_entry( $obj, $author );
}

sub pre_save {
    my $eh = shift;
    my ( $app, $obj ) = @_;

    # save tags
    my $tags = $app->param('tags');
    if ( defined $tags ) {
        my $blog   = $app->blog;
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
        {   message => $app->translate(
                "[_1] '[_2]' (ID:[_3]) deleted by '[_4]'",
                $obj->class_label, $obj->title,
                $obj->id,          $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => $obj->class,
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

    my $app_author = $app->user;
    my $perms      = $app->permissions;

    my @objects;
    foreach my $id (@ids) {
        my $entry = MT::Entry->load($id)
            or
            return $app->errtrans( "One of the entries ([_1]) did not exist",
            $id );

        return $app->permission_denied()
            unless $app_author->is_superuser
                || ( ( $entry->class eq 'entry' )
                    && $app_author->permissions( $entry->blog_id )
                    ->can_edit_entry( $entry, $app_author, 1 ) )
                || ( ( $entry->class eq 'page' )
                    && $app_author->permissions( $entry->blog_id )
                    ->can_manage_pages );

        if ( $app->config('DeleteFilesAtRebuild')
            && ( MT::Entry::RELEASE() eq $entry->status ) )
        {
            my $archive_type
                = $entry->class eq 'page'
                ? 'Page'
                : 'Individual';
            $app->publisher->remove_entry_archive_file(
                Entry       => $entry,
                ArchiveType => $archive_type
            );
        }
        my $original   = $entry->clone;
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
            {   message  => $message,
                level    => MT::Log::INFO(),
                class    => $entry->class,
                category => 'edit',
                metadata => $entry->id
            }
        );
        push( @objects, { current => $entry, original => $original } );
    }

    my $tmpl = $app->rebuild_these( \%rebuild_these,
        how => MT::App::CMS::NEW_PHASE() );

    if (@objects) {
        my $obj = $objects[0]{current};
        $app->run_callbacks(
            'cms_post_bulk_save.'
                . ( $obj->class eq 'entry' ? 'entries' : 'pages' ),
            $app, \@objects
        );
    }

    $tmpl;
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
            {   blog_id    => $blog->id,
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
    my $q = $app->param;

    my $blog;
    if ( my $blog_id = $q->param('blog_id') ) {
        $blog = MT::Blog->load($blog_id)
            or return $app->error(
            $app->translate( 'Cannot load blog #[_1].', $blog_id ) );
    }

    my $can_background
        = ( ( $blog && $blog->count_static_templates('Individual') == 0 )
            || MT::Util->launch_background_tasks() ) ? 1 : 0;

    $app->setup_filtered_ids
        if $app->param('all_selected');
    my %rebuild_recipe;
    for my $id ( $q->param('id') ) {
        my $class = $app->model("entry");
        my $obj   = $class->load($id);
        return $app->call_return unless $obj;

        $app->run_callbacks( 'cms_delete_permission_filter.entry',
            $app, $obj )
            || return $app->permission_denied();

        my %recipe = $app->publisher->rebuild_deleted_entry(
            Entry => $obj,
            Blog  => $obj->blog
        ) if $obj->status eq MT::Entry::RELEASE();

        # Remove object from database
        $obj->remove()
            or return $app->errtrans(
            'Removing [_1] failed: [_2]',
            $app->translate('entry'),
            $obj->errstr
            );
        $app->run_callbacks( 'cms_post_delete.entry', $app, $obj );

        my $child_hash = $rebuild_recipe{ $obj->blog->id } || {};
        MT::__merge_hash( $child_hash, \%recipe );
        $rebuild_recipe{ $obj->blog->id } = $child_hash;
    }

    $app->add_return_arg( saved_deleted => 1 );
    if ( $q->param('is_power_edit') ) {
        $app->add_return_arg( is_power_edit => 1 );
    }

    if ( $app->config('RebuildAtDelete') ) {
        $app->run_callbacks('pre_build');

        my $rebuild_func = sub {
            foreach my $b_id ( keys %rebuild_recipe ) {
                my $b   = MT::Blog->load($b_id);
                my $res = $app->rebuild_archives(
                    Blog   => $b,
                    Recipe => $rebuild_recipe{$b_id},
                ) or return $app->publish_error();
                $app->rebuild_indexes( Blog => $b )
                    or return $app->publish_error();
                $app->run_callbacks( 'rebuild', $b );
            }
        };

        if ($can_background) {
            MT::Util::start_background_task($rebuild_func);
        }
        else {
            $rebuild_func->();
        }

        $app->add_return_arg( no_rebuild => 1 );
        my %params = (
            is_full_screen  => 1,
            redirect_target => $app->base
                . $app->path
                . $app->script . '?'
                . $app->return_args,
        );
        return $app->load_tmpl( 'rebuilding.tmpl', \%params );
    }

    return $app->call_return();
}

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;

    my $user = $app->user;
    return if $user->is_superuser;

    my $blog_id = $app->param('blog_id') || 0;
    my $blog = $blog_id ? $app->blog : undef;
    my $blog_ids
        = !$blog         ? undef
        : $blog->is_blog ? [$blog_id]
        :                  [ map { $_->id } @{ $blog->blogs } ];

    require MT::Permission;
    my $iter = MT::Permission->load_iter(
        {   author_id => $user->id,
            (   $blog_ids
                ? ( blog_id => $blog_ids )
                : ( blog_id => { 'not' => 0 } )
            ),
        }
    );

    my $filters;
    while ( my $perm = $iter->() ) {
        my $user_filter;
        $user_filter->{blog_id} = $perm->blog_id;
        if (   !$perm->can_do('publish_all_entry')
            && !$perm->can_do('edit_all_entries') )
        {
            $user_filter->{author_id} = $user->id;
        }
        push @$filters, ( '-or', $user_filter );
    }

    my $terms = $load_options->{terms} || {};
    delete $terms->{blog_id}
        if exists $terms->{blog_id};
    delete $terms->{author_id}
        if exists $terms->{author_id};

    my $new_terms;
    push @$new_terms, ($terms)
        if ( keys %$terms );
    push @$new_terms, ( '-and', $filters );
    $load_options->{terms} = $new_terms;
}

1;
