use strict;
use warnings;
use FindBin;
use File::Spec;

push @INC, "." unless $INC[-1] eq ".";

$ENV{MT_TEST_MAIL_MODULES} = 'MIME::Lite Email::MIME';
$ENV{MT_TEST_SMTPS}        = 'starttls';

my $file = File::Spec->canonpath("$FindBin::Bin/30-mail-smtp.t");
do $file or die "$file: $!";
