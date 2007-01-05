# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Template::Context;
use strict;

use MT::ErrorHandler;
@MT::Template::Context::ISA = qw( MT::ErrorHandler );

use constant FALSE => -99999;
use Exporter;
*import = \&Exporter::import;
use vars qw( @EXPORT );
@EXPORT = qw( FALSE );
use MT::I18N qw( substr_text length_text );

use vars qw( %Global_handlers %Handlers %Global_filters %Filters );

sub add_tag {
    my $class = shift;
    my($name, $code) = @_;
    push @{$MT::Plugins{$MT::plugin_sig}{tags}}, "<\$MT${name}\$>"
        if $MT::plugin_sig;
    $Global_handlers{$name} = { code => $code, is_container => 0 };
}

sub add_container_tag {
    my $class = shift;
    my($name, $code) = @_;
    push @{$MT::Plugins{$MT::plugin_sig}{tags}}, "<MT${name}>"
        if $MT::plugin_sig;
    $Global_handlers{$name} = { code => $code, is_container => 1 };
}

sub add_conditional_tag {
    my $class = shift;
    my($name, $condition) = @_;
    push @{$MT::Plugins{$MT::plugin_sig}{tags}}, "<MT${name}>"
        if $MT::plugin_sig;
    $Global_handlers{$name} = { code => sub {
        $condition->(@_) ? _hdlr_pass_tokens(@_) : _hdlr_pass_tokens_else(@_);
    }, is_container => 1 };
}

sub add_global_filter {
    my $class = shift;
    my($name, $code) = @_;
    push @{$MT::Plugins{$MT::plugin_sig}{attributes}}, $name if $MT::plugin_sig;
    $Global_filters{$name} = $code;
}

sub new {
    my $class = shift;
    my $ctx = bless {}, $class;
    require MT::Template::ContextHandlers;
    $ctx->init(@_);
}

sub init {
    my $ctx = shift;
    if (!%Handlers) {
        $ctx->init_default_handlers;
        for my $tag (keys %Handlers) {
            next unless ref $Handlers{$tag} eq 'ARRAY';
            if (my $flag = $Handlers{$tag}[1]) {
                if ($flag == 2) { # conditional declaration
                    my $code = $Handlers{$tag}[0];
                    $Handlers{$tag} = [ sub {
                        $code->(@_) ? _hdlr_pass_tokens(@_) : _hdlr_pass_tokens_else(@_);
                    }, 1 ];
                }
            }
        }
        for my $tag (keys %Global_handlers) {
            my $arg;
            if ($Global_handlers{$tag}{is_container}) {
                $arg = [ $Global_handlers{$tag}{code}, 1 ];
            } else {
                $arg = $Global_handlers{$tag}{code};
            }
            $ctx->register_handler($tag => $arg);
        }
    }
    if (!%Filters) {
        $ctx->init_default_filters;
    }
    $ctx;
}

sub stash {
    my $ctx = shift;
    my $key = shift;
    $ctx->{__stash}->{$key} = shift if @_;
    if (ref $ctx->{__stash}->{$key} eq 'MT::Promise') {
        return MT::Promise::force($ctx->{__stash}->{$key});
    } else {
        return $ctx->{__stash}->{$key};
    }
}

sub register_handler { $Handlers{$_[1]} = $_[2] }
sub handler_for      {
    my $v = $Handlers{$_[1]};
    ref($v) eq 'ARRAY' ? @$v : $v
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
        $arglist ||= [];
        if (@$arglist) {
            # In the event that $args was manipulated by handlers,
            # locate any new arguments and add them to $arglist for
            # processing
            my %arglist_keys = map { @$_ } @$arglist;
            if (scalar keys %arglist_keys != scalar keys %$args) {
                my %more_args = %$args;
                for (keys %arglist_keys) {
                    delete $more_args{$_} if exists $more_args{$_};
                }
                if (%more_args) {
                    push @$arglist, [ $_ => $more_args{$_} ] foreach
                        grep { exists $Global_filters{$_} || exists $Filters{$_} }
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
                grep { exists $Global_filters{$_} || exists $Filters{$_} }
                keys %$args;
        }
        for my $arg (@$arglist) {
            my ($name, $val) = @$arg;
            next unless exists $args->{$name};
            if (my $code = $Global_filters{$name} || $Filters{$name}) {
                $str = $code->($str, $val, $ctx);
            }
        }
        $str;
    }
    sub post_process_handler {
        \&stock_post_process_handler;
    }
}

sub slurp {
    my ($ctx, $args, $cond) = @_;
    $ctx->stash('builder')->build($ctx, $ctx->stash('tokens'), $cond);
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
