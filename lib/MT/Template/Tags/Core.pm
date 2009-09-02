# Movable Type (r) Open Source (C) 2001-2009 Six Apart Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: Core.pm 107384 2009-07-22 03:11:39Z fyoshimatsu $
package MT::Template::Tags::Core;
use strict;

sub _math_operation {
    my ($ctx, $op, $lvalue, $rvalue) = @_;
    return $lvalue
        unless ( $lvalue =~ m/^\-?[\d\.]+$/ )
            && ( ( defined($rvalue) && ( $rvalue =~ m/^\-?[\d\.]+$/ ) )
              || ( ( $op eq 'inc' ) || ( $op eq 'dec' ) || ( $op eq '++' ) || ( $op eq '--' ) )
            );
    if ( ( '+' eq $op ) || ( 'add' eq $op ) ) {
        return $lvalue + $rvalue;
    }
    elsif ( ( '++' eq $op ) || ( 'inc' eq $op ) ) {
        return $lvalue + 1;
    }
    elsif ( ( '-' eq $op ) || ( 'sub' eq $op ) ) {
        return $lvalue - $rvalue;
    }
    elsif ( ( '--' eq $op ) || ( 'dec' eq $op ) ) {
        return $lvalue - 1;
    }
    elsif ( ( '*' eq $op ) || ( 'mul' eq $op ) ) {
        return $lvalue * $rvalue;
    }
    elsif ( ( '/' eq $op ) || ( 'div' eq $op ) ) {
        return $ctx->error( MT->translate('Division by zero.') )
            if $rvalue == 0;
        return $lvalue / $rvalue;
    }
    elsif ( ( '%' eq $op ) || ( 'mod' eq $op ) ) {
        # Perl % is integer only
        $lvalue = int($lvalue);
        $rvalue = int($rvalue);
        return $ctx->error( MT->translate('Division by zero.') )
            if $rvalue == 0;
        return $lvalue % $rvalue;
    }
    return $lvalue;
}

###########################################################################

=head2 If

A conditional block that is evaluated if the attributes/modifiers evaluate
true. This tag can be used in combination with the L<ElseIf> and L<Else>
tags to test for a variety of cases.

B<Attributes:>

=over 4

=item * name

=item * var

Declares a variable to test. When none of the comparison attributes are
present ("eq", "ne", "lt", etc.) the If tag tests if the variable has
a "true" value, meaning if it is assigned a non-empty, non-zero value.

=item * tag

Declares a MT tag to execute; the value of which is used for testing.
When none of the comparison attributes are present ("eq", "ne", "lt", etc.)
the If tag tests if the specified tag produces a "true" value, meaning if
it produces a non-empty, non-zero value. For MT conditional tags, the
If tag passes through the logical result of that conditional tag.

=item * op

If specified, applies the specified mathematical operator to the value
being tested. 'op' may be one of the following (those that require a
second value use the 'value' attribute):

=over 4

=item * + or add

Addition.

=item * - or sub

Subtraction.

=item * ++ or inc

Adds 1 to the given value.

=item * -- or dec

Subtracts 1 from the given value.

=item * * or mul

Multiplication.

=item * / or div

Division.

=item * % or mod

Issues a modulus operator.

=back

=item * value

Used in conjunction with the 'op' attribute.

=item * eq

Tests whether the given value is equal to the value of the 'eq' attribute.

=item * ne

Tests whether the given value is not equal to the value of the 'ne' attribute.

=item * gt

Tests whether the given value is greater than the value of the 'gt' attribute.

=item * lt

Tests whether the given value is less than the value of the 'lt' attribute.

=item * ge

Tests whether the given value is greater than or equal to the value of the
'ge' attribute.

=item * le

Tests whether the given value is less than or equal to the value of the
'le' attribute.

=item * like

Tests whether the given value matches the regex pattern in the 'like'
attribute.

=item * test

Uses a Perl (or PHP under Dynamic Publishing) expression. For Perl, this
requires the "Safe" Perl module to be installed.

=back

B<Examples:>

If variable "foo" has a non-zero value:

    <mt:SetVar name="foo" value="bar">
    <mt:If name="foo">
        <!-- do something -->
    </mt:If>

If variable "foo" has a value equal to "bar":

    <mt:SetVar name="foo" value="bar">
    <mt:If name="foo" eq="bar">
        <!-- do something -->
    </mt:If>

If variable "foo" has a value that starts with "bar" or "baz":

    <mt:SetVar name="foo" value="barcamp" />
    <mt:If name="foo" like="^(bar|baz)">
        <!-- do something -->
    </mt:If>

If tag <$mt:EntryTitle$> has a value of "hello world":

    <mt:If tag="EntryTitle" eq="hello world">
        <!-- do something -->
    </mt:If>

If tag <$mt:CategoryCount$> is greater than 10 add "(Popular)" after
Category Label:

    <mt:Categories>
        <$mt:CategoryLabel$>
        <mt:If tag="CategoryCount" gt="10">(Popular)</mt:If>
    </mt:Categories>


If tag <$mt:EntryAuthor$> is "Melody" or "melody" and last name is "Nelson"
or "nelson" then do something:

    <mt:Authors>
        <mt:If tag="EntryAuthor" like="/(M|m)elody (N|n)elson/"
            <!-- do something -->
        </mt:If>
    </mt:Authors>

If the <$mt:CommenterEmail$> matches foo@domain.com or bar@domain.com:

    <mt:If tag="CommenterEmail" like="(foo@domain.com|bar@domain.com)">
        <!-- do something -->
    </mt:If>

If the <$mt:CommenterUsername$> matches the username of someone on the
Movable Type team:

    <mt:If tag="CommenterUsername" like="(beau|byrne|brad|jim|mark|fumiaki|yuji|djchall)">
        <!-- do something -->
    </mt:If>

If <$mt:EntryCategory$> is "Comic" then use the Comic template module
otherwise use the default:

    <mt:If tag="EntryCategory" eq="Comic">
        <$mt:Include module="Comic Entry Detail"$>
    <mt:Else>
        <$mt:Include module="Entry Detail"$>
    </mt:If>

If <$mt:EntryCategory$> is "Comic", "Sports", or "News" then link to the
category archive:

    <mt:If tag="EntryCategory" like="(Comic|Sports|News)">
        <a href="<$mt:CategoryArchiveLink$>"><$mt:CategoryLabel$></a>
    <mt:Else>
        <$mt:CategoryLabel$>
    </mt:If>

List all categories and link to categories it the category has one or more
entries:

    <mt:Categories show_empty="1">
        <mt:If name="__first__">
    <ul>
        </mt:If>
        <mt:If tag="CategoryCount" gte="1">
        <li><a href="<$MTCategoryArchiveLink$>"><$MTCategoryLabel$></a></li>
        <mt:Else>
        <li><$MTCategoryLabel$></li>
        </mt:If>
        <mt:If name="__last__">
    </ul>
        </mt:If>
    </mt:Categories>

Test a variable using Perl:

    <mt:If test="length($some_variable) > 10">
        '<$mt:Var name="some_variable"$>' is 11 characters or longer
    </mt:If>

=for tags templating

=cut

sub _hdlr_if {
    my ($ctx, $args, $cond) = @_;
    my $var = $args->{name} || $args->{var};
    my $value;
    if (defined $var) {
        # pick off any {...} or [...] from the name.
        my ($index, $key);
        if ($var =~ m/^(.+)([\[\{])(.+)[\]\}]$/) {
            $var = $1;
            my $br = $2;
            my $ref = $3;
            if ($ref =~ m/^\$(.+)/) {
                $ref = $ctx->var($1);
            }
            $br eq '[' ? $index = $ref : $key = $ref;
        } else {
            $index = $args->{index} if exists $args->{index};
            $key = $args->{key} if exists $args->{key};
        }

        $value = $ctx->var($var);
        if (ref($value)) {
            if (UNIVERSAL::isa($value, 'MT::Template')) {
                local $value->{context} = $ctx;
                $value = $value->output();
            } elsif (UNIVERSAL::isa($value, 'MT::Template::Tokens')) {
                local $ctx->{__stash}{tokens} = $value;
                $value = $ctx->slurp($args, $cond) or return;
            } elsif (ref($value) eq 'ARRAY') {
                $value = $value->[$index] if defined $index;
            } elsif (ref($value) eq 'HASH') {
                $value = $value->{$key} if defined $key;
            }
        }
    }
    elsif (defined(my $tag = $args->{tag})) {
        $tag =~ s/^MT:?//i;
        $value = $ctx->tag( $tag, $args, $cond );
    }

    $ctx->{__stash}{vars}{__cond_value__} = $value;
    $ctx->{__stash}{vars}{__cond_name__} = $var;

    if ( my $op = $args->{op} ) {
        my $rvalue = $args->{'value'};
        if ( $op && (defined $value) && !ref($value) ) {
            $value = _math_operation($ctx, $op, $value, $rvalue);
        }
    }

    my $numeric = qr/^[-]?\d+(\.\d+)?$/;
    no warnings;
    if (exists $args->{eq}) {
        return 0 unless defined($value);
        my $eq = $args->{eq};
        if ($value =~ m/$numeric/ && $eq =~ m/$numeric/) {
            return $value == $eq;
        } else {
            return $value eq $eq;
        }
    }
    elsif (exists $args->{ne}) {
        return 0 unless defined($value);
        my $ne = $args->{ne};
        if ($value =~ m/$numeric/ && $ne =~ m/$numeric/) {
            return $value != $ne;
        } else {
            return $value ne $ne;
        }
    }
    elsif (exists $args->{gt}) {
        return 0 unless defined($value);
        my $gt = $args->{gt};
        if ($value =~ m/$numeric/ && $gt =~ m/$numeric/) {
            return $value > $gt;
        } else {
            return $value gt $gt;
        }
    }
    elsif (exists $args->{lt}) {
        return 0 unless defined($value);
        my $lt = $args->{lt};
        if ($value =~ m/$numeric/ && $lt =~ m/$numeric/) {
            return $value < $lt;
        } else {
            return $value lt $lt;
        }
    }
    elsif (exists $args->{ge}) {
        return 0 unless defined($value);
        my $ge = $args->{ge};
        if ($value =~ m/$numeric/ && $ge =~ m/$numeric/) {
            return $value >= $ge;
        } else {
            return $value ge $ge;
        }
    }
    elsif (exists $args->{le}) {
        return 0 unless defined($value);
        my $le = $args->{le};
        if ($value =~ m/$numeric/ && $le =~ m/$numeric/) {
            return $value <= $le;
        } else {
            return $value le $le;
        }
    }
    elsif (exists $args->{like}) {
        my $like = $args->{like};
        if (!ref $like) {
            if ($like =~ m!^/.+/([si]+)?$!s) {
                my $opt = $1;
                $like =~ s!^/|/([si]+)?$!!g; # /abc/ => abc
                $like = "(?$opt)" . $like if defined $opt;
            }
            my $re = eval { qr/$like/ };
            return 0 unless $re;
            $args->{like} = $like = $re;
        }
        return defined($value) && ($value =~ m/$like/) ? 1 : 0;
    }
    elsif (exists $args->{test}) {
        my $expr = $args->{'test'};
        my $safe = $ctx->{__safe_compartment};
        if (!$safe) {
            $safe = eval { require Safe; new Safe; }
                or return $ctx->error("Cannot evaluate expression [$expr]: Perl 'Safe' module is required.");
            $ctx->{__safe_compartment} = $safe;
        }
        my $vars = $ctx->{__stash}{vars};
        my $ns = $safe->root;
        {
            no strict 'refs';
            foreach my $v (keys %$vars) {
                # or should we be using $ctx->var here ?
                # can we limit this step to just the variables
                # mentioned in $expr ??
                ${ $ns . '::' . $v } = $vars->{$v};
            }
        }
        my $res = $safe->reval($expr);
        if ($@) {
            return $ctx->error("Error in expression [$expr]: $@");
        }
        return $res;
    }
    if ((defined $value) && $value) {
        if (ref($value) eq 'ARRAY') {
            return @$value ? 1 : 0;
        }
        return 1;
    }
    return 0;
}

###########################################################################

=head2 Unless

A conditional tag that is the logical opposite of the L<If> tag. All
attributes supported by the L<If> tag are also supported for this tag.

=for tags templating

=cut

sub _hdlr_unless {
    defined(my $r = &_hdlr_if) or return;
    !$r;
}

###########################################################################

=head2 Else

A container tag used within If and Unless blocks to output the alternate
case.

This tag supports all of the attributes and logical operators available in
the L<If> tag and can be used multiple times to test for different
scenarios.

B<Example:>

    <mt:If name="some_variable">
        'some_variable' is assigned
    <mt:Else name="some_other_variable">
        'some_other_variable' is assigned
    <mt:Else>
        'some_variable' nor 'some_other_variable' is assigned
    </mt:If>

=for tags templating

=cut

sub _hdlr_else {
    my ($ctx, $args, $cond) = @_;
    local $args->{'@'};
    delete $args->{'@'};
    if  ((keys %$args) >= 1) {
        unless ($args->{name} || $args->{var} || $args->{tag}) {
            if ( my $t = $ctx->var('__cond_tag__') ) {
                $args->{tag} = $t;
            }
            elsif ( my $n = $ctx->var('__cond_name__') ) {
                $args->{name} = $n;
            }
        }
    }
    if (%$args) {
        defined(my $res = _hdlr_if(@_)) or return;
        return $res ? $ctx->slurp(@_) : $ctx->else();
    }
    return $ctx->slurp(@_);
}

###########################################################################

=head2 ElseIf

An alias for the 'Else' tag.

=for tags templating

=cut

sub _hdlr_elseif {
    my ($ctx, $args, $cond) = @_;
    unless ($args->{name} || $args->{var} || $args->{tag}) {
        if ( my $t = $ctx->var('__cond_tag__') ) {
            $args->{tag} = $t;
        }
        elsif ( my $n = $ctx->var('__cond_name__') ) {
            $args->{name} = $n;
        }
    }
    return _hdlr_else($ctx, $args, $cond);
}

###########################################################################

=head2 IfNonEmpty

A conditional tag used to test whether a template variable or tag are
non-empty. This tag is considered deprecated, in favor of the L<If> tag.

B<Attributes:>

=over 4

=item * tag

A tag which is evaluated and tested for non-emptiness.

=item * name or var

A variable whose contents are tested for non-emptiness.

=back

=for tags deprecated

=cut

sub _hdlr_if_nonempty {
    my ($ctx, $args, $cond) = @_;
    my $value;
    if (exists $args->{tag}) {
        $args->{tag} =~ s/^MT:?//i;
        $value = $ctx->tag($args->{tag}, $args, $cond);
    } elsif (exists $args->{name}) {
        $value = $ctx->var($args->{name});
    } elsif (exists $args->{var}) {
        $value = $ctx->var($args->{var});
    }
    if (defined($value) && $value ne '') { # want to include "0" here
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfNonZero

A conditional tag used to test whether a template variable or tag are
non-zero. This tag is considered deprecated, in favor of the L<If> tag.

B<Attributes:>

=over 4

=item * tag

A tag which is evaluated and tested for non-zeroness.

=item * name or var

A variable whose contents are tested for non-zeroness.

=back

=for tags deprecated

=cut

sub _hdlr_if_nonzero {
    my ($ctx, $args, $cond) = @_;
    my $value;
    if (exists $args->{tag}) {
        $args->{tag} =~ s/^MT:?//i;
        $value = $ctx->tag($args->{tag}, $args, $cond);
    } elsif (exists $args->{name}) {
        $value = $ctx->var($args->{name});
    } elsif (exists $args->{var}) {
        $value = $ctx->var($args->{var});
    }
    if (defined($value) && $value) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 Loop

This tag is primarily used for MT application templates, for processing
a Perl array of hashref data. This tag's heritage comes from the
CPAN HTML::Template module and it's C<TMPL_LOOP> tag and offers similar
capabilities. This tag can also handle a hashref variable, which
causes it to loop over all keys in the hash.

B<Attributes:>

=over 4

=item * name

=item * var

The template variable that contains the array of hashref data to
process.

=item * sort_by (optional)

Causes the data in the given array to be resorted in the manner
specified. The 'sort_by' attribute may specify "key" or "value"
and may additionally include the keywords "numeric" (to imply
a numeric sort instead of the default alphabetic sort) and/or
"reverse" to force the sort to be done in reverse order.

B<Example:>

    sort_by="key reverse"; sort_by="value numeric"

=item * glue (optional)

If specified, this string will be placed inbetween each "row"
of data produced by the loop tag.

=back

Within the tag, the following variables are assigned and may
be used:

=over 4

=item * __first__

Assigned when the loop is in the first iteration.

=item * __last__

Assigned when the loop is in the last iteration.

=item * __odd__

Assigned 1 when the loop is on odd numbered rows, 0 when even.

=item * __even__

Assigned 1 when the loop is on even numbered rows, 0 when odd.

=item * __key__

When looping over a hashref template variable, this variable is
assigned the key currently in context.

=item * __value__

This variable holds the value of the array or hashref element
currently in context.

=back

=for tags loop, templating

=cut

sub _hdlr_loop {
    my ($ctx, $args, $cond) = @_;
    my $name = $args->{name} || $args->{var};
    my $var = $ctx->var($name);
    return '' unless $var
      && ( (ref($var) eq 'ARRAY') && (scalar @$var) )
        || ( (ref($var) eq 'HASH') && (scalar(keys %$var)) );

    my $hash_var;
    if ( 'HASH' eq ref($var) ) {
        $hash_var = $var;
        my @keys = keys %$var;
        $var = \@keys;
    }
    if (my $sort = $args->{sort_by}) {
        $sort = lc $sort;
        if ($sort =~ m/\bkey\b/) {
            @$var = sort {$a cmp $b} @$var;
        } elsif ($sort =~ m/\bvalue\b/) {
            no warnings;
            if ($sort =~ m/\bnumeric\b/) {
                no warnings;
                if (defined $hash_var) {
                    @$var = sort {$hash_var->{$a} <=> $hash_var->{$b}} @$var;
                } else {
                    @$var = sort {$a <=> $b} @$var;
                }
            } else {
                if (defined $hash_var) {
                    @$var = sort {$hash_var->{$a} cmp $hash_var->{$b}} @$var;
                } else {
                    @$var = sort {$a cmp $b} @$var;
                }
            }
        }
        if ($sort =~ m/\breverse\b/) {
            @$var = reverse @$var;
        }
    }

    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $out = '';
    my $i = 1;
    my $vars = $ctx->{__stash}{vars} ||= {};
    my $glue = $args->{glue};
    foreach my $item (@$var) {
        local $vars->{__first__} = $i == 1;
        local $vars->{__last__} = $i == scalar @$var;
        local $vars->{__odd__} = ($i % 2 ) == 1;
        local $vars->{__even__} = ($i % 2 ) == 0;
        local $vars->{__counter__} = $i;
        my @names;
        if (UNIVERSAL::isa($item, 'MT::Object')) {
            @names = @{ $item->column_names };
        } else {
            if (ref($item) eq 'HASH') {
                @names = keys %$item;
            } elsif ( $hash_var ) {
                @names = ( '__key__', '__value__' );
            } else {
                @names = '__value__';
            }
        }
        my @var_names;
        push @var_names, lc $_ for @names;
        local @{$vars}{@var_names};
        if (UNIVERSAL::isa($item, 'MT::Object')) {
            $vars->{lc($_)} = $item->column($_) for @names;
        } elsif (ref($item) eq 'HASH') {
            $vars->{lc($_)} = $item->{$_} for @names;
        } elsif ( $hash_var ) {
            $vars->{'__key__'} = $item;
            $vars->{'__value__'} = $hash_var->{$item};
        } else {
            $vars->{'__value__'} = $item;
        }
        my $res = $builder->build($ctx, $tokens, $cond);
        return $ctx->error($builder->errstr) unless defined $res;
        if ($res ne '') {
            $out .= $glue if defined $glue && $i > 1 && length($out) && length($res);
            $out .= $res;
            $i++;
        }
    }
    return $out;
}

###########################################################################

=head2 For

Many programming languages support the notion of a "for" loop. In the most
simple use case one could give, a for loop is a way to repeatedly execute a
piece of code n times.

Technically a for loop advances through a sequence (e.g. all odd numbers, all
even numbers, every nth number, etc), giving the programmer greater control
over the seed value (or "index") of each iteration through the loop.

B<Attributes:>

=over 4

=item * var (optional)

If assigned, the current 'index' of the loop is assigned to this template
variable.

=item * from (optional; default "0")

=item * start

Identifies the starting number for the loop.

=item * to

=item * end

Identifies the ending number for the loop. Either 'to' or 'end' must
be specified.

=item * step (optional; default "1")

=item * increment

Provides the amount to increment the loop counter.

=item * glue (optional)

If specified, this string is added inbetween each block of the loop.

=back

Within the tag, the following variables are assigned:

=over 4

=item * __first__

Assigned 1 when the loop is in the first iteration.

=item * __last__

Assigned 1 when the loop is in the last iteration.

=item * __odd__

Assigned 1 when the loop index is odd, 0 when it is even.

=item * __even__

Assigned 1 when the loop index is even, 0 when it is odd.

=item * __index__

Holds the current loop index value, even if the 'var' attribute has
been given.

=item * __counter__

Tracks the number of times the loop has run (starts at 1).

=back

B<Example:>

    <mt:For from="2" to="10" step="2" glue=","><$mt:Var name="__index__"$></mt:For>

Produces:

    2,4,6,8,10

=for tags loop, templating

=cut

sub _hdlr_for {
    my ($ctx, $args, $cond) = @_;

    my $start = (exists $args->{from} ? $args->{from} : $args->{start}) || 0;
    $start = 0 unless $start =~ /^-?\d+$/;
    my $end = (exists $args->{to} ? $args->{to} : $args->{end}) || 0;
    return q() unless $end =~ /^-?\d+$/;
    my $incr = $args->{increment} || $args->{step} || 1;
    # FIXME: support negative "step" values
    $incr = 1 unless $incr =~ /^\d+$/;
    $incr = 1 unless $incr;

    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $cnt = 1;
    my $out = '';
    my $vars = $ctx->{__stash}{vars} ||= {};
    my $glue = $args->{glue};
    my $var = $args->{var};
    for (my $i = $start; $i <= $end; $i += $incr) {
        local $vars->{__first__} = $i == $start;
        local $vars->{__last__} = $i == $end;
        local $vars->{__odd__} = ($cnt % 2 ) == 1;
        local $vars->{__even__} = ($cnt % 2 ) == 0;
        local $vars->{__index__} = $i;
        local $vars->{__counter__} = $cnt;
        local $vars->{$var} = $i if defined $var;
        my $res = $builder->build($ctx, $tokens, $cond);
        return $ctx->error($builder->errstr) unless defined $res;
        $out .= $glue
            if defined $glue && $cnt > 1 && length($out) && length($res);
        $out .= $res;
        $cnt++;
    }
    return $out;
}

###########################################################################

=head2 SetVarBlock

A block tag used to set the value of a template variable. Note that
you can also use the global 'setvar' modifier to achieve the same result
as it can be applied to any MT tag.

B<Attributes:>

=over 4

=item * var or name (required)

Identifies the name of the template variable. See L<Var> for more
information on the format of this attribute.

=item * op (optional)

See the L<Var> tag for more information about this attribute.

=item * prepend (optional)

If specified, places the contents at the front of any existing value
for the template variable.

=item * append (optional)

If specified, places the contents at the end of any existing value
for the template variable.

=back

=for tags templating

=cut

###########################################################################

=head2 SetVarTemplate

Similar to the L<SetVarBlock> tag, but does not evaluate the contents
of the tag, but saves it for later evaluation, when the variable is
requested. This allows you to create inline template modules that you
can use over and over again.

B<Attributes:>

=over 4

=item * var or name (required)

Identifies the name of the template variable. See L<Var> for more
information on the format of this attribute.

=back

B<Example:>

    <mt:SetVarTemplate name="entry_title">
        <h1><$MTEntryTitle$></h1>
    </mt:SetVarTemplate>
    
    <mt:Entries>
        <$mt:Var name="entry_title"$>
    </mt:Entries>

=for tags templating

=cut

###########################################################################

=head2 SetVars

A block tag that is useful for assigning multiple template variables at
once.

B<Example:>

    <mt:SetVars>
    title=My Favorite Color
    color=Blue
    </mt:SetVars>

Then later:

    <h1><$mt:Var name="title"$></h1>

    <ul><li><$mt:Var name="color"$></li></ul>

=for tags templating

=cut

sub _hdlr_set_vars {
    my($ctx, $args) = @_;
    my $tag = lc $ctx->stash('tag');
    my $val = $ctx->slurp($args);
    $val =~ s/(^\s+|\s+$)//g;
    my @pairs = split /\r?\n/, $val;
    foreach my $line (@pairs) {
        next if $line =~ m/^\s*$/;
        my ($var, $value) = split /\s*=/, $line, 2;
        unless (defined($var) && defined($value)) {
            return $ctx->error("Invalid variable assignment: $line");
        }
        $var =~ s/^\s+//;
        $ctx->var($var, $value);
    }
    return '';
}

###########################################################################

=head2 SetHashVar

A block tag that is used for creating a hash template variable. A hash
is a variable that stores many values. You can even nest L<SetHashVar>
tags so you can store hashes inside hashes for more complex structures.

B<Example:>

    <mt:SetHashVar name="my_hash">
        <$mt:Var name="foo" value="bar"$>
        <$mt:Var name="fizzle" value="fozzle"$>
    </mt:SetHashVar>

Then later:

    foo is assigned: <$mt:Var name="my_hash{foo}"$>

=for tags templating

=cut

sub _hdlr_set_hashvar {
    my($ctx, $args) = @_;
    my $tag = lc $ctx->stash('tag');
    my $name = $args->{name} || $args->{var};
    if ($name =~ m/^\$/) {
        $name = $ctx->var($name);
    }
    return $ctx->error(MT->translate(
        "You used a [_1] tag without a valid name attribute.", "<MT$tag>" ))
        unless defined $name;

    my $hash = $ctx->var($name) || {};
    return $ctx->error(MT->translate( "[_1] is not a hash.", $name ))
        unless 'HASH' eq ref($hash);

    {
        local $ctx->{__inside_set_hashvar} = $hash;
        $ctx->slurp($args);
    }
    if ( my $parent_hash = $ctx->{__inside_set_hashvar} ) {
        $parent_hash->{$name} = $hash;
    }
    else {
        $ctx->var($name, $hash);
    }
    return q();
}

###########################################################################

=head2 SetVar

A function tag used to set the value of a template variable.

For simply setting variables you can use the L<Var> tag with a value attribute to assign template variables.

B<Attributes:>

=over 4

=item * var or name

Identifies the name of the template variable. See L<Var> for more
information on the format of this attribute.

=item * value

The value to assign to the variable.

=item * op (optional)

See the L<Var> tag for more information about this attribute.

=item * prepend (optional)

If specified, places the contents at the front of any existing value
for the template variable.

=item * append (optional)

If specified, places the contents at the end of any existing value
for the template variable.

=back

=for tags

=cut

sub _hdlr_set_var {
    my($ctx, $args) = @_;
    my $tag = lc $ctx->stash('tag');
    my $name = $args->{name} || $args->{var};

    return $ctx->error(MT->translate(
        "You used a [_1] tag without a valid name attribute.", "<MT$tag>" ))
        unless defined $name;

    my ($func, $key, $index, $value);
    if ($name =~ m/^(\w+)\((.+)\)$/) {
        $func = $1;
        $name = $2;
    } else {
        $func = $args->{function} if exists $args->{function};
    }

    # pick off any {...} or [...] from the name.
    if ($name =~ m/^(.+)([\[\{])(.+)[\]\}]$/) {
        $name = $1;
        my $br = $2;
        my $ref = $3;
        if ($ref =~ m/^\$(.+)/) {
            $ref = $ctx->var($1);
            $ref = chr(0) unless defined $ref;
        }
        $br eq '[' ? $index = $ref : $key = $ref;
    } else {
        $index = $args->{index} if exists $args->{index};
        $key = $args->{key} if exists $args->{key};
    }

    if ($name =~ m/^\$/) {
        $name = $ctx->var($name);
        return $ctx->error(MT->translate(
            "You used a [_1] tag without a valid name attribute.", "<MT$tag>" ))
            unless defined $name;
    }

    my $val = '';
    my $data = $ctx->var($name);
    if (($tag eq 'setvar') || ($tag eq 'var')) {
        $val = defined $args->{value} ? $args->{value} : '';
    } elsif ($tag eq 'setvarblock') {
        $val = $ctx->slurp($args);
        return unless defined($val);
    } elsif ($tag eq 'setvartemplate') {
        $val = $ctx->stash('tokens');
        return unless defined($val);
        $val = bless $val, 'MT::Template::Tokens';
    }

    my $existing = $ctx->var($name);
    $existing = '' unless defined $existing;
    if ( 'HASH' eq ref($existing) ) {
        $existing = $existing->{ $key };
    }
    elsif ( 'ARRAY' eq ref($existing) ) {
        $existing = ( defined $index && ( $index =~ /^-?\d+$/ ) )
          ? $existing->[ $index ] 
          : undef;
    }
    $existing = '' unless defined $existing;

    if ($args->{prepend}) {
        $val = $val . $existing;
    }
    elsif ($args->{append}) {
        $val = $existing . $val;
    }
    elsif ( $existing ne '' && ( my $op = $args->{op} ) ) {
        $val = _math_operation($ctx, $op, $existing, $val);
    }

    if ( defined $key ) {
        $data ||= {};
        return $ctx->error( MT->translate("'[_1]' is not a hash.", $name) )
            unless 'HASH' eq ref($data);

        if ( ( defined $func )
          && ( 'delete' eq lc( $func ) ) ) {
            delete $data->{ $key };
        }
        else {
            $data->{ $key } = $val;
        }
    }
    elsif ( defined $index ) {
        $data ||= [];
        return $ctx->error( MT->translate("'[_1]' is not an array.", $name) )
            unless 'ARRAY' eq ref($data);
        return $ctx->error( MT->translate("Invalid index.") )
            unless $index =~ /^-?\d+$/;
        $data->[ $index ] = $val;
    }
    elsif ( defined $func ) {
        if ( 'undef' eq lc( $func ) ) {
            $data = undef;
        }
        else {
            $data ||= [];
            return $ctx->error( MT->translate("'[_1]' is not an array.", $name) )
                unless 'ARRAY' eq ref($data);
            if ( 'push' eq lc( $func ) ) {
                push @$data, $val;
            }
            elsif ( 'unshift' eq lc( $func ) ) {
                $data ||= [];
                unshift @$data, $val;
            }
            else {
                return $ctx->error(
                    MT->translate("'[_1]' is not a valid function.", $func)
                );
            }
        }
    }
    else {
        $data = $val;
    }

    if ( my $hash = $ctx->{__inside_set_hashvar} ) {
        $hash->{$name} = $data;
    }
    else {
        $ctx->var($name, $data);
    }
    return '';
}

###########################################################################

=head2 GetVar

An alias for the 'Var' tag, and considered deprecated in favor of 'Var'.

=for tags deprecated

=cut

###########################################################################

=head2 Var

A B<function tag> used to store and later output data in a template.

B<Attributes:>

=over 4

=item * name (or var)

Identifies the template variable. The 'name' attribute supports a variety
of expressions. In order to not conflict with variable interpolation, 
the value of the name attribute should only contain uppercase letters,
lowercase letters, numbers and underscores. The typical case is a simple
variable name:

    <$mt:Var name="foo"$>

Template variables may be arrays, or hash variables, in which case you
may want to reference a specific element instead of the array or hash
itself.

This selects the second element from the 'foo' array template variable:

    <$mt:Var name="foo[1]"$>

This selects the 'bar' element from the 'foo' hash template variable:

    <$mt:Var name="foo{bar}"$>

Sometimes you want to obtain the value of a function that is applied
to a variable (see the 'function' attribute). This will obtain the
number of elements in the 'foo' array:

    <$mt:Var name="count(foo)"$>

Excluding the punctuation required in the examples above, the 'name'
attribute value should contain only alphanumeric characters and,
optionally, underscores.

=item * value

In the simplest case, this attribute triggers I<assignment> of the
specified value to the variable.

    <$mt:Var name="little_pig_count" value="3"$>          # Stores 3

However, if provided with the 'op' attribute (see below), the value becomes
the operand for the specified mathematical operation and no assignment takes
place.

The 'value' attribute can contain anything other than a double quote. If you
need to use a double quote or the value is very long, you may want to use
the L<SetVarBlock> tag or the L<setvar> global modifier instead.

=item * op

Used along with the 'value' attribute to perform a number of mathematical
operations on the value of the variable.  When used in this way, the stored
value of the variable doesn't change but instead gets transformed in the
process of being output.

    <$mt:Var name="little_pig_count">                     # Displays 3
    <$mt:Var name="little_pig_count" value="1" op="sub"$> # Displays 2
    <$mt:Var name="little_pig_count" value="2" op="sub"$> # Displays 1
    <$mt:Var name="little_pig_count" value="3" op="sub"$> # Displays 0

See the L<If> tag for the list of supported operators.

=item * prepend

When used in conjuction with the 'value' attribute to store a value, this
attribute acts as a flag (i.e. 'prepend="1"') to indicate that the new value
should be added to the front of any existing value instead of replacing it.

    <$mt:Var name="greeting" value="World"$>
    <$mt:Var name="greeting" value="Hello " prepend="1"$>
    <$mt:Var name="greeting"$>  # Displays: Hello World

=item * append

When used in conjuction with the 'value' attribute to store a value, this
attribute acts as a flag (i.e. 'append="1"') to indicate that the new value
should be added to the back of any existing value instead of replacing it.

    <$mt:Var name="greeting" value="Hello"$>
    <$mt:Var name="greeting" value=" World" append="1"$>
    <$mt:Var name="greeting"$>  # Displays: Hello World

=item * function

For array template variables, this attribute supports:

=over 4

=item * push

Adds the element to the end of the array (becomes the last element).

=item * pop

Removes an element from the end of the array (last element) and
outputs it.

=item * unshift

Adds the element to the front of the array (index 0).

=item * shift

Takes an element from the front of the array (index 0).

=item * count

Returns the number of elements in the array template variable.

=back

For hash template variables, this attribute supports:

=over 4

=item * delete

Only valid when used with the 'key' attribute, or if a key is present
in the variable name.

=item * count

Returns the number of keys present in the hash template variable.

=back

=item * index

Identifies an element of an array template variable.

=item * key

Identifies a value stored for the key of a hash template variable.

=item * default

If the variable is undefined or empty, this value will be output
instead. Use of the 'default' and 'setvar' attributes together make
for an excellent way to conditionally initialize variables. The
following sets the "max_pages" variable to 10 if and only if it does
not yet have a value.

    <mt:var name="max_pages" default="10" setvar="max_pages"> 

=item * to_json

Formats the variable in JSON notation.

=item * glue

For array template variables, this attribute is used in joining the
values of the array together.

=back

=for tags templating

=cut

sub _hdlr_get_var {
    my ($ctx, $args, $cond) = @_;
    if ( exists( $args->{value} )
      && !exists( $args->{op} ) ) {
        return &_hdlr_set_var(@_);
    }
    my $name = $args->{name} || $args->{var};
    return $ctx->error(MT->translate(
        "You used a [_1] tag without a valid name attribute.", "<MT" . $ctx->stash('tag') . ">" ))
        unless defined $name;

    my ($func, $key, $index, $value);
    if ($name =~ m/^(\w+)\((.+)\)$/) {
        $func = $1;
        $name = $2;
    } else {
        $func = $args->{function} if exists $args->{function};
    }

    # pick off any {...} or [...] from the name.
    if ($name =~ m/^(.+)([\[\{])(.+)[\]\}]$/) {
        $name = $1;
        my $br = $2;
        my $ref = $3;
        if ($ref =~ m/^\$(.+)/) {
            $ref = $ctx->var($1);
            $ref = chr(0) unless defined $ref;
        }
        $br eq '[' ? $index = $ref : $key = $ref;
    } else {
        $index = $args->{index} if exists $args->{index};
        $key = $args->{key} if exists $args->{key};
    }

    if ($name =~ m/^\$/) {
        $name = $ctx->var($name);
    }

    if (defined $name) {
        $value = $ctx->var($name);
        if (ref($value) eq 'CODE') { # handle coderefs
            $value = $value->(@_);
        }
        if (ref($value)) {
            if (UNIVERSAL::isa($value, 'MT::Template')) {
                local $args->{name} = undef;
                local $args->{var} = undef;
                local $value->{context} = $ctx;
                $value = $value->output($args);
            } elsif (UNIVERSAL::isa($value, 'MT::Template::Tokens')) {
                local $ctx->{__stash}{tokens} = $value;
                local $args->{name} = undef;
                local $args->{var} = undef;
                # Pass through SetVarTemplate arguments as variables
                # so that they do not affect the global stash
                my $vars = $ctx->{__stash}{vars} ||= {};
                my @names = keys %$args;
                my @var_names;
                push @var_names, lc $_ for @names;
                local @{$vars}{@var_names};
                $vars->{lc($_)} = $args->{$_} for @names;
                $value = $ctx->slurp($args) or return;
            } elsif (ref($value) eq 'ARRAY') {
                if ( defined $index ) {
                    if ($index =~ /^-?\d+$/) {
                        $value = $value->[ $index ];
                    } else {
                        $value = undef; # fall through to any 'default'
                    }
                }
                elsif ( defined $func ) {
                    $func = lc $func;
                    if ( 'pop' eq $func ) {
                        $value = @$value ? pop @$value : undef;
                    }
                    elsif ( 'shift' eq $func ) {
                        $value = @$value ? shift @$value : undef;
                    }
                    elsif ( 'count' eq $func ) {
                        $value = scalar @$value;
                    }
                    else {
                        return $ctx->error(
                            MT->translate("'[_1]' is not a valid function for an array.", $func)
                        );
                    }
                }
                else {
                    unless ($args->{to_json}) {
                        my $glue = exists $args->{glue} ? $args->{glue} : "";
                        $value = join $glue, @$value;
                    }
                }
            } elsif ( ref($value) eq 'HASH' ) {
                if ( defined $key ) {
                    if ( defined $func ) {
                        if ( 'delete' eq lc($func) ) {
                            $value = delete $value->{$key};
                        } else {
                            return $ctx->error(
                                MT->translate("'[_1]' is not a valid function for a hash.", $func)
                            );
                        }
                    } else {
                        if ($key ne chr(0)) {
                            $value = $value->{$key};
                        } else {
                            $value = undef;
                        }
                    }
                }
                elsif ( defined $func ) {
                    if ( 'count' eq lc($func) ) {
                        $value = scalar( keys %$value );
                    }
                    else {
                        return $ctx->error(
                            MT->translate("'[_1]' is not a valid function for a hash.", $func)
                        );
                    }
                }
            }
        }
        if ( my $op = $args->{op} ) {
            my $rvalue = $args->{'value'};
            if ( $op && (defined $value) && !ref($value) ) {
                $value = _math_operation($ctx, $op, $value, $rvalue);
            }
        }
    }
    if ((!defined $value) || ($value eq '')) {
        if (exists $args->{default}) {
            $value = $args->{default};
        }
    }

    if (ref($value) && $args->{to_json}) {
        return MT::Util::to_json($value);
    }
    return defined $value ? $value : "";
}

###########################################################################

=head2 Ignore

A block tag that always produces an empty string. This tag is useful
for wrapping template code you wish to disable, or perhaps annotating
sections of your template.

B<Example:>

    <mt:Ignore>
        The API key for the following tag is D3ADB33F.
    </mt:Ignore>

=for tags templating

=cut

###########################################################################

=head2 TemplateNote

A function tag that always returns an empty string. This tag is useful
for placing simple notes in your templates, since it produces nothing.

B<Example:>

    <$mt:TemplateNote note="Hi, mom!"$>

=for tags templating

=cut

1;
