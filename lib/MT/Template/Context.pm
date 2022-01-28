# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Template::Context;

use strict;
use warnings;
use base qw( MT::ErrorHandler );

use MT::Util qw( weaken );
use MT::Template::Handler;

our ( %Handlers, %Filters );

sub new {
    my $class = shift;
    require MT::Template::ContextHandlers;
    my $ctx = bless {}, $class;
    $ctx->init(@_);
}

sub init {
    my $ctx = shift;
    weaken( $ctx->{config} = MT->config );
    $ctx->stash( 'vars', {} );
    $ctx->init_handlers();
    $ctx;
}

sub clone {
    my $ctx   = shift;
    my $clone = ref($ctx)->new;
    for my $key ( keys %{$ctx} ) {
        $clone->{$key} = $ctx->{$key};
    }
    return $clone;
}

sub init_handlers {
    my $ctx = shift;
    my $mt  = MT->instance;
    if ( !$mt->{__tag_handlers} ) {
        my $h = $mt->{__tag_handlers} = {};
        my $f = $mt->{__tag_filters}  = {};
        my $all_tags = MT::Component->registry('tags');

        # Put application-specific handlers in front of 'core'
        # tag set (allows MT::App::Search, etc to replace the
        # stubbed core handlers)
        if ( $mt->isa('MT::App') ) {
            my $app_tags = MT->registry( "applications", $mt->id, "tags" );
            unshift @$all_tags, $app_tags if $app_tags;
        }
        for my $tag_set (@$all_tags) {
            if ( my $block = $tag_set->{block} ) {
                for my $orig_tag ( keys %$block ) {
                    next if $orig_tag eq 'plugin';

                    my $tag  = lc $orig_tag;
                    my $type = 1;

                    # A '?' suffix identifies conditional tags
                    if ( $tag =~ m/\?$/ ) {
                        $tag =~ s/\?$//;
                        $type = 2;
                    }

                    # Application level tags should not be overwritten
                    # by 'core' tags (which may be placeholders, as in the
                    # case of MT-Search). Non-core plugins can override
                    # other core routines and application level tags though.
                    my $prev_hdlr;
                    if ( exists $h->{$tag} ) {

                        # a replaced handler
                        next if ( $block->{plugin}{id} || '' ) eq 'core';
                        $prev_hdlr = $h->{$tag};
                    }
                    if ( ref( $block->{$orig_tag} ) eq 'HASH' ) {
                        if ( $block->{$orig_tag}{handler} ) {
                            $h->{$tag} = [
                                $block->{$orig_tag}{handler}, $type,
                                $prev_hdlr
                            ];
                        }
                    }
                    else {
                        $h->{$tag}
                            = [ $block->{$orig_tag}, $type, $prev_hdlr ];
                    }
                }
            }
            if ( my $func = $tag_set->{function} ) {
                for my $orig_tag ( keys %$func ) {
                    next if $orig_tag eq 'plugin';

                    my $tag = lc $orig_tag;
                    my $prev_hdlr;
                    if ( exists $h->{$tag} ) {

                        # a replaced handler
                        next if ( $func->{plugin}{id} || '' ) eq 'core';
                        $prev_hdlr = $h->{$tag};
                    }
                    if ( ref( $func->{$orig_tag} ) eq 'HASH' ) {
                        $h->{$tag}
                            = [ $func->{$orig_tag}{handler}, 0, $prev_hdlr ];
                    }
                    else {
                        $h->{$tag} = [ $func->{$orig_tag}, 0, $prev_hdlr ];
                    }
                }
            }
            if ( my $mod = $tag_set->{modifier} ) {
                for my $orig_mod ( keys %$mod ) {
                    next if $orig_mod eq 'plugin';
                    my $modifier = lc $orig_mod;
                    next
                        if exists $f->{$modifier}
                        && ( $mod->{plugin}{id} || '' ) eq 'core';
                    $f->{$modifier} = $mod->{$orig_mod};
                }
            }
        }
    }
    weaken( $ctx->{__handlers} = $mt->{__tag_handlers} );
    weaken( $ctx->{__filters}  = $mt->{__tag_filters} );
}

sub super_handler {
    my ($ctx) = @_;
    my $hdlr = $ctx->stash('__handler');
    return unless defined $hdlr;
    $hdlr->invoke_super(@_);
}

sub stash {
    my $ctx = shift;
    my $key = shift;
    return $ctx->{__stash}->{$key} = shift if @_;
    if ( ref $ctx->{__stash}->{$key} eq 'MT::Promise' ) {
        return MT::Promise::force( $ctx->{__stash}->{$key} );
    }
    else {
        return $ctx->{__stash}->{$key};
    }
}

sub var {
    my $ctx = shift;
    my $key = lc shift;
    if ( $key =~ m/^(config|request)\.(.+)$/i ) {
        if ( lc($1) eq 'request' ) {
            my $mt = MT->instance;
            return '' unless $mt->isa('MT::App');
            return $mt->param($2);
        }
        elsif ( lc($1) eq 'config' ) {
            my $setting = $2;
            return '' if $setting =~ m/password/i;
            return '' if $setting =~ m/secret/i;
            return MT->config($setting);
        }
        return '';
    }
    my $value = $ctx->{__stash}{vars}{$key};

    # protects $_ value set during template attribute interpolation
    local $_ = $_;
    if ( ref $value eq 'CODE' ) {
        $value = $value->($ctx);
    }
    $ctx->{__stash}{vars}{$key} = shift if @_;
    return $value;
}

sub this_tag {
    my $ctx = shift;
    return 'mt' . lc( $ctx->stash('tag') );
}

sub tag {
    my $ctx = shift;
    my $tag = lc shift;
    my $h   = $ctx->handler_for($tag)
        or return $ctx->error("No handler for tag $tag");
    local $ctx->{__stash}{tag} = $tag;
    my ( $args, $cond ) = @_;
    $args ||= {};
    my $out = $h->invoke( $ctx, $args, $cond );
    if ( defined $out ) {

        if ( my $ph = $ctx->post_process_handler ) {
            $out = $ph->( $ctx, $args, $out );
        }
    }
    return $out;
}

sub handler_for {
    my $ctx = shift;
    my $tag = lc $_[0];
    my $v   = $ctx->{__handlers}{$tag};
    if ( ref($v) eq 'MT::Template::Handler' ) {
        return wantarray ? $v->values : $v;
    }
    if ( ref($v) eq 'HASH' ) {
        $v = $ctx->{__handlers}{$tag} = $v->{handler};
    }
    if (wantarray) {
        my @h = ref($v) eq 'ARRAY' ? @$v : $v;
        if ( !ref( $h[0] ) ) {
            $h[0] = MT->handler_to_coderef( $h[0] );
            if ( ref($v) ) {
                $ctx->{__handlers}{$tag}[0] = $h[0];
            }
            else {
                $ctx->{__handlers}{$tag} = $h[0];
            }
        }
        return ref($v) eq 'ARRAY' ? @h : $h[0];
    }
    else {
        my @h = ref($v) eq 'ARRAY' ? @$v : $v;
        my $hdlr = MT::Template::Handler->new(@h);
        return $ctx->{__handlers}{$tag} = $hdlr;
    }
}

sub invoke_handler {
    my $ctx     = shift;
    my $tag     = shift;
    my $handler = $ctx->handler_for($tag);
    die "cannot find handler for $tag" unless $handler;
    $handler->invoke( $ctx, @_ );
}

{
    my ( @order, %order );

    BEGIN {
        @order = qw(filters trim_to trim ltrim rtrim decode_html
            decode_xml remove_html dirify sanitize
            encode_html encode_xml encode_js encode_php
            encode_url upper_case lower_case strip_linefeeds
            space_pad zero_pad sprintf);
        my $el = 0;
        %order = map { $_ => ++$el } @order;
    }

    sub stock_post_process_handler {
        my ( $ctx, $args, $str, $arglist ) = @_;
        my $filters = $ctx->{__filters};
        $arglist ||= [];
        if (@$arglist) {

            # In the event that $args was manipulated by handlers,
            # locate any new arguments and add them to $arglist for
            # processing
            my %arglist_keys = map { $_->[0] => $_->[1] } @$arglist;
            if ( scalar keys %arglist_keys != scalar keys %$args ) {
                my %more_args = %$args;
                for ( keys %arglist_keys ) {
                    delete $more_args{$_} if exists $more_args{$_};
                }
                if (%more_args) {
                    push @$arglist, [ $_ => $more_args{$_} ]
                        foreach grep { exists $filters->{$_} }
                        keys %more_args;
                }
            }
        }
        elsif ( keys %$args && !@$arglist ) {

            # in the event that we don't have arglist,
            # we'll build it using the hashref we do have
            # we might as well preserve the original ordering
            # of processing as well, since it's better than
            # the pseudo random order we get from retrieving the
            # keys from the hash.
            push @$arglist, [ $_, $args->{$_} ] foreach sort {
                exists $order{$a} && exists $order{$b}
                    ? $order{$a} <=> $order{$b}
                    : 0
                }
                grep { exists $filters->{$_} }
                keys %$args;
        }
        for my $arg (@$arglist) {
            my ( $name, $val ) = @$arg;
            next unless exists $args->{$name};
            if ( my $code = $filters->{$name} ) {
                if ( ref $code eq 'HASH' ) {
                    $code = $code->{code}
                        ||= MT->handler_to_coderef( $code->{handler} );
                }
                elsif ( !ref $code ) {
                    $code = MT->handler_to_coderef($code);
                }
                elsif ( defined $code and !ref $code ) {
                    $code = MT->handler_to_coderef($code);
                }
                $str = $code->( $str, $val, $ctx );
            }
        }
        $str;
    }
}

sub post_process_handler {
    \&stock_post_process_handler;
}

sub slurp {
    my ( $ctx, $args, $cond ) = @_;
    my $tokens = $ctx->stash('tokens');
    return '' unless $tokens;
    my $result = $ctx->stash('builder')->build( $ctx, $tokens, $cond );
    return $ctx->error( $ctx->stash('builder')->errstr )
        unless defined $result;
    return $result;
}

sub else {
    my ( $ctx, $args, $cond ) = @_;
    my $tokens = $ctx->stash('tokens_else');
    return '' unless $tokens;
    my $result = $ctx->stash('builder')->build( $ctx, $tokens, $cond );
    return $ctx->error( $ctx->stash('builder')->errstr )
        unless defined $result;
    return $result;
}

sub build {
    my ( $ctx, $tmpl, $cond ) = @_;
    my $builder = $ctx->stash('builder');
    my $tokens = $builder->compile( $ctx, $tmpl )
        or return $ctx->error( $builder->errstr );
    local $ctx->{stash}{tokens} = $tokens;
    my $result = $builder->build( $ctx, $tokens, $cond );
    return $ctx->error( $builder->errstr )
        unless defined $result;
    return $result;
}

sub set_blog_load_context {
    my ( $ctx, $attr, $terms, $args, $col ) = @_;
    my $blog_id = $ctx->stash('blog_id');
    $col ||= 'blog_id';

    # Preprocess from MultiBlog
    MT::Template::Context::_preprocess_multiblog(@_);

    # Grab specified blog IDs
    my $blog_ids
        = $attr->{include_sites}
        || $attr->{blog_ids}
        || $attr->{include_blogs}
        || $attr->{site_ids}
        || $attr->{include_websites};

    if ( defined($blog_ids) && ( $blog_ids =~ m/-/ ) ) {
        my @list = split /\s*,\s*/, $blog_ids;
        my @ids;
        foreach my $id (@list) {
            if ( $id =~ m/^(\d+)-(\d+)$/ ) {
                push @ids, $_ for $1 .. $2;
            }
            else {
                push @ids, $id;
            }
        }
        $blog_ids = join ",", @ids;
    }

    # If no blog IDs specified, use the current blog
    if ( !$blog_ids ) {
        if ( my $blog = $ctx->stash('blog') ) {
            my $tag = lc $ctx->stash('tag');
            if (   $tag eq 'websitepingcount'
                || $tag eq 'websiteentrycount'
                || $tag eq 'websitepagecount'
                || $tag eq 'websitecommentcount' )
            {
                my $website = $blog->website
                    or return $ctx->_no_parent_website_error();
                $terms->{$col} = $website->id
                    if $website->id && $col eq 'blog_id';
            }
            else {
                $terms->{$col} = $blog_id if $blog_id && $col eq 'blog_id';
            }
        }

        # include_blogs="all" removes the blog_id/id constraint
    }
    elsif ( lc $blog_ids eq 'all' ) {
        delete $terms->{$col} if exists $terms->{$col};

     # "include_blogs='site'" collects all blogs in current context of website
    }
    elsif (
        ( my $blog = $ctx->stash('blog') )
        && (   ( lc($blog_ids) eq 'site' )
            || ( lc($blog_ids) eq 'children' )
            || ( lc($blog_ids) eq 'siblings' ) )
        )
    {
        my $website
            = $blog->is_blog
            ? $blog->website
            : $blog;
        my ( @blogs, $blog_ids );
        @blogs = MT->model('blog')->load( { parent_id => $website->id } );
        $blog_ids = scalar @blogs ? [ map { $_->id } @blogs ] : [];
        push @$blog_ids, $website->id
            if $attr->{include_parent_site} || $attr->{include_with_website};
        $blog_ids = -1
            unless scalar @$blog_ids
            ; # We should use non-existing blog id when calculated blog_ids is empty
        $terms->{$col} = $blog_ids;

        # Blogs are specified in include_blogs so set the terms
    }
    else {
        my $blogs = { map { $_ => 1 } split /\s*,\s*/, $blog_ids };
        $terms->{$col} = [ keys %{$blogs} ];
    }

    # Filtered by acl;
    my $allow;
    $allow = delete $attr->{allow_blogs} if $attr->{allow_blogs};
    if ($allow) {
        if ( !$terms->{$col} ) {
            $terms->{$col} = $allow;
        }
        else {
            my $term_ids = $terms->{$col};
            $term_ids = [$term_ids] unless ref $term_ids eq 'ARRAY';
            my %seen = map { $_ => 1 } @$allow;
            my @allows = grep { $seen{$_} } @$term_ids;
            if (@allows) {
                $terms->{$col} = \@allows;
            }
            else {
                $terms->{$col} = $blog_id;
            }
        }
    }

    # If exclude blogs, set the terms and the NOT arg for load
    # 'All' is not a valid value for exclude_blogs
    if (   $attr->{exclude_sites}
        || $attr->{exclude_blogs}
        || $attr->{exclude_websites}
        || $attr->{deny_blogs} )
    {
        my $exclude_ids
            = $attr->{exclude_sites}
            || $attr->{exclude_blogs}
            || $attr->{exclude_websites};
        return $ctx->error(
            MT->translate(
                "The attribute exclude_blogs cannot take '[_1]' for a value.",
                $exclude_ids
            )
        ) if lc $exclude_ids eq 'all';

        my @blog_ids;
        if (   ( lc($exclude_ids) eq 'site' )
            || ( lc($exclude_ids) eq 'children' )
            || ( lc($exclude_ids) eq 'siblings' ) )
        {
            my ( $ex_args, %terms, %args );
            $ex_args->{include_blogs} = $exclude_ids;
            $ctx->set_blog_load_context( $ex_args, \%terms, \%args, $col );
            @blog_ids = @{ $terms{$col} };
        }
        else {
            @blog_ids = split /\s*,\s*/, $exclude_ids;
        }

        # Merge deny list
        push @blog_ids, @{ $attr->{deny_blogs} } if $attr->{deny_blogs};
        my %seen;
        @seen{@blog_ids} = ();
        @blog_ids = keys %seen;

        if ( !$blog_ids || lc $blog_ids eq 'all' || !$terms->{$col} ) {
            $terms->{$col} = \@blog_ids;
            $args->{not}{$col} = 1;
        }
        else {
            my $term_ids = $terms->{$col};
            $term_ids = [$term_ids] unless ref $term_ids eq 'ARRAY';
            my %exc_ids = map { $_ => 1 } @blog_ids;
            @blog_ids = grep { !$exc_ids{$_} } @$term_ids;
            return $ctx->error(
                MT->translate(
                    "When the same blog IDs are simultaneously listed in the include_blogs and exclude_blogs attributes, those blogs are excluded."
                )
            ) unless @blog_ids;

            if (@blog_ids) {
                $terms->{$col} = \@blog_ids;
            }
            else {
                $terms->{$col} = $blog_id;
            }
        }
    }

    1;
}

sub set_content_type_load_context {
    my ( $ctx, $args, $cond, $cd_terms, $cd_args ) = @_;

    $ctx->set_blog_load_context( $args, $cd_terms, $cd_args )
        or return $ctx->error( $ctx->errstr );

    if ( my $arg = $args->{content_type} ) {
        my $class   = MT->model('content_type');
        my $blog_id = $cd_terms->{blog_id};
        my $ct      = $class->load_by_id_or_name( $arg, $blog_id );
        return $ctx->_no_content_type_error unless $ct;
        $cd_terms->{content_type_id} = $ct->id;
    }
    1;
}

sub get_content_type_context {
    my ( $ctx, $args, $cond ) = @_;

    my $blog         = $ctx->stash('blog');
    my $content_type = $ctx->stash('content_type');
    my $blog_id      = $args->{blog_id} || $blog->id || '';

    if ( my $str = $args->{content_type} ) {
        ## If $str points to $content_type, just return it
        return $content_type
            if (
            $content_type
            && (   ( $str =~ /^[0-9]+$/ && $content_type->id eq $str )
                || ( $str eq $content_type->unique_id )
                || (   $str eq $content_type->name
                    && $content_type->blog_id eq $blog_id )
            )
            );
        $content_type
            = MT->model('content_type')->load_by_id_or_name( $str, $blog_id );
        return $ctx->_no_content_type_error() unless $content_type;
    }

    return $content_type;
}

sub compile_category_filter {
    my ( $ctx, $cat_expr, $cats, $param ) = @_;

    $param ||= {};
    $cats  ||= [];
    my $is_and   = $param->{'and'}      ? 1 : 0;
    my $children = $param->{'children'} ? 1 : 0;

    if ($cat_expr) {

        # we got an expression, and a list of categories to try to fit in
        my $use_ex_names = $cat_expr =~ m!/! ? 1 : 0;
        my %cats_dir;
        foreach my $cat (@$cats) {
            my @ex_cat;
            if ($children) {
                my @kids = ($cat);
                while ( my $c = shift @kids ) {
                    push @ex_cat, $c;
                    push @kids, ( $c->children_categories );
                }
            }
            else {
                @ex_cat = ($cat);
            }
            push @{ $cats_dir{ $cat->label } ||= [] }, @ex_cat;
            next unless $use_ex_names;
            next if $cat->label eq $cat->category_label_path;
            push @{ $cats_dir{ $cat->category_label_path } ||= [] }, @ex_cat;
        }
        my $new_expr = '';
        my %cats_used;
        my $label_token
            = %cats_dir
            ? join( '|',
            map  { quotemeta($_) . '(?!/)' }
            sort { $b cmp $a } keys %cats_dir )
            . '|'
            : '';
        my @split_expr = split /($label_token\bOR\b|\bAND\b|\bNOT\b|\(|\))/i,
            $cat_expr;

        foreach my $token (@split_expr) {
            if ( grep { lc $token eq $_ } qw{OR AND NOT ( )} ) {
                $new_expr .= $token;
                next;
            }
            if ( $token =~ m/^\s*$/ ) {
                $new_expr .= $token;
                next;
            }
            my ($b_space) = $token =~ m/^(\s*)/;
            my ($e_space) = $token =~ m/(\s*)$/;
            substr( $token, 0, length($b_space), '' );
            substr( $token, -length($e_space), length($e_space), '' )
                if length($e_space);
            $new_expr .= $b_space;
            if ( not exists $cats_dir{$token} ) {
                $new_expr .= $token . $e_space;
                next;
            }
            $cats_used{ $_->id } = $_ foreach @{ $cats_dir{$token} };
            if ( 1 == @{ $cats_dir{$token} } ) {
                $new_expr .= "#" . $cats_dir{$token}->[0]->id;
            }
            else {
                my $str
                    = join( ' OR ', map "#" . $_->id,
                    @{ $cats_dir{$token} } );
                $new_expr .= "($str)";
            }
            $new_expr .= $e_space;
        }
        $cat_expr = $new_expr;
        @$cats    = values %cats_used;

        # when $cat_expr not containing AND, OR or NOT,
        # parenthesis is invalid token.
        my $regexp;
        if ( $cat_expr =~ /\b(AND|OR|NOT)\b/i ) {
            $regexp = qr/#\d+|&&|\|\||!|\(|\)/;
        }
        else {
            $regexp = qr/#\d+/;
        }

        $cat_expr =~ s/\bAND\b/&&/gi;
        $cat_expr =~ s/\bOR\b/||/gi;
        $cat_expr =~ s/\bNOT\b/!/gi;

        # replace any other 'thing' with '(0)' since it's a
        # category that doesn't even exist.
        my @cat_expr = split /($regexp)/,
            $cat_expr;    # Split by valid tokens, which are kept.
        @cat_expr = grep { $_ ne '' } @cat_expr;    # Remove empty tokens.
        @cat_expr = map { $_ =~ /^(\s+|$regexp)$/ ? $_ : '(0)' }
            @cat_expr;    # Replace invalid tokens with '(0)'.
        $cat_expr = join '', @cat_expr;

        # strip out all the 'ok' stuff. if anything is left, we have
        # some invalid data in our expression:
        my $test_expr = $cat_expr;
        $test_expr =~ s/\s+|\(0\)|$regexp//g;
        return undef if $test_expr;
    }
    else {
        my %cats_used;
        $cat_expr = '';
        foreach my $cat (@$cats) {
            my $id = $cat->id;
            $cat_expr .= ( $is_and ? '&&' : '||' ) if $cat_expr ne '';
            if ($children) {
                my @kids = ($cat);
                my @cats;
                while ( my $c = shift @kids ) {
                    push @cats, $c;
                    push @kids, ( $c->children_categories );
                }
                my $repl = '';
                $repl .= '||' . '#' . $_->id for @cats;
                $cats_used{ $_->id } = $_ for @cats;
                $repl = '(' . substr( $repl, 2 ) . ')';
                $cat_expr .= $repl;
            }
            else {
                $cats_used{ $cat->id } = $cat;
                $cat_expr .= "#$id";
            }
        }
        @$cats = values %cats_used;
    }

    $cat_expr =~ s/#(\d+)/(exists \$p->{$1})/g;
    my $expr  = 'sub{my($p)=@_;' . $cat_expr . ';}';
    my $cexpr = eval($expr);
    $@ ? undef : $cexpr;
}

sub compile_tag_filter {
    my ( $ctx, $tag_expr, $tags ) = @_;

    # Sort in descending order by length
    @$tags = sort { length( $b->name ) <=> length( $a->name ) } @$tags;

    # Modify the tag argument, replacing the tag name with '#TagID'
    # Create a ID-based hash of the tags that are used in the arg
    my %tags_used;
    foreach my $tag (@$tags) {
        my $name = $tag->name;
        ## FIXME: this implementation can't handle tags which starts
        ## with hash mark and numbers related. because they could break
        ## our mid-compiled expression. now just skip them.
        next if $name =~ /^\s*\#\d+\s*$/;
        my $id = $tag->id;

        ## search for tags from expression and replace them with its IDs.
        ## allowed only existing tag name and some logical operators
        ## ( AND, OR, NOT, and round brackets ).
        if ($tag_expr =~ s/
                (
                    \sAND\s
                    | \sOR\s
                    | \s?NOT\s
                    | \(
                    | \A
                )
                \s*?
                \Q$name\E
                \s*?
                (
                    \Z
                    | \)
                    | \sAND\s
                    | \sOR\s
                    | \sNOT\s
                )
            /$1#$id$2/igx
            )    # Change all matches to #$id (e.g. #932)
        {
            $tags_used{$id} = $tag;
        }
    }

    # Populate array ref (passed in by reference) of used tags
    @$tags = values %tags_used;

    # when $cat_expr not containing AND, OR or NOT,
    # parenthesis is invalid token.
    my $regexp;
    if ( $tag_expr =~ /\b(AND|OR|NOT)\b/i ) {
        $regexp = qr/#\d+|&&|\|\||!|\(|\)/;
    }
    else {
        $regexp = qr/#\d+/;
    }

    # Replace logical constructs with their perl equivalents
    $tag_expr =~ s/\bAND\b/&&/gi;
    $tag_expr =~ s/\bOR\b/||/gi;
    $tag_expr =~ s/\bNOT\b/!/gi;

    # If any foreign/unrecognized sequences appear in our
    # expression (such as a non-extistent tag name),
    # replace that with '(0)' which will evaluate to false.
    my @tag_expr = split /($regexp)/,
        $tag_expr;    # Split by valid tokens, which are kept.
    @tag_expr = grep { $_ ne '' } @tag_expr;    # Remove empty tokens.
    @tag_expr = map { $_ =~ /^(\s+|$regexp)$/ ? $_ : '(0)' }
        @tag_expr;    # Replace invalid tokens with '(0)'.
    $tag_expr = join '', @tag_expr;

    # Syntax check on 'tag' argument
    # Strip out all the valid stuff. if anything is left, we have
    # some invalid data in our expression:
    my $test_expr = $tag_expr;
    $test_expr =~ s/\s+|\(0\)|$regexp//g;
    return undef if ($test_expr);

    # Replace '#TagID' with a hash lookup function.
    # Function confirms/denies use of tag on entry (by IDs)
    # Translation: exists( PlacementHashRef->{EntryID}{TagID} )
    $tag_expr =~ s/#(\d+)/(exists \$p->{$1})/g;

    # Create an anonymous subroutine of that lookup function
    # and return it if all is well.  This code ref will be used
    # later to test for existence of specified tags in entries.
    my $expr  = 'sub{my($p)=@_;' . $tag_expr . '}';
    my $cexpr = eval $expr;
    $@ ? undef : $cexpr;
}

sub compile_role_filter {
    my ( $ctx, $role_expr, $roles ) = @_;

    # Sort in descending order by length
    @$roles = sort { length( $b->name ) <=> length( $a->name ) } @$roles;

    my %roles_used;
    foreach my $role (@$roles) {
        my $name = $role->name;
        my $id   = $role->id;
        if ( $role_expr =~ s/(?<![#\d])\Q$name\E/#$id/g ) {
            $roles_used{$id} = $role;
        }
    }
    @$roles = values %roles_used;

    $role_expr =~ s/\bOR\b/||/gi;
    $role_expr =~ s/\bAND\b/&&/gi;
    $role_expr =~ s/\bNOT\b/!/gi;
    $role_expr =~ s/( |#\d+|&&|\|\||!|\(|\))|([^#&|!()]+)/$2?'(0)':$1/ge;

    my $test_expr = $role_expr;
    $test_expr =~ s/!|&&|\|\||\(0\)|\(|\)|\s|#\d+//g;
    return undef if $test_expr;

    $role_expr =~ s/#(\d+)/(exists \$p->{\$e}{$1})/g;
    my $expr  = 'sub{my($e,$p)=@_;' . $role_expr . ';}';
    my $cexpr = eval $expr;
    $@ ? undef : $cexpr;
}

sub compile_status_filter {
    my ( $ctx, $status_expr, $status ) = @_;

    foreach my $s (@$status) {
        my $name = $s->{name};
        my $id   = $s->{id};
        $status_expr =~ s/(?<![#\d])\Q$name\E/#$id/g;
    }

    $status_expr =~ s/\bOR\b/||/gi;
    $status_expr =~ s/( |#\d+|&&|\|\||!|\(|\))|([^#&|!()]+)/$2?'(0)':$1/ge;

    my $test_expr = $status_expr;
    $test_expr =~ s/!|&&|\|\||\(0\)|\(|\)|\s|#\d+//g;
    return undef if $test_expr;

    $status_expr =~ s/#(\d+)/(\$_[0]->status == $1)/g;
    my $expr  = 'sub{' . $status_expr . ';}';
    my $cexpr = eval $expr;
    $@ ? undef : $cexpr;
}

sub set_tag_filter_context {
    my ( $ctx, $param ) = @_;

    # You can pass undef to $object_args if you do not want to filter by SQL statements.
    my ( $objects, $tag_arg, $blog_terms, $blog_args, $object_args, $filters, $datasource ) = @$param{qw(objects tag_arg blog_terms blog_args object_args filters datasource)};

    require MT::Tag;
    require MT::ObjectTag;

    my $terms;
    if ( $tag_arg !~ m/\b(AND|OR|NOT)\b|\(|\)/i ) {
        my @tags = MT::Tag->split( ',', $tag_arg );
        $terms   = { name => \@tags };
        $tag_arg = join " or ", @tags;
    }
    my @tags = MT::Tag->load(
        $terms,
        {   ( $terms ? ( binary => { name => 1 } ) : () ),
            join => MT::ObjectTag->join_on(
                'tag_id',
                {   object_datasource => $datasource,
                    %$blog_terms,
                },
                { %$blog_args, unique => 1 }
            ),
        }
    );

    my $cexpr = $ctx->compile_tag_filter( $tag_arg, \@tags )
        or return $ctx->error(
            MT->translate(
                "You have an error in your '[_2]' attribute: [_1]",
                $tag_arg, 'tag'
            )
            );

    my @tag_ids = map { $_->id, ( $_->n8d_id ? ( $_->n8d_id ) : () ) } @tags;

    if ( $tag_arg !~ m/\bNOT\b/i ) {
        if ( !@tags ) {
            return 'no_matching_tags';
        }

        if ($object_args) {
            push @{ $object_args->{joins} },
                MT::ObjectTag->join_on(
                'object_id',
                {   tag_id            => \@tag_ids,
                    object_datasource => $datasource,
                    %$blog_terms
                },
                { %$blog_args, unique => 1 }
                );
        }
    }

    # We can filter by "JOIN" statement for simple args. (single tag, "or" condition)
    return 'filter_only_by_join'
        if !$objects && $object_args && $tag_arg !~ m/\b(AND|NOT)\b|\(|\)/i;

    # TODO: optimize $preloader
    my $preloader = @tag_ids
        ? sub {
        my ($object_id) = @_;
        my $preload_terms = {
            tag_id            => \@tag_ids,
            object_id         => $object_id,
            object_datasource => $datasource,
            %$blog_terms,
        };
        my $preload_args = {
            %$blog_args,
            fetchonly   => ['tag_id'],
            no_triggers => 1,
        };
        my @ot_ids;
        @ot_ids = MT::ObjectTag->load( $preload_terms, $preload_args );
        my %map;
        $map{ $_->tag_id } = 1 for @ot_ids;
        \%map;
        }
        : sub { +{} };
    push @$filters, sub { $cexpr->( $preloader->( $_[0]->id ) ) };

    return 'filter_added';
}

sub count_format {
    my $ctx = shift;
    my ( $count, $args ) = @_;
    my $phrase;
    $count ||= 0;
    if ( $count == 0 ) {
        $phrase
            = exists $args->{none}
            ? $args->{none}
            : ( exists $args->{plural} ? $args->{plural} : '' );
    }
    elsif ( $count == 1 ) {
        $phrase = exists $args->{singular} ? $args->{singular} : '';
    }
    elsif ( $count > 1 ) {
        $phrase = exists $args->{plural} ? $args->{plural} : '';
    }
    return $count if $phrase eq '';
    return $phrase unless $phrase =~ m/#/;

    $phrase =~ s/(?<!\\)#/$count/g;
    $phrase =~ s/\\#/#/g;
    return $phrase;
}

sub _preprocess_multiblog {
    my ( $ctx, $args, $cond ) = @_;
    my $tag = lc $ctx->stash('tag');

    # If we're running under MT-Search, set the context based on the search
    # parameters available.
    unless ( $args->{blog_id}
        || $args->{include_sites}
        || $args->{exclude_sites}
        || $args->{blog_ids}
        || $args->{site_ids}
        || $args->{include_blogs}
        || $args->{exclude_blogs}
        || $args->{include_websites}
        || $args->{exclude_websites} )
    {
        my $app = MT->instance;
        if ( $app->isa('MT::App::Search') && !$ctx->stash('inside_blogs') ) {
            if ( my $excl = $app->{searchparam}{ExcludeBlogs} ) {
                $args->{exclude_blogs} ||= join ',', @$excl;
            }
            elsif ( my $incl = $app->{searchparam}{IncludeBlogs} ) {
                $args->{include_blogs} = join ',', @$incl;
            }

            if ( ( $args->{include_blogs} || $args->{exclude_blogs} )
                && $args->{blog_id} )
            {
                delete $args->{blog_id};
            }
        }
    }

    # Load sites access control list
    my $incl
        = $args->{include_sites}
        || $args->{include_blogs}
        || $args->{include_websites}
        || $args->{blog_id}
        || $args->{blog_ids}
        || grep( $_ eq $tag, 'blogs', 'websites' );
    my $excl
        = $args->{exclude_sites}
        || $args->{exclude_blogs}
        || $args->{exclude_websites};
    for ( $incl, $excl ) {
        next unless $_;
        s{\s+}{}g;    # Remove spaces
    }
    if ( $incl or $excl ) {
        require MT::RebuildTrigger;
        my %acl = MT::RebuildTrigger->load_sites_acl($ctx);
        $args->{ $acl{mode} } = $acl{acl};
    }

    # Explicity set blog_id for MTInclude if not specified
    # so that it never gets sites context from MTSites
    if ( $tag eq 'include' and !exists $args->{blog_id} ) {
        if ( $ctx->stash('sites_context') ) {
            if ( !$args->{local} && !$args->{global} && !$args->{parent} ) {
                $args->{blog_id} = $ctx->stash('blog_id');
            }
            elsif ( $args->{local} ) {
                my $local_blog_id = $ctx->stash('local_blog_id');
                if ( defined $local_blog_id ) {
                    $args->{blog_id} = $ctx->stash('local_blog_id');
                }
            }
        }
        else {
            my $local_blog_id = $ctx->stash('local_blog_id');
            if ( defined $local_blog_id ) {
                $args->{blog_id} = $ctx->stash('local_blog_id');
            }
        }
    }

    # If no include_blogs/exclude_blogs specified look for a
    # previously set MTSites context
    elsif ( $ctx->stash('sites_context') ) {
        $args->{include_blogs} = $ctx->stash('sites_include_blog_ids')
            if $ctx->stash('sites_include_blog_ids');
        $args->{exclude_blogs} = $ctx->stash('sites_exclude_blog_ids')
            if $ctx->stash('sites_exclude_blog_ids');
    }

    # Remove local blog ID from MTTags since it is cross-blog
    # and hence MTMultiBlogIfLocalBlog doesn't make sense there.
    local $ctx->{__stash}{local_blog_id} = 0 if $tag eq 'tags';
}

sub _no_author_error {
    my ($ctx) = @_;
    my $tag_name = $ctx->stash('tag');
    return $ctx->error(
        MT->translate(
            "You used an '[_1]' tag outside of the context of a author; "
                . "Perhaps you mistakenly placed it outside of an 'MTAuthors' "
                . "container tag?",
            $tag_name
        )
    );
}

sub _no_entry_error {
    my ($ctx) = @_;
    my $tag_name = $ctx->stash('tag');
    $tag_name = 'mt' . $tag_name unless $tag_name =~ m/^MT/i;
    return $_[0]->error(
        MT->translate(
            "You used an '[_1]' tag outside of the context of an entry; "
                . "Perhaps you mistakenly placed it outside of an 'MTEntries' container tag?",
            $tag_name
        )
    );
}

sub _no_content_type_error {
    my ($ctx) = @_;
    $ctx->error( MT->translate('No Content Type could be found.') );
}

sub _no_content_error {
    my ($ctx) = @_;
    my $tag_name = $ctx->stash('tag');
    $tag_name = 'mt' . $tag_name unless $tag_name =~ m/^MT/i;
    return $_[0]->error(
        MT->translate(
            "You used an '[_1]' tag outside of the context of a content; "
                . "Perhaps you mistakenly placed it outside of an 'MTContents' container tag?",
            $tag_name
        )
    );
}

sub _no_content_field_error {
    my ( $ctx, $args_content_field ) = @_;
    if ( defined $args_content_field && $args_content_field ne '' ) {
        $ctx->error(
            MT->translate(
                'No Content Field could be found: "[_1]"',
                $args_content_field
            )
        );
    }
    else {
        $ctx->error( MT->translate('No Content Field could be found.') );
    }
}

sub _no_website_error {
    my ($ctx) = @_;
    my $tag_name = $ctx->stash('tag');
    $tag_name = 'mt' . $tag_name unless $tag_name =~ m/^MT/i;
    return $_[0]->error(
        MT->translate(
            "You used an '[_1]' tag outside of the context of the website; "
                . "Perhaps you mistakenly placed it outside of an 'MTWebsites' container tag?",
            $tag_name
        )
    );
}

sub _no_parent_website_error {
    my ($ctx) = @_;
    my $tag_name = $ctx->stash('tag');
    $tag_name = 'mt' . $tag_name unless $tag_name =~ m/^MT/i;
    return $_[0]->error(
        MT->translate(
            "You used an \'[_1]\' tag inside of the context of a blog which has no parent website; "
                . "Perhaps your blog record is broken?",
            $tag_name
        )
    );
}

sub _no_blog_error {
    my ($ctx) = @_;
    my $tag_name = $ctx->stash('tag');
    $tag_name = 'mt' . $tag_name unless $tag_name =~ m/^MT/i;
    return $_[0]->error(
        MT->translate(
            "You used an '[_1]' tag outside of the context of the blog; "
                . "Perhaps you mistakenly placed it outside of an 'MTBlogs' container tag?",
            $tag_name
        )
    );
}

sub _no_site_error {
    my ($ctx) = @_;
    my $tag_name = $ctx->stash('tag');
    $tag_name = 'mt' . $tag_name unless $tag_name =~ m/^MT/i;
    return $_[0]->error(
        MT->translate(
            "You used an '[_1]' tag outside of the context of the site;",
            $tag_name
        )
    );
}

sub _no_comment_error {
    my ($ctx) = @_;
    my $tag_name = $ctx->stash('tag');
    $tag_name = 'mt' . $tag_name unless $tag_name =~ m/^MT/i;
    return $ctx->error(
        MT->translate(
            "You used an '[_1]' tag outside of the context of a comment; "
                . "Perhaps you mistakenly placed it outside of an 'MTComments' "
                . "container tag?",
            $tag_name
        )
    );
}

sub _no_ping_error {
    my ($ctx) = @_;
    my $tag_name = $ctx->stash('tag');
    $tag_name = 'mt' . $tag_name unless $tag_name =~ m/^MT/i;
    return $ctx->error(
        MT->translate(
            "You used an '[_1]' tag outside of the context of "
                . "a ping; Perhaps you mistakenly placed it outside "
                . "of an 'MTPings' container tag?",
            $tag_name
        )
    );
}

sub _no_asset_error {
    my ($ctx) = @_;
    my $tag_name = $ctx->stash('tag');
    $tag_name = 'mt' . $tag_name unless $tag_name =~ m/^MT/i;
    return $ctx->error(
        MT->translate(
            "You used an '[_1]' tag outside of the context of an asset; "
                . "Perhaps you mistakenly placed it outside of an 'MTAssets' container tag?",
            $tag_name
        )
    );

}

sub _no_page_error {
    my ($ctx) = @_;
    my $tag_name = $ctx->stash('tag');
    $tag_name = 'mt' . $tag_name unless $tag_name =~ m/^MT/i;
    return $ctx->error(
        MT->translate(
            "You used an '[_1]' tag outside of the context of a page; "
                . "Perhaps you mistakenly placed it outside of a 'MTPages' container tag?",
            $tag_name
        )
    );
}

sub _no_category_set_error {
    my ($ctx) = @_;
    $ctx->error( MT->translate('No Category Set could be found.') );
}

# overridden in other contexts
sub context_script {''}

1;
__END__

=head1 NAME

MT::Template::Context - Movable Type Template Context

=head1 SYNOPSIS

    use MT::Template::Context;
    MT::Template::Context->add_tag( FooBar => sub {
        my($ctx, $args) = @_;
        my $foo = $ctx->stash('foo')
            or return $ctx->error("No foo in context");
        $foo->bar;
    } );

    ## In a template:
    ## <$MTFooBar$>

=head1 DESCRIPTION

I<MT::Template::Context> provides the implementation for all of the built-in
template tags in Movable Type, as well as the public interface to the
system's plugin interface.

This document focuses only on the public methods needed to implement plugins
in Movable Type, and the methods that plugin developers might wish to make
use of. Of course, plugins can make use of other objects loaded from the
Movable Type database, in which case you may wish to look at the documentation
for the classes in question (for example, I<MT::Entry>).

=head1 USAGE

=head2 MT::Template::Context->add_tag($name, \&subroutine)

I<add_tag> registers a simple "variable tag" with the system. An example of
such a tag might be C<E<lt>$MTEntryTitle$E<gt>>.

I<$name> is the name of the tag, without the I<MT> prefix, and
I<\&subroutine> a reference to a subroutine (either anonymous or named).
I<\&subroutine> should return either an error (see L<ERROR HANDLING>) or
a defined scalar value (returning C<undef> will be treated as an error, so
instead of returning C<undef>, always return the empty string instead).

For example:

    MT::Template::Context->add_tag(ServerUptime => sub { `uptime` });

This tag would be used in a template as C<E<lt>$MTServerUptime$E<gt>>.

The subroutine reference will be passed two arguments: the
I<MT::Template::Context> object with which the template is being built, and
a reference to a hash containing the arguments passed in through the template
tag. For example, if a tag C<E<lt>$MTFooBar$E<gt>> were called like

    <$MTFooBar baz="1" quux="2"$>

the second argument to the subroutine registered with this tag would be

    {
        'quux' => 2,
        'bar' => 1
    };

=head2 MT::Template::Context->add_container_tag($name, \&subroutine)

Registers a "container tag" with the template system. Container tags are
generally used to represent either a loop or a conditional. In practice, you
should probably use I<add_container_tag> just for loops--use
I<add_conditional_tag> for a conditional, because it will take care of much
of the backend work for you (most conditional tag handlers have a similar
structure).

I<$name> is the name of the tag, without the I<MT> prefix, and
I<\&subroutine> a reference to a subroutine (either anonymous or named).
I<\&subroutine> should return either an error (see L<ERROR HANDLING>) or
a defined scalar value (returning C<undef> will be treated as an error, so
instead of returning C<undef>, always return the empty string instead).

The subroutine reference will be passed two arguments: the
I<MT::Template::Context> object with which the template is being built, and
a reference to a hash containing the arguments passed in through the template
tag.

Since a container tag generally represents a loop, inside of your subroutine
you will need to use a loop construct to loop over some list of items, and
build the template tags used inside of the container for each of those
items. These inner template tags have B<already been compiled into a list of
tokens>. You need only use the I<MT::Builder> object to build this list of
tokens into a scalar string, then add the string to your output value. The
list of tokens is in C<$ctx-E<gt>stash('tokens')>, and the I<MT::Builder>
object is in C<$ctx-E<gt>stash('builder')>.

For example, if a tag C<E<lt>MTLoopE<gt>> were used like this:

    <MTLoop>
    The value of I is: <$MTLoopIValue$>
    </MTLoop>

a sample implementation of this set of tags might look like this:

    MT::Template::Context->add_container_tag(Loop => sub {
        my $ctx = shift;
        my $res = '';
        my $builder = $ctx->stash('builder');
        my $tokens = $ctx->stash('tokens');
        for my $i (1..5) {
            $ctx->stash('i_value', $i);
            defined(my $out = $builder->build($ctx, $tokens))
                or return $ctx->error($builder->errstr);
            $res .= $out;
        }
        $res;
    });

    MT::Template::Context->add_tag(LoopIValue => sub {
        my $ctx = shift;
        $ctx->stash('i_value');
    });

C<E<lt>$MTLoopIValue$E<gt>> is a simple variable tag. C<E<lt>MTLoopE<gt>> is
registered as a container tag, and it loops over the numbers 1 through 5,
building the list of tokens between C<E<lt>MTLoopE<gt>> and
C<E<lt>/MTLoopE<gt>> for each number. It checks for an error return value
from the C<$builder-E<gt>build> invocation each time through.

Use of the tags above would produce:

    The value of I is: 1
    The value of I is: 2
    The value of I is: 3
    The value of I is: 4
    The value of I is: 5

=head2 MT::Template::Context->add_conditional_tag($name, $condition)

Registers a conditional tag with the template system.

Conditional tags are technically just container tags, but in order to make
it very easy to write conditional tags, you can use the I<add_conditional_tag>
method. I<$name> is the name of the tag, without the I<MT> prefix, and
I<$condition> is a reference to a subroutine which should return true if
the condition is true, and false otherwise. If the condition is true, the
block of tags and markup inside of the conditional tag will be executed and
displayed; otherwise, it will be ignored.

For example, the following code registers two conditional tags:

    MT::Template::Context->add_conditional_tag(IfYes => sub { 1 });
    MT::Template::Context->add_conditional_tag(IfNo => sub { 0 });

C<E<lt>MTIfYesE<gt>> will always display its contents, because it always
returns 1; C<E<lt>MTIfNoE<gt>> will never display is contents, because it
always returns 0. So if these tags were to be used like this:

    <MTIfYes>Yes, this appears.</MTIfYes>
    <MTIfNo>No, this doesn't appear.</MTIfNo>

Only "Yes, this appears." would be displayed.

A more interesting example is to add a tag C<E<lt>MTEntryIfTitleE<gt>>,
to be used in entry context, and which will display its contents if the
entry has a title.

    MT::Template::Context->add_conditional_tag(EntryIfTitle => sub {
        my $e = $_[0]->stash('entry') or return;
        defined($e->title) && $e->title ne '';
    });

To be used like this:

    <MTEntries>
    <MTEntryIfTitle>
    This entry has a title: <$MTEntryTitle$>
    </MTEntryIfTitle>
    </MTEntries>

=head2 MT::Template::Context->add_global_filter($name, \&subroutine)

Registers a global tag attribute. More information is available in the
Movable Type manual, in the Template Tags section, in "Global Tag Attributes".

Global tag attributes can be used in any tag, and are essentially global
filters, used to filter the normal output of the tag and modify it in some
way. For example, the I<lower_case> global tag attribute can be used like
this:

    <$MTEntryTitle lower_case="1"$>

and will transform all entry titles to lower-case.

Using I<add_global_filter> you can add your own global filters. I<$name>
is the name of the filter (this should be lower-case for consistency), and
I<\&subroutine> is a reference to a subroutine that will be called to
transform the normal output of the tag. I<\&subroutine> will be given three
arguments: the standard scalar output of the tag, the value of the attribute
(C<1> in the above I<lower_case> example), and the I<MT::Template::Context>
object being used to build the template.

For example, the following adds a I<rot13> filter:

    MT::Template::Context->add_global_filter(rot13 => sub {
        (my $s = shift) =~ tr/a-zA-Z/n-za-mN-ZA-M/;
        $s;
    });

Which can be used like this:

    <$MTEntryTitle rot13="1"$>

Another example: if we wished to implement the built-in I<trim_to> filter
using I<add_global_filter>, we would use this:

    MT::Template::Context->add_global_filter(trim_to => sub {
        my($str, $len, $ctx) = @_;
        $str = substr $str, 0, $len if $len < length($str);
        $str;
    });

The second argument (I<$len>) is used here to determine the length to which
the string (I<$str>) should be trimmed.

Note: If you add multiple global filters, the order in which they are called
is undefined, so you should not rely on any particular ordering.

=head2 $ctx->stash($key [, $value ])

A simple data stash that can be used to store data between calls to different
tags in your plugin. For example, this is very useful when implementing a
container tag, as we saw above in the implementation of C<E<lt>MTLoopE<gt>>.

I<$key> should be a scalar string identifying the data that you are stashing.
I<$value>, if provided>, should be any scalar value (a string, a number, a
reference, an object, etc).

When called with only I<$key>, returns the stashed value for I<$key>; when
called with both I<$key> and I<$value>, sets the stash for I<$key> to
I<$value>.

=head1 ERROR HANDLING

If an error occurs in one of the subroutine handlers within your plugin,
you should return an error by calling the I<error> method on the I<$ctx>
object:

    return $ctx->error("the error message");

In particular, you might wish to use this if your tag expects to be called
in a particular context. For example, the C<E<lt>$MTEntry*$E<gt>> tags all
expect that when they are called, an entry will be in context. So they all
use

    my $entry = $ctx->stash('entry')
        or return $ctx->error("Tag called without an entry in context");

to ensure this.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
