package MT::CMS::Comment;

use strict;
use MT::Util qw( remove_html format_ts relative_date encode_html );
use MT::I18N qw( const break_up_text substr_text length_text );

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
                'mode' => 'list_comment',
                args   => { blog_id => $blog_id }
            )
        );
        $app->add_breadcrumb( $app->translate('Edit Comment') );
        $param->{has_publish_access} = 1 if $app->user->is_superuser;
        $param->{has_publish_access} = (
            ( $perms->can_manage_feedback || $perms->can_edit_all_posts )
            ? 1
            : 0
        ) unless $app->user->is_superuser;
        if ( my $entry = $obj->entry ) {
            my $title_max_len = const('DISPLAY_LENGTH_EDIT_COMMENT_TITLE');
            $param->{entry_title} =
              ( !defined( $entry->title ) || $entry->title eq '' )
              ? $app->translate('(untitled)')
              : $entry->title;
            $param->{entry_title} =
              substr_text( $param->{entry_title}, 0, $title_max_len ) . '...'
              if $param->{entry_title}
              && length_text( $param->{entry_title} ) > $title_max_len;
            $param->{entry_permalink} = $entry->permalink;
            unless ( $param->{has_publish_access} ) {
                $param->{has_publish_access} =
                  ( $perms->can_publish_post
                      && ( $app->user->id == $entry->author_id ) ) ? 1 : 0;
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
                $param->{commenter_url} = $app->uri(
                    mode => 'view',
                    args => { '_type' => 'author', 'id' => $cmtr->id, }
                  )
                  if ( MT::Author::AUTHOR() == $cmtr->type )
                  && $app->user->is_superuser;
            }
            if ( $obj->email !~ m/@/ ) {    # no email for this commenter
                $param->{email_withheld} = 1;
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
    my ($app, $id, $obj, $param) = @_;

    # We never create commenters through the UI, so this
    # is really the only valid condition
    if ($id) {
        my $q = $app->param;
        my $blog_id = $q->param('blog_id');
        my $perms = $app->permissions;
        my $type = $q->param('_type');

        $param->{is_email_hidden} = $obj->is_email_hidden;
        $param->{status}          = {
            MT::Author::PENDING()  => "pending",
            MT::Author::APPROVED() => "approved",
            MT::Author::BANNED()   => "banned"
        }->{ $obj->commenter_status($blog_id) };
        $param->{"commenter_" . $param->{status}} = 1;
        $param->{commenter_url} = $obj->url if $obj->url;

        if ( $app->user->is_superuser()
          || ($perms && $perms->can_administer_blog ) ) {
            $param->{search_type}   = 'author';
            $param->{search_label}  = $app->translate('Users');
        }

        $param->{is_me} = 1 if $obj->id == $app->user->id;
        $param->{type_author} = 1
          if MT::Author::AUTHOR() == $obj->type;
    }

    1;
}

sub list {
    my $app = shift;

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

    my ( %entries, %blogs, %cmntrs );
    my $perms = $app->permissions;
    my $user  = $app->user;
    my $admin = $user->is_superuser
      || ( $perms && $perms->can_administer_blog );
    my $can_empty_junk = $admin
      || ( $perms && $perms->can_manage_feedback )
      ? 1 : 0;
    my $state_editable = $admin
      || ( $perms
        && ( $perms->can_edit_all_posts || $perms->can_manage_feedback ) )
      ? 1 : 0;
    my $state_entry_editable = $admin
      || ( $perms && $perms->can_edit_all_posts )
      ? 1 : 0;
    my $state_commenter_editable = $perms
      && ( $perms->can_publish_post
        || $perms->can_edit_all_posts || $perms->can_manage_feedback )
      ? 1 : 0;
    my $entry_pkg = $app->model('entry');
    my $code      = sub {
        my ( $obj, $row ) = @_;

        # Comment column
        $row->{comment_short} =
          ( substr_text( $obj->text(), 0, $trim_length )
              . ( length_text( $obj->text ) > $trim_length ? "..." : "" ) );
        $row->{comment_short} =
          break_up_text( $row->{comment_short}, $comment_short_len )
          ;    # break up really long strings
        $row->{comment_long} = remove_html( $obj->text );
        $row->{comment_long} =
          break_up_text( $row->{comment_long}, $comment_long_len )
          ;    # break up really long strings

        # Commenter name column
        $row->{author_display} = $row->{author};
        $row->{author_display} =
          substr_text( $row->{author_display}, 0, $author_max_len ) . '...'
          if $row->{author_display}
          && length_text( $row->{author_display} ) > $author_max_len;
        if ( $row->{commenter_id} ) {
            my $cmntr = $cmntrs{ $row->{commenter_id} } ||=
              MT::Author->load( { id => $row->{commenter_id} } );
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
        }

        # Entry column
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
          substr_text( $row->{entry_title}, 0, $title_max_len ) . '...'
          if $row->{entry_title}
          && length_text( $row->{entry_title} ) > $title_max_len;

        # Date column
        my $blog = $blogs{ $obj->blog_id } ||= $obj->blog;
        if ( my $ts = $obj->created_on ) {
            $row->{created_on_time_formatted} =
              format_ts( MT::App::CMS::LISTING_DATETIME_FORMAT(), $ts, $blog, $app->user ? $app->user->preferred_language : undef );
            $row->{created_on_formatted} =
              format_ts( MT::App::CMS::LISTING_DATE_FORMAT(), $ts, $blog, $app->user ? $app->user->preferred_language : undef );

            $row->{created_on_relative} = relative_date( $ts, time, $blog );
        }

        # Permissions
        $row->{has_edit_access} = $state_editable
          || ( $entry && ( $user->id == $entry->author_id ) );
        $row->{can_edit_entry} = $state_entry_editable
          || ( $entry && ($user->id == $entry->author_id ) );
        $row->{can_edit_commenter} = $user->is_superuser ? 1 : 0;
        if ( !$row->{can_edit_commenter} && $row->{commenter_id} ) {
            my $cmntr = $cmntrs{ $row->{commenter_id} };
            if ($cmntr) {
                $row->{can_edit_commenter} = $cmntr->type eq MT::Author::COMMENTER()
                  && $state_commenter_editable
                  ? 1 : 0;
            }
        }

        # Blog column
        if ($blog) {
            $row->{weblog_id}   = $blog->id;
            $row->{weblog_name} = $blog->name;
        }
        else {
            $row->{weblog_name} =
              '* ' . $app->translate('Orphaned comment') . ' *';
        }

        $row->{reply_count} =
          $app->model('comment')->count( { parent_id => $obj->id } );
    };

    my %terms;
    my $filter_col = $app->param('filter');
    if ( $filter_col && ( my $val = $app->param('filter_val') ) ) {
        if ( $filter_col eq 'status' ) {
            if ( $val eq 'approved' ) {
                $terms{visible} = 1;
            }
            elsif ( $val eq 'pending' ) {
                $terms{visible} = 0;
            }
            elsif ( $val eq 'junk' ) {
                $terms{junk_status} = MT::Comment::JUNK();
            }
            else {
                $terms{junk_status} = MT::Comment::NOT_JUNK();
            }
        }
    }

    my %param;
    my $blog_id = $app->param('blog_id');
    $param{feed_name} = $app->translate("Comments Activity Feed");
    $param{feed_url} =
      $app->make_feed_link( 'comment',
        $blog_id ? { blog_id => $blog_id } : undef );
    $param{filter_spam} =
      ( $app->param('filter_key') && $app->param('filter_key') eq 'spam' );
    $param{has_expanded_mode} = 1;
    $param{object_type}       = 'comment';
    $param{screen_id}         = 'list-comment';
    $param{screen_class}      = 'list-comment';
    $param{search_label}      = $app->translate('Comments');
    $param{state_editable}    = $state_editable;
    $param{can_empty_junk}    = $can_empty_junk;
    return $app->listing(
        {
            type   => 'comment',
            code   => $code,
            args   => { sort => 'created_on', direction => 'descend' },
            params => \%param,
            terms    => \%terms,
        }
    );
}

# list of all users, regardless of commenter/author on a blog
sub list_member {
    my $app = shift;

    my $blog_id = $app->param('blog_id');
    $app->return_to_dashboard( redirect => 1 )
      unless $blog_id;

    my $blog  = $app->blog;
    my $user  = $app->user;
    my $perms = $app->permissions;
    return $app->return_to_dashboard( permission => 1 )
      unless $user->is_superuser() || ($perms && $perms->can_administer_blog());

    my $super_user = 1 if $user->is_superuser();
    my $args       = {};
    my $terms      = {};
    my $param = { list_noncron => 1 };
    $args->{join} =
      MT::Permission->join_on( 'author_id', { blog_id => $blog_id, } );

    $args->{sort_order} = 'created_on';
    $args->{direction}  = 'descend';

    $param->{saved} = 1 if $app->param('saved');
    $param->{search_label} = $app->translate('Users');
    $param->{object_type} = 'author';

    my $all_perms;
    my @all_perms = @{ MT::Permission->perms() };
    $all_perms = [@all_perms];
    foreach (@$all_perms) {
        $_->[1] = $app->translate( $_->[1] );
    }

    require MT::Association;
    require MT::Role;
    my @all_roles = MT::Role->load( undef, { sort => 'name' });

    my $sel_role = 0;
    my $filter = $app->param('filter') || '';
    if ($filter eq 'role') {
        my $val = scalar $app->param('filter_val');
        if ($val) {
            $sel_role = $val;
            $args->{join} = MT::Association->join_on('author_id', { blog_id => $blog_id, role_id => $val });
        }
    }
    elsif ($filter eq 'status') {
        my $val = $app->param('filter_val');
        if ($val eq 'disabled') {
            $terms->{status} = 2;
        }
        elsif ($val eq 'pending') {
            $terms->{status} = 3;
        }
        else {
            $terms->{status} = 1;
        }
    }

    my @role_loop;
    foreach my $r (@all_roles) {
        push @role_loop, { role_id => $r->id, role_name => $r->name, selected => $r->id == $sel_role };
    }
    $param->{role_loop} = \@role_loop;
    my $hasher = sub {
        my ( $obj, $row ) = @_;
        if ( ( $row->{email} || '' ) !~ m/@/ ) {
            $row->{email} = '';
        }
        if ( $row->{created_by} ) {
            if ( my $created_by = MT::Author->load( $row->{created_by} ) ) {
                $row->{created_by} = $created_by->name;
            }
            else {
                $row->{created_by} = $app->translate('*User deleted*');
            }
        }
        $row->{is_me}           = $row->{id} == $user->id;
        $row->{has_edit_access} = 1 if $super_user;
        $row->{usertype_author} = 1 if $obj->type == MT::Author::AUTHOR();
        if ( $obj->type == MT::Author::COMMENTER() ) {
            $row->{usertype_commenter} = 1;
            $row->{status_trusted} = 1 if $obj->is_trusted($blog_id);
            if ($row->{name} =~ m/^[a-f0-9]{32}$/) {
                $row->{name} = $row->{nickname} || $row->{url};
            }
        }
        $row->{status_enabled} = 1 if $obj->status == 1;
        my @roles = MT::Role->load(undef, { join => MT::Association->join_on('role_id', { author_id => $row->{id}, blog_id => $blog_id }, { unique => 1 })});
        my @role_loop;
        foreach my $role (@roles) {
            my @perms;
            foreach (@$all_perms) {
                next unless length( $_->[1] || '' );
                push @perms, $app->translate( $_->[1] )
                  if $role->has( $_->[0] );
            }
            my $role_perms = join(", ", @perms);
            push @role_loop, { role_name => $role->name, role_id => $role->id, role_perms => $role_perms };
        }
        $row->{role_loop} = \@role_loop;
        $row->{auth_icon_url} = $obj->auth_icon_url;
    };
    $param->{screen_id} = "list-member";

    return $app->listing(
        {
            type     => 'user',
            template => 'list_member.tmpl',
            terms    => $terms,
            params   => $param,
            args     => $args,
            code     => $hasher,
        }
    );
}

sub list_commenter {
    my $app = shift;
    unless ( $app->user_can_admin_commenters ) {
        return $app->error( $app->translate("Permission denied.") );
    }

    my $q         = $app->param;
    my $list_pref = $app->list_pref('commenter');
    my $blog_id   = $q->param('blog_id');
    my %param     = %$list_pref;
    my %terms     = ( type => MT::Author::COMMENTER() );
    my %terms2    = ();
    my $limit     = $list_pref->{rows};
    my $offset    = $q->param('offset') || 0;
    my %arg;
    require MT::Comment;
    $arg{'join'} = MT::Comment->join_on(
        'commenter_id',
        { ( $blog_id ? ( blog_id => $blog_id ) : () ) },
        {
            'sort'    => 'created_on',
            direction => 'descend',
            unique    => 1
        }
    );
    my ( $filter_col, $val );
    $param{filter_args} = "";

    if (   ( $filter_col = $q->param('filter') )
        && ( $val = $q->param('filter_val') ) )
    {
        if ( !exists( $terms{$filter_col} ) ) {
            if ( $filter_col eq 'status' ) {
                my ($perm) = (
                      $val eq 'neutral'  ? undef
                    : $val eq 'approved' ? 'comment'
                    : $val eq 'banned'   ? 'not_comment'
                    : undef
                );
                $arg{join} = MT::Permission->join_on(
                    'author_id',
                    {
                        blog_id => $blog_id,
                        ( defined $perm ) ? ( permissions => $perm ) : ()
                    }
                );
            }
            else {
                $terms{$filter_col} = $val;
            }

            $param{filter}     = $filter_col;
            $param{filter_val} = $val;
            $param{filter_args} = "&filter=" . encode_url($filter_col) . "&filter_val=" . encode_url($val);
        }
    }
    $arg{'offset'} = $offset if $offset;
    $arg{'limit'} = $limit + 1;
    my $terms = \%terms;
    my $arg   = \%arg;
    my $iter  = MT::Author->load_iter( $terms, $arg );

    my $data = build_commenter_table( $app, iter => $iter, param => \%param );
    if ( @$data > $limit ) {
        pop @$data;
        $param{next_offset}     = 1;
        $param{next_offset_val} = $offset + $limit;
    }
    if ( $offset > 0 ) {
        $param{prev_offset}     = 1;
        $param{prev_offset_val} = $offset - $limit;
        $param{prev_offset_val} = 0 if $param{prev_offset_val} < 0;
    }

    $param{object_type}  = 'commenter';
    $param{search_label} = $app->translate('Commenters');
    $param{list_start}   = $offset + 1;
    $param{list_end}     = $offset + scalar @$data;
    $param{offset}       = $offset;
    $param{limit}        = $limit;
    delete $arg->{limit};
    delete $arg->{offset};
    $param{list_total} = MT::Author->count( $terms, $arg );

    if ( $param{list_total} ) {
        $param{next_max} = $param{list_total} - $limit;
        $param{next_max} = 0 if ( $param{next_max} || 0 ) < $offset + 1;
    }
    $app->add_breadcrumb( $app->translate('Authenticated Commenters') );
    $param{nav_commenters} = 1;
    for my $msg (qw(trusted untrusted banned unbanned)) {
        $param{$msg} = 1 if $app->param($msg);
    }
    return $app->load_tmpl( 'list_commenter.tmpl', \%param );
}

sub build_commenter_table {
    my ($app, %args) = @_;

    my $param = $args{param};
    my $iter;
    if ( $args{load_args} ) {
        my $class = $app->model('commenter');
        $iter = $class->load_iter( @{ $args{load_args} } );
    }
    elsif ( $args{iter} ) {
        $iter = $args{iter};
    }
    elsif ( $args{items} ) {
        $iter = sub { pop @{ $args{items} } };
    }
    return [] unless $iter;

    my $app_user  = $app->user;
    my $user_perm = $app->permissions;
    my $blog_id   = $app->param('blog_id');

    my @data;
    require MT::Blog;
    my $blog = MT::Blog->load($blog_id);
    while ( my $cmtr = $iter->() ) {
        require MT::Comment;
        my $cmt_count = MT::Comment->count(
            {
                commenter_id => $cmtr->id,
                blog_id      => $blog_id
            }
        );
        my $most_recent = MT::Comment->load(
            {
                commenter_id => $cmtr->id,
                blog_id      => $blog_id
            },
            {
                'sort'    => 'created_on',
                direction => 'descend'
            }
        ) if $cmt_count > 0;

        my $blog_connection = MT::Permission->load(
            {
                author_id => $cmtr->id,
                blog_id   => $blog_id
            }
        );

        # Tells us whether the commenter is associated with this
        # blog. the role flags are not important
        next if ( !$cmt_count && !$blog_connection );

        my $row = {};
        $row->{author_id}      = $cmtr->id();
        $row->{author}         = $cmtr->name();
        $row->{author_display} = $cmtr->nickname();
        $row->{email}          = $cmtr->email();
        $row->{url}            = $cmtr->url();
        $row->{email_hidden}   = $cmtr->is_email_hidden();
        $row->{comment_count}  = $cmt_count;
        if ($most_recent) {

            if ( my $ts = $most_recent->created_on ) {
                $row->{most_recent_time_formatted} =
                  format_ts( MT::App::CMS::LISTING_DATETIME_FORMAT(), $ts, $blog, $app->user ? $app->user->preferred_language : undef );
                $row->{most_recent_formatted} =
                  format_ts( MT::App::CMS::LISTING_DATE_FORMAT(), $ts, $blog, $app->user ? $app->user->preferred_language : undef );
                $row->{most_recent_relative} =
                  relative_date( $ts, time, $blog );
            }
        }
        $row->{status} = {
            PENDING  => "neutral",
            APPROVED => "approved",
            BANNED   => "banned"
        }->{ $cmtr->commenter_status($blog_id) };
        $row->{commenter_approved} =
          $cmtr->commenter_status($blog_id) == MT::Author::APPROVED();
        $row->{commenter_banned} =
          $cmtr->commenter_status($blog_id) == MT::Author::BANNED();
        $row->{commenter_url}   = $cmtr->url if $cmtr->url;
        $row->{has_edit_access} = $app->user_can_admin_commenters;
        $row->{object}          = $cmtr;
        push @data, $row;
    }
    return [] unless @data;

    $param->{commenter_table}[0]{object_loop} = \@data if @data;
    $app->load_list_actions( 'commenter', $param->{commenter_table}[0] );
    $param->{commenter_table}[0]{page_actions} =
      $app->page_actions('list_commenter');
    $param->{object_loop} = $param->{commenter_table}[0]{object_loop};
    \@data;
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
            $app->log(
                $app->translate(
                    "User '[_1]' trusted commenter '[_2]'.", $author->name,
                    $cmntr->name
                )
            );
            $acted_on++;
        }
        elsif ($action eq 'ban'
            && $cmntr->commenter_status($blog_id) != MT::Author::BANNED() )
        {
            $cmntr->ban($blog_id) or return $app->error( $cmntr->errstr );
            $app->log(
                $app->translate(
                    "User '[_1]' banned commenter '[_2]'.", $author->name,
                    $cmntr->name
                )
            );
            $acted_on++;
        }
        elsif ($action eq 'unban'
            && $cmntr->commenter_status($blog_id) == MT::Author::BANNED() )
        {
            $cmntr->pending($blog_id) or return $app->error( $cmntr->errstr );
            $app->log(
                $app->translate(
                    "User '[_1]' unbanned commenter '[_2]'.", $author->name,
                    $cmntr->name
                )
            );
            $acted_on++;
        }
        elsif ($action eq 'untrust'
            && $cmntr->commenter_status($blog_id) == MT::Author::APPROVED() )
        {
            $cmntr->pending($blog_id) or return $app->error( $cmntr->errstr );
            $app->log(
                $app->translate(
                    "User '[_1]' untrusted commenter '[_2]'.", $author->name,
                    $cmntr->name
                )
            );
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

sub cfg_comments {
    my $app     = shift;
    my $q       = $app->param;
    my $blog_id = scalar $q->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 )
      unless $blog_id;
    $q->param( '_type', 'blog' );
    $q->param( 'id',    scalar $q->param('blog_id') );
    $app->forward( "view",
        {
            output         => 'cfg_comments.tmpl',
            screen_class   => 'settings-screen',
            screen_id      => 'comment-settings',
        }
    );
}

sub cfg_registration {
    my $app     = shift;
    my $q       = $app->param;
    my $blog_id = scalar $q->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 )
      unless $blog_id;
    $q->param( '_type', 'blog' );
    $q->param( 'id',    scalar $q->param('blog_id') );
    eval { require Digest::SHA1; };
    my $openid_available = $@ ? 0 : 1;
    $app->forward( "view",
        {
            output       => 'cfg_registration.tmpl',
            screen_class => 'settings-screen registration-screen',
            openid_enabled => $openid_available
        }
    );
}

sub cfg_spam {
    my $app = shift;
    my $q   = $app->param;
    $q->param( '_type', 'blog' );
    $q->param( 'id',    scalar $q->param('blog_id') );

    my $plugin_config_html;
    my $plugin_name;
    my $plugin;
    if ( my $p = $q->param('plugin') ) {
        $plugin = $MT::Plugins{$p};
        if ($plugin) {
            $plugin = $plugin->{object};
        }
        else {
            $plugin = MT->component($p);
        }
        return $app->errtrans("Invalid request.") unless $plugin;

        my $scope;
        if ( $q->param('blog_id') ) {
            $scope = 'blog:' . $q->param('blog_id');
        }
        else {
            $scope = 'system';
        }
        $plugin_name = $plugin->name;
        my %plugin_param;
        $plugin->load_config( \%plugin_param, $scope );
        my $snip_tmpl = $plugin->config_template( \%plugin_param, $scope );
        my $tmpl;
        if ( ref $snip_tmpl ne 'MT::Template' ) {
            require MT::Template;
            $tmpl = MT::Template->new(
                type   => 'scalarref',
                source => ref $snip_tmpl
                ? $snip_tmpl
                : \$snip_tmpl
            );
        }
        else {
            $tmpl = $snip_tmpl;
        }

        # Process template independent of $app to avoid premature
        # localization (give plugin a chance to do L10N first).
        $tmpl->param( \%plugin_param );
        $plugin_config_html = $tmpl->output();
        $plugin_config_html =
          $plugin->translate_templatized($plugin_config_html)
          if $plugin_config_html =~ m/<(?:__trans|mt_trans) /i;
    }
    my $filters = MT::Component->registry('junk_filters') || [];
    my %plugins;
    foreach my $set (@$filters) {
        foreach my $f ( values %$set ) {
            $plugins{ $f->{plugin} } = $f->{plugin};
        }
    }
    my @plugins = values %plugins;
    my $loop    = [];
    foreach my $p (@plugins) {
        push @$loop,
          {
            name   => $p->name,
            plugin => $p->id,
            active => ( $plugin && ( $p->id eq $plugin->id ) ? 1 : 0 ),
          },
          ;
    }
    @$loop = sort { $a->{name} cmp $b->{name} } @$loop;

    $app->forward( "view",
        {
            plugin_config_html => $plugin_config_html,
            plugin_name        => $plugin_name,
            junk_filter_loop   => $loop,
            output             => 'cfg_spam.tmpl',
            screen_class       => 'settings-screen spam-screen'
        }
    );
}

sub empty_junk {
    my $app     = shift;
    my $perms   = $app->permissions;
    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');
    return $app->errtrans("Permission denied.")
      if ( !$blog_id && !$user->is_superuser() )
      || (
        $perms
        && !(
               $perms->can_administer_blog
            || $perms->can_edit_all_posts
            || $perms->can_manage_feedback
        )
      );

    my $type  = $app->param('_type');
    my $class = $app->model($type);
    my $arg   = {};
    require MT::Comment;
    $arg->{junk_status} = MT::Comment::JUNK();
    $arg->{blog_id} = $blog_id if $blog_id;
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
    my $perm_checked = ( $app->user->is_superuser()
      || (
        $app->param('blog_id')
        && (   $perms->can_manage_feedback
            || $perms->can_edit_all_posts )
      ) ) ? 1 : 0;

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
            next unless $perms->can_publish_post;
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

    my $perm_checked = ( $app->user->is_superuser()
      || (
        $app->param('blog_id')
        && (   $perms->can_manage_feedback
            || $perms->can_edit_all_posts )
      ) ) ? 1 : 0;

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
            next unless $perms->can_publish_post;
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

sub cfg_system_feedback {
    my $app = shift;
    my %param;
    return $app->redirect(
        $app->uri(
            mode => 'cfg_comments',
            args => { blog_id => $app->param('blog_id') }
        )
    ) if $app->param('blog_id');

    return $app->errtrans("Permission denied.")
      unless $app->user->is_superuser();

    my $cfg = $app->config;
    $param{nav_config} = 1;
    $app->add_breadcrumb( $app->translate('Feedback Settings') );
    $param{nav_settings}         = 1;
    $param{comment_disable}      = $cfg->AllowComments ? 0 : 1;
    $param{ping_disable}         = $cfg->AllowPings ? 0 : 1;
    $param{disabled_notify_ping} = $cfg->DisableNotificationPings ? 1 : 0;
    $param{system_no_email}      = 1 unless $cfg->EmailAddressMain;
    my $send = $cfg->OutboundTrackbackLimit || 'any';

    if ( $send =~ m/^(any|off|selected|local)$/ ) {
        $param{ "trackback_send_" . $cfg->OutboundTrackbackLimit } = 1;
        if ( $send eq 'selected' ) {
            my @domains = $cfg->OutboundTrackbackDomains;
            my $domains = join "\n", @domains;
            $param{trackback_send_domains} = $domains;
        }
    }
    else {
        $param{"trackback_send_any"} = 1;
    }
    $param{saved}        = $app->param('saved');
    $param{screen_class} = "settings-screen system-feedback-settings";
    $app->load_tmpl( 'cfg_system_feedback.tmpl', \%param );
}

sub save_cfg_system_feedback {
    my $app = shift;
    return $app->errtrans("Permission denied.")
      unless $app->user->is_superuser();

    $app->validate_magic or return;
    my $cfg = $app->config;
    $cfg->AllowComments( ( $app->param('comment_disable') ? 0 : 1 ), 1 );
    $cfg->AllowPings(    ( $app->param('ping_disable')    ? 0 : 1 ), 1 );
    $cfg->DisableNotificationPings(
        ( $app->param('disable_notify_ping') ? 1 : 0 ), 1 );
    my $send = $app->param('trackback_send') || 'any';
    if ( $send =~ m/^(any|off|selected|local)$/ ) {
        $cfg->OutboundTrackbackLimit( $send, 1 );
        if ( $send eq 'selected' ) {
            my $domains = $app->param('trackback_send_domains') || '';
            $domains =~ s/[\r\n]+/ /gs;
            $domains =~ s/\s{2,}/ /gs;
            my @domains = split /\s/, $domains;
            $cfg->OutboundTrackbackDomains( \@domains, 1 );
        }
    }

    $cfg->save_config();
    $app->redirect(
        $app->uri(
            'mode' => 'cfg_system_feedback',
            args   => { saved => 1 }
        )
    );
}

sub reply {
    my $app = shift;
    my $q   = $app->param;

    my $reply_to    = encode_html( $q->param('reply_to') );
    my $magic_token = encode_html( $q->param('magic_token') );
    my $blog_id     = encode_html( $q->param('blog_id') );
    my $return_url  = encode_html( $q->param('return_url') );
    my $text        = encode_html( $q->param('text') );
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
<input type="hidden" name="text" value="$text" />
</form></div></body></html>
SPINNER
}

sub do_reply {
    my $app = shift;

    # Save requires POST
    return $app->error( $app->translate("Invalid request") )
      if $app->request_method() ne 'POST';

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
        { %$param, text => $q->param('text') } );
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

    unless ( $user->is_superuser()
        || $perms->can_edit_all_posts
        || $perms->can_manage_feedback )
    {
        return $app->errtrans("Permission denied.")
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
        return_url => $app->base
          . $app->mt_uri . '?'
          . $app->param('return_args'),
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
    if (
        !(
               $entry->author_id == $app->user->id
            || $perms->can_edit_all_posts
            || $perms->can_manage_feedback
        )
      )
    {
        return 0;
    }
    1;
}

sub can_save {
    my ( $eh, $app, $id ) = @_;
    return 0 unless $id;    # Can't create new comments here
    return 1 if $app->user->is_superuser();

    my $perms = $app->permissions;
    return 1
      if $perms
      && ( $perms->can_edit_all_posts
        || $perms->can_manage_feedback );

    my $c = MT::Comment->load($id)
        or return 0;
    if ( $perms && $perms->can_create_post && $perms->can_publish_post ) {
        return $c->entry->author_id == $app->user->id;
    }
    elsif ( $perms && $perms->can_create_post ) {
        return ( $c->entry->author_id == $app->user->id )
          && ( ( $c->is_junk && ( 'junk' eq $app->param('status') ) )
            || ( $c->is_moderated && ( 'moderate' eq $app->param('status') ) )
            || ( $c->is_published && ( 'publish' eq $app->param('status') ) ) );
    }
    elsif ( $perms && $perms->can_publish_post ) {
        return 0 unless $c->entry->author_id == $app->user->id;
        return 0
          unless ( $c->text eq $app->param('text') )
          && ( $c->author eq $app->param('author') )
          && ( $c->email  eq $app->param('email') )
          && ( $c->url    eq $app->param('url') );
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

    # publish_post allows entry author to delete comment.
    return 1
      if $perms->can_edit_all_posts
      || $perms->can_manage_feedback
      || $perms->can_edit_entry( $entry, $author, 1 );
    return 0 if $obj->visible;    # otherwise, visible comment can't be deleted.
    return $perms && $perms->can_edit_entry( $entry, $author );
}

sub pre_save {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;
    my $perms = $app->permissions;
    return 1
      unless $perms->can_publish_post
      || $perms->can_edit_all_posts
      || $perms->can_manage_feedback;

    unless ( $perms->can_edit_all_posts || $perms->can_manage_feedback ) {
        return 1 unless $perms->can_publish_post;
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
            class    => 'system',
            category => 'delete'
        }
    );
}

sub can_view_commenter {
    my $eh = shift;
    my ( $app, $id ) = @_;
    my $auth = MT::Author->load(
        {
            id   => $id,
            type => MT::Author::COMMENTER()
        }
    );
    $auth ? 1 : 0;
}

sub can_delete_commenter {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();
    my $perms = $author->permissions( $obj->blog_id );
    ( $perms && $perms->can_administer_blog );
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
                    if ( !$author->is_superuser ) {
                        if ( !$perms || $perms->blog_id != $obj->blog_id ) {
                            $perms = $author->permissions( $obj->blog_id );
                        }
                        unless ($perms) {
                            return $app->errtrans(
"You don't have permission to approve this comment."
                            );
                        }
                        unless (
                            $perms->can_manage_feedback
                            || ( $perms->can_publish_post
                                && ( $obj_parent->author_id == $author->id ) )
                          )
                        {
                            return $app->errtrans(
"You don't have permission to approve this comment."
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
                if ( !$author->is_superuser ) {
                    if ( !$perms || $perms->blog_id != $obj->blog_id ) {
                        $perms = $author->permissions( $obj->blog_id );
                    }
                    unless ($perms) {
                        return $app->errtrans(
                            "You don't have permission to approve this comment."
                        );
                    }
                    unless (
                        $perms->can_manage_feedback
                        || ( $perms->can_publish_post
                            && ( $entry->author_id == $author->id ) )
                      )
                    {
                        return $app->errtrans(
                            "You don't have permission to approve this comment."
                        );
                    }
                }
                $rebuild_set{ $obj->entry_id } = $entry;
            }
            $obj->visible($new_visible);
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
    my $text = $q->param('text');
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
        my $row = $obj->column_values;
        $row->{author_display} = $row->{author};
        $row->{author_display} =
          substr_text( $row->{author_display}, 0, $author_max_len ) . '...'
          if $row->{author_display}
          && length_text( $row->{author_display} ) > $author_max_len;
        $row->{comment_short} =
          ( substr_text( $obj->text(), 0, $trim_length )
              . ( length_text( $obj->text ) > $trim_length ? "..." : "" ) );
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
          substr_text( $row->{entry_title}, 0, $title_max_len ) . '...'
          if $row->{entry_title}
          && length_text( $row->{entry_title} ) > $title_max_len;
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
                $perms && ( $perms->can_edit_all_posts
                    || $perms->can_manage_feedback )
                  || ( ( $perms->can_publish_post )
                    && ( $author->id == $entry->author_id ) )
            );
            $row->{has_edit_access} = (
                $perms && ( $perms->can_edit_all_posts
                    || $perms->can_manage_feedback )
                  || ( ( $perms->can_create_post )
                    && ( $author->id == $entry->author_id ) )
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

1;
