#!/usr/bin/perl -w
use strict;
use warnings;
use utf8;
use FindBin;
use lib ("$FindBin::Bin/../lib", "$FindBin::Bin/../extlib", "$FindBin::Bin/lib");
use Getopt::Long;
use feature qw(say);
use Module::Load '';
use MT::Bootstrap;
use MT;

BEGIN {
    $ENV{MT_CONFIG} = "$FindBin::Bin/../mt-config.cgi";
    $ENV{MT_HOME} = "$FindBin::Bin/../";
}

use MT::Test;

GetOptions(
    "help|?" => sub { usage(); exit },
);

my $class = $ARGV[0] or usage() and exit;
$class = 'MT::Test::Fixture::'. $class unless ($class =~ /^MT::Test::Fixture::/);
Module::Load::load($class);
$class->prepare_fixture;

my $author = MT->model('author')->load(1);
$author->name('Melody');
$author->set_password('Nelson');
$author->preferred_language('ja');
$author->save;

sub usage {
    print STDERR << "EOT";
usage:   perl $0 [fixture_class_id]
example: perl $0 ContentData
example: perl $0 Cms::Common1
EOT
}
