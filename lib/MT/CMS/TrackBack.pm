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
                'mode' => 'list',
                args   => {
                    '_type' => 'ping',
                    blog_id => $blog_id
                }
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
            class    => 'ping',
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

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;

    my $user = $app->user;
    return if $user->is_superuser;

    my $blog_id = $app->param('blog_id') || 0;
    my $blog = $blog_id ? $app->blog : undef;
    my $blog_ids = !$blog         ? undef
                 : $blog->is_blog ? [ $blog_id ]
                 :                  [ map { $_->id } @{$blog->blogs} ];

    require MT::Permission;
    my $iter = MT::Permission->load_iter(
        {
            author_id => $user->id,
            ( $blog_ids ? ( blog_id => $blog_ids ) : ( blog_id => { 'not' => 0 } ) ),
        }
    );

    my $args = $load_options->{args};
    my $filters;
    while ( my $perm = $iter->() ) {
        if ( $perm->can_do('manage_feedback') || $perm->can_do('manage_pages')) {
            push @$filters, ( '-or', { blog_id => $perm->blog_id } );
        } elsif ( $perm->can_do('create_post') ) {
            push @$filters, ( '-or', {
                blog_id => $perm->blog_id,
                author_id => $user->id,
            } );
        }
    }

    $args->{joins} ||= [];
    push @{ $args->{joins} }, MT->model('entry')->join_on(
        undef, [
             { id => \'=comment_entry_id', },
             '-and',
             $filters,
        ],
    );

    my $terms = $load_options->{terms} || {};
    delete $terms->{blog_id}
        if exists $terms->{blog_id};
}

1;
