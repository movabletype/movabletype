##
## Chinese GB2312 tables (GB2312 byte encoding)
##

package Date::Language::Chinese_GB;

use strict;
use warnings;

use Date::Language ();

use base 'Date::Language';

our $VERSION = '2.35'; # VERSION: generated
# ABSTRACT: Chinese localization for Date::Format (GB2312)

our (@DoW, @DoWs, @MoY, @MoYs, @AMPM, @Dsuf, %MoY, %DoW);

@DoW = (
    "\xd0\xc7\xc6\xda\xc8\xd5",  # 星期日
    "\xd0\xc7\xc6\xda\xd2\xbb",  # 星期一
    "\xd0\xc7\xc6\xda\xb6\xfe",  # 星期二
    "\xd0\xc7\xc6\xda\xc8\xfd",  # 星期三
    "\xd0\xc7\xc6\xda\xcb\xc4",  # 星期四
    "\xd0\xc7\xc6\xda\xce\xe5",  # 星期五
    "\xd0\xc7\xc6\xda\xc1\xf9",  # 星期六
);

@MoY = (
    "\xd2\xbb\xd4\xc2",          # 一月
    "\xb6\xfe\xd4\xc2",          # 二月
    "\xc8\xfd\xd4\xc2",          # 三月
    "\xcb\xc4\xd4\xc2",          # 四月
    "\xce\xe5\xd4\xc2",          # 五月
    "\xc1\xf9\xd4\xc2",          # 六月
    "\xc6\xdf\xd4\xc2",          # 七月
    "\xb0\xcb\xd4\xc2",          # 八月
    "\xbe\xc5\xd4\xc2",          # 九月
    "\xca\xae\xd4\xc2",          # 十月
    "\xca\xae\xd2\xbb\xd4\xc2",  # 十一月
    "\xca\xae\xb6\xfe\xd4\xc2",  # 十二月
);

@DoWs = map { $_ } @DoW;
@MoYs = map { $_ } @MoY;

@AMPM = (
    "\xc9\xcf\xce\xe7",  # 上午
    "\xcf\xc2\xce\xe7",  # 下午
);

@Dsuf = ("\xc8\xd5") x 31;  # 日

Date::Language::_build_lookups();

# Formatting routines

sub format_a { $DoWs[$_[0]->[6]] }
sub format_A { $DoW[$_[0]->[6]] }
sub format_b { $MoYs[$_[0]->[4]] }
sub format_B { $MoY[$_[0]->[4]] }
sub format_h { $MoYs[$_[0]->[4]] }
sub format_p { $_[0]->[2] >= 12 ?  $AMPM[1] : $AMPM[0] }

sub format_o { sprintf("%2d%s",$_[0]->[3],"\xc8\xd5") }  # 日

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Date::Language::Chinese_GB - Chinese localization for Date::Format (GB2312)

=head1 VERSION

version 2.35

=head1 AUTHOR

Graham <gbarr@pobox.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Barr.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
