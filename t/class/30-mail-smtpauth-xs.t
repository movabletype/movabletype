use strict;
use warnings;
use FindBin;
use File::Spec;

push @INC, "." unless $INC[-1] eq ".";

$ENV{MT_TEST_AUTHEN_SASL_XS} = 1;
$ENV{MT_TEST_SMTPAUTH}       = 'starttls';
$ENV{MT_TEST_SMTPUSER}       = 'mt';
$ENV{MT_TEST_SMTPPASSWORD}   = 'test';

my $file = File::Spec->canonpath("$FindBin::Bin/30-mail-smtp.t");
do $file or die "$file: $!";
