package Lucene::QueryParser;

use 5.00503;
use strict;
use Carp;

require Exporter;
use Text::Balanced qw(extract_bracketed extract_delimited);

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);
@ISA = qw(Exporter);
@EXPORT_OK = qw( parse_query deparse_query );
@EXPORT = qw( parse_query deparse_query );
$VERSION = '1.04';

sub parse_query {
    local $_ = shift;
    my @rv;
    while ($_) {
        s/^\s+// and next;
        my $item;
        s/^(AND|OR|\|\|)\s+//;
        if ($1)                   { $item->{conj} = $1; }
        if (s/^\+//)              { $item->{type} = "REQUIRED";   }
        elsif (s/^(-|!|NOT)\s*//i){ $item->{type} = "PROHIBITED"; }
        else                      { $item->{type} = "NORMAL";     }

        if (s/^([^\s(":]+)://)      { $item->{field} = $1 }

        # Subquery
        if (/^\(/) {
            my ($extracted, $remainer) = extract_bracketed($_,"(");
            if (!$extracted) { croak "Unbalanced subquery" }
            $_ = $remainer;
            $extracted =~ s/^\(//;
            $extracted =~ s/\)$//;
            $item->{query} = "SUBQUERY";
            $item->{subquery} = parse_query($extracted);
        } elsif (/^"/) {
            my ($extracted, $remainer) = extract_delimited($_, '"');
            if (!$extracted) { croak "Unbalanced phrase" }
            $_ = $remainer;
            $extracted =~ s/^"//;
            $extracted =~ s/"$//;
            $item->{query} = "PHRASE";
            $item->{term} = $extracted;
        } elsif (s/^(\S+)\*//) {
            $item->{query} = "PREFIX";
            $item->{term} = $1;
        } else {
            s/([^\s\^]+)// or croak "Malformed query";
            $item->{query} = "TERM";
            $item->{term} = $1;
        }

        if (s/^\^(\d+(?:.\d+)?)//)  { $item->{boost} = $1 }

        push @rv, bless $item, "Lucene::QueryParser::".ucfirst lc $item->{query};
    }
    return bless \@rv, "Lucene::QueryParser::TopLevel";
}

sub deparse_query {
    my $ds = shift;
    my @out; 
    for my $elem (@$ds) {
        my $thing = "";
        if ($elem->{conj}) { $thing .= "$elem->{conj} "; }
        if ($elem->{type} eq "REQUIRED") {
            $thing .= "+";
        } elsif ($elem->{type} eq "PROHIBITED") {
            $thing .= "-";
        }
        if (exists $elem->{field}) { 
            $thing .= $elem->{field}.":"
        }
        if ($elem->{query} eq "TERM") {
            $thing .= $elem->{term};
        } elsif ($elem->{query} eq "SUBQUERY") {
            $thing .= "(".deparse_query($elem->{subquery}).")";
        } elsif ($elem->{query} eq "PHRASE") {
            $thing .= '"'.$elem->{term}.'"';
        }
        if (exists $elem->{boost}) { $thing .= "^".$elem->{boost} }
        push @out, $thing;
    }
    return join " ", @out;
}

package Lucene::QueryParser::TopLevel;

sub to_plucene {
    my ($self, $field) = @_;
    Carp::croak("You need to specify a default field for your query")
        unless $field;
    return $self->[0]->to_plucene($field) 
        if @$self ==1 and $self->[0]->{type} eq "NORMAL";

    my @clauses;
    $self->add_clause(\@clauses, $_, $field) for @$self;
    require Plucene::Search::BooleanQuery;
    my $query = new Plucene::Search::BooleanQuery;
    $query->add_clause($_) for @clauses;
    
    $query;
}

sub add_clause {
    my ($self, $clauses, $term, $field) = @_;
    my $q = $term->to_plucene($field);
    if (exists $term->{conj} and $term->{conj} eq "AND" and @$clauses) { 
        # The previous term needs to become required
        $clauses->[-1]->required(1) unless $clauses->[-1]->prohibited;
    }

    return unless $q; # Shouldn't happen yet
    my $prohibited = $term->{type} eq "PROHIBITED";
    my $required   = $term->{type} eq "REQUIRED";
    $required = 1 if exists $term->{conj} and $term->{conj} eq "AND" 
                     and !$prohibited;
    require Plucene::Search::BooleanClause;
    push @$clauses, Plucene::Search::BooleanClause->new({
        prohibited => $prohibited,
        required   => $required,
        query      => $q
    });
}

# Oh, I really like abstraction

package Lucene::QueryParser::Term;

sub to_plucene {
    require Plucene::Search::TermQuery;
    require Plucene::Index::Term;
    my ($self, $field) = @_;
    $self->{pl_term} = Plucene::Index::Term->new({
        field => (exists $self->{field} ? $self->{field} : $field),
        text => $self->{term}
    });
    my $q = Plucene::Search::TermQuery->new({ term => $self->{pl_term} });
    $self->set_boost($q);
    return $q;
}

sub set_boost {
    my ($self, $q) = @_;
    $q->boost($self->{boost}) if exists $self->{boost};
}

package Lucene::QueryParser::Phrase;
our @ISA = qw(Lucene::QueryParser::Term);
# This corresponds to the rules for "PHRASE" in the Plucene grammar

sub to_plucene {
    require Plucene::Search::PhraseQuery;
    require Plucene::Index::Term;
    my ($self, $field) = @_;
    my @words = split /\s+/, $self->{term};
    return $self->SUPER::to_plucene($field) if @words == 1;

    my $phrase = Plucene::Search::PhraseQuery->new;
    for my $word (@words) {
        my $term = Plucene::Index::Term->new({
            field => (exists $self->{field} ? $self->{field} : $field),
            text => $word
        });
        $phrase->add($term);
    }
    if (exists $self->{slop}) { # Future extension
        $phrase->slop($self->{slop});
    }
    $self->set_boost($phrase);
    return $phrase;
}

package Lucene::QueryParser::Subquery;

sub to_plucene {
    my ($self, $field) = @_;
    $self->{subquery}->to_plucene(
        exists $self->{field} ? $self->{field} : $field
    )
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Lucene::QueryParser - Turn a Lucene query into a Perl data structure

=head1 SYNOPSIS

  use Lucene::QueryParser;
  my $structure = parse_query("red and yellow and -(coat:pink and green)");

C<$structure> will be:

 [ { query => 'TERM', type => 'NORMAL', term => 'red' },
   { query => 'TERM', type => 'NORMAL', term => 'yellow' },
   { subquery => [
        { query => 'TERM', type => 'NORMAL', term => 'pink', field => 'coat' },
        { query => 'TERM', type => 'NORMAL', term => 'green' }
     ], query => 'SUBQUERY', type => 'PROHIBITED' 
   }
 ]

=head1 DESCRIPTION

This module parses a Lucene query, as defined by 
http://lucene.sourceforge.net/cgi-bin/faq/faqmanager.cgi?file=chapter.search&toc=faq#q5

It deals with fields, types, phrases, subqueries, and so on; everything
handled by the C<SimpleQuery> class in Lucene. The data structure is similar
to the one given above, and is pretty self-explanatory.

The other function, C<deparse_query> turns such a data structure back into
a Lucene query string. This is useful if you've just been mucking about
with the data.

=head2 PLUCENE

Note for people using Plucene: the big arrayref and the hashes in the
output of C<parse_query> are actually objects. They're not
C<Plucene::Query> objects, because then everyone who wanted to do search
queries would have to pull in Plucene, which is a bit unfair. However,
they can be turned into C<Plucene::Query>s by calling C<to_plucene> on
them. The argument to C<to_plucene> should be the default field to
search if none is supplied.

=head2 EXPORT

Exports the C<parse_query> and C<deparse_query> functions.

=head1 AUTHOR

Simon Cozens, E<lt>simon@kasei.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by Kasei

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
