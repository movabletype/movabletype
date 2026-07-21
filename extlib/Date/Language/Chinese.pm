##
## English tables
##

package Date::Language::Chinese;

use strict;
use warnings;
use utf8;
use Date::Language ();

use base qw(Date::Language);

our $VERSION = '2.35'; # VERSION: generated
# ABSTRACT: Chinese localization for Date::Format

our @DoW = qw(星期日 星期一 星期二 星期三 星期四 星期五 星期六);
our @MoY = qw(一月 二月 三月 四月 五月 六月
      七月 八月 九月 十月 十一月 十二月);
our @DoWs = map { $_ } @DoW;
our @MoYs = map { $_ } @MoY;
our @AMPM = qw(上午 下午);

our @Dsuf = (qw(日 日 日 日 日 日 日 日 日 日)) x 3;

our ( %MoY, %DoW );
Date::Language::_build_lookups();

# Formatting routines

sub format_a { $DoWs[$_[0]->[6]] }
sub format_A { $DoW[$_[0]->[6]] }
sub format_b { $MoYs[$_[0]->[4]] }
sub format_B { $MoY[$_[0]->[4]] }
sub format_h { $MoYs[$_[0]->[4]] }
sub format_p { $_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0] }

sub format_o { sprintf("%2d%s",$_[0]->[3],"日") }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Date::Language::Chinese - Chinese localization for Date::Format

=head1 VERSION

version 2.35

=head1 AUTHOR

Graham <gbarr@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Barr.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
