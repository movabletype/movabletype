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
    return +{
        'system.administer' =>
            { inherit_from => ['system.manage_content_types'] },
        'system.manage_content_types' => {
            group            => 'sys_admin',
            label            => 'Manage Content Types',
            order            => 500,
            permitted_action => { create_conten_type => 1 },
        }
    };
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

1;
