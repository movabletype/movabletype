# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

# Original copyright (c) 2004-2006, Brad Choate and Tobias Hoellrich

package MT::Plugin::SpamLookup;

use strict;
use MT;
use MT::Plugin;

use vars qw($VERSION);

sub BEGIN {
    @MT::Plugin::SpamLookup::ISA = ('MT::Plugin');
    $VERSION                     = '2.5';
    my $plugin;
    $plugin = new MT::Plugin::SpamLookup(
        {   name    => 'SpamLookup - Lookups',
            version => $VERSION,
            description =>
                '<MT_TRANS phrase="SpamLookup module for using blacklist lookup services to filter feedback.">',
            doc_link        => 'http://www.spamlookup.com/wiki/LookupFilter',
            author_name     => 'Six Apart Ltd.',
            author_link     => 'http://www.movabletype.org/',
            config_template => 'lookup_config.tmpl',
            l10n_class      => 'spamlookup::L10N',
            settings        => new MT::PluginSettings(
                [   [ 'ipbl_mode',     { Default => 1 } ],
                    [ 'ipbl_weight',   { Default => 1 } ],
                    [ 'ipbl_moderate', { Default => 0 } ],
                    [ 'ipbl_service',  { Default => 'bsb.spamlookup.net' } ],
                    [ 'domainbl_mode', { Default => 1 } ],
                    [ 'domainbl_weight', { Default => 1 } ],
                    [   'domainbl_service',
                        { Default => 'bsb.spamlookup.net, sc.surbl.org' }
                    ],
                    [ 'tborigin_mode',   { Default => 1 } ],
                    [ 'tborigin_weight', { Default => 1 } ],
                    [   'whitelist',
                        {   Default =>
                                q{# This list can contain IP addresses and domain names that you
# wish to exclude from the Lookup filters you've configured above.
# You may specify either a complete or partial IP address

# This matches all 192.168.*.* IP addresses.
192.168.

# This will match sixapart.com and any of its subdomains:
sixapart.com}
                        }
                    ],
                ]
            ),
            registry => {
                junk_filters => {
                    spamlookup_ipbl => {
                        label => "SpamLookup IP Lookup",
                        code  => sub { $plugin->runner( 'ipbl', @_ ) },
                    },
                    spamlookup_domainbl => {
                        label => "SpamLookup Domain Lookup",
                        code  => sub { $plugin->runner( 'domainbl', @_ ) },
                    },
                    spamlookup_tborigin => {
                        label => "SpamLookup TrackBack Origin",
                        code  => sub { $plugin->runner( 'tborigin', @_ ) },
                    },
                },
            },
        }
    );
    MT->add_plugin($plugin);
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

sub init_app {
    my $plugin = shift;
    $plugin->SUPER::init_app(@_);
    my ($app) = @_;

    return unless $app->isa('MT::App::CMS');

    #$app->add_itemset_action({type => 'blog',
    #                          key => "despam_comments",
    #                          label => "Despam Comments",
    #                          code => sub { $plugin->despam_comments(@_) },
    #                       });
    #$app->add_itemset_action({type => 'blog',
    #                          key => "despam_trackbacks",
    #                          label => "Despam TrackBacks",
    #                          code => sub { $plugin->despam_trackbacks(@_) },
    #                       });
    #$app->add_itemset_action({type => 'comment',
    #                          key => "despam_comments",
    #                          label => "Despam",
    #                          code => sub { $plugin->despam_comments(@_) },
    #                       });
    #$app->add_itemset_action({type => 'ping',
    #                          key => "despam_trackbacks",
    #                          label => "Despam",
    #                          code => sub { $plugin->despam_trackbacks(@_) },
    #                       });
    #$app->add_methods(
    #    spamlookup_despam => sub { $plugin->runner('despam', @_) },
    #);
}

sub runner {
    my $plugin = shift;
    my $method = shift;
    require spamlookup;
    return $_->( $plugin, @_ ) if $_ = \&{"spamlookup::$method"};
    die "Failed to find spamlookup::$method";
}

sub despam_trackbacks {
    my $plugin = shift;
    my $app    = shift;

}

sub despam_comments {
    my $plugin = shift;
    my $app    = shift;

}

1;
