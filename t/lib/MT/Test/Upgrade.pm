package MT::Test::Upgrade;
use strict;
use warnings;

sub upgrade {
    if ( $_[0] && $_[0] eq __PACKAGE__ ) {
        shift;
    }

    my $args;
    if ( ref $_[0] ) {
        $args = $_[0];
    }
    else {
        my %hash = @_;
        $args = \%hash;
    }

    my $from      = $args->{from};
    my $component = $args->{component} || 'core';
    my $cfg       = MT->config;

    if ( lc($component) eq 'core' ) {
        if ( !$from ) {
            die
                '"from" parameter is needed. This is "schema_version" before upgrading.';
        }

        $cfg->SchemaVersion( $from, 1 );
    }
    else {
        my $plugin_schema_version = $cfg->PluginSchemaVersion;

        if ( !exists $plugin_schema_version->{$component} ) {
            die
                "component: $component does not exist in PluginSchemaVersion.";
        }

        if ( $from ) {
            $plugin_schema_version->{$component} = $from;
        }
        else {
            delete $plugin_schema_version->{$component};
        }
        $cfg->PluginSchemaVersion( $plugin_schema_version, 1 );
    }
    $cfg->save_config;

    require MT::Upgrade;
    MT::Upgrade->do_upgrade;
}

1;
__END__

=head1 NAME

MT::Test::Upgrade - Helper module for upgrading test.

=head1 SYNOPSIS

    use MT::Test::Upgrade;
    ...
    MT::Test::Upgrade->upgrade({
        from      => '2.0',
        component => 'multiblog',
    });

=head1 DESCRIPTION

Helper module for upgrading test.

=head1 METHODS

=head2 MT::Test::Upgrade->upgrade({ $from[, $component] })

Change SchemaVersion and upgrade Movable Type only by using this method.

$from is a required paramter. $from is set SchemaVersion or PluginSchemaVersion. An error occurs when $from is not set.

$component is an optional parameter. SchemaVersion is changed before upgrading when $component is 'core' or is not set. PluginSchemaVersion is chagned before upgrading when $component is set.

=cut
