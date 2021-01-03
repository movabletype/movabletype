# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Role;

use strict;
use warnings;
use base qw( MT::Object );

# NOTE: Keep the role_mask fields defined here in sync with those in
# MT::Permission.
__PACKAGE__->install_properties(
    {   column_defs => {
            id          => 'integer not null auto_increment',
            name        => 'string(255) not null',
            description => 'text',
            is_system   => 'boolean',
            role_mask   => 'integer',
            role_mask2  => 'integer',                        # for upgrades...
            role_mask3  => 'integer',
            role_mask4  => 'integer',
            permissions => 'text',
        },
        indexes => {
            name       => 1,
            is_system  => 1,
            created_on => 1,
        },
        defaults      => { is_system => 0, },
        child_classes => ['MT::Association'],
        audit         => 1,
        datasource    => 'role',
        primary_key   => 'id',
    }
);

sub class_label {
    return MT->translate('Role');
}

sub class_label_plural {
    return MT->translate('Roles');
}

sub list_props {
    return {
        name => {
            auto       => 1,
            label      => 'Name',
            display    => 'force',
            order      => 100,
            sub_fields => [
                {   class => 'description',
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
                        { role_id => \@ids, },
                        { group   => ['role_id'], },
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
                my $asc_count = $prop->asc_count( $objs, $opts );
                my @out;
                for my $obj (@$objs) {
                    my $len  = 40;                  ## FIXME: Hard coded
                    my $desc = $obj->description;
                    if ( length $desc > $len ) {
                        $desc = substr( $desc, 0, $len );
                        $desc .= '...';
                    }
                    $desc = MT::Util::encode_html($desc);
                    my $url = $app->uri(
                        mode => 'view',
                        args => {
                            _type   => 'role',
                            id      => $obj->id,
                            blog_id => 0,
                        }
                    );
                    my $name = MT::Util::encode_html( $obj->name );
                    push @out, qq{
                        <a href="$url">$name</a>
                    } . (
                        $desc
                        ? qq{
                        <p class="description">$desc</p>
                    }
                        : q{}
                    );
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
            filter_type => 'role_id',
            view_filter => [],
        },
        active_inactive => {
            base    => '__virtual.single_select',
            label   => '__ROLE_STATUS',
            display => 'none',
            terms   => sub {
                my $prop = shift;
                my ( $args, $base_terms, $base_args, $opts, ) = @_;
                my $val = $args->{value};
                if ( $val eq 'active' ) {
                    $base_args->{joins} ||= [];
                    push @{ $base_args->{joins} },
                        MT->model('association')->join_on(
                        undef,
                        { id => \'is not null', },
                        {   unique    => 1,
                            type      => 'left',
                            condition => { role_id => \'= role_id' },
                        },
                        );
                }
                else {
                    $base_args->{joins} ||= [];
                    push @{ $base_args->{joins} },
                        MT->model('association')->join_on(
                        undef,
                        { id => \'is null', },
                        {   unique    => 1,
                            type      => 'left',
                            condition => { role_id => \'= role_id' },
                        },
                        );
                }
            },
            single_select_options => [
                {   label => MT->translate('__ROLE_ACTIVE'),
                    value => 'active',
                },
                {   label => MT->translate('__ROLE_INACTIVE'),
                    value => 'inactive',
                },
            ],
        },
        description => {
            auto      => 1,
            label     => 'Description',
            use_blank => 1,
            display   => 'none',
        },
        created_on => {
            base  => '__virtual.created_on',
            order => 300,
        },
        modified_on => {
            base    => '__virtual.modified_on',
            display => 'none',
        },
        created_by => {
            base    => '__virtual.author_name',
            label   => 'Created by',
            display => 'none',
        },
        modified_by => {
            auto            => 1,
            display         => 'none',
            filter_editable => 0,
        },
        content => {
            base    => '__virtual.content',
            fields  => [qw( name description )],
            display => 'none',
        },
    };
}

sub save {
    my $role = shift;
    my $res = $role->SUPER::save(@_) or return;

    require MT::Association;

    # now, update MT::Permissions to reflect role update
    if (my $assoc_iter = MT::Association->load_iter(
            {   type => [
                    MT::Association::USER_BLOG_ROLE(),
                    MT::Association::GROUP_BLOG_ROLE()
                ],
                role_id => $role->id,
            }
        )
        )
    {
        while ( my $assoc = $assoc_iter->() ) {
            $assoc->rebuild_permissions;
        }
    }

    $res;
}

sub remove {
    my $role = shift;
    if ( ref $role ) {
        my @assoc
            = MT->model('association')->load( { role_id => $role->id } );
        $role->remove_children( { key => 'role_id' } ) or return;
        $_->rebuild_permissions foreach @assoc;
    }
    $role->SUPER::remove(@_);
}

sub load_same {
    my $class = shift;
    require MT::Permission;
    MT::Permission::load_same( $class, @_ );
}

sub load_by_permission {
    my $class = shift;
    my (@list) = @_;
    require MT::Permission;
    MT::Permission::load_same( $class, undef, undef, 0, @list );
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

    my @default_roles = _default_roles();

    require MT::Role;
    return 1 if MT::Role->exist();

    foreach my $r (@default_roles) {
        my $role = MT::Role->new();
        $role->name( $r->{name} );
        $role->description( $r->{description} );
        $role->clear_full_permissions;
        $role->set_these_permissions( $r->{perms} );
        if ( $r->{name} =~ m/^System/ ) {
            $role->is_system(1);
        }
        $role->role_mask( $r->{role_mask} ) if exists $r->{role_mask};
        $role->save
            or return $class->error( $role->errstr );
    }

    1;
}

sub _default_roles {
    return +(
        {   name        => MT->translate('Site Administrator'),
            description => MT->translate('Can administer the site.'),
            perms       => ['administer_site']
        },
        {   name        => MT->translate('Editor'),
            description => MT->translate(
                'Can upload files, edit all entries(categories), pages(folders), tags and publish the site.'
            ),
            perms => [
                'comment',             'create_post',
                'publish_post',        'edit_all_posts',
                'edit_categories',     'edit_tags',
                'manage_pages',        'rebuild',
                'upload',              'send_notifications',
                'manage_feedback',     'edit_assets',
                'manage_content_data', 'manage_category_set'
            ],
        },
        {   name        => MT->translate('Author'),
            description => MT->translate(
                'Can create entries, edit their own entries, upload files and publish.'
            ),
            perms => [
                'comment',      'create_post',
                'publish_post', 'upload',
                'send_notifications'
            ],
        },
        {   name        => MT->translate('Designer'),
            description => MT->translate(
                'Can edit, manage, and publish blog templates and themes.'),
            role_mask => ( 2**4 + 2**7 ),
            perms     => [
                'manage_themes', 'edit_templates',
                'rebuild',       'upload',
                'edit_assets'
            ]
        },
        {   name        => MT->translate('Webmaster'),
            description => MT->translate(
                'Can manage pages, upload files and publish site/child site templates.'
            ),
            perms => [ 'manage_pages', 'rebuild', 'upload' ]
        },
        {   name        => MT->translate('Contributor'),
            description => MT->translate(
                'Can create entries, edit their own entries, and comment.'),
            perms => [ 'comment', 'create_post' ],
        },
        {   name        => MT->translate('Content Designer'),
            description => MT->translate(
                'Can manage content types, content data and category sets.'
            ),
            perms => [
                'manage_content_types', 'manage_content_data',
                'manage_category_set'
            ],
        },
    );
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
