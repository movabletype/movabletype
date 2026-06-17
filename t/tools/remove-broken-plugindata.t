use strict;
use warnings;
use utf8;
use IPC::Run3 qw/run3/;
use File::Spec;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new();
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Fixture;

$test_env->prepare_fixture('db');

for my $plugin_name ('NotInstalled', 'FormattedText') {
    for (1 .. 3) {
        my $pd = MT::PluginData->new('plugin' => $plugin_name, 'key' => 'configuration:blog:10');
        $pd->save;
    }
    for (1 .. 3) {
        my $pd = MT::PluginData->new('plugin' => $plugin_name, 'key' => 'configuration');
        $pd->save;
    }
}

is(MT::PluginData->count(), 12, 'test data prepared');

{
    my $log_count = MT::Log->count();
    my ($stdin, $stdout, $stderr) = do_command();
    is(MT::PluginData->count(),       12, 'not deleted yet');
    is(MT::Log->count() - $log_count, 0,  'right number of logs left');

    ($stdin, $stdout, $stderr) = do_command(['--delete']);
    is(MT::PluginData->count(),                                                                       4, 'deleted');
    is(MT::PluginData->count({ plugin => 'NotInstalled', key => 'configuration:blog:10' }),  1, 'right record remains');
    is(MT::PluginData->count({ plugin => 'NotInstalled', key => 'configuration' }),          1, 'right record remains');
    is(MT::PluginData->count({ plugin => 'FormattedText', key => 'configuration:blog:10' }), 1, 'right record remains');
    is(MT::PluginData->count({ plugin => 'FormattedText', key => 'configuration' }),        1, 'right record remains');
    is(MT::Log->count() - $log_count,                                                                 2, 'right number of logs left');
    my @log = MT::Log->load({}, { sort => 'id', direction => 'decend', limit => 2 });
    is(scalar(split(',', ($log[0]->metadata =~ /keys:(.+)/)[0])), 2, 'right number of ids in metadata');
    is(scalar(split(',', ($log[1]->metadata =~ /keys:(.+)/)[0])), 2, 'right number of ids in metadata');

    ($stdin, $stdout, $stderr) = do_command(['--delete']);
    is(MT::PluginData->count(), 4, 'no more deletion');
}

{
    my $log_count = MT::Log->count();
    my $pd        = MT::PluginData->new('plugin' => 'NotInstalled', 'key' => 'configuration:blog:100');
    $pd->data(\'1');    # broken data emulation
    $pd->save;
    is(MT::PluginData->count(), 5, 'added');
    my ($stdin, $stdout, $stderr) = do_command(['--delete']);
    is(MT::PluginData->count(),                                                                       4, 'deleted');
    is(MT::PluginData->count({ plugin => 'NotInstalled', key => 'configuration:blog:10' }),  1, 'right record remains');
    is(MT::PluginData->count({ plugin => 'NotInstalled', key => 'configuration' }),          1, 'right record remains');
    is(MT::PluginData->count({ plugin => 'FormattedText', key => 'configuration:blog:10' }), 1, 'right record remains');
    is(MT::PluginData->count({ plugin => 'FormattedText', key => 'configuration' }),        1, 'right record remains');
    is(MT::Log->count() - $log_count,                                                                 1, 'right number of logs left');
    my @log = MT::Log->load({}, { sort => 'id', direction => 'decend', limit => 1 });
    is(scalar(split(',', ($log[0]->metadata =~ /keys:(.+)/)[0])), 2, 'right number of ids in metadata');
}

sub do_command {
    my ($cmd_options) = @_;
    my @cmd = (
        $^X, '-I',
        File::Spec->catdir($ENV{MT_HOME}, 't/lib'),
        File::Spec->catfile($ENV{MT_HOME}, 'tools/remove-broken-plugindata'),
        @{ $cmd_options || [] },
    );

    run3 \@cmd, \my $stdin, \my $stdout, \my $stderr;
    note $stderr if $stderr;

    # Since ODBC driver seems to be fork-unsafe, dbh must be destroyed after forking process so that MT::Object will establish new one.
    MT::Blog->driver->dbh(undef) if MT->config->ODBCDriver;

    return $stdin, $stdout, $stderr;
}

done_testing;
