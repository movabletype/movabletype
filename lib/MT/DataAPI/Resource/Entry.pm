package MT::DataAPI::Resource::Entry;

use strict;
use warnings;

use MT::DataAPI::Resource::Common;

sub updatable_fields {
    [   qw(
            status
            allowComments
            allowTrackbacks
            title
            body
            more
            excerpt
            keywords
            tags
            ),
        {   name      => 'date',
            condition => sub {
                MT->instance->can_do('edit_entry_basename');
            },
        },
        {   name      => 'basename',
            condition => sub {
                MT->instance->can_do('edit_entry_basename');
            },
        }
    ];
}

sub fields {
    [   {   name   => 'author',
            fields => [qw(id displayName userpicURL)],
            type   => 'MT::DataAPI::Resource::DataType::Object',
        },
        $MT::DataAPI::Resource::Common::fields{blog},
        {   name        => 'categories',
            from_object => sub {
                my ($obj) = @_;
                my $rows = $obj->__load_category_data or return;

                my $primary = do {
                    my @rows = grep { $_->[1] } @$rows;
                    @rows ? $rows[0]->[0] : 0;
                };

                my $cats = MT::Category->lookup_multi(
                    [ map { $_->[0] } @$rows ] );

                [   map { $_->category_label_path } sort {
                              $a->id == $primary ? 1
                            : $b->id == $primary ? -1
                            : $a->label cmp $b->label
                    } @$cats
                ];
            },
        },
        {   name => 'id',
            type => 'MT::DataAPI::Resource::DataType::Integer',
        },
        'class',
        {   name        => 'status',
            from_object => sub {
                my ($obj) = @_;
                MT::Entry::status_text( $obj->status );
            },
            to_object => sub {
                my ($hash) = @_;
                MT::Entry::status_int( $hash->{status} );
            },
        },
        {   name                => 'allowComments',
            alias               => 'allow_comments',
            from_object_default => 0,
            type                => 'MT::DataAPI::Resource::DataType::Boolean',
        },
        {   name                => 'allowTrackbacks',
            alias               => 'allow_pings',
            from_object_default => 0,
            type                => 'MT::DataAPI::Resource::DataType::Boolean',
        },
        {   name                => 'title',
            from_object_default => '',
        },
        {   name                => 'body',
            alias               => 'text',
            from_object_default => '',
        },
        {   name                => 'more',
            alias               => 'text_more',
            from_object_default => '',
        },
        {   name        => 'excerpt',
            from_object => sub {
                my ($obj) = @_;
                $obj->get_excerpt;
            },
        },
        {   name                => 'keywords',
            from_object_default => '',
        },
        'basename',
        'permalink',
        {   name  => 'pingsSentURL',
            alias => 'pinged_url_list',
        },
        {   name  => 'date',
            alias => 'authored_on',
            type  => 'MT::DataAPI::Resource::DataType::ISO8601',
        },
        {   name  => 'createdDate',
            alias => 'created_on',
            type  => 'MT::DataAPI::Resource::DataType::ISO8601',
        },
        {   name  => 'modifiedDate',
            alias => 'modified_on',
            type  => 'MT::DataAPI::Resource::DataType::ISO8601',
        },
        {   name  => 'commentCount',
            alias => 'comment_count',
        },
        {   name  => 'trackbackCount',
            alias => 'ping_count',
        },
        {   name        => 'comments',
            from_object => sub {
                my ($obj) = @_;
                my $app   = MT->instance;
                my $user  = $app->user;

                my $terms = undef;
                if ( !$user->is_superuser ) {
                    my $perm = $app->model('permission')->load(
                        {   author_id => $user->id,
                            blog_id   => $obj->blog_id,
                        },
                    );
                    if (!$perm
                        || !(
                            $perm->can_do('view_all_comments')
                            || (   $perm->can_do('view_own_entry_comment')
                                && $obj->author_id == $user->id )
                        )
                        )
                    {
                        require MT::Comment;
                        $terms = {
                            visible     => 1,
                            junk_status => MT::Comment::NOT_JUNK(),
                        };
                    }
                }

                my $args = undef;
                if ( $app->can('param')
                    && defined( $app->param('maxComments') ) )
                {
                    $args = { limit => int( $app->param('maxComments') ), };
                }
                MT::DataAPI::Resource->from_object(
                    $obj->comments( $terms, $args ) );
            },
        },
        {   name        => 'trackbacks',
            from_object => sub {
                my ($obj) = @_;
                my $app   = MT->instance;
                my $user  = $app->user;

                my $terms = undef;
                if ( !$user->is_superuser ) {
                    my $perm = $app->model('permission')->load(
                        {   author_id => $user->id,
                            blog_id   => $obj->blog_id,
                        },
                    );
                    if (!$perm
                        || !(
                               $perm->can_do('manage_feedback')
                            || $perm->can_do('manage_pages')
                            || (   $perm->can_do('create_post')
                                && $obj->author_id == $user->id )
                        )
                        )
                    {
                        require MT::TBPing;
                        $terms = {
                            visible     => 1,
                            junk_status => MT::TBPing::NOT_JUNK(),
                        };
                    }
                }

                my $args = undef;
                if ( $app->can('param')
                    && defined( $app->param('maxTrackbacks') ) )
                {
                    $args = { limit => int( $app->param('maxTrackbacks') ), };
                }
                MT::DataAPI::Resource->from_object(
                    $obj->pings( $terms, $args ) || [] );
            },
        },
        {   name        => 'assets',
            from_object => sub {
                my ($obj) = @_;
                MT::DataAPI::Resource->from_object( $obj->assets );
            },
        },
        $MT::DataAPI::Resource::Common::fields{tags},
        {   name             => 'updatable',
            type             => 'MT::DataAPI::Resource::DataType::Boolean',
            bulk_from_object => sub {
                my ( $objs, $hashs ) = @_;
                my $app  = MT->instance;
                my $user = $app->user;

                if ( $user->is_superuser ) {
                    $_->{updatable} = 1 for @$hashs;
                    return;
                }

                my %blog_perms;

                for ( my $i = 0; $i < scalar @$objs; $i++ ) {
                    my $obj  = $objs->[$i];
                    my $type = $obj->class_type;

                    my $perms;
                    $perms = $blog_perms{ $obj->blog_id }
                        ||= $user->blog_perm( $obj->blog_id );

                    $hashs->[$i]{updatable}
                        = (    ( 'entry' eq $type )
                            && $perms
                            && $perms->can_edit_entry( $obj, $user ) )
                        || (
                           ( 'page' eq $type )
                        && $perms
                        && (  $user->id == $obj->author_id
                            ? $perms->can_do('edit_own_page')
                            : $perms->can_do('edit_all_pages')
                        )
                        );
                }
            },
        },
    ];
}

1;
