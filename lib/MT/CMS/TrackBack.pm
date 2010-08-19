# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::CMS::TrackBack;

use strict;
use MT::Util qw( format_ts relative_date encode_url encode_html break_up_text );
use MT::I18N qw( const );

sub edit {
    my $cb = shift;
    my ($app, $id, $obj, $param) = @_;

    my $q = $app->param;
    my $perms = $app->permissions;
    my $blog = $app->blog;
    my $blog_id = $q->param('blog_id');
    my $type = $q->param('_type');

    if ($id) {
        $param->{nav_trackbacks} = 1;
        $app->add_breadcrumb(
            $app->translate('TrackBacks'),
            $app->uri(
                'mode' => 'list_pings',
                args   => { blog_id => $blog_id }
            )
        );
        $app->add_breadcrumb( $app->translate('Edit TrackBack') );
        $param->{approved}           = $app->param('approved');
        $param->{unapproved}         = $app->param('unapproved');
        $param->{has_publish_access} = 1 if $app->user->is_superuser;
        $param->{has_publish_access} = (
            $app->can_do('publish_trackback') ? 1 : 0
        ) unless $app->user->is_superuser;
        require MT::Trackback;

        if ( my $tb = MT::Trackback->load( $obj->tb_id ) ) {
            if ( $tb->entry_id ) {
                $param->{entry_ping} = 1;
                require MT::Entry;
                if ( my $entry = MT::Entry->load( $tb->entry_id ) ) {
                    $param->{entry_title} = $entry->title;
                    $param->{entry_id}    = $entry->id;
                    unless ( $param->{has_publish_access} ) {
                        $param->{has_publish_access} =
                          ( $perms->can_do('publish_own_entry_trackback')
                              && ( $app->user->id == $entry->author_id ) )
                          ? 1
                          : 0;
                    }
                    $param->{target_type} = $entry->class;
                    $param->{target_label} = MT->model($entry->class)->class_label;
                }
            }
            elsif ( $tb->category_id ) {
                $param->{category_ping} = 1;
                require MT::Category;
                if ( my $cat = MT::Category->load( $tb->category_id ) ) {
                    $param->{category_id}    = $cat->id;
                    $param->{category_label} = $cat->label;
                }
            }
        }

        $param->{"ping_approved"} = $obj->is_published
          or $param->{"ping_pending"} = $obj->is_moderated
          or $param->{"is_junk"}      = $obj->is_junk;

        ## Load next and previous entries for next/previous links
        if ( my $next = $obj->next ) {
            $param->{next_ping_id} = $next->id;
        }
        if ( my $prev = $obj->previous ) {
            $param->{previous_ping_id} = $prev->id;
        }
        my $parent = $obj->parent;
        if ( $parent && ( $parent->isa('MT::Entry') ) ) {
            if ( $parent->status == MT::Entry::RELEASE() ) {
                $param->{entry_permalink} = $parent->permalink;
            }
        }

        if ( $obj->junk_log ) {
            require MT::CMS::Comment;
            MT::CMS::Comment::build_junk_table( $app, param => $param, object => $obj );
        }

        $param->{created_on_time_formatted} =
          format_ts( MT::App::CMS::LISTING_DATETIME_FORMAT(), $obj->created_on(), $blog, $app->user ? $app->user->preferred_language : undef );
        $param->{created_on_day_formatted} =
          format_ts( MT::App::CMS::LISTING_DATE_FORMAT(), $obj->created_on(), $blog, $app->user ? $app->user->preferred_language : undef );

        $param->{search_label} = $app->translate('TrackBacks');
        $param->{object_type}  = 'ping';

        $app->load_list_actions( $type, $param );

        # since MT::App::build_page clobbers it:
        $param->{source_blog_name} = $param->{blog_name};
    }
    1;
}

sub list {
    my $app   = shift;
    my $q     = $app->param;
    my $perms = $app->permissions;

    my $can_empty_junk = 1;
    my $state_editable = 1;
    my $admin = $app->user->is_superuser
      || ( $perms && $perms->can_administer_blog );
    if ($perms) {
        $app->can_do('access_to_trackback_list')
            or return $app->permission_denied();
        $can_empty_junk = $admin
          || $app->can_do('delete_junk_trackbacks')
          ? 1 : 0;
        $state_editable = $admin
          || $app->can_do('edit_trackback_status') ? 1 : 0;
    }    # otherwise we simply filter the list of objects

    my $list_pref = $app->list_pref('ping');
    my $class     = $app->model("ping") or return;
    my $blog_id   = $q->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 )
        unless $blog_id;
    my $blog = $app->model('blog')->load($blog_id);

    my %param = %$list_pref;
    my %terms;

    my $blog_ids = $app->_load_child_blog_ids($blog_id);
    push @$blog_ids, $blog_id;
    $terms{blog_id} = $blog_ids;

    my $cols           = $class->column_names;
    my $limit          = $list_pref->{rows};
    my $offset         = $app->param('offset') || 0;
    my $sort_direction = $q->param('sortasc') ? 'ascend' : 'descend';

    ## We load $limit + 1 records so that we can easily tell if we have a
    ## page of next entries to link to. Obviously we only display $limit
    ## entries.
    my %arg;
    $arg{'sort'}    = 'created_on';
    $arg{direction} = $sort_direction;
    require MT::TBPing;
    if ( ( $app->param('tab') || '' ) eq 'junk' ) {
        $app->param( 'filter',     'junk_status' );
        $app->param( 'filter_val', MT::TBPing::JUNK() );
        $param{filter_special} = 1;
        $param{filter_phrase}  = $app->translate('Junk TrackBacks');
    }
    else {
        $terms{'junk_status'} = MT::TBPing::NOT_JUNK();
    }

    my $filter_key = $q->param('filter_key');
    if ( !$filter_key && !$app->param('filter') ) {
        $filter_key = 'default';
    }
    my @val        = $q->param('filter_val');
    my $filter_col = $q->param('filter');
    if ( $filter_col && ( my $val = $q->param('filter_val') ) ) {
        if ( $filter_col eq 'status' ) {
            $terms{visible} = $val eq 'approved' ? 1 : 0;
        }
        elsif ($filter_col eq 'category_id'
            || $filter_col eq 'entry_id' )
        {
            $arg{join} = $app->model('trackback')->join_on(
                undef,
                {
                    id          => \'= tbping_tb_id',
                    $filter_col => $val,
                    $blog_id ? ( blog_id => $blog_id ) : (),
                }
            );
            if ( $filter_col eq 'entry_id' ) {
                my $pkg   = $app->model('entry');
                my $entry = $pkg->load($val);
                if ($entry) {
                    $param{filter_phrase} = $app->translate(
    "TrackBacks where <strong>[_1]</strong> is &quot;[_2]&quot;.",
                        $entry->class_label,
                        encode_html( $entry->title )
                    );
                }
            }
            elsif ( $filter_col eq 'category_id' ) {
                my $pkg = $app->model('category');
                my $cat = $pkg->load($val);
                if ($cat) {
                    $param{filter_phrase} = $app->translate(
    "TrackBacks where <strong>[_1]</strong> is &quot;[_2]&quot;.",
                        $cat->class_label,
                        encode_html( $cat->label )
                    );
                }
            }
            $param{filter_special} = 1;
        }
        else {
            if ( $val[1] ) {
                $terms{$filter_col} = [ $val[0], $val[1] ];
                $arg{'range_incl'} = { $filter_col => 1 };
                $param{filter_val2}  = $val[1];
                $param{filter_range} = 1;
            }
            else {
                $terms{$filter_col} = $val;
            }
        }
        $param{filter_args} = "&filter=" . encode_url($filter_col) . "&filter_val=" . encode_url($val);
        $param{filter}     ||= $filter_col;
        $param{filter_val} ||= $val;
        $param{is_filtered} = 1;
        $param{is_ip_filter} = $filter_col eq "ip";
    }
    elsif ($filter_key) {
        my $filters = $app->registry("list_filters", "ping") || {};
        if ( my $filter = $filters->{$filter_key} ) {
            if ( my $code = $filter->{code}
                || $app->handler_to_coderef( $filter->{handler} ) )
            {
                $param{filter} = 1;
                $param{filter_key}   = $filter_key;
                $param{filter_label} = $filter->{label};
                $code->( \%terms, \%arg );
            }
        }
    }

    my $ping_class = $app->model('ping');
    my $total      = $ping_class->count( \%terms, \%arg ) || 0;
    $arg{limit}     = $limit + 1;
    if ( $total <= $limit ) {
        delete $arg{limit};
        $offset = 0;
    }
    else {
        $arg{offset} = $offset if $offset;
    }

    my $iter = $class->load_iter( \%terms, \%arg );
    my $data = build_ping_table( $app, iter => $iter, param => \%param );
    delete $_->{object} for @$data;

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

    $param{ping_count}         = scalar @$data;
    $param{limit}              = $limit;
    $param{offset}             = $offset;
    $param{list_filters}       = $app->list_filters('ping');
    $param{saved}              = $q->param('saved');
    $param{junked}             = $q->param('junked');
    $param{unjunked}           = $q->param('unjunked');
    $param{approved}           = $q->param('approved');
    $param{unapproved}         = $q->param('unapproved');
    $param{emptied}            = $q->param('emptied');
    $param{state_editable}     = $state_editable;
    $param{can_empty_junk}     = $can_empty_junk;
    $param{saved_deleted_ping} = $q->param('saved_deleted')
      || $q->param('saved_deleted_ping');
    $param{object_type}         = 'ping';
    $param{object_label}        = $ping_class->class_label;
    $param{object_label_plural} = $ping_class->class_label_plural;
    $param{search_label}        = $param{object_label_plural};
    $param{list_start}          = $offset + 1;
    $param{list_end}            = $offset + scalar @$data;
    $param{list_total}          = $total;
    $param{next_max}
        = $param{next_offset}
        ? int( $param{list_total} / $limit ) * $limit
        : 0;
    $param{page_actions} = $app->page_actions('list_pings')
      || $app->page_actions('list_ping');
    $param{nav_trackbacks}    = 1;
    $param{has_expanded_mode} = 1;
    $param{tab}               = $app->param('tab') || 'pings';
    $param{ "tab_" . ( $app->param('tab') || 'pings' ) } = 1;

    $param{blog_view} = 1 if $blog->is_blog;
    $param{filter_spam} =
      ( $app->param('filter_key') && $app->param('filter_key') eq 'spam' );
    if ( $param{'tab'} ne 'junk' ) {
        $param{feed_name} = $app->translate("TrackBack Activity Feed");
        $param{feed_url} =
          $app->make_feed_link( 'ping',
            $blog_id ? { blog_id => $blog_id } : undef );
    }
    $param{screen_id} = "list-ping";
    $param{listing_screen} = 1;
    $app->add_breadcrumb( $app->translate('TrackBacks') );
    $app->load_tmpl( "list_ping.tmpl", \%param );
}

sub can_view {
    my $eh = shift;
    my ( $app, $id, $objp ) = @_;
    my $obj = $objp->force() or return 0;
    require MT::Trackback;
    my $tb    = MT::Trackback->load( $obj->tb_id );
    my $perms = $app->permissions;
    if ($tb) {
        if ( $tb->entry_id ) {
            require MT::Entry;
            my $entry = MT::Entry->load( $tb->entry_id );
            return ( !$entry
                  || ( $entry->author_id == $app->user->id
                       && $app->can_do('open_own_entry_trackback_edit_screen') )
                  || $perms->can_do('open_all_trackback_edit_screen') );
        }
        elsif ( $tb->category_id ) {
            require MT::Category;
            my $cat = MT::Category->load( $tb->category_id );
            return $cat && $perms->can_do('open_category_trackback_edit_screen');
        }


    }
    else {
        return 0;    # no TrackBack center--no edit
    }
    return 1;
}

sub can_save {
    my ( $eh, $app, $id ) = @_;
    return 0 unless $id;    # Can't create new pings here
    return 1 if $app->user->is_superuser();

    my $perms = $app->permissions;
    return 1
        if $app->can_do('save_all_trackback');
    my $p      = MT::TBPing->load($id)
        or return 0;
    my $tbitem = $p->parent;
    if ( $tbitem->isa('MT::Entry') ) {
        return 0
            if $tbitem->author_id != $app->user->id;

        my $status_is_changed
            = $p->is_junk      ? ( 'junk'      ne $app->param('status') )
            : $p->is_moderated ? ( 'moderated' ne $app->param('status') )
            : $p->is_published ? ( 'publish'   ne $app->param('status') )
            :                    1
            ;
        return $status_is_changed ? $app->can_do('edit_own_entry_trackback_status')
                                  : $app->can_do('edit_own_entry_trackback_without_status')
                                  ;
    }
    else {
        return $app->can_do('save_category_trackback');
    }
}

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();
    my $perms = $app->permissions;
    require MT::Trackback;
    my $tb = MT::Trackback->load( $obj->tb_id )
        or return 0;
    if ( my $entry = $tb->entry ) {
        if ( !$perms || $perms->blog_id != $entry->blog_id ) {
            $perms ||= $author->permissions( $entry->blog_id );
        }

        # publish_post allows entry author to delete comment.
        return 1
          if $perms->can_do('delete_all_trackbacks')
          || ( $perms->can_edit_entry( $entry, $author, 1 )
               && $perms->can_do('delete_own_entry_trackback') );
        return 0
          if $obj->visible;    # otherwise, visible comment can't be deleted.
        return $perms->can_edit_entry( $entry, $author )
               && $perms->can_do('delete_own_entry_unpublished_trackback');
    }
    elsif ( $tb->category_id ) {
        $perms ||= $author->permissions( $tb->blog_id );
        return ( $perms && $perms->can_do('delete_category_trackback') );
    }
    return 0;
}

sub pre_save {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;
    my $perms = $app->permissions;

    PERMCHECK: {
        last PERMCHECK
            if $app->can_do('handle_junk_for_all_trackbacks');
        require MT::Trackback;
        my $tb = MT::Trackback->load( $obj->tb_id )
            or return 0; # wrong trackback id. callback was failed.
        if ( $tb->entry_id ) {
            require MT::Entry;
            my $entry = MT::Entry->load( $tb->entry_id );
            last PERMCHECK
                if $entry
                    && $entry->author_id == $app->user->id
                    && $app->can_do('handle_junk_for_own_entry_trackback');
        }
        elsif ( $tb->category_id ) {
            require MT::Category;
            my $cat = MT::Category->load( $tb->category_id );
            last PERMCHECK
                if $cat && $app->can_do('handle_junk_for_category_trackback');
        }
        ## do nothing.
        return 1;
    }

    my $status = $app->param('status');
    if ( $status eq 'publish' ) {
        $obj->approve;
        if ( $original->junk_status != $obj->junk_status ) {
            $app->run_callbacks( 'handle_ham', $app, $obj );
        }
    }
    elsif ( $status eq 'moderate' ) {
        $obj->moderate;
    }
    elsif ( $status eq 'junk' ) {
        $obj->junk;
        if ( $original->junk_status != $obj->junk_status ) {
            $app->run_callbacks( 'handle_spam', $app, $obj );
        }
    }
    return 1;
}

sub post_save {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;
    require MT::Trackback;
    require MT::Entry;
    require MT::Category;
    if ( my $tb = MT::Trackback->load( $obj->tb_id ) ) {
        my ( $entry, $cat );
        if ( $tb->entry_id && ( $entry = MT::Entry->load( $tb->entry_id ) ) ) {
            if ( $obj->visible
                || ( ( $obj->visible || 0 ) != ( $original->visible || 0 ) ) )
            {
                $app->rebuild_entry( Entry => $entry, BuildIndexes => 1 )
                    or return $app->publish_error();
            }
        }
        elsif ( $tb->category_id
            && ( $cat = MT::Category->load( $tb->category_id ) ) )
        {

            # FIXME: rebuild single category
        }
    }
    1;
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    my ( $message, $title );
    my $obj_parent = $obj->parent();
    if ( $obj_parent->isa('MT::Category') ) {
        $title = $obj_parent->label || $app->translate('(Unlabeled category)');
        $message =
          $app->translate(
            "Ping (ID:[_1]) from '[_2]' deleted by '[_3]' from category '[_4]'",
            $obj->id, $obj->blog_name, $app->user->name, $title );
    }
    else {
        $title = $obj_parent->title || $app->translate('(Untitled entry)');
        $message =
          $app->translate(
            "Ping (ID:[_1]) from '[_2]' deleted by '[_3]' from entry '[_4]'",
            $obj->id, $obj->blog_name, $app->user->name, $title );
    }

    $app->log(
        {
            message  => $message,
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'delete'
        }
    );
}

# takes param and one of load_args, iter, or items
sub build_ping_table {
    my $app = shift;
    my (%args) = @_;

    require MT::Entry;
    require MT::Trackback;
    require MT::Category;

    my $author    = $app->user;
    my $list_pref = $app->list_pref('ping');
    my $iter;
    if ( $args{load_args} ) {
        my $class = $app->model('ping');
        $iter = $class->load_iter( @{ $args{load_args} } );
    }
    elsif ( $args{iter} ) {
        $iter = $args{iter};
    }
    elsif ( $args{items} ) {
        $iter = sub { pop @{ $args{items} } };
    }
    return [] unless $iter;
    my $limit = $args{limit};
    my $param = $args{param};

    my @data;
    my ( %blogs, %entries, %cats, %perms );
    my $excerpt_max_len = const('DISPLAY_LENGTH_EDIT_PING_TITLE_FROM_EXCERPT');
    my $title_max_len   = const('DISPLAY_LENGTH_EDIT_PING_BREAK_UP');
    while ( my $obj = $iter->() ) {
        my $row = $obj->get_values;
        my $blog = $blogs{ $obj->blog_id } ||= $obj->blog if $obj->blog_id;
        $row->{excerpt} = '[' . $app->translate("No Excerpt") . ']'
          unless ( $row->{excerpt} || '' ) ne '';
        if ( ( $row->{title} || '' ) eq ( $row->{source_url} || '' ) ) {
            $row->{title} = '[' . $app->translate("No Title") . ']';
        }
        if ( !defined( $row->{title} ) ) {
            $row->{title} =
              substr( $row->{excerpt} || "", 0, $excerpt_max_len ) . '...';
        }
        $row->{excerpt} ||= '';
        $row->{title}     = break_up_text( $row->{title},     $title_max_len );
        $row->{excerpt}   = break_up_text( $row->{excerpt},   $title_max_len );
        $row->{blog_name} = break_up_text( $row->{blog_name}, $title_max_len );
        $row->{object}    = $obj;
        push @data, $row;

        my $entry;
        my $cat;
        if ( my $tb_center = MT::Trackback->load( $obj->tb_id ) ) {
            if ( $tb_center->entry_id ) {
                $entry = $entries{ $tb_center->entry_id } ||=
                  $app->model('entry')->load( $tb_center->entry_id );
                my $class = $entry->class || 'entry';
                if ($entry) {
                    $row->{target_title} = $entry->title;
                    $row->{target_link}  = $app->uri(
                        'mode' => 'view',
                        args   => {
                            '_type' => $class,
                            id      => $entry->id,
                            blog_id => $entry->blog_id,
                            tab     => 'pings'
                        }
                    );
                }
                else {
                    $row->{target_title} =
                      ( '* ' . $app->translate('Orphaned TrackBack') . ' *' );
                }
                $row->{target_type} = $app->translate($class);
            }
            elsif ( $tb_center->category_id ) {
                $cat = $cats{ $tb_center->category_id } ||=
                  MT::Category->load( $tb_center->category_id );
                if ($cat) {
                    $row->{target_title} =
                      ( '* ' . $app->translate('Orphaned TrackBack') . ' *' );
                    $row->{target_title} = $cat->label;
                    $row->{target_link}  = $app->uri(
                        'mode' => 'view',
                        args   => {
                            '_type' => 'category',
                            id      => $cat->id,
                            blog_id => $cat->blog_id,
                            tab     => 'pings'
                        }
                    );
                }
                $row->{target_type} = $app->translate('category');
            }
        }
        if ( my $ts = $obj->created_on ) {
            $row->{created_on_time_formatted} =
              format_ts( MT::App::CMS::LISTING_DATETIME_FORMAT(), $ts, $blog, $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_formatted} =
              format_ts( MT::App::CMS::LISTING_DATE_FORMAT(), $ts, $blog, $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_relative} = relative_date( $ts, time, $blog );
        }
        if ($blog) {
            $row->{weblog_id}   = $blog->id;
            $row->{weblog_name} = $blog->name;
        }
        else {
            $row->{weblog_name} =
              '* ' . $app->translate('Orphaned TrackBack') . ' *';
        }
        if ( $author->is_superuser() ) {
            $row->{has_edit_access} = 1;
            $row->{has_bulk_access} = 1;
        }
        else {
            my $perms = $perms{ $obj->blog_id } ||=
              $author->permissions( $obj->blog_id );
            my $own_entry = $entry && $author->id == $entry->author_id;

            $row->{has_bulk_access}
                = $cat       ? $perms->can_do('bulk_edit_category_trackbacks')
                : $own_entry ? $perms->can_do('bulk_edit_own_entry_trackbacks')
                :              $perms->can_do('bulk_edit_all_entry_trackbacks')
                ;

            $row->{has_edit_access}
                = $cat       ? $perms->can_do('open_category_trackback_edit_screen')
                : $own_entry ? $perms->can_do('open_own_entry_trackback_edit_screen')
                :              $perms->can_do('open_all_trackback_edit_screen')
                ;
        }
    }
    return [] unless @data;

    $param->{ping_table}[0] = {%$list_pref};
    $param->{object_loop} = $param->{ping_table}[0]{object_loop} = \@data;
    $param->{ping_table}[0]{object_type} = 'ping';
    $app->load_list_actions( 'ping', $param );
    \@data;
}

1;
