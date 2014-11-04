# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Endpoint::Plugin::v2;

use strict;
use warnings;

use boolean ();

use MT::App;
use MT::CMS::Plugin;
use MT::DataAPI::Endpoint::Common;

sub list {
    my ( $app, $endpoint ) = @_;

    run_permission_filter( $app, 'data_api_list_permission_filter', 'plugin' )
        or return;

    my %param;
    MT::CMS::Plugin::build_plugin_table(
        $app,
        param => \%param,
        scope => 'system'
    );

    return _to_object( $param{plugin_loop} );
}

sub get {
    my ( $app, $endpoint ) = @_;

    run_permission_filter( $app, 'data_api_view_permission_filter', 'plugin' )
        or return;

    my $plugin_id = _retrieve_plugin_id($app) or return;

    my %param;
    MT::CMS::Plugin::build_plugin_table(
        $app,
        param => \%param,
        scope => 'system'
    );

    my @plugin_loop
        = grep { $_->{plugin_folder} || $_->{plugin_sig} eq $plugin_id }
        @{ $param{plugin_loop} };

    my ($plugin) = @{ _to_object( \@plugin_loop ) }
        or return $app->error( $app->translate('Plugin not found'), 404 );

    return $plugin;
}

sub enable {
    my ( $app, $endpoint ) = @_;
    my $plugin_id = _retrieve_plugin_id($app) or return;
    _switch_plugin_state( $app, $plugin_id, 'on' );
}

sub disable {
    my ( $app, $endpoint ) = @_;
    my $plugin_id = _retrieve_plugin_id($app) or return;
    _switch_plugin_state( $app, $plugin_id, 'off' );
}

sub enable_all {
    my ( $app, $endpoint ) = @_;
    _switch_plugin_state( $app, '*', 'on' );
}

sub disable_all {
    my ( $app, $endpoint ) = @_;
    _switch_plugin_state( $app, '*', 'off' );
}

sub _switch_plugin_state {
    my ( $app, $plugin_id, $state ) = @_;

    $app->param( 'plugin_sig', $plugin_id );
    $app->param( 'state',      $state );

    local $app->{return_args};
    local $app->{redirect};
    local $app->{redirect_use_meta};

    no warnings 'redefine';
    local *MT::App::validate_magic = sub {1};

    MT::CMS::Plugin::plugin_control($app);
    return if $app->errstr;

    return +{ status => 'success' };
}

sub _retrieve_plugin_id {
    my ($app) = @_;

    my $plugin_id = $app->param('plugin_id');
    if ( !defined $plugin_id || $plugin_id eq '' ) {
        return $app->error(
            $app->translate('A parameter "plugin_id" id required.'), 400 );
    }

    return $plugin_id;
}

sub _to_object {
    my ($plugin_loop) = @_;

    my @plugins;
    my $plugin_set;

    for my $p (@$plugin_loop) {

        if ( $p->{plugin_folder} ) {
            $plugin_set = $p->{plugin_folder};
            next;
        }

        my %plugin = (
            id        => $p->{plugin_sig},
            name      => $p->{plugin_name},
            icon      => $p->{plugin_icon},
            pluginSet => $plugin_set,
            status    => $p->{plugin_disabled} ? 'Disabled' : 'Enabled',
            !$p->{plugin_disabled}
            ? ( version      => $p->{plugin_version},
                description  => $p->{plugin_desc},
                pluginLink   => $p->{plugin_plugin_link},
                authorName   => $p->{plugin_author_name},
                authorLink   => $p->{plugin_author_link},
                documentLink => $p->{plugin_doc_link},
                configLink   => $p->{plugin_config_link},
                tags         => [ map { $_->{name} } @{ $p->{plugin_tags} } ],
                attributes =>
                    [ map { $_->{name} } @{ $p->{plugin_attributes} } ],
                textFilters =>
                    [ map { $_->{name} } @{ $p->{plugin_text_filters} } ],
                junkFilters =>
                    [ map { $_->{name} } @{ $p->{plugin_junk_filters} } ],
                $MT::DebugMode ? ( errors => $p->{compat_errors} ) : (),
                )
            : (),
        );

        push @plugins, \%plugin;
    }

    return \@plugins;
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::Plugin::v2 - Movable Type class for endpoint definitions about the MT::Plugin.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
