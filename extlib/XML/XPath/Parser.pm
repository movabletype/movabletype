# $Id: Parser.pm 4532 2004-05-11 05:15:40Z ezra $

package XML::XPath::Parser;

use strict;
use vars qw/
        $NCName 
        $QName 
        $NCWild
        $QNWild
        $NUMBER_RE 
        $NODE_TYPE 
        $AXIS_NAME 
        %AXES 
        $LITERAL
        %CACHE/;

use XML::XPath::XMLParser;
use XML::XPath::Step;
use XML::XPath::Expr;
use XML::XPath::Function;
use XML::XPath::LocationPath;
use XML::XPath::Variable;
use XML::XPath::Literal;
use XML::XPath::Number;
use XML::XPath::NodeSet;

# Axis name to principal node type mapping
%AXES = (
        'ancestor' => 'element',
        'ancestor-or-self' => 'element',
        'attribute' => 'attribute',
        'namespace' => 'namespace',
        'child' => 'element',
        'descendant' => 'element',
        'descendant-or-self' => 'element',
        'following' => 'element',
        'following-sibling' => 'element',
        'parent' => 'element',
        'preceding' => 'element',
        'preceding-sibling' => 'element',
        'self' => 'element',
        );

$NCName = '([A-Za-z_][\w\\.\\-]*)';
$QName = "($NCName:)?$NCName";
$NCWild = "${NCName}:\\*";
$QNWild = "\\*";
$NODE_TYPE = '((text|comment|processing-instruction|node)\\(\\))';
$AXIS_NAME = '(' . join('|', keys %AXES) . ')::';
$NUMBER_RE = '\d+(\\.\d*)?|\\.\d+';
$LITERAL = '\\"[^\\"]*\\"|\\\'[^\\\']*\\\'';

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    debug("New Parser being created.\n");
    $self->{context_set} = XML::XPath::NodeSet->new();
    $self->{context_pos} = undef; # 1 based position in array context
    $self->{context_size} = 0; # total size of context
    $self->clear_namespaces();
    $self->{vars} = {};
    $self->{direction} = 'forward';
    $self->{cache} = {};
    return $self;
}

sub get_var {
    my $self = shift;
    my $var = shift;
    $self->{vars}->{$var};
}

sub set_var {
    my $self = shift;
    my $var = shift;
    my $val = shift;
    $self->{vars}->{$var} = $val;
}

sub set_namespace {
    my $self = shift;
    my ($prefix, $expanded) = @_;
    $self->{namespaces}{$prefix} = $expanded;
}

sub clear_namespaces {
    my $self = shift;
    $self->{namespaces} = {};
}

sub get_namespace {
    my $self = shift;
    my ($prefix, $node) = @_;
    if (my $ns = $self->{namespaces}{$prefix}) {
        return $ns;
    }
    if (my $nsnode = $node->getNamespace($prefix)) {
        return $nsnode->getValue();
    }
}

sub get_context_set { $_[0]->{context_set}; }
sub set_context_set { $_[0]->{context_set} = $_[1]; }
sub get_context_pos { $_[0]->{context_pos}; }
sub set_context_pos { $_[0]->{context_pos} = $_[1]; }
sub get_context_size { $_[0]->{context_set}->size; }
sub get_context_node { $_[0]->{context_set}->get_node($_[0]->{context_pos}); }

sub my_sub {
    return (caller(1))[3];
}

sub parse {
    my $self = shift;
    my $path = shift;
    if ($CACHE{$path}) {
        return $CACHE{$path};
    }
    my $tokens = $self->tokenize($path);

    $self->{_tokpos} = 0;
    my $tree = $self->analyze($tokens);
    
    if ($self->{_tokpos} < scalar(@$tokens)) {
        # didn't manage to parse entire expression - throw an exception
        die "Parse of expression $path failed - junk after end of expression: $tokens->[$self->{_tokpos}]";
    }
    
    $CACHE{$path} = $tree;
    
    debug("PARSED Expr to:\n", $tree->as_string, "\n") if $XML::XPath::Debug;
    
    return $tree;
}

sub tokenize {
    my $self = shift;
    my $path = shift;
    study $path;
    
    my @tokens;
    
    debug("Parsing: $path\n");
    
    # Bug: We don't allow "'@' NodeType" which is in the grammar, but I think is just plain stupid.

    while($path =~ m/\G
        \s* # ignore all whitespace
        ( # tokens
            $LITERAL|
            $NUMBER_RE| # Match digits
            \.\.| # match parent
            \.| # match current
            ($AXIS_NAME)?$NODE_TYPE| # match tests
            processing-instruction|
            \@($NCWild|$QName|$QNWild)| # match attrib
            \$$QName| # match variable reference
            ($AXIS_NAME)?($NCWild|$QName|$QNWild)| # match NCName,NodeType,Axis::Test
            \!=|<=|\-|>=|\/\/|and|or|mod|div| # multi-char seps
            [,\+=\|<>\/\(\[\]\)]| # single char seps
            (?<!(\@|\(|\[))\*| # multiply operator rules (see xpath spec)
            (?<!::)\*|
            $ # match end of query
        )
        \s* # ignore all whitespace
        /gcxso) {

        my ($token) = ($1);

        if (length($token)) {
            debug("TOKEN: $token\n");
            push @tokens, $token;
        }
        
    }
    
    if (pos($path) < length($path)) {
        my $marker = ("." x (pos($path)-1));
        $path = substr($path, 0, pos($path) + 8) . "...";
        $path =~ s/\n/ /g;
        $path =~ s/\t/ /g;
        die "Query:\n",
            "$path\n",
            $marker, "^^^\n",
            "Invalid query somewhere around here (I think)\n";
    }
    
    return \@tokens;
}

sub analyze {
    my $self = shift;
    my $tokens = shift;
    # lexical analysis
    
    return Expr($self, $tokens);
}

sub match {
    my ($self, $tokens, $match, $fatal) = @_;
    
    $self->{_curr_match} = '';
    return 0 unless $self->{_tokpos} < @$tokens;

    local $^W;
    
#    debug ("match: $match\n");
    
    if ($tokens->[$self->{_tokpos}] =~ /^$match$/) {
        $self->{_curr_match} = $tokens->[$self->{_tokpos}];
        $self->{_tokpos}++;
        return 1;
    }
    else {
        if ($fatal) {
            die "Invalid token: ", $tokens->[$self->{_tokpos}], "\n";
        }
        else {
            return 0;
        }
    }
}

sub Expr {
    my ($self, $tokens) = @_;
    
    debug("in SUB\n");
    
    return OrExpr($self, $tokens);
}

sub OrExpr {
    my ($self, $tokens) = @_;
    
    debug("in SUB\n");
    
    my $expr = AndExpr($self, $tokens); 
    while (match($self, $tokens, 'or')) {
        my $or_expr = XML::XPath::Expr->new($self);
        $or_expr->set_lhs($expr);
        $or_expr->set_op('or');

        my $rhs = AndExpr($self, $tokens);

        $or_expr->set_rhs($rhs);
        $expr = $or_expr;
    }
    
    return $expr;
}

sub AndExpr {
    my ($self, $tokens) = @_;
    
    debug("in SUB\n");
    
    my $expr = EqualityExpr($self, $tokens);
    while (match($self, $tokens, 'and')) {
        my $and_expr = XML::XPath::Expr->new($self);
        $and_expr->set_lhs($expr);
        $and_expr->set_op('and');
        
        my $rhs = EqualityExpr($self, $tokens);
        
        $and_expr->set_rhs($rhs);
        $expr = $and_expr;
    }
    
    return $expr;
}

sub EqualityExpr {
    my ($self, $tokens) = @_;
    
    debug("in SUB\n");
    
    my $expr = RelationalExpr($self, $tokens);
    while (match($self, $tokens, '!?=')) {
        my $eq_expr = XML::XPath::Expr->new($self);
        $eq_expr->set_lhs($expr);
        $eq_expr->set_op($self->{_curr_match});
        
        my $rhs = RelationalExpr($self, $tokens);
        
        $eq_expr->set_rhs($rhs);
        $expr = $eq_expr;
    }
    
    return $expr;
}

sub RelationalExpr {
    my ($self, $tokens) = @_;
    
    debug("in SUB\n");
    
    my $expr = AdditiveExpr($self, $tokens);
    while (match($self, $tokens, '(<|>|<=|>=)')) {
        my $rel_expr = XML::XPath::Expr->new($self);
        $rel_expr->set_lhs($expr);
        $rel_expr->set_op($self->{_curr_match});
        
        my $rhs = AdditiveExpr($self, $tokens);
        
        $rel_expr->set_rhs($rhs);
        $expr = $rel_expr;
    }
    
    return $expr;
}

sub AdditiveExpr {
    my ($self, $tokens) = @_;
    
    debug("in SUB\n");
    
    my $expr = MultiplicativeExpr($self, $tokens);
    while (match($self, $tokens, '[\\+\\-]')) {
        my $add_expr = XML::XPath::Expr->new($self);
        $add_expr->set_lhs($expr);
        $add_expr->set_op($self->{_curr_match});
        
        my $rhs = MultiplicativeExpr($self, $tokens);
        
        $add_expr->set_rhs($rhs);
        $expr = $add_expr;
    }
    
    return $expr;
}

sub MultiplicativeExpr {
    my ($self, $tokens) = @_;
    
    debug("in SUB\n");
    
    my $expr = UnaryExpr($self, $tokens);
    while (match($self, $tokens, '(\\*|div|mod)')) {
        my $mult_expr = XML::XPath::Expr->new($self);
        $mult_expr->set_lhs($expr);
        $mult_expr->set_op($self->{_curr_match});
        
        my $rhs = UnaryExpr($self, $tokens);
        
        $mult_expr->set_rhs($rhs);
        $expr = $mult_expr;
    }
    
    return $expr;
}

sub UnaryExpr {
    my ($self, $tokens) = @_;
    
    debug("in SUB\n");
    
    if (match($self, $tokens, '-')) {
        my $expr = XML::XPath::Expr->new($self);
        $expr->set_lhs(XML::XPath::Number->new(0));
        $expr->set_op('-');
        $expr->set_rhs(UnaryExpr($self, $tokens));
        return $expr;
    }
    else {
        return UnionExpr($self, $tokens);
    }
}

sub UnionExpr {
    my ($self, $tokens) = @_;
    
    debug("in SUB\n");
    
    my $expr = PathExpr($self, $tokens);
    while (match($self, $tokens, '\\|')) {
        my $un_expr = XML::XPath::Expr->new($self);
        $un_expr->set_lhs($expr);
        $un_expr->set_op('|');
        
        my $rhs = PathExpr($self, $tokens);
        
        $un_expr->set_rhs($rhs);
        $expr = $un_expr;
    }
    
    return $expr;
}

sub PathExpr {
    my ($self, $tokens) = @_;

    debug("in SUB\n");
    
    # PathExpr is LocationPath | FilterExpr | FilterExpr '//?' RelativeLocationPath
    
    # Since we are being predictive we need to find out which function to call next, then.
        
    # LocationPath either starts with "/", "//", ".", ".." or a proper Step.
    
    my $expr = XML::XPath::Expr->new($self);
    
    my $test = $tokens->[$self->{_tokpos}];
    
    # Test for AbsoluteLocationPath and AbbreviatedRelativeLocationPath
    if ($test =~ /^(\/\/?|\.\.?)$/) {
        # LocationPath
        $expr->set_lhs(LocationPath($self, $tokens));
    }
    # Test for AxisName::...
    elsif (is_step($self, $tokens)) {
        $expr->set_lhs(LocationPath($self, $tokens));
    }
    else {
        # Not a LocationPath
        # Use FilterExpr instead:
        
        $expr = FilterExpr($self, $tokens);
        if (match($self, $tokens, '//?')) {
            my $loc_path = XML::XPath::LocationPath->new();
            push @$loc_path, $expr;
            if ($self->{_curr_match} eq '//') {
                push @$loc_path, XML::XPath::Step->new($self, 'descendant-or-self', 
                                        XML::XPath::Step::test_nt_node);
            }
            push @$loc_path, RelativeLocationPath($self, $tokens);
            my $new_expr = XML::XPath::Expr->new($self);
            $new_expr->set_lhs($loc_path);
            return $new_expr;
        }
    }
    
    return $expr;
}

sub FilterExpr {
    my ($self, $tokens) = @_;
    
    debug("in SUB\n");
    
    my $expr = PrimaryExpr($self, $tokens);
    while (match($self, $tokens, '\\[')) {
        # really PredicateExpr...
        $expr->push_predicate(Expr($self, $tokens));
        match($self, $tokens, '\\]', 1);
    }
    
    return $expr;
}

sub PrimaryExpr {
    my ($self, $tokens) = @_;

    debug("in SUB\n");
    
    my $expr = XML::XPath::Expr->new($self);
    
    if (match($self, $tokens, $LITERAL)) {
        # new Literal with $self->{_curr_match}...
        $self->{_curr_match} =~ m/^(["'])(.*)\1$/;
        $expr->set_lhs(XML::XPath::Literal->new($2));
    }
    elsif (match($self, $tokens, $NUMBER_RE)) {
        # new Number with $self->{_curr_match}...
        $expr->set_lhs(XML::XPath::Number->new($self->{_curr_match}));
    }
    elsif (match($self, $tokens, '\\(')) {
        $expr->set_lhs(Expr($self, $tokens));
        match($self, $tokens, '\\)', 1);
    }
    elsif (match($self, $tokens, "\\\$$QName")) {
        # new Variable with $self->{_curr_match}...
        $self->{_curr_match} =~ /^\$(.*)$/;
        $expr->set_lhs(XML::XPath::Variable->new($self, $1));
    }
    elsif (match($self, $tokens, $QName)) {
        # check match not Node_Type - done in lexer...
        # new Function
        my $func_name = $self->{_curr_match};
        match($self, $tokens, '\\(', 1);
        $expr->set_lhs(
                XML::XPath::Function->new(
                    $self,
                    $func_name,
                    Arguments($self, $tokens)
                )
            );
        match($self, $tokens, '\\)', 1);
    }
    else {
        die "Not a PrimaryExpr at ", $tokens->[$self->{_tokpos}], "\n";
    }
    
    return $expr;
}

sub Arguments {
    my ($self, $tokens) = @_;
    
    debug("in SUB\n");
    
    my @args;
    
    if($tokens->[$self->{_tokpos}] eq ')') {
        return \@args;
    }
    
    push @args, Expr($self, $tokens);
    while (match($self, $tokens, ',')) {
        push @args, Expr($self, $tokens);
    }
    
    return \@args;
}

sub LocationPath {
    my ($self, $tokens) = @_;

    debug("in SUB\n");
    
    my $loc_path = XML::XPath::LocationPath->new();
    
    if (match($self, $tokens, '/')) {
        # root
        debug("SUB: Matched root\n");
        push @$loc_path, XML::XPath::Root->new();
        if (is_step($self, $tokens)) {
            debug("Next is step\n");
            push @$loc_path, RelativeLocationPath($self, $tokens);
        }
    }
    elsif (match($self, $tokens, '//')) {
        # root
        push @$loc_path, XML::XPath::Root->new();
        my $optimised = optimise_descendant_or_self($self, $tokens);
        if (!$optimised) {
            push @$loc_path, XML::XPath::Step->new($self, 'descendant-or-self',
                                XML::XPath::Step::test_nt_node);
            push @$loc_path, RelativeLocationPath($self, $tokens);
        }
        else {
            push @$loc_path, $optimised, RelativeLocationPath($self, $tokens);
        }
    }
    else {
        push @$loc_path, RelativeLocationPath($self, $tokens);
    }
    
    return $loc_path;
}

sub optimise_descendant_or_self {
    my ($self, $tokens) = @_;
    
    debug("in SUB\n");
    
    my $tokpos = $self->{_tokpos};
    
    # // must be followed by a Step.
    if ($tokens->[$tokpos+1] && $tokens->[$tokpos+1] eq '[') {
        # next token is a predicate
        return;
    }
    elsif ($tokens->[$tokpos] =~ /^\.\.?$/) {
        # abbreviatedStep - can't optimise.
        return;
    }                                                                                              
    else {
        debug("Trying to optimise //\n");
        my $step = Step($self, $tokens);
        if ($step->{axis} ne 'child') {
            # can't optimise axes other than child for now...
            $self->{_tokpos} = $tokpos;
            return;
        }
        $step->{axis} = 'descendant';
        $step->{axis_method} = 'axis_descendant';
        $self->{_tokpos}--;
        $tokens->[$self->{_tokpos}] = '.';
        return $step;
    }
}

sub RelativeLocationPath {
    my ($self, $tokens) = @_;
    
    debug("in SUB\n");
    
    my @steps;
    
    push @steps, Step($self, $tokens);
    while (match($self, $tokens, '//?')) {
        if ($self->{_curr_match} eq '//') {
            my $optimised = optimise_descendant_or_self($self, $tokens);
            if (!$optimised) {
                push @steps, XML::XPath::Step->new($self, 'descendant-or-self',
                                        XML::XPath::Step::test_nt_node);
            }
            else {
                push @steps, $optimised;
            }
        }
        push @steps, Step($self, $tokens);
        if (@steps > 1 && 
                $steps[-1]->{axis} eq 'self' && 
                $steps[-1]->{test} == XML::XPath::Step::test_nt_node) {
            pop @steps;
        }
    }
    
    return @steps;
}

sub Step {
    my ($self, $tokens) = @_;

    debug("in SUB\n");
    
    if (match($self, $tokens, '\\.')) {
        # self::node()
        return XML::XPath::Step->new($self, 'self', XML::XPath::Step::test_nt_node);
    }
    elsif (match($self, $tokens, '\\.\\.')) {
        # parent::node()
        return XML::XPath::Step->new($self, 'parent', XML::XPath::Step::test_nt_node);
    }
    else {
        # AxisSpecifier NodeTest Predicate(s?)
        my $token = $tokens->[$self->{_tokpos}];
        
        debug("SUB: Checking $token\n");
        
        my $step;
        if ($token eq 'processing-instruction') {
            $self->{_tokpos}++;
            match($self, $tokens, '\\(', 1);
            match($self, $tokens, $LITERAL);
            $self->{_curr_match} =~ /^["'](.*)["']$/;
            $step = XML::XPath::Step->new($self, 'child',
                                    XML::XPath::Step::test_nt_pi,
                        XML::XPath::Literal->new($1));
            match($self, $tokens, '\\)', 1);
        }
        elsif ($token =~ /^\@($NCWild|$QName|$QNWild)$/o) {
            $self->{_tokpos}++;
                        if ($token eq '@*') {
                            $step = XML::XPath::Step->new($self,
                                    'attribute',
                                    XML::XPath::Step::test_attr_any,
                                    '*');
                        }
                        elsif ($token =~ /^\@($NCName):\*$/o) {
                            $step = XML::XPath::Step->new($self,
                                    'attribute',
                                    XML::XPath::Step::test_attr_ncwild,
                                    $1);
                        }
                        elsif ($token =~ /^\@($QName)$/o) {
                            $step = XML::XPath::Step->new($self,
                                    'attribute',
                                    XML::XPath::Step::test_attr_qname,
                                    $1);
                        }
        }
        elsif ($token =~ /^($NCName):\*$/o) { # ns:*
            $self->{_tokpos}++;
            $step = XML::XPath::Step->new($self, 'child', 
                                XML::XPath::Step::test_ncwild,
                                $1);
        }
        elsif ($token =~ /^$QNWild$/o) { # *
            $self->{_tokpos}++;
            $step = XML::XPath::Step->new($self, 'child', 
                                XML::XPath::Step::test_any,
                                $token);
        }
        elsif ($token =~ /^$QName$/o) { # name:name
            $self->{_tokpos}++;
            $step = XML::XPath::Step->new($self, 'child', 
                                XML::XPath::Step::test_qname,
                                $token);
        }
        elsif ($token eq 'comment()') {
                    $self->{_tokpos}++;
            $step = XML::XPath::Step->new($self, 'child',
                            XML::XPath::Step::test_nt_comment);
        }
        elsif ($token eq 'text()') {
            $self->{_tokpos}++;
            $step = XML::XPath::Step->new($self, 'child',
                    XML::XPath::Step::test_nt_text);
        }
        elsif ($token eq 'node()') {
            $self->{_tokpos}++;
            $step = XML::XPath::Step->new($self, 'child',
                    XML::XPath::Step::test_nt_node);
        }
        elsif ($token eq 'processing-instruction()') {
            $self->{_tokpos}++;
            $step = XML::XPath::Step->new($self, 'child',
                    XML::XPath::Step::test_nt_pi);
        }
        elsif ($token =~ /^$AXIS_NAME($NCWild|$QName|$QNWild|$NODE_TYPE)$/o) {
                    my $axis = $1;
                    $self->{_tokpos}++;
                    $token = $2;
            if ($token eq 'processing-instruction') {
                match($self, $tokens, '\\(', 1);
                match($self, $tokens, $LITERAL);
                $self->{_curr_match} =~ /^["'](.*)["']$/;
                $step = XML::XPath::Step->new($self, $axis,
                                        XML::XPath::Step::test_nt_pi,
                            XML::XPath::Literal->new($1));
                match($self, $tokens, '\\)', 1);
            }
            elsif ($token =~ /^($NCName):\*$/o) { # ns:*
                $step = XML::XPath::Step->new($self, $axis, 
                                    (($axis eq 'attribute') ? 
                                    XML::XPath::Step::test_attr_ncwild
                                        :
                                    XML::XPath::Step::test_ncwild),
                                    $1);
            }
            elsif ($token =~ /^$QNWild$/o) { # *
                $step = XML::XPath::Step->new($self, $axis, 
                                    (($axis eq 'attribute') ?
                                    XML::XPath::Step::test_attr_any
                                        :
                                    XML::XPath::Step::test_any),
                                    $token);
            }
            elsif ($token =~ /^$QName$/o) { # name:name
                $step = XML::XPath::Step->new($self, $axis, 
                                    (($axis eq 'attribute') ?
                                    XML::XPath::Step::test_attr_qname
                                        :
                                    XML::XPath::Step::test_qname),
                                    $token);
            }
            elsif ($token eq 'comment()') {
                $step = XML::XPath::Step->new($self, $axis,
                                XML::XPath::Step::test_nt_comment);
            }
            elsif ($token eq 'text()') {
                $step = XML::XPath::Step->new($self, $axis,
                        XML::XPath::Step::test_nt_text);
            }
            elsif ($token eq 'node()') {
                $step = XML::XPath::Step->new($self, $axis,
                        XML::XPath::Step::test_nt_node);
            }
            elsif ($token eq 'processing-instruction()') {
                $step = XML::XPath::Step->new($self, $axis,
                        XML::XPath::Step::test_nt_pi);
            }
            else {
                die "Shouldn't get here";
            }
        }
        else {
            die "token $token doesn't match format of a 'Step'\n";
        }
        
        while (match($self, $tokens, '\\[')) {
            push @{$step->{predicates}}, Expr($self, $tokens);
            match($self, $tokens, '\\]', 1);
        }
        
        return $step;
    }
}

sub is_step {
    my ($self, $tokens) = @_;
    
    my $token = $tokens->[$self->{_tokpos}];
    
    return unless defined $token;
        
    debug("SUB: Checking if '$token' is a step\n");
    
        local $^W;
        
    if ($token eq 'processing-instruction') {
        return 1;
    }
    elsif ($token =~ /^\@($NCWild|$QName|$QNWild)$/o) {
        return 1;
    }
    elsif ($token =~ /^($NCWild|$QName|$QNWild)$/o && $tokens->[$self->{_tokpos}+1] ne '(') {
        return 1;
    }
    elsif ($token =~ /^$NODE_TYPE$/o) {
        return 1;
    }
    elsif ($token =~ /^$AXIS_NAME($NCWild|$QName|$QNWild|$NODE_TYPE)$/o) {
        return 1;
    }
    
    debug("SUB: '$token' not a step\n");

    return;
}

sub debug {
    return unless $XML::XPath::Debug;
    
    my ($pkg, $file, $line, $sub) = caller(1);
    
    $sub =~ s/^$pkg\:://;
    
    while (@_) {
        my $x = shift;
        $x =~ s/\bPKG\b/$pkg/g;
        $x =~ s/\bLINE\b/$line/g;
        $x =~ s/\bSUB\b/$sub/g;
        print STDERR $x;
    }
}

1;
