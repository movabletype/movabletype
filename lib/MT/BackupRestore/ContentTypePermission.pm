# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::BackupRestore::ContentTypePermission;
use strict;
use warnings;

sub has_permission {
    my $class = shift;
    my ($permission) = @_;
    return 0 unless defined $permission && $permission ne '';
    my @perms = split ',', $permission;
    for my $p (@perms) {
        return 1 if _is_permission($p);
    }
    0;
}

sub _is_permission {
    my ($permission) = @_;
    _get_content_type_uid($permission) ? 1 : 0;
}

sub get_content_type_uids {
    my $class = shift;
    my ($permissions) = @_;
    return [] unless defined $permissions && $permissions ne '';
    my %uid_hash;
    for my $p ( split ',', $permissions ) {
        if ( my $uid = _get_content_type_uid($p) ) {
            $uid_hash{$uid} = 1;
        }
    }
    [ keys %uid_hash ];
}

sub get_content_field_uids {
    my $class = shift;
    my ($permissions) = @_;
    return [] unless defined $permissions && $permissions ne '';
    my %uid_hash;
    for my $p ( split ',', $permissions ) {
        if ( my $uid = _get_content_field_uid($p) ) {
            $uid_hash{$uid} = 1;
        }
    }
    [ keys %uid_hash ];
}

sub _get_content_type_uid {
    my ($permission) = @_;
    my $uid_regex = _uid_regex();
    return $1 if $permission =~ /'create_content_data:($uid_regex)'/;
    return $1 if $permission =~ /'edit_all_content_data:($uid_regex)'/;
    return $1 if $permission =~ /'manage_content_data:($uid_regex)'/;
    return $1 if $permission =~ /'publish_content_data:($uid_regex)'/;
    return $1
        if $permission
        =~ /'content_type:($uid_regex)-content_field:$uid_regex'/;
    undef;
}

sub _get_content_field_uid {
    my ($permission) = @_;
    my $uid_regex = _uid_regex();
    return $1
        if $permission
        =~ /'content_type:$uid_regex-content_field:($uid_regex)'/;
    undef;
}

sub update_permissions {
    my $class = shift;
    my ( $permissions, $all_objects ) = @_;
    return
           unless defined $permissions
        && $permissions ne ''
        && $class->has_permission($permissions);
    my @old_perms = split ',', $permissions;
    my @new_perms;
    for my $p (@old_perms) {
        if ( _is_permission($p) ) {
            push @new_perms, _update_permission( $p, $all_objects );
        }
        else {
            push @new_perms, $p;
        }
    }
    my $new_perms = join ',', @new_perms;
    return if $new_perms eq $permissions;
    $new_perms;
}

sub _update_permission {
    my ( $permission, $all_objects ) = @_;
    my $updated_permission;

    $updated_permission
        = _update_create_content_data_permission( $permission, $all_objects );
    return $updated_permission if $updated_permission;

    $updated_permission
        = _update_edit_all_content_data_permission( $permission,
        $all_objects );
    return $updated_permission if $updated_permission;

    $updated_permission
        = _update_manage_content_data_permission( $permission, $all_objects );
    return $updated_permission if $updated_permission;

    $updated_permission
        = _update_publish_content_data_permission( $permission,
        $all_objects );
    return $updated_permission if $updated_permission;

    $updated_permission
        = _update_content_field_permission( $permission, $all_objects );
    return $updated_permission if $updated_permission;

    $permission;
}

sub _update_create_content_data_permission {
    my ( $permission, $all_objects ) = @_;
    my $uid_regex = _uid_regex();
    return unless $permission =~ /'create_content_data:($uid_regex)'/;
    my $old_content_type_uid = $1;
    my $new_content_type
        = $all_objects->{"MT::ContentType#uid:$old_content_type_uid"}
        or return;
    my $new_content_type_uid = $new_content_type->unique_id;
    $permission
        =~ s/'create_content_data:$old_content_type_uid'/'create_content_data:$new_content_type_uid'/;
    $permission;
}

sub _update_edit_all_content_data_permission {
    my ( $permission, $all_objects ) = @_;
    my $uid_regex = _uid_regex();
    return unless $permission =~ /'edit_all_content_data:($uid_regex)'/;
    my $old_content_type_uid = $1;
    my $new_content_type
        = $all_objects->{"MT::ContentType#uid:$old_content_type_uid"}
        or return;
    my $new_content_type_uid = $new_content_type->unique_id;
    $permission
        =~ s/'edit_all_content_data:$old_content_type_uid'/'edit_all_content_data:$new_content_type_uid'/;
    $permission;
}

sub _update_manage_content_data_permission {
    my ( $permission, $all_objects ) = @_;
    my $uid_regex = _uid_regex();
    return unless $permission =~ /'manage_content_data:($uid_regex)'/;
    my $old_content_type_uid = $1;
    my $new_content_type
        = $all_objects->{"MT::ContentType#uid:$old_content_type_uid"}
        or return;
    my $new_content_type_uid = $new_content_type->unique_id;
    $permission
        =~ s/'manage_content_data:$old_content_type_uid'/'manage_content_data:$new_content_type_uid'/;
    $permission;
}

sub _update_publish_content_data_permission {
    my ( $permission, $all_objects ) = @_;
    my $uid_regex = _uid_regex();
    return unless $permission =~ /'publish_content_data:($uid_regex)'/;
    my $old_content_type_uid = $1;
    my $new_content_type
        = $all_objects->{"MT::ContentType#uid:$old_content_type_uid"}
        or return;
    my $new_content_type_uid = $new_content_type->unique_id;
    $permission
        =~ s/'publish_content_data:$old_content_type_uid'/'publish_content_data:$new_content_type_uid'/;
    $permission;
}

sub _update_content_field_permission {
    my ( $permission, $all_objects ) = @_;
    my $uid_regex = _uid_regex();
    return
        unless $permission
        =~ /'content_type:($uid_regex)-content_field:($uid_regex)'/;
    my $old_content_type_uid  = $1;
    my $old_content_field_uid = $2;
    if ( my $new_content_type
        = $all_objects->{"MT::ContentType#uid:$old_content_type_uid"} )
    {
        my $new_content_type_uid = $new_content_type->unique_id;
        $permission
            =~ s/'content_type:$old_content_type_uid-content_field:($uid_regex)'/'content_type:$new_content_type_uid-content_field:$1'/;
    }
    if ( my $new_content_field
        = $all_objects->{"MT::ContentField#uid:$old_content_field_uid"} )
    {
        my $new_content_field_uid = $new_content_field->unique_id;
        $permission
            =~ s/'content_type:($uid_regex)-content_field:$old_content_field_uid'/'content_type:$1-content_field:$new_content_field_uid'/;
    }
    $permission;
}

sub _uid_regex {
    '[0-9a-f]{40}';
}

1;

