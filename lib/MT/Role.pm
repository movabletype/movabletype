# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Role;

use strict;
use base qw( MT::Object );

# NOTE: Keep the role_mask fields defined here in sync with those in
# MT::Permission.
__PACKAGE__->install_properties({
    column_defs => {
        id           => 'integer not null auto_increment',
        name         => 'string(255) not null',
        description  => 'text',
        is_system    => 'boolean',
        role_mask    => 'integer',
        role_mask2   => 'integer',  # for upgrades...
        role_mask3   => 'integer',
        role_mask4   => 'integer',
        permissions  => 'text',
    },
    indexes => {
        name => 1,
        is_system => 1,
        created_on => 1,
    },
    defaults => {
        is_system => 0,
    },
    child_classes => ['MT::Association'],
    audit => 1,
    datasource => 'role',
    primary_key => 'id',
});

sub class_label {
    return MT->translate('Role');
}

sub class_label_plural {
    return MT->translate('Roles');
}

sub list_props {
    return {
        name => {
            auto  => 1,
            label => 'Name',
            display => 'force',
            order   => 100,
            sub_fields => [
                {
                    class => 'description',
                    label => 'Description',
                },
            ],
            asc_count => sub {
                my $prop = shift;
                my ( $objs, $opts ) = @_;
                if ( exists $opts->{asc_count} ) {
                    return $opts->{asc_count};
                }
                else {
                    my @ids = map { $_->id } @$objs;
                    my $c_iter = MT->model('association')->count_group_by(
                        {
                            role_id => \@ids,
                        },
                        {
                            group => [ 'role_id' ],
                        },
                    );
                    my %asc_count;
                    while ( my ( $cnt, $id ) = $c_iter->() ) {
                        $asc_count{$id} = $cnt;
                    }
                    return $opts->{asc_count} = \%asc_count;
                }
            },
            bulk_html => sub {
                my $prop = shift;
                my ( $objs, $app, $opts ) = @_;
                my $asc_count = $prop->asc_count($objs, $opts);
                my @out;
                for my $obj ( @$objs ) {
                    my $len = 40; ## FIXME: Hard coded
                    my $desc = $obj->description;
                    if ( length $desc > $len ) {
                        $desc = substr($desc, 0, $len);
                        $desc .= '...';
                    }
                    my $url = $app->uri(
                        mode => 'view',
                        args => {
                            _type   => 'role',
                            id      => $obj->id,
                            blog_id => 0,
                    });
                    my $cnt = $asc_count->{ $obj->id };
                    my $name = $obj->name;
                    my $status_img = MT->static_path
                        . (
                        $cnt
                        ? '/images/status_icons/role-active.gif'
                        : '/images/status_icons/role-inactive.gif'
                        );
                    my $status_class = $cnt ? 'role-active' : 'role-inactive';
                    push @out, qq{
                        <span class="icon status $status_class">
                            <img alt="$status_class" src="$status_img" />
                        </span>
                        <a href="$url">$name</a>
                    } . ( $desc ? qq{
                        <p class="description">$desc</p>
                    } : q{} );
                }
                return @out;
            },
        },
        association_count => {
            base        => '__virtual.object_count',
            label       => 'Associations',
            display     => 'default',
            order       => 200,
            col_class   => '',
            count_class => 'association',
            count_col   => 'role_id',
            view_filter => [],
        },
        active_inactive => {
            base    => '__virtual.single_select',
            label   => 'Active/Inactive',
            display => 'none',
            terms   => sub {
                my $prop = shift;
                my ( $args, $base_terms, $base_args, $opts, ) = @_;
                my $val = $args->{value};
                if ( $val eq 'active' ) {
                    $base_args->{joins} ||= [];
                    push @{ $base_args->{joins} }, MT->model('association')->join_on(
                        undef,
                        {
                            id => \'is not null',
                        },
                        {
                            unique => 1,
                            type => 'left',
                            condition => { role_id => \'= role_id' },
                        },
                    );
                }
                else {
                    $base_args->{joins} ||= [];
                    push @{ $base_args->{joins} }, MT->model('association')->join_on(
                        undef,
                        {
                            id => \'is null',
                        },
                        {
                            unique => 1,
                            type => 'left',
                            condition => { role_id => \'= role_id' },
                        },
                    );
                }
            },
            single_select_options => [
                { label => 'Active',   value => 'active', },
                { label => 'Inactive', value => 'inactive', },
            ],
        },
        description => {
            auto => 1,
            label => 'Desctription',
            display => 'none',
        },
        created_on => {
            base => '__virtual.created_on',
            order => 300,
        },
        modified_on => {
            base => '__virtual.modified_on',
            display => 'none',
        },
        created_by => {
            base => '__virtual.author_name',
            label => 'Created by',
            display => 'none',
        },
    };
}

sub save {
    my $role = shift;
    my $res = $role->SUPER::save(@_) or return;

    require MT::Association;
    # now, update MT::Permissions to reflect role update
    if (my $assoc_iter = MT::Association->load_iter({
        type => [ MT::Association::USER_BLOG_ROLE(),
                  MT::Association::GROUP_BLOG_ROLE() ],
        role_id => $role->id,
        })) {
        while (my $assoc = $assoc_iter->()) {
            $assoc->rebuild_permissions;
        }
    }

    $res;
}

sub remove {
    my $role = shift;
    if (ref $role) {
        $role->remove_children({ key => 'role_id' }) or return;
    }
    $role->SUPER::remove(@_);
}

sub load_same {
    my $class = shift;
    require MT::Permission;
    MT::Permission::load_same($class, @_);
}

sub load_by_permission {
    my $class = shift;
    my (@list) = @_;
    require MT::Permission;
    MT::Permission::load_same($class, undef, undef, 0,  @list);
}

# Lets you set a list of permissions by name.
sub set_these_permissions {
    require MT::Permission;
    MT::Permission::set_these_permissions(@_);
}

sub clear_full_permissions {
    require MT::Permission;
    MT::Permission::clear_full_permissions(@_);
}

sub clear_permissions {
    require MT::Permission;
    MT::Permission::clear_permissions(@_);
}

sub set_full_permissions {
    require MT::Permission;
    MT::Permission::set_full_permissions(@_);
}

sub set_permissions {
    require MT::Permission;
    MT::Permission::set_permissions(@_);
}

sub add_permissions {
    require MT::Permission;
    MT::Permission::add_permissions(@_);
}

sub has {
    require MT::Permission;
    MT::Permission::has(@_);
}

sub create_default_roles {
    my $class = shift;
    my (%param) = @_;

    my @default_roles = (
        { name => MT->translate('Website Administrator'),
          description => MT->translate('Can administer the website.'),
          perms => ['administer_website', 'manage_member_blogs'] },
        { name => MT->translate('Blog Administrator'),
          description => MT->translate('Can administer the blog.'),
          role_mask => 2**12,
          perms => ['administer_blog'] },
        { name => MT->translate('Editor'),
          description => MT->translate('Can upload files, edit all entries(categories), pages(folders), tags and publish the site.'),
          perms => ['comment', 'create_post', 'publish_post', 'edit_all_posts', 'edit_categories', 'edit_tags', 'manage_pages',
                    'rebuild', 'upload', 'send_notifications', 'manage_feedback', 'edit_assets'], },
        { name => MT->translate('Author'),
          description => MT->translate('Can create entries, edit their own entries, upload files and publish.'),
          perms => ['comment', 'create_post', 'publish_post', 'upload', 'send_notifications'], },
        { name => MT->translate('Designer'),
          description => MT->translate('Can edit, manage, and publish blog templates and themes.'),
          role_mask => (2**4 + 2**7),
          perms => ['manage_themes', 'edit_templates', 'rebuild'] },
        { name => MT->translate('Webmaster'),
          description => MT->translate('Can manage pages, upload files and publish blog templates.'),
          perms => ['manage_pages', 'rebuild', 'upload'] },
        { name => MT->translate('Contributor'),
          description => MT->translate('Can create entries, edit their own entries, and comment.'),
          perms => ['comment', 'create_post'], },
        { name => MT->translate('Moderator'),
          description => MT->translate('Can comment and manage feedback.'),
          perms => ['comment', 'manage_feedback'], },
        { name => MT->translate('Commenter'),
          description => MT->translate('Can comment.'),
          role_mask => 2**0,
          perms => ['comment'], },
    );

    require MT::Role;
    return 1 if MT::Role->exist();

    foreach my $r (@default_roles) {
        my $role = MT::Role->new();
        $role->name($r->{name});
        $role->description($r->{description});
        $role->clear_full_permissions;
        $role->set_these_permissions($r->{perms});
        if ($r->{name} =~ m/^System/) {
            $role->is_system(1);
        }
        $role->role_mask($r->{role_mask}) if exists $r->{role_mask};
        $role->save
            or return $class->error($role->errstr);
    }

    1;
}

1;
__END__

=head1 NAME

MT::Role

=head1 METHODS

=head2 save()

Save this role and rebuild the associated permissions.

=head2 remove([\%terms])

Remove this role and optionally, constrain the set with I<%terms>.

=head2 has($flag_name)

Return the value of L<MT::Permission/has> for I<flag_name>.

=head2 add_permissions

Return the value of L<MT::Permission/add_permissions>.

=head2 clear_full_permissions

Return the value of L<MT::Permission/clear_full_permissions>.

=head2 clear_permissions

Return the value of L<MT::Permission/clear_permissions>.

=head2 set_full_permissions

Return the value of L<MT::Permission/set_full_permissions>.

=head2 set_permissions

Return the value of L<MT::Permission/set_permissions>.

=head2 set_these_permissions

Return the value of L<MT::Permission/set_these_permissions>.

=head2 load_by_permission(@permissions)

Return a list of roles given by a list of I<@permissions>.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
