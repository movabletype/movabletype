# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::Entry;

use strict;
use warnings;
use MT::Util qw( format_ts relative_date remove_html encode_html encode_js
    encode_url archive_file_for offset_time_list break_up_text first_n_words );
use MT::I18N qw( const wrap_text );

sub edit {
    my $cb = shift;
    my ( $app, $id, $obj, $param ) = @_;

    $app->validate_param({
        _type                     => [qw/OBJTYPE/],
        allow_comments            => [qw/MAYBE_STRING/],
        allow_pings               => [qw/MAYBE_STRING/],
        asset_id                  => [qw/ID/],
        authored_on_date          => [qw/MAYBE_STRING/],
        authored_on_day           => [qw/MAYBE_STRING/],
        authored_on_hour          => [qw/MAYBE_STRING/],
        authored_on_minute        => [qw/MAYBE_STRING/],
        authored_on_month         => [qw/MAYBE_STRING/],
        authored_on_second        => [qw/MAYBE_STRING/],
        authored_on_time          => [qw/MAYBE_STRING/],
        authored_on_year          => [qw/MAYBE_STRING/],
        basename                  => [qw/MAYBE_STRING/],
        category_id               => [qw/ID/],
        category_ids              => [qw/MAYBE_IDS/],    # may contain -1?
        convert_breaks            => [qw/MAYBE_STRING/],
        convert_breaks_for_mobile => [qw/MAYBE_STRING/],
        dirty                     => [qw/MAYBE_STRING/],
        id                        => [qw/ID/],
        include_asset_ids         => [qw/IDS/],
        mobile_view               => [qw/MAYBE_STRING/],
        no_snapshot               => [qw/MAYBE_STRING/],
        ping_errors               => [qw/MAYBE_STRING/],
        r                         => [qw/MAYBE_STRING/],
        reedit                    => [qw/MAYBE_STRING/],
        save_revision             => [qw/MAYBE_STRING/],
        status                    => [qw/MAYBE_STRING/],
        tags                      => [qw/MAYBE_STRING/],
        unpublished_on_date       => [qw/MAYBE_STRING/],
        unpublished_on_day        => [qw/MAYBE_STRING/],
        unpublished_on_hour       => [qw/MAYBE_STRING/],
        unpublished_on_minute     => [qw/MAYBE_STRING/],
        unpublished_on_month      => [qw/MAYBE_STRING/],
        unpublished_on_second     => [qw/MAYBE_STRING/],
        unpublished_on_time       => [qw/MAYBE_STRING/],
        unpublished_on_year       => [qw/MAYBE_STRING/],
    }) or return;

    my $type  = $app->param('_type');
    my $perms = $app->permissions
        or return $app->permission_denied();
    my $blog_class = $app->model('blog');
    my $blog       = $app->blog;
    my $blog_id    = $blog->id;
    my $author     = $app->user;
    my $class      = $app->model($type);

    if ($blog_id) {
        my $blog_class = $app->model('blog');
        my $blog       = $blog_class->load($blog_id);
        return $app->return_to_dashboard( redirect => 1 )
            if !$blog;
    }

    # to trigger autosave logic in main edit routine
    $param->{autosave_support} = 1;

    my $preferred_language = $author ? $author->preferred_language : undef;
    my $allow_comments     = $app->param('allow_comments');
    my $reedit             = $app->param('reedit');

    my $original_revision;
    if ($id) {
        return $app->error( $app->translate("Invalid parameter") )
            if $obj->class ne $type;

        if ( $blog->use_revision ) {
            $original_revision = $obj->revision;
            my $rn = $app->param('r');
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
                $param->{no_snapshot}      = 1 if $app->param('no_snapshot');
                $param->{missing_cats_rev} = 1
                    if exists( $obj->{__missing_cats_rev} )
                    && $obj->{__missing_cats_rev};
                $param->{missing_tags_rev} = 1
                    if exists( $obj->{__missing_tags_rev} )
                    && $obj->{__missing_tags_rev};
            }
            $param->{rev_date} = format_ts( "%Y-%m-%d %H:%M:%S",
                $obj->modified_on, $blog, $preferred_language );
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
        unless ( defined $app->param('category_id') ) {
            delete $param->{'category_id'};
            if ( my $cat = $obj->category ) {
                $param->{category_id} = $cat->id;
            }
        }
        $blog_id = $obj->blog_id;
        my $blog = $app->model('blog')->load($blog_id);
        my $status = $app->param('status') || $obj->status;
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
                . ( $allow_comments || $obj->allow_comments || 0 ) } = 1;
        $param->{'authored_on_date'} = $app->param('authored_on_date')
            || format_ts( "%Y-%m-%d", $obj->authored_on, $blog,
            $preferred_language );
        $param->{'authored_on_time'} = $app->param('authored_on_time')
            || format_ts( "%H:%M:%S", $obj->authored_on, $blog,
            $preferred_language );
        $param->{'unpublished_on_date'} = $app->param('unpublished_on_date')
            || format_ts( "%Y-%m-%d", $obj->unpublished_on, $blog,
            $preferred_language );
        $param->{'unpublished_on_time'} = $app->param('unpublished_on_time')
            || format_ts( "%H:%M:%S", $obj->unpublished_on, $blog,
            $preferred_language );

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
        $param->{ping_errors}         = $app->param('ping_errors');
        $param->{can_view_log}        = $app->can_do('view_log');
        $param->{entry_permalink} = MT::Util::encode_html( $obj->permalink );

        my $at = $blog->archive_type_preferred
          || 'Individual';
        $at = 'Page' if $type eq 'page';
        $param->{has_archive_mapping} = MT::TemplateMap->exist(
            {
                archive_type => $at,
                is_preferred => 1,
                blog_id      => $blog_id,
            }
        );

        $param->{'mode_view_entry'} = 1;
        $param->{'basename'}        = $obj->basename;

        if ( my $ts = $obj->authored_on ) {
            $param->{authored_on_ts} = $ts;
            $param->{authored_on_formatted}
                = format_ts( MT::App::CMS::LISTING_DATETIME_FORMAT(),
                $ts, $blog, $preferred_language );
        }
        if ( my $id = $obj->author_id ) {
            my $obj_author = MT::Author->load($id);
            $param->{authored_by}
                = $obj_author
                ? $obj_author->name
                : MT->translate('*User deleted*');
            $param->{from_email} = 1
                if ( ( $obj_author && $obj_author->email )
                || $app->config('EmailAddressMain') );
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
                $param->{ 'allow_comments_' . $allow_comments } = 1;
                $param->{allow_comments} = $allow_comments;
                $param->{allow_pings}    = $app->param('allow_pings');
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
        $param->{authored_on_date} = $app->param('authored_on_date')
            || POSIX::strftime( "%Y-%m-%d", @now );
        $param->{authored_on_time} = $app->param('authored_on_time')
            || POSIX::strftime( "%H:%M:%S", @now );
        $param->{unpublished_on_date} = $app->param('unpublished_on_date');
        $param->{unpublished_on_time} = $app->param('unpublished_on_time');
    }

    if (   $app->param('mobile_view')
        || $app->param('authored_on_year')
        || $app->param('authored_on_month')
        || $app->param('authored_on_day') )
    {
        $param->{authored_on_year}  = $app->param('authored_on_year');
        $param->{authored_on_month} = $app->param('authored_on_month');
        $param->{authored_on_day}   = $app->param('authored_on_day');
    }
    elsif ( $param->{authored_on_date} ) {
        (   $param->{authored_on_year},
            $param->{authored_on_month},
            $param->{authored_on_day}
        ) = split '-', $param->{authored_on_date};
    }
    if (   $app->param('mobile_view')
        || $app->param('authored_on_hour')
        || $app->param('authored_on_minute')
        || $app->param('authored_on_second') )
    {
        $param->{authored_on_hour}   = $app->param('authored_on_hour');
        $param->{authored_on_minute} = $app->param('authored_on_minute');
        $param->{authored_on_second} = $app->param('authored_on_second');
    }
    elsif ( $param->{authored_on_time} ) {
        (   $param->{authored_on_hour},
            $param->{authored_on_minute},
            $param->{authored_on_second}
        ) = split ':', $param->{authored_on_time};
    }
    if (   $app->param('mobile_view')
        || $app->param('unpublished_on_year')
        || $app->param('unpublished_on_month')
        || $app->param('unpublished_on_day') )
    {
        $param->{unpublished_on_year}  = $app->param('unpublished_on_year');
        $param->{unpublished_on_month} = $app->param('unpublished_on_month');
        $param->{unpublished_on_day}   = $app->param('unpublished_on_day');
    }
    elsif ( $param->{unpublished_on_date} ) {
        (   $param->{unpublished_on_year},
            $param->{unpublished_on_month},
            $param->{unpublished_on_day}
        ) = split '-', $param->{unpublished_on_date};
    }
    if (   $app->param('mobile_view')
        || $app->param('unpublished_on_hour')
        || $app->param('unpublished_on_minute')
        || $app->param('unpublished_on_second') )
    {
        $param->{unpublished_on_hour} = $app->param('unpublished_on_hour');
        $param->{unpublished_on_minute}
            = $app->param('unpublished_on_minute');
        $param->{unpublished_on_second}
            = $app->param('unpublished_on_second');
    }
    elsif ( $param->{unpublished_on_time} ) {
        (   $param->{unpublished_on_hour},
            $param->{unpublished_on_minute},
            $param->{unpublished_on_second}
        ) = split ':', $param->{unpublished_on_time};
    }

    ## show the necessary associated assets
    if ( $type eq 'entry' || $type eq 'page' ) {
        require MT::Asset;
        require MT::ObjectAsset;
        my $assets            = ();
        my $include_asset_ids = $app->param('include_asset_ids');
        my $asset_id          = $app->param('asset_id');
        if ( $reedit && $include_asset_ids ) {
            my @asset_ids = split( ',', $include_asset_ids );
            foreach my $asset_id (@asset_ids) {
                my $asset = MT::Asset->load($asset_id);
                if ($asset) {
                    my $asset_1;
                    if ( $asset->class eq 'image' ) {
                        my ($thumb_url) = $asset->thumbnail_url( Width => 100 );
                        $asset_1 = {
                            asset_id   => $asset->id,
                            asset_name => $asset->file_name,
                            asset_type => $asset->class,
                            asset_thumb => $thumb_url,
                            asset_blog_id => $asset->blog_id,
                        };
                    }
                    else {
                        $asset_1 = {
                            asset_id      => $asset->id,
                            asset_name    => $asset->file_name,
                            asset_type    => $asset->class,
                            asset_blog_id => $asset->blog_id,
                        };
                    }
                    push @{$assets}, $asset_1;
                }
            }
        }
        elsif ( $asset_id && !$id ) {
            my $asset   = MT::Asset->load($asset_id);
            my $asset_1 = {
                asset_id      => $asset->id,
                asset_name    => $asset->file_name,
                asset_type    => $asset->class,
                asset_blog_id => $asset->blog_id,
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
                    my ($thumb_url) = $asset->thumbnail_url( Width => 100 );
                    $asset_1 = {
                        asset_id    => $asset->id,
                        asset_name  => $asset->file_name,
                        asset_thumb => $thumb_url,
                        asset_type  => $asset->class,
                        asset_blog_id => $asset->blog_id,
                    };
                }
                else {
                    $asset_1 = {
                        asset_id      => $asset->id,
                        asset_name    => $asset->file_name,
                        asset_type    => $asset->class,
                        asset_blog_id => $asset->blog_id,
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
    $param->{dirty} = $app->param('dirty') ? 1 : 0;

    if ($id) {
        my $cats = $obj->categories;
        %places = map { $_->id => 1 } @$cats;
    }
    my $cats = $app->param('category_ids');
    if ( defined $cats ) {
        if ( my @cats = grep { $_ =~ /^\d+/ } split /,/, $cats ) {
            $cat_id = $cats[0];
            %places = map { $_ => 1 } @cats;
        }
    }
    if ($reedit) {
        $param->{reedit}          = 1;
        $param->{'basename'}      = $app->param('basename');
        $param->{'revision-note'} = $app->param('revision-note');
        if ( $app->param('save_revision') ) {
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

        require MT::Tag;
        $param->{tags_js} = MT::Tag->get_tags_js($blog_id);

        $param->{can_edit_categories} = $perms->can_do('edit_categories');
        if ( $type eq 'page' ) {
            $param->{can_edit_categories} ||= $perms->can_do('manage_pages');
        }
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
            && $_->{category_id} ne $cat_id;
    }
    $param->{category_tree} = $cat_tree;
    unshift @sel_cats, $top_cat if defined $top_cat && $top_cat ne "";
    $param->{selected_category_loop}   = \@sel_cats;
    $param->{have_multiple_categories} = scalar @$data > 1;

    $param->{basename_limit} = ( $blog ? $blog->basename_limit : 0 ) || 30;

    if ( my $tags = $app->param('tags') ) {
        $param->{tags} = $tags;
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
    my $filter
        = $app->param('mobile_view')
        ? $app->param('convert_breaks_for_mobile')
        : $app->param('convert_breaks');
    if ( defined $filter ) {
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
    if ( $app->archetype_editor_is_enabled ) {
        $app->sanitize_tainted_param( $param, [qw(text text_more)] );
    }

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

    unless (MT->config->DisableQuickPost) {
        $param->{quickpost_js} = MT::CMS::Entry::quickpost_js( $app, $type );
    }
    $param->{object_label_plural} = $param->{search_label}
        = $class->class_label_plural;
    if ( 'page' eq $type ) {
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

sub preview {
    my $app = shift;

    if ( $app->config('PreviewInNewWindow') ) {
        $app->{hide_goback_button} = 1;
    }

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
        my $org_entry
            = $entry_class->load( { id => $id, blog_id => $blog_id } )
            or return $app->errtrans("Invalid request.");
        $entry   = $org_entry->clone();
        $user_id = $entry->author_id;
    }
    else {
        $entry = $entry_class->new;
        $entry->author_id($user_id);
        $entry->id(-1);    # fake out things like MT::Taggable::__load_tags
        $entry->blog_id($blog_id);
    }

    my $perm = $app->permissions;
    return $app->return_to_dashboard( permission => 1 )
        unless $perm && $perm->can_edit_entry( $entry, $app->user );

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
    my $type        = $app->param('_type') || 'entry';
    my $entry_class = $app->model($type);
    my $blog_id     = $app->param('blog_id');
    my $blog        = $app->blog;
    my $id          = $app->param('id');
    my $user_id     = $app->user->id;
    my $cat;
    my $cat_ids = $app->param('category_ids');

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
    my $tags      = $app->param('tags');
    my @tag_names
        = ( defined $tags and $tags ne '' )
        ? MT::Tag->split( $tag_delim, $tags )
        : ();
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

    my $ao_date = $app->param('authored_on_date') || '';
    my $ao_time = $app->param('authored_on_time') || '';
    if ( $app->param('mobile_view') ) {
        my $ao_year  = $app->param('authored_on_year')  || '';
        my $ao_month = $app->param('authored_on_month') || '';
        my $ao_day   = $app->param('authored_on_day')   || '';
        if ( $ao_year || $ao_month || $ao_day ) {
            $ao_date = join '-', $ao_year, $ao_month, $ao_day;
        }

        my $ao_hour   = $app->param('authored_on_hour')   || '';
        my $ao_minute = $app->param('authored_on_minute') || '';
        my $ao_second = $app->param('authored_on_second') || '';
        if ( $ao_hour || $ao_minute || $ao_second ) {
            $ao_time = join ':', $ao_hour, $ao_minute, $ao_second;
        }
    }
    my $ao_ts = $ao_date . $ao_time;
    $ao_ts =~ s/\D//g;
    $entry->authored_on($ao_ts);

    my $uo_date = $app->param('unpublished_on_date') || '';
    my $uo_time = $app->param('unpublished_on_time') || '';
    if ( $app->param('mobile_view') ) {
        my $uo_year  = $app->param('unpublished_on_year')  || '';
        my $uo_month = $app->param('unpublished_on_month') || '';
        my $uo_day   = $app->param('unpublished_on_day')   || '';
        if ( $uo_year || $uo_month || $uo_day ) {
            $uo_date = join '-', $uo_year, $uo_month, $uo_day;
        }

        my $uo_hour   = $app->param('unpublished_on_hour')   || '';
        my $uo_minute = $app->param('unpublished_on_minute') || '';
        my $uo_second = $app->param('unpublished_on_second') || '';
        if ( $uo_hour || $uo_minute || $uo_second ) {
            $uo_time = join ':', $uo_hour, $uo_minute, $uo_second;
        }
    }
    my $uo_ts = $uo_date . $uo_time;
    $uo_ts =~ s/\D//g;
    $entry->unpublished_on($uo_ts);

    my $basename         = $app->param('basename');
    my $preview_basename = $app->preview_object_basename;
    $entry->basename( $basename || $preview_basename );

    # translates naughty words when PublishCharset is NOT UTF-8
    MT::Util::translate_naughty_words($entry);

    my $convert_breaks
        = $app->param('mobile_view')
        ? $app->param('convert_breaks_for_mobile')
        : $app->param('convert_breaks');
    $entry->convert_breaks(
        ( $convert_breaks || '' ) eq '_richtext'
        ? 'richtext'
        : $convert_breaks
    );

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
    my $archive_url;
    if ($tmpl_map) {
        $tmpl = MT::Template->load( $tmpl_map->template_id );
        MT::Request->instance->cache( 'build_template', $tmpl );
        $file_ext = $blog->file_extension || '';
        $archive_file = $entry->archive_file;
        my $base_url = $blog->archive_url;
        $base_url = $blog->site_url if $type eq 'page';
        $base_url .= '/' unless $base_url =~ m|/$|;
        $archive_url = $base_url . $archive_file;
        $archive_url =~ s{(?<!:)//+}{/}g;

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
    $ctx->{current_timestamp}    = $ao_ts;
    $ctx->{current_archive_type} = $at;
    $ctx->var( 'preview_template', 1 );
    $ctx->stash('current_mapping_url', $archive_url);

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

        # In the preview screen, in order to use the site URL of the blog,
        # there is likely to be mixed-contents.(http and https)
        # If MT is configured to do 'PreviewInNewWindow', MT will open preview
        # screen on the new window/tab.
            if ( $app->config('PreviewInNewWindow') ) {
                return $app->redirect($preview_url);
            }
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
            || $col eq 'unpublished_on'
            || $col eq 'pinged_urls'
            || $col eq 'tangent_cache'
            || $col eq 'template_id'
            || $col eq 'class'
            || $col eq 'meta'
            || $col eq 'comment_count'
            || $col eq 'ping_count'
            || $col eq 'current_revision';
        my $value = $app->param($col);
        push @data,
            {
            data_name  => $col,
            data_value => $value,
            };
    }
    for my $data (
        qw( authored_on_date authored_on_time unpublished_on_date unpublished_on_time basename_manual basename_old category_ids tags include_asset_ids save_revision revision-note )
        )
    {
        my $value = $app->param($data);
        push @data,
            {
            data_name  => $data,
            data_value => $value,
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

    my $rev_numbers = $app->param('rev_numbers') || '';
    my $collision = $app->param('collision');
    $param{diff_view} = $rev_numbers || $collision;
    $param{collision} = 1;
    if ( my @rev_numbers = split /,/, $rev_numbers ) {
        $param{comparing_revisions} = 1;
        $param{rev_a}               = $rev_numbers[0];
        $param{rev_b}               = $rev_numbers[1];
    }
    $param{dirty} = $app->param('dirty') ? 1 : 0;

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
    my $blog_id = $app->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 )
        unless $blog_id;
    return $app->permission_denied()
        unless $app->can_do('edit_config');
    $app->param( '_type', $app->blog->class );
    $app->param( 'id',    $blog_id );
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

    $app->validate_param({
        _autosave                 => [qw/MAYBE_STRING/],
        _type                     => [qw/OBJTYPE/],
        allow_comments            => [qw/MAYBE_STRING/],
        allow_pings               => [qw/MAYBE_STRING/],
        authored_on_date          => [qw/MAYBE_STRING/],
        authored_on_day           => [qw/MAYBE_STRING/],
        authored_on_hour          => [qw/MAYBE_STRING/],
        authored_on_minute        => [qw/MAYBE_STRING/],
        authored_on_month         => [qw/MAYBE_STRING/],
        authored_on_second        => [qw/MAYBE_STRING/],
        authored_on_time          => [qw/MAYBE_STRING/],
        authored_on_year          => [qw/MAYBE_STRING/],
        basename                  => [qw/MAYBE_STRING/],
        basename_manual           => [qw/MAYBE_STRING/],
        blog_id                   => [qw/ID/],
        category_ids              => [qw/MAYBE_IDS/],    # may contain -1?
        class                     => [qw/MAYBE_STRING/],
        convert_breaks_for_mobile => [qw/MAYBE_STRING/],
        id                        => [qw/ID/],
        include_asset_ids         => [qw/IDS/],
        is_power_edit             => [qw/MAYBE_STRING/],
        mobile_view               => [qw/MAYBE_STRING/],
        return_args               => [qw/MAYBE_STRING/],
        scheduled                 => [qw/MAYBE_STRING/],
        status                    => [qw/MAYBE_STRING/],
        unpublished_on_date       => [qw/MAYBE_STRING/],
        unpublished_on_day        => [qw/MAYBE_STRING/],
        unpublished_on_hour       => [qw/MAYBE_STRING/],
        unpublished_on_minute     => [qw/MAYBE_STRING/],
        unpublished_on_month      => [qw/MAYBE_STRING/],
        unpublished_on_second     => [qw/MAYBE_STRING/],
        unpublished_on_time       => [qw/MAYBE_STRING/],
        unpublished_on_year       => [qw/MAYBE_STRING/],
        week_number               => [qw/MAYBE_STRING/],
    }) or return;

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

    return $app->errtrans('Invalid request.')
        if $app->param('class');

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

    my ( $primary_category_old, $categories_old );
    if ( $orig_obj->id ) {
        $primary_category_old = $orig_obj->category;
        $categories_old       = $orig_obj->categories;
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
        unless $perms->can_do("edit_${type}_basename");
    require MT::Entry;
    $values{status} = MT::Entry::FUTURE() if $app->param('scheduled');
    if ( $app->param('mobile_view') ) {
        $values{convert_breaks} = $app->param('convert_breaks_for_mobile');
    }
    $values{convert_breaks} = 'richtext'
        if ( $values{convert_breaks} || '' ) eq '_richtext';
    $obj->set_values( \%values );
    $obj->allow_pings(0)
        if !defined $app->param('allow_pings')
        || $app->param('allow_pings') eq '';
    my $ao_d = $app->param('authored_on_date');
    my $ao_t = $app->param('authored_on_time');
    my $uo_d = $app->param('unpublished_on_date');
    my $uo_t = $app->param('unpublished_on_time');

    if ( $app->param('mobile_view') ) {
        my $ao_year  = $app->param('authored_on_year')  || '';
        my $ao_month = $app->param('authored_on_month') || '';
        my $ao_day   = $app->param('authored_on_day')   || '';
        if ( $ao_year || $ao_month || $ao_day ) {
            $ao_d = join '-', $ao_year, $ao_month, $ao_day;
        }

        my $ao_hour   = $app->param('authored_on_hour')   || '';
        my $ao_minute = $app->param('authored_on_minute') || '';
        my $ao_second = $app->param('authored_on_second') || '';
        if ( $ao_hour || $ao_minute || $ao_second ) {
            $ao_t = join ':', $ao_hour, $ao_minute, $ao_second;
        }

        my $uo_year  = $app->param('unpublished_on_year')  || '';
        my $uo_month = $app->param('unpublished_on_month') || '';
        my $uo_day   = $app->param('unpublished_on_day')   || '';
        if ( $uo_year || $uo_month || $uo_day ) {
            $uo_d = join '-', $uo_year, $uo_month, $uo_day;
        }

        my $uo_hour   = $app->param('unpublished_on_hour')   || '';
        my $uo_minute = $app->param('unpublished_on_minute') || '';
        my $uo_second = $app->param('unpublished_on_second') || '';
        if ( $uo_hour || $uo_minute || $uo_second ) {
            $uo_t = join ':', $uo_hour, $uo_minute, $uo_second;
        }
    }

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
        my $folder;
        $folder = MT::Folder->load($cat_id) if $cat_id;
        while ( my $p = $dup_it->() ) {
            my ( $dup_path, $org_path );

            if ( $app->config('BasenameCheckCompat') ) {
                my $p_folder = $p->folder;
                $dup_path
                    = defined $p_folder ? $p_folder->publish_path() : '';
                $org_path = defined $folder ? $folder->publish_path() : '';
            }
            else {
                $dup_path = $p->permalink;

                my $url = $blog->site_url || "";
                $url .= '/' unless $url =~ m!/$!;
                $org_path
                    = $url . archive_file_for( $obj, $blog, 'Page', $folder );
            }

            return $app->error(
                $app->translate(
                    "This basename has already been used. You should use an unique basename."
                )
            ) if ( $dup_path eq $org_path );
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
    if ( $perms->can_do("edit_${type}_authored_on") && ( $ao_d || $ao_t ) ) {
        my %param = ();
        my $ao    = $ao_d . ' ' . $ao_t;
        my $ts    = MT::Util::valid_date_time2ts($ao);
        if ( !$ts ) {
            $param{error} = $app->translate(
                "Invalid date '[_1]'; 'Published on' dates must be in the format YYYY-MM-DD HH:MM:SS.",
                $ao
            );
        }
        $param{return_args} = $app->param('return_args');
        return $app->forward( "view", \%param ) if $param{error};
        if ( $obj->authored_on ) {
            $previous_old = $obj->previous(1);
            $next_old     = $obj->next(1);
        }
        $obj->authored_on($ts);
    }
    if (   $perms->can_do("edit_${type}_unpublished_on")
        && $obj->status != MT::Entry::UNPUBLISH() )
    {
        if ( $uo_d || $uo_t ) {
            my %param = ();
            my $uo    = $uo_d . ' ' . $uo_t;
            my $ts    = MT::Util::valid_date_time2ts($uo);
            if ( !$ts ) {
                $param{error} = $app->translate(
                    "Invalid date '[_1]'; 'Unpublished on' dates must be in the format YYYY-MM-DD HH:MM:SS.",
                    $uo
                );
            }
            require MT::DateTime;
            unless ( $param{error} ) {
                $param{error} = $app->translate(
                    "Invalid date '[_1]'; 'Unpublished on' dates should be dates in the future.",
                    $uo
                    )
                    if (
                    MT::DateTime->compare(
                        blog => $blog,
                        a    => { value => time(), type => 'epoch' },
                        b    => $ts
                    ) > 0
                    );
            }
            if ( !$param{error} && $obj->authored_on ) {
                $param{error} = $app->translate(
                    "Invalid date '[_1]'; 'Unpublished on' dates should be later than the corresponding 'Published on' date.",
                    $uo
                    )
                    if (
                    MT::DateTime->compare(
                        blog => $blog,
                        a    => $obj->authored_on,
                        b    => $ts
                    ) > 0
                    );
            }
            $param{show_input_unpublished_on} = 1 if $param{error};
            $param{return_args} = $app->param('return_args');
            return $app->forward( "view", \%param ) if $param{error};
            if ( $obj->unpublished_on ) {
                $previous_old = $obj->previous(1);
                $next_old     = $obj->next(1);
            }
            $obj->unpublished_on($ts);
        }
        else {
            $obj->unpublished_on(undef);
        }
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

    # Clear cache for site stats dashboard widget.
    if (!$id
        || ((   ( $obj->status || 0 ) == MT::Entry::RELEASE()
                || $status_old eq MT::Entry::RELEASE()
            )
            && $status_old != $obj->status
        )
        )
    {
        require MT::Util;
        MT::Util::clear_site_stats_widget_cache($blog_id)
            or return $app->errtrans('Removing stats cache failed.');
    }

    ## look if any assets have been included/removed from this entry
    require MT::Asset;
    require MT::ObjectAsset;
    my $include_asset_ids = $app->param('include_asset_ids') || '';
    my @asset_ids  = split( ',', $include_asset_ids );
    my $obj_assets = ();
    my @obj_assets = MT::ObjectAsset->load(
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

    my $error_string = MT::callback_errstr();

    my $placements_updated;
    my $primary_category;

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
        $primary_category   = $cat_class->load($cat_id);
        $placements_updated = 1;
    }
    else {
        if ($place) {
            $place->remove;
            $obj->cache_property( 'category', undef, undef );
            $placements_updated = 1;
        }
    }

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
        unshift @add_cat_obj, $primary_category if $primary_category;
        @add_cat_obj = sort { $a->label cmp $b->label } @add_cat_obj;
        $obj->cache_property( 'categories', undef, \@add_cat_obj );
    }

    $app->run_callbacks( 'cms_post_save.' . $type, $app, $obj, $orig_obj );

    ## If the saved status is RELEASE, or if the *previous* status was
    ## RELEASE, then rebuild entry archives, indexes, and send the
    ## XML-RPC ping(s). Otherwise the status was and is HOLD, and we
    ## don't have to do anything.
    if ( ( $obj->status || 0 ) == MT::Entry::RELEASE()
        || $status_old == MT::Entry::RELEASE() )
    {
        # Delete old archive files.
        if ( $app->config('DeleteFilesAtRebuild') && $id ) {
            $app->request->cache( 'file', {} );    # clear cache
            my $file = archive_file_for( $obj, $blog, $archive_type );
            if ( $file ne $orig_file || $obj->status != MT::Entry::RELEASE() ) {
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
                            ? ( BuildDependencies => 1,
                                OldEntry          => $orig_obj,
                                OldPrevious       => $previous_old ? $previous_old->id : undef,
                                OldNext           => $next_old ? $next_old->id : undef,
                                OldDate           => $orig_obj->authored_on,
                                )
                            : ( BuildIndexes => 1 )
                        ),
                        OldCategories => join( ',', map { $_->id } @$categories_old ),
                    ) or return $app->publish_error();
                    $app->run_callbacks( 'rebuild', $blog );
                    $app->run_callbacks('post_build');
                    $app->publisher->remove_marked_files( $blog, 1 );
                    1;
                }
            );
            return unless $res;
            if ( MT->has_plugin('Trackback') ) {
                require Trackback::CMS::Entry;
                return Trackback::CMS::Entry::ping_continuation(
                    $app,
                    $obj, $blog,
                    OldStatus => $status_old,
                    IsNew     => $is_new,
                );
            }
            else {
                return _finish_rebuild( $app, $obj, $is_new );
            }
        }
        else {
            require MT::Util::UniqueID;
            my $token = MT::Util::UniqueID::create_magic_token( 'rebuild' . time );
            if ( my $session = $app->session ) {
                $session->set( 'mt_rebuild_token', $token );
                $session->save;
            }
            return $app->redirect(
                $app->uri(
                    'mode' => 'start_rebuild',
                    args   => {
                        blog_id    => $obj->blog_id,
                        ott        => $token,
                        'next'     => 0,
                        type       => 'entry-' . $obj->id,
                        entry_id   => $obj->id,
                        is_new     => $is_new,
                        old_status => $status_old,
                        old_date   => $orig_obj->authored_on,
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
    _finish_rebuild( $app, $obj, !$id );
}

sub save_entries {
    my $app = shift;

    require MT::Util::Log;
    MT::Util::Log::init();

    MT::Util::Log->debug('--- Start save_entries.');

    my $perms = $app->permissions
        or $app->permission_denied();
    my $type = $app->param('_type') || '';
    my $blog_id = $app->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 )
        unless $blog_id;
    my $blog = $app->model('blog')->load($blog_id);
    return $app->return_to_dashboard( redirect => 1 )
        unless $blog;

    MT::Util::Log->debug(' Start permission check.');

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
                my $blogs    = $blog->blogs;
                my $blog_ids = [ $blog->id ];
                my @map      = map { $_->id } @$blogs;
                push @$blog_ids, map { $_->id } @{ $blog->blogs };

                last PERMCHECK
                    if $app->user->can_do(
                    $action,
                    blog_id      => $blog_ids,
                    at_least_one => 1,
                    );
            }
        }
        else {
            last PERMCHECK
                if $app->user->can_do( $action, at_least_one => 1 );
        }
        return $app->permission_denied();
    }

    MT::Util::Log->debug(' End   permission check.');

    $app->validate_magic() or return;

    my @p = $app->multi_param;
    require MT::Entry;
    require MT::Placement;
    require MT::Log;
    my $this_author    = $app->user;
    my $this_author_id = $this_author->id;
    my @objects;

    MT::Util::Log->debug(' Start check params.');

    for my $p (@p) {
        next unless $p =~ /^author_id_(\d+)/;
        my $id    = $1;
        my $entry = MT::Entry->load($id)
            or next;
        my $old_status = $entry->status;
        my $orig_obj   = $entry->clone;
        $perms = $app->user->permissions( $entry->blog_id );
        if ( $perms->can_edit_entry( $entry, $this_author ) ) {
            my $author_id = $app->param( 'author_id_' . $id );
            my $title     = $app->param( 'title_' . $id )
                || $app->param( 'no_title_' . $id );
            $entry->author_id( $author_id ? $author_id : 0 );
            $entry->title($title);
        }
        else {
            return $app->permission_denied();
        }
        if ( $perms->can_edit_entry( $entry, $this_author, 1 ) )
        {    ## can he/she change status?
            my $status = $app->param( 'status_' . $id );
            $entry->status($status);

            my $date_closure = sub {
                my ( $val, $col, $name ) = @_;

                # FIXME: Should be assigning the publish_date field here
                my $ts = MT::Util::valid_date_time2ts($val)
                    or return $app->error(
                    $app->translate(
                        "Invalid date '[_1]'; [_2] dates must be in the format YYYY-MM-DD HH:MM:SS.",
                        $val,
                        $name
                    )
                    );

                if ( $col eq 'authored_on' && $entry->unpublished_on ) {
                    require MT::DateTime;
                    return $app->error(
                        $app->translate(
                            "Invalid date '[_1]'; 'Published on' dates should be earlier than the corresponding 'Unpublished on' date '[_2]'.",
                            $val,
                            format_ts(
                                "%Y-%m-%d %H:%M:%S",
                                $entry->unpublished_on,
                                $blog,
                                $app->user
                                ? $app->user->preferred_language
                                : undef
                            )
                        )
                        )
                        if (
                        MT::DateTime->compare(
                            blog => $blog,
                            a    => $ts,
                            b    => $entry->unpublished_on
                        ) > 0
                        );
                }

                $entry->$col($ts);
            };

            my $co = $app->param( 'created_on_' . $id ) || '';
            $date_closure->(
                $co, 'authored_on', MT->translate('authored on')
            ) or return;
            $co = $app->param( 'modified_on_' . $id ) || '';
            $date_closure->(
                $co, 'modified_on', MT->translate('modified on')
            ) or return;

            # Clear Unpublish Date
            if (   $old_status == MT::Entry::UNPUBLISH()
                && $entry->status == MT::Entry::RELEASE() )
            {
                $entry->unpublished_on(undef);
            }
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

        my $cat_id = $app->param("category_id_$id");
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
                level    => MT::Log::NOTICE(),
                class    => $entry->class,
                category => 'edit',
                metadata => $entry->id
            }
        );
        push( @objects, { current => $entry, original => $orig_obj } );
    }

    MT::Util::Log->debug(' End   check params.');

    MT::Util::Log->debug(' Start callbacks cms_post_bulk_save.');

    $app->run_callbacks(
        'cms_post_bulk_save.' . ( $type eq 'entry' ? 'entries' : 'pages' ),
        $app, \@objects );

    MT::Util::Log->debug(' End   callbacks cms_post_bulk_save.');

    $app->add_return_arg( 'saved' => 1, is_power_edit => 1 );

    MT::Util::Log->debug('--- End   save_entries.');

    $app->call_return;
}

sub pinged_urls {
    my $app   = shift;

    $app->validate_param({
        entry_id => [qw/ID/],
    }) or return;

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
        ? (
        $entry->author_id == $author->id
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

    require MT::Util::Log;
    MT::Util::Log::init();

    MT::Util::Log->debug('--- Start save_entry_prefs.');

    # Magic token check
    $app->validate_magic() or return;

    # Param check
    my $type = lc scalar $app->param('_type') || '';
    if ( 'entry' ne $type and 'page' ne $type ) {
        return $app->error( $app->translate('Invalid request.') );
    }

    # Loading permission record
    my $user = $app->user
        or return $app->error( $app->translate('Invalid request.') );
    my $blog_id = scalar $app->param('blog_id')
        or return $app->error( $app->translate('Invalid request.') );
    my $perms = MT->model('permission')->load(
        {   author_id => $user->id,
            blog_id   => $blog_id,
        }
    );

    # Sometimes super user does not have any permission for each site.
    return $app->json_result( { success => 1 } )
        if $user->is_superuser && !$perms;

    # Permission check
    return $app->permission_denied()
        unless $perms
        && $perms->can_do('save_edit_prefs');

    my $prefs      = $app->_entry_prefs_from_params;
    my $disp       = scalar $app->param('entry_prefs');
    my $sort_only  = scalar $app->param('sort_only');
    my $prefs_type = $type . '_prefs';

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

    MT::Util::Log->debug('--- End   save_entry_prefs.');

    return $app->json_result( { success => 1 } );
}

sub publish_entries {
    my $app = shift;

    $app->validate_param({
        id => [qw/ID MULTI/],
    }) or return;

    require MT::Entry;
    update_entry_status( $app, MT::Entry::RELEASE(),
        $app->multi_param('id') );
}

sub draft_entries {
    my $app = shift;

    $app->validate_param({
        id => [qw/ID MULTI/],
    }) or return;

    require MT::Entry;
    update_entry_status( $app, MT::Entry::HOLD(), $app->multi_param('id') );
}

sub open_batch_editor {
    my $app = shift;
    my ($param) = @_;

    $app->validate_param({
        _type   => [qw/OBJTYPE/],
        blog_id => [qw/ID/],
        id      => [qw/ID MULTI/],
        saved   => [qw/MAYBE_STRING/],
    }) or return;

    $param ||= {};
    my @ids = $app->multi_param('id')
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

    my $blog_id = $app->param('blog_id');
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
        push @blog_ids, $blog->id;
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

    $param{saved}               = $app->param('saved');
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
    my $perms      = $app->permissions
        or return $app->permission_denied();
    my $type  = $args{type};
    my $class = $app->model($type);

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

sub can_save {
    my ( $eh, $app, $id, $obj, $original ) = @_;

    my $perms = $app->permissions
        or return 0;

    if ($id) {
        $original
            ||= MT->model('entry')->load( { class => 'entry', id => $id } )
            or return 0;

        return 0
            unless $perms->can_edit_entry( $original, $app->user );
        return 0
            if ( ( $obj && $obj->status != $original->status )
            || ( !$obj && $original->status ne $app->param('status') ) )
            && !( $perms->can_edit_entry( $original, $app->user, 1 ) );
    }
    else {
        return 0
            unless $perms->can_do('create_new_entry');
        return 0
            if $obj
            && $obj->status != MT::Entry::HOLD()
            && !$perms->can_do('publish_own_entry')
            && !$perms->can_do('publish_all_entry');
    }

    1;
}

sub can_view {
    my ( $eh, $app, $id, $objp ) = @_;
    my $perms = $app->permissions
        or return 0;
    if (   !$id
        && !$perms->can_do('access_to_new_entry_editor') )
    {
        return 0;
    }
    if ($id) {
        my $obj = $objp->force();
        return 0 if ( !$obj || !$obj->is_entry );
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
            $obj->set_tags();
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
    $obj->discover_tb_from_entry() if MT->has_plugin('Trackback');
    1;
}

sub post_save {
    my $eh = shift;
    my ( $app, $obj, $orig_obj ) = @_;
    if ( $app->can('autosave_session_obj') ) {
        my $sess_obj = $app->autosave_session_obj;
        $sess_obj->remove if $sess_obj;
    }

    return 1 unless $orig_obj;

    my $author = $app->user;

    my $message;
    if ( !$orig_obj->id ) {
        $message
            = $app->translate( "[_1] '[_2]' (ID:[_3]) added by user '[_4]'",
            $obj->class_label, $obj->title, $obj->id, $author->name );
    }
    elsif ( $orig_obj->status ne $obj->status ) {
        $message = $app->translate(
            "[_1] '[_2]' (ID:[_3]) edited and its status changed from [_4] to [_5] by user '[_6]'",
            $obj->class_label,
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
            $obj->class_label, $obj->title, $obj->id, $author->name );
    }
    require MT::Log;
    $app->log(
        {   message => $message,
            $orig_obj->id ? ( level => MT::Log::NOTICE() ) : ( level => MT::Log::INFO() ),
            class   => $obj->class,
            $orig_obj->id ? ( category => 'edit' ) : ( category => 'new' ),
            metadata => $obj->id
        }
    );

    1;
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    if ( $app->can('autosave_session_obj') ) {
        my $sess_obj = $app->autosave_session_obj;
        $sess_obj->remove if $sess_obj;
    }

    $app->log(
        {   message => $app->translate(
                "[_1] '[_2]' (ID:[_3]) deleted by '[_4]'",
                $obj->class_label, $obj->title,
                $obj->id,          $app->user->name
            ),
            level    => MT::Log::NOTICE(),
            class    => $obj->class,
            category => 'delete'
        }
    );
}

sub update_entry_status {
    my $app = shift;

    require MT::Util::Log;
    MT::Util::Log::init();

    MT::Util::Log->debug('--- Start update_entry_status.');

    my ( $new_status, @ids ) = @_;
    return $app->errtrans("Need a status to update entries")
        unless $new_status;
    return $app->errtrans("Need entries to update status")
        unless @ids;
    my %rebuild_these;
    require MT::Entry;

    my $app_author = $app->user;

    my @objects;

    MT::Util::Log->debug(' Start load entries.');

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
                ArchiveType => $archive_type,
                (     ( $new_status != MT::Entry::RELEASE() )
                    ? ( Force => 1 )
                    : ( Force => 0 )
                ),
            );
        }
        my $original   = $entry->clone;
        my $old_status = $entry->status;
        $entry->status($new_status);
        $entry->modified_by( $app_author->id );
        $entry->save() and $rebuild_these{$id} = 1;

        # Clear cache for site stats dashboard widget.
        if ((      $entry->status == MT::Entry::RELEASE()
                || $old_status == MT::Entry::RELEASE()
            )
            && $old_status != $entry->status
            )
        {
            require MT::Util;
            MT::Util::clear_site_stats_widget_cache( $entry->blog_id )
                or return $app->errtrans('Removing stats cache failed.');
        }

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
                level    => MT::Log::NOTICE(),
                class    => $entry->class,
                category => 'edit',
                metadata => $entry->id
            }
        );
        push( @objects, { current => $entry, original => $original } );
    }

    MT::Util::Log->debug(' End   load entries.');

    MT::Util::Log->debug(' Start rebuild_these.');

    my $tmpl = $app->rebuild_these( \%rebuild_these,
        how => MT::App::CMS::NEW_PHASE() );

    MT::Util::Log->debug(' End   rebuild_these.');

    if (@objects) {
        my $obj = $objects[0]{current};

        MT::Util::Log->debug(' Start callbacks cms_post_bulk_save.');

        $app->run_callbacks(
            'cms_post_bulk_save.'
                . ( $obj->class eq 'entry' ? 'entries' : 'pages' ),
            $app, \@objects
        );

        MT::Util::Log->debug(' End   callbacks cms_post_bulk_save.');
    }

    MT::Util::Log->debug('--- End   update_entry_status.');

    $tmpl;
}

sub _finish_rebuild {
    my $app = shift;
    my ( $entry, $is_new ) = @_;
    $app->redirect(
        $app->uri(
            'mode' => 'view',
            args   => {
                '_type' => $entry->class,
                blog_id => $entry->blog_id,
                id      => $entry->id,
                ( $is_new ? ( saved_added => 1 ) : ( saved_changes => 1 ) )
            }
        )
    );
}

sub delete {
    my $app = shift;
    $app->validate_magic() or return;

    $app->validate_param({
        all_selected  => [qw/MAYBE_STRING/],
        blog_id       => [qw/ID/],
        id            => [qw/ID MULTI/],
        is_power_edit => [qw/MAYBE_STRING/],
    }) or return;

    require MT::Blog;

    my $blog;
    if ( my $blog_id = $app->param('blog_id') ) {
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
    for my $id ( $app->multi_param('id') ) {
        my $class = $app->model("entry");
        my $obj   = $class->load($id);
        return $app->call_return unless $obj;

        $app->run_callbacks( 'cms_delete_permission_filter.entry',
            $app, $obj )
            || return $app->permission_denied();

        my %recipe;
        %recipe = $app->publisher->rebuild_deleted_entry(
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

        # Clear cache for site stats dashboard widget.
        require MT::Util;
        MT::Util::clear_site_stats_widget_cache( $obj->blog->id )
            or return $app->errtrans('Removing stats cache failed.');
    }

    $app->add_return_arg( saved_deleted => 1 );
    if ( $app->param('is_power_edit') ) {
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
                $app->publisher->remove_marked_files( $b, 1 );
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

    my $terms = $load_options->{terms} || {};
    my $blog_ids;
    $blog_ids = delete $terms->{blog_id}
        if exists $terms->{blog_id};
    delete $terms->{author_id}
        if exists $terms->{author_id};

    if ( !$blog_ids ) {
        my $blog_id = $app->param('blog_id') || 0;
        my $blog = $blog_id ? $app->blog : undef;
        $blog_ids
            = !$blog         ? undef
            : $blog->is_blog ? [$blog_id]
            :   [ $blog->id, map { $_->id } @{ $blog->blogs } ];
    }

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

    my $new_terms;
    push @$new_terms, ($terms)
        if ( keys %$terms );
    push @$new_terms, ( '-and', $filters || { blog_id => 0 } );
    $load_options->{terms} = $new_terms;
}

1;
