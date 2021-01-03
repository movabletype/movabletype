# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Upgrade::v2;

use strict;
use warnings;

sub upgrade_functions {
    return {

        # < 2.1
        'core_fix_placement_blog_ids' => {
            version_limit => 2.1,
            priority      => 9.2,
            updater       => {
                type      => 'placement',
                label     => 'Updating category placements...',
                condition => sub { !$_[0]->blog_id },
                code      => sub {
                    require MT::Category;
                    my $cat = MT::Category->load( $_[0]->category_id );
                    $_[0]->blog_id( $cat->blog_id ) if $cat;
                },
            },
        },

        # < 3.0
        'core_set_blog_allow_comments' => {
            version_limit => 3.0,
            priority      => 9.3,
            updater       => {
                type      => 'blog',
                label     => 'Assigning comment/moderation settings...',
                condition => sub {
                    !(     defined $_[0]->allow_unreg_comments
                        || defined $_[0]->allow_reg_comments
                        || defined $_[0]->manual_approve_comments
                        || defined $_[0]->moderate_unreg_comments );
                },
                code => sub {
                    $_[0]->allow_unreg_comments(1)
                        unless defined $_[0]->allow_unreg_comments;
                    $_[0]->allow_reg_comments(1)
                        unless defined $_[0]->allow_reg_comments;
                    $_[0]->manual_approve_commenters(0)
                        unless defined $_[0]->manual_approve_commenters;
                    $_[0]->moderate_unreg_comments(0)
                        unless defined $_[0]->moderate_unreg_comments;
                    $_[0]->moderate_pings(0)
                        unless defined $_[0]->moderate_pings;
                },
                sql => [
                    'update mt_blog
                        set blog_allow_unreg_comments = 1
                      where blog_allow_unreg_comments is null',
                    'update mt_blog
                        set blog_allow_reg_comments = 1
                      where blog_allow_reg_comments is null',
                    'update mt_blog
                        set blog_manual_approve_commenters = 0
                      where blog_manual_approve_commenters is null',
                    'update mt_blog
                        set blog_moderate_unreg_comments = 0
                      where blog_moderate_unreg_comments is null'
                ],
            },
        },
    };
}

1;
