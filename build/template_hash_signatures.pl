#!/usr/bin/perl

use strict;
use lib 'lib';
use Digest::SHA1 qw(sha1_hex);
require MT;
require MT::DefaultTemplates;
my $mt = new MT() or die MT->errstr;

my $langs = MT->supported_languages;
my @langs = keys %$langs;

my $tmpls = MT::DefaultTemplates->templates;

print "    # " . MT->version_number . "\n";
foreach my $tmpl (@$tmpls) {
    my $text = $tmpl->{text};
    my $name = $tmpl->{name};
    my $type = $tmpl->{type};
    my %sigs;
    foreach my $lang (@langs) {
        MT->set_language($lang);
        my $tmpl_text = MT->translate_templatized($text);
        $tmpl_text =~ s/\s+//g;
        my $sha1 = sha1_hex($tmpl_text);
        $sigs{$sha1} = 1;
    }
    foreach (sort keys %sigs) {
        print "    \$dict->{'$type'}{'$name'}{'$_'} = 1;\n";
    }
}
