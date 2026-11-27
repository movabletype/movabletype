use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

local $ENV{MT_USE_EXCEPTION_OBJECT} = 1;
local $ENV{MT_WARN_UNRESOLVED_ERROR} = 1;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;

    plan skip_all => 'for MySQL only' unless lc $test_env->driver eq 'mysql';
}

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Test::Upgrade;

$test_env->prepare_fixture('db');

require MT::Upgrade;
MT->add_callback('core_upgrade_end', 10, 'MT::Upgrade' => sub {
    my ($cb, @rest) = @_;
print STDERR "\n\n\nCALLBACK IS CALLED\n\n\n";
require Data::Dump;
print STDERR Data::Dump::dump(\@rest);
    print STDERR "ERROR AT CALLBACK: ", MT::Upgrade->errstr, "\n\n\n";
});

subtest 'upgrade' => sub {
    my $dbh = MT::Object->driver->rw_handle;
    $dbh->do('create index entry_basename on mt_entry (entry_basename)');

    my @dying_msg;
    local $SIG{__DIE__} = sub { push @dying_msg, @_ };

    MT::Test::Upgrade->upgrade(from => 8.0000);
    ok !@dying_msg, "no dying messages";

    my $indices = $dbh->selectall_arrayref('show index from mt_entry', { Slice => +{} });
    my ($found) = grep { $_->{Key_name} eq 'entry_basename' } @$indices;
    ok $found, "entry_basename index remains intact";
};

done_testing;
