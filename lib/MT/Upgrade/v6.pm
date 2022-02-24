# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Upgrade::v6;

use strict;
use warnings;

sub upgrade_functions {
    return {
        'v6_update_blog_class' => {
            version_limit => 5.0,
            priority      => 3.3,
            updater       => {
                type      => 'blog',
                condition => sub {
                    my $blog = $_[0];
                    $blog->class eq 'blog' && !$blog->parent_id;
                },
                code  => sub { $_[0]->class('website') },
                label => "Migrating current blog to a website...",
                sql   => <<__SQL__,
UPDATE mt_blog
SET    blog_class = 'website'
WHERE  blog_class = 'blog'
    AND ( blog_parent_id is null OR blog_parent_id = 0 )
__SQL__
            },
        },
        'v6_migrate_author_favorite_blogs' => {
            version_limit => 5.0,
            priority      => 3.3,
            updater       => {
                type      => 'author',
                condition => sub { $_[0]->favorite_blogs },
                code      => sub {
                    $_[0]->favorite_websites( $_[0]->favorite_blogs );
                    $_[0]->favorite_blogs(undef);
                },
                label =>
                    "Migrating the record for recently accessed blogs...",
                sql => <<__SQL__,
UPDATE mt_author_meta
SET    author_meta_type = 'favorite_websites'
WHERE  author_meta_type = 'favorite_blogs'
__SQL__
            },
        },
        'v6_migrate_blog_administrator_role' => {
            version_limit => 5.0,
            priority      => 3.3,
            updater       => {
                type      => 'association',
                condition => sub {
                    my $association = shift;
                    require MT::Role;
                    my @blog_admin
                        = MT::Role->load_by_permission('administer_blog');
                    grep { $_->id == $association->role_id } @blog_admin;
                },
                code => sub {
                    require MT::Role;
                    my $website_admin
                        = MT::Role->load_by_permission('administer_website');
                    $_[0]->role_id( $website_admin->id );
                    $_[0]->save;
                },
                label => 'Adding Website Administrator role...',
            },
        },
        '_v6_add_site_stats_widget' => {
            version_limit => 6.0005,
            priority      => 3.1,
            updater       => {
                type  => 'author',
                label => 'Adding "Site stats" dashboard widget...',
                code  => \&_v6_add_site_stats_widget,
            },
        },
        '_v6_enable_session_key_compat' => {
            version_limit => 6.0006,
            priority      => 3.1,
            code          => sub {
                MT->config( 'EnableSessionKeyCompat', 1, 1 );
            },
        },
        '_v6_renumbering_widget_orders' => {
            version_limit => 6.0007,
            priority      => 3.2,
            updater       => {
                type  => 'author',
                label => "Reordering dashboard widgets...",
                code  => \&_v6_renumbering_widget_orders,
            },
        },
        'v6_remove_indexes' => {
            version_limit => 6.0008,
            priority      => 3.2,
            code          => \&_v6_remove_indexes,
        },
        'v6_rebuild_permissions' => {
            version_limit => 6.0020,
            priority      => 5,
            updater       => {
                type  => 'permission',
                label => "Rebuilding permission records...",
                code  => \&_v6_rebuild_permissions,
            },
        },
    };
}

sub _v6_add_site_stats_widget {
    my $user    = shift;
    my $widgets = $user->widgets;
    return 1 unless $widgets;

    foreach my $key ( keys %$widgets ) {
        my @keys = split ':', $key;
        if ( $keys[0] eq 'dashboard'
            && ( $keys[1] eq 'user' || $keys[1] eq 'blog' ) )
        {
            my @widget_keys = keys %{ $widgets->{$key} };
            unless ( grep { $_ eq 'site_stats' } @widget_keys ) {
                foreach my $widget_key (@widget_keys) {
                    if ( $keys[1] eq 'user' ) {
                        next
                            if ( $widget_key eq 'notification_dashboard'
                            || $widgets->{$key}->{$widget_key}->{set} eq
                            'main' );
                    }
                    $widgets->{$key}->{$widget_key}->{order} += 1;
                }
                my $order = $keys[1] eq 'user' ? 2 : 1;
                $widgets->{$key}->{'site_stats'} = {
                    order => $order,
                    set   => 'main',
                };
            }
        }
    }

    $user->widgets($widgets);
    $user->save;
}

sub _v6_renumbering_widget_orders {
    my $user    = shift;
    my $widgets = $user->widgets;
    return 1 unless $widgets;

    foreach my $key ( keys %$widgets ) {
        my @keys        = split ':', $key;
        my @widget_keys = keys %{ $widgets->{$key} };
        my $widget_num  = @widget_keys;
        foreach my $widget_key (@widget_keys) {
            my $order = $widgets->{$key}->{$widget_key}->{order};
            if ($order) {
                $order = $order * 100;
            }
            else {
                $widget_num++;
                $order = $widget_num * 100;
            }
            $widgets->{$key}->{$widget_key}->{order} = $order;
        }
    }

    $user->widgets($widgets);
    $user->save;
}

sub _v6_rebuild_permissions {
    my $perm = shift;

    return 1 unless $perm->blog_id;

    $perm->permissions('');
    $perm->rebuild;

    return 1;
}

sub _v6_remove_indexes {
    my $self = shift;

    $self->progress(
        $self->translate_escape('Fixing TheSchwartz::Error table...') );

    my $driver = MT::Object->driver;
    my $dbh    = $driver->r_handle;

    if ( $driver->dbd =~ m/::Pg$/ ) {

        my $sth = $dbh->prepare(<<SQL)
SELECT cidx.relname as index_name, idx.indisunique, idx.indisprimary, idx.indnatts, idx.indkey, am.amname
FROM pg_index idx
INNER JOIN pg_class cidx ON idx.indexrelid = cidx.oid
INNER JOIN pg_class ctbl ON idx.indrelid = ctbl.oid
INNER JOIN pg_am am ON cidx.relam = am.oid
WHERE ctbl.relname = 'mt_ts_error' and ( idx.indisprimary = 't' or idx.indisprimary = '1' )
SQL
            or return undef;
        $sth->execute or return undef;
        my $row = $sth->fetchrow_hashref;
        return unless $row;
        my $pkey = $row->{index_name};

        $driver->sql( [ "alter table mt_ts_error drop constraint $pkey", ] );
    }
    elsif ( $driver->dbd =~ m/::mysql$/ ) {
        return unless $dbh->selectrow_arrayref("show index in mt_ts_error where Key_name = ?", undef, 'PRIMARY');
        $driver->sql( [ 'alter table mt_ts_error drop primary key', ] );
    }
    elsif ( $driver->dbd =~ m/::Oracle$/ ) {
        my ($exist) = $dbh->selectrow_array(q{select 1 from user_constraints where table_name = 'MT_TS_ERROR' AND constraint_type = 'P'});
        return unless $exist;
        $driver->sql( [ 'alter table mt_ts_error drop primary key', ] );
    }
    elsif ( $driver->dbd =~ m/::u?mssqlserver$/i ) {

        my $sth = $dbh->prepare(<<SQL)
SELECT i.name AS index_name, i.type AS index_type, is_unique, is_primary_key, is_unique_constraint
, c.name AS column_name
, ic.key_ordinal AS key_ordinal
FROM sys.indexes AS i 
INNER JOIN sys.index_columns AS ic ON i.index_id = ic.index_id AND i.object_id = ic.object_id 
INNER JOIN sys.columns AS c ON ic.column_id = c.column_id AND ic.object_id = c.object_id 
WHERE is_hypothetical = 0 
AND i.index_id <> 0 
AND i.object_id = OBJECT_ID('mt_ts_error')
AND i.is_primary_key = 1
SQL
            or return undef;
        $sth->execute or return undef;
        my $row = $sth->fetchrow_hashref;
        return unless $row;
        my $pkey = $row->{index_name};

        $driver->sql( [ "alter table mt_ts_error drop constraint $pkey", ] );
    }
    1;
}

1;
__END__
