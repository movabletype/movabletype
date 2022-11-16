# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

# Original copyright (c) 2004-2006, Brad Choate and Tobias Hoellrich

package MT::Plugin::SpamLookup::Link;

use strict;
use MT;
use MT::Plugin;

use vars qw($VERSION);

sub BEGIN {
    @MT::Plugin::SpamLookup::Link::ISA = ('MT::Plugin');
    $VERSION                           = '2.3';
    my $plugin;
    $plugin = new MT::Plugin::SpamLookup::Link(
        {   name    => 'SpamLookup - Link',
            version => $VERSION,
            description =>
                '<__trans phrase="SpamLookup module for junking and moderating feedback based on link filters.">',
            doc_link        => 'http://www.spamlookup.com/wiki/LinkFilter',
            author_name     => 'Six Apart Ltd.',
            author_link     => 'http://www.movabletype.org/',
            config_template => 'url_config.tmpl',
            l10n_class      => 'spamlookup::L10N',
            settings        => new MT::PluginSettings(
                [   [ 'urlcount_none_mode',         { Default => 1 } ],
                    [ 'urlcount_none_weight',       { Default => 1 } ],
                    [ 'urlcount_moderate_mode',     { Default => 1 } ],
                    [ 'urlcount_moderate_limit',    { Default => 3 } ],
                    [ 'urlcount_junk_mode',         { Default => 1 } ],
                    [ 'urlcount_junk_limit',        { Default => 10 } ],
                    [ 'urlcount_junk_weight',       { Default => 1 } ],
                    [ 'priorurl_mode',              { Default => 1 } ],
                    [ 'priorurl_weight',            { Default => 1 } ],
                    [ 'priorurl_greyperiod_mode',   { Default => 1 } ],
                    [ 'priorurl_greyperiod',        { Default => 7 } ],
                    [ 'prioremail_mode',            { Default => 1 } ],
                    [ 'prioremail_weight',          { Default => 1 } ],
                    [ 'prioremail_greyperiod_mode', { Default => 1 } ],
                    [ 'prioremail_greyperiod',      { Default => 7 } ],
                ]
            ),
            registry => {
                junk_filters => {
                    spamlookup_urls => {
                        label => "SpamLookup Link Filter",
                        code  => sub { $plugin->runner( 'urls', @_ ) },
                    },
                    spamlookup_link_memory => {
                        label => "SpamLookup Link Memory",
                        code  => sub { $plugin->runner( 'link_memory', @_ ) },
                    },
                    spamlookup_email_memory => {
                        label => "SpamLookup Email Memory",
                        code => sub { $plugin->runner( 'email_memory', @_ ) },
                    },
                },
            },
        }
    );
    MT->add_plugin($plugin);
}

sub config_tmpl {
    my $plugin = shift;
    my $tmpl   = $plugin->load_tmpl('url_config.tmpl');
    $tmpl->param( 'sql',
        UNIVERSAL::isa( MT::Object->driver, 'MT::ObjectDriver::DBI' ) );
    $tmpl;
}

sub runner {
    my $plugin = shift;
    my $method = shift;
    require spamlookup;
    return $_->( $plugin, @_ ) if $_ = \&{"spamlookup::$method"};
    die "Failed to find spamlookup::$method";
}

sub apply_default_settings {
    my $plugin = shift;
    my ( $data, $scope ) = @_;
    if ( $scope ne 'system' ) {
        my $sys     = $plugin->get_config_obj('system');
        my $sysdata = $sys->data();
        if ( $plugin->{settings} && $sysdata ) {
            foreach ( keys %$sysdata ) {
                $data->{$_} = $sysdata->{$_} if !exists $data->{$_};
            }
        }
    }
    else {
        $plugin->SUPER::apply_default_settings(@_);
    }
}

1;
