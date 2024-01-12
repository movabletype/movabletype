# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Builder::Fast;

use strict;
use warnings;
use base qw( MT::Builder );
use MT::Template::Node ':constants';
use MT::Template::Handler;
use MT::Util::Encode;
use Scalar::Util 'weaken';

our $Compiler = \&compilerPP;    # for now

my @FilterOrder = qw(
    filters trim_to trim ltrim rtrim decode_html
    decode_xml remove_html dirify sanitize
    encode_html encode_xml encode_js encode_php
    encode_url upper_case lower_case strip_linefeeds
    space_pad zero_pad sprintf
);
my %FilterOrderMap = do { my $i = 0; map { $_ => $i++ } @FilterOrder };

sub compile {
    my $build = shift;
    my ($ctx, $text) = @_;
    my $tmpl;

    my $ids;
    my $classes;
    my $error = $build->{__state}{errors} = [];

    # handle $builder->compile($template) signature
    if (UNIVERSAL::isa($ctx, 'MT::Template')) {
        $tmpl = $ctx;
        $ctx  = $tmpl->context;
        $text = $tmpl->text;
        $tmpl->reset_tokens();
        $ids                    = $build->{__state}{ids}     = {};
        $classes                = $build->{__state}{classes} = {};
        $build->{__state}{tmpl} = $tmpl;
    } else {
        $ids     = $build->{__state}{ids}     || {};
        $classes = $build->{__state}{classes} || {};
        $tmpl    = $build->{__state}{tmpl};
    }

    return [] unless defined $text;
    my $turn_utf8_back = 0;
    if (MT::Util::Encode::is_utf8($text)) {
        MT::Util::Encode::_utf8_off($text);
        $turn_utf8_back = 1;
    }

    if ($text =~ m/<(?:MT_TRANS\b|MT_ACTION\b|(?:tmpl_(?:if|loop|unless|else|var|include)))/i) {
        MT::Builder::translate_html_tmpl($text);
    }

    my $handlers  = $ctx->{__handlers};
    my $modifiers = $ctx->{__filters};

    my $tokens = $Compiler->($handlers, $modifiers, $ids, $classes, $error, $text, $tmpl);

    MT::Util::Encode::_utf8_on($text) if $turn_utf8_back;

    if (@$error) {
        my ($error_pos, $msg) = @$error;
        my $pre_error = substr($text, 0, $error_pos);
        my $line      = () = $pre_error =~ m/\r?\n/g;
        $line++;
        $msg =~ s/#/$line/;
        if ($tmpl) {
            $tmpl->errors([{ message => $msg, line => $line }]);
            $msg = MT->translate(
                "Publish error in template '[_1]': [_2]",
                $tmpl->name || $tmpl->{__file},
                $msg
            );
        }
        return $build->error($msg);
    } elsif (defined $tmpl) {
        # assign token and id references to template
        $tmpl->tokens($tokens);
        $tmpl->token_ids($ids);
        $tmpl->token_classes($classes);
    }
    return $tokens;
}

sub compilerPP {
    my ($handlers, $modifiers, $ids, $classes, $error, $text, $tmpl) = @_;

    my $tokens = [];
    my @blocks;
    my $last_tag_ended = 0;
    my $space_eater    = 0;

    while (
        $text =~ m!(<
                (/?)\$?     # close tag
                [mM][tT]:?
                ((?:<[^>]+?>|"(?:<[^>]+?>|.)*?"|'(?:<[^>]+?>|.)*?'|.)+?) # attr
                (-?)[\$/]?>)
        !gsx
        )
    {
        my $whole_tag        = $1;
        my $is_close         = $2;
        my $tag              = $3;
        my $next_space_eater = $4;
        my ($tag_name, $args_string) = split /\s+/, $tag, 2;
        $args_string = '' unless defined $args_string;
        my $lc_tag_name = lc($tag_name);
        my $tag_start   = pos($text) - length($whole_tag);
        my $tag_end     = pos($text);

        if ($tag_start > $last_tag_ended) {
            my $t_part = substr($text, $last_tag_ended, $tag_start - $last_tag_ended);
            $t_part =~ s/^\s+//s if $space_eater;
            if (length $t_part) {
                MT::Util::Encode::_utf8_on($t_part);
                my $t_rec = [
                    'TEXT',     # name
                    undef,      # attr (or text?)
                    undef,      # children
                    $t_part,    # value
                    undef,      # attrlist
                    undef,      # parent
                    $tmpl,
                ];
                weaken($t_rec->[EL_NODE_TEMPLATE]);
                push @{ @blocks ? ($blocks[-1][0][EL_NODE_CHILDREN] ||= []) : $tokens }, $t_rec;
            }
        }
        $last_tag_ended = $tag_end;
        $space_eater    = $next_space_eater ? 1 : 0;
        if ($is_close) {
            my $head;
            while (@blocks) {
                $head = pop @blocks;
                my $hrec         = $head->[0];
                my $hstart       = $head->[1];
                my $lc_head_name = lc($hrec->[EL_NODE_NAME]);
                if ($lc_head_name eq $lc_tag_name) {
                    $hrec->[EL_NODE_VALUE] = substr($text, $hstart, $tag_start - $hstart);
                    MT::Util::Encode::_utf8_on($hrec->[EL_NODE_VALUE]);
                    last;
                }
                if (($lc_head_name eq 'else') or ($lc_head_name eq 'elseif')) {
                    $hrec->[EL_NODE_VALUE] = substr($text, $hstart, $tag_start - $hstart);
                    MT::Util::Encode::_utf8_on($hrec->[EL_NODE_VALUE]);
                    $head = undef;
                    next;
                }

                if ($lc_tag_name eq 'ignore') {
                    # Treat mismatched closing tag as a text (or an html snippet)
                    push @blocks, $head;
                    my $t_rec = [
                        'TEXT',     # name
                        undef,      # attr (or text?)
                        undef,      # children
                        $whole_tag, # value
                        undef,      # attrlist
                        undef,      # parent
                        $tmpl,
                    ];
                    weaken($t_rec->[EL_NODE_TEMPLATE]);
                    push @{ @blocks ? ($blocks[-1][0][EL_NODE_CHILDREN] ||= []) : $tokens }, $t_rec;
                    last;
                }
            }
            if (not $head) {
                if ($lc_tag_name eq 'ignore') {
                    my $t_rec = [
                        'TEXT',     # name
                        undef,      # attr (or text?)
                        undef,      # children
                        $whole_tag, # value
                        undef,      # attrlist
                        undef,      # parent
                        $tmpl,
                    ];
                    weaken($t_rec->[EL_NODE_TEMPLATE]);
                    push @{ @blocks ? ($blocks[-1][0][EL_NODE_CHILDREN] ||= []) : $tokens }, $t_rec;
                } else {
                    push @$error, $tag_start, MT->translate("Found mismatched closing tag [_1] at line #", $lc_tag_name);
                    return;
                }
            }
            next;
        }
        if (not exists $handlers->{$lc_tag_name}) {
            push @$error, $tag_start, MT->translate("Undefined tag [_1] at line #", MT::Util::Encode::decode_utf8($lc_tag_name));
            return;
        }
        my $rec = [
            $tag_name,                             # name
            \my %args,                             # attr
            [],                                    # children
            undef,                                 # value
            \my @args,                             # attrlist
            (@blocks ? $blocks[-1][0] : $tmpl),    # parent
            $tmpl,
        ];
        weaken($rec->[EL_NODE_TEMPLATE]);
        weaken($rec->[EL_NODE_PARENT]);
        while (
            $args_string =~ m!
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
            !gsx
            )
        {    # "
            if (defined $7) {
                my $arg_name = lc $7;
                MT::Util::Encode::_utf8_on($arg_name);
                $args{name} = $arg_name;
                next;
            }
            my $arg_name = lc $1;
            my ($arg_value) = defined $6 ? $6 : $3;
            MT::Util::Encode::_utf8_on($arg_value);
            my $extra_args = $4;
            if ($extra_args) {
                $arg_value = [$arg_value];
                while ($extra_args =~ m/[,:](?:'((?:<[^>]+?>|.)*?)'|"((?:<[^>]+?>|.)*?)")/gs) {
                    my ($value) = grep defined($_), $1, $2;
                    MT::Util::Encode::_utf8_on($value);
                    push @$arg_value, $value;
                }
            }
            $args{$arg_name} = $arg_value;
            if ($arg_name eq "id") {
                $ids->{$arg_value} = $rec;
            } elsif ($arg_name eq "class") {
                push @{ $classes->{ lc $arg_value } ||= [] }, $rec;
            }
            if (exists $modifiers->{$arg_name}) {
                push @args, [$arg_name, $arg_value];
            }
        }
        if (@blocks) {
            push @{ $blocks[-1][0][EL_NODE_CHILDREN] ||= [] }, $rec;
        } else {
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
                push @$error, $tag_start, MT->translate("Tag [_1] left unclosed at line #", $lc_tag_name);
                return;
            }
            $last_tag_ended = pos($text);
            $rec->[EL_NODE_CHILDREN] = []; $rec->[EL_NODE_VALUE] = '';    # keeping compability with original version
            next;
        }
        my $handler = $handlers->{$lc_tag_name};
        if (Scalar::Util::reftype $handler eq 'ARRAY' && $handler->[1]) {
            # is block tag
            push @blocks, [$rec, $tag_end] unless substr($whole_tag, -2) eq '/>';
        }
    }

    if (@blocks) {
        push @$error, $blocks[-1][1], MT->translate("Tag [_1] left unclosed at line #", ($blocks[-1][0][0]));
        return;
    }

    if ($last_tag_ended < length($text)) {
        my $t_part = substr($text, $last_tag_ended, length($text) - $last_tag_ended);
        $t_part =~ s/^\s+//s if $space_eater;
        if (length $t_part) {
            MT::Util::Encode::_utf8_on($t_part);
            my $t_rec = [
                'TEXT',     # name
                undef,      # attr (or text)
                undef,      # children
                $t_part,    # value
                undef,      # attrlist
                undef,      # parent
                $tmpl,
            ];
            weaken($t_rec->[EL_NODE_TEMPLATE]);
            push @$tokens, $t_rec;
        }
    }

    return $tokens;
}

sub build {
    my $build = shift;
    my ($ctx, $tokens, $cond) = @_;

    my $timer;
    if ($MT::DebugMode & 8) {
        $timer = MT->get_timer();
    }

    if ($cond) {
        my %lcond;

        # lowercase condtional keys since we're storing tags in lowercase now
        # When both the lowercase key and the CamelCase key exist,
        # the value will be overwrited in the CamelCase key's value.
        $lcond{ lc $_ } = $cond->{$_} for reverse sort keys %$cond;
        $cond = \%lcond;
    } else {
        $cond = {};
    }

    # Avoids circular reference between MT::Template::Context and MT::Builder.
    local $ctx->{__stash}{builder} = $build;
    my $res = '';
    # my $ph  = $ctx->post_process_handler;

    my %post_process_handlers;

    my %handler_cache;
    for my $t (@$tokens) {
        my $tag = $t->[EL_NODE_NAME];
        if ($tag eq 'TEXT') {
            $res .= $t->[EL_NODE_VALUE];
        } else {
            my ($tokens, $tokens_else, $uncompiled);
            my $lc_tag = lc $tag;
            if ($cond && (exists $cond->{$lc_tag} && !$cond->{$lc_tag})) {

                # if there's a cond for this tag and it's false,
                # walk the children and look for an MTElse.
                # the children of the MTElse will become $tokens
                for my $child (@{ $t->[EL_NODE_CHILDREN] }) {
                    my $child_tag = lc $child->[EL_NODE_NAME];
                    if ($child_tag eq 'else' || $child_tag eq 'elseif') {
                        $tokens     = $child->[EL_NODE_CHILDREN];
                        $uncompiled = $child->[EL_NODE_VALUE];
                        last;
                    }
                }
                next unless $tokens;
            } else {
                my $childNodes = $t->[EL_NODE_CHILDREN];
                if ($childNodes && ref($childNodes)) {

                    # either there is no cond for this tag, or it's true,
                    # so we want to partition the children into
                    # those which are inside an else and those which are not.
                    ($tokens, $tokens_else) = ([], []);
                    for my $child (@$childNodes) {
                        my $child_tag = lc $child->[EL_NODE_NAME];
                        if ($child_tag eq 'else' || $child_tag eq 'elseif') {
                            push @$tokens_else, $child;
                        } else {
                            push @$tokens, $child;
                        }
                    }
                }
                $uncompiled = $t->[EL_NODE_VALUE];
            }
            my $hdlr = $handler_cache{$lc_tag} ||= $ctx->handler_for($tag);
            my ($h, $type, $orig) = @$hdlr;
            my $conditional = defined $type && $type == 2;

            if ($h) {
                $timer->pause_partial if $timer;
                local ($ctx->{__stash}{tag}) = $tag;
                local ($ctx->{__stash}{tokens}) =
                    ref($tokens)
                    ? bless $tokens, 'MT::Template::Tokens'
                    : undef;
                local ($ctx->{__stash}{tokens_else}) =
                    ref($tokens_else)
                    ? bless $tokens_else, 'MT::Template::Tokens'
                    : undef;
                local ($ctx->{__stash}{uncompiled}) = $uncompiled;
                my %args = %{ $t->[EL_NODE_ATTR]     || {} };
                my @args = @{ $t->[EL_NODE_ATTRLIST] || [] };

                # process variables
                foreach my $v (keys %args) {
                    if (ref $args{$v} eq 'ARRAY') {
                        my @array = @{ $args{$v} };
                        foreach (@array) {
                            if (m/^\$([A-Za-z_](?:\w|\.)*)$/) {
                                $_ = $ctx->var($1);
                            }
                        }
                        $args{$v} = \@array;
                    } else {
                        if ($args{$v} =~ m/^\$([A-Za-z_](?:\w|\.)*)$/) {
                            $args{$v} = $ctx->var($1);
                        }
                    }
                }
                foreach (@args) {
                    $_ = [$_->[0], $_->[1]];
                    my $arg = $_;
                    if (ref $arg->[1] eq 'ARRAY') {
                        $arg->[1] = [@{ $arg->[1] }];
                        foreach (@{ $arg->[1] }) {
                            if (m/^\$([A-Za-z_](?:\w|\.)*)$/) {
                                $_ = $ctx->var($1);
                            }
                        }
                    } else {
                        if ($arg->[1] =~ m/^\$([A-Za-z_](?:\w|\.)*)$/) {
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

                my $out = $hdlr->invoke($ctx, \%args, $cond);

                unless (defined $out) {
                    my $err = $ctx->errstr;
                    if (defined $err) {
                        return $build->error(MT->translate("Error in <mt[_1]> tag: [_2]", $tag, $ctx->errstr));
                    } else {
                        # no error was given, so undef will mean '' in
                        # such a scenario
                        $out = '';
                    }
                }

                if ($conditional) {

                    # conditional; process result
                    $out =
                          $out
                        ? $ctx->slurp(\%args, $cond)
                        : $ctx->else(\%args, $cond);
                    delete $vars->{__cond_tag__};
                    return $build->error(MT->translate("Error in <mt[_1]> tag: [_2]", $tag, $ctx->errstr))
                        unless defined $out;
                }

                if (%args) {
                    # post process
                    if (@args) {
                        # In the event that $args was manipulated by handlers,
                        # locate any new arguments and add them to $arglist for
                        # processing
                        my %map = map { $_->[0] => $_->[1] } @args;
                        if (scalar keys %map != scalar keys %args) {
                            for my $key (keys %args) {
                                next if exists $map{$key};
                                push @args, [$key => $args{$key}] if exists $ctx->{__filters}{$key};
                            }
                        }
                    } elsif (%args and !@args) {
                        # in the event that we don't have arglist,
                        # we'll build it using the hashref we do have
                        # we might as well preserve the original ordering
                        # of processing as well, since it's better than
                        # the pseudo random order we get from retrieving the
                        # keys from the hash.
                        for my $key (sort {($FilterOrderMap{$a} || 0) <=> ($FilterOrderMap{$b} || 0)} keys %args) {
                            next unless $ctx->{__filters}{$key};
                            push @args, [$key => $args{$key}];
                        }
                    }

                    for my $arg (@args) {
                        my ($name, $val) = @$arg;
                        next unless exists $args{$name};
                        next unless exists $ctx->{__filters}{$name};
                        my $code = $post_process_handlers{$name} ||= do {
                            my $filter = $ctx->{__filters}{$name};
                            if (ref $filter eq 'HASH') {
                                $filter = $filter->{code} ||= MT->handler_to_coderef($filter->{handler});
                            } elsif (defined $filter && !ref $filter) {
                                $filter = MT->handler_to_coderef($filter);
                            }
                            $filter;
                        };
                        $out = $code->($out, $val, $ctx);
                        $out = '' unless defined($out);
                    }
                }
                $res .= $out
                    if defined $out;

                if ($timer) {
                    $timer->mark("tag_" . $lc_tag . MT::Builder::args_to_string(\%args));
                }
            } else {
                if ($tag !~ m/^_/) {    # placeholder tag. just ignore
                    return $build->error(MT->translate("Unknown tag found: [_1]", $tag));
                }
            }
        }
    }

    return $res;
}

1;
