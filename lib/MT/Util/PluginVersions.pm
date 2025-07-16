# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
package MT::Util::PluginVersions;

use strict;
use warnings;
use File::Temp ();

sub plugin_versions_file {
    my $home = $ENV{MT_TEST_ROOT} || $ENV{MT_HOME} || '.';
    $home . '/PLUGIN_VERSIONS';
}

sub load_plugin_versions {
    my $file = plugin_versions_file();
    return unless -f $file;
    open my $fh, '<', $file or die "$!: $file";
    my %map;
    while (<$fh>) {
        chomp;
        next if /^#/ or /^\s*$/;
        my ($version, $plugin_sig) = split /\t/, $_;
        $map{$plugin_sig} = $version;
    }
    \%map;
}

sub update_plugin_versions {
    my $temp_dir = File::Temp::tempdir(CLEANUP => 1);
    my $cmd      = qq(touch ${temp_dir}/mtconf && MT_CONFIG=${temp_dir}/mtconf MT_CONFIG_ObjectDriver=DBI::sqlite MT_CONFIG_Database=${temp_dir}/mtdb perl -Iextlib -Ilib -MMT -E 'MT->new; map { say(\$_->version . "\t" . \$_->{plugin_sig}) } sort { \$a->{plugin_sig} cmp \$b->{plugin_sig} } grep { \$_ && \$_->isa("MT::Plugin") } map { \$MT::Plugins{\$_}->{object} } keys %MT::Plugins');
    my $result   = `$cmd`;

    my $file = plugin_versions_file();
    open my $out, '>', $file or die "$!: $file";
    print $out $result;
    close $out;
}

1;
