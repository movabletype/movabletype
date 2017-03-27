package ContentType::Permission;
use strict;
use warnings;

use File::Spec ();

use MT;
use MT::Util::YAML;

sub permissions {
    return +{ %{ _system_permissions() }, %{ _blog_permissions() }, };
}

sub _system_permissions {
    return _load_yaml('system_permissions.yaml');
}

sub _blog_permissions {
    return MT->model('content_type')->all_permissions;
}

sub _load_yaml {
    my $filename = shift;
    my $plugin   = MT->component('ContentType') or die;
    my $filepath = File::Spec->catfile( $plugin->envelope, $filename );
    return MT::Util::YAML::LoadFile($filepath);
}

1;
