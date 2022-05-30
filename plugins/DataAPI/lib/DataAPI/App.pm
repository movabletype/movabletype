# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package DataAPI::App;
use strict;
use warnings;

sub config_tmpl {
    my ($plugin, $param, $scope) = @_;
    my %param;
    if ($scope eq 'system') {
        my $cfg = MT->config;
        my %disable_sites = map { $_ => 1 } split /,/, defined $cfg->DataAPIDisableSite ? $cfg->DataAPIDisableSite : '';
        $param{enable_data_api} = $disable_sites{0} ? 0 : 1;
    } else {
        my ($blog_id) = $scope =~ m/blog:(\d+)/;
        my $blog = MT::Blog->load($blog_id);
        if ($blog) {
            $param{blog_id}         = $blog_id;
            $param{enable_data_api} = $blog->allow_data_api;
        }
    }
    $plugin->load_tmpl('config.tmpl', \%param);
}

sub update_allow_data_api {
    my ($cb, $plugin, $data, $scope) = @_;
    my $app = MT->instance;
    my ($blog_id) = $scope =~ m/blog:(\d+)/;
    $blog_id = 0 if $scope eq 'system';

    require MT::CMS::Blog;
    MT::CMS::Blog::save_data_api_settings($app, $blog_id, $data->{enable_data_api});

    return 1;
}

1;

__END__
