##
## Czech tables
##
## Contributed by Honza Pazdziora

package Date::Language::Czech;

use strict;
use warnings;
use utf8;
use Date::Language ();

use base 'Date::Language';

our $VERSION = '2.35'; # VERSION: generated
# ABSTRACT: Czech localization for Date::Format

our @MoY = qw(leden únor bøezen duben kvìten èerven èervenec srpen záøí
          øíjen listopad prosinec);
our @MoYs = qw(led únor bøe dub kvì èvn èec srp záøí øíj lis pro);
our @MoY2 = @MoY;
for (@MoY2)
      { s!en$!na! or s!ec$!ce! or s!ad$!adu! or s!or$!ora!; }

our @DoW = qw(nedìle pondìlí úterý støeda ètvrtek pátek sobota);
our @DoWs = qw(Ne Po Út St Èt Pá So);

our @AMPM = qw(dop. odp.);

our ( %MoY, %DoW );
Date::Language::_build_lookups();

# Formatting routines

sub format_a { $DoWs[$_[0]->[6]] }
sub format_A { $DoW[$_[0]->[6]] }
sub format_b { $MoYs[$_[0]->[4]] }
sub format_B { $MoY[$_[0]->[4]] }
sub format_h { $MoYs[$_[0]->[4]] }
sub format_p { $_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0] }

sub format_d { $_[0]->[3] }
sub format_m { $_[0]->[4] + 1 }
sub format_o { $_[0]->[3] . '.' }

sub format_Q { $MoY2[$_[0]->[4]] }

sub time2str {
      my $ref = shift;
      my @a = @_;
      $a[0] =~ s/(%[do]\.?\s?)%B/$1%Q/;
      $ref->SUPER::time2str(@a);
      }

sub strftime {
      my $ref = shift;
      my @a = @_;
      $a[0] =~ s/(%[do]\.?\s?)%B/$1%Q/;
      $ref->SUPER::time2str(@a);
      }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Date::Language::Czech - Czech localization for Date::Format

=head1 VERSION

version 2.35

=head1 AUTHOR

Graham <gbarr@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Barr.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
