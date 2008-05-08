# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Template::Context;

use strict;
use base qw( MT::ErrorHandler );

use constant FALSE => -99999;
use Exporter;
*import = \&Exporter::import;
use vars qw( @EXPORT );
@EXPORT = qw( FALSE );
use MT::Util qw( weaken );
use MT::I18N qw( substr_text length_text );

our (%Handlers, %Filters);

sub new {
    my $class = shift;
    require MT::Template::ContextHandlers;
    my $ctx = bless {}, $class;
    $ctx->init(@_);
}

sub init {
    my $ctx = shift;
    weaken($ctx->{config} = MT->config);
    $ctx->init_handlers();
    $ctx;
}

sub clone {
    my $ctx = shift;
    my $clone = ref($ctx)->new;
    for my $key (keys %{$ctx}) {
	$clone->{$key} = $ctx->{$key}
    }
    return $clone;
}

sub init_handlers {
    my $ctx = shift;
    my $mt = MT->instance;
    if (!$mt->{__tag_handlers}) {
        my $h = $mt->{__tag_handlers} = {};
        my $f = $mt->{__tag_filters} = {};
        my $all_tags = MT::Component->registry('tags');
        # Put application-specific handlers in front of 'core'
        # tag set (allows MT::App::Search, etc to replace the
        # stubbed core handlers)
        if ($mt->isa('MT::App')) {
            my $app_tags = MT->registry("applications", $mt->id, "tags");
            unshift @$all_tags, $app_tags if $app_tags;
        }
        for my $tag_set ( @$all_tags ) {
            if (my $block = $tag_set->{block}) {
                for my $orig_tag (keys %$block) {
                    next if $orig_tag eq 'plugin';

                    my $tag = lc $orig_tag;
                    my $type = 1;

                    # A '?' suffix identifies conditional tags
                    if ($tag =~ m/\?$/) {
                        $tag =~ s/\?$//;
                        $type = 2;
                    }

                    # Application level tags should not be overwritten
                    # by 'core' tags (which may be placeholders, as in the
                    # case of MT-Search). Non-core plugins can override
                    # other core routines and application level tags though.
                    my $prev_hdlr;
                    if (exists $h->{$tag}) {
                        # a replaced handler
                        next if ($block->{plugin}{id}||'') eq 'core';
                        $prev_hdlr = $h->{$tag};
                    }
                    if (ref($block->{$orig_tag}) eq 'HASH') {
                        $h->{$tag} = [ $block->{$orig_tag}{handler}, $type, $prev_hdlr ];
                    } else {
                        $h->{$tag} = [ $block->{$orig_tag}, $type, $prev_hdlr ];
                    }
                }
            }
            if (my $func = $tag_set->{function}) {
                for my $orig_tag (keys %$func) {
                    next if $orig_tag eq 'plugin';

                    my $tag = lc $orig_tag;
                    my $prev_hdlr;
                    if (exists $h->{$tag}) {
                        # a replaced handler
                        next if ($func->{plugin}{id}||'') eq 'core';
                        $prev_hdlr = $h->{$tag};
                    }
                    if (ref($func->{$orig_tag}) eq 'HASH') {
                        $h->{$tag} = [ $func->{$orig_tag}{handler}, 0, $prev_hdlr ];
                    } else {
                        $h->{$tag} = [ $func->{$orig_tag}, 0, $prev_hdlr ];
                    }
                }
            }
            if (my $mod = $tag_set->{modifier}) {
                for my $orig_mod (keys %$mod) {
                    next if $orig_mod eq 'plugin';
                    my $modifier = lc $orig_mod;
                    next if exists $f->{$modifier} && ($mod->{plugin}{id} || '') eq 'core';
                    $f->{$modifier} = $mod->{$orig_mod};
                }
            }
        }
    }
    weaken( $ctx->{__handlers} = $mt->{__tag_handlers} );
    weaken( $ctx->{__filters} = $mt->{__tag_filters} );
}

sub super_handler {
    my ($ctx) = @_;
    my $tag = lc $ctx->stash('tag');
    my ($hdlr, $type, $orig_tag) = $ctx->handler_for($tag);
    if ($orig_tag && $orig_tag->[0]) {
        my $orig_hdlr = $orig_tag->[0];
        unless (ref $orig_hdlr) {
            $orig_tag->[0] = $orig_hdlr = MT->handler_to_coderef( $orig_hdlr );
        }
        local $ctx->{__handlers}{$tag} = $orig_tag;
        return $orig_hdlr->(@_);
    }
    return undef;
}

sub stash {
    my $ctx = shift;
    my $key = shift;
    return $ctx->{__stash}->{$key} = shift if @_;
    if (ref $ctx->{__stash}->{$key} eq 'MT::Promise') {
        return MT::Promise::force($ctx->{__stash}->{$key});
    } else {
        return $ctx->{__stash}->{$key};
    }
}

sub var {
    my $ctx = shift;
    my $key = lc shift;
    if ($key =~ m/^(config|request)\.(.+)$/i) {
        if (lc($1) eq 'request') {
            my $mt = MT->instance;
            return '' unless $mt->isa('MT::App');
            return $mt->param($2);
        }
        elsif (lc($1) eq 'config') {
            my $setting = $2;
            return '' if $setting =~ m/password/i;
            return MT->config($setting);
        }
        return '';
    }
    my $value = $ctx->{__stash}{vars}{$key};
    # protects $_ value set during template attribute interpolation
    local $_ = $_;
    if (ref $value eq 'CODE') {
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
    my ($h) = $ctx->handler_for($tag) or return $ctx->error("No handler for tag $tag");
    local $ctx->{__stash}{tag} = $tag;
    return $h->($ctx, @_);
}

sub handler_for {
    my $ctx = shift;
    my $tag = lc $_[0];
    my $v = $ctx->{__handlers}{$tag};
    if (ref($v) eq 'HASH') { 
    $v = $ctx->{__handlers}{$tag} = $v->{handler};
    }
    my @h = ref($v) eq 'ARRAY' ? @$v : $v;
    if (!ref($h[0])) {
        $h[0] = MT->handler_to_coderef($h[0]);
        if (ref($v)) {
            $ctx->{__handlers}{$tag}[0] = $h[0];
        } else {
            $ctx->{__handlers}{$tag} = $h[0];
        }
    }
    return ref($v) eq 'ARRAY' ? @h : $h[0];
}

{
    my (@order, %order);
    BEGIN {
        @order = qw(filters trim_to trim ltrim rtrim decode_html
                    decode_xml remove_html dirify sanitize
                    encode_html encode_xml encode_js encode_php
                    encode_url upper_case lower_case strip_linefeeds
                    space_pad zero_pad sprintf);
        my $el = 0; %order = map { $_ => ++$el } @order;
    }
    sub stock_post_process_handler {
        my($ctx, $args, $str, $arglist) = @_;
        my $filters = $ctx->{__filters};
        $arglist ||= [];
        if (@$arglist) {
            # In the event that $args was manipulated by handlers,
            # locate any new arguments and add them to $arglist for
            # processing
            my %arglist_keys = map { $_->[0] => $_->[1] } @$arglist;
            if (scalar keys %arglist_keys != scalar keys %$args) {
                my %more_args = %$args;
                for (keys %arglist_keys) {
                    delete $more_args{$_} if exists $more_args{$_};
                }
                if (%more_args) {
                    push @$arglist, [ $_ => $more_args{$_} ] foreach
                        grep { exists $filters->{$_} }
                        keys %more_args;
                }
            }
        } elsif (keys %$args && !@$arglist) {
            # in the event that we don't have arglist,
            # we'll build it using the hashref we do have
            # we might as well preserve the original ordering
            # of processing as well, since it's better than
            # the pseudo random order we get from retrieving the
            # keys from the hash.
            push @$arglist, [ $_, $args->{$_} ] foreach
                sort { exists $order{$a} && exists $order{$b} ? $order{$a} <=> $order{$b} : 0 }
                grep { exists $filters->{$_} }
                keys %$args;
        }
        for my $arg (@$arglist) {
            my ($name, $val) = @$arg;
            next unless exists $args->{$name};
            if (my $code = $filters->{$name}) {
                if (ref $code eq 'HASH') {
                    $code = $code->{code} ||= MT->handler_to_coderef($code->{handler});
                }
                $str = $code->($str, $val, $ctx);
            }
        }
        $str;
    }
}

sub post_process_handler {
    \&stock_post_process_handler;
}

sub slurp {
    my ($ctx, $args, $cond) = @_;
    my $tokens  = $ctx->stash('tokens');
    return '' unless $tokens;
    my $result = $ctx->stash('builder')->build($ctx, $tokens, $cond);
    return $ctx->error($ctx->stash('builder')->errstr)
        unless defined $result;
    return $result;
}

sub else {
    my ($ctx, $args, $cond) = @_;
    my $tokens = $ctx->stash('tokens_else');
    return '' unless $tokens;
    my $result = $ctx->stash('builder')->build($ctx, $tokens, $cond);
    return $ctx->error($ctx->stash('builder')->errstr)
        unless defined $result;
    return $result;
}

sub build {
    my ($ctx, $tmpl, $cond) = @_;
    my $builder = $ctx->stash('builder');
    my $tokens = $builder->compile($ctx, $tmpl)
        or return $ctx->error($builder->errstr);
    local $ctx->{stash}{tokens} = $tokens;
    my $result = $builder->build($ctx, $tokens, $cond);
    return $ctx->error($builder->errstr)
        unless defined $result;
    return $result;
}

sub set_blog_load_context {
    my ($ctx, $attr, $terms, $args, $col) = @_;
    my $blog_id = $ctx->stash('blog_id');
    $col ||= 'blog_id';

    # Grab specified blog IDs
    my $blog_ids = $attr->{blog_ids}
                || $attr->{include_blogs}
                || $attr->{exclude_blogs};

    if (defined($blog_ids) && ($blog_ids =~ m/-/)) {
        my @list = split /\s*,\s*/, $blog_ids;
        my @ids;
        foreach my $id (@list) {
            if ($id =~ m/^(\d+)-(\d+)$/) {
                push @ids, $_ for $1..$2;
            } else {
                push @ids, $id;
            }
        }
        $blog_ids = join ",", @ids;
    }

    # If no blog IDs specified, use the current blog
    if ( ! $blog_ids ) {
        $terms->{$col} = $blog_id if $col eq 'blog_id';
    } 
    # If exclude blogs, set the terms and the NOT arg for load
    # 'All' is not a valid value for exclude_blogs
    elsif ( $attr->{exclude_blogs} ) {
        return $ctx->error(MT->translate(
                "The attribute exclude_blogs cannot take 'all' for a value."
            )) if lc $args->{exclude_blogs} eq 'all';

        my @excluded_blogs = split /\s*,\s*/, $blog_ids;
        $terms->{$col} = [ @excluded_blogs ];
        $args->{not}{$col} = 1;
    # include_blogs="all" removes the blog_id/id constraint
    } elsif (lc $blog_ids eq 'all') {
        delete $terms->{$col} if exists $terms->{$col};
    # Blogs are specified in include_blogs so set the terms
    } else {
        my $blogs = { map { $_ => 1 } split /\s*,\s*/, $blog_ids };
        $terms->{$col} = [ keys %{$blogs} ];
    }
    1;
}

sub compile_category_filter {
    my ($ctx, $cat_expr, $cats, $param) = @_;

    $param ||= {};
    $cats ||= [];
    my $is_and = $param->{'and'} ? 1 : 0;
    my $children = $param->{'children'} ? 1 : 0;

    if ($cat_expr) {
        my @cols = $cat_expr =~ m!/! ? qw(category_label_path label) : qw(label);
        my %cats_used;
        foreach my $col (@cols) {
            my %cats_replaced;
            @$cats = sort {length($b->$col) <=> length($a->$col)} @$cats;

            foreach my $cat (@$cats) {
                next unless $cat;
                my $catl = $cat->$col;
                my $catid = $cat->id;
                my @cats = ($cat);
                my $repl;
                if ($children) {
                    my @kids = ($cat);
                    while (my $c = shift @kids) {
                        push @cats, $c;
                        push @kids, ($c->children_categories);
                    }
                    $repl = '';
                    $repl .= '||' . '#'.$_->id for @cats;
                    $repl = '(' . substr($repl, 2) . ')';
                } else {
                    $repl = "#$catid";
                }
                if ($cat_expr =~ s/(?<![#\d])(?:\Q$catl\E)/$repl/g) {
                    $cats_used{$_->id} = $_ for @cats;
                }
                # for multi blog case
                if ($cats_replaced{$catl}) {
                    my $last_catid = $cats_replaced{$catl};
                    $cat_expr =~ s/(#$last_catid\b)/($1 OR #$catid)/g;
                    $cats_used{$catid} = $cat;
                }
                $cats_replaced{$catl} = $catid;
            }
        }
        @$cats = values %cats_used;

        $cat_expr =~ s/\bAND\b/&&/gi;
        $cat_expr =~ s/\bOR\b/||/gi;
        $cat_expr =~ s/\bNOT\b/!/gi;
        # replace any other 'thing' with '(0)' since it's a
        # category that doesn't even exist.
        $cat_expr =~ s/( |#\d+|&&|\|\||!|\(|\))|([^#0-9&|!()]+)/$2?'(0)':$1/ge;

        # strip out all the 'ok' stuff. if anything is left, we have
        # some invalid data in our expression:
        my $test_expr = $cat_expr;
        $test_expr =~ s/!|&&|\|\||\(0\)|\(|\)|\s|#\d+//g;
        return undef if $test_expr;
    } else {
        my %cats_used;
        $cat_expr = '';
        foreach my $cat (@$cats) {
            my $id = $cat->id;
            $cat_expr .= ($is_and ? '&&' : '||') if $cat_expr ne '';
            if ($children) {
                my @kids = ($cat);
                my @cats;
                while (my $c = shift @kids) {
                    push @cats, $c;
                    push @kids, ($c->children_categories);
                }
                my $repl = '';
                $repl .= '||' . '#'.$_->id for @cats;
                $cats_used{$_->id} = $_ for @cats;
                $repl = '(' . substr($repl, 2) . ')';
                $cat_expr .= $repl;
            } else {
                $cats_used{$cat->id} = $cat;
                $cat_expr .= "#$id";
            }
        }
        @$cats = values %cats_used;
    }

    $cat_expr =~ s/#(\d+)/(exists \$p->{\$e}{$1})/g;
    my $expr = 'sub{my($e,$p)=@_;'.$cat_expr.';}';
    my $cexpr = eval($expr);
    $@ ? undef : $cexpr;
}

sub compile_tag_filter {
    my ($ctx, $tag_expr, $tags) = @_;

    # Sort in descending order by length
    @$tags = sort {length($b->name) <=> length($a->name)} @$tags;

    # Modify the tag argument, replacing the tag name with '#TagID'
    # Create a ID-based hash of the tags that are used in the arg
    my %tags_used;
    foreach my $tag (@$tags) {
        my $name = $tag->name;
        my $id = $tag->id;
        if ($tag_expr =~ s/(?<![#\d])\Q$name\E/#$id/g) {
            $tags_used{$id} = $tag;
        }
    }
    # Populate array ref (passed in by reference) of used tags
    @$tags = values %tags_used;

    # Replace logical constructs with their perl equivalents
    $tag_expr =~ s/\bAND\b/&&/gi;
    $tag_expr =~ s/\bOR\b/||/gi;
    $tag_expr =~ s/\bNOT\b/!/gi;

    # If any foreign/unrecognized sequences appear in our
    # expression (such as a non-extistent tag name),
    # replace that with '(0)' which will evaluate to false.
    $tag_expr =~ s/
        (
            [ ]  | # space
            #\d+ | # #123
            &&   | # literal &&
            \|\| | # literal ||
            !    | # literal !
            \(   | # literal (
            \)     # literal )
        )  |
        (
            [^#0-9&|!()]+  # some unknown set of characters
        )
    / $2 ? '(0)' : $1 /gex;

    # Syntax check on 'tag' argument
    # Strip out all the valid stuff. if anything is left, we have
    # some invalid data in our expression:
    my $test_expr = $tag_expr;
    $test_expr =~ s/!|&&|\|\||\(0\)|\(|\)|\s|#\d+//g;
    return undef if ($test_expr);

    # Replace '#TagID' with a hash lookup function.
    # Function confirms/denies use of tag on entry (by IDs)
    # Translation: exists( PlacementHashRef->{EntryID}{TagID} )
    $tag_expr =~ s/#(\d+)/(exists \$p->{$1})/g;

    # Create an anonymous subroutine of that lookup function
    # and return it if all is well.  This code ref will be used
    # later to test for existence of specified tags in entries.
    my $expr = 'sub{my($p)=@_;' . $tag_expr . '}';
    my $cexpr = eval $expr;
    $@ ? undef : $cexpr;
}

sub compile_role_filter {
    my ($ctx, $role_expr, $roles) = @_;

    my %roles_used;
    foreach my $role (@$roles) {
        my $name = $role->name;
        my $id = $role->id;
        if ($role_expr =~ s/(?<![#\d])\Q$name\E/#$id/g) {
            $roles_used{$id} = $role;
        }
    }
    @$roles = values %roles_used;

    $role_expr =~ s/\bOR\b/||/gi;
    $role_expr =~ s/\bAND\b/&&/gi;
    $role_expr =~ s/\bNOT\b/!/gi;
    $role_expr =~ s/( |#\d+|&&|\|\||!|\(|\))|([^#0-9&|!()]+)/$2?'(0)':$1/ge;

    my $test_expr = $role_expr;
    $test_expr =~ s/!|&&|\|\||\(0\)|\(|\)|\s|#\d+//g;
    return undef if $test_expr;

    $role_expr =~ s/#(\d+)/(exists \$p->{\$e}{$1})/g;
    my $expr = 'sub{my($e,$p)=@_;'.$role_expr.';}';
    my $cexpr = eval $expr;
    $@ ? undef : $cexpr;
}

sub compile_status_filter {
    my ($ctx, $status_expr, $status) = @_;

    foreach my $s (@$status) {
        my $name = $s->{name};
        my $id = $s->{id};
        $status_expr =~ s/(?<![#\d])\Q$name\E/#$id/g;
    }

    $status_expr =~ s/\bOR\b/||/gi;
    $status_expr =~ s/( |#\d+|&&|\|\||!|\(|\))|([^#0-9&|!()]+)/$2?'(0)':$1/ge;

    my $test_expr = $status_expr;
    $test_expr =~ s/!|&&|\|\||\(0\)|\(|\)|\s|#\d+//g;
    return undef if $test_expr;

    $status_expr =~ s/#(\d+)/(\$_[0]->status == $1)/g;
    my $expr = 'sub{'.$status_expr.';}';
    my $cexpr = eval $expr;
    $@ ? undef : $cexpr;
}

sub _no_author_error {
    my ($ctx) = @_;
    my $tag_name = $ctx->stash('tag');
    return $ctx->error(MT->translate(
        "You used an '[_1]' tag outside of the context of a author; " .
        "perhaps you mistakenly placed it outside of an 'MTAuthors' " .
        "container?", $tag_name
    ));
}

sub _no_entry_error {
    my ($ctx) = @_;
    my $tag_name = $ctx->stash('tag');
    $tag_name = 'mt' . $tag_name unless $tag_name =~ m/^MT/i;
    return $_[0]->error(MT->translate(
        "You used an '[_1]' tag outside of the context of an entry; " .
        "perhaps you mistakenly placed it outside of an 'MTEntries' container?", $tag_name
    ));
}

sub _no_comment_error {
    my ($ctx) = @_;
    my $tag_name = $ctx->stash('tag');
    $tag_name = 'mt' . $tag_name unless $tag_name =~ m/^MT/i;
    return $ctx->error(MT->translate(
        "You used an '[_1]' tag outside of the context of a comment; " .
        "perhaps you mistakenly placed it outside of an 'MTComments' " .
        "container?", $tag_name
    ));
}

sub _no_ping_error {
    my ($ctx) = @_;
    my $tag_name = $ctx->stash('tag');
    $tag_name = 'mt' . $tag_name unless $tag_name =~ m/^MT/i;
    return $ctx->error(MT->translate(
        "You used an '[_1]' tag outside of the context of " .
        "a ping; perhaps you mistakenly placed it outside " .
        "of an 'MTPings' container?", $tag_name
    ));
}

sub _no_asset_error {
    my ($ctx) = @_;
    my $tag_name = $ctx->stash('tag');
    $tag_name = 'mt' . $tag_name unless $tag_name =~ m/^MT/i;
    return $ctx->error(MT->translate(
        "You used an '[_1]' tag outside of the context of an asset; " .
        "perhaps you mistakenly placed it outside of an 'MTAssets' container?", $tag_name
    ));

}

sub _no_page_error {
    my ($ctx) = @_;
    my $tag_name = $ctx->stash('tag');
    $tag_name = 'mt' . $tag_name unless $tag_name =~ m/^MT/i;
    return $ctx->error(MT->translate(
        "You used an '[_1]' tag outside of the context of an page; " .
        "perhaps you mistakenly placed it outside of an 'MTPages' container?",
        $tag_name
    ));
}

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
