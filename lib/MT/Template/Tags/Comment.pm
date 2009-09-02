# Movable Type (r) Open Source (C) 2001-2009 Six Apart Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: Comment.pm 107171 2009-07-19 16:09:46Z ytakayama $
package MT::Template::Tags::Comment;

use strict;

use MT;
use MT::Entry;
use MT::Util qw( encode_html encode_js remove_html spam_protect encode_url );
use MT::Promise qw( delay );
use MT::I18N qw( first_n_text );

sub _comment_follow {
    my($ctx, $arg) = @_;
    my $c = $ctx->stash('comment');
    return unless $c;

    my $blog = $ctx->stash('blog');
    if ($blog && $blog->nofollow_urls) {
        if ($blog->follow_auth_links) {
            my $cmntr = $ctx->stash('commenter');
            unless ($cmntr) {
                if ($c->commenter_id) {
                    $cmntr = MT::Author->load($c->commenter_id) || undef;
                }
            }
            if (!defined $cmntr || ($cmntr && !$cmntr->is_trusted($blog->id))) {
                $ctx->nofollowfy_on($arg);
            }
        } else {
            $ctx->nofollowfy_on($arg);
        }
    }
}

###########################################################################

=head2 IfCommentsModerated

A conditional tag that is true when the blog is configured to moderate
incoming comments from anonymous commenters.

=for tags comments

=cut

sub _hdlr_comments_moderated {
    my ($ctx) = @_;
    my $blog = $ctx->stash('blog');
    if ($blog->moderate_unreg_comments || $blog->manual_approve_commenters) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 WebsiteIfCommentsOpen

A conditional tag that returns true when: the system is configured to
allow comments and the website is configured to accept comments in some
fashion.

=for tags comments

=cut

###########################################################################

=head2 BlogIfCommentsOpen

A conditional tag that returns true when: the system is configured to
allow comments and the blog is configured to accept comments in some
fashion.

=for tags comments

=cut

sub _hdlr_blog_if_comments_open {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    if ($ctx->{config}->AllowComments &&
        (($blog->allow_reg_comments && $blog->effective_remote_auth_token)
         || $blog->allow_unreg_comments)) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 Comments

A container tag which iterates over a list of comments on an entry or for a
blog. By default, all comments in context (e.g. on an entry or in a blog) are
returned. When used in a blog context, only comments on published entries are
returned.

B<Attributes:>

=over 4

=item * lastn

Display the last N comments in context where N is a positive integer.
B<NOTE: lastn required in a blog context.>

=item * offset (optional; default "0")

Specifies a number of comments to skip.

=item * sort_by (optional)

Specifies a sort column.

=item * sort_order (optional)

Specifies the sort order and overrides the General Settings. Recognized
values are "ascend" and "descend."

=item * namespace

Used in conjunction with the "min*", "max*" attributes to
select comments based on a particular scoring mechanism.

=item * min_score

If 'namespace' is also specified, filters the comments based on
the score within that namespace. This specifies the minimum score
to consider the comment for inclusion.

=item * max_score

If 'namespace' is also specified, filters the comments based on
the score within that namespace. This specifies the maximum score
to consider the comment for inclusion.

=item * min_rate

If 'namespace' is also specified, filters the comments based on
the rank within that namespace. This specifies the minimum rank
to consider the comment for inclusion.

=item * max_rate

If 'namespace' is also specified, filters the comments based on
the rank within that namespace. This specifies the maximum rank
to consider the comment for inclusion.

=item * min_count

If 'namespace' is also specified, filters the comments based on
the count within that namespace. This specifies the minimum count
to consider the comment for inclusion.

=item * max_count

If 'namespace' is also specified, filters the comments based on
the count within that namespace. This specifies the maximum count
to consider the comment for inclusion.

=back

=for tags multiblog, comments, loop, scoring

=cut

sub _hdlr_comments {
    my($ctx, $args, $cond) = @_;

    my (%terms, %args);
    my @filters;
    my @comments;
    my $comments = $ctx->stash('comments');
    my $blog_id = $ctx->stash('blog_id');
    my $blog = $ctx->stash('blog');
    my $namespace = $args->{namespace};
    if ($args->{namespace}) {
        my $need_join = 0;
        if ($args->{sort_by} && ($args->{sort_by} eq 'score' || $args->{sort_by} eq 'rate')) {
            $need_join = 1;
        } else {
            for my $f qw( min_score max_score min_rate max_rate min_count max_count scored_by ) {
                if ($args->{$f}) {
                    $need_join = 1;
                    last;
                }
            }
        }
        if ($need_join) {
            my $scored_by = $args->{scored_by} || undef;
            if ($scored_by) {
                require MT::Author;
                my $author = MT::Author->load({ name => $scored_by }) or
                    return $ctx->error(MT->translate(
                        "No such user '[_1]'", $scored_by ));
                $scored_by = $author;
            }
            $args{join} = MT->model('objectscore')->join_on(undef,
                {
                    object_id => \'=comment_id',
                    object_ds => 'comment',
                    namespace => $namespace,
                    (!$comments && $scored_by ? (author_id => $scored_by->id) : ()),
                }, {
                    unique => 1,
            });
            if ($comments && $scored_by) {
                push @filters, sub { $_[0]->get_score($namespace, $scored_by) };
            }
        }

        # Adds a rate or score filter to the filter list.
        if ($args->{min_score}) {
            push @filters, sub { $_[0]->score_for($namespace) >= $args->{min_score}; };
        }
        if ($args->{max_score}) {
            push @filters, sub { $_[0]->score_for($namespace) <= $args->{max_score}; };
        }
        if ($args->{min_rate}) {
            push @filters, sub { $_[0]->score_avg($namespace) >= $args->{min_rate}; };
        }
        if ($args->{max_rate}) {
            push @filters, sub { $_[0]->score_avg($namespace) <= $args->{max_rate}; };
        }
        if ($args->{min_count}) {
            push @filters, sub { $_[0]->vote_for($namespace) >= $args->{min_count}; };
        }
        if ($args->{max_count}) {
            push @filters, sub { $_[0]->vote_for($namespace) <= $args->{max_count}; };
        }
    }

    my $so = lc ($args->{sort_order} || ($blog ? $blog->sort_order_comments : undef) || 'ascend');
    my $no_resort;

    # if old comments are present in the stash
    if ($comments) {
        my $n = $args->{lastn};
        my $col = lc($args->{sort_by} || 'created_on');
        @$comments = $so eq 'ascend' ?
            sort { $a->created_on cmp $b->created_on } @$comments :
            sort { $b->created_on cmp $a->created_on } @$comments;
        $no_resort = 1
            unless $args->{sort_order} || $args->{sort_by};
        if (@filters) {
            my $offset = $args->{offset} || 0;
            my $j      = 0;
            COMMENTS: for my $c (@$comments) {
                for (@filters) {
                    next COMMENTS unless $_->($c);
                }
                next if $offset && $j++ < $offset;
                push @comments, $c;
            }
        }
        else {
            my $offset;
            if ($offset = $args->{offset}) {
                if ($offset < scalar @comments) {
                    @comments = @$comments[$offset..$#comments];
                } else {
                    @comments = ();
                }
            } else {
                @comments = @$comments;
            }
        }
        if ($n) {
            my $max = $n - 1 > $#comments ? $#comments : $n - 1;
            @comments = $so eq 'ascend' ?
                @comments[$#comments-$max..$#comments] :
                @comments[0..$max];
        }
    } 
    # if there are no comments in the stash
    else {
        $terms{visible} = 1;
        $ctx->set_blog_load_context($args, \%terms, \%args)
            or return $ctx->error($ctx->errstr);

        ## If there is a "lastn" arg, then we need to check if there is an entry
        ## in context. If so, grab the N most recent comments for that entry;
        ## otherwise, grab the N most recent comments for the entire blog.
        my $n = $args->{lastn};
        if (my $e = $ctx->stash('entry')) {
            ## Sort in descending order unless sort_order is specified
            ## then grab the first $n ($n mos recent) comments.
            $args{'sort'} = 'created_on';
            if ($so) {
                $args{'direction'} = $so;
            } else {
                $args{'direction'} = 'descend';
            }
            my $cmts = $e->comments(\%terms, \%args);
            my $offset = $args->{offset} || 0;
            if (@filters) {
                my $i = 0;
                my $j = 0;
                my $offset = $args->{offset} || 0;
                COMMENTS: for my $c (@$cmts) {
                    for (@filters) {
                        next COMMENTS unless $_->($c);
                    }
                    next if $offset && $j++ < $offset;
                    push @comments, $c;
                    last if $n && ( $n <= ++$i );
                }
            } elsif ($offset || $n) {
                if ($offset) {
                    if ($offset < scalar @$cmts - 1) {
                        @$cmts = @$cmts[$offset..(scalar @$cmts - 1)];
                     } else {
                        @$cmts = ();
                    }
                }
                if ($n) {
                    my $max = $n - 1 > scalar @$cmts - 1 ? scalar @$cmts - 1 : $n - 1;
                    @$cmts = @$cmts[0..$max];
                }
                @comments = @$cmts;
            } else {
                @comments = @$cmts;
            }
        } 
        # else look for most recent comments in the entire blog
        else {
            $args{'sort'} = lc $args->{sort_by} || 'created_on';
            #if ($args->{lastn} || $args->{offset}) {
            #    $args{'direction'} =  'descend';
            #    $so = 'descend';
            #} else {
            #    $args{'direction'} =  'ascend';
            #    $no_resort = 1
            #        unless $args->{sort_order} || $args->{sort_by};
            #}
            $args{'sort'} = 'created_on';
            if ($so) {
                $args{'direction'} = $so;
             } else {
                $args{'direction'} = 'descend';
             }

            require MT::Comment;
            if (!@filters) {
                $args{limit} = $n if $n;
                $args{offset} = $args->{offset} if $args->{offset};
                $args{join} = MT->model('entry')->join_on(
                    undef,
                    {
                        id => \'=comment_entry_id',
                        status => MT::Entry::RELEASE(),
                    }, {unique => 1});

                @comments = MT::Comment->load(\%terms, \%args);
            } else {
                my $iter = MT::Comment->load_iter(\%terms, \%args);
                my %entries;
                my $j = 0;
                my $offset = $args->{offset} || 0;
                COMMENT: while (my $c = $iter->()) {
                    my $e = $entries{$c->entry_id} ||= $c->entry;
                    next unless $e;
                    next if $e->status != MT::Entry::RELEASE();
                    for (@filters) {
                        next COMMENT unless $_->($c);
                    }
                    next if $offset && $j++ < $offset;
                    push @comments, $c;
                    if ($n && (scalar @comments == $n)) {
                        $iter->end;
                        last;
                    }
                }
            }
        }
    }

    if (!$no_resort) {
        my $col = lc ($args->{sort_by} || 'created_on');
        if (@comments) {
            if ('created_on' eq $col) {
                my @comm;
                @comm = $so eq 'ascend' ?
                    sort { $a->created_on <=> $b->created_on } @comments :
                    sort { $b->created_on <=> $a->created_on } @comments;
                # filter out comments from unapproved commenters
                @comments = grep { $_->visible() } @comm;
            } elsif ('score' eq $col) {
                my %m = map { $_->id => $_ } @comments;
                my @cid = keys %m;
                require MT::ObjectScore;
                my $scores = MT::ObjectScore->sum_group_by(
                    { 'object_ds' => 'comment', 'namespace' => $namespace, object_id => \@cid },
                    { 'sum' => 'score', group => ['object_id'],
                      $so eq 'ascend' ? (direction => 'ascend') : (direction => 'descend'),
                    });
                my @tmp;
                while (my ($score, $object_id) = $scores->()) {
                    push @tmp, delete $m{ $object_id } if exists $m{ $object_id };
                    $scores->end, last unless %m;
                }
                @comments = @tmp;
            } elsif ('rate' eq $col) {
                my %m = map { $_->id => $_ } @comments;
                my @cid = keys %m;
                require MT::ObjectScore;
                my $scores = MT::ObjectScore->avg_group_by(
                    { 'object_ds' => 'comment', 'namespace' => $namespace, object_id => \@cid },
                    { 'avg' => 'score', group => ['object_id'],
                      $so eq 'ascend' ? (direction => 'ascend') : (direction => 'descend'),
                    });
                my @tmp;
                while (my ($score, $object_id) = $scores->()) {
                    push @tmp, delete $m{ $object_id } if exists $m{ $object_id };
                    $scores->end, last unless %m;
                }
                @comments = @tmp;
            }
        }
    }

    my $html = '';
    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $i = 1;

    local $ctx->{__stash}{commenter} = $ctx->{__stash}{commenter};
    my $vars = $ctx->{__stash}{vars} ||= {};
    my $glue = $args->{glue};
    for my $c (@comments) {
        local $vars->{__first__} = $i == 1;
        local $vars->{__last__} = ($i == scalar @comments);
        local $vars->{__odd__} = ($i % 2) == 1;
        local $vars->{__even__} = ($i % 2) == 0;
        local $vars->{__counter__} = $i;
        local $ctx->{__stash}{blog} = $c->blog;
        local $ctx->{__stash}{blog_id} = $c->blog_id;
        local $ctx->{__stash}{comment} = $c;
        local $ctx->{current_timestamp} = $c->created_on;
        $ctx->stash('comment_order_num', $i);
        if ($c->commenter_id) {
            $ctx->stash('commenter', delay(sub {MT::Author->load($c->commenter_id)}));
        } else {
            $ctx->stash('commenter', undef);
        }
        my $out = $builder->build($ctx, $tokens,
            { CommentsHeader => $i == 1,
              CommentsFooter => ($i == scalar @comments), %$cond } );
        return $ctx->error( $builder->errstr ) unless defined $out;
        $html .= $glue if defined $glue && length($html) && length($out);
        $html .= $out;
        $i++;
    }
    if (!@comments) {
        return MT::Template::Context::_hdlr_pass_tokens_else(@_);
    }
    return $html;
}

###########################################################################

=head2 CommentsHeader

The contents of this container tag will be displayed when the first
comment listed by a L<Comments> or L<CommentReplies> tag is reached.

=for tags comments

=cut

###########################################################################

=head2 CommentsFooter

The contents of this container tag will be displayed when the last
comment listed by a L<Comments> or L<CommentReplies> tag is reached.

=for tags comments

=cut

###########################################################################

=head2 CommentEntry

A block tag that can be used to set the parent entry of the comment
in context.

B<Example:>

    <mt:Comments lastn="4">
        <$mt:CommentAuthor$> left a comment on
        <mt:CommentEntry><$mt:EntryTitle$></mt:CommentEntry>.
    </mt:Comments>

=for tags comments

=cut

sub _hdlr_comment_entry {
    my($ctx, $args, $cond) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $entry = MT::Entry->load($c->entry_id)
        or return '';
    local $ctx->{__stash}{entry} = $entry;
    local $ctx->{current_timestamp} = $entry->authored_on;
    $ctx->stash('builder')->build($ctx, $ctx->stash('tokens'), $cond);
}

###########################################################################

=head2 CommentIfModerated

Conditional tag for testing whether the current comment in context is
moderated or not (used for application, email and comment response
templates where the comment may not actually be published).

=for tags comments

=cut

sub _hdlr_comment_if_moderated {
    my ($ctx) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    return $c->visible ? 1 : 0;
}

###########################################################################

=head2 CommentParent

A block tag that can be used to set the parent comment of the current
comment in context. If the current comment has no parent, it produces
nothing.

B<Example:>

    <mt:CommentParent>
        (a reply to <$mt:CommentAuthor$>'s comment)
    </mt:CommentParent>

=for tags comments

=cut

sub _hdlr_comment_parent {
    my($ctx, $args, $cond) = @_;

    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    $c->parent_id && (my $parent = MT::Comment->load($c->parent_id))
        or return '';
    local $ctx->{__stash}{comment} = $parent;
    $ctx->stash('builder')->build($ctx, $ctx->stash('tokens'), $cond);
}

###########################################################################

=head2 CommentReplies

A block tag which iterates over a list of reply comments to the 
in context.

B<Example:>

    <mt:Comment>
      <mt:CommentReplies>
        <mt:CommentsHeader>Replies to the comment:</mt:CommentsHeader>
        <$mt:CommentBody$>
      </mt:CommentReplies>
    </mt:Comment>

=for tags comments, loop

=cut

sub _hdlr_comment_replies {
    my($ctx, $args, $cond) = @_;

    my $comment = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $tokens = $ctx->stash('tokens');

    $ctx->stash('_comment_replies_tokens', $tokens);

    my (%terms, %args);
    $terms{parent_id} = $comment->id;
    $terms{visible} = 1;
    $args{'sort'} = 'created_on';
    $args{'direction'} = 'descend';
    require MT::Comment;
    my $iter = MT::Comment->load_iter(\%terms, \%args);
    my %entries;
    my $blog = $ctx->stash('blog');
    my $so = lc($args->{sort_order}) || ($blog ? $blog->sort_order_comments : undef) || 'ascend';
    my $n = $args->{lastn};
    my @comments;
    while (my $c = $iter->()) {
        push @comments, $c;
        if ($n && (scalar @comments == $n)) {
            $iter->end;
            last;
        }
    }
    @comments = $so eq 'ascend' ?
        sort { $a->created_on <=> $b->created_on } @comments :
        sort { $b->created_on <=> $a->created_on } @comments;

    my $html = '';
    my $builder = $ctx->stash('builder');
    my $i = 1;
    
    @comments = grep { $_->visible() } @comments;

    local $ctx->{__stash}{commenter} = $ctx->{__stash}{commenter};
    my $vars = $ctx->{__stash}{vars} ||= {};
    for my $c (@comments) {
        local $vars->{__first__} = $i == 1;
        local $vars->{__last__} = ($i == scalar @comments);
        local $vars->{__odd__} = ($i % 2) == 1;
        local $vars->{__even__} = ($i % 2) == 0;
        local $vars->{__counter__} = $i;
        local $ctx->{__stash}{blog} = $c->blog;
        local $ctx->{__stash}{blog_id} = $c->blog_id;
        local $ctx->{__stash}{comment} = $c;
        local $ctx->{current_timestamp} = $c->created_on;
        $ctx->stash('comment_order_num', $i);
        if ($c->commenter_id) {
            $ctx->stash('commenter', delay(sub {MT::Author->load($c->commenter_id)}));
        } else {
            $ctx->stash('commenter', undef);
        }
        my $out = $builder->build($ctx, $tokens,
            { CommentsHeader => $i == 1,
              CommentsFooter => ($i == scalar @comments), } );
        return $ctx->error( $builder->errstr ) unless defined $out;
        $html .= $out;
        $i++;
    }
    if (!@comments) {
        return MT::Template::Context::_hdlr_pass_tokens_else(@_);
    }
    $html;
}

###########################################################################

=head2 IfCommentParent

A conditional tag that is true when the comment currently in context
is a reply to another comment.

B<Example:>

    <mt:IfCommentParent>
        (a reply)
    </mt:IfCommentParent>

=for tags comments

=cut

sub _hdlr_if_comment_parent {
    my($ctx, $args, $cond) = @_;

    my $c = $ctx->stash('comment');
    return 0 if !$c;

    my $parent_id = $c->parent_id;
    return 0 unless $parent_id;

    require MT::Comment;
    my $parent = MT::Comment->load($c->parent_id);
    return 0 unless $parent;
    return $parent->visible ? 1 : 0;
}

###########################################################################

=head2 IfCommentReplies

A conditional tag that is true when the comment currently in context
has replies.

=for tags comments

=cut

sub _hdlr_if_comment_replies {
    my($ctx, $args, $cond) = @_;
    my $c = $ctx->stash('comment');
    return 0 if !$c;
    MT::Comment->exist( { parent_id => $c->id, visible => 1 } );
}

###########################################################################

=head2 IfRegistrationRequired

A conditional tag that is true when the blog has been configured to
require user registration.

=for tags comments

=cut

sub _hdlr_reg_required {
    my ($ctx) = @_;
    my $blog = $ctx->stash('blog');
    if ( $blog->allow_reg_comments && $blog->commenter_authenticators
        && ! $blog->allow_unreg_comments ) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfRegistrationNotRequired

A conditional tag that is true when the blog has been configured to
permit anonymous comments.

=for tags comments

=cut

sub _hdlr_reg_not_required {
    my ($ctx) = @_;
    my $blog = $ctx->stash('blog');
    if ($blog->allow_reg_comments && $blog->commenter_authenticators
        && $blog->allow_unreg_comments) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfRegistrationAllowed

A conditional tag that is true when the blog has been configured to
permit user registration.

B<Attributes:>

=over 4

=item * type (optional)

If specified, can be used to test if a particular type of registration
is enabled. The core types include "OpenID", "Vox", "LiveJournal", "TypeKey"
and "MovableType". The identifier is case-insensitive.

=back

=for tags comments

=cut

sub _hdlr_reg_allowed {
    my ($ctx, $args) = @_;
    my $blog = $ctx->stash('blog');
    if ($blog->allow_reg_comments && $blog->commenter_authenticators) {
        if (my $type = $args->{type}) {
            my %types = map { lc($_) => 1 }
                split /,/, $blog->commenter_authenticators;
            return $types{lc $type} ? 1 : 0;
        }
        return 1;
    } else {
        return 0;
    }
}

#FIXME: rethink the above tags.
#  * move all registration conditions into Context.pm?
#  * reg_not_required implies registration is allowed?
#  * moderation includes manual_approve_commenters ??
#  * alias authentication to registration?

###########################################################################

=head2 IfTypeKeyToken

A conditional tag that is true when the current blog in context has been
configured with a TypePad token.

=for tags comments, typepad

=cut

sub _hdlr_if_typekey_token {
    my ($ctx) = @_;
    my $blog = $ctx->stash('blog');
    return $blog->remote_auth_token ? 1 : 0;
}

###########################################################################

=head2 IfAllowCommentHTML

Conditional block that is true when the blog has been configured to
permit HTML in comments.

=for tags comments

=cut

sub _hdlr_if_allow_comment_html {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    if ($blog->allow_comment_html) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfCommentsAllowed

Conditional block that is true when the blog is configured to accept
comments, and comments are accepted on a system-wide basis. This tag
does not take the current entry context into account; use the
L<IfCommentsAccepted> tag for this.

=for tags comments, configuration

=cut

sub _hdlr_if_comments_allowed {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    if ((!$blog || ($blog && ($blog->allow_unreg_comments
                              || ($blog->allow_reg_comments
                                  && $blog->effective_remote_auth_token))))
        && $cfg->AllowComments) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfCommentsActive

Conditional tag that displays its contents if comments are enabled or
comments exist for the entry in context.

=for tags comments, entries

=cut

# comments exist in stash OR entry context allows comments
sub _hdlr_if_comments_active {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    my $active;
    if (my $entry = $ctx->stash('entry')) {
        $active = 1 if ($blog->accepts_comments && $entry->allow_comments
                        && $cfg->AllowComments);
        $active = 1 if $entry->comment_count;
    } else {
        $active = 1 if ($blog->accepts_comments && $cfg->AllowComments);
    }
    if ($active) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfCommentsAccepted

Conditional tag that displays its contents if commenting is enabled for
the entry in context.

B<Example:>

    <mt:IfCommentsAccepted>
        <h3>What do you think?</h3>
        (comment form)
    </mt:IfCommentsAccepted>

=for tags comments, entries, configuration

=cut

sub _hdlr_if_comments_accepted {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    my $entry = $ctx->stash('entry');
    my $blog_comments_accepted = $blog->accepts_comments && $cfg->AllowComments;
    my $accepted = $blog_comments_accepted;
    $accepted = 0 if $entry && !$entry->allow_comments;
    if ($accepted) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfNeedEmail

Conditional tag that is positive when the blog is configured to
require an e-mail address for anonymous comments.

=cut

###########################################################################

=head2 IfRequireCommentEmails

Conditional tag that is positive when the blog is configured to
require an e-mail address for anonymous comments.

=cut

sub _hdlr_if_need_email {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    if ($blog->require_comment_emails) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 EntryIfAllowComments

Conditional tag that is positive when the entry in context is
configured to allow commenting and the blog and MT installation
also permits comments.

=cut

sub _hdlr_entry_if_allow_comments {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    my $blog_comments_accepted = $blog->accepts_comments && $cfg->AllowComments;
    my $entry = $ctx->stash('entry');
    if ($blog_comments_accepted && $entry->allow_comments) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 EntryIfCommentsOpen

Deprecated in favor of L<EntryIfCommentsActive>.

=for tags deprecated

=cut

sub _hdlr_entry_if_comments_open {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    my $blog_comments_accepted = $blog->accepts_comments && $cfg->AllowComments;
    my $entry = $ctx->stash('entry');
    if ($entry && $blog_comments_accepted && $entry->allow_comments && $entry->allow_comments eq '1') {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 CommentID

Outputs the numeric ID for the current comment in context.

=for tags comments

=cut

sub _hdlr_comment_id {
    my ($ctx, $args) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $id = $c->id || 0;
    return $args && $args->{pad} ? (sprintf "%06d", $id) : $id;
}

###########################################################################

=head2 CommentBlogID

Outputs the numeric ID of the blog for the current comment
in context.

=for tags comments

=cut

sub _hdlr_comment_blog_id {
    my ($ctx) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    return $c->blog_id;
}

###########################################################################

=head2 CommentEntryID

Outputs the numeric ID for the parent entry (or page) of
the current comment in context.

=for tags comments

=cut

sub _hdlr_comment_entry_id {
    my ($ctx, $args) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    return $args && $args->{pad} ? (sprintf "%06d", $c->entry_id) : $c->entry_id;
}

###########################################################################

=head2 CommentName

Deprecated in favor of the L<CommentAuthor> tag.

=for tags deprecated

=cut

###########################################################################

=head2 CommentIP

Outputs the IP address where the current comment in context was
posted from.

=for tags comments

=cut

sub _hdlr_comment_ip {
    my ($ctx) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    return defined $c->ip ? $c->ip : '';
}

###########################################################################

=head2 CommentAuthor

Outputs the name field of the current comment in context (for
comments left by authenticated users, this will return their
display name).

=for tags comments

=cut

sub _hdlr_comment_author {
    my ($ctx, $args) = @_;
    $ctx->sanitize_on($args);
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $a = defined $c->author ? $c->author : '';
    $args->{default} = MT->translate("Anonymous")
        unless exists $args->{default};
    $a ||= $args->{default};
    return remove_html($a);    
}

###########################################################################

=head2 CommentAuthorLink

A linked version of the comment author name, using the comment author's URL
if provided in the comment posting form. Otherwise, the comment author
name is unlinked. This behavior can be altered with optional attributes.

B<Attributes:>

=over 4

=item * show_email (optional; default "0")

Specifies if the comment author's email can be displayed.

=item * show_url (optional; default "1")

Specifies if the comment author's URL can be displayed.

=item * new_window (optional; default "0")

Specifies to open the link in a new window by adding C<target="_blank">
to the anchor tag. See example below.

=item * default_name (optional; default "Anonymous")

Used in the event that the commenter did not provide a value for their
name.

=item * no_redirect (optional; default "0")

Prevents use of the mt-comments.cgi script to handle the comment author
link.

=item * nofollowfy (optional)

If assigned, applies a C<rel="nofollow"> link relation to the link.

=back

=for tags comments

=cut

sub _hdlr_comment_author_link {
    #sanitize_on($_[1]);
    my($ctx, $args) = @_;
    _comment_follow($ctx, $args);

    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $name = $c->author;
    $name = '' unless defined $name;
    $name ||= $args->{default_name};
    $name ||= MT->translate("Anonymous");
    $name = encode_html( remove_html( $name ) );
    my $show_email = $args->{show_email} ? 1 : 0;
    my $show_url = 1 unless exists $args->{show_url} && !$args->{show_url};
    # Open the link in a new window if requested (with new_window="1").
    my $target = $args->{new_window} ? ' target="_blank"' : '';
    my $cmntr = $ctx->stash('commenter');
    if ( !$cmntr ) {
        $cmntr = MT::Author->load( $c->commenter_id ) if $c->commenter_id;
    }

    if ( $cmntr ) {
        $name = encode_html( remove_html( $cmntr->nickname ) ) if $cmntr->nickname;
        if ($cmntr->url) {
            return sprintf(qq(<a title="%s" href="%s"%s>%s</a>),
                           encode_html( $cmntr->url ), encode_html( $cmntr->url ), $target, $name); 
        }
        return $name;
    } elsif ($show_url && $c->url) {
        my $cfg = $ctx->{config};
        my $cgi_path = $ctx->cgi_path;
        my $comment_script = $cfg->CommentScript;
        $name = remove_html($name);
        my $url = remove_html($c->url);
        if ($c->id && !$args->{no_redirect} && !$args->{nofollowfy}) {
            return sprintf(qq(<a title="%s" href="%s%s?__mode=red;id=%d"%s>%s</a>),
                           encode_html( $url ), $cgi_path, $comment_script, $c->id, $target, $name);
        } else {
            # In the case of preview, show URL directly without a redirect
            return sprintf(qq(<a title="%s" href="%s"%s>%s</a>),
                           $url, $url, $target, $name); 
        }
    } elsif ($show_email && $c->email && MT::Util::is_valid_email($c->email)) {
        my $email = remove_html($c->email);
        my $str = "mailto:" . encode_html( $email );
        $str = spam_protect($str) if $args->{'spam_protect'};
        return sprintf qq(<a href="%s">%s</a>), $str, $name;
    }
    return $name;
}

###########################################################################

=head2 CommentAuthorIdentity

Returns a profile icon link for the current commenter in context. The icon
is for the authentication service used (ie, TypeKey, OpenID, Vox
LiveJournal, etc.). If the commenter has a URL in their profile the icon
is linked to that URL.

=for tags comments

=cut

sub _hdlr_comment_author_identity {
    my ($ctx, $args) = @_;
    my $cmt = $ctx->stash('comment')
         or return $ctx->_no_comment_error();
    my $cmntr = $ctx->stash('commenter');
    unless ($cmntr) {
        if ($cmt->commenter_id) {
            $cmntr = MT::Author->load($cmt->commenter_id) 
                or return "?";
        } else {
            return q();
        }
    }
    my $link = $cmntr->url;
    my $static_path = $ctx->invoke_handler('StaticWebPath', $args);
    my $logo = $cmntr->auth_icon_url;
    unless ($logo) {
        my $root_url = $static_path . "images";
        $logo = "$root_url/nav-commenters.gif";
    }
    if ($logo =~ m!^/!) {
        # relative path, prepend blog domain
        my $blog = $ctx->stash('blog');
        if ($blog) {
            my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
            $logo = $blog_domain . $logo;
        }
    }
    my $result = qq{<img alt=\"Author Profile Page\" src=\"$logo\" width=\"16\" height=\"16\" />};
    if ($link) {
        $result = qq{<a class="commenter-profile" href=\"$link\">$result</a>};
    }
    return $result;
}

###########################################################################

=head2 CommentEmail

Publishes the commenter's e-mail address.

B<NOTE:> It is not recommended to publish any email addresses.

B<Attributes:>

=over 4

=item * spam_protect (optional; default "0")

=back

=for tags comments

=cut

sub _hdlr_comment_email {
    my ($ctx, $args) = @_;
    $ctx->sanitize_on($args);
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    return '' unless defined $c->email;
    return '' unless $c->email =~ m/@/;
    my $email = remove_html($c->email);
    return $args && $args->{'spam_protect'} ? spam_protect($email) : $email;
}

###########################################################################

=head2 CommentLink

Outputs the permalink for the comment currently in context. This is
the permalink for the parent entry, plus an anchor for the comment
itself (in the format '#comment-ID').

=for tags comments

=cut

sub _hdlr_comment_link {
    my ($ctx) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    return '#' unless $c->id;
    my $entry = $c->entry
        or return $ctx->error("No entry exists for comment #" . $c->id);
    return $entry->archive_url . '#comment-' . $c->id;
}

###########################################################################

=head2 CommentURL

Outputs the URL of the current comment in context. The URL is the link
provided in the comment from an anonymous comment, or for authenticated
comments, is the URL from the commenter's profile.

=for tags comments

=cut

sub _hdlr_comment_url {
    my ($ctx, $args) = @_;
    $ctx->sanitize_on($args);
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $url = defined $c->url ? $c->url : '';
    return remove_html($url);
}

###########################################################################

=head2 CommentBody

B<Attributes:>

=over 4

=item * autolink (optional)

If unspecified, any plaintext links in the comment body will be
automatically linked if the blog is configured to do that on the
comment preferences screen. If this attribute is specified, it will
override the blog preference.

=item * convert_breaks (optional)

By default, the comment text is formatted according to the comment text
formatting choice in the blog preferences. If convert_breaks is disabled,
the raw content of the comment body is output without any re-formatting
applied.

=item * words (optional)

Limits the length of the comment body to the specified number of words.
This is useful for producing a list of recent comments with an excerpt
of each.

=back

=for tags comments

=cut

sub _hdlr_comment_body {
    my($ctx, $args) = @_;
    $ctx->sanitize_on($args);
    _comment_follow($ctx, $args);

    my $blog = $ctx->stash('blog');
    return q() unless $blog;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $t = defined $c->text ? $c->text : '';
    unless ($blog->allow_comment_html) {
        $t = remove_html($t);
    }
    my $convert_breaks = exists $args->{convert_breaks} ?
        $args->{convert_breaks} :
        $blog->convert_paras_comments;
    $t = $convert_breaks ?
        MT->apply_text_filters($t, $blog->comment_text_filters, $ctx) :
        $t;
    return first_n_text($t, $args->{words}) if exists $args->{words};
    if (!(exists $args->{autolink} && !$args->{autolink}) &&
        $blog->autolink_urls) {
        $t =~ s!(^|\s|>)(https?://[^\s<]+)!$1<a href="$2">$2</a>!gs;
    }
    $t;
}

###########################################################################

=head2 CommentOrderNumber

Outputs a number relating to the position of the comment in the list
of all comments published using the C<Comments> tag, starting with "1".

=for tags comments

=cut

sub _hdlr_comment_order_num {
    my ($ctx) = @_;
    return $ctx->stash('comment_order_num');
}

###########################################################################

=head2 CommentDate

Outputs the creation date for the current comment in context. See
the L<Date> tag for support attributes.

=for tags date, comments

=cut

sub _hdlr_comment_date {
    my ($ctx, $args) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    $args->{ts} = $c->created_on;
    return $ctx->build_date($args);
}

###########################################################################

=head2 CommentParentID

Outputs the ID of the parent comment for the comment currently in context.
If there is no parent comment, outputs '0'.

B<Attributes:>

=over 4

=item * pad

If specified, zero-pads the ID to 6 digits. Example: 001234.

=back

=for tags comments

=cut

sub _hdlr_comment_parent_id {
    my ($ctx, $args) = @_;
    my $c = $ctx->stash('comment') or return '';
    my $id = $c->parent_id || 0;
    $args && $args->{pad} ? (sprintf "%06d", $id) : ($id ? $id : '');
}

###########################################################################

=head2 CommentReplyToLink

Produces the "Reply" link for the current comment in context.
By default, this relies on using the MT "Javascript" default template,
which supplies the C<mtReplyCommentOnClick> function.

B<Attributes:>

=over 4

=item * label or text (optional)

A custom phrase for the link (default is "Reply").

=item * onclick (optional)

Custom JavaScript code for the onclick attribute. By default, this
value is "mtReplyCommentOnClick(%d, '%s')" (note that %d is replaced
with the comment ID; %s is replaced with the name of the commenter).

=back

=for tags comments

=cut

sub _hdlr_comment_reply_link {
    my($ctx, $args) = @_;
    my $comment = $ctx->stash('comment') or
        return  $ctx->_no_comment_error();

    my $label = $args->{label} || $args->{text} || MT->translate('Reply');
    my $comment_author = MT::Util::encode_html( MT::Util::encode_js($comment->author) );
    my $onclick = sprintf( $args->{onclick} || "mtReplyCommentOnClick(%d, '%s')", $comment->id, $comment_author);

    return sprintf(qq(<a title="%s" href="javascript:void(0);" onclick="$onclick">%s</a>),
                   $label, $label);
}

###########################################################################

=head2 CommentPreviewAuthor

A deprecated tag, replaced with L<CommentAuthor>.

=for tags deprecated

=cut

###########################################################################

=head2 CommentPreviewIP

A deprecated tag, replaced with L<CommentIP>.

=for tags deprecated

=cut

###########################################################################

=head2 CommentPreviewAuthorLink

A deprecated tag, replaced with L<CommentAuthorLink>.

=for tags deprecated

=cut

###########################################################################

=head2 CommentPreviewEmail

A deprecated tag, replaced with L<CommentEmail>.

=for tags deprecated

=cut

###########################################################################

=head2 CommentPreviewURL

A deprecated tag, replaced with L<CommentURL>.

=for tags deprecated

=cut

###########################################################################

=head2 CommentPreviewBody

A deprecated tag, replaced with L<CommentBody>.

=for tags deprecated

=cut

###########################################################################

=head2 CommentPreviewDate

A deprecated tag, replaced with L<CommentDate>.

=for tags deprecated

=cut

###########################################################################

=head2 CommentPreviewState

For the comment preview template only.

=for tags comments

=cut

sub _hdlr_comment_prev_state {
    my ($ctx) = @_;
    return $ctx->stash('comment_state');
}

###########################################################################

=head2 CommentPreviewIsStatic

For the comment preview template only.

=for tags comments

=cut

sub _hdlr_comment_prev_static {
    my ($ctx) = @_;
    my $s = encode_html($ctx->stash('comment_is_static')) || '';
    return defined $s ? $s : ''
}

###########################################################################

=head2 CommentRepliesRecurse

Recursively call the block with the replies to the comment in context. This
tag, when placed at the end of loop controlled by MTCommentReplies tag will
cause them to recursively descend into any replies to comments that exist
during the loop.

B<Example:>

    <mt:Comments>
      <$mt:CommentBody$>
      <mt:CommentReplies>
        <mt:CommentsHeader><ul></MTCommentsHeader>
        <li><$mt:CommentID$>
        <$mt:CommentRepliesRecurse$>
        </li>
        <mt:CommentsFooter></ul></mt:CommentsFooter>
      </mt:CommentReplies>
    </mt:Comments>

=for tags comments

=cut

sub _hdlr_comment_replies_recurse {
    my($ctx, $args, $cond) = @_;

    my $comment = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $tokens = $ctx->stash('_comment_replies_tokens');

    my (%terms, %args);
    $terms{parent_id} = $comment->id;
    $terms{visible} = 1;
    $args{'sort'} = 'created_on';
    $args{'direction'} = 'descend';
    require MT::Comment;
    my $iter = MT::Comment->load_iter(\%terms, \%args);
    my %entries;
    my $blog = $ctx->stash('blog');
    my $so = lc($args->{sort_order}) || ($blog ? $blog->sort_order_comments : undef) || 'ascend';
    my $n = $args->{lastn};
    my @comments;
    while (my $c = $iter->()) {
        push @comments, $c;
        if ($n && (scalar @comments == $n)) {
            $iter->end;
            last;
        }
    }
    @comments = $so eq 'ascend' ?
        sort { $a->created_on <=> $b->created_on } @comments :
        sort { $b->created_on <=> $a->created_on } @comments;

    my $html = '';
    my $builder = $ctx->stash('builder');
    my $i = 1;
    
    @comments = grep { $_->visible() } @comments;

    local $ctx->{__stash}{commenter} = $ctx->{__stash}{commenter};
    my $vars = $ctx->{__stash}{vars} ||= {};
    for my $c (@comments) {
        local $vars->{__first__} = $i == 1;
        local $vars->{__last__} = ($i == scalar @comments);
        local $vars->{__odd__} = ($i % 2) == 1;
        local $vars->{__even__} = ($i % 2) == 0;
        local $vars->{__counter__} = $i;
        local $ctx->{__stash}{blog} = $c->blog;
        local $ctx->{__stash}{blog_id} = $c->blog_id;
        local $ctx->{__stash}{comment} = $c;
        local $ctx->{current_timestamp} = $c->created_on;
        $ctx->stash('comment_order_num', $i);
        if ($c->commenter_id) {
            $ctx->stash('commenter', delay(sub {MT::Author->load($c->commenter_id)}));
        } else {
            $ctx->stash('commenter', undef);
        }
        my $out = $builder->build($ctx, $tokens,
            { CommentsHeader => $i == 1,
              CommentsFooter => ($i == scalar @comments), } );
        return $ctx->error( $builder->errstr ) unless defined $out;
        $html .= $out;
        $i++;
    }
    if (!@comments) {
        return MT::Template::Context::_hdlr_pass_tokens_else(@_);
    }
    $html;
}

###########################################################################

=head2 WebsiteCommentCount

Returns the number of published comments associated with the website
currently in context.

=for tags multiblog, count, websites, comments

=cut

###########################################################################

=head2 BlogCommentCount

Returns the number of published comments associated with the blog
currently in context.

=for tags multiblog, count, blogs, comments

=cut

sub _hdlr_blog_comment_count {
    my ($ctx, $args, $cond) = @_;
    my (%terms, %args);
    $ctx->set_blog_load_context($args, \%terms, \%args)
        or return $ctx->error($ctx->errstr);
    $terms{visible} = 1;
    require MT::Comment;
    my $count = MT::Comment->count(\%terms, \%args);
    return $ctx->count_format($count, $args);
}

###########################################################################

=head2 EntryCommentCount

Outputs the number of published comments for the current entry in context.

=cut

sub _hdlr_entry_comments {
    my ($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $count = $e->comment_count;
    return $ctx->count_format($count, $args);
}

###########################################################################

=head2 CategoryCommentCount

This template tag returns the number of comments found within a category.

B<Example:>

    <ul><mt:Categories>
        <li><$mt:CategoryLabel$> (<$mt:CategoryCommentCount$>)</li>
    </mt:Categories></ul>

=for tags categories, comments

=cut

sub _hdlr_category_comment_count {
    my ($ctx, $args, $cond) = @_;
    my $cat = ($ctx->stash('category') || $ctx->stash('archive_category'))
        or return $ctx->error(MT->translate(
            "You used an [_1] tag outside of the proper context.",
            '<$MT' . $ctx->stash('tag') . '$>'));
    my($count);
    my $blog_id = $ctx->stash ('blog_id');
    my $class = MT->model(
        $ctx->stash('tag') =~ m/Category/ig ? 'entry' : 'page');
    my @args = ({ blog_id => $blog_id, visible => 1 },
                { 'join' => MT::Entry->join_on(undef,
                              { id => \'= comment_entry_id',
                              status => MT::Entry::RELEASE(),
                              blog_id => $blog_id, },
                              { 'join' => MT::Placement->join_on('entry_id', { category_id => $cat->id, blog_id => $blog_id } ) } ) } );
    require MT::Comment;
    $count = scalar MT::Comment->count(@args);
    return $ctx->count_format($count, $args);
}

###########################################################################

=head2 TypeKeyToken

Outputs the configured TypePad token for the current blog in context.
If the blog has not been configured to use TypePad, this will output
an empty string.

=cut

sub _hdlr_typekey_token {
    my ($ctx, $args, $cond) = @_;

    my $blog_id = $ctx->stash('blog_id');
    my $blog = MT::Blog->load($blog_id)
        or return $ctx->error(MT->translate('Can\'t load blog #[_1].', $blog_id));
    my $tp_token = $blog->effective_remote_auth_token();
    return $tp_token;
}

###########################################################################

=head2 CommentFields

A deprecated tag that formerly published an entry comment form.

=for tags deprecated

=cut

sub _hdlr_comment_fields {
    my ($ctx, $args, $cond) = @_;
    return $ctx->error(MT->translate("The MTCommentFields tag is no longer available; please include the [_1] template module instead.", MT->translate("Comment Form")));
}

###########################################################################

=head2 RemoteSignInLink

Outputs a link to the MT Comment script to allow signing in to a TypePad
configured blog. B<NOTE: This is deprecated in favor of L<SignInLink>.>

=for tags deprecated

=cut

sub _hdlr_remote_sign_in_link {
    my ($ctx, $args) = @_;
    my $cfg = $ctx->{config};
    my $blog = $ctx->stash('blog_id');
    $blog = MT::Blog->load($blog)
        if defined $blog && !(ref $blog);
    return $ctx->error(MT->translate('Can\'t load blog #[_1].', $ctx->stash('blog_id'))) unless $blog;
    my $auths = $blog->commenter_authenticators;
    return $ctx->error(MT->translate("TypePad authentication is not enabled in this blog.  MTRemoteSignInLink can't be used."))
        if $auths !~ /TypeKey/;
    
    my $rem_auth_token = $blog->effective_remote_auth_token();
    return $ctx->error(MT->translate("To enable comment registration, you need to add a TypePad token in your weblog config or user profile."))
        unless $rem_auth_token;
    my $needs_email = $blog->require_typekey_emails ? "&amp;need_email=1" : "";
    my $signon_url = $cfg->SignOnURL;
    my $path = $ctx->cgi_path;
    my $comment_script = $cfg->CommentScript;
    my $static_arg = $args->{static} ? "static=" . encode_url( encode_url( $args->{static} ) ) : "static=0";
    my $e = $ctx->stash('entry');
    my $tk_version = $cfg->TypeKeyVersion ? "&amp;v=" . $cfg->TypeKeyVersion : "";
    my $language = "&amp;lang=" . ($args->{lang} || $cfg->DefaultLanguage || $blog->language);
    return "$signon_url$needs_email$language&amp;t=$rem_auth_token$tk_version&amp;_return=$path$comment_script%3f__mode=handle_sign_in%26key=TypeKey%26$static_arg" .
        ($e ? "%26entry_id=" . $e->id : '%26blog_id=' . $blog->id);
}

###########################################################################

=head2 RemoteSignOutLink

Outputs a link to the MT Comment script to allow a user to sign out from
a blog. B<NOTE: This tag is deprecated in favor of L<SignOutLink>.>

=for tags deprecated

=cut

sub _hdlr_remote_sign_out_link {
    my ($ctx, $args) = @_;
    my $cfg = $ctx->{config};
    my $path = $ctx->cgi_path;
    my $comment_script = $cfg->CommentScript;
    my $static_arg;
    if ($args->{no_static}) {
        $static_arg = q();
    } else {
        my $url = $args->{static};
        if ($url && ($url ne '1')) {
            $static_arg = "&amp;static=" . MT::Util::encode_url($url);
        } elsif ($url) {
            $static_arg = "&amp;static=1";
        } else {
            $static_arg = "&amp;static=0";
        }
    }
    my $e = $ctx->stash('entry');
    "$path$comment_script?__mode=handle_sign_in$static_arg&amp;logout=1" .
        ($e ? "&amp;entry_id=" . $e->id : '');
}

###########################################################################

=head2 SignInLink

Outputs a link to the MT Comment script to allow a user to sign in
to comment on the blog.

=cut

sub _hdlr_sign_in_link {
    my ($ctx, $args) = @_;    
    my $cfg = $ctx->{config};
    my $blog = $ctx->stash('blog');
    my $path = $ctx->cgi_path;
    $path .= '/' unless $path =~ m!/$!;
    my $comment_script = $cfg->CommentScript;
    my $static_arg = $args->{static} ? "&static=" . $args->{static} : '';
    my $e = $ctx->stash('entry');
    return "$path$comment_script?__mode=login$static_arg" .
        ($blog ? '&blog_id=' . $blog->id : '') .
        ($e ? '&entry_id=' . $e->id : '');
}

###########################################################################

=head2 SignOutLink

Outputs a link to the MT Comment script to allow a signed-in user to
sign out from the blog.

=cut

sub _hdlr_sign_out_link {
    my ($ctx, $args) = @_;
    my $cfg = $ctx->{config};
    my $path = $ctx->cgi_path;
    $path .= '/' unless $path =~ m!/$!;
    my $comment_script = $cfg->CommentScript;
    my $static_arg;
    if ($args->{no_static}) {
        $static_arg = q();
    } else {
        my $url = $args->{static};
        if ($url && ($url ne '1')) {
            $static_arg = "&static=" . MT::Util::encode_url($url);
        } elsif ($url) {
            $static_arg = "&static=1";
        } else {
            $static_arg = "&static=0";
        }
    }
    my $e = $ctx->stash('entry');
    return "$path$comment_script?__mode=handle_sign_in$static_arg&logout=1" .
        ($e ? "&amp;entry_id=" . $e->id : '');
}

###########################################################################

=head2 SignOnURL

The value of the C<SignOnURL> configuration setting.

=for tags comments

=cut

sub _hdlr_signon_url {
    my ($ctx) = @_;
    return $ctx->{config}->SignOnURL;
}

1;
