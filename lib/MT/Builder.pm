# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Builder;

use strict;
use base qw( MT::ErrorHandler );
use MT::Template::Node;
use MT::Template::Handler;

sub NODE () {'MT::Template::Node'}

sub new { bless {}, $_[0] }

sub compile {
    my $build = shift;
    my ( $ctx, $text, $opt ) = @_;
    my $tmpl;

    $opt ||= { uncompiled => 1 };
    my $depth = $opt->{depth} ||= 0;

    my $ids;
    my $classes;
    my $errors;
    $build->{__state}{errors} = [] unless $depth;
    $errors = $build->{__state}{errors};

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
    if ( $depth <= 0 && $text && Encode::is_utf8($text) ) {
        Encode::_utf8_off($text);
    }

    my $mods;

    # Translate any HTML::Template markup into native MT syntax.
    if (   $depth <= 0
        && $text
        =~ m/<(?:MT_TRANS\b|MT_ACTION\b|(?:tmpl_(?:if|loop|unless|else|var|include)))/i
        )
    {
        translate_html_tmpl($text);
    }

    my $state = $build->{__state};
    local $state->{tokens}  = [];
    local $state->{classes} = $classes;
    local $state->{tmpl}    = $tmpl;
    local $state->{ids}     = $ids;
    local $state->{text}    = \$text;

    my $pos = 0;
    my $len = length $text;

    # MT tag syntax: <MTFoo>, <$MTFoo$>, <$MTFoo>
    #                <MT:Foo>, <$MT:Foo>, <$MT:Foo$>
    #                <MTFoo:Bar>, <$MTFoo:Bar>, <$MTFoo:Bar$>
    # For 'function' tags, the '$' characters are optional
    # For namespace, the ':' is optional for the default 'MT' namespace.
    # Other namespaces (like 'Foo') would require the colon.
    # Tag and attributes are case-insensitive. So you can write:
    #   <mtfoo>...</MTFOO>
    while ( $text
        =~ m!(<\$?(MT:?)((?:<[^>]+?>|"(?:<[^>]+?>|.)*?"|'(?:<[^>]+?>|.)*?'|.)+?)([-]?)[\$/]?>)!gis
        )
    {
        my ( $whole_tag, $prefix, $tag, $space_eater ) = ( $1, $2, $3, $4 );
        ( $tag, my ($args) ) = split /\s+/, $tag, 2;
        my $sec_start = pos $text;
        my $tag_start = $sec_start - length $whole_tag;
        _text_block( $state, $pos, $tag_start ) if $pos < $tag_start;
        $state->{space_eater} = $space_eater;
        $args ||= '';

        # Structure of a node:
        #   tag name, attribute hashref, contained tokens, template text,
        #       attributes arrayref, parent array reference
        my $rec = NODE->new(
            tag            => $tag,
            attributes     => \my %args,
            attribute_list => \my @args
        );
        while (
            $args =~ /
            (?:
                (?:
                    ((?:\w|:)+)                     #1
                    \s*=\s*
                    (?:(?:
                        (["'])                      #2
                        ((?:<[^>]+?>|.)*?)          #3
                        \2
                        (                           #4
                            (?:
                                [,:]
                                (["'])              #5
                                (?:(?:<[^>]+?>|.)*?)
                                \5
                            )+
                        )?
                    ) |
                    (\S+))                          #6
                )
            ) |
            (\w+)                                   #7
            /gsx
            )
        {
            if ( defined $7 ) {

                # An unnamed attribute gets stored in the 'name' argument.
                $args{'name'} = $7;
            }
            else {
                my $attr  = lc $1;
                my $value = defined $6 ? $6 : $3;
                my $extra = $4;
                if ( defined $extra ) {
                    my @extra;
                    push @extra, $2
                        while $extra =~ m/[,:](["'])((?:<[^>]+?>|.)*?)\1/gs;
                    $value = [ $value, @extra ];
                }

                # We need a reference to the filters to check
                # attributes and whether they need to be in the array of
                # attributes for post-processing.
                $mods ||= $ctx->{__filters};
                push @args, [ $attr, $value ] if exists $mods->{$attr};
                $args{$attr} = $value;
                if ( $attr eq 'id' ) {

                    # store a reference to this token based on the 'id' for it
                    $ids->{$3} = $rec;
                }
                elsif ( $attr eq 'class' ) {

                    # store a reference to this token based on the 'id' for it
                    $classes->{ lc $3 } ||= [];
                    push @{ $classes->{ lc $3 } }, $rec;
                }
            }
        }
        my $hdlr = $ctx->handler_for($tag);
        my ( $h, $is_container );
        if ($hdlr) {
            ( $h, $is_container ) = $hdlr->values;
        }
        if ( !$h ) {

            # determine line #
            my $pre_error = substr( $text, 0, $tag_start );
            my @m         = $pre_error =~ m/\r?\n/g;
            my $line      = scalar @m;
            if ($depth) {
                $opt->{error_line} = $line;
                push @$errors,
                    {
                    message => MT->translate(
                        "<[_1]> at line [_2] is unrecognized.",
                        $prefix . $tag, "#"
                    ),
                    line => $line + 1
                    };
            }
            else {
                push @$errors,
                    {
                    message => MT->translate(
                        "<[_1]> at line [_2] is unrecognized.",
                        $prefix . $tag,
                        $line + 1
                    ),
                    line => $line
                    };
            }
        }
        if ($is_container) {
            if ( $whole_tag !~ m|/>$| ) {
                my ( $sec_end, $tag_end )
                    = _consume_up_to( $ctx, \$text, $sec_start, $tag );
                if ($sec_end) {
                    my $sec = $tag =~ m/ignore/i
                        ? ''    # ignore MTIgnore blocks
                        : substr $text, $sec_start, $sec_end - $sec_start;
                    if ( $sec !~ m/<\$?MT/i ) {
                        $rec->childNodes(
                            [   (   $sec ne ''
                                    ? NODE->new(
                                        tag       => 'TEXT',
                                        nodeValue => $sec
                                        )
                                    : ()
                                )
                            ]
                        );
                    }
                    else {
                        local $opt->{depth}  = $opt->{depth} + 1;
                        local $opt->{parent} = $rec;
                        $rec->childNodes(
                            $build->compile( $ctx, $sec, $opt ) );
                        if (@$errors) {
                            my $pre_error = substr( $text, 0, $sec_start );
                            my @m         = $pre_error =~ m/\r?\n/g;
                            my $line      = scalar @m;
                            foreach (@$errors) {
                                $line += $_->{line};
                                $_->{line} = $line;
                                $_->{message} =~ s/#/$line/ unless $depth;
                            }
                        }

             # unless (defined $rec->[2]) {
             #     my $pre_error = substr($text, 0, $sec_start);
             #     my @m = $pre_error =~ m/\r?\n/g;
             #     my $line = scalar @m;
             #     if ($depth) {
             #         $opt->{error_line} = $line + ($opt->{error_line} || 0);
             #         return;
             #     }
             #     else {
             #         $line += ($opt->{error_line} || 0) + 1;
             #         my $err = $build->errstr;
             #         $err =~ s/#/$line/;
             #         return $build->error($err);
             #     }
             # }
                    }
                    $rec->nodeValue($sec) if $opt->{uncompiled};
                }
                else {
                    my $pre_error = substr( $text, 0, $tag_start );
                    my @m         = $pre_error =~ m/\r?\n/g;
                    my $line      = scalar @m;
                    if ($depth) {

# $opt->{error_line} = $line;
# return $build->error(MT->translate("<[_1]> with no </[_1]> on line #", $prefix . $tag));
                        push @$errors,
                            {
                            message => MT->translate(
                                "<[_1]> with no </[_1]> on line [_2].",
                                $prefix . $tag, "#"
                            ),
                            line => $line
                            };
                    }
                    else {
                        push @$errors,
                            {
                            message => MT->translate(
                                "<[_1]> with no </[_1]> on line [_2].",
                                $prefix . $tag,
                                $line + 1
                            ),
                            line => $line + 1
                            };

# return $build->error(MT->translate("<[_1]> with no </[_1]> on line [_2]", $prefix . $tag, $line + 1));
                    }
                    last;    # return undef;
                }
                $pos = $tag_end + 1;
                ( pos $text ) = $tag_end;
            }
            else {
                $rec->nodeValue('');
            }
        }
        $rec->parentNode( $opt->{parent} || $tmpl );
        $rec->template($tmpl);
        push @{ $state->{tokens} }, $rec;
        $pos = pos $text;
    }
    _text_block( $state, $pos, $len ) if $pos < $len;
    if ( defined $tmpl ) {

        # assign token and id references to template
        $tmpl->tokens( $state->{tokens} );
        $tmpl->token_ids( $state->{ids} );
        $tmpl->token_classes( $state->{classes} );
        $tmpl->errors( $state->{errors} )
            if $state->{errors} && ( @{ $state->{errors} } );
    }
    else {
        if ( $errors && @$errors ) {
            return $build->error( $errors->[0]->{message} );
        }
    }

    if ( $depth <= 0 ) {
        for my $t ( @{ $state->{tokens} } ) {
            $t->upgrade;
        }
        Encode::_utf8_on($text)
            if !Encode::is_utf8($text);
    }
    return $state->{tokens};
}

sub translate_html_tmpl {
    $_[0] =~ s!<(/?)tmpl_(if|loop|unless|else|var|include)\b!<$1mt:$2!ig;
    $_[0] =~ s!<MT_TRANS\b!<__trans!ig;
    $_[0] =~ s!<MT_ACTION\b!<__action!ig;
}

sub _consume_up_to {
    my ( $ctx, $text, $start, $stoptag ) = @_;
    my $whole_tag;
    ( pos $$text ) = $start;
    while ( $$text =~ m!(<([\$/]?)MT:?([^\s\$>]+)(?:<[^>]+?>|[^>])*?[\$/]?>)!gi ) {
        $whole_tag = $1;
        my ( $prefix, $tag ) = ( $2, $3 );

        # not a container tag
        my $hdlr = $ctx->handler_for($tag);
        next if !( $hdlr && $hdlr->type );

        my $end = pos $$text;
        if ( $prefix && ( $prefix eq '/' ) ) {
            return ( $end - length($whole_tag), $end )
                if lc($tag) eq lc($stoptag);
            last;
        }
        elsif ( $whole_tag !~ m|/>\z| ) {
            my ( $sec_end, $end_tag )
                = _consume_up_to( $ctx, $text, $end, $tag );
            last if !$sec_end;
            ( pos $$text ) = $end_tag;
        }
    }

    # special case for unclosed 'else' tag:
    if ( lc($stoptag) eq 'else' || lc($stoptag) eq 'elseif' ) {
        my $pos
            = pos($$text)
            ? pos($$text) - length($whole_tag)
            : length($$text);
        return ( $pos, $pos );
    }
    return ( 0, 0 );
}

sub _text_block {
    my $text = substr ${ $_[0]->{text} }, $_[1], $_[2] - $_[1];
    if ( ( defined $text ) && ( $text ne '' ) ) {
        return if $_[0]->{space_eater} && ( $text =~ m/^\s+$/s );
        $text =~ s/^\s+//s if $_[0]->{space_eater};
        my $rec = NODE->new(
            tag        => 'TEXT',
            nodeValue  => $text,
            parentNode => $_[0]->{tokens},
            template   => $_[0]->{tmpl}
        );
        push @{ $_[0]->{tokens} }, $rec;
    }
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
