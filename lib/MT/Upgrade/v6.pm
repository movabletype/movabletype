# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Upgrade::v6;

use strict;

sub upgrade_functions {
    return {
        'v6_update_blog_class' => {
            version_limit => 5.0,
            priority      => 3.3,
            updater       => {
                type      => 'blog',
                condition => sub { $_[0]->class eq 'blog' },
                code      => sub { $_[0]->class('website') },
                label     => "Updating class of blogs in MT4...",
                sql       => <<__SQL__,
UPDATE mt_blog
SET    blog_class = 'website'
WHERE  blog_class = 'blog'
    AND ( blog_parent_id is null OR blog_parent_id = '' OR blog_parent_id = 0 );
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
                label => "Migrating favorite_blogs of authors in MT4...",
                sql   => <<__SQL__,
UPDATE mt_author_meta
SET    author_meta_type = 'favorite_websites'
WHERE  author_meta_type = 'favorite_blogs';
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
                label => 'Migrating Blog Administrator roles in MT4...',
            },
        },
    };
}

1;
__END__
