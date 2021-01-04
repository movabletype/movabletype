# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Util::YAML;
use strict;
use warnings;
use MT;
use base qw( MT::ErrorHandler );
use vars qw( $Module );

sub _find_module {

    # lookup argument for unit test.
    my ($config) = @_;
    if ( !$config ) {
        ## if MT was not yet instantiated, ignore the config directive.
        eval { $config = MT->app->config('YAMLModule') || '' };
    }
    if ($config) {
        $config =~ s/^YAML:://;
        die MT->translate('Invalid YAML module') if $config =~ /[^\w:]/;
        if ( $config !~ /::/ ) {
            $config = 'MT::Util::YAML::' . $config;
        }
        eval "require $config";
        die MT->translate( "Cannot load YAML module: [_1]", $@ ) if $@;
        $Module = $config;
    }
    else {
        eval { require YAML::Syck };
        $Module
            = $@
            ? 'MT::Util::YAML::Tiny'
            : 'MT::Util::YAML::Syck';
        eval "require $Module";
        die $@ if $@;
    }
    1;
}

BEGIN { _find_module() }

sub Dump {
    no strict 'refs';
    *{ $Module . "::Dump" }->(@_);
}

sub Load {
    no strict 'refs';
    *{ $Module . "::Load" }->(@_);

}

sub LoadFile {
    no strict 'refs';
    *{ $Module . "::LoadFile" }->(@_);
}

1;
