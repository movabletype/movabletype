package TinyMCE6::App;

use strict;
use warnings;

use TinyMCE6;

sub param_edit_entry_cd {
    my ( $cb, $app, $param, $tmpl ) = @_;
    my $plugin = plugin();
    my $blog   = $app->blog;
    my $scope  = $blog ? ( 'blog:' . $blog->id ) : 'system';
    my $config = $plugin->get_config_value( 'tinymce6_config', $scope );
    $config =~ s/\r?\n//g;
    $param->{tinymce6_config} = $config;
}

1;
