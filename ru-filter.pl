#!/usr/bin/perl 

#
# Copyright (c) 2008, Alex L. Demidov (http://alexd.vinf.ru/)
#
# This program is free software, you can redistribute it and/or 
# modify it under the terms of the BSD License.
# 

use utf8;
use strict;
use warnings;
use Encode;

while (<STDIN>) {
    chomp;
    my $l = $_;

    if ($l =~ /## The following is the translation table./) {
        print <<'EOF';
sub quant {
    my($handle, $num, @forms) = @_;

    return $num if @forms == 0; # what should this mean?

    # Note that the formatting of $num is preserved.
    return( $handle->numf($num) . ' ' . $handle->numerate($num, @forms) );
    # Most human languages put the number phrase before the qualified phrase.
}

sub numerate {
    # return this lexical item in a form appropriate to this number
    my($handle, $num, @forms) = @_;
    my $s = ($num == 1);

    return '' unless @forms;

    return $forms[0] if $num =~ /^([0-9]*?[02-9])?1$/; 
    return $forms[0] if ( @forms == 1);

    return $forms[1] if $num =~ /^([0-9]*?[02-9])?[234]$/; 
    return $forms[1] if ( @forms == 2);
    return $forms[2];
}
        
EOF
        print $l, "\n";
    } ## end if ($l =~ /## The following is the translation table./)
    elsif ($l =~ /^[#\s]*'(.+)'\s*=>\s*'(.*)'\s*,\s*(#.*)?\s*$/) {
        my $base    = $1;
        my $trans   = $2;
        my $comment = $3;
        my $disable = q{};

        if (!defined $trans || $trans eq q{}) {
            $comment = '# Translate - Empty';
            $disable = q{#};
        }
        elsif ($base eq $trans) {
            $comment = '# Translate - Not translated';
        }
        elsif ($base =~ /[a-zA-Z]/ && !is_rus($trans)) {
            $comment = '# Translate - No russian chars';
        }

        if (defined $comment) {
            printf "%s\t'%s' => '%s', %s\n", $disable, $base, $trans, $comment;
        }
        else {
            print $l, "\n";
        }
    }
    else {
        print $l, "\n";
    }
} ## end while (<STDIN>)

sub is_rus {
    my ($str) = @_;
    $str = decode_utf8($str);
    if ($str =~
/.*[АБВГДЕЁЖЗИИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯабвгдеёжзийклмнопрстуфхцчшщьыъэюя]+.*/
      )
    {
        return 1;
    }
    return 0;
}
