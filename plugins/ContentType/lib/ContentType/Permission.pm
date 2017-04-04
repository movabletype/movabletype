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
    return +{
        %{ _blog_edit_content_types_permission() },
        %{ MT->model('content_type')->all_permissions },
    };
}

sub _blog_edit_content_types_permission {
    return +{
        'blog.administer_blog' =>
            { inherit_from => ['blog.edit_content_types'] },
        'blog.edit_content_types' => {
            group => 'blog_design',
            label => 'Edit Content Types',
            order => 300,
        }
    };
}

sub _load_yaml {
    my $filename = shift;
    my $plugin   = MT->component('ContentType') or die;
    my $filepath = File::Spec->catfile( $plugin->envelope, $filename );
    return MT::Util::YAML::LoadFile($filepath);
}

1;
