# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Builder;

use strict;
use base qw( MT::ErrorHandler );
use MT::Template::Node;
use MT::Template::Handler;

my $compiler_version = 1.0;
my $compiler;
{
    local $@;
    eval { require MT::Builder::XS; };
    if ((not $@) and ($MT::Builder::XS::compiler_version >= $compiler_version)) {
        $compiler = \&MT::Builder::XS::compiler;
    }
    else {
        $compiler = \&compilerPP;
    }
}

sub new { bless {}, $_[0] }

sub compile {
    my $build = shift;
    my ( $ctx, $text ) = @_;
    my $tmpl;

    my $ids;
    my $classes;
    my $error = $build->{__state}{errors} = [];

    # handle $builder->compile($template) signature
    if ( UNIVERSAL::isa( $ctx, 'MT::Template' ) ) {
        $tmpl = $ctx;
        $ctx  = $tmpl->context;
        $text = $tmpl->text;
        $tmpl->reset_tokens();
        $ids     = $build->{__state}{ids}     = {};
        $classes = $build->{__state}{classes} = {};
        $build->{__state}{tmpl} = $tmpl;
    }
    else {
        $ids     = $build->{__state}{ids}     || {};
        $classes = $build->{__state}{classes} || {};
        $tmpl    = $build->{__state}{tmpl};
    }

    return [] unless defined $text;
    my $turn_utf8_back = 0;
    if (Encode::is_utf8($text) ) {
        Encode::_utf8_off($text);
        $turn_utf8_back = 1;
    }

    if ($text =~ m/<(?:MT_TRANS\b|MT_ACTION\b|(?:tmpl_(?:if|loop|unless|else|var|include)))/i)
    {
        MT::Builder::translate_html_tmpl($text);
    }

    my $handlers = $ctx->{__handlers};
    my $modifiers = $ctx->{__filters};

    my $tokens = $compiler->($handlers, $modifiers, $ids, $classes, $error, $text, $tmpl);

    Encode::_utf8_on($text) if $turn_utf8_back;

    if ( @$error ) {
        my ($error_pos, $msg, @params) = @$error; 
        my $pre_error = substr( $text, 0, $error_pos );
        my $line =()= $pre_error =~ m/\r?\n/g;
        $line++;
        my $error_tr = MT->translate($msg, @params);
        if ($tmpl) {
            $tmpl->errors( [ { message => $error_tr, line => $line, } ] );
            $error_tr = MT->translate(
                "Publish error in template '[_1]': [_2]",
                $tmpl->name || $tmpl->{__file},
                $error_tr);
        }
        $error_tr =~ s/#/$line/;
        return $build->error( $error_tr );
    }
    elsif ( defined $tmpl ) {
        # assign token and id references to template
        $tmpl->tokens( $tokens );
        $tmpl->token_ids( $ids );
        $tmpl->token_classes( $classes );
    }
    return $tokens;
}

sub translate_html_tmpl {
    $_[0] =~ s!<(/?)tmpl_(if|loop|unless|else|var|include)\b!<$1mt:$2!ig;
    $_[0] =~ s!<MT_TRANS\b!<__trans!ig;
    $_[0] =~ s!<MT_ACTION\b!<__action!ig;
}

sub compilerPP {
    my ($handlers, $modifiers, $ids, $classes, $error, $text, $tmpl) = @_;

    my $tokens = [];
    my @blocks;
    my $last_tag_ended = 0;
    my $space_eater = 0;

    while ($text =~ 
          m!(<
                (/?)\$?     # close tag
                [mM][tT]:?(\w[\w:]*)  # tag name
                ((?:\s+
                    [\w:]+\s*    # attr name
                    (?:=\s*
                        (?:
                            [^'"\$>\s]+   # bare attr value
                            |
                            (?:
                                (?:
                                    '(?:[^'<]*|<[^>]*>)*'
                                    |
                                    "(?:[^"<]*|<[^>]*>)*"
                                )
                                (?:,
                                    (?:'(?:[^'<]*|<[^>]*>)*'|"(?:[^"<]*|<[^>]*>)*")
                                )*
                            )
                        )
                    )?
                )*)
            \s*(-?)[\$/]?>)
        !gx) {
        my $whole_tag = $1;
        my $is_close = $2;
        my $tag_name = $3;
        my $args_atring = $4;
        my $next_space_eater = $5;
        my $lc_tag_name = lc($tag_name);
        my $tag_start = pos($text) - length($whole_tag);
        my $tag_end = pos($text);
        if ($tag_start > $last_tag_ended) {
            my $t_part = substr($text, $last_tag_ended, $tag_start-$last_tag_ended);
            $t_part =~ s/^\s+//s if $space_eater;
            if (length $t_part) {
                Encode::_utf8_on($t_part);
                my $t_rec = MT::Template::Node->new(
                    tag            => 'TEXT',
                    # the original version was buggy
                    parentNode     => undef, #(@blocks ? $blocks[-1] : $tmpl)
                    template       => $tmpl,
                    nodeValue      => $t_part,
                );
                push @{ @blocks ? ( $blocks[-1][0][2] ||= [] ) : $tokens }, $t_rec;
            }
        }
        $last_tag_ended = $tag_end;
        $space_eater = $next_space_eater ? 1 : 0;
        if ($is_close) {
            my $head;
            while (@blocks) {
                $head = pop @blocks;
                my $hrec = $head->[0];
                my $hstart = $head->[1];
                my $lc_head_name = lc($hrec->[0]);
                if ($lc_head_name eq $lc_tag_name) {
                    $hrec->[3] = substr($text, $hstart, $tag_start-$hstart);
                    Encode::_utf8_on($hrec->[3]);
                    last;
                }
                if (($lc_head_name eq 'else') or ($lc_head_name eq 'elseif')) {
                    $hrec->[3] = substr($text, $hstart, $tag_start-$hstart);
                    Encode::_utf8_on($hrec->[3]);
                    $head = undef;
                    next;
                }
                push @$error, $tag_start, "Found mismatched closing tag [_1] at line #", $lc_tag_name;
                return;
            }
            if (not $head) {
                push @$error, $tag_start, "Found mismatched closing tag [_1] at line #", $lc_tag_name;
                return;
            }
            next;
        }
        if (not exists $handlers->{$lc_tag_name}) {
            push @$error, $tag_start, "Undefined tag [_1] at line #", $lc_tag_name;
            return;
        }
        my $rec = MT::Template::Node->new(
            tag            => $tag_name,
            attributes     => \my %args,
            attribute_list => \my @args,
            parentNode     => (@blocks ? $blocks[-1][0] : $tmpl),
            template       => $tmpl,
        );
        while ($args_atring =~ m!
                    ([\w:]+)\s*    # attr name
                    (?:=\s*
                        (?:
                            ([^'"$>\s]+)   # bare attr value
                            |
                            (?:
                                (?:
                                    '((?:[^'<]*|<[^>]*>)*)'
                                    |
                                    "((?:[^"<]*|<[^>]*>)*)"
                                )
                                (,?)
                            )
                        )
                    )?!gx) { # "
            my $arg_name = $1;

            my ($arg_value) = grep defined($_), $2, $3, $4;
            if (not defined $arg_value) {
                Encode::_utf8_on($arg_name);
                $args{'name'} = $arg_name;
                next;
            }
            $arg_name = lc $arg_name;
            Encode::_utf8_on($arg_value);
            my $extra_args = $5;
            if ($extra_args) {
                $arg_value = [ $arg_value ];
                pos($args_atring) -= 1;
                my $args_pos = pos($args_atring);
                while ( $args_atring =~ m!\G,(?:'((?:[^'<]*|<[^>]*>)*)'|"((?:[^"<]*|<[^>]*>)*)")!g) {
                    my ($value) = grep defined($_), $1, $2;
                    Encode::_utf8_on($value);
                    push @$arg_value, $value;
                    $args_pos = pos($args_atring);
                }
                pos($args_atring) = $args_pos;
            }
            $args{$arg_name} = $arg_value;
            if ($arg_name eq "id") {
                $ids->{$arg_value} = $rec;
            }
            elsif ($arg_name eq "class") {
                push @{ $classes->{lc $arg_value} ||= [] }, $rec;
            }
            if (exists $modifiers->{$arg_name}) {
                push @args, [ $arg_name, $arg_value ];
            }
        }
        if (@blocks) {
            push @{ $blocks[-1][0][2] ||= [] }, $rec;
        }
        else {
            push @$tokens, $rec;
        }
        if ($lc_tag_name eq 'ignore') {
            my $depth = 1;
            while ($text =~ m!<(/?)mt:?ignore>!gi) {
                my $is_end = $1;
                $depth += ($is_end ? -1 : 1);
                last if $depth < 1;
            }
            if ($depth) {
                push @$error, $tag_start, "Tag [_1] left unclosed at line #", $lc_tag_name;
                return;
            }
            $last_tag_ended = pos($text);
            $rec->[2]=[]; $rec->[3]=''; # keeping compability with original version
            next;
        }
        if ($handlers->{$lc_tag_name}->[1]) {
            # is block tag
            push @blocks, [$rec, $tag_end];
        }
    }

    if (@blocks) {
        push @$error, $blocks[-1][1], "Tag [_1] left unclosed at line #", lc($blocks[-1][0][0]);
        return;
    }

    if ($last_tag_ended < length($text)) {
        my $t_part = substr($text, $last_tag_ended, length($text)-$last_tag_ended);
        $t_part =~ s/^\s+//s if $space_eater;
        if (length $t_part) {
            Encode::_utf8_on($t_part);
            push @$tokens, MT::Template::Node->new(
                tag            => 'TEXT',
                parentNode     => undef,
                template       => $tmpl,
                nodeValue      => $t_part,
            );
        }
    }

    return $tokens;
}

sub syntree2str {
    my ( $tokens, $depth ) = @_;
    my $string = '';
    foreach my $t (@$tokens) {
        my ( $name, $args, $tokens, $uncompiled )
            = ( $t->tag, $t->attributes, $t->childNodes, $t->nodeValue );
        $string .= ( " " x $depth ) . $name;
        if ( ref $args eq 'HASH' ) {
            $string .= join( ", ",
                ( map { " $_ => " . $args->{$_} } ( keys %$args ) ) );
        }

        $string .= "\n";
        $string .= syntree2str( $tokens, $depth + 2 );
    }
    return $string;
}

sub build {
    my $build = shift;
    my ( $ctx, $tokens, $cond ) = @_;

    my $timer;
    if ( $MT::DebugMode & 8 ) {
        $timer = MT->get_timer();
    }

    if ($cond) {
        my %lcond;

        # lowercase condtional keys since we're storing tags in lowercase now
        # When both the lowercase key and the CamelCase key exist,
        # the value will be overwrited in the CamelCase key's value.
        $lcond{ lc $_ } = $cond->{$_} for reverse sort keys %$cond;
        $cond = \%lcond;
    }
    else {
        $cond = {};
    }

    # Avoids circular reference between MT::Template::Context and MT::Builder.
    local $ctx->{__stash}{builder} = $build;
    my $res = '';
    my $ph  = $ctx->post_process_handler;

    for my $t (@$tokens) {
        if ( $t->tag eq 'TEXT' ) {
            $res .= $t->nodeValue;
        }
        else {
            my ( $tokens, $tokens_else, $uncompiled );
            my $tag = lc $t->tag;
            if ( $cond && ( exists $cond->{$tag} && !$cond->{$tag} ) ) {

                # if there's a cond for this tag and it's false,
                # walk the children and look for an MTElse.
                # the children of the MTElse will become $tokens
                for my $tok ( @{ $t->childNodes } ) {
                    my $tag = lc $tok->tag;
                    if ( $tag eq 'else' || $tag eq 'elseif' ) {
                        $tokens     = $tok->childNodes;
                        $uncompiled = $tok->nodeValue;
                        last;
                    }
                }
                next unless $tokens;
            }
            else {
                my $childNodes = $t->childNodes;
                if ( $childNodes && ref($childNodes) ) {

                    # either there is no cond for this tag, or it's true,
                    # so we want to partition the children into
                    # those which are inside an else and those which are not.
                    ( $tokens, $tokens_else ) = ( [], [] );
                    for my $sub (@$childNodes) {
                        my $tag = lc $sub->tag;
                        if ( $tag eq 'else' || $tag eq 'elseif' ) {
                            push @$tokens_else, $sub;
                        }
                        else {
                            push @$tokens, $sub;
                        }
                    }
                }
                $uncompiled = $t->nodeValue;
            }
            my $hdlr = $ctx->handler_for( $t->tag );
            my ( $h, $type, $orig ) = $hdlr->values;
            my $conditional = defined $type && $type == 2;

            if ($h) {
                $timer->pause_partial if $timer;
                local ( $ctx->{__stash}{tag} ) = $t->tag;
                local ( $ctx->{__stash}{tokens} )
                    = ref($tokens)
                    ? bless $tokens, 'MT::Template::Tokens'
                    : undef;
                local ( $ctx->{__stash}{tokens_else} )
                    = ref($tokens_else)
                    ? bless $tokens_else, 'MT::Template::Tokens'
                    : undef;
                local ( $ctx->{__stash}{uncompiled} ) = $uncompiled;
                my %args = %{ $t->attributes } if defined $t->attributes;
                my @args = @{ $t->attribute_list }
                    if defined $t->attribute_list;

                # process variables
                foreach my $v ( keys %args ) {
                    if ( ref $args{$v} eq 'ARRAY' ) {
                        my @array = @{ $args{$v} };
                        foreach (@array) {
                            if (m/^\$([A-Za-z_](\w|\.)*)$/) {
                                $_ = $ctx->var($1);
                            }
                        }
                        $args{$v} = \@array;
                    }
                    else {
                        if ( $args{$v} =~ m/^\$([A-Za-z_](\w|\.)*)$/ ) {
                            $args{$v} = $ctx->var($1);
                        }
                    }
                }
                foreach (@args) {
                    $_ = [ $_->[0], $_->[1] ];
                    my $arg = $_;
                    if ( ref $arg->[1] eq 'ARRAY' ) {
                        $arg->[1] = [ @{ $arg->[1] } ];
                        foreach ( @{ $arg->[1] } ) {
                            if (m/^\$([A-Za-z_](\w|\.)*)$/) {
                                $_ = $ctx->var($1);
                            }
                        }
                    }
                    else {
                        if ( $arg->[1] =~ m/^\$([A-Za-z_](\w|\.)*)$/ ) {
                            $arg->[1] = $ctx->var($1);
                        }
                    }
                }

                # Stores a reference to the ordered list of arguments,
                # just in case the handler wants them
                local $args{'@'} = \@args;

                my $vars = $ctx->{__stash}{vars};
                local $vars->{__cond_value__} = $vars->{__cond_value__}
                    if $conditional;
                local $vars->{__cond_name__} = $vars->{__cond_name__}
                    if $conditional;

                my $out = $hdlr->invoke( $ctx, \%args, $cond );

                unless ( defined $out ) {
                    my $err = $ctx->errstr;
                    if ( defined $err ) {
                        return $build->error(
                            MT->translate(
                                "Error in <mt[_1]> tag: [_2]", $t->tag,
                                $ctx->errstr
                            )
                        );
                    }
                    else {

                        # no error was given, so undef will mean '' in
                        # such a scenario
                        $out = '';
                    }
                }

                if ($conditional) {

                    # conditional; process result
                    $out
                        = $out
                        ? $ctx->slurp( \%args, $cond )
                        : $ctx->else( \%args, $cond );
                    delete $vars->{__cond_tag__};
                    return $build->error(
                        MT->translate(
                            "Error in <mt[_1]> tag: [_2]", $t->tag,
                            $ctx->errstr
                        )
                    ) unless defined $out;
                }

                $out = $ph->( $ctx, \%args, $out, \@args )
                    if %args && $ph;
                $res .= $out
                    if defined $out;

                if ($timer) {
                    $timer->mark(
                        "tag_" . lc( $t->tag ) . args_to_string( \%args ) );
                }
            }
            else {
                if ( $t->tag !~ m/^_/ ) {    # placeholder tag. just ignore
                    return $build->error(
                        MT->translate( "Unknown tag found: [_1]", $t->tag ) );
                }
            }
        }
    }

    return $res;
}

sub args_to_string {
    my ($args) = @_;
    my $str = '';
    foreach my $a ( keys %$args ) {
        next if $a eq '@';
        next unless defined $args->{$a};
        next if $args->{$a} eq '';
        $str .= ';' . $a . ':';
        if ( ref $args->{$a} eq 'ARRAY' ) {
            foreach my $aa ( @{ $args->{$a} } ) {
                $aa = '...' if $aa =~ m/ /;
                $str .= $aa . ';';
            }
            chop($str);
        }
        else {
            $str .= $args->{$a} =~ m/ / ? '...' : $args->{$a};
        }
    }
    my $more_args = $args->{'@'};
    if ( $more_args && @$more_args ) {
        foreach my $a (@$more_args) {
            if ( ref $a->[1] eq 'ARRAY' ) {
                $str .= ' ' . $a->[0] . '=';
                foreach my $aa ( @{ $a->[1] } ) {
                    $aa = '...' if $aa =~ m/ /;
                    $str .= $aa . ';';
                }
                chop($str);
            }
            else {
                next
                    if exists $args->{ $a->[0] }
                        && ( $args->{ $a->[0] } eq $a->[1] );
                $str .= ';' . $a->[0] . ':';
                $str .= $a->[1];
            }
        }
    }
    return $str ne '' ? '[' . substr( $str, 1 ) . ']' : '';
}
1;
__END__

=head1 NAME

MT::Builder - Parser and interpreter for MT templates

=head1 SYNOPSIS

    use MT::Builder;
    use MT::Template::Context;

    my $build = MT::Builder->new;
    my $ctx = MT::Template::Context->new;

    my $tokens = $build->compile($ctx, '<$MTVersion$>')
        or die $build->errstr;
    defined(my $out = $build->build($ctx, $tokens))
        or die $build->errstr;

=head1 DESCRIPTION

I<MT::Builder> provides the parser and interpreter for taking a template
body and turning it into a generated output page. An I<MT::Builder> object
knows how to parse a string of text into tokens, then take those tokens and
build a scalar string representing the output of the page. It does not,
however, know anything about the types of tags that it encounters; it hands
off this work to the I<MT::Template::Context> object, which can look up a
tag and determine whether it's valid, whether it's a container or substitution
tag, etc.

All I<MT::Builder> knows is the basic structure of a Movable Type tag, and
how to break up a string into pieces: plain text pieces interspersed with
tag callouts. It then knows how to take a list of these tokens/pieces and
build a completed page, using the same I<MT::Template::Context> object to
actually fill in the values for the Movable Type tags.

=head1 USAGE

=head2 MT::Builder->new

Constructs and returns a new parser/interpreter object.

=head2 $build->compile($ctx, $string)

Given an I<MT::Template::Context> object I<$ctx>, breaks up the scalar string
I<$string> into tokens and returns the list of tokens as a reference to an
array. Returns C<undef> on compilation failure.

=head2 $build->build($ctx, \@tokens [, \%cond ])

Given an I<MT::Template::Context> object I<$ctx>, turns a list of tokens
I<\@tokens> and generates an output page. Returns the output page on success,
C<undef> on failure. Note that the empty string (C<''>) and the number zero
(C<0>) are both valid return values for this method, so you should check
specifically for an undefined value when checking for errors.

The optional argument I<\%cond> specifies a list of conditions under which
the tokens will be interpreted. If provided, I<\%cond> should be a reference
to a hash, where the keys are MT tag names (without the leading C<MT>), and
the values are boolean flags specifying whether to include the tag; a true
value means that the tag should be included in the final output, a false value
that it should not. This is useful when a template includes conditional
container tags (eg C<E<lt>MTEntryIfExtendedE<gt>>), and you wish to influence
the inclusion of these container tags. For example, if a template contains
the container

    <MTEntryIfExtended>
    <$MTEntryMore$>
    </MTEntryIfExtended>

and you wish to exclude this conditional, you could call I<build> like this:

    my $out = $build->build($ctx, $tokens, { EntryIfExtended => 0 });

=head2 $build->syntree2str(\@tokens)

Internal debugging routine to dump a set of template tokens. Returns a
readable string of contents of the C<$tokens> parameter.

=head1 ERROR HANDLING

On an error, the above methods return C<undef>, and the error message can
be obtained by calling the method I<errstr> on the object. For example:

    defined(my $out = $build->build($ctx, $tokens))
        or die $build->errstr;

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
