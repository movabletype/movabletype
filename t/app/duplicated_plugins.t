use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use MT::Test::Util::Plugin;

our $test_env;
BEGIN {
    plan skip_all => 'TODO: FIXME' if $ENV{MT_TEST_RUN_APP_AS_CGI};

    $test_env = MT::Test::Env->new(
        PluginPath => [
            'TEST_ROOT/plugins',
            'TEST_ROOT/plugins-A',
            'TEST_ROOT/plugins-B',
        ],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::App;
use JSON;

# Load fixture before preparing plugins

$test_env->prepare_fixture('db');

subtest 'Conflicting plugins in the same plugins directory' => sub {
    # Case 1: .pl has a lower version than config.yaml
    MT::Test::Util::Plugin->write(
        'MyPlugin1-0.1' => {
            'MyPlugin1.pl' => {
                name    => 'MyPlugin1',
                version => '0.1',
            },
        },
        'MyPlugin1-1.0' => {
            'config.yaml' => {
                name    => 'MyPlugin1',
                version => '1.0',
            },
        },
    );

    # Case 2: .pl has a lower version than root .pl
    MT::Test::Util::Plugin->write(
        'MyPlugin2-0.1' => {
            'MyPlugin2.pl' => {
                name    => 'MyPlugin2',
                version => '0.1',
            },
        },
        '' => {
            'MyPlugin2-1.0.pl' => {
                name    => 'MyPlugin2',
                version => '1.0',
            },
        },
    );

    # Case 3: config.yaml has a higher version than root .pl
    MT::Test::Util::Plugin->write(
        'MyPlugin3-2.0' => {
            'config.yaml' => {
                name    => 'MyPlugin3',
                version => '2.0',
            },
        },
        '' => {
            'MyPlugin3-1.0.pl' => {
                name    => 'MyPlugin3',
                version => '1.0',
            },
        },
    );

    note "first rpt";
    my $res = run_rpt();

    my $switch = MT->config->PluginSwitch || {};

    ok !$switch->{'MyPlugin1-0.1/MyPlugin.pl'}, "MyPlugin1: older version is listed in PluginSwitch but is 0";
    ok $switch->{'MyPlugin1-1.0'},              "MyPlugin1: newer version is listed in PluginSwitch";
    like $res => qr/Conflicted plugin \S+?MyPlugin1-0.1\/MyPlugin1.pl 0.1 is disabled/, "logged correctly";

    ok !$switch->{'MyPlugin2-0.1/MyPlugin.pl'}, "MyPlugin2: older version is listed in PluginSwitch but is 0";
    ok $switch->{'MyPlugin2-1.0.pl'},           "MyPlugin2: newer version is listed in PluginSwitch";
    like $res => qr/Conflicted plugin \S+?MyPlugin2-0.1\/MyPlugin2.pl 0.1 is disabled/, "logged correctly";

    ok !$switch->{'MyPlugin3-1.0.pl'}, "MyPlugin3: older version is listed in PluginSwitch but is 0";
    ok $switch->{'MyPlugin3-2.0'},     "MyPlugin3: newer version is listed in PluginSwitch";
    like $res => qr/Conflicted plugin \S+?MyPlugin3-1.0.pl 1.0 is disabled/, "logged correctly";
};

subtest 'Conflicting plugins in different plugins directories' => sub {
    # Case 4: same root .pl
    MT::Test::Util::Plugin->write(
        plugin_root => 'plugins-A',
        ''          => {
            'MyPlugin4.pl' => {
                name    => 'MyPlugin4',
                version => '0.1',
            },
        },
    );
    MT::Test::Util::Plugin->write(
        plugin_root => 'plugins-B',
        ''          => {
            'MyPlugin4.pl' => {
                name    => 'MyPlugin4',
                version => '1.0',
            },
        },
    );

    # Case 5: same .pl
    MT::Test::Util::Plugin->write(
        plugin_root => 'plugins-A',
        'MyPlugin5' => {
            'MyPlugin5.pl' => {
                name    => 'MyPlugin5',
                version => '0.1',
            },
        },
    );
    MT::Test::Util::Plugin->write(
        plugin_root => 'plugins-B',
        'MyPlugin5' => {
            'MyPlugin5.pl' => {
                name    => 'MyPlugin5',
                version => '1.0',
            },
        },
    );

    # Case 6: same config.yaml
    MT::Test::Util::Plugin->write(
        plugin_root => 'plugins-A',
        'MyPlugin6' => {
            'config.yaml' => {
                name    => 'MyPlugin6',
                version => '2.0',
            },
        },
    );
    MT::Test::Util::Plugin->write(
        plugin_root => 'plugins-B',
        'MyPlugin6' => {
            'config.yaml' => {
                name    => 'MyPlugin6',
                version => '1.0',
            },
        },
    );

    note "first rpt";
    my $res = run_rpt();

    my $switch = MT->config->PluginSwitch || {};

    ok $switch->{'MyPlugin4.pl'}, "MyPlugin4 is listed in PluginSwitch";
    like $res => qr/plugins-A\/MyPlugin4.pl 0.1 is disabled/, "logged correctly";

    ok $switch->{'MyPlugin5/MyPlugin5.pl'}, "MyPlugin5 is listed in PluginSwitch";
    like $res => qr/plugins-A\/MyPlugin5\/MyPlugin5.pl 0.1 is disabled/, "logged correctly";

    ok $switch->{'MyPlugin6'}, "MyPlugin6 is listed in PluginSwitch";
    like $res => qr/plugins-B\/MyPlugin6 1.0 is disabled/, "logged correctly";
};

subtest 'Correct modules are loaded?' => sub {
    # Case 7: .pl plugin that loads modules from lib and extlib
    MT::Test::Util::Plugin->write(
        plugin_root => 'plugins-A',
        'MyPlugin7' => {
            'MyPlugin7.pl' => {
                name     => 'MyPlugin7',
                version  => '0.1',
                use      => 'use MyPlugin7::App; use ExtLib::Module;',
                registry => {
                    object_types => {
                        entry => {
                            myplugin7_meta_column => 'integer',
                        },
                    },
                },
            },
            'lib/MyPlugin7/App.pm' => {
                version => '0.1',
                code    => qq{print STDERR "MyPlugin7::App 0.1 was loaded.\n";\n},
            },
            'extlib/ExtLib/Module.pm' => {
                version => '1.0',
                code    => qq{print STDERR "ExtLib::Module 1.0 from plugins-A was loaded.\n";\n},
            },
        },
    );
    MT::Test::Util::Plugin->write(
        plugin_root => 'plugins-B',
        'MyPlugin7' => {
            'MyPlugin7.pl' => {
                name     => 'MyPlugin7',
                version  => '1.0',
                use      => 'use MyPlugin7::App; use ExtLib::Module;',
                registry => {
                    object_types => {
                        entry => {
                            myplugin7_meta_column => 'integer',
                        },
                    },
                },
            },
            'lib/MyPlugin7/App.pm' => {
                version => '1.0',
                code    => qq{print STDERR "MyPlugin7::App 1.0 was loaded.\n";\n},
            },
            'extlib/ExtLib/Module.pm' => {
                version => '1.0',
                code    => qq{print STDERR "ExtLib::Module 1.0 from plugins-B was loaded.\n";\n},
            },
        },
    );

    # helper plugin to show @INC
    MT::Test::Util::Plugin->write(
        ShowINC => {
            'config.yaml' => {
                yaml => <<'YAML',
applications:
  cms:
    methods:
      show_inc:
        app_mode: JSON
        handler: $ShowINC::ShowINC::show_inc
        requires_login: 0
YAML
            },
            'lib/ShowINC.pm' => {
                code => 'sub show_inc { shift->json_result(\@INC); }',
            },
        },
    );

    note "first rpt";
    my $res = run_rpt();
    like $res => qr/MyPlugin7::App 0.1 was loaded./,                "the first (and old) MyPlugin::App was loaded";
    like $res => qr/ExtLib::Module 1.0 from plugins-A was loaded./, "the first ExtLib::Module was loaded";

    my $switch = MT->config->PluginSwitch || {};

    ok $switch->{'MyPlugin7/MyPlugin7.pl'}, "MyPlugin7 is listed in PluginSwitch";
    like $res => qr!plugins-A/MyPlugin7/MyPlugin7.pl 0.1 is disabled!, "logged correctly";

    note "second rpt";
    $res = run_rpt();

    ok $res !~ /MyPlugin7::App 0.1 was loaded./,                "the first (and old) MyPlugin::App should not be loaded";
    ok $res !~ /ExtLib::Module 1.0 from plugins-A was loaded./, "the first ExtLib::Module should not be loaded";
    ok $res =~ /MyPlugin7::App 1.0 was loaded./,                "the correct (and new) MyPlugin::App was loaded";
    ok $res =~ /ExtLib::Module 1.0 from plugins-B was loaded./, "the correct ExtLib::Module was loaded";

    # INC should only contain lib and extlib from enabled plugins
    my $app = MT::Test::App->new;
    $res = $app->js_get_ok({ __mode => 'show_inc' });
    my $json = decode_json($res->decoded_content);
    my $inc = $json->{result} or note explain $json;
    ok !grep({m!/plugins-A/MyPlugin7/(?:lib|extlib)!} @$inc), "\@INC should not contain lib and extlib under plugins-A";
    ok grep({m!/plugins-B/MyPlugin7/(?:lib|extlib)!} @$inc), "\@INC contains lib and extlib under plugins-B";
};

subtest 'Conflicting plugins have callbacks' => sub {
    # Case 8: .pl with callbacks
    MT::Test::Util::Plugin->write(
        plugin_root => 'plugins-A',
        MyPlugin8 => {
            'MyPlugin8.pl' => {
                version => '0.1',
                registry => {
                    callbacks => {
                        post_init => sub {
                            print STDERR "post init from plugins-A/MyPlugin8 is called\n";
                        },
                    },
                },
            },
        },
    );
    MT::Test::Util::Plugin->write(
        plugin_root => 'plugins-B',
        MyPlugin8 => {
            'MyPlugin8.pl' => {
                version => '1.0',
                registry => {
                    callbacks => {
                        post_init => sub {
                            print STDERR "post init from plugins-B/MyPlugin8 is called\n";
                        },
                    },
                },
            },
        },
    );

    # Case 9: config.yaml with callbacks
    MT::Test::Util::Plugin->write(
        plugin_root => 'plugins-A',
        MyPlugin9 => {
            'config.yaml' => {
                version => '0.1',
                yaml => <<'YAML',
callbacks:
  post_init: $MyPlugin9::MyPlugin9::post_init
YAML
            },
            'lib/MyPlugin9.pm' => {
                code => 'sub post_init { print STDERR "post init from plugins-A/MyPlugin9 is called\n"; }',
            },
        },
    );
    MT::Test::Util::Plugin->write(
        plugin_root => 'plugins-B',
        MyPlugin9 => {
            'config.yaml' => {
                version => '1.0',
                yaml => <<'YAML',
callbacks:
  post_init: $MyPlugin9::MyPlugin9::post_init
YAML
            },
            'lib/MyPlugin9.pm' => {
                code => 'sub post_init { print STDERR "post init from plugins-B/MyPlugin9 is called\n"; }',
            },
        },
    );

    note "first rpt";
    my $res = run_rpt();

    my $switch = MT->config->PluginSwitch || {};

    ok $switch->{'MyPlugin8/MyPlugin8.pl'}, "MyPlugin8 is listed in PluginSwitch";
    ok $switch->{'MyPlugin9'}, "MyPlugin9 is listed in PluginSwitch";
    like $res => qr!plugins-A/MyPlugin8/MyPlugin8.pl 0.1 is disabled!, "logged correctly";
    like $res => qr!plugins-A/MyPlugin9 0.1 is disabled!, "logged correctly";

    my @called_A = $res =~ m!post init from (plugins-A/MyPlugin[89]) is called!g;
    ok !@called_A, "post init from A was not called";
    my @called_B = $res =~ m!post init from (plugins-B/MyPlugin[89]) is called!g;
    ok @called_B == 2, "post init from B was called twice";
};

subtest 'Broken plugins should not interfere other plugins' => sub {
    my @plugin_paths = MT->config->PluginPath;
    $test_env->update_config(PluginPath => [@plugin_paths, 'TEST_ROOT/broken']);

    subtest 'Broken plugin and registry' => sub {
        # Case 10: adopted from t/app/defer_plugin_errors.t
        MT::Test::Util::Plugin->write(
            plugin_root => 'broken',
            Broken      => {
                'Broken.pl' => {
                    code => 'die "Broken!";',
                },
            },
        );
        MT::Test::Util::Plugin->write(
            MyPlugin => {
                'MyPlugin.pl' => {
                    version        => '1.0',
                    schema_version => '1.0',
                    registry       => {
                        object_types => {
                            entry => {
                                my_plugin_meta_column => 'integer',
                            },
                        },
                        callbacks => {
                            post_init => sub {
                                my $entry = MT->model('entry')->new;
                                print STDERR "Entry has my_plugin_meta_column\n" if $entry->can('my_plugin_meta_column');
                            },
                        },
                    },
                },
            },
        );

        note "first rpt";
        my $res = run_rpt();
        ok $res =~ m!Errored plugin Broken/Broken.pl is disabled by the system!, "Broken plugin error is logged correctly";
        ok $res =~ m!Entry has my_plugin_meta_column!,                           "new column is correctly added to entry";

        my $switch = MT->config->PluginSwitch || {};
        ok $switch->{'MyPlugin/MyPlugin.pl'}, "MyPlugin is listed in PluginSwitch";

        note "second rpt";
        $res = run_rpt();
        ok $res !~ m!Errored plugin Broken/Broken.pl is disabled by the system!, "Broken plugin error is gone correctly";
    };

    subtest 'Broken, conflicting plugins' => sub {
        # Case 11: broken plugin also conflicts
        MT::Test::Util::Plugin->write(
            plugin_root => 'broken',
            MyPlugin11  => {
                'MyPlugin11.pl' => {
                    version => '2.0',
                    code    => 'die "Broken!";',
                },
            },
        );
        MT::Test::Util::Plugin->write(
            plugin_root => 'plugins-A',
            MyPlugin11  => {
                'MyPlugin11.pl' => {
                    version => '0.1',
                },
            },
        );
        MT::Test::Util::Plugin->write(
            plugin_root => 'plugins-B',
            MyPlugin11  => {
                'MyPlugin11.pl' => {
                    version => '1.0',
                },
            },
        );

        note "first rpt";
        my $res = run_rpt();

        my $switch = MT->config->PluginSwitch || {};

        ok $switch->{'MyPlugin11/MyPlugin11.pl'}, "MyPlugin11 is listed in PluginSwitch";
        ok $res =~ m!plugins-A\/MyPlugin11/MyPlugin11.pl 0.1 is disabled!, "logged correctly";
        ok $res !~ m!plugins-B\/MyPlugin11/MyPlugin11.pl 1.0 is disabled!, "MyPlugin11 ver 1.0 should not be disabled";
    };

    $test_env->update_config(PluginPath => \@plugin_paths);
};

done_testing;

sub run_rpt {
    MT::Session->remove({ kind => 'PT' });
    my $res = `perl -It/lib ./tools/run-periodic-tasks --verbose 2>&1`;
    # reload updated config
    MT->config->read_config_db();
    $res =~ s!\\!/!g if $^O eq 'MSWin32';
    note $res;
    $res;
}
