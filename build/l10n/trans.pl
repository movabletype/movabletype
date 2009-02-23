#!/usr/bin/perl

# Movable Type (r) Open Source (C) 2005-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

use strict;

use lib './lib';
use lib './extlib';
$| = 1;

use Getopt::Long;

my $L10N_FILE = 'lib/MT/L10N/ja.pm';

GetOptions(
    't:s' => \$L10N_FILE,
);

my %conv;
my %lconv;

eval {
    require "$L10N_FILE";
};
if ($@) {
    die "Failed to load $L10N_FILE: $@";
}

my $lang = $L10N_FILE;
$lang =~ s!^lib/MT/L10N/!!;
$lang =~ s!\.pm$!!;
no strict 'refs';
%conv = %{'MT::L10N::' . $lang . '::Lexicon'};
foreach (keys %conv) {
    $lconv{lc $_} = $conv{$_};
    my $key = $_;
    my $key_esc = $key;
    my $value_esc = $conv{$key};
    $key_esc =~ s/\'/\\'/sg;
    $conv{$key_esc}=$value_esc;
    $key_esc = $key;
    $key_esc =~ s/\n/\\n/sg;
    $conv{$key_esc}=$value_esc;    
    $key_esc = $key;
    $key_esc =~ s/\"/\\"/sg;
    $conv{$key_esc}=$value_esc;
}

my (%phrase, %is_used, $args);
my $text = <>;
my $tmpl = $ARGV;
exit unless $text;
do {
    if (($tmpl ne $ARGV) || eof()) {
        #printf "\n\t## %s\n", $tmpl;
        printf "\n## %s\n", $tmpl;
        $tmpl = $ARGV;
        if ( $tmpl =~ m|plugins/([\-\w]+)/\w+| ) {
            my $plugin = $1;
            eval { 
                unshift @INC, "plugins/$plugin/lib";
            };
            eval {
                require "plugins/$plugin/lib/$plugin/L10N/$lang.pm";
            };
            if ($@) {
                # Deep dive into sub directories to find L10N
                my $path = "plugins/$plugin/lib";
                $path = find_l10n_dir($path);
                if ( $path && ($path =~ /L10N$/) ) {
                    eval {
                        require "$path/$lang.pm";
                    };
                    if ($@) {
                        $plugin = undef;
                    }
                    else {
                        $path =~ s|plugins/$plugin/lib/||g;
                        $path =~ s|/|::|g;
                        $plugin = $path;
                    }
                }
                else {
                    $plugin = undef;
                }
            }
            else {
                $plugin .= '::L10N';
            }
            if ($plugin) {
                %conv = (
                    %conv,
                    %{$plugin . '::' . $lang . '::Lexicon'},
                );
            }
        }
        elsif ( $tmpl =~ m|addons/(\w+)\.pack/\w+| ) {
            my $addon = $1;
            eval { 
                unshift @INC, "addons/$addon.pack/lib";
                require "addons/$addon.pack/lib/MT/$addon/L10N/$lang.pm"
            };
            unless ($@) {
                %conv = (
                    %conv,
                    %{'MT::' . $addon . '::L10N::' . $lang . '::Lexicon'},
                );
            }
        }
        %phrase = ();
        my $t;
        while ($text =~ m!(<(?:_|MT)_TRANS(?:\s+((?:\w+)\s*=\s*(["'])(?:<[^>]+?>|[^\3]+?)*?\3))+?\s*/?>)!igm) {
            my($msg, %args) = ($1);
            while ($msg =~ /\b(\w+)\s*=\s*(["'])((?:<[^>]+?>|[^\2])*?)?\2/g) {  #'
                $args{$1} = $3;
            }
            my $trans = '';
            if (exists $args{phrase}) {
                if ($trans eq '' && $conv{$args{phrase}}) {
                     $trans = $conv{$args{phrase}};
                     $is_used{$args{phrase}} = 1;
                }
                $trans =~ s/([^\\]?)'/$1\\'/g;
                $args{phrase} =~ s/([^\\])'/$1\\'/g;
                $args{phrase} =~ s/\\"/"/g;
		
                unless ($phrase{$args{phrase}}) {
                    $phrase{$args{phrase}} = 1;
                    
                    my $q = "'";
                    if ($args{phrase} =~ /\\n/) {
                       $q = '"';
                    }
                    if ($args{phrase} =~ /[^\\]'/) {
                       $q = '"';
                    }

                    if ($trans) {
                        printf "\t$q%s$q => '%s',\n", $args{phrase}, $trans; # Print out translation if there was an existing one
                    } else {
                        $trans = $lconv{lc $args{phrase}};
			$trans =~ s/([^\\]?)'/$1\\'/g;
			my $reason = $trans?'Case':'New'; # Really new translation or just different case
                        printf "\t$q%s$q => '%s', # Translate - $reason\n", $args{phrase}, $trans; # Print out translation if there was an existing one based on the lowercase string, empty otherwise
                    }
                }
            }
        }
        while ($text =~ /(?:translate|errtrans|trans_error|trans|translate_escape|maketext)\s*\(((?:\s*(?:"(?:[^"\\]+|\\.)*"|'(?:[^'\\]+|\\.)*')\s*\.?\s*){1,})[,\)]/gs) {
            my($msg, %args);
            my $p = $1;
            while ($p =~ /"((?:[^"\\]+|\\.)*)"|'((?:[^'\\]+|\\.)*)'/gs) {
                $args{'phrase'} .= ($1 || $2);
            }          
            my $trans = '';
            $args{phrase} =~ s/([^\\]?)'/$1\\'/g;
            $args{phrase} =~ s/['"]\s*.\s*\n\s*['"]//gs;
            $args{phrase} =~ s/['"]\s*\n\s*.\s*['"]//gs;
            my $phrase = $args{phrase};
            $phrase =~ s/\\?\\'/'/g;
            if ($trans eq '' && $conv{$phrase}) {
                 $trans = $conv{$phrase};
                 $is_used{$phrase} = 1;
            }
            $trans =~ s/([^\\]?)'/$1\\'/g;
            next if ($phrase{$args{phrase}});
            $phrase{$args{phrase}} = 1;
            my $q = "'";
            if ($args{phrase} =~ /\\n|[^\\]'/) {
               $q = '"';
            }
            $args{phrase} =~ s/\\\\'/\\'/g;
            if ($trans) {
                printf "\t$q%s$q => $q%s$q,\n", $args{phrase}, $trans; # Print out the translation if there was an existing one
            } else {
                $trans = $lconv{lc $args{phrase}} || '';
                my $reason = $trans ? "Case" : "New"; # New translation, or just different case?
                printf "\t$q%s$q => $q%s$q, # Translate - $reason\n", $args{phrase}, $trans; # Print out the translation if there was an existing one based on the lowercase string, else empty
            }
        }
        while ($text =~ /\s*label\s*=>\s*(["'])(.*?)([^\\])\1/gs) { 
            my($msg, %args);
            my $trans = '';
            $args{phrase} = $2.$3;

            if ($trans eq '' && $conv{$args{phrase}}) {
                 $trans = $conv{$args{phrase}};
                 $is_used{$args{phrase}} = 1;
            }
            $trans =~ s/([^\\]?)'/$1\\'/g;
            next if ($phrase{$args{phrase}});
            $phrase{$args{phrase}} = 1;
            my $q = "'";
            if ($args{phrase} =~ /\\n/) {
               $q = '"';
            }
            if ($trans) {
                printf "\t$q%s$q => '%s',\n", $args{phrase}, $trans; # Print out the translation if there was an existing one
            } else {
                $trans = $lconv{lc $args{phrase}} || '';
                my $reason = $trans ? "Case" : "New"; # New translation, or just different case?
                printf "\t$q%s$q => '%s', # Translate - $reason\n", $args{phrase}, $trans; # Print out the translation if there was an existing one based on the lowercase string, else empty
            }
        }
        if ($tmpl =~ /(services|streams)\.yaml$/) {
            while ($text =~ /\s*(?:description|ident_hint|label|name):\s*(.+)/g) { 
                my($msg, %args);
                my $trans = '';
                $args{phrase} = $1;
                $args{phrase} =~ s/(^'+|'+$)//;
                $args{phrase} =~ s/'/\\'/g;
                if ($trans eq '' && $conv{$args{phrase}}) {
                     $trans = $conv{$args{phrase}};
                     $is_used{$args{phrase}} = 1;
                }
                $trans =~ s/([^\\]?)'/$1\\'/g;
                next if ($phrase{$args{phrase}});
                $phrase{$args{phrase}} = 1;
                my $q = "'";
                if ($args{phrase} =~ /\\n/) {
                   $q = '"';
                }
                if ($trans) {
                    printf "\t$q%s$q => '%s',\n", $args{phrase}, $trans; # Print out the translation if there was an existing one
                } else {
                    $trans = $lconv{lc $args{phrase}} || '';
                    my $reason = $trans ? "Case" : "New"; # New translation, or just different case?
                    printf "\t$q%s$q => '%s', # Translate - $reason\n", $args{phrase}, $trans; # Print out the translation if there was an existing one based on the lowercase string, else empty
                }
            }
        }
        elsif ($tmpl =~ /\.yaml$/) {
            while ($text =~ /\s*label:\s*(.+)/g) { 
                my($msg, %args);
                my $trans = '';
                $args{phrase} = $1;
                $args{phrase} =~ s/(^'+|'+$)//;
                $args{phrase} =~ s/'/\\'/g;
                if ($trans eq '' && $conv{$args{phrase}}) {
                     $trans = $conv{$args{phrase}};
                     $is_used{$args{phrase}} = 1;
                }
                $trans =~ s/([^\\]?)'/$1\\'/g;
                next if ($phrase{$args{phrase}});
                $phrase{$args{phrase}} = 1;
                my $q = "'";
                if ($args{phrase} =~ /\\n/) {
                   $q = '"';
                }
                if ($trans) {
                    printf "\t$q%s$q => '%s',\n", $args{phrase}, $trans; # Print out the translation if there was an existing one
                } else {
                    $trans = $lconv{lc $args{phrase}} || '';
                    my $reason = $trans ? "Case" : "New"; # New translation, or just different case?
                    printf "\t$q%s$q => '%s', # Translate - $reason\n", $args{phrase}, $trans; # Print out the translation if there was an existing one based on the lowercase string, else empty
                }
            }
        }
        $text = '';
    }
    $text .= $_ if $_;
} while (<>);
exit;

print "\n\n\t## not used\n";
foreach my $p (keys %conv) {
    $p =~ s/([^\\])'/$1\\'/g;
    unless ($is_used{$p}) {
        my $trans = '';
        if ($conv{$p}) {
             $trans = $conv{$p};
             $is_used{$p} = 0;
        }
        my $q = "'";
        if ($p =~ /\\[a-z]/) {
            $q = '"';    
        }
        $trans =~ s/([^\\])'/$1\\'/g;
	printf "\t$q%s$q => '%s',\n", $p, '';#$trans;
    #printf "\nmsgid \"%s\"\nmsgstr \"%s\"\n", $p, $trans;
    }
}

sub find_l10n_dir {
    my ($path) = @_;
    return 0 unless -d $path;
    if ( opendir my $dh, $path ) {
        my @items = readdir $dh;
        closedir $dh;
        for my $item (@items) {
            next if ( $item =~ /^\.\.?$/ || $item =~ /~$/ );
            require File::Spec;
            my $full_path = File::Spec->catfile( $path, $item );
            next if ( -f $full_path );
            if ( ( $item eq 'L10N' ) && -d $full_path ) {
                return $full_path;
            }
            if ( my $found = find_l10n_dir($full_path) ) {
                return $found;
            }
        }
    }
    return 0;
}

1;
