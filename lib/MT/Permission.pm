# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Permission;

use strict;

use MT::Blog;
use MT::Object;
@MT::Permission::ISA = qw(MT::Object);

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'        => 'integer not null auto_increment',
            'author_id' => 'integer not null',
            'blog_id'   => 'integer not null',
            'role_mask' => 'integer',

            # These were only declared for MTE 1.5x; dropping them
            # has no ill effect since they were never actually used.
            # 'role_mask2'      => 'integer',  # for upgrades...
            # 'role_mask3'      => 'integer',
            # 'role_mask4'      => 'integer',
            'permissions'    => 'text',
            'entry_prefs'    => 'text',
            'page_prefs'     => 'text',
            'blog_prefs'     => 'string(255)',
            'template_prefs' => 'string(255)',
            'restrictions'   => 'text',
        },
        child_of => 'MT::Blog',
        indexes  => {
            blog_id   => 1,
            author_id => 1,
            role_mask => 1,
        },
        defaults => {
            author_id => 0,
            blog_id   => 0,
            role_mask => 0,
        },
        audit       => 1,
        datasource  => 'permission',
        primary_key => 'id',
    }
);

sub class_label {
    MT->translate("Permission");
}

sub class_label_plural {
    MT->translate("Permissions");
}

sub user {
    my $perm = shift;

    #xxx Beware of circular references
    return undef unless $perm->author_id;
    $perm->cache_property(
        'user',
        sub {
            require MT::Author;
            MT::Author->load( $perm->author_id );
        }
    );
}
*author = *user;

sub blog {
    my $perm = shift;
    return undef unless $perm->blog_id;
    $perm->cache_property(
        'blog',
        sub {
            require MT::Blog;
            MT::Blog->load( $perm->blog_id );
        }
    );
}

sub global_perms {
    my $perm = shift;

    return undef unless $perm->author_id;
    return $perm unless $perm->blog_id;

    $perm->cache_property(
        'global_perms',
        sub {
            __PACKAGE__->load(
                { author_id => $perm->author_id, blog_id => 0 } );
        }
    );
}

{
    my %perms;

    sub perms_from_registry {
        return \%perms if %perms;

        my $regs = MT::Component->registry('permissions');
        my %keys = map { $_ => 1 } map { keys %$_ } @$regs;
        %perms = map { $_ => MT->registry( 'permissions' => $_ ) } keys %keys;

        \%perms;
    }
}

# Legend:
# author_id || blog_id || permissions
#    N      ||    0    || System level privilege
#    N      ||    N    || Author's Weblog level permissions
#    0      ||    N    || Weblog default preferences of Entry Display (TBRemoved)
#    0      ||    0    || !!BUG!!
# Permissions are stored in database like 'Perm1','Perm_2','Perm_3'.
{
    my @Perms;

    sub init_permissions {
        my $pkg = shift;
        $pkg->perms() unless @Perms;
    }

    sub _all_perms {
        my ($scope) = @_;
        my @perms;
        if ( my $perms = __PACKAGE__->perms_from_registry() ) {
            foreach my $p (%$perms) {
                my ( $s, $name ) = split /\./, $p;
                next unless $s && $name;
                next unless $s eq $scope;
                push @perms, "'$name'";
            }
        }
        return join ',', @perms;
    }

    sub add_permissions {
        my $perms = shift;

        # This parameter can be any MT::Object that provides the
        # permission field. So it works with MT::Permission and MT::Role.
        my ($more_perm) = @_;
        if ( my $more = $more_perm->permissions ) {
            if ( $more =~ /\'manage_member_blogs\'/ ) {
                $more = _all_perms('blog');
            }
            else {
                my @more = split ',', $more;
                my @more_perms;
                for my $p (@more) {
                    $p =~ s/'(.+)'/$1/;
                    if ( $perms->blog_id ) {
                        $p = "blog.$p";
                    }
                    else {
                        $p = "system.$p";
                    }
                    my $perms
                        = __PACKAGE__->_load_inheritance_permissions($p);
                    push @more_perms, @$perms if $perms;
                }
                if (@more_perms) {
                    my %tmp;
                    my @sort = grep( !$tmp{$_}++, @more_perms );
                    $more = join ',', @sort;
                }
            }
            my $cur_perm = $perms->permissions;
            my @newperms;
            for my $p ( split ',', $more ) {
                $p =~ s/'(.+)'/$1/;
                next if $perms->has($p);
                push @newperms, $p;
            }
            return unless @newperms;
            my $newperm = "'" . join( "','", @newperms ) . "'";
            $newperm = "$cur_perm,$newperm" if $cur_perm;
            $perms->permissions($newperm);
        }
    }

    sub add_restrictions {
        my $perms = shift;
        my ($more_perm) = @_;
        if ( my $more = $more_perm->restrictions ) {
            if ( $more =~ /'administer_blog' | 'administer_website'/ ) {
                $more = _all_perms('blog');
            }
            my $cur_perm = $perms->restrictions;
            my @newperms;
            for my $p ( split ',', $more ) {
                $p =~ s/'(.+)'/$1/;
                next if $perms->is_restricted($p);
                push @newperms, $p;
            }
            return unless @newperms;
            my $newperm = "'" . join( "','", @newperms ) . "'";
            $newperm = "$cur_perm,$newperm" if $cur_perm;
            $perms->restrictions($newperm);
        }
    }

    # Sets permissions of those in a particular set
    sub set_full_permissions {
        my $perms = shift;
        $perms->set_permissions('blog');
    }

    sub set_permissions {
        my $perms = shift;
        __PACKAGE__->_set_these( $perms, 'permissions', @_ );
    }

    sub set_restrictions {
        my $perms = shift;
        __PACKAGE__->_set_these( $perms, 'restrictions', @_ );
    }

    sub _set_these {
        my $pkg   = shift;
        my $perms = shift;
        my ( $column, $set ) = @_;
        my @permissions;
        for my $ref ( @{ perms() } ) {
            next if $set && ( $set ne '*' ) && ( $ref->[2] ne $set );
            push @permissions, $ref->[0];
        }
        $perms->$column( "'" . join( "','", @permissions ) . "'" );
    }

    sub remove_restrictions {
        my $perms    = shift;
        my (@perms)  = @_;
        my $cur_rest = $perms->restrictions;
        return unless $cur_rest;
        for my $perm_name (@perms) {
            $cur_rest =~ s/'$perm_name',?//i;
        }
        $perms->restrictions( $cur_rest || undef );
    }

    # Clears all permissions or those in a particular set
    sub clear_full_permissions {
        my $perms = shift;
        $perms->clear_permissions('blog');
    }

    sub clear_permissions {
        my $perms = shift;
        __PACKAGE__->_clear_these( $perms, 'permissions', @_ );
    }

    sub clear_restrictions {
        my $perms = shift;
        __PACKAGE__->_clear_these( $perms, 'restrictions', @_ );
    }

    sub _clear_these {
        my $pkg   = shift;
        my $perms = shift;
        my ( $column, $set ) = @_;
        my $cur_perm = $perms->$column;
        return unless $cur_perm;
        for my $ref ( @{ perms() } ) {
            next if $set && ( $set ne '*' ) && ( $ref->[2] ne $set );
            my $perm_name = $ref->[0];
            $cur_perm =~ s/'$perm_name',?//i;
        }
        $perms->$column($cur_perm);
    }

    sub perms {
        my $pkg = shift;
        unless (@Perms) {
            if ( my $perms = __PACKAGE__->perms_from_registry() ) {
                foreach my $pk (%$perms) {
                    my ( $scope, $name ) = split /\./, $pk;
                    next unless $scope && $name;
                    my $label
                        = 'CODE' eq ref( $perms->{$pk}{label} )
                        ? $perms->{$pk}{label}->()
                        : $perms->{$pk}{label};
                    push @Perms, [ $name, $label || '', $scope ];
                }
                __mk_perm($_) foreach @Perms;
            }
        }
        if (@_) {
            my $set = shift;
            my @perms = grep { $_->[2] eq $set } @Perms;
            \@perms;
        }
        else {
            \@Perms;
        }
    }

    my %Perms;

    sub __mk_perm {
        no strict 'refs';
        my $ref  = shift;
        my $meth = 'can_' . $ref->[0];
        $Perms{ $ref->[0] } = $ref;
        my $set = $ref->[2];

        return if defined *$meth;

        *$meth = sub {
            my $cur_perm = $_[0]->permissions;
            return undef if !$cur_perm && ( @_ < 2 );
            my $perm = substr $meth, 4;    #remove 'can_'
            if ( @_ == 2 ) {
                if ( $_[1] ) {
                    return 1 if $_[0]->has($perm);
                    $cur_perm .= ',' if $cur_perm;
                    $cur_perm .= "'$perm'";
                }
                else {

                    # arg == 0 - remove it
                    $cur_perm =~ s/'$perm',?// if defined $cur_perm;

                   # the "has no permission" status is NULL, not empty string.
                    if ( ( $cur_perm || '' ) eq '' ) {
                        $cur_perm = undef;
                    }
                }
                $_[0]->permissions($cur_perm);
            }
            else {
                if ( my $author = $_[0]->author ) {
                    return 1
                        if ( ( $meth ne 'can_administer' )
                        && $author->is_superuser );
                    return 1
                        if ( ( $_[0]->blog && $_[0]->blog->is_blog )
                        && $_[0]->has('administer_blog') );
                    return 1
                        if ( ( $_[0]->blog && !$_[0]->blog->is_blog )
                        && $_[0]->has('administer_website') );
                }
            }

            # return negative if a restriction is present
            return undef
                if $_[0]->restrictions && $_[0]->restrictions =~ /'$perm'/i;

            # return positive if permission is set in this permission set
            return 1 if defined($cur_perm) && $cur_perm =~ /'$perm'/i;

            # test for global-level permission
            return 1
                if $_[0]->author_id
                    && $_[0]->blog_id
                    && $_[0]->global_perms
                    && $_[0]->global_perms->has($perm);
            return undef;
        };
    }

    sub set_these_permissions {
        my $perms = shift;
        __PACKAGE__->_set_these_list( $perms, 'permissions', @_ );
    }

    sub set_these_restrictions {
        my $perms = shift;
        __PACKAGE__->_set_these_list( $perms, 'restrictions', @_ );
    }

    sub _set_these_list {
        my $pkg   = shift;
        my $perms = shift;
        my ( $column, @list ) = @_;
        if ( ( ref $list[0] ) eq 'ARRAY' ) {
            @list = @{ $list[0] };
        }
        foreach (@list) {
            my $ref = $Perms{$_};
            die "invalid permission" unless $ref;
            next if $pkg->_check_if( $perms, $column, $_ );
            my $val = $perms->$column || '';
            $val .= ',' if $val ne '';
            $val .= "'" . $ref->[0] . "'";
            $perms->$column($val);
        }
    }

    sub add_permission {
        my $pkg = shift;
        my ($perm) = @_;
        if ( ref $perm eq 'HASH' ) {
            return unless $perm->{key} && $perm->{set};
            my $ref = [ $perm->{key}, $perm->{label} || '', $perm->{set} ];
            push @Perms, $ref;
            __mk_perm($ref);
        }
        elsif ( ref $perm eq 'ARRAY' ) {
            push @Perms, $perm;
            __mk_perm($perm);
        }
    }

    # $perm->has() and $perm->is_restricted skips any fancy logic,
    # returning true or false depending only on whether the bit is
    # set in this record.
    sub has {
        my $this = shift;
        __PACKAGE__->_check_if( $this, 'permissions', @_ );
    }

    sub is_restricted {
        my $this = shift;
        __PACKAGE__->_check_if( $this, 'restrictions', @_ );
    }

    sub _check_if {
        my $pkg  = shift;
        my $this = shift;
        my ( $column, $perm_name ) = @_;
        my $cur_perm = $this->$column;
        return 0 unless $cur_perm;
        my $r = ( $cur_perm =~ /'$perm_name'/i ) ? 1 : 0;
        return $r;
    }
}

sub can_do {
    my $self = shift;
    return unless $self->permissions;

    my $action = shift;
    my @perms = split /,/, $self->permissions;
    for my $perm (@perms) {
        $perm =~ s/'(.+)'/$1/;
        return 1 if 'administer' eq $perm;
        next if $self->is_restricted($perm);
        $perm = join( '.',
            ( ( $self->blog_id != 0 ? 'blog' : 'system' ), $perm ) );
        my $result = __PACKAGE__->_confirm_action( $perm, $action );
        return $result if defined $result;
    }
    return;
}

sub _confirm_action {
    my $pkg = shift;
    my ( $perm_name, $action, $permissions ) = @_;
    $permissions ||= __PACKAGE__->perms_from_registry();
    my $perm = $permissions->{$perm_name};

    ## No such permission.
    return unless defined $perm;
    if ( exists $perm->{permitted_action}{$action} ) {
        return $perm->{permitted_action}{$action};
    }

    ## search from ancestors
    my $inherits = $perm->{inherit_from};
    return unless defined $inherits;
    for my $inherit (@$inherits) {
        my $res
            = __PACKAGE__->_confirm_action( $inherit, $action, $permissions );
        return $res if defined $res;
    }
    return;
}

sub can_post {
    my $perms = shift;
    if ( my ($val) = @_ ) {
        $perms->can_create_post($val);
        $perms->can_publish_post($val);
        return $val;
    }
    $perms->can_create_post && $perms->can_publish_post;
}

sub can_edit_authors {
    my $perms  = shift;
    my $author = $perms->user;
    $perms->can_administer_blog || ( $author && $author->is_superuser() );
}

sub can_edit_entry {
    my $perms = shift;
    my ( $entry, $author, $status ) = @_;
    die unless $author->isa('MT::Author');
    return 1 if $author->is_superuser();
    unless ( ref $entry ) {
        require MT::Entry;
        $entry = MT::Entry->load($entry)
            or return;
    }

    $perms = $author->permissions( $entry->blog_id )
        or return;

    return $perms->can_manage_pages
        unless $entry->is_entry;

    return 1
        if $perms->can_do('edit_all_entries');

    my $own_entry = $entry->author_id == $author->id;

    if ( defined $status ) {
        return $own_entry
            ? $perms->can_do('edit_own_published_entry')
            : $perms->can_do('edit_all_published_entry');
    }
    else {
        return $own_entry
            ? $perms->can_do('edit_own_unpublished_entry')
            : $perms->can_do('edit_all_unpublished_entry');
    }
}

sub can_republish_entry {
    my $perms = shift;
    my ( $entry, $author ) = @_;
    die unless $author->isa('MT::Author');
    return 1 if $author->is_superuser();
    unless ( ref $entry ) {
        require MT::Entry;
        $entry = MT::Entry->load($entry)
            or return;
    }

    $perms = $author->permissions( $entry->blog_id )
        or return;

    return 1
        if $perms->can_do('rebuild');

    return $perms->can_do('manage_pages')
        unless $entry->is_entry;

    return
           $perms->can_do('edit_all_entries')
        || $perms->can_do('manage_feedback')
        || ( $entry->author_id == $author->id
        && $perms->can_do('publish_own_entry') );
}

sub can_upload {
    my $perms = shift;
    if (@_) {
        if ( my $can = shift ) {
            $perms->set_these_permissions('upload');
        }
        else {
            $perms->clear_permissions('upload');
        }
    }
    return $perms->can_do('upload');
}

sub can_view_feedback {
    my $perms = shift;
    $perms->can_do('view_feedback');
}

sub is_empty {
    my $perms = shift;
    !( defined( $perms->permissions ) && $perms->permissions );
}

sub _static_rebuild {
    my $pkg = shift;
    my ($obj) = @_;

    if ( $obj->isa('MT::Association') ) {
        my $assoc = $obj;
        if ( $assoc->role_id && $assoc->blog_id ) {
            if ( $assoc->group_id ) {
                my $grp = $assoc->group or return;
                my $iter = $grp->user_iter;
                while ( my $user = $iter->() ) {
                    my $perm = MT::Permission->get_by_key(
                        {   author_id => $user->id,
                            blog_id   => $assoc->blog_id
                        }
                    );
                    $perm->rebuild;
                }
            }
            elsif ( $assoc->author_id ) {
                my $user = $assoc->user or return;
                my $perm = MT::Permission->get_by_key(
                    {   author_id => $user->id,
                        blog_id   => $assoc->blog_id
                    }
                );
                $perm->rebuild;
            }
        }
        elsif ( $assoc->author_id && $assoc->group_id ) {

            # rebuild permissions for author
            my $grp = $assoc->group or return;
            my $blog_iter = $grp->blog_iter;
            my @blogs;
            if ($blog_iter) {
                while ( my $blog = $blog_iter->() ) {
                    push @blogs, $blog->id;
                }
            }
            if (@blogs) {
                foreach my $blog_id (@blogs) {
                    my $perm = MT::Permission->get_by_key(
                        {   author_id => $assoc->author_id,
                            blog_id   => $blog_id,
                        }
                    );
                    $perm->rebuild;
                }
            }
        }
    }
    1;
}

sub rebuild {
    my $perm = shift;
    if ( !ref $perm ) {
        return $perm->_static_rebuild(@_);
    }

    # rebuild permissions for this user / blog
    my $user_id = $perm->author_id;
    my $blog_id = $perm->blog_id;

    return unless $user_id && $blog_id;

    # clean slate
    $perm->clear_full_permissions;
    my $has_permissions = 0;

    # find all blogs for this user
    my $user = MT::Author->load($user_id) or return;

    my $role_iter = $user->role_iter( { blog_id => $blog_id } );
    if ($role_iter) {
        while ( my $role = $role_iter->() ) {
            $perm->add_permissions($role);
            $has_permissions = 1;
        }
    }

    # find all blogs for this user through groups
    $role_iter = $user->group_role_iter( { blog_id => $blog_id } );
    if ($role_iter) {
        while ( my $role = $role_iter->() ) {
            $perm->add_permissions($role);
            $has_permissions = 1;
        }
    }

    if ($has_permissions) {
        $perm->save;
    }
    else {
        $perm->remove if $perm->id;
    }
}

sub load_same {
    my $pkg = shift;
    my ( $terms, $args, $exact, @list ) = @_;
    if ( ( ref $list[0] ) eq 'ARRAY' ) {
        @list = @{ $list[0] };
    }
    foreach (@list) {
        $_ =~ s/^([^'].+[^'])$/'$1'/;
    }

    my %terms = map { $_ => $terms->{$_} } keys %$terms;
    my %args  = map { $_ => $args->{$_} } keys %$args;
    $args{like} = { 'permissions' => 1 };
    my @ids;
    my @roles = ();
    for my $key (@list) {
        $terms{permissions} = "%" . $key . "%";
        $terms{id} = \@ids if scalar(@ids);

        my @tmp_roles = $pkg->load( \%terms, \%args );
        unless ( scalar @tmp_roles ) {
            @roles = ();
            last;
        }
        delete $args{not};    # not is used only the first time
        @ids = map { $_->id } @tmp_roles;
        @roles = @tmp_roles;
    }
    return ( wantarray ? () : undef ) unless scalar(@roles);
    if ($exact) {
        my $base_len = length( join( ',', @list ) );
        @roles = grep { length( $_->permissions ) == $base_len } @roles;
    }
    return wantarray ? @roles : ( ( scalar @roles ) ? $roles[0] : undef );
}

sub to_hash {
    my $perms     = shift;
    my $hash      = {};                        # $perms->SUPER::to_hash(@_);
    my $all_perms = MT::Permission->perms();
    foreach (@$all_perms) {
        my $perm = $_->[0];
        $perm = 'can_' . $perm;
        $hash->{"permission.$perm"} = $perms->$perm();
    }
    $hash;
}

sub _load_inheritance_permissions {
    my $pkg         = shift;
    my ($perm_name) = @_;
    my $permissions = __PACKAGE__->perms_from_registry();
    my $perms       = $pkg->_load_recursive( $perm_name, $permissions );

    my $hash;
    if (@$perms) {
        foreach (@$perms) {
            my ( $s, $p ) = split /\./, $_;
            $hash->{$p} = 1;
        }
        @$perms = keys %$hash;
    }

    return $perms;
}

sub _load_recursive {
    my $pkg = shift;
    my ( $perm_name, $permissions ) = @_;
    $permissions ||= __PACKAGE__->perms_from_registry();

    my $perms;
    push @$perms, $perm_name;

    my $permission = $permissions->{$perm_name};
    return $perms unless $permission;

    my $inherits = $permission->{inherit_from};
    return $perms unless $inherits;

    foreach my $inherit (@$inherits) {
        my $res = __PACKAGE__->_load_recursive( $inherit, $permissions );
        push @$perms, @$res if defined $res;
    }

    return $perms;
}

sub load_permissions_from_action {
    my $pkg = shift;
    my ($action) = @_;
    my $permissions ||= __PACKAGE__->perms_from_registry();
    my $perms;

    foreach my $p ( keys %$permissions ) {
        push @$perms, $p
            if $pkg->_confirm_action( $p, $action, $permissions );
    }
    return $perms;
}

1;
__END__

=head1 NAME

MT::Permission - Movable Type permissions record

=head1 SYNOPSIS

    use MT::Permission;
    my $perms = MT::Permission->load({ blog_id => $blog->id,
                                       author_id => $author->id })
        or die "User has no permissions for blog";
    $perms->can_create_post
        or die "User cannot publish to blog";

    $perms->can_edit_config(0);
    $perms->save
        or die $perms->errstr;

=head1 DESCRIPTION

An I<MT::Permission> object represents the permissions settings for a user
in a particular blog. Permissions are set on a role basis, and each permission
is either on or off for an user-blog combination; permissions are stored as
a bitmask.

Note: The I<MT::Permission> object is not meant to be modified or created
directly. Permissions should be assigned to users through role associations,
or through MT::Author's can_xxx methods for system level privileges.
The I<MT::Permission> object is actually managed by Movable Type purely, and
is a flattened view of all the permissions a particular user has for a single
blog.  Users' system level privileges are also stored in MT::Permission record
with blog_id = 0.

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::Permission> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

The following methods are unique to the I<MT::Permission> interface. Each of
these methods, B<except> for I<set_full_permissions>, can be called with an
optional argument to turn the permission on or off. If the argument is some
true value, the permission is enabled; otherwise, the permission is disabled.
If no argument is provided at all, the existing permission setting is
returned.

=head2 MT::Permission->perms( [ $set ] )

Returns an array reference containing the list of available permissions. The
array is a list of permissions, each of which is an array reference with
the following items:

    [ key, label, set ]

The 'key' element is the value of that permission and is also a unique 
identifier that is used to identify the permission. Declared permissions
may be tested through a 'can' method that is added to the MT::Permission
namespace when registering them. So if you register with a 'key' value 
of 'foo', this creates a method 'can_foo', which may be tested for like this:

    my $perm = $app->permissions;
    if ($perm->can_foo) {
        $app->foo;
    }

The 'label' element is a phrase that identifies the permission.

The 'set' element identifies which group or category of permissions the
permission is associated with. Currently, there are two sets of 
permissions: 'blog' and 'system'.

If you call the perms method with the $set parameter, it will only return
permissions declared with that 'set' identifier.

=head2 MT::Permission->add_permission( \%perm )

=head2 MT::Permission->add_permission( \@perm )

Both of these methods can be used to register a new permission with
Movable Type.

Note: It is not advisable to call these method to register custom permissions
without having preregistered for one from Six Apart, Ltd. This will
reserve your permission and allow it to coexist with other plugins and
future permissions defined by Movable Type itself.

When calling add_permission with a hashref, you should specify these
elements in the hash:

=over 4

=item * key

=item * label

=item * set

=back

See the 'perms' method documentation for more information on these
elements.

If calling the add_permission method with an arrayref, you should
specify the elements of the array in the same order as given by
the 'perms' method. You may only register one permission per call
to the add_permission method.

=head2 $perms->set_full_permissions()

Turns on all blog-level permissions.

=head2 $perms->clear_full_permissions()

Turns off all permissions.

=head2 $perms->set_permissions($set)

Sets all permissions identified by the group C<$set> (use '*' to include
all permissions regardless of grouping).

=head2 $perms->clear_permissions($set)

Clears all permissions identified by the group C<$set> (use '*' to include
all permissions regardless of grouping).

=head2 $perms->add_permissions($more_perms)

Adds C<$more_perms> to C<$perms>.

=head2 $perms->set_these_permissions(@permission_names)

Adds permissions (enabling them) to the existing permission object.

    $perms->set_these_permissions('view_blog_log', 'create_post');

=head2 MT::Permission->rebuild($assoc)

Rebuilds permission objects affected by the given L<MT::Association> object.

=head2 $perms->rebuild()

Rebuilds the single permission object based on the user/group/role/blog
relationships that can be found for the author and blog tied to the
permission.

=head2 $perms->has($permission_name)

Returns true or false depending only on whether the bit identified by
C<$permission_name> is set in this permission object.

=head2 $perms->can_administer_blog

Returns true if the user can administer the blog. This is a blog-level
"superuser" capability.

=head2 $perms->can_create_post

Returns true if the user can post to the blog , and edit the entries that
he/she has posted; false otherwise.

=head2 $perms->can_publish_post

Returns true if the user can publish his/her post; false otherwise.

=head2 $perms->can_post

(Backward compatibility API) Returns true if the user can post to the blog,
and edit the entries that he/she has posted and publish the post; false otherwise.

=head2 $perms->can_upload

Returns true if the user can upload files to the blog directories specified
for this blog, false otherwise.

=head2 $perms->can_edit_all_posts

Returns true if the user can edit B<all> entries posted to this blog (even
entries that he/she did not write), false otherwise.

=head2 $perms->can_edit_templates

Returns true if the user can edit the blog's templates, false otherwise.

=head2 $perms->can_send_notifications

Returns true if the user can send messages to the notification list, false
otherwise.

=head2 $perms->can_edit_categories

Returns true if the user can edit the categories defined for the blog, false
otherwise.

=head2 $perms->can_edit_tags

Returns true if the user can edit the tags defined for the blog, false
otherwise.

=head2 $perms->can_edit_notifications

Returns true if the user can edit the notification list for the blog, false
otherwise.

=head2 $perms->can_view_blog_log

Returns true if the user can view the activity log for the blog, false
otherwise.

=head2 $perms->can_rebuild

Returns true if the user can edit the rebuild the blog, false otherwise.

=head2 $perms->can_edit_config

Returns true if the user can edit the blog configuration, false otherwise.

(Backward compatibility warning) can_edit_config no longer means the user
can set and modify publishing paths (site_path, site_url, archive_path and
archive_url) for the weblog.  Use can_set_publish_paths.

=head2 $perms->can_set_publish_paths

Returns true if the user can set publishing paths, false otherwise.

=head2 $perms->can_edit_authors()

Returns true if the 'administer_blog' permission is set or the associated
author has superuser rights.

=head2 $perms->can_edit_entry($entry, $author)

Returns true if the C<$author> has rights to edit entry C<$entry>. This
is always true if C<$author> is a superuser or can edit all posts or
is a blog administrator for the blog that contains the entry. Otherwise,
it returns true if the author has permission to post and the entry was
authored by that author, false otherwise.

The C<$entry> parameter can either be a I<MT::Entry> object or an entry id.

=head2 $perms->can_republish_entry($entry, $author)

Returns true if the C<$author> has rights to republish entry C<$entry>.
This is always true if C<$author> is a superuser or can edit all posts or
can rebuild or can manage feedback or is a blog administrator for the blog
that contains the entry. Otherwise, it returns true if the author has
permission to post and the entry was authored by that author, false otherwise.

The C<$entry> parameter can either be a I<MT::Entry> object or an entry id.

=head2 $perms->can_manage_feedback

Returns true if the C<$author> has rights to manage feedbacks (comments
and trackbacks) as well as IP ban list.

=head2 $perms->can_view_feedback

TODO Returns true if permission indicates the user can list comments and trackbacks.

=head2 $perms->can_administer

Returns true if the user in question is a system administrator, false otherwise.

=head2 $perms->can_view_log

Returns true if the user can view system level activity log, false otherwise.

=head2 $perms->can_create_blog

Returns true if the user can create a new weblog, false otherwise.

=head2 $perms->can_create_website

Returns true if the user can create a new website, false otherwise.

=head2 $perms->can_manage_plugins

Returns true if the user can enable/disable, and configure plugins in system level,
false otherwise.

=head2 $perms->can_not_comment

Returns true if the user has been banned from commenting on the blog.
This permission is used for authenticated commenters.

=head2 $perms->can_comment

Returns true if the user has been approved for commenting on the blog.
This permission is used for authenticated commenters.

=head2 $perms->blog

Returns the I<MT::Blog> object for this permission object.

=head2 $perms->user

=head2 $perms->author

Returns the I<MT::Author> object for this permission object. The C<author>
method is deprecated in favor of C<user>.

=head2 $perms->to_hash

Returns a hashref that represents the contents of the permission object.
Elements are in the form of (enabled permissions are set, disabled
permissions are set to 0):

    { 'permission.can_edit_templates' => 16,
      'permission.can_rebuild' => 0,
      # ....
      'permission.can_create_post' => 2 }

=head2 $class->load_same($terms, $args, $exact, @list)

Returns an array or an object depending on context, of permission records
which have specified list of permissions.  If $exact is set to True, permission
records which have exact match to the list are returned.  $terms and $args
can be used to further narrow down results.

=head1 DATA ACCESS METHODS

The I<MT::Comment> object holds the following pieces of data. These fields can
be accessed and set using the standard data access methods described in the
I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of this permissions record.

=item * author_id

The numeric ID of the user associated with this permissions record.

=item * blog_id

The numeric ID of the blog associated with this permissions record.

=item * role_mask

=item * role_mask2

=item * role_mask3

=item * role_mask4

These bitmask fields are deprecated in favor of text based permissions
column.

=item * permissions

Permissions are stored in this column like 'Perm1','Perm_2','Pe_rm_3'.

=item * entry_prefs

The setting of display fields of "edit entry" page.  The value
at author_id 0 means default setting of a blog.

=item * page_prefs

The setting of display fields of "edit page" page.  The value
at author_id 0 means default setting of a blog.

=item * template_prefs

The setting of display  "edit template" page.  The value
at author_id 0 means default setting of a blog.

=back

=head1 DATA LOOKUP

In addition to numeric ID lookup, you can look up or sort records by any
combination of the following fields. See the I<load> documentation in
I<MT::Object> for more information.

=over 4

=item * blog_id

=item * author_id

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for user, copyright, and license information.

=cut
