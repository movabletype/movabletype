# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
package MT::Util::PluginVersions;

use strict;
use warnings;
use ExtUtils::Manifest ();
use File::Temp         ();

my $HasGit;

sub plugin_versions_file {
    my $home = $ENV{MT_TEST_ROOT} || $ENV{MT_HOME} || '.';
    $home . '/PLUGIN_VERSIONS';
}

sub load_plugin_versions {
    my $file = plugin_versions_file();
    return unless -f $file;
    open my $fh, '<', $file or die "$!: $file";
    my $data = do { local $/; <$fh> };
    close $fh;
    _parse_plugin_versions($data);
}

sub _parse_plugin_versions {
    my $data = shift;
    return unless $data;
    my %map;
    for (split /\n/, $data) {
        next if /^#/ or /^\s*$/;
        my ($sig, $version) = split /\t/, $_;
        my $path =
            $sig =~ /\.pl$/
            ? "plugins/${sig}"
            : "plugins/${sig}/config.yaml";
        $map{$sig} = {
            path    => $path,
            sig     => $sig,
            version => $version,
        };
    }
    \%map;
}

sub update_plugin_versions {
    my $file = plugin_versions_file();
    my @files;
    my $manifested;
    if (-e './MANIFEST') {
        @files      = keys %{ ExtUtils::Manifest::maniread() };
        $manifested = 1;
    } elsif (-d '.git' && _has_git()) {
        my $skip = ExtUtils::Manifest::maniskip();
        @files = grep { !$skip->($_) } split /\n/, `git ls-tree -r --name-only HEAD`;
    }
    my $data                = _generate_plugin_versions();
    my $plugin_versions_map = _parse_plugin_versions($data);
    open my $out, '>', $file or die "$!: $file";
    for my $f (sort @files) {
        my ($matched) = grep { $_->{path} eq $f } values %{$plugin_versions_map};
        next unless $matched;
        print $out $matched->{sig}, "\t", $matched->{version}, "\n";
    }
    close $out;
    ExtUtils::Manifest::mkmanifest() if $manifested;
}

sub _generate_plugin_versions {
    my $home        = $ENV{MT_HOME} || '.';
    my $temp_dir    = File::Temp::tempdir(CLEANUP => 1);
    my $plugin_path = MT->config->PluginPath;
    my $cmd         = qq(touch ${temp_dir}/mtconf && MT_CONFIG=${temp_dir}/mtconf MT_CONFIG_ObjectDriver=DBI::sqlite MT_CONFIG_Database=${temp_dir}/mtdb MT_CONFIG_PluginPath=${plugin_path} perl -I${home}/extlib -I${home}/lib -MMT -E 'MT->new; map { say(\$_->{plugin_sig} . "\t" . \$_->version) } sort { \$a->{plugin_sig} cmp \$b->{plugin_sig} } grep { \$_ && \$_->isa("MT::Plugin") } map { \$MT::Plugins{\$_}->{object} } keys %MT::Plugins');
    `$cmd`;
}

sub _has_git {
    return $HasGit if defined $HasGit;
    $HasGit = `git --version` =~ /^git version/s ? 1 : 0;
}

1;
