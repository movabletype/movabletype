# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Comment;

use strict;
use base qw( MT::Object MT::Scorable );
use MT::Util qw( weaken );

sub JUNK ()     { -1 }
sub NOT_JUNK () { 1 }

__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'blog_id' => 'integer not null',
        'entry_id' => 'integer not null',
        'author' => 'string(100)',
        'commenter_id' => 'integer',
        'visible' => 'boolean',
        'junk_status' => 'smallint',
        'email' => 'string(127)',
        'url' => 'string(255)',
        'text' => 'text',
        'ip' => 'string(50)',
        'last_moved_on' => 'datetime not null',
        'junk_score' => 'float',
        'junk_log' => 'text',
        'parent_id' => 'integer',
    },
    indexes => {
        entry_visible => {
            columns => [ 'entry_id', 'visible', 'created_on' ],
        },
		author => 1,
        email => 1,
        commenter_id => 1,
        last_moved_on => 1, # used for junk expiration

        # For URL lookups to aid spam filtering
        blog_url => {
            columns => [ 'blog_id', 'visible', 'url' ],
        },
        blog_stat => {
            columns => [ 'blog_id', 'junk_status', 'created_on' ],
        },
        blog_visible => {
            columns => [ 'blog_id', 'visible', 'created_on', 'id' ],
        },
		dd_coment_vis_mod => {
			columns => [ 'visible', 'modified_on' ],
		},
        visible_date => {
            columns => [ 'visible', 'created_on' ],
        },
        blog_ip_date => {
            columns => [ 'blog_id', 'ip', 'created_on'],
        },
    },
    meta => 1,
    defaults => {
        junk_status => NOT_JUNK,
        last_moved_on => '20000101000000',
    },
    audit => 1,
    datasource => 'comment',
    primary_key => 'id',
});

my %blocklists = ();

sub class_label {
    return MT->translate("Comment");
}

sub class_label_plural {
    return MT->translate("Comments");
}

sub is_junk {
    $_[0]->junk_status == JUNK;
}

sub is_not_junk {
    $_[0]->junk_status != JUNK;
}

sub list_props {
    return {
        comment => {
            label => 'Comment',
            order => 100,
            display => 'force',
            html  => sub {
                my ( $prop, $obj, $app ) = @_;
                my $text = MT::Util::remove_html($obj->text);
                ## FIXME: Hard coded...
                my $len  = 40;
                if ( $len < length($text) ) {
                    $text = substr($text, 0, $len);
                    $text .= '...';
                }
                elsif ( !$text ) {
                    $text = '...';
                }
                my $id  = $obj->id;
                my $link = $app->uri(
                    mode => 'view',
                    args => {
                        _type   => 'comment',
                        id      => $id,
                        blog_id => $obj->blog_id,
                });
                my $status_img = MT->static_path . 'images/status_icons/';
                $status_img .= $obj->is_junk      ? 'warning.gif'
                             : $obj->is_published ? 'success.gif'
                             :                      'draft.gif';
                my $status_class = $obj->is_junk      ? 'Junk'
                                 : $obj->is_published ? 'Approved'
                                 :                      'Unapproved';
                my $lc_status_class = lc $status_class;

                my $ts = $obj->created_on;
                my $date_format = MT::App::CMS::LISTING_DATE_FORMAT();
                my $blog = $app ? $app->blog : undef;
                my $is_relative = 1;
                ## TBD: should do like this...
                ## my $is_relative = $app->user->date_type eq 'relative' ? 1 : 0;
                my $date= $is_relative ? MT::Util::relative_date( $ts, time, $blog )
                        :                MT::Util::format_ts( $date_format, $ts, $blog, $app->user ? $app->user->preferred_language : undef );

                my $reply_link;
                my $return_arg = $app->uri_params(
                    mode => 'list',
                    args => {
                        _type => 'comment',
                        blog_id => $app->blog ? $app->blog->id : 0,
                });
                my $reply_url  = $app->uri(
                    mode => 'dialog_post_comment',
                    args => {
                        reply_to    => $id,
                        blog_id     => $obj->blog_id,
                        return_args => $return_arg,
                        magic_token => $app->current_magic,
                    },
                );
                my $reply_str = MT->translate('Reply');
                $reply_link = qq{<a href="$reply_url" class="reply-link mt-open-dialog">$reply_str</a>};

                return qq{
                    <span class="icon status $lc_status_class">
                      <img alt="$status_class" src="$status_img" />
                    </span>
                    <a href="$link">$date</a>
                    $reply_link
                    <p class="comment-text description">$text</p>
                };
            },
            sort => sub {
                my $prop = shift;
                my ( $terms, $args ) = @_;
                $args->{sort} = 'created_on';
                return;
            },
            default_sort_order => 'descend',
        },
        author => {
            label => 'Commenter',
            order => 200,
            auto  => 1,
            display => 'default',
            html => sub {
                my ( $prop, $obj, $app, $opts ) = @_;
                my $name = MT::Util::remove_html( $obj->author );
                my ( $link, $status_img, $status_class, $lc_status_class, $auth_img, $auth_label );
                my $id  = $obj->commenter_id;
                my $static = MT->static_path;

                if ( !$id ) {
                    $link = $app->uri(
                        mode => 'search_replace',
                        args => {
                            _type       => 'comment',
                            search_cols => 'author',
                            is_limited  => 1,
                            do_search   => 1,
                            search      => $name,
                            blog_id     => $app->blog ? $app->blog->id : 0,
                    });
                    $status_img = '';
                    $status_class = 'Anonymous';
                    $lc_status_class = lc $status_class;
                    my $link_title = MT->translate('Search other comments from this anonymous commenter');
                    return qq{
                        <span class="commenter">
                          <a href="$link" title="$link_title">$name</a>
                        </span>
                    };
                }

                $link = $app->uri(
                    mode => 'view',
                    args => {
                        _type   => 'commenter',
                        id      => $id,
                        blog_id => $obj->blog_id,
                });
                my $commenter = MT->model('author')->load($id);

                if ( !$commenter ) {
                    $link = $app->uri(
                        mode => 'search_replace',
                        args => {
                            _type       => 'comment',
                            search_cols => 'author',
                            is_limited  => 1,
                            do_search   => 1,
                            search      => $name,
                            blog_id     => $app->blog ? $app->blog->id : 0,
                    });
                    $status_img = '';
                    $status_class = 'Deleted';
                    $lc_status_class = lc $status_class;
                    my $link_title = MT->translate('Search other comments from this deleted commenter');
                    my $optional_status = MT->translate('(Deleted)');
                    return qq{
                        <span class="commenter">
                          <a href="$link" title="$link_title">$name</a> $optional_status
                        </span>
                    };
                }

                my $status = $commenter->status;
                my $status_icon;

                if ( MT->config->SingleCommunity ) {
                    if ( $commenter->type == MT::Author::AUTHOR() ) {
                        $status_icon
                            = $commenter->status == MT::Author::ACTIVE()
                            ? 'user-enabled.gif'
                            : $commenter->status == MT::Author::INACTIVE()
                            ? 'user-disabled.gif'
                            : 'user-pending.gif';
                        $status_class
                            = $commenter->status == MT::Author::ACTIVE()
                            ? 'Enabled'
                            : $commenter->status == MT::Author::INACTIVE()
                            ? 'Disabled'
                            : 'Pending';
                    }
                    else {
                        $status_icon
                            = $commenter->is_trusted(0) ? 'trusted.gif'
                            : $commenter->is_banned(0)  ? 'banned.gif'
                            :                             'authenticated.gif';
                        $status_class
                            = $commenter->is_trusted(0) ? 'Trusted'
                            : $commenter->is_banned(0)  ? 'Banned'
                            :                             'Authenticated';
                    }
                }
                else {
                    my $blog_id = $opts->{blog_id};
                    $status_icon
                        = $commenter->is_trusted($blog_id) ? 'trusted.gif'
                        : $commenter->is_banned($blog_id)  ? 'banned.gif'
                        :   'authenticated.gif';
                    $status_class
                        = $commenter->is_trusted($blog_id) ? 'Trusted'
                        : $commenter->is_banned($blog_id)  ? 'Banned'
                        :                                    'Authenticated';
                }

                $lc_status_class = lc $status_class;
                my $status_url = $static . 'images/status_icons/' . $status_icon;
                $status_img = qq{<img src="$status_url" />};

                $auth_img = $static;
                if ( $commenter->auth_type eq 'MT' ) {
                    $auth_img .= 'images/comment/mt_logo.png';
                    $auth_label = 'Movable Type';
                }
                else {
                    my $auth = MT->registry( commenter_authenticators => $commenter->auth_type );
                    $auth_img .= $auth->{logo_small};
                    $auth_label = $auth->{label};
                    $auth_label = $auth_label->() if ref $auth_label;
                }
                my $link_title = MT->translate(
                    'Edit this [_1] commenter.',
                    MT->translate( $status_class ),
                );

                my $out = qq{
                    <span class="auth-type">
                      <img alt="$auth_label" src="$auth_img" class="auth-type-icon" />
                    </span>
                    <span class="commenter">
                      <a href="$link" title="$link_title">$name</a>
                    </span>
                    <span class="status $lc_status_class">
                      $status_img
                    </span>
                };
            },
        },
        ip => {
            auto  => 1,
            order => 300,
            label => 'IP Address',
            condition => sub { MT->config->ShowIPInformation },
        },
        blog_name => {
            base  => '__common.blog_name',
            order => 400,
        },
        entry => {
            label => 'Entry/Page',
            base => '__virtual.integer',
            col_class => 'string',
            filter_editable => 0,
            order => 500,
            display => 'default',
            sort => sub {
                my $prop = shift;
                my ( $terms, $args ) = @_;
                $args->{joins} ||= [];
                push @{ $args->{joins} }, MT->model('entry')->join_on(
                    undef, {
                        id => \'= comment_entry_id',
                    },
                    {
                        sort => 'title',
                        direction => $args->{direction} || 'ascend',
                    },
                );
                $args->{sort} = [];
                return;
            },
            terms => sub {
                my ( $prop, $args, $db_terms, $db_args ) = @_;
                $db_args->{joins} ||= [];
                push @{ $db_args->{joins} }, MT->model('entry')->join_on(
                    undef,
                    {
                        id => [ '-and', $args->{value}, \'= comment_entry_id' ],
                    },
                );
                return;
            },
            bulk_html => sub {
                my $prop = shift;
                my ( $objs, $app ) = @_;
                my %entry_ids  = map { $_->entry_id => 1 } @$objs;
                my @entries = MT->model('entry')->load({
                    id => [ keys %entry_ids ],
                });
                my %entries   = map { $_->id => $_ } @entries;
                my $title_prop = MT::ListProperty->instance( '__virtual.title' );
                $title_prop->{col} = 'title';
                my @result;
                for my $obj ( @$objs ) {
                    my $id    = $obj->entry_id;
                    my $entry = $entries{$id};
                    my $type  = $entry->class_type;
                    my $img = MT->static_path . 'images/nav_icons/color/' . $type . '.gif';
                    my $title_html = $title_prop->html($entry,$app);
                    push @result, qq{
                        <span class="icon target-type $type">
                          <img src="$img" />
                        </span>
                        $title_html
                    };
                }
                return @result;
            },
            raw => sub {
                my ( $prop, $obj ) = @_;
                my $entry_id = $obj->entry_id;
                return $entry_id ? MT->model('entry')->load($entry_id)->title : '';
            },
            label_via_param => sub {
                my $prop = shift;
                my $app = shift;
                my $entry_id = $app->param('filter_val');
                my $entry = MT->model('entry')->load($entry_id);
                return MT->translate(
                    'Comments on [_1]: [_2]',
                    $entry->class eq 'entry' ? MT->translate('Entry') : MT->translate('Page'),
                    $entry->title,
                );
            },
        },

        modified_on => {
            auto    => 1,
            label   => 'Modified on',
            display => 'none'
        },
        created_on => {
            auto    => 1,
            label   => 'Created on',
            display => 'none'
        },
        status => {
            label => 'Status',
            base => '__virtual.single_select',
            col => 'visible',
            display => 'none',
            terms => sub {
                my ( $prop, $args ) = @_;
                return $args->{value} eq 'approved'  ? { visible => 1, junk_status => NOT_JUNK() }
                     : $args->{value} eq 'pending'   ? { visible => 0, junk_status => NOT_JUNK() }
                     : $args->{value} eq 'junk'      ? { junk_status => JUNK() }
                     :                                 { junk_status => NOT_JUNK() }
                     ;
            },
            single_select_options => [
                { label => 'Approved',         value => 'approved', },
                { label => 'Unapproved',       value => 'pending', },
                { label => 'Not spam',         value => 'not_junk', },
                { label => 'Reported as spam', value => 'junk', },
            ],
        },
        ## Hide default author_name.
        author_name => {
            view => 'none',
        },
        commenter_id => {
            auto => 1,
            filter_editable => 0,
            display => 'none',
            label => 'Commenter ID',
            label_via_param => sub {
                my $prop = shift;
                my ( $app, $val ) = @_;
                my $user = MT->model('author')->load($val);
                return MT->translate(
                    "All comments by [_1] '[_2]'",
                    ( $user->type == MT::Author::COMMENTER()
                        ? $app->translate("Commenter")
                        : $app->translate("Author")
                    ),
                    (     $user->nickname
                        ? $user->nickname . ' (' . $user->name . ')'
                        : $user->name
                    )
                );
            },
        },
        text => {
            auto => 1,
            label => 'Text',
            display => 'none',
        },
        for_current_user => {
            label => 'For my entries',
            terms => sub {
                my ( $prop, $args, $db_terms, $db_args ) = @_;
                my $user = MT->app->user;
                $db_args->{joins} ||= [];
                push @{ $db_args->{joins} }, MT->model('entry')->join_on(
                    undef,
                    {
                        id        => \"= comment_entry_id",
                        author_id => $user->id,
                    },
                );
            },
        },
        email => {
            auto    => 1,
            display => 'none',
            label   => 'Email',
        },
        url => {
            auto    => 1,
            display => 'none',
            label   => 'URL',
        },
        commenter_status => {
            label   => 'Commenter Status',
            display => 'none',
            base    => 'commenter.status',
            terms   => sub {
                my $prop = shift;
                my ( $args, $base_terms, $base_args, $opts, ) = @_;
                my $val = $args->{value};
                if ( $val eq 'deleted' ) {
                    $base_args->{joins} ||= [];
                    push @{ $base_args->{joins} }, MT->model('author')->join_on(
                        undef,
                        {
                            id => \'is null',
                        },
                        {
                            type => 'left',
                            condition => { id => \'= comment_commenter_id' },
                        },
                    );
                    return { commenter_id => \' is not null', };
                }
                elsif ( $val eq 'anonymous' ) {
                    return { commenter_id => \' is null' };
                }
                else {
                    my ( $com_terms, $com_args ) = ( {}, {} );
                    $prop->super( $args, $com_terms, $com_args, $opts );
                    $base_args->{joins} ||= [];
                    push @{ $base_args->{joins} }, MT->model('author')->join_on(
                        undef,
                        { id => \'= comment_commenter_id', %$com_terms },
                        $com_args,
                    );
                }
            },
            single_select_options => [
                { label => 'Deleted Users/Deleted Commenters', value => 'deleted',   },
                { label => 'Enabled Users/Enabled Commenters', value => 'enabled',   },
                { label => 'Disabled Users/Banned Commenters', value => 'disabled',  },
                { label => 'Pending Users/Pending Commenters', value => 'pending',   },
                { label => 'Anonymous Commenters',             value => 'anonymous', },
            ],
        },
    };
}

sub system_filters {
    return {
        not_spam => {
            label => 'Non spam comments',
            items => [
                { type => 'status', args => { value => 'not_junk' }, },
            ],
        },
        not_spam_in_this_website => {
            label => 'Non spam comments on this website',
            view => 'website',
            items => [
                { type => 'current_context' },
                { type => 'status', args => { value => 'not_junk' }, },
            ],
        },
        pending => {
            label => 'Pending comments',
            items => [
                { type => 'status', args => { value => 'moderated' }, },
            ],
        },
        published => {
            label => 'Published comments',
            items => [
                { type => 'status', args => { value => 'approved' }, },
            ],
        },
        comments_on_my_entry => {
            label => 'Comments on my entries/pages',
            items => sub {
                my $login_user = MT->app->user;
                [ { type => 'for_current_user' }, { type => 'current_context' } ],
            },
        },
        comments_in_last_7_days => {
            label => 'Comments in the last 7 days',
            items => [
                { type => 'status', args => { value => 'not_junk' }, },
                { type => 'created_on', args => { option => 'days', days => 7 } }
            ],
        },
        spam => {
            label => 'Spam comments',
            items => [
                { type => 'status', args => { value => 'junk' }, },
            ],
        },
        _comments_by_entry => {
            label => sub {
                my $app = MT->app;
                my $id = $app->param('filter_val');
                my $entry = MT->model('entry')->load($id);
                return 'Comments by entry: ' . $entry->title;
            },
            items => sub {
                my $app = MT->app;
                my $id = $app->param('filter_val');
                return [
                    { type => 'entry', args => { option => 'equal', value => $id } }
                ];
            },
        },
    };
}

sub is_not_blocked { 
    my ($eh, $cmt) = @_;
    
    my($host, @hosts);
    # other URI schemes?
    require MT::Util;
    @hosts = MT::Util::extract_urls($cmt->text);
    
    my $not_blocked = 1;
    my $blog_id = $cmt->blog_id;
    if (!$blocklists{$blog_id}) {
        require MT::Blocklist;
        my @blocks = MT::Blocklist->load( { blog_id => $blog_id } );
        $blocklists{$blog_id} = [ @blocks ];
    }
    if (@{$blocklists{$blog_id}}) {
        for my $h (@hosts) {
            for my $b (@{$blocklists{$blog_id}}) {
                $not_blocked = 0 if ($h eq $b->text);
            }
        }
    }
    $not_blocked;
}

sub next {
    my $comment = shift;
    my($publish_only) = @_;
    $publish_only = $publish_only ? {'visible' => 1} : {};
    $comment->_nextprev('next', $publish_only);
}

sub previous {
    my $comment = shift;
    my($publish_only) = @_;
    $publish_only = $publish_only ? {'visible' => 1} : {};
    $comment->_nextprev('previous', $publish_only);
}

sub _nextprev {
    my $obj = shift;
    my $class = ref($obj);
    my ($direction, $terms) = @_;
    return undef unless ($direction eq 'next' || $direction eq 'previous');
    my $next = $direction eq 'next';

    my $label = '__' . $direction;
    return $obj->{$label} if $obj->{$label};

    my $o = $obj->nextprev(
        direction => $direction,
        terms     => { blog_id => $obj->blog_id, %$terms },
        by        => 'created_on',
    );
    weaken($o->{$label} = $o) if $o;
    return $o;
}

sub entry {
    my ($comment) = @_;
    my $entry = $comment->{__entry};
    unless ($entry) {
        my $entry_id = $comment->entry_id;
        return undef unless $entry_id;
        require MT::Entry;
        $entry = MT::Entry->load($entry_id) or
            return $comment->error(MT->translate(
            "Load of entry '[_1]' failed: [_2]", $entry_id, MT::Entry->errstr));
        $comment->{__entry} = $entry;
    }
    return $entry;
}

sub blog {
    my ($comment) = @_;
    my $blog = $comment->{__blog};
    unless ($blog) {
        my $blog_id = $comment->blog_id;
        require MT::Blog;
        $blog = MT::Blog->load($blog_id) or
            return $comment->error(MT->translate(
            "Load of blog '[_1]' failed: [_2]", $blog_id, MT::Blog->errstr));
        $comment->{__blog} = $blog;
    }
    return $blog;
}

sub junk {
    my ($comment) = @_;
    if (($comment->junk_status || 0) != JUNK) {
        require MT::Util;
        my @ts = MT::Util::offset_time_list(time, $comment->blog_id);
        my $ts = sprintf("%04d%02d%02d%02d%02d%02d",
                         $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0]);
        $comment->last_moved_on($ts);
    }
    $comment->junk_status(JUNK);
    $comment->visible(0);
}

sub moderate {
    my ($comment) = @_;
    $comment->visible(0);
    $comment->junk_status(NOT_JUNK);
}

sub approve {
    my ($comment) = @_;
    $comment->visible(1);
    $comment->junk_status(NOT_JUNK);
}

*publish = \&approve;

sub author {
    my $comment = shift;
    if (!@_ && $comment->commenter_id) {
        require MT::Author;
        if (my $auth = MT::Author->load($comment->commenter_id)) {
            return $auth->nickname;
        }
    }
    return $comment->column('author', @_);
}

sub all_text {
    my $this = shift;
    my $text = $this->column('author') || '';
    $text .= "\n" . ($this->column('email') || '');
    $text .= "\n" . ($this->column('url') || '');
    $text .= "\n" . ($this->column('text') || '');
    $text;
}

sub is_published {
    return $_[0]->visible && !$_[0]->is_junk;
}

sub is_moderated {
    return !$_[0]->visible() && !$_[0]->is_junk();
}

sub log {
    # TBD: pre-load __junk_log when loading the comment
    my $comment = shift;
    push @{$comment->{__junk_log}}, @_;
}

sub save {
    my $comment = shift;
    $comment->junk_log(join "\n", @{$comment->{__junk_log}})
        if ref $comment->{__junk_log} eq 'ARRAY';
    my $ret = $comment->SUPER::save();
    delete $comment->{__changed}{visibility} if $ret;
    return $ret;
}

sub to_hash {
    my $cmt = shift;
    my $hash = $cmt->SUPER::to_hash();

    $hash->{'comment.created_on_iso'} = sub { MT::Util::ts2iso($cmt->blog, $cmt->created_on) };
    $hash->{'comment.modified_on_iso'} = sub { MT::Util::ts2iso($cmt->blog, $cmt->modified_on) };
    if (my $blog = $cmt->blog) {
        $hash->{'comment.text_html'} = sub {
            my $txt = defined $cmt->text ? $cmt->text : '';
            require MT::Util;
            $txt = MT::Util::munge_comment($txt, $blog);
            my $convert_breaks = $blog->convert_paras_comments;
            $txt = $convert_breaks ?
                MT->apply_text_filters($txt, $blog->comment_text_filters) :
                $txt;
            my $sanitize_spec = $blog->sanitize_spec ||
                MT->config->GlobalSanitizeSpec;
            require MT::Sanitize;
            MT::Sanitize->sanitize($txt, $sanitize_spec);
        }
    }
    if (my $entry = $cmt->entry) {
        my $entry_hash = $entry->to_hash;
        $hash->{"comment.$_"} = $entry_hash->{$_} foreach keys %$entry_hash;
    }
    if ($cmt->commenter_id) {
        # commenter record exists... populate it
        require MT::Author;
        if (my $auth = MT::Author->load($cmt->commenter_id)) {
            my $auth_hash = $auth->to_hash;
            $hash->{"comment.$_"} = $auth_hash->{$_} foreach keys %$auth_hash;
        }
    }

    $hash;
}

sub visible {
    my $comment = shift;
    return $comment->SUPER::visible unless @_;

    ## Note transitions in visibility in the object, so that
    ## other methods can act appropriately.
    my $was_visible = $comment->SUPER::visible || 0;
    my $is_visible = shift || 0;

    my $vis_delta = 0;
    if (!$was_visible && $is_visible) {
        $vis_delta = 1;
    } elsif ($was_visible && !$is_visible) {
        $vis_delta = -1;
    }
    $comment->{__changed}{visibility} ||= 0;
    $comment->{__changed}{visibility} += $vis_delta;

    return $comment->SUPER::visible($is_visible);
}

sub parent {
    my $comment = shift;
    $comment->cache_property('parent', sub {
        if ($comment->parent_id) {
            return MT::Comment->load($comment->parent_id);
        }
    });
}

1;
__END__

=head1 NAME

MT::Comment - Movable Type comment record

=head1 SYNOPSIS

    use MT::Comment;
    my $comment = MT::Comment->new;
    $comment->blog_id($entry->blog_id);
    $comment->entry_id($entry->id);
    $comment->author('Foo');
    $comment->text('This is a comment.');
    $comment->save
        or die $comment->errstr;

=head1 DESCRIPTION

An I<MT::Comment> object represents a comment in the Movable Type system. It
contains all of the metadata about the comment (author name, email address,
homepage URL, IP address, etc.), as well as the actual body of the comment.

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::Comment> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

=head1 DATA ACCESS METHODS

The I<MT::Comment> object holds the following pieces of data. These fields can
be accessed and set using the standard data access methods described in the
I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the comment.

=item * blog_id

The numeric ID of the blog in which the comment is found.

=item * entry_id

The numeric ID of the entry on which the comment has been made.

=item * author

The name of the author of the comment.

=item * commenter_id

The author_id for the commenter; this will only be defined if the
commenter is registered, which is only required if the blog config
option allow_unreg_comments is false.

=item * ip

The IP address of the author of the comment.

=item * email

The email address of the author of the comment.

=item * url

The URL of the author of the comment.

=item * text

The body of the comment.

=item * visible

Returns a true value if the comment should be displayed. Comments can
be hidden if comment registration is required and the commenter is
pending approval.

=item * created_on

The timestamp denoting when the comment record was created, in the format
C<YYYYMMDDHHMMSS>. Note that the timestamp has already been adjusted for the
selected timezone.

=item * modified_on

The timestamp denoting when the comment record was last modified, in the
format C<YYYYMMDDHHMMSS>. Note that the timestamp has already been adjusted
for the selected timezone.

=back

=head1 DATA LOOKUP

In addition to numeric ID lookup, you can look up or sort records by any
combination of the following fields. See the I<load> documentation in
I<MT::Object> for more information.

=over 4

=item * created_on

=item * entry_id

=item * blog_id

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
