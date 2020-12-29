# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Template::Tags::Author;

use strict;
use warnings;

use MT;
use MT::Util qw( spam_protect );

sub _get_author {
    my ( $author_name, $blog_id, $order, $content_type ) = @_;

    if ( $order eq 'previous' ) {
        $order = 'descend';
    }
    else {
        $order = 'ascend';
    }
    require MT::Entry;
    require MT::Author;
    require MT::ContentStatus;
    my $join
        = $content_type
        ? MT->model('content_data')->join_on(
        'author_id',
        {   status          => MT::ContentStatus::RELEASE(),
            blog_id         => $blog_id,
            content_type_id => $content_type->id,
        },
        { unique => 1 }
        )
        : MT->model('entry')->join_on(
        'author_id',
        {   status  => MT::Entry::RELEASE(),
            blog_id => $blog_id,
        },
        { unique => 1 }
        );
    my $author = MT::Author->load(
        undef,
        {   'sort'    => 'name',
            direction => $order,
            start_val => $author_name,
            'join'    => $join,
        }
    );
    $author;
}

###########################################################################

=head2 Authors

A container tag which iterates over a list of authors. Default listing
includes Authors who have at least one published entry.

B<Attributes:>

=over 4

=item * display_name

Specifies a particular author to select.

=item * lastn

Limits the selection of authors to the specified number.

=item * sort_by (optional)

Supported values: display_name, name, created_on.

=item * sort_order (optional; default "ascend")

Supported values: ascend, descend.

=item * any_type (optional; default "0")

Pass a value of '1' for this attribute to cause it to select users of
any type associated with the blog, including commenters.

=item * roles

List of roles used to select users by. Comma separated
(eg: "Author, Commenter"), or using conditional logic
(eg: "Author OR Commenter" or "!(Author)")

=item * need_entry (optional; default "1")

Identifies whether the author(s) must have published an entry
to be included or not.

=item * need_association (optional; default "0")

Identifies whether the author(s) must have explicit association
to the blog(s) in context.  This attribute can be used to
exclude system administrators who do not have explicit association
to the blog(s).  This attribute requires blog context which
can be created by include_blogs, exclude_blogs, and blog_ids.

=item * status (optional; default "enabled")

Supported values: enabled, disabled.

=item * namespace

Used in conjunction with the "min*", "max*" attributes to
select authors based on a particular scoring mechanism.

=item * scoring_to

If 'namespace' is also specified, filters the authors based on
the score within that namespace. This attribute specifies which 
type of object to look up. the object has to be specified in context.

=item * min_score

If 'namespace' is also specified, filters the authors based on
the score within that namespace. This specifies the minimum score
to consider the author for inclusion.

=item * max_score

If 'namespace' is also specified, filters the authors based on
the score within that namespace. This specifies the maximum score
to consider the author for inclusion.

=item * min_rate

If 'namespace' is also specified, filters the authors based on
the rank within that namespace. This specifies the minimum rank
to consider the author for inclusion.

=item * max_rate

If 'namespace' is also specified, filters the authors based on
the rank within that namespace. This specifies the maximum rank
to consider the author for inclusion.

=item * min_count

If 'namespace' is also specified, filters the authors based on
the count within that namespace. This specifies the minimum count
to consider the author for inclusion.

=item * max_count

If 'namespace' is also specified, filters the authors based on
the count within that namespace. This specifies the maximum count
to consider the author for inclusion.

=back

List all Authors in a blog with at least 1 entry:

    <mt:Authors>
       <a href="<$mt:AuthorURL$>"><$mt:AuthorDisplayName$></a>
    </mt:Authors>

List all Authors and Commenters for a blog:

    <mt:Authors need_entry="0" roles="Author, Commenter">
        <a href="<$mt:AuthorURL$>"><mt:AuthorDisplayName$></a>
    </mt:Authors>

=for tags multiblog, loop, scoring, authors

=cut

sub _hdlr_authors {
    my ( $ctx, $args, $cond ) = @_;
    my $blog_id = $ctx->stash('blog_id');
    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');

    require MT::Entry;
    require MT::Author;

    my ( %blog_terms, %blog_args );
    $ctx->set_blog_load_context( $args, \%blog_terms, \%blog_args )
        or return $ctx->error( $ctx->errstr );
    my ( @filters, %terms, %args, @joins );

    if ( ( defined $args->{id} ) && ( my $user_id = $args->{id} ) ) {
        return $ctx->error(
            MT->translate(
                "The '[_2]' attribute will only accept an integer: [_1]",
                $user_id, 'user_id'
            )
        ) unless ( $user_id =~ m/^[\d]+$/ );
        $terms{id} = $args->{id};
    }
    elsif ( defined $args->{username} ) {
        $terms{name} = $args->{username};
    }
    elsif ( defined $args->{display_name} ) {
        $terms{nickname} = $args->{display_name};
    }

    if ( my $status_arg = $args->{status} || 'enabled' ) {
        if ( $status_arg !~ m/\b(OR)\b|\(|\)/i ) {
            my @status = MT::Tag->split( ',', $status_arg );
            $status_arg = join " or ", @status;
        }
        my $status = [
            { name => 'enabled',  id => 1 },
            { name => 'disabled', id => 2 },
        ];
        my $cexpr = $ctx->compile_status_filter( $status_arg, $status );
        if ($cexpr) {
            push @filters, $cexpr;
        }
    }
    my $role_arg;
    if ( $role_arg = $args->{role} || $args->{roles} ) {
        if ( $role_arg !~ m/\b(OR)\b|\(|\)/i ) {
            my @roles = MT::Tag->split( ',', $role_arg );
            $role_arg = join " or ", @roles;
        }
        require MT::Association;
        require MT::Role;
        my $roles = [ MT::Role->load( undef, { sort => 'name' } ) ];
        my $cexpr = $ctx->compile_role_filter( $role_arg, $roles );
        if ($cexpr) {
            my %map;
            for my $role (@$roles) {
                my $iter = MT::Association->load_iter(
                    {   role_id => $role->id,
                        %blog_terms
                    },
                    \%blog_args
                );
                while ( my $as = $iter->() ) {
                    if (   ( $as->type == MT::Association::GROUP_BLOG_ROLE() )
                        or ( $as->type == MT::Association::GROUP_ROLE() ) )
                    {
                        my $iter2 = MT::Association->load_iter(
                            {   group_id => $as->group_id,
                                type     => MT::Association::USER_GROUP(),
                            },
                        );
                        while ( my $as2 = $iter2->() ) {
                            $map{ $as2->author_id }{ $role->id }++;
                        }
                    }
                    else {
                        $map{ $as->author_id }{ $role->id }++;
                    }
                }
            }
            push @filters, sub { $cexpr->( $_[0]->id, \%map ) };
        }
    }

    # if need_entry is NOT defined AND any_type=1, then need_entry=0
    unless ( defined $args->{need_entry} ) {
        $args->{need_entry} = 0
            if ( defined $args->{any_type} && $args->{any_type} == 1 );
    }
    if ( ( defined $args->{need_entry} ? $args->{need_entry} : 1 )
        && !( defined $args->{id} || defined $args->{username} ) )
    {
        $blog_args{'unique'}  = 1;
        $blog_terms{'status'} = MT::Entry::RELEASE();
        push @joins,
            MT::Entry->join_on( 'author_id', \%blog_terms, \%blog_args );
    }
    else {
        $blog_args{'unique'} = 1;
        if ( !$role_arg ) {
            require MT::Permission;
            push @joins,
                MT::Permission->join_on(
                'author_id',
                exists( $args->{need_association} )
                    && $args->{need_association}
                ? \%blog_terms
                : undef,
                \%blog_args
                );
            if ( !$args->{any_type} ) {
                push @filters, sub {
                    my @blog_ids;
                    if ( $blog_terms{blog_id} ) {
                        push @blog_ids, 0;
                        push @blog_ids,
                            ref( $blog_terms{blog_id} ) eq 'ARRAY'
                            ? @{ $blog_terms{blog_id} }
                            : $blog_terms{blog_id};
                    }
                    my $perm_iter = MT::Permission->load_iter(
                        {   author_id => $_[0]->id,
                            ( @blog_ids ? ( blog_id => \@blog_ids ) : () ),
                        },
                        \%blog_args
                    );
                    while ( my $perm = $perm_iter->() ) {
                        $perm_iter->end(), return 1
                            if $perm->can_do('create_post');
                    }
                    return 0;
                };
            }
            else {
                push @filters, sub {
                    my $blog_id;
                    if ( $blog_terms{blog_id} ) {
                        $blog_id
                            = ref $blog_terms{blog_id} eq 'ARRAY'
                            ? [ 0, @{ $blog_terms{blog_id} } ]
                            : [ 0, $blog_terms{blog_id} ];
                    }
                    my $count = MT::Permission->count(
                        {   author_id => $_[0]->id,
                            $blog_id ? ( blog_id => $blog_id ) : (),
                        },
                        \%blog_args
                    );
                    return $count > 0;
                };
            }
        }
    }
    if ( $args->{'needs_userpic'} ) {
        push @filters, sub { $_[0]->userpic_asset_id > 0; };
    }
    if ( $args->{namespace} ) {
        my $namespace = $args->{namespace};
        if ( my $scoring_to = $args->{scoring_to} ) {
            return $ctx->error(
                MT->translate(
                    "You have an error in your '[_2]' attribute: [_1]",
                    $scoring_to, 'scoring_to'
                )
            ) unless exists $ctx->{__stash}{$scoring_to};
            my $scored_object = $ctx->{__stash}{$scoring_to};
            if ( $args->{min_score} ) {
                push @filters, sub {
                    $scored_object->get_score( $namespace, $_[0] )
                        >= $args->{min_score};
                };
            }
            if ( $args->{max_score} ) {
                push @filters, sub {
                    $scored_object->get_score( $namespace, $_[0] )
                        <= $args->{max_score};
                };
            }
            if ( !exists $args->{max_score} && !exists $args->{min_score} ) {
                push @filters, sub {
                    defined $scored_object->get_score( $namespace, $_[0] );
                };
            }
        }
        else {
            my $need_join = 0;
            if ($args->{sort_by}
                && (   $args->{sort_by} eq 'score'
                    || $args->{sort_by} eq 'rate' )
                )
            {
                $need_join = 1;
            }
            else {
                for my $f (
                    qw( min_score max_score min_rate max_rate min_count max_count scored_by )
                    )
                {
                    if ( $args->{$f} ) {
                        $need_join = 1;
                        last;
                    }
                }
            }
            if ($need_join) {
                push @joins,
                    MT->model('objectscore')->join_on(
                    undef,
                    {   object_id => \'=author_id',
                        object_ds => 'author',
                        namespace => $namespace,
                    },
                    { unique => 1, }
                    );
            }

            # Adds a rate or score filter to the filter list.
            if ( $args->{min_score} ) {
                push @filters, sub {
                    $_[0]->score_for($namespace) >= $args->{min_score};
                };
            }
            if ( $args->{max_score} ) {
                push @filters, sub {
                    $_[0]->score_for($namespace) <= $args->{max_score};
                };
            }
            if ( $args->{min_rate} ) {
                push @filters,
                    sub { $_[0]->score_avg($namespace) >= $args->{min_rate}; };
            }
            if ( $args->{max_rate} ) {
                push @filters,
                    sub { $_[0]->score_avg($namespace) <= $args->{max_rate}; };
            }
            if ( $args->{min_count} ) {
                push @filters,
                    sub { $_[0]->vote_for($namespace) >= $args->{min_count}; };
            }
            if ( $args->{max_count} ) {
                push @filters,
                    sub { $_[0]->vote_for($namespace) <= $args->{max_count}; };
            }
        }
    }

    my $re_sort      = 0;
    my $score_limit  = 0;
    my $score_offset = 0;
    $args{'sort'} = 'created_on';
    if ( $args->{'sort_by'} ) {
        if ( lc $args->{'sort_by'} eq 'display_name' ) {
            $args{'sort'} = 'nickname';
        }
        elsif ( 'score' eq $args->{sort_by} || 'rate' eq $args->{sort_by} ) {
            $score_limit  = delete( $args->{limit} )  || 0;
            $score_offset = delete( $args->{offset} ) || 0;
            $re_sort      = 1;
        }
        elsif ( MT::Author->has_column( $args->{sort_by} ) ) {
            $args{'sort'} = $args->{sort_by};
        }
    }
    if ( $args->{'limit'} ) {
        $args{limit} = $args->{limit};
    }

    if ($re_sort) {
        $args{'direction'} = 'ascend';
    }
    else {
        $args{'direction'} = $args->{sort_order} || 'ascend';
    }

    $args{'joins'} = \@joins if @joins;
    my $iter  = MT::Author->load_iter( \%terms, \%args );
    my $count = 0;
    my $next  = $iter->();
    my $n     = $args->{lastn};
    my @authors;
AUTHOR: while ($next) {
        my $author = $next;
        $next = $iter->();
        for (@filters) {
            next AUTHOR unless $_->($author);
        }
        push @authors, $author;
        $count++;
        if ( $n && ( $count >= $n ) ) {
            $iter->end;
            last;
        }
    }

    if ( $re_sort && ( scalar @authors ) ) {
        my $col       = $args->{sort_by};
        my $namespace = $args->{'namespace'};
        if ( 'score' eq $col ) {
            my $so = $args->{sort_order} || '';
            my %a = map { $_->id => $_ } @authors;
            my @aid = keys %a;
            require MT::ObjectScore;
            my $scores = MT::ObjectScore->sum_group_by(
                {   'object_ds' => 'author',
                    'namespace' => $namespace,
                    object_id   => \@aid
                },
                {   'sum' => 'score',
                    group => ['object_id'],
                    $so eq 'ascend'
                    ? ( direction => 'ascend' )
                    : ( direction => 'descend' ),
                }
            );
            my @tmp;
            my $i = 0;
            while ( my ( $score, $object_id ) = $scores->() ) {
                $i++;
                next if $score_offset && ( $i - 1 ) < $score_offset;
                push @tmp, delete $a{$object_id} if exists $a{$object_id};
                if ( !%a || ( $score_limit && $i >= $score_limit ) ) {
                    $scores->end;
                    last;
                }
            }
            @authors = @tmp;
        }
        elsif ( 'rate' eq $col ) {
            my $so = $args->{sort_order} || '';
            my %a = map { $_->id => $_ } @authors;
            my @aid = keys %a;
            require MT::ObjectScore;
            my $scores = MT::ObjectScore->avg_group_by(
                {   'object_ds' => 'author',
                    'namespace' => $namespace,
                    object_id   => \@aid
                },
                {   'avg' => 'score',
                    group => ['object_id'],
                    $so eq 'ascend'
                    ? ( direction => 'ascend' )
                    : ( direction => 'descend' ),
                }
            );
            my @tmp;
            my $i = 0;
            while ( my ( $score, $object_id ) = $scores->() ) {
                $i++;
                next if $score_offset && ( $i - 1 ) < $score_offset;
                push @tmp, delete $a{$object_id} if exists $a{$object_id};
                if ( !%a || ( $score_limit && $i >= $score_limit ) ) {
                    $scores->end;
                    last;
                }
            }
            @authors = @tmp;
        }
    }

    my $res = '';
    my $vars = $ctx->{__stash}{vars} ||= {};
    $count = 0;
    MT::Meta::Proxy->bulk_load_meta_objects( \@authors );
    for my $author (@authors) {
        $count++;
        local $ctx->{__stash}{author}    = $author;
        local $ctx->{__stash}{author_id} = $author->id;
        local $vars->{__first__}         = $count == 1;
        local $vars->{__last__}          = !defined $authors[$count]
            || ( $n && ( $count == $n ) );
        local $vars->{__odd__}     = ( $count % 2 ) == 1;
        local $vars->{__even__}    = ( $count % 2 ) == 0;
        local $vars->{__counter__} = $count;
        defined( my $out = $builder->build( $ctx, $tokens, $cond ) )
            or return $ctx->error( $builder->errstr );
        $res .= $out;
    }
    $res;
}

###########################################################################

=head2 AuthorNext

A container tag which creates a author context of the next author. The
order of authors is determined by author's login name. Authors who have
at least a published entry will be considered in finding the next author.

B<Example:>

    <mt:AuthorNext>
        <a href="<$mt:ArchiveLink archive_type="Author"$>"><$mt:AuthorDisplayName$></a>
    </mt:AuthorNext>

=for tags authors, archives

=cut

###########################################################################

=head2 AuthorPrevious

A container tag which creates a author context of the previous author. The
order of authors is determined by author's login name. Authors who have
at least a published entry will be considered in finding the previous author.

B<Example:>

    <mt:AuthorPrevious>
        <a href="<$mt:ArchiveLink archive_type="Author"$>"><$mt:AuthorDisplayName$></a>
    </mt:AuthorPrevious>

=for tags authors, archives

=cut

sub _hdlr_author_next_prev {
    my ( $ctx, $args, $cond ) = @_;
    my $tag     = $ctx->stash('tag');
    my $is_prev = $tag eq 'AuthorPrevious';
    my $author  = $ctx->stash('author')
        or return $ctx->error(
        MT->translate(
            "You used an [_1] without a author context set up.", "<MT$tag>"
        )
        );
    my $blog         = $ctx->stash('blog');
    my $content_type = $ctx->stash('content_type');
    my @args         = (
        $author->name, $blog->id, $is_prev ? 'previous' : 'next',
        $content_type
    );
    my $res = '';

    if ( my $next = _get_author(@args) ) {
        my $builder = $ctx->stash('builder');
        local $ctx->{__stash}->{author} = $next;
        defined( my $out
                = $builder->build( $ctx, $ctx->stash('tokens'), $cond ) )
            or return $ctx->error( $builder->errstr );
        $res .= $out;
    }
    $res;
}

###########################################################################

=head2 IfAuthor

A conditional tag that is true when an author object is in context.

    <mt:IfAuthor>
        Author: <$mt:AuthorDisplayName$>
    </mt:IfAuthor>

=for tags authors

=cut

sub _hdlr_if_author {
    my ($ctx) = @_;
    return $ctx->stash('author') ? 1 : 0;
}

###########################################################################

=head2 AuthorID

Outputs the numeric ID of the author currently in context. If no author
is in context, it will use the author of the entry or page in context.

=for tags authors

=cut

sub _hdlr_author_id {
    my ($ctx) = @_;
    my $author = $ctx->stash('author');
    unless ($author) {
        my $e = $ctx->stash('entry');
        $author = $e->author if $e;
    }
    return $ctx->_no_author_error() unless $author;
    return $author->id;
}

###########################################################################

=head2 AuthorName

Outputs the username of the author currently in context. If no author
is in context, it will use the author of the entry or page in context.

B<NOTE:> it is not recommended to publish the author's username.

=for tags authors

=cut

sub _hdlr_author_name {
    my ($ctx) = @_;
    my $author = $ctx->stash('author');
    unless ($author) {
        my $e = $ctx->stash('entry');
        $author = $e->author if $e;
    }
    return $ctx->_no_author_error() unless $author;
    return $author->name;
}

###########################################################################

=head2 AuthorDisplayName

Outputs the display name of the author currently in context. If no author
is in context, it will use the author of the entry or page in context.

=for tags authors

=cut

sub _hdlr_author_display_name {
    my ($ctx) = @_;
    my $a = $ctx->stash('author');
    unless ($a) {
        my $e = $ctx->stash('entry');
        $a = $e->author if $e;
    }
    return $ctx->_no_author_error() unless $a;
    return $a->nickname || MT->translate( '(Display Name not set)', $a->id );
}

###########################################################################

=head2 AuthorEmail

Outputs the email address of the author currently in context. If no author
is in context, it will use the author of the entry or page in context.

B<NOTE:> it is not recommended to publish the author's email address.

=for tags authors

=cut

sub _hdlr_author_email {
    my ( $ctx, $args ) = @_;
    my $author = $ctx->stash('author');
    unless ($author) {
        my $e = $ctx->stash('entry');
        $author = $e->author if $e;
    }
    return $ctx->_no_author_error() unless $author;
    my $email = $author->email;
    return '' unless defined $email;
    return $args && $args->{'spam_protect'} ? spam_protect($email) : $email;
}

###########################################################################

=head2 AuthorURL

Outputs the URL field of the author currently in context. If no author
is in context, it will use the author of the entry or page in context.

=for tags authors

=cut

sub _hdlr_author_url {
    my ($ctx) = @_;
    my $author = $ctx->stash('author');
    unless ($author) {
        my $e = $ctx->stash('entry');
        $author = $e->author if $e;
    }
    return $ctx->_no_author_error() unless $author;
    my $url = $author->url;
    return defined $url ? $url : '';
}

###########################################################################

=head2 AuthorAuthType

Outputs the authentication type identifier for the author currently
in context. For Movable Type registered users, this is "MT".

=for tags authors

=cut

sub _hdlr_author_auth_type {
    my ($ctx) = @_;
    my $author = $ctx->stash('author');
    unless ($author) {
        my $e = $ctx->stash('entry');
        $author = $e->author if $e;
    }
    return $ctx->_no_author_error() unless $author;
    my $auth_type = $author->auth_type;
    return defined $auth_type ? $auth_type : '';
}

###########################################################################

=head2 AuthorAuthIconURL

Returns URL to a small (16x16) image represents in what authentication
provider the author in context is authenticated. For most of users it will
be a small spanner logo of Movable Type. If user is a commenter, icon image
is provided by each of authentication provider. Movable Type provides
images for Vox, LiveJournal and OpenID out of the box.

B<Attributes:>

=over 4

=item * size (optional; default "logo_small")

Identifies the requested size of the logo. This is an identifier,
not a dimension in pixels. And, currently, "logo_small" is the only
supported identifier.

=back

B<Example:>

    <mt:Authors>
        <img src="<$mt:AuthorAuthIconURL$>" height="16" width="16" />
        <$mt:AuthorDisplayName$>
    </mt:Authors>

=for tags authors

=cut

sub _hdlr_author_auth_icon_url {
    my ( $ctx, $args ) = @_;
    my $author = $ctx->stash('author');
    unless ($author) {
        my $e = $ctx->stash('entry');
        $author = $e->author if $e;
    }
    return $ctx->_no_author_error() unless $author;
    my $size = $args->{size} || 'logo_small';
    my $url = $author->auth_icon_url($size);
    if ( $url =~ m!^/! ) {

        # relative path, prepend blog domain
        my $blog = $ctx->stash('blog');
        if ($blog) {
            my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
            $url = $blog_domain . $url;
        }
    }
    return $url;
}

###########################################################################

=head2 AuthorBasename

Outputs the 'Basename' field of the author currently in context.

B<Attributes:>

=over 4

=item * separator (optional)

Accepts either "-" or "_". If unspecified, the raw basename value is
returned.

=back

=for tags authors

=cut

sub _hdlr_author_basename {
    my ( $ctx, $args ) = @_;
    my $author = $ctx->stash('author')
        or return $ctx->_no_author_error();
    my $name = $author->basename;
    $name = MT::Util::make_unique_author_basename($author) if !$name;
    if ( my $sep = $args->{separator} ) {
        if ( $sep eq '-' ) {
            $name =~ s/_/-/g;
        }
        elsif ( $sep eq '_' ) {
            $name =~ s/-/_/g;
        }
    }
    return $name;
}

1;
