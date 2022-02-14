# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ParamValidator;

use strict;
use warnings;
use base 'MT::ErrorHandler';

our $Initialized;

my %Handlers = (
    ID      => \&validate_id,
    IDS     => \&validate_ids,
    UINT    => \&validate_unsigned_integer,
    INT     => \&validate_integer,
    NUMBER  => \&validate_number,
    XDIGIT  => \&validate_xdigit,
    WORD    => \&validate_word,
    WORDS   => \&validate_words,
    OBJTYPE => \&validate_objtype,
    FLAG    => \&validate_word,
    STRING  => \&validate_string,
    TEXT    => \&validate_text,
    EMAIL   => \&validate_email,
);

sub new {
    my ($class, $rules) = @_;
    my (@names, @re_names, %multi, %required, %validators);
    for my $param_name (keys %$rules) {
        my $param_rules = $rules->{$param_name};
        $param_rules = [$param_rules] unless ref $param_rules;
        if (ref $param_rules ne 'ARRAY') {
            return $class->error(MT->translate("Invalid validation rules: [_1]", $param_name));
        }
        if ($param_name !~ /\A[a-zA-Z0-9_]+\z/) {
            push @re_names, $param_name;
        } else {
            push @names, $param_name;
        }
        for my $rule (@$param_rules) {
            my $rule_name = ref $rule eq 'ARRAY' ? shift @$rule : $rule;
            if (ref $rule_name) {
                return $class->error(MT->translate("Invalid validation rules: [_1]", $param_name));
            }
            my $uc_rule_name = uc $rule_name;
            next if $uc_rule_name =~ /MAYBE/;
            if ($uc_rule_name eq 'REQUIRED' or $uc_rule_name eq 'NOT_NULL') {
                $required{$param_name} = 1;
                next;
            }
            if ($uc_rule_name eq 'MULTI') {
                $multi{$param_name} = 1;
                next;
            }
            if (!exists $Handlers{$uc_rule_name}) {
                return $class->error(MT->translate("Unknown validation rule: [_1]", $rule_name));
            }
            my $validator = $Handlers{$uc_rule_name};
            if (ref $rule) {
                push @{ $validators{$param_name} ||= [] }, [$uc_rule_name, $validator, @$rule];
            } else {
                push @{ $validators{$param_name} ||= [] }, [$uc_rule_name, $validator];
            }
        }
    }
    bless {
        names      => \@names,
        re_names   => \@re_names,
        validators => \%validators,
        required   => \%required,
        multi      => \%multi,
    }, $class;
}

sub validate_param {
    my ($self, $app) = @_;

    my @names = @{ $self->{names} };
    if (my @re_names = @{ $self->{re_names} }) {
        my @all_names = $app->multi_param;
        for my $re (@re_names) {
            for my $matched (grep { /$re/ } @all_names) {
                $self->{validators}{$matched} = $self->{validators}{$re};
                $self->{required}{$matched}   = $self->{required}{$re};
                $self->{multi}{$matched}      = $self->{multi}{$re};
                push @names, $matched;
            }
        }
    }

    for my $name (@names) {
        next unless exists $self->{validators}{$name};
        my $last_error;
        my @values = $app->multi_param($name);
        if (@values > 1 && !$self->{multi}{$name}) {
            _warn(MT->translate("'[_1]' has multiple values", $name) . join ",", @values);
        }
        if (!@values && $self->{required}{$name}) {
            return $self->error(MT->translate("'[_1]' is required", $name));
        }
        for my $value (@values) {
            if (!defined $value or $value eq '') {
                if ($self->{required}{$name}) {
                    return $self->error(MT->translate("'[_1]' is required", $name));
                }
                next;
            }
            for my $validator (@{$self->{validators}{$name}}) {
                my ($rule_name, $code, @params) = @$validator;
                local $@;
                my $error = eval { $code->($app, $name, $value, @params) };
                if ($error || $@) {
                    $error =~ s/ at .*? line .+\z//s;
                    return $self->error("$error: $value");
                }
            }
        }
    }
    return 1;
}

sub _warn {
    return unless $MT::DebugMode;
    require MT::Util::Log;
    MT::Util::Log::init();
    MT::Util::Log->warn(@_);
Carp::cluck(@_);
}

sub handlers { %Handlers ? \%Handlers : undef }

sub set_handler {
    my ($class, $name, $code) = @_;
    $Handlers{ uc $name } = $code;
}

sub validate_id {
    my ($app, $name, $value, @params) = @_;
    return if $value =~ /\A(?:0|[1-9][0-9]*)\z/s;
    return $app->translate("'[_1]' requires a valid ID", $name);
}

sub validate_ids {
    my ($app, $name, $value, @params) = @_;
    my $separator = $params[0] || ',';
    my @values    = split $separator, $value;
    for my $v (@values) {
        if (validate_id($app, $name, $v, @params)) {
            return $app->translate("'[_1]' requires valid (concatenated) IDs", $name);
        }
    }
    return;
}

sub validate_unsigned_integer {
    my ($app, $name, $value, @params) = @_;
    return if $value =~ /\A(?:0|[1-9][0-9]*)\z/s;
    return $app->translate("'[_1]' requires a valid integer", $name);
}

sub validate_integer {
    my ($app, $name, $value, @params) = @_;
    return if $value =~ /\A[+-]?(?:0|[1-9][0-9]*)\z/s;
    return $app->translate("'[_1]' requires a valid integer", $name);
}

sub validate_number {
    my ($app, $name, $value, @params) = @_;
    return if $value =~ /\A[+-]?(?:0|[1-9][0-9]*)(?:\.[0-9]+)?\z/s;
    return $app->translate("'[_1]' requires a valid number", $name);
}
sub validate_xdigit {
    my ($app, $name, $value, @params) = @_;
    return if $value =~ /\A[0-9a-fA-f]+\z/s;
    return $app->translate("'[_1]' requires a valid xdigit value", $name);
}

sub validate_word {
    my ($app, $name, $value, @params) = @_;
    return if $value =~ /\A[0-9a-zA-Z_]+\z/s;
    return $app->translate("'[_1]' requires a valid word", $name);
}

sub validate_words {
    my ($app, $name, $value, @params) = @_;
    my $separator = $params[0] || ',';
    my @values    = split $separator, $value;
    for my $v (@values) {
        if (validate_word($app, $name, $v, @params)) {
            return $app->translate("'[_1]' requires valid (concatenated) words", $name);
        }
    }
    return;
}

sub validate_objtype {
    my ($app, $name, $value, @params) = @_;
    return if $value =~ /\A[0-9a-zA-Z_:.]+\z/s;
    return $app->translate("'[_1]' requires a valid objtype", $name);
}

sub validate_string {
    my ($app, $name, $value, @params) = @_;
    return if $value =~ /\A(?:\p{^PosixCntrl}|0x08)+\z/s;
    return $app->translate("'[_1]' requires a valid string", $name);
}

sub validate_text {
    my ($app, $name, $value, @params) = @_;
    return if $value =~ /\A(?:[[:print:]]|[[:space:]]|0x08)+\z/s;
    return $app->translate("'[_1]' requires a valid text", $name);
}

sub validate_email {
    my ($app, $name, $value, @params) = @_;
    # cf. https://html.spec.whatwg.org/multipage/input.html#valid-e-mail-address
    return if $value =~ /\A[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\z/s;
    return $app->translate("'[_1]' requires a valid email", $name);
}

1;
