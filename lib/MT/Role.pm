# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.movabletype.org.
#
# $Id$

package MT::Role;

use strict;
use MT::Object;
@MT::Role::ISA = qw(MT::Object);

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
