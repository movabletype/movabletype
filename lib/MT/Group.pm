# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Group;

use strict;
use base qw( MT::Object );

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'           => 'integer not null auto_increment',
            'name'         => 'string(255) not null',
            'display_name' => 'string(255)',
            'description'  => 'text',
            'status'       => 'integer',
            'external_id'  => 'string(255)',
        },
        defaults => { status => 1, },
        indexes  => {
            created_on  => 1,
            name        => 1,
            status      => 1,
            external_id => 1,
        },
        child_classes => ['MT::Association'],
        datasource    => 'group',
        primary_key   => 'id',
        audit         => 1,
    }
);

sub class_label {
    return MT->translate('Group');
}

sub class_label_plural {
    return MT->translate('Groups');
}

sub ACTIVE ()   {1}
sub INACTIVE () {2}

use Exporter;
*import = \&Exporter::import;
use vars qw(@EXPORT_OK %EXPORT_TAGS);
@EXPORT_OK = qw(ACTIVE INACTIVE);
%EXPORT_TAGS = ( constants => [qw(ACTIVE INACTIVE)] );

sub is_active { shift->status(@_) == ACTIVE; }

# TBD: use MT->instance->user_class ??

sub remove {
    my $group = shift;
    if ( ref $group ) {
        my @authors;
        require MT::Association;
        my $iter = MT::Association->load_iter(
            {   type     => MT::Association::USER_GROUP(),
                group_id => $group->id,
            },
            { fetchonly => { author_id => 1 }, }
        );
        while ( my $a = $iter->() ) {
            push @authors, $a->author_id;
        }

        my @blogs;
        $iter = MT::Association->load_iter(
            {   type     => MT::Association::GROUP_BLOG_ROLE(),
                group_id => $group->id,
            },
            { fetchonly => { blog_id => 1 }, }
        );
        while ( my $b = $iter->() ) {
            push @blogs, $b->blog_id;
        }

        $group->remove_children( { key => 'group_id' } ) or return;

        if ( @authors || @blogs ) {
            require MT::Permission;
            $iter = MT::Permission->load_iter(
                {   ( @authors ? ( author_id => \@authors ) : () ),
                    ( @blogs   ? ( blog_id   => \@blogs )   : () ),
                }
            );
            while ( my $p = $iter->() ) {
                $p->rebuild;
            }
        }
    }
    $group->SUPER::remove(@_);
}

sub user_iter {
    my $group = shift;
    my ( $terms, $args ) = @_;
    require MT::Association;
    require MT::Author;
    $args->{join} = MT::Association->join_on(
        'author_id',
        {   type     => MT::Association::USER_GROUP(),
            group_id => $group->id,
        }
    );
    MT::Author->load_iter( $terms, $args );
}

sub blog_iter {
    my $group = shift;
    my ( $terms, $args ) = @_;

    # restore once we allow group-system role associations
    #my $perm = $group->permissions;
    #if (!$perm->can_administer) {
    require MT::Association;
    $args->{join} = MT::Association->join_on(
        'blog_id',
        {   type     => MT::Association::GROUP_BLOG_ROLE(),
            group_id => $group->id,
        }
    );
    $args->{unique}   = 1;
    $args->{no_class} = 1;

    #}
    require MT::Blog;
    MT::Blog->load_iter( $terms, $args );
}

sub user_count {
    my $group = shift;
    my ( $terms, $args ) = @_;
    require MT::Association;
    require MT::Author;
    $args->{join} = MT::Association->join_on(
        'author_id',
        {   type     => MT::Association::USER_GROUP(),
            group_id => $group->id,
        }
    );
    my $count = MT::Author->count( $terms, $args );
    return $count + 0;
}

sub role_iter {
    my $group = shift;
    my ( $terms, $args ) = @_;
    my $type;
    require MT::Association;
    my $blog_id = delete $terms->{blog_id};
    if ($blog_id) {
        $type = MT::Association::GROUP_BLOG_ROLE();
    }
    else {
        $type = MT::Association::GROUP_ROLE();
    }
    $args->{join} = MT::Association->join_on(
        'role_id',
        {   type     => $type,
            group_id => $group->id,
            $blog_id ? ( blog_id => $blog_id ) : (),
        }
    );
    require MT::Role;
    MT::Role->load_iter( $terms, $args );
}

sub add_user {
    my $group = shift;
    my ($user) = @_;
    $group->save unless $group->id;
    $user->save  unless $user->id;
    require MT::Association;
    MT::Association->link( $group, @_ );
}

sub remove_user {
    my $group = shift;
    require MT::Association;
    MT::Association->unlink( $group, @_ );
}

sub add_role {
    my $group = shift;
    my ( $role, $blog ) = @_;
    $group->save unless $group->id;
    $role->save  unless $role->id;
    $blog->save if $blog && !$blog->id;
    require MT::Association;
    MT::Association->link( $group, @_ );
    1;
}

sub remove_role {
    my $group = shift;
    require MT::Association;
    MT::Association->unlink( $group, @_ );
}

sub external_id {
    my $group = shift;
    if (@_) {
        return $group->column( 'external_id',
            $group->unpack_external_id(@_) );
    }
    my $value = $group->column('external_id');
    $value = $group->pack_external_id($value) if $value;
}

sub save {
    my $group         = shift;
    my $rebuild_perms = 0;
    if ( $group->id ) {
        $rebuild_perms = exists( $group->{changed_cols}->{status} ) ? 1 : 0;
    }
    my $res = $group->SUPER::save(@_)
        or return $group->error( $group->errstr() );
    if ($rebuild_perms) {
        require MT::Association;
        if (my $assoc_iter = MT::Association->load_iter(
                {   type => [
                        MT::Association::GROUP_ROLE(),
                        MT::Association::GROUP_BLOG_ROLE()
                    ],
                    group_id => $group->id,
                }
            )
            )
        {
            while ( my $assoc = $assoc_iter->() ) {
                $assoc->rebuild_permissions;
            }
        }
    }
    $res;
}

sub load {
    my $group = shift;
    my ( $terms, $args ) = @_;
    if ( ( ref($terms) eq 'HASH' ) && exists( $terms->{external_id} ) ) {
        $terms->{external_id}
            = $group->unpack_external_id( $terms->{external_id} );
    }
    $group->SUPER::load( $terms, $args );
}

sub load_iter {
    my $group = shift;
    my ( $terms, $args ) = @_;
    if ( ( ref($terms) eq 'HASH' ) && exists( $terms->{external_id} ) ) {
        $terms->{external_id}
            = $group->unpack_external_id( $terms->{external_id} );
    }
    $group->SUPER::load_iter( $terms, $args );
}

sub pack_external_id { return pack( 'H*', $_[1] ); }
sub unpack_external_id { return unpack( 'H*', $_[1] ); }

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    if ( defined($blog_ids) && scalar(@$blog_ids) ) {
        return {
            term => undef,
            args => {
                'join' => [
                    'MT::Association', 'group_id',
                    { blog_id => $blog_ids }, { unique => 1 }
                ]
            }
        };
    }
    else {
        return { term => undef, args => undef };
    }
}

sub backup_plugin_cb {
    my ( $cb, $blog_ids, $progress, $else_xml, $backuped_objs ) = @_;
    return 1 unless defined($blog_ids) && scalar(@$blog_ids);
    my @group_ids = @{ $backuped_objs->{'MT::Group'} || [] };

    my $backuped_authors = ( $backuped_objs->{'MT::Author'} ||= [] );
    my %backuped_authors = map { ( $_ => 1 ) } @$backuped_authors;
    my $out = '';
    my %authors_to_backup;

    if (@group_ids) {

        my $class = MT->model('association');
        my $iter  = $class->load_iter(
            {   blog_id  => 0,
                type     => MT::Association::USER_GROUP(),
                group_id => \@group_ids
            }
        );
        return 1 unless $iter;

        my @assoc_meta;
        if ( exists( $class->properties->{meta} )
            && $class->properties->{meta} )
        {
            require MT::Meta;
            @assoc_meta = MT::Meta->metadata_by_class($class);
        }

        my $as_count = 0;

        my $state = MT->translate( 'Exporting [_1] records:', $class );
        $progress->( $state, $class->class_type || $class->datasource );
        while ( my $as = $iter->() ) {
            $out .= $as->to_xml( undef, \@assoc_meta ) . "\n";
            $as_count++;
            next if exists $backuped_authors{ $as->author_id };
            $authors_to_backup{ $as->author_id } = 1;
        }
        $progress->(
            $state . " "
                . MT->translate( "[_1] records exported...", $as_count ),
            $class->class_type || $class->datasource
        );
    }

    if (%authors_to_backup) {
        my $class = MT->model('author');
        my @author_meta;
        if ( exists( $class->properties->{meta} )
            && $class->properties->{meta} )
        {
            require MT::Meta;
            @author_meta = MT::Meta->metadata_by_class($class);
        }

        my $state = MT->translate( 'Exporting [_1] records:', $class );
        $progress->( $state, $class->class_type || $class->datasource );
        my $author_count = 0;

        my @authors_to_backup = keys %authors_to_backup;
        while (@authors_to_backup) {
            my @ids = splice( @authors_to_backup, 0, 50 );
            my $iter = $class->load_iter( { id => \@ids } );
            next unless $iter;
            while ( my $author = $iter->() ) {
                $out .= $author->to_xml( undef, \@author_meta ) . "\n";
                $author_count++;
                $backuped_authors{ $author->author_id } = 1;
                push @$backuped_authors, $author->author_id;
            }
        }
        $progress->(
            $state . " "
                . MT->translate( "[_1] records exported...", $author_count ),
            $class->class_type || $class->datasource
        );
    }

    push @$else_xml, $out if $out;
}

sub list_props {
    return {
        name => {
            auto    => 1,
            label   => 'Name',
            display => 'force',
            order   => 100,
            html    => sub {
                my ( $prop, $obj, $app ) = @_;
                my $name        = MT::Util::encode_html( $obj->name );
                my $description = MT::Util::encode_html( $obj->description );
                my $edit_url    = $app->uri(
                    mode => 'view',
                    args => {
                        _type   => 'group',
                        id      => $obj->id,
                        blog_id => 0,
                    },
                );
                my $status
                    = $obj->status == MT::Group::ACTIVE()
                    ? 'enabled'
                    : 'disabled';
                my $status_label            = ucfirst $status;
                my $translated_status_label = $app->translate($status_label);
                my $badge_type
                    = $obj->status == MT::Group::ACTIVE()
                    ? 'success'
                    : 'default';
                my $description_block
                    = ( length($description) > 0 )
                    ? qq{<p class="description">$description</p>}
                    : q{};
                my $static_uri = $app->static_path;

                if ( $app->can_do('edit_groups') ) {
                    return qq{
                      <span class="status $status">
                          <svg role="img" class="mt-icon mt-icon--sm">
                              <title>$status_label</title>
                              <use xlink:href="${static_uri}images/sprite.svg#ic_member"></use>
                          </svg>
                      </span>
                      <span class="groupname">
                          <a href="$edit_url">$name</a>
                          <span class="badge badge-$badge_type">$translated_status_label</span>
                      </span>
                      $description_block
                  };
                }
                else {
                    return qq{
                      <span class="status $status">
                          <svg role="img" class="mt-icon mt-icon--sm">
                              <title>$status</title>
                              <use xlink:href="${static_uri}images/sprite.svg#ic_member"></use>
                          </svg>
                      </span>
                      <span class="groupname">
                          $name
                          <span class="badge badge-$badge_type">$translated_status_label</span>
                      </span>
                      $description_block
                  };
                }
            },
        },
        display_name => {
            auto      => 1,
            label     => 'Display Name',
            display   => 'default',
            use_blank => 1,
            order     => 200,
        },
        member_count => {
            label              => '__GROUP_MEMBER_COUNT',
            display            => 'default',
            base               => '__virtual.object_count',
            order              => 300,
            count_class        => 'association',
            count_col          => 'group_id',
            count_terms        => { author_id => { not => 0 } },
            filter_type        => 'group_id',
            list_screen        => 'group_member',
            list_permit_action => 'access_to_any_group_list',
        },
        created_on => {
            base    => '__virtual.created_on',
            display => 'none',
        },
        modified_on => {
            base    => '__virtual.modified_on',
            display => 'none',
        },
        description => {
            label     => 'Description',
            auto      => 1,
            display   => 'none',
            use_blank => 1,
        },
        status => {
            label                 => 'Status',
            base                  => '__virtual.single_select',
            col                   => 'status',
            display               => 'none',
            single_select_options => sub {
                return [
                    {   label => MT->translate('Enabled'),
                        text  => 'Enabled',
                        value => 1,
                    },
                    {   label => MT->translate('Disabled'),
                        text  => 'Disabled',
                        value => 2,
                    }
                ];
            },
        },
        author_id => {
            base            => '__virtual.integer',
            label           => 'Author',
            filter_label    => 'My Groups',
            display         => 'none',
            filter_editable => 0,
            terms           => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                my $aid               = $args->{value};
                my $association_class = MT->model('association');
                $db_args->{joins} ||= [];
                push @{ $db_args->{joins} },
                    $association_class->join_on(
                    'group_id',
                    {   type      => $association_class->USER_GROUP(),
                        author_id => $aid,
                    },
                    );
            },
            label_via_param => sub {
                my $prop = shift;
                my ( $app, $val ) = @_;
                my $author = MT->model('author')->load($val);
                MT->translate(
                    'Groups associated with author: [_1]',
                    MT::Util::encode_html(
                        $author->nickname || $author->name
                    ),
                );
            },
        },
        content => {
            base    => '__virtual.content',
            fields  => [ 'name', 'display_name', 'description' ],
            display => 'none',
        },
    };

}

sub member_list_props {
    return {
        name => {
            label      => 'Username',
            col        => 'name',
            display    => 'force',
            order      => 100,
            base       => '__virtual.string',
            sub_fields => [
                {   class   => 'userpic',
                    label   => 'Userpic',
                    display => 'optional',
                },
                {   class   => 'user-info',
                    label   => 'User Info',
                    display => 'optional',
                },
            ],
            html => sub {
                my ( $prop, $obj, $app ) = @_;
                MT::Author::_bulk_author_name_html( $prop, [ $obj->user ],
                    $app );
            },
            bulk_sort => sub {
                my $prop = shift;
                my ($objs) = @_;
                sort { $a->user->name cmp $b->user->name } @$objs;
            },
            terms => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                my $term = $prop->super(@_);
                $db_args->{joins} ||= [];
                push @{ $db_args->{joins} },
                    MT->model('author')->join_on(
                    undef,
                    {   id   => \'= association_author_id',
                        name => $term->{name},
                    },
                    {}
                    );
            },
            sort => 0,
        },
        nickname => {
            base    => '__virtual.string',
            col     => 'name',
            label   => 'Display Name',
            order   => 200,
            display => 'default',
            html    => sub {
                my ( $prop, $obj, $app ) = @_;
                MT::Author::_nickname_bulk_html( $prop, [ $obj->user ],
                    $app );
            },
            bulk_sort => sub {
                my $prop = shift;
                my ($objs) = @_;
                sort { $a->user->nickname cmp $b->user->nickname } @$objs;
            },
            terms => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                my $term = $prop->super(@_);
                $db_args->{joins} ||= [];
                push @{ $db_args->{joins} },
                    MT->model('author')->join_on(
                    undef,
                    {   id       => \'= association_author_id',
                        nickname => $term->{name},
                    },
                    {}
                    );
            },
            sort => 0,
        },
        group_name => {
            label        => 'Group Name',
            filter_label => 'Group',
            display      => 'force',
            base         => '__virtual.string',
            order        => 300,
            col          => 'name',
            html         => sub {
                my ( $prop, $obj, $app ) = @_;
                my $group = $obj->group;
                return unless $group;
                my $name = MT::Util::encode_html( $group->name );
                my $description
                    = MT::Util::encode_html( $group->description );
                my $edit_url = $app->uri(
                    mode => 'view',
                    args => {
                        _type   => 'group',
                        id      => $group->id,
                        blog_id => 0,
                    },
                );
                my $status
                    = $group->status == MT::Group::ACTIVE()
                    ? 'enabled'
                    : 'disabled';
                my $translated_status_label
                    = $group->status == MT::Group::ACTIVE()
                    ? $app->translate('Enabled')
                    : $app->translate('Disabled');
                my $badge_type
                    = $group->status == MT::Group::ACTIVE()
                    ? 'success'
                    : 'default';
                my $description_block = ( length($description) > 0 )
                    ? qq{
                        <p class="description">$description</p>
                    }
                    : q{};
                my $static_uri = $app->static_path;
                return qq{
                        <span class="status $status">
                            <svg role="img" class="mt-icon mt-icon--sm">
                                <title>group</title>
                                <use xlink:href="${static_uri}images/sprite.svg#ic_member"></use>
                            </svg>
                        </span>
                        <span class="groupname">
                            <a href="$edit_url">$name</a>
                            <span class="badge badge-$badge_type">$translated_status_label</span>
                        </span>
                        $description_block
                    };
            },
            terms => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                my $term = $prop->super(@_);
                $db_args->{joins} ||= [];
                push @{ $db_args->{joins} },
                    MT->model('group')->join_on(
                    undef,
                    {   id   => \'= association_group_id',
                        name => $term->{name},
                    },
                    {}
                    );
            },
            bulk_sort => sub {
                my $prop = shift;
                my ($objs) = @_;
                sort { $a->group->name cmp $b->group->name } @$objs;
            },
        },
        _type => {
            terms => sub {
                require MT::Association;
                return { type => MT::Association::USER_GROUP() };
            },
            view => 'none',
        },
        content_data_count => {
            order       => 350,
            label       => 'Content Data Count',
            display     => 'default',
            base        => '__virtual.object_count',
            col_class   => 'num',
            count_class => 'content_data',
            count_col   => 'author_id',
            filter_type => 'author_id',
            ref_column  => 'author_id',
            html        => sub {
                my $prop = shift;
                my ( $obj, $app, $opts ) = @_;
                my $count = MT->model( $prop->count_class )
                    ->count( { $prop->count_col => $obj->author_id } );
                return $count;
            },
        },
        entry_count => {
            label       => '__ENTRY_COUNT',
            display     => 'default',
            order       => 400,
            base        => '__virtual.object_count',
            col_class   => 'num',
            count_class => 'entry',
            count_col   => 'author_id',
            filter_type => 'author_id',
            ref_column  => 'author_id',
            html        => sub {
                my $prop = shift;
                my ( $obj, $app ) = @_;
                my $count = MT->model( $prop->count_class )
                    ->count( { $prop->count_col => $obj->author_id } );
                my $uri = $app->uri(
                    mode => 'list',
                    args => {
                        _type      => $prop->count_class,
                        blog_id    => ( $app->blog ? $app->blog->id : 0 ),
                        filter     => $prop->filter_type,
                        filter_val => $obj->author_id,
                    }
                );
                return qq{<a href="$uri">$count</a>};
            },
        },
        comment_count => {
            label       => '__COMMENT_COUNT',
            display     => 'default',
            order       => 500,
            base        => '__virtual.object_count',
            col_class   => 'num',
            count_class => 'comment',
            count_col   => 'commenter_id',
            filter_type => 'commenter_id',
            ref_column  => 'author_id',
            html        => sub {
                my $prop = shift;
                my ( $obj, $app ) = @_;
                my $count = MT->model( $prop->count_class )
                    ->count( { $prop->count_col => $obj->author_id } );
                my $uri = $app->uri(
                    mode => 'list',
                    args => {
                        _type      => $prop->count_class,
                        blog_id    => ( $app->blog ? $app->blog->id : 0 ),
                        filter     => $prop->filter_type,
                        filter_val => $obj->author_id,
                    }
                );
                return qq{<a href="$uri">$count</a>};
            }
        },
        created_on => {
            base    => '__virtual.created_on',
            order   => 700,
            display => 'optional',
            raw     => sub {
                my ( $prop, $obj ) = @_;
                $obj->user->created_on;
            },
            terms => sub {
                my $prop = shift;
                my ( $args, $load_terms, $load_args ) = @_;
                my $term = $prop->super(@_);
                $load_args->{joins} ||= [];
                push @{ $load_args->{joins} },
                    MT->model('author')->join_on(
                    undef,
                    {   id         => \'=association_author_id',
                        created_on => $term->{created_on},
                    },
                    {}
                    );
            },
        },
        modified_on => {
            base    => '__virtual.modified_on',
            order   => 800,
            display => 'optional',
            raw     => sub {
                my ( $prop, $obj ) = @_;
                $obj->user->modified_on;
            },
            terms => sub {
                my $prop = shift;
                my ( $args, $load_terms, $load_args ) = @_;
                my $term = $prop->super(@_);
                $load_args->{joins} ||= [];
                push @{ $load_args->{joins} },
                    MT->model('author')->join_on(
                    undef,
                    {   id         => \'=association_author_id',
                        created_on => $term->{modified_on},
                    },
                    {}
                    );
            },
        },
        blog_name => { display => 'none', },
        status    => {
            label                 => 'Status',
            base                  => '__virtual.single_select',
            col                   => 'status',
            display               => 'none',
            single_select_options => sub {
                my @sso;
                push @sso,
                    {
                    label => MT->translate('Active'),
                    value => 'active'
                    };
                push @sso,
                    {
                    label => MT->translate('Inactive'),
                    value => 'inactive'
                    };
                push @sso,
                    {
                    label => MT->translate('Pending'),
                    value => 'pending'
                    };
                return \@sso;
            },
            terms => sub {
                my ( $prop, $args, $load_terms, $load_args ) = @_;
                my $val = $args->{value};

                require MT::Author;
                my %statuses = (
                    active   => MT::Author::ACTIVE(),
                    inactive => MT::Author::INACTIVE(),
                    pending  => MT::Author::PENDING(),
                );
                $val = exists $statuses{$val} ? $statuses{$val} : undef;
                return unless $val;

                $load_args->{joins} ||= [];
                push @{ $load_args->{joins} },
                    MT->model('author')->join_on(
                    undef,
                    {   id     => \'=association_author_id',
                        status => $val,
                    },
                    {}
                    );
            },
        },
        email => {
            base         => '__virtual.string',
            label        => 'Email',
            filter_label => 'Email Address',
            display      => 'none',
            col          => 'email',
            terms        => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                my $term = $prop->super(@_);
                $db_args->{joins} ||= [];
                push @{ $db_args->{joins} },
                    MT->model('author')->join_on(
                    undef,
                    {   id    => \'= association_author_id',
                        email => $term->{email},
                    },
                    {}
                    );
            },
            sort => 0,
        },
        group_id => {
            base            => '__virtual.hidden',
            col             => 'group_id',
            filter_editable => 0,
            display         => 'none',
            label_via_param => sub {
                my ( $prop, $app, $val ) = @_;
                my $group = MT->model('group')->load($val)
                    or return $prop->error(
                    MT->translate('Invalid parameter.') );
                my $label = MT->translate( 'Members of group: [_1]',
                    $group->name, );
                $prop->{label} = MT::Util::encode_html($label);
            },
            args_via_param => sub {
                my ( $prop, $app ) = @_;
                my $group_id = $app->param('filter_val');
                return { value => $group_id };
            },
        },
    };
}

sub system_filters {
    return {
        active_groups => {
            label => 'Active Groups',
            items => [
                {   type => 'status',
                    args => { value => MT::Group::ACTIVE(), },
                }
            ],
            order => 100,
        },
        disabled_groups => {
            label => 'Disabled Groups',
            items => [
                {   type => 'status',
                    args => { value => MT::Group::INACTIVE(), },
                }
            ],
            order => 200,
        },
    };
}

sub member_system_filters {
    return {
        enabled => {
            label => 'Enabled Users',
            items => [
                {   type => 'status',
                    args => { value => 'active', },
                },
            ],
            order => 100,
        },
        disabled => {
            label => 'Disabled Users',
            items => [
                {   type => 'status',
                    args => { value => 'inactive', }
                },
            ],
            order => 200,
        },
    };
}

MT->add_callback( 'backup.plugin_objects', 10,
    undef, \&MT::Group::backup_plugin_cb,
);

1;
__END__

=head1 NAME

MT::Group

=head1 METHODS

=head2 is_active([$status])

Return true if the group is active.  As a side-effect, if an argument
is passed to this method, it will be used to set the status before
performing the check.

=head2 remove([\%terms])

Remove the group. Optionally, remove the group(s) by the given terms.

=head2 remove_role([\%terms])

Unlink the group-role association and optionally specify a set of
terms by which to restrict the operation.

=head2 remove_user([\%terms])

Unlink the group-user association and optionally specify a set of
terms by which to restrict the operation.

=head2 add_role($role, $blog)

Associate this group with the given role and webblog.

=head2 add_user($user)

Associate this group with the given user.

=head2 load([\%terms, \%args])

Return a list of groups given optional terms and args selection
arguments.

=head2 load_iter([\%terms, \%args])

Return an object of loaded groups for usage with iteration.

=head2 save()

Save the group!  If the status of the group has changed, rebuild the
permissions.

=head2 user_count([\%terms, \%args])

Return the number of members of the group.

=head2 user_iter([\%terms, \%args])

Return an object of group user-members for usage with iteration.

=head2 blog_iter([\%terms, \%args])

Return an object of group associated blogs for usage with iteration.

=head2 role_iter([\%terms, \%args])

Return an object of group associated roles for usage with iteration.

=head2 external_id()

Set the value of the external id for this group.

=head2 pack_external_id($id)

This function returns the given I<id> as a hexadecimal string.

=head2 unpack_external_id($id)

This function returns the given hexadecimal I<id> as an ordinary
string.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
