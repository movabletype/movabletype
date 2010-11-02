# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::CMS::Comment;

use strict;
use MT::Util qw( remove_html format_ts relative_date encode_html break_up_text );
use MT::I18N qw( const );

sub edit {
    my $cb = shift;
    my ($app, $id, $obj, $param) = @_;

    my $q = $app->param;
    my $blog_id = $q->param('blog_id');
    my $perms = $app->permissions;
    my $blog = $app->blog;
    my $type = $q->param('_type');

    if ($id) {
        $param->{nav_comments} = 1;
        $app->add_breadcrumb(
            $app->translate('Comments'),
            $app->uri(
                'mode' => 'list',
                args   => {
                    '_type' => 'comment',
                    blog_id => $blog_id
                }
            )
        );
        $app->add_breadcrumb( $app->translate('Edit Comment') );
        $param->{has_publish_access} = $app->can_do('edit_comment_status');
        if ( my $entry = $obj->entry ) {
            my $title_max_len = const('DISPLAY_LENGTH_EDIT_COMMENT_TITLE');
            $param->{entry_title} =
              ( !defined( $entry->title ) || $entry->title eq '' )
              ? $app->translate('(untitled)')
              : $entry->title;
            $param->{entry_title} =
              substr( $param->{entry_title}, 0, $title_max_len ) . '...'
              if $param->{entry_title}
              && length( $param->{entry_title} ) > $title_max_len;
            $param->{entry_permalink} = $entry->permalink;
            unless ( $param->{has_publish_access} ) {
                $param->{has_publish_access}
                    = $app->can_do('edit_comment_status_of_own_entry') ? 1 : 0
                        if $app->user->id == $entry->author_id;
            }
        }
        else {
            $param->{no_entry} = 1;
        }
        $param->{comment_approved} = $obj->is_published
          or $param->{comment_pending} = $obj->is_moderated
          or $param->{is_junk}         = $obj->is_junk;

        $param->{created_on_time_formatted} =
          format_ts( MT::App::CMS::LISTING_DATETIME_FORMAT(), $obj->created_on(), $blog, $app->user ? $app->user->preferred_language : undef );
        $param->{created_on_day_formatted} =
          format_ts( MT::App::CMS::LISTING_DATE_FORMAT(), $obj->created_on(), $blog, $app->user ? $app->user->preferred_language : undef );

        $param->{approved}   = $app->param('approved');
        $param->{unapproved} = $app->param('unapproved');
        $param->{is_junk}    = $obj->is_junk;

        $param->{entry_class_label} = $obj->entry->class_label;
        $param->{entry_class} = $obj->entry->class;

        ## Load next and previous entries for next/previous links
        if ( my $next = $obj->next ) {
            $param->{next_comment_id} = $next->id;
        }
        if ( my $prev = $obj->previous ) {
            $param->{previous_comment_id} = $prev->id;
        }
        if ( $obj->junk_log ) {
            require MT::CMS::Comment;
            MT::CMS::Comment::build_junk_table( $app, param => $param, object => $obj );
        }

        if ( my $cmtr_id = $obj->commenter_id ) {
            my $cmtr = $app->model('author')->load($cmtr_id);
            if ($cmtr) {
                $param->{is_mine} = 1 if $cmtr_id == $app->user->id;
                $param->{commenter_approved} =
                  $cmtr->commenter_status( $obj->blog_id ) ==
                  MT::Author::APPROVED();
                $param->{commenter_banned} =
                  $cmtr->commenter_status( $obj->blog_id ) ==
                  MT::Author::BANNED();
                $param->{type_author} = 1
                  if MT::Author::AUTHOR() == $cmtr->type;
                $param->{auth_icon_url} = $cmtr->auth_icon_url;
                $param->{email} = $cmtr->email;
                $param->{url} = $cmtr->url;
                $param->{commenter_url} = $app->uri(
                    mode => 'view',
                    args => { '_type' => 'author', 'id' => $cmtr->id, }
                  )
                  if ( MT::Author::AUTHOR() == $cmtr->type )
                  && $app->user->is_superuser;
            }
        }
        $param->{invisible_unregistered} = !$obj->visible
          && !$obj->commenter_id;

        $param->{search_label} = $app->translate('Comments');
        $param->{object_type}  = 'comment';

        my $children =
          build_comment_table( $app, load_args =>
              [ { parent_id => $obj->id }, { direction => 'descend' } ] );
        $param->{object_loop} = $children if @$children;

        $app->load_list_actions( $type, $param );
    }
    1;
}

sub edit_commenter {
    my $cb = shift;
    my ( $app, $id, $obj, $param ) = @_;

    return $app->errtrans("Invalid request.") if !$id;

    my $q       = $app->param;
    my $blog_id = $q->param('blog_id');
    my $perms   = $app->permissions;
    my $type    = $q->param('_type');

    $param->{is_email_hidden} = $obj->is_email_hidden;
    $param->{status}          = {
        MT::Author::PENDING()  => "pending",
        MT::Author::APPROVED() => "approved",
        MT::Author::BANNED()   => "banned"
    }->{ $obj->commenter_status($blog_id) };
    $param->{ "commenter_" . $param->{status} } = 1;
    $param->{commenter_url} = $obj->url if $obj->url;
    if ( $app->can_do('search_authors') ) {
        $param->{search_type}  = 'author';
        $param->{search_label} = $app->translate('Users');
    }
    $param->{is_me} = 1 if $obj->id == $app->user->id;
    $param->{type_author} = 1
        if MT::Author::AUTHOR() == $obj->type;

    $param->{can_edit_commenters} = $app->user->is_superuser
        ? 1
        : $app->config->SingleCommunity
            ? $app->blog
                ? 0
                : $app->user->can_do('edit_commenter_status')
                    ? 1
                    : 0
            : $app->blog
                ? $app->user->permissions($blog_id)->can_do('edit_commenter_status')
                    ? 1
                    : 0
                : 0;
    1;
}

sub save_commenter_perm {
    my $app      = shift;
    my ($params) = @_;
    my $q        = $app->param;
    my $action   = $q->param('action');

    $app->validate_magic() or return;

    my $acted_on;
    my %rebuild_set;
    my @ids     = $params ? @$params : $app->param('commenter_id');
    my $blog_id = $q->param('blog_id');
    my $author  = $app->user;

    foreach my $id (@ids) {
        ( $id, $blog_id ) = @$id if ref $id eq 'ARRAY';

        my $cmntr = MT::Author->load($id)
          or return $app->errtrans( "No such commenter [_1].", $id );
        my $old_status = $cmntr->commenter_status($blog_id);

        if (   $action eq 'trust'
            && $cmntr->commenter_status($blog_id) != MT::Author::APPROVED() )
        {
            $cmntr->approve($blog_id) or return $app->error( $cmntr->errstr );
            $app->log({
                message => $app->translate(
                    "User '[_1]' trusted commenter '[_2]'.", $author->name,
                    $cmntr->name
                ),
                class => 'comment',
                category => 'edit',
            });
            $acted_on++;
        }
        elsif ($action eq 'ban'
            && $cmntr->commenter_status($blog_id) != MT::Author::BANNED() )
        {
            $cmntr->ban($blog_id) or return $app->error( $cmntr->errstr );
            $app->log({
                message => $app->translate(
                    "User '[_1]' banned commenter '[_2]'.", $author->name,
                    $cmntr->name
                ),
                class => 'comment',
                category => 'edit',
            });
            $acted_on++;
        }
        elsif ($action eq 'unban'
            && $cmntr->commenter_status($blog_id) == MT::Author::BANNED() )
        {
            $cmntr->pending($blog_id) or return $app->error( $cmntr->errstr );
            $app->log({
                message => $app->translate(
                    "User '[_1]' unbanned commenter '[_2]'.", $author->name,
                    $cmntr->name
                ),
                class => 'comment',
                category => 'edit',
            });
            $acted_on++;
        }
        elsif ($action eq 'untrust'
            && $cmntr->commenter_status($blog_id) == MT::Author::APPROVED() )
        {
            $cmntr->pending($blog_id) or return $app->error( $cmntr->errstr );
            $app->log({
                message => $app->translate(
                    "User '[_1]' untrusted commenter '[_2]'.", $author->name,
                    $cmntr->name
                ),
                class => 'comment',
                category => 'edit',
            });
            $acted_on++;
        }

        require MT::Entry;
        require MT::Comment;
        my $iter = MT::Entry->load_iter(
            undef,
            {
                join => MT::Comment->join_on(
                    'entry_id', { commenter_id => $cmntr->id }
                )
            }
        );
        my $e;
        while ( $e = $iter->() ) {
            $rebuild_set{$id} = $e;
        }
    }
    if ($acted_on) {
        my %msgs = (
            trust   => 'trusted',
            ban     => 'banned',
            unban   => 'unbanned',
            untrust => 'untrusted'
        );
        $app->add_return_arg( $msgs{$action} => 1 );
    }
    $app->call_return;
}

sub trust_commenter_by_comment {
    my $app        = shift;
    my @comments   = $app->param('id');
    my @commenters = map_comment_to_commenter( $app, \@comments );
    $app->param( 'action', 'trust' );
    save_commenter_perm( $app, \@commenters );
}

sub untrust_commenter_by_comment {
    my $app        = shift;
    my @comments   = $app->param('id');
    my @commenters = map_comment_to_commenter( $app, \@comments );
    $app->param( 'action', 'untrust' );
    save_commenter_perm( $app, \@commenters );
}

sub ban_commenter_by_comment {
    my $app        = shift;
    my @comments   = $app->param('id');
    my @commenters = map_comment_to_commenter( $app, \@comments );
    $app->param( 'action', 'ban' );
    save_commenter_perm( $app, \@commenters );
}

sub unban_commenter_by_comment {
    my $app        = shift;
    my @comments   = $app->param('id');
    my @commenters = map_comment_to_commenter( $app, \@comments );
    $app->param( 'action', 'unban' );
    save_commenter_perm( $app, \@commenters );
}

sub trust_commenter {
    my $app        = shift;
    my @commenters = $app->param('id');
    $app->param( 'action', 'trust' );
    save_commenter_perm( $app, \@commenters );
}

sub ban_commenter {
    my $app        = shift;
    my @commenters = $app->param('id');
    $app->param( 'action', 'ban' );
    save_commenter_perm( $app, \@commenters );
}

sub unban_commenter {
    my $app        = shift;
    my @commenters = $app->param('id');
    $app->param( 'action', 'unban' );
    save_commenter_perm( $app, \@commenters );
}

sub untrust_commenter {
    my $app        = shift;
    my @commenters = $app->param('id');
    $app->param( 'action', 'untrust' );
    save_commenter_perm( $app, \@commenters );
}

sub approve_item {
    my $app   = shift;
    my $perms = $app->permissions;
    $app->param( 'approve', 1 );
    set_item_visible($app);
}

sub unapprove_item {
    my $app   = shift;
    my $perms = $app->permissions;
    $app->param( 'unapprove', 1 );
    set_item_visible($app);
}

sub empty_junk {
    my $app     = shift;
    my $perms   = $app->permissions;
    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');
    if ($blog_id) {
        $app->can_do('delete_junk_comments')
            or return $app->permission_denied();
    }
    else {
        $app->can_do('delete_all_junk_comments')
            or return $app->permission_denied();
    }

    my $blog_ids = $app->_load_child_blog_ids($blog_id);
    push @$blog_ids, $blog_id if $blog_id;

    my $type  = $app->param('_type');
    my $class = $app->model($type);
    my $arg   = {};
    require MT::Comment;
    $arg->{junk_status} = MT::Comment::JUNK();
    $arg->{blog_id} = $blog_ids if $blog_id;
    $class->remove($arg);
    $app->add_return_arg( 'emptied' => 1 );
    $app->call_return;
}

sub handle_junk {
    my $app   = shift;
    my @ids   = $app->param("id");
    my $type  = $app->param("_type");
    my $class = $app->model($type);
    my @item_loop;
    my $i       = 0;
    my $blog_id = $app->param('blog_id');
    my ( %rebuild_entries, %rebuild_categories );

    my @obj_ids = $app->param('id');
    if ( my $req_nonce = $app->param('nonce') ) {
        if ( scalar @obj_ids == 1 ) {
            my $cmt_id = $obj_ids[0];
            if ( my $obj = $class->load($cmt_id) ) {
                my $nonce =
                  MT::Util::perl_sha1_digest_hex( $obj->id
                      . $obj->created_on
                      . $obj->blog_id
                      . $app->config->SecretToken );
                return $app->errtrans("Invalid request.")
                  unless $nonce eq $req_nonce;
                my $return_args = $app->uri_params(
                    mode => 'view',
                    args => {
                        '_type' => $type,
                        id      => $cmt_id,
                        blog_id => $obj->blog_id
                    }
                );
                $return_args =~ s!^\?!!;
                $app->return_args($return_args);
            }
            else {
                return $app->errtrans("Invalid request.");
            }
        }
        else {
            return $app->errtrans("Invalid request.");
        }
    }
    else {
        $app->validate_magic() or return;
    }

    my $perms = $app->permissions;
    my $perm_checked = $app->can_do('handle_junk');

    foreach my $id (@ids) {
        next unless $id;

        my $obj = $class->load($id) or die "No $class $id";
        my $old_visible = $obj->visible || 0;
        unless ($perm_checked) {
            if ( $obj->isa('MT::TBPing') && $obj->parent->isa('MT::Entry') ) {
                next if $obj->parent->author_id != $app->user->id;
            }
            elsif ( $obj->isa('MT::Comment') ) {
                next if $obj->entry->author_id != $app->user->id;
            }
            next unless $perms->can_do('handle_junk_for_own_entry');
        }
        $obj->junk;
        $app->run_callbacks( 'handle_spam', $app, $obj )
          ;            # mv this into blk below?
        $obj->save;    # (so that each cb doesn't have to save indiv'ly)
        next if $old_visible == $obj->visible;
        if ( $obj->isa('MT::TBPing') ) {
            my ( $parent_type, $parent_id ) = $obj->parent_id();
            if ( $parent_type eq 'MT::Entry' ) {
                $rebuild_entries{$parent_id} = 1;
            }
            else {
                $rebuild_categories{ $obj->category_id } = 1;

                # TODO: do something with this list.
            }
        }
        else {
            $rebuild_entries{ $obj->entry_id } = 1;
        }
    }
    $app->add_return_arg( 'junked' => 1 );
    if (%rebuild_entries) {
        $app->rebuild_these( \%rebuild_entries, how => MT::App::CMS::NEW_PHASE() );
    }
    else {
        $app->call_return;
    }
}

sub not_junk {
    my $app = shift;

    my $perms = $app->permissions;

    my @ids = $app->param("id");
    my @item_loop;
    my $i     = 0;
    my $type  = $app->param('_type');
    my $class = $app->model($type);
    my %rebuild_set;

    my $perm_checked = $app->can_do('handle_not_junk');

    foreach my $id (@ids) {
        next unless $id;
        my $obj = $class->load($id)
            or next;
        unless ($perm_checked) {
            if ( $obj->isa('MT::TBPing') && $obj->parent->isa('MT::Entry') ) {
                next if $obj->parent->author_id != $app->user->id;
            }
            elsif ( $obj->isa('MT::Comment') ) {
                next if $obj->entry->author_id != $app->user->id;
            }
            next unless $perms->can_do('handle_not_junk_for_own_entry');
        }
        $obj->approve;
        $app->run_callbacks( 'handle_ham', $app, $obj );
        if ( $obj->isa('MT::TBPing') ) {
            my ( $parent_type, $parent_id ) = $obj->parent_id();
            if ( $parent_type eq 'MT::Entry' ) {
                $rebuild_set{$parent_id} = 1;
            }
            else {
            }
        }
        else {
            $rebuild_set{ $obj->entry_id } = 1;
        }
        $obj->save();
    }
    $app->param( 'approve', 1 );

    $app->add_return_arg( 'unjunked' => 1 );

    $app->rebuild_these( \%rebuild_set, how => MT::App::CMS::NEW_PHASE() );
}

sub reply {
    my $app = shift;
    my $q   = $app->param;

    my $reply_to    = encode_html( $q->param('reply_to') );
    my $magic_token = encode_html( $q->param('magic_token') );
    my $blog_id     = encode_html( $q->param('blog_id') );
    my $return_url  = encode_html( $q->param('return_url') );
    my $text        = encode_html( $q->param('comment-reply'), 1 );
    my $indicator   = $app->static_path . 'images/indicator.gif';
    my $url         = $app->uri;
    <<SPINNER;
<html><head><style type="text/css">
#dialog-indicator {position: relative;top: 200px;
background: url($indicator)
no-repeat;width: 66px;height: 66px;margin: 0 auto;
}</style><script type="text/javascript">
function init() { var f = document.getElementById('f'); f.submit(); }
window.setTimeout("init()", 1500);
</script></head><body>
<div align="center"><div id="dialog-indicator"></div>
<form id="f" method="post" action="$url">
<input type="hidden" name="__mode" value="do_reply" />
<input type="hidden" name="reply_to" value="$reply_to" />
<input type="hidden" name="magic_token" value="$magic_token" />
<input type="hidden" name="blog_id" value="$blog_id" />
<input type="hidden" name="return_url" value="$return_url" />
<input type="hidden" name="comment-reply" value="$text" />
</form></div></body></html>
SPINNER
}

sub do_reply {
    my $app = shift;

    # Save requires POST
    return $app->error( $app->translate("Invalid request") )
      if $app->request_method() ne 'POST';

    $app->validate_magic
        or return $app->error( $app->translate("Invalid request") );

    my $q   = $app->param;

    my $param = {
        reply_to    => $q->param('reply_to'),
        magic_token => $q->param('magic_token'),
        blog_id     => $q->param('blog_id'),
    };

    my ( $comment, $parent, $entry ) = _prepare_reply($app);
    return unless $comment;

    my $blog = $parent->blog
            || $app->model('blog')->load($q->param('blog_id'));
    return $app->error($app->translate('Can\'t load blog #[_1].', $q->param('blog_id'))) unless $blog;

    unless ( $app->can_do('reply_comment_from_cms') ) {
        my $user  = $app->user;
        my $perms = $app->{perms};
        return unless $perms;

        return $app->permission_denied()
          unless $perms->can_edit_entry( $entry, $user, 1 )
          ;    # check for publish_post
    }

    require MT::Sanitize;
    my $spec = $blog->sanitize_spec
            || $app->config->GlobalSanitizeSpec;
    $param->{commenter_name} = MT::Sanitize->sanitize($parent->author, $spec);
    $param->{entry_title}    = $entry->title;
    $param->{comment_created_on} =
      format_ts( "%Y-%m-%d %H:%M:%S", $parent->created_on, undef, $app->user ? $app->user->preferred_language : undef );
    $param->{comment_text} = $parent->text;

    return $app->build_page( 'dialog/comment_reply.tmpl',
        { %$param, error => $app->errstr } )
      unless $comment;

    $comment->parent_id( $param->{reply_to} );
    $comment->approve;
    return $app->handle_error(
        $app->translate( "An error occurred: [_1]", $comment->errstr() ) )
      unless $comment->save;

    MT::Util::start_background_task(
        sub {
            $app->rebuild_entry( Entry => $parent->entry_id, BuildDependencies => 1 )
              or return $app->publish_error( "Publish failed: [_1]", $app->errstr );
            $app->_send_comment_notification( $comment, q(), $entry,
                $app->model('blog')->load( $param->{blog_id} ), $app->user );
        }
    );
    return $app->build_page( 'dialog/comment_reply.tmpl',
        { closing => 1, return_url => $q->param('return_url') } );
}

sub reply_preview {
    my $app = shift;

    # Preview requires POST
    return $app->error( $app->translate("Invalid request") )
      if $app->request_method() ne 'POST';

    $app->validate_magic or return;

    my $q   = $app->param;
    my $cfg = $app->config;

    my $param = {
        reply_to    => $q->param('reply_to'),
        magic_token => $app->current_magic,
        blog_id     => $q->param('blog_id'),
        return_url  => $q->param('return_url'),
    };
    my ( $comment, $parent, $entry ) = _prepare_reply($app);
    return unless $comment;

    my $blog = $parent->blog
            || $app->model('blog')->load($q->param('blog_id'));
    return $app->error($app->translate('Can\'t load blog #[_1].', $q->param('blog_id'))) unless $blog;

    require MT::Sanitize;
    my $spec = $blog->sanitize_spec
            || $app->config->GlobalSanitizeSpec;
    $param->{commenter_name} = MT::Sanitize->sanitize($parent->author, $spec);
    $param->{entry_title}    = $entry->title;
    $param->{comment_created_on} =
      format_ts( "%Y-%m-%d %H:%M:%S", $parent->created_on, undef, $app->user ? $app->user->preferred_language : undef );
    $param->{comment_text} = MT::Sanitize->sanitize($parent->text, $spec);

    return $app->build_page( 'dialog/comment_reply.tmpl',
        { %$param, error => $app->errstr } )
      unless $comment;

    ## Set timestamp as we would usually do in ObjectDriver.
    my @ts = MT::Util::offset_time_list( time, $entry->blog_id );
    my $ts = sprintf "%04d%02d%02d%02d%02d%02d", $ts[5] + 1900, $ts[4] + 1,
      @ts[ 3, 2, 1, 0 ];
    $comment->created_on($ts);
    $comment->commenter_id( $app->user->id );
    $param->{'comment'} = $comment;

    my $tmpl = $app->load_tmpl('include/comment_detail.tmpl');
    my $ctx  = $tmpl->context;
    $ctx->stash( 'comment', $comment );
    $ctx->stash( 'entry',   $entry );
    $ctx->stash( 'blog',    $parent->blog );
    $param->{'preview_html'} = $tmpl->output;

    return $app->build_page( 'dialog/comment_reply.tmpl',
        { %$param, 'text' => $q->param('comment-reply') } );
}

sub dialog_post_comment {
    my $app = shift;
    $app->validate_magic or return;

    my $user      = $app->user;
    my $parent_id = $app->param('reply_to');

    return $app->errtrans('Parent comment id was not specified.')
      unless $parent_id;

    my $comment_class = $app->model('comment');
    my $parent        = $comment_class->load($parent_id)
      or return $app->errtrans('Parent comment was not found.');
    return $app->errtrans("You can't reply to unapproved comment.")
      unless $parent->is_published;

    my $perms = $app->{perms};
    return unless $perms;

    my $entry_class = $app->_load_driver_for('entry');
    my $entry       = $entry_class->load( $parent->entry_id );

    unless ( $app->can_do('reply_comment_from_cms') ){
        return $app->permission_denied()
          unless $perms->can_edit_entry( $entry, $user, 1 )
          ;    # check for publish_post
    }

    my $blog = $parent->blog
            || $app->model('blog')->load($app->param('blog_id'));
    return $app->error($app->translate('Can\'t load blog #[_1].', $app->param('blog_id'))) unless $blog;

    require MT::Sanitize;
    my $spec = $blog->sanitize_spec
            || $app->config->GlobalSanitizeSpec;
    my $param = {
        reply_to       => $parent_id,
        commenter_name => MT::Sanitize->sanitize($parent->author, $spec),
        entry_title    => $entry->title,
        comment_created_on =>
          format_ts( MT::App::CMS::LISTING_DATETIME_FORMAT(), $parent->created_on, $blog, $app->user ? $app->user->preferred_language : undef ),
        comment_text       => MT::Sanitize->sanitize($parent->text, $spec),
        comment_script_url => $app->config('CGIPath')
          . $app->config('CommentScript'),
        return_url => $app->base . $app->uri(
            mode => 'list',
            args => {
                  '_type' => 'comment',
                  blog_id => $blog->id,
              }
        ),
    };

    $app->load_tmpl( 'dialog/comment_reply.tmpl', $param );
}

sub can_view {
    my $eh = shift;
    my ( $app, $id, $objp ) = @_;
    return 0 unless ($id);
    my $obj = $objp->force() or return 0;
    require MT::Entry;
    my $entry = MT::Entry->load( $obj->entry_id )
      or return 0;
    my $perms = $app->permissions;
    if ( $entry->author_id == $app->user->id ) {
        return $app->can_do('open_own_entry_comment_edit_screen');
    }
    else {
        return $app->can_do('open_comment_edit_screen');
    }
}

sub can_save {
    my ( $eh, $app, $id ) = @_;
    return 0 unless $id;    # Can't create new comments here
    return 1 if $app->user->is_superuser();

    return 1
      if $app->can_do('save_existing_comment');

    my $c = MT::Comment->load($id)
        or return 0;
    if ( $app->can_do('edit_own_entry_comment') ) {
        return $c->entry->author_id == $app->user->id;
    }
    elsif ( $app->can_do('edit_own_entry_comment_without_status') ) {
        return ( $c->entry->author_id == $app->user->id )
          && ( ( $c->is_junk && ( 'junk' eq $app->param('status') ) )
            || ( $c->is_moderated && ( 'moderate' eq $app->param('status') ) )
            || ( $c->is_published && ( 'publish' eq $app->param('status') ) ) );
    }
    else {
        return 0;
    }
}

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();
    my $perms = $app->permissions;
    require MT::Entry;
    my $entry = MT::Entry->load( $obj->entry_id )
        or return 0;
    if ( !$perms || $perms->blog_id != $entry->blog_id ) {
        $perms ||= $author->permissions( $entry->blog_id );
    }

    # TBD: replace this check to new permission syntax.

    # publish_post allows entry author to delete comment.
    return 1 if $app->can_do('delete_every_comment');
    return 1 if $perms->can_edit_entry( $entry, $author, 1 );
    return 0 if $obj->visible;    # otherwise, visible comment can't be deleted.
    return $perms && $perms->can_edit_entry( $entry, $author );
}

sub pre_save {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;
    my $perms = $app->permissions;

    if ( !$app->can_do('edit_all_comments') ) {
        $app->can_do('edit_own_entry_comment')
            or return 1;
        require MT::Entry;
        my $entry = MT::Entry->load( $obj->entry_id )
          or return 1;
        return 1 unless $entry->author_id == $app->user->id;
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

    if ( $obj->visible
        || ( ( $obj->visible || 0 ) != ( $original->visible || 0 ) ) )
    {
        return MT::Util::start_background_task(
            sub {
                my $app = MT->instance;
                if ( !$app->rebuild_entry( Entry => $obj->entry_id, BuildIndexes => 1 ) ) {
                    $app->publish_error(); # logs error as well.
                    return $eh->error( MT->translate( "Publish failed: [_1]", $app->errstr ) );
                }
                1;
            }
        );
    }
    1;
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    require MT::Entry;
    my $title = '';
    if ( my $entry = MT::Entry->load( $obj->entry_id ) ) {
        $title = $entry->title;
    }

    $app->log(
        {
            message => $app->translate(
"Comment (ID:[_1]) by '[_2]' deleted by '[_3]' from entry '[_4]'",
                $obj->id, $obj->author, $app->user->name, $title
            ),
            level    => MT::Log::INFO(),
            class    => 'comment',
            category => 'delete',
        }
    );
}

sub can_view_commenter {
    my ( $eh, $app, $id ) = @_;
    $app->can_do('view_commenter');
}

sub can_delete_commenter {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();
    my $perms = $author->permissions( $obj->blog_id );
    ( $perms && $perms->can_do('administer_blog') );
}

sub build_junk_table {
    my $app = shift;
    my (%args) = @_;

    my $param = $args{param};
    my $obj   = $args{object};

    if ( defined $obj->junk_score ) {
        $param->{junk_score} =
          ( $obj->junk_score > 0 ? '+' : '' ) . $obj->junk_score;
    }
    my $log = $obj->junk_log || '';
    my @log = split /\r?\n/, $log;
    my @junk;
    for ( my $i = 0 ; $i < scalar(@log) ; $i++ ) {
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
        for ( my $j = $i + 1 ; $j < scalar(@log) ; $j++ ) {
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

sub set_item_visible {
    my $app    = shift;
    my $perms  = $app->permissions;
    my $author = $app->user;

    my $type    = $app->param('_type');
    my $class   = $app->model($type);
    $app->setup_filtered_ids
        if $app->param('all_selected');
    my @obj_ids = $app->param('id');

    if ( my $req_nonce = $app->param('nonce') ) {
        if ( scalar @obj_ids == 1 ) {
            my $cmt_id = $obj_ids[0];
            if ( my $obj = $class->load($cmt_id) ) {
                my $nonce =
                  MT::Util::perl_sha1_digest_hex( $obj->id
                      . $obj->created_on
                      . $obj->blog_id
                      . $app->config->SecretToken );
                return $app->errtrans("Invalid request.")
                  unless $nonce eq $req_nonce;
                my $return_args = $app->uri_params(
                    mode => 'view',
                    args => {
                        '_type' => $type,
                        id      => $cmt_id,
                        blog_id => $obj->blog_id
                    }
                );
                $return_args =~ s!^\?!!;
                $app->return_args($return_args);
            }
            else {
                return $app->errtrans("Invalid request.");
            }
        }
        else {
            return $app->errtrans("Invalid request.");
        }
    }
    else {
        $app->validate_magic() or return;
    }

    my $new_visible;
    if ( $app->param('approve') ) {
        $new_visible = 1;
    }
    elsif ( $app->param('unapprove') ) {
        $new_visible = 0;
    }

    my %rebuild_set = ();
    require MT::Entry;
    foreach my $id (@obj_ids) {
        my $obj = $class->load($id)
            or next;
        my $old_visible = $obj->visible || 0;
        if ( $old_visible != $new_visible ) {
            if ( $obj->isa('MT::TBPing') ) {
                my $obj_parent = $obj->parent();
                if ( $obj_parent->isa('MT::Category') ) {
                    my $blog = MT::Blog->load( $obj_parent->blog_id );
                    next unless $blog;
                    $app->publisher->_rebuild_entry_archive_type(
                        Entry       => undef,
                        Blog        => $blog,
                        Category    => $obj_parent,
                        ArchiveType => 'Category'
                    );
                }
                else {
                    if ( !$perms || $perms->blog_id != $obj->blog_id ) {
                        $perms = $author->permissions( $obj->blog_id );
                    }
                    if ( !$app->can_do('approve_all_trackback', $perms) ) {
                        if ( $app->can_do('approve_own_entry_trackback', $perms) ) {
                            return $app->errtrans(
                                "You don't have permission to approve this trackback."
                            ) if $obj_parent->author_id != $author->id;
                        }
                        else {
                            return $app->errtrans(
                                "You don't have permission to approve this trackback."
                            );
                        }
                    }
                    $rebuild_set{ $obj_parent->id } = $obj_parent;
                }
            }
            elsif ( $obj->entry_id ) {

                # TODO: Factor out permissions checking
                my $entry = MT::Entry->load( $obj->entry_id )
                  || return $app->error(
                    $app->translate("Comment on missing entry!") );

                if ( !$perms || $perms->blog_id != $obj->blog_id ) {
                    $perms = $author->permissions( $obj->blog_id );
                }
                unless ($perms) {
                    return $app->errtrans(
                        "You don't have permission to approve this comment."
                    );
                }
                if ( !$app->can_do('approve_all_comment', $perms) ) {
                    if ( $app->can_do('approve_own_entry_comment', $perms) ) {
                        return $app->errtrans(
                            "You don't have permission to approve this comment."
                        ) if $entry->author_id != $author->id;
                    }
                    else {
                        return $app->errtrans(
                            "You don't have permission to approve this comment."
                        );
                    }
                }
                $rebuild_set{ $obj->entry_id } = $entry;
            }
            if ( $new_visible ) {
                $obj->approve;
            }
            else {
                $obj->visible( $new_visible );
            }
            $obj->save();
        }
    }
    my $approved_flag = ( $new_visible ? '' : 'un' ) . 'approved';
    $app->add_return_arg( $approved_flag => 1 );
    return $app->rebuild_these( \%rebuild_set, how => MT::App::CMS::NEW_PHASE() );
}

sub map_comment_to_commenter {
    my $app = shift;
    my ($comments) = @_;
    my %commenters;
    require MT::Comment;
    for my $id (@$comments) {
        my $cmt = MT::Comment->load($id);
        if ( $cmt && $cmt->commenter_id ) {
            $commenters{ $cmt->commenter_id . ':' . $cmt->blog_id } =
              [ $cmt->commenter_id, $cmt->blog_id ];
        }
        else {
            $app->add_return_arg( 'unauth', 1 );
        }
    }
    return values %commenters;
}

sub _prepare_reply {
    my $app = shift;
    my $q   = $app->param;

    my $comment_class = $app->model('comment');
    my $parent        = $comment_class->load( $q->param('reply_to') );
    my $entry         = $app->model('entry')->load( $parent->entry_id );

    if ( !$parent || !$parent->is_published ) {
        $app->error(
            $app->translate("You can't reply to unpublished comment.") );
        return ( undef, $parent, $entry );
    }

    unless ( $app->validate_magic ) {
        $app->error( $app->translate("Invalid request.") );
        return ( undef, $parent, $entry );
    }

    my $nick = $app->user->nickname || $app->translate('Registered User');

    my $comment = $comment_class->new;

    ## Strip linefeed characters.
    my $text = $q->param('comment-reply');
    $text = '' unless defined $text;
    $text =~ tr/\r//d;
    $comment->ip( $app->remote_ip );
    $comment->commenter_id( $app->user->id );
    $comment->blog_id( $entry->blog_id );
    $comment->entry_id( $entry->id );
    $comment->parent_id( $parent->id );
    $comment->author( remove_html($nick) );
    $comment->email( remove_html( $app->user->email ) );
    $comment->text($text);
    if (my $url = $app->user->url ) {
        $comment->url($url);
    }

    $comment->visible(1);    # leave as undefined
    $comment->is_junk(0);

    # strip of any null characters (done after junk checks so they can
    # monitor for that kind of activity)
    for my $field (qw(author email text)) {
        my $val = $comment->column($field);
        if ( $val =~ m/\x00/ ) {
            $val =~ tr/\x00//d;
            $comment->column( $field, $val );
        }
    }

    ( $comment, $parent, $entry );
}

sub build_comment_table {
    my $app = shift;
    my (%args) = @_;

    my $author    = $app->user;
    my $class     = $app->model('comment');
    my $list_pref = $app->list_pref('comment');
    my $entry_pkg = $app->model('entry');
    my $iter;
    if ( $args{load_args} ) {
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
    my $param = $args{param} || {};

    my @data;
    my $i;
    $i = 1;
    my ( %blogs, %entries, %perms, %cmntrs );
    my $trim_length =
      $app->config('ShowIPInformation')
      ? const('DISPLAY_LENGTH_EDIT_COMMENT_TEXT_SHORT')
      : const('DISPLAY_LENGTH_EDIT_COMMENT_TEXT_LONG');
    my $author_max_len = const('DISPLAY_LENGTH_EDIT_COMMENT_AUTHOR');
    my $comment_short_len =
      const('DISPLAY_LENGTH_EDIT_COMMENT_TEXT_BREAK_UP_SHORT');
    my $comment_long_len =
      const('DISPLAY_LENGTH_EDIT_COMMENT_TEXT_BREAK_UP_LONG');
    my $title_max_len = const('DISPLAY_LENGTH_EDIT_COMMENT_TITLE');

    while ( my $obj = $iter->() ) {
        my $row = $obj->get_values;
        $row->{author_display} = $row->{author};
        $row->{author_display} =
          substr( $row->{author_display}, 0, $author_max_len ) . '...'
          if $row->{author_display}
          && length( $row->{author_display} ) > $author_max_len;
        $row->{comment_short} =
          ( substr( $obj->text(), 0, $trim_length )
              . ( length( $obj->text ) > $trim_length ? "..." : "" ) );
        $row->{comment_short} =
          break_up_text( $row->{comment_short}, $comment_short_len )
          ;    # break up really long strings
        $row->{comment_long} = remove_html( $obj->text );
        $row->{comment_long} =
          break_up_text( $row->{comment_long}, $comment_long_len )
          ;    # break up really long strings

        $row->{visible}  = $obj->visible();
        $row->{entry_id} = $obj->entry_id();
        my $blog = $blogs{ $obj->blog_id } ||= $obj->blog;
        my $entry = $entries{ $obj->entry_id } ||=
          $entry_pkg->load( $obj->entry_id );
        unless ($entry) {
            $entry = $entry_pkg->new;
            $entry->title( '* ' . $app->translate('Orphaned comment') . ' *' );
        }
        $row->{entry_class} = $entry->class;
        $row->{entry_class_label} = $entry->class_label;
        $row->{entry_title} = (
              defined( $entry->title ) ? $entry->title
            : defined( $entry->text )  ? $entry->text
            : ''
        );
        $row->{entry_title} = $app->translate('(untitled)')
          if $row->{entry_title} eq '';
        $row->{entry_title} =
          substr( $row->{entry_title}, 0, $title_max_len ) . '...'
          if $row->{entry_title}
          && length( $row->{entry_title} ) > $title_max_len;
        $row->{commenter_id} = $obj->commenter_id() if $obj->commenter_id();
        my $cmntr;
        if ( $obj->commenter_id ) {
            $cmntr = $cmntrs{ $obj->commenter_id } ||= MT::Author->load(
                {
                    id   => $obj->commenter_id(),
                }
            );
        }
        if ($cmntr) {
            $row->{email_hidden} = $cmntr && $cmntr->is_email_hidden();
            $row->{auth_icon_url} = $cmntr->auth_icon_url;

            my $status = $cmntr->commenter_status( $obj->blog_id );
            $row->{commenter_approved} =
              ( $cmntr->commenter_status( $obj->blog_id ) ==
                  MT::Author::APPROVED() );
            $row->{commenter_banned} =
              ( $cmntr->commenter_status( $obj->blog_id ) ==
                  MT::Author::BANNED() );
        }
        if ( my $ts = $obj->created_on ) {
            $row->{created_on_time_formatted} =
              format_ts( MT::App::CMS::LISTING_DATETIME_FORMAT(), $ts, $blog, $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_formatted} =
              format_ts( MT::App::CMS::LISTING_DATE_FORMAT(), $ts, $blog, $app->user ? $app->user->preferred_language : undef );

            $row->{created_on_relative} = relative_date( $ts, time, $blog );
        }
        if ( $author->is_superuser() ) {
            $row->{has_edit_access} = 1;
            $row->{has_bulk_access} = 1;
        }
        else {
            my $perms = $perms{ $obj->blog_id } ||=
              $author->permissions( $obj->blog_id );
            $row->{has_bulk_access} = (
                $perms 
                && ( $app->can_do('bulk_edit_all_comments', $perms) 
                     || ( $app->can_do('bulk_edit_own_entry_comments', $perms)
                          && ( $author->id == $entry->author_id ) )
                )
            );
            $row->{has_edit_access} = (
                $perms 
                && ( $app->can_do('open_all_comment_edit_screen', $perms) 
                     || ( $app->can_do('open_own_entry_comment_edit_screen', $perms)
                          && ( $author->id == $entry->author_id ) )
                )
            );
        }
        if ($blog) {
            $row->{weblog_id}   = $blog->id;
            $row->{weblog_name} = $blog->name;
        }
        else {
            $row->{weblog_name} =
              '* ' . $app->translate('Orphaned comment') . ' *';
        }
        $row->{reply_count} = $class->count( { parent_id => $obj->id } );
        $row->{object} = $obj;
        push @data, $row;
        last if $limit and @data > $limit;
    }
    return [] unless @data;

    my $junk_tab = ( $app->param('tab') || '' ) eq 'junk';
    $param->{comment_table}[0]              = {%$list_pref};
    $param->{comment_table}[0]{object_loop} = \@data;
    $param->{comment_table}[0]{object_type} = 'comment';
    $param->{object_loop} = $param->{comment_table}[0]{object_loop}
      unless exists $param->{object_loop};

    $app->load_list_actions( 'comment', \%$param );
    \@data;
}

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;

    my $user = $app->user;
    return if $user->is_superuser;

    my $blog_ids = $load_options->{blog_ids};
    require MT::Permission;
    my $iter = MT::Permission->load_iter(
        {
            author_id => $user->id,
            ( scalar @$blog_ids ? ( blog_id => $blog_ids ) : ( blog_id => { 'not' => 0 } ) ),
        }
    );

    my $args = $load_options->{args};
    my $filters = [];
    while ( my $perm = $iter->() ) {
        if ( $perm->can_do('view_all_comments') ) {
            push @$filters, '-or' if scalar @$filters;
            push @$filters, { blog_id => $perm->blog_id };
        } elsif ( $perm->can_do('view_own_entry_comment') ) {
            push @$filters, '-or' if scalar @$filters;
            push @$filters, {
                blog_id => $perm->blog_id,
                author_id => $user->id,
            };
        }
    }

    if ( scalar @$filters ) {
        $args->{joins} ||= [];
        push @{ $args->{joins} }, MT->model('entry')->join_on(
            undef, [
                 { id => \'=comment_entry_id', },
                 '-and',
                 $filters,
            ],
        );
    }

    my $terms = $load_options->{terms} || {};
    delete $terms->{blog_id}
        if exists $terms->{blog_id};
}

1;
