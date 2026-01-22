package MT::Plugin::Diagnosis::Department::PluginData;
use strict;
use warnings;
use base 'MT::Plugin::Diagnosis::Department';
use MT::PluginData;
use MT::Plugin::Diagnosis::Util qw(commify);
use MT::Plugin::Diagnosis;

sub description { translate('Delete plugindata breakage or duplication.') }

sub CASE_DUPLICATION { 1 }
sub CASE_BROKEN      { 2 }

sub scan {
    my ($class) = @_;
    my @result;

    MT->log({
        message   => translate('Disgnosis scan on PluginData is started'),
        level     => MT::Log::INFO(),
        author_id => MT->instance->user->id,
    });

    my $pd_plugins = pd_plugins();
    my $installed  = installed_plugins();

    for my $pname (keys %$pd_plugins) {
        my $plugin = $installed->{$pname} || MT::Plugin->new({ id => $pname, name => $pname });

        while (my ($key, $count) = each(%{ $pd_plugins->{$pname} })) {
            my $scope_id  = ($key =~ qr{^configuration:?(.*)})[0] || '';
            my $cfg       = $plugin->get_config_obj($scope_id);
            my $active_id = $cfg->id || next;                              # never reach next

            if ($count > 1) {
                push @result, {
                    params => MT::Util::to_json({
                        case      => CASE_DUPLICATION(),
                        plugin    => $pname,
                        scope_id  => $scope_id,
                        active_id => $active_id,
                    }),
                    department  => $class->department_name,
                    description => translate('[_1] duplications.', commify($count)),
                };
            }

            if (ref $cfg->data ne 'HASH') {
                push @result, {
                    params => MT::Util::to_json({
                        case      => CASE_BROKEN(),
                        plugin    => $pname,
                        scope_id  => $scope_id,
                        delete_id => $active_id,
                    }),
                    department  => $class->department_name,
                    description => translate('Breakages.'),
                };
            }
        }
    }

    return @result;
}

sub repair {
    my ($class, $task) = @_;

    my $params = MT::Util::from_json($task->params);
    my $key    = 'configuration' . ($params->{scope_id} ? ':' . $params->{scope_id} : '');

    if ($params->{case} == CASE_DUPLICATION()) {
        MT::PluginData->remove(
            { plugin  => $params->{plugin}, key => $key, id => { not => $params->{active_id} } },
            { nofetch => 1 });
    } elsif ($params->{case} == CASE_BROKEN()) {
        MT::PluginData->remove(
            { plugin  => $params->{plugin}, key => $key, id => $params->{delete_id} },
            { nofetch => 1 });
    }
    return 1;
}

sub installed_plugins {
    my $plugins;
    for my $k (keys %MT::Plugins) {
        if (my $p = $MT::Plugins{$k}->{object}) {
            next unless $p->isa('MT::Plugin');
            $plugins->{ $p->key || $p->name } = $p;
        }
    }
    return $plugins;
}

sub pd_plugins {
    my $plugins = {};
    my $iter    = MT::PluginData->count_group_by(undef, { group => ['plugin', 'key'] });
    while (my ($count, $plugin, $key) = $iter->()) {
        $plugins->{$plugin} ||= {};
        $plugins->{$plugin}->{$key} = $count;
    }
    return $plugins;
}

1;
