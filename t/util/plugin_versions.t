use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $test_env->write_config({
        PluginPath => File::Spec->catdir($test_env->root, 'plugins'),
    });
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Util::PluginVersions;
use ExtUtils::Manifest;
use File::Copy qw(copy);
use Path::Tiny;
use File::pushd;
use Test::Differences;
use File::Spec;

$test_env->save_file('plugins/AddedPluginYaml/config.yaml', <<ADDED_PLUGIN_YAML);
id: AddedPluginYaml
name: AddedPluginYaml
version: 0.1
ADDED_PLUGIN_YAML
$test_env->save_file('plugins/AddedPluginPl/AddedPluginPl.pl', <<ADDED_PLUGIN_PL);
package MT::Plugin::AddedPluginPl;

use strict;
use warnings;
use MT;
use base qw( MT::Plugin );

MT->add_plugin(
    __PACKAGE__->new({
        name    => 'AddedPluginPl',
        version => 0.2,
    })
);

1;
ADDED_PLUGIN_PL

copy('MANIFEST.SKIP', $test_env->root);
{
    no Carp::Always;
    local $ExtUtils::Manifest::Verbose = $ENV{TEST_VERBOSE} ? 1 : 0;
    my $guard = pushd $test_env->root;
    ExtUtils::Manifest::mkmanifest();
}
my $manifest_file = path($test_env->path('MANIFEST'));
ok -f $manifest_file, "generated MANIFEST";

my $manifest = $manifest_file->slurp;
like $manifest => qr!plugins/AddedPluginYaml/config\.yaml!,    "has plugins/AddedPluginYaml/config.yaml";
like $manifest => qr!plugins/AddedPluginPl/AddedPluginPl\.pl!, "has plugins/AddedPluginPl/AddedPlugin.pl";

my $plugin_versions_file = path($test_env->path('PLUGIN_VERSIONS'));
ok !-f $plugin_versions_file, "PLUGIN_VERSIONS does not exist yet";

{
    no Carp::Always;
    local $ExtUtils::Manifest::Verbose = $ENV{TEST_VERBOSE} ? 1 : 0;
    my $guard = pushd $test_env->root;
    MT::Util::PluginVersions::update_plugin_versions();
}

ok -f $plugin_versions_file, "PLUGIN_VERSIONS exists now";
my $plugin_versions = $plugin_versions_file->slurp;
like $plugin_versions => qr!AddedPluginYaml\t[0-9.]!,                 "has AddedPluginYaml in PLUGIN_VERSIONS";
like $plugin_versions => qr!AddedPluginPl/AddedPluginPl\.pl\t[0-9.]!, "has AddedPluginPl/AddedPluginPl.pl in PLUGIN_VERSIONS";

my $updated_manifest = $manifest_file->slurp;
like $updated_manifest => qr!PLUGIN_VERSIONS!, "MANIFEST has PLUGIN_VERSIONS as well";

my $expected = join "\n", map { $_->{plugin_sig} . "\t" . $_->version } sort { $a->{plugin_sig} cmp $b->{plugin_sig} } grep { $_ && $_->isa("MT::Plugin") } map { $MT::Plugins{$_}->{object} } keys %MT::Plugins;
$expected .= "\n";
is $plugin_versions, $expected, "everything is genuine and tracked";

unless (`git --version` =~ /git version/ && `git config --global user.email` =~ /\w+\@\w+/) {
    done_testing;
    exit;
}

unlink $manifest_file;
unlink $plugin_versions_file;

{
    copy(".gitignore", $test_env->root);
    my $guard  = pushd $test_env->root;
    my $silent = $ENV{TEST_VERBOSE} ? '' : '-q';
    system(qq{git init $silent});
    system(qq{git add .});
    system(qq{git commit $silent -m "init"});
    MT::Util::PluginVersions::update_plugin_versions();
}

ok -f $plugin_versions_file, "PLUGIN_VERSIONS exists now";
$plugin_versions = $plugin_versions_file->slurp;
like $plugin_versions => qr!AddedPluginYaml\t[0-9.]!,                 "has AddedPluginYaml in PLUGIN_VERSIONS";
like $plugin_versions => qr!AddedPluginPl/AddedPluginPl\.pl\t[0-9.]!, "has AddedPluginPl/AddedPluginPl.pl in PLUGIN_VERSIONS";

is $plugin_versions, $expected, "everything is genuine and tracked";

done_testing;
