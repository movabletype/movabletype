# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v2::User;

use strict;
use warnings;

use boolean ();

use MT::Author;
use MT::Permission;
use MT::DataAPI::Resource::Common;
use MT::DataAPI::Resource::v1::User;

sub updatable_fields {
    [   qw(
            status
            name
            password
            language

            dateFormat
            textFormat
            tagDelimiter
            systemPermissions
            ),
    ];
}

sub fields {
    [   status => {
            name => 'status',
            bulk_from_object =>
                MT::DataAPI::Resource::v1::User::_private_bulk_from_object(
                'status', 'get_status_text'
                ),
            to_object => sub {
                my ( $hash, $obj ) = @_;
                $obj->set_status_by_text( $hash->{status} );
                return;
            },
        },
        {   name        => 'password',
            from_object => sub { },      # Display nothing.
            to_object   => sub {
                my ( $hash, $obj ) = @_;
                my $pass = $hash->{password};
                if ( length $pass ) {
                    $obj->set_password($pass);
                }
                return;
            },
        },
        {   name        => 'language',
            alias       => 'preferred_language',
            from_object => sub {
                my ($obj) = @_;
                my $l = $obj->preferred_language;
                if ( !$l ) {
                    my $cfg = MT->config;
                    $l = $cfg->DefaultUserLanguage
                        || $cfg->DefaultLanguage;
                }
                $l =~ s/_/-/g;
                lc $l;
            },
        },
        {   name  => 'dateFormat',
            alias => 'date_format',
            bulk_from_object =>
                MT::DataAPI::Resource::v1::User::_private_bulk_from_object(
                'dateFormat', 'date_format'
                ),
        },
        {   name  => 'textFormat',
            alias => 'text_format',
            bulk_from_object =>
                MT::DataAPI::Resource::v1::User::_private_bulk_from_object(
                'textFormat', 'text_format'
                ),
        },
        {   name        => 'tagDelimiter',
            alias       => 'entry_prefs',
            from_object => sub {
                my ($obj) = @_;
                my $app  = MT->instance or return;
                my $user = $app->user   or return;

                return if !( $user->is_superuser || $user->id == $obj->id );

                my $entry_prefs = $obj->entry_prefs;
                if ( defined($entry_prefs) && $entry_prefs eq ' ' ) {
                    return 'space';
                }
                else {
                    return 'comma';
                }
            },
            to_object => sub {
                my ($hash) = @_;
                my $delim;
                my $tag_delimiter = $hash->{tagDelimiter};
                if ( $tag_delimiter && lc($tag_delimiter) eq 'space' ) {
                    $delim = ord(' ');
                }
                else {
                    $delim = ord(',');
                }
                return "tag_delim=$delim";
            },
        },
        {   name        => 'isSuperuser',
            type        => 'MT::DataAPI::Resource::DataType::Boolean',
            from_object => sub {
                my ($obj) = @_;
                my $app  = MT->instance or return;
                my $user = $app->user   or return;

                return if !( $user->is_superuser || $user->id == $obj->id );
                return $obj->is_superuser
                    ? boolean::true()
                    : boolean::false();
            },
        },
        {   name        => 'lockedOut',
            type        => 'MT::DataAPI::Resource::DataType::Boolean',
            from_object => sub {
                my ($obj) = @_;
                my $app  = MT->instance or return;
                my $user = $app->user   or return;

                return if !( $user->is_superuser || $user->id == $obj->id );
                return $obj->locked_out ? boolean::true() : boolean::false();
            },
        },
        {   name             => 'systemPermissions',
            bulk_from_object => \&_system_permissions_bulk_from_object,
            to_object => sub { },    # Do nothing.
            type_to_object => \&_system_permissions_type_to_object,
            schema => {
                type  => 'array',
                items => {
                    type => 'string',
                },
            },
        },
        $MT::DataAPI::Resource::Common::fields{createdBy},
        $MT::DataAPI::Resource::Common::fields{modifiedBy},
        $MT::DataAPI::Resource::Common::fields{createdDate},
        $MT::DataAPI::Resource::Common::fields{modifiedDate},
    ];
}

sub _system_permissions_bulk_from_object {
    my ( $objs, $hashes ) = @_;
    my $app  = MT->instance or return;
    my $user = $app->user   or return;

    my $perms = $app->model('permission')->perms_from_registry;

    for my $i ( 0 .. ( scalar(@$objs) - 1 ) ) {

        my $obj  = $objs->[$i];
        my $hash = $hashes->[$i];

        next unless $user->is_superuser;

        my %user_perms;

        # General permissions...
        my $sys_perms = $obj->permissions(0);
        if ( $sys_perms && $sys_perms->permissions ) {
            my @sys_perms = split( ',', $sys_perms->permissions );
            foreach my $perm (@sys_perms) {
                $perm =~ s/'(.+)'/$1/;
                $user_perms{ 'system.' . $perm } = 1;
            }
        }

        # Make permission list
        my @perms;
        my @keys = keys %$perms;
        foreach my $key (@keys) {
            next if $key !~ m/^system./;
            my $perm;
            ( $perm->{id} = $key ) =~ s/^system\.//;

            $perm->{order} = $perms->{$key}->{order};
            $perm->{can_do} = $obj->id ? $user_perms{$key} : undef;

            if ( exists $perms->{$key}->{inherit_from} ) {
                my $inherit_from = $perms->{$key}->{inherit_from};
                if ($inherit_from) {
                    my @child;
                    foreach (@$inherit_from) {
                        my $child = $_;
                        $child =~ s/^system\.//;
                        push @child, $child;
                    }
                    $perm->{children} = \@child;
                }
            }

            push @perms, $perm;
        }

        # Process inheritance.
        my %all_children;
        for my $p (@perms) {
            if ( $p->{can_do} ) {
                $all_children{$_} = 1 for @{ $p->{children} };
            }
        }

        my @can_do = keys %all_children;
        for my $p (@perms) {
            if ( grep { $p->{id} eq $_ } @can_do ) {
                $p->{can_do} = 1;
            }
        }

        # Filter and sort.
        my @perms_id = map { $_->{id} }
            sort { $a->{order} <=> $b->{order} }
            grep { $_->{can_do} } @perms;

        $hash->{systemPermissions} = \@perms_id;
    }

    return;

}

sub _system_permissions_type_to_object {
    my ( $hashes, $objs ) = @_;
    my $app = MT->instance;
    my $user = $app->user or return;

    return if !$user->is_superuser;

    for my $i ( 0 .. ( scalar(@$hashes) - 1 ) ) {
        my $hash = $hashes->[$i];
        my $obj  = $objs->[$i];

        next if $obj->status != MT::Author::ACTIVE();

        if ( $obj->id ) {
            next if $user->id == $obj->id;
            _to_object_when_updating( $hash, $obj );
        }
        else {
            _to_object_when_creating( $hash, $obj );
        }
    }

    return;
}

sub _to_object_when_updating {
    my ( $hash, $obj ) = @_;

    my $perms = $hash->{systemPermissions};
    my @perms = ref($perms) eq 'ARRAY' ? @$perms : ($perms);

    my $sys_perms = MT::Permission->perms('system');
    my @sys_perms = map { $_->[0] } @$sys_perms;

    for my $p (@sys_perms) {
        next if !defined($p);

        my $can_do = ( grep { $p eq $_ } @perms ) ? 1 : 0;

        if ( $p eq 'administer' ) {
            $obj->is_superuser($can_do);
        }
        else {
            my $name = 'can_' . $p;
            $obj->$name($can_do);
        }
    }
}

sub _to_object_when_creating {
    my ( $hash, $obj ) = @_;

    my $perms = $hash->{systemPermissions};
    my @perms = ref($perms) eq 'ARRAY' ? @$perms : ($perms);

    for my $p (@perms) {
        next if !defined($p);

        if ( $p eq 'administer' ) {
            $obj->is_superuser(1);
            last;
        }
        else {
            my $name = 'can_' . $p;
            eval $obj->$name(1);
        }
    }
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v2::User - Movable Type class for resources definitions of the MT::Authror.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
