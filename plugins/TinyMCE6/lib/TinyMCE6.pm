package TinyMCE6;

use strict;
use warnings;

our @EXPORT = qw(plugin);
use base qw(MT::Plugin Exporter);

use TinyMCE6::TinyMCEConfig;

sub plugin {
    MT->component('TinyMCE6');
}

sub system_config_template {
    my ( $app ) = @_;

    my $plugin = plugin();

    my %params = (
        settings => config_data()
    );

    return $plugin->load_tmpl("config.tmpl", \%params);
}


sub save_config {
    my $plugin = shift;
    MT->log("save_config");
    $plugin->save_config(@_);

}



1;