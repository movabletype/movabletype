# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::App::CMS::Common;

use strict;
use warnings;

sub init_core_callbacks {
    my $app = shift;
    my $pkg = $app->id . '_';
    my $pfx = '$Core::MT::CMS::';
    $app->_register_core_callbacks(
        {

            # notification callbacks
            $pkg
                . 'save_permission_filter.notification' =>
                "${pfx}AddressBook::can_save",
            $pkg
                . 'delete_permission_filter.notification' =>
                "${pfx}AddressBook::can_delete",
            $pkg
                . 'save_filter.notification' =>
                "${pfx}AddressBook::save_filter",
            $pkg
                . 'post_delete.notification' =>
                "${pfx}AddressBook::post_delete",
            $pkg
                . 'pre_load_filtered_list.notification' =>
                "${pfx}AddressBook::cms_pre_load_filtered_list",

            # banlist callbacks
            $pkg
                . 'save_permission_filter.banlist' =>
                "${pfx}BanList::can_save",
            $pkg
                . 'delete_permission_filter.banlist' =>
                "${pfx}BanList::can_delete",
            $pkg . 'save_filter.banlist' => "${pfx}BanList::save_filter",
            $pkg
                . 'pre_load_filtered_list.banlist' =>
                "${pfx}BanList::cms_pre_load_filtered_list",

            # associations
            $pkg
                . 'delete_permission_filter.association' =>
                "${pfx}User::can_delete_association",
            $pkg
                . 'pre_load_filtered_list.association' =>
                "${pfx}User::cms_pre_load_filtered_list_assoc",
            'list_template_param.association' =>
                "${pfx}User::template_param_list",

            # user callbacks
            $pkg . 'edit.author'                   => "${pfx}User::edit",
            $pkg . 'save_permission_filter.author' => "${pfx}User::can_save",
            $pkg
                . 'delete_permission_filter.author' =>
                "${pfx}User::can_delete",
            $pkg . 'post_save.author'   => "${pfx}User::post_save",
            $pkg . 'post_delete.author' => "${pfx}User::post_delete",
            $pkg . 'pre_load_filtered_list.member' => sub {
                my ( $cb, $app, $filter, $opts, $cols ) = @_;
                my $terms = $opts->{terms};
                delete $terms->{blog_id};
                my $args = $opts->{args};
                $args->{joins} ||= [];
                if ( MT->config->SingleCommunity ) {
                    $terms->{type} = 1;
                    push @{ $args->{joins} },
                        MT->model('association')->join_on(
                        undef,
                        [   {   blog_id   => $opts->{blog_id},
                                author_id => { not => 0 },
                            },
                            'and',
                            { author_id => \'= author_id', },
                        ],
                        { unique => 1, },
                        );
                }
                else {
                    push @{ $args->{joins} },
                        MT->model('permission')->join_on(
                        undef,
                        {   blog_id   => $opts->{blog_id},
                            author_id => { not => 0 },
                        },
                        {   unique    => 1,
                            condition => { author_id => \'= author_id', },
                            type      => 'inner'
                        },
                        );
                    push @{ $args->{joins} },
                        MT->model('association')->join_on(
                        undef,
                        [   [   { blog_id => $opts->{blog_id}, },
                                '-or',
                                { blog_id => \' is null', },
                            ],
                        ],
                        {   type      => 'left',
                            condition => { author_id => \'= author_id', },
                            unique    => 1,
                        },
                        );
                }
            },

            # website callbacks
            $pkg . 'post_save.website'   => "${pfx}Website::post_save",
            $pkg . 'pre_save.website'    => "${pfx}Website::pre_save",
            $pkg . 'edit.website'        => "${pfx}Website::edit",
            $pkg . 'post_delete.website' => "${pfx}Website::post_delete",
            $pkg
                . 'save_permission_filter.website' =>
                "${pfx}Website::can_save",
            $pkg
                . 'delete_permission_filter.website' =>
                "${pfx}Website::can_delete",
            $pkg
                . 'pre_load_filtered_list.website' =>
                "${pfx}Website::cms_pre_load_filtered_list",
            $pkg . 'filtered_list_param.website' => sub {
                my ( $cb, $app, $param, $objs ) = @_;
                if ( $param->{not_deleted} ) {
                    $param->{messages} ||= [];
                    push @{ $param->{messages} },
                        {
                        cls => 'alert',
                        msg => MT->translate(
                            'Some websites were not deleted. You need to delete blogs under the website first.',
                        )
                        };
                }
            },

            $pkg
                . 'view_permission_filter.website' =>
                "${pfx}Website::can_view",

            # blog callbacks
            $pkg . 'edit.blog'                   => "${pfx}Blog::edit",
            $pkg . 'save_permission_filter.blog' => "${pfx}Blog::can_save",
            $pkg
                . 'delete_permission_filter.blog' => "${pfx}Blog::can_delete",
            $pkg . 'pre_save.blog'    => "${pfx}Blog::pre_save",
            $pkg . 'post_save.blog'   => "${pfx}Blog::post_save",
            $pkg . 'post_delete.blog' => "${pfx}Blog::post_delete",

            # folder callbacks
            $pkg . 'edit.folder' => "${pfx}Folder::edit",
            $pkg
                . 'save_permission_filter.folder' => "${pfx}Folder::can_save",
            $pkg
                . 'delete_permission_filter.folder' =>
                "${pfx}Folder::can_delete",
            $pkg . 'pre_save.folder'    => "${pfx}Folder::pre_save",
            $pkg . 'post_save.folder'   => "${pfx}Folder::post_save",
            $pkg . 'save_filter.folder' => "${pfx}Folder::save_filter",
            $pkg . 'post_delete.folder' => "${pfx}Folder::post_delete",

            # category callbacks
            $pkg . 'edit.category' => "${pfx}Category::edit",
            $pkg
                . 'save_permission_filter.category' =>
                "${pfx}Category::can_save",
            $pkg
                . 'delete_permission_filter.category' =>
                "${pfx}Category::can_delete",
            $pkg . 'pre_save.category'    => "${pfx}Category::pre_save",
            $pkg . 'post_save.category'   => "${pfx}Category::post_save",
            $pkg . 'post_delete.category' => "${pfx}Category::post_delete",
            'list_template_param.category' =>
                "${pfx}Category::template_param_list",
            $pkg
                . 'filtered_list_param.category' =>
                "${pfx}Category::filtered_list_param",
            'list_template_param.folder' =>
                "${pfx}Category::template_param_list",
            $pkg
                . 'filtered_list_param.folder' =>
                "${pfx}Category::filtered_list_param",

            # category_set callbacks
            "${pkg}save_permission_filter.category_set" =>
                "${pfx}CategorySet::can_save",
            "${pkg}delete_permission_filter.category_set" =>
                "${pfx}CategorySet::can_delete",
            "${pkg}post_delete.category_set" => "${pfx}CategorySet::post_delete",

            # entry callbacks
            $pkg . 'edit.entry'                   => "${pfx}Entry::edit",
            $pkg . 'save_permission_filter.entry' => "${pfx}Entry::can_save",
            $pkg
                . 'delete_permission_filter.entry' =>
                "${pfx}Entry::can_delete",
            $pkg . 'pre_save.entry'    => "${pfx}Entry::pre_save",
            $pkg . 'post_save.entry'   => "${pfx}Entry::post_save",
            $pkg . 'post_delete.entry' => "${pfx}Entry::post_delete",

            # page callbacks
            $pkg . 'edit.page' => "${pfx}Page::edit",
            $pkg
                . 'delete_permission_filter.page' => "${pfx}Page::can_delete",
            $pkg . 'save_permission_filter.page' => "${pfx}Page::can_save",
            $pkg . 'pre_save.page'               => "${pfx}Page::pre_save",
            $pkg . 'post_save.page'              => "${pfx}Page::post_save",
            $pkg . 'post_delete.page'            => "${pfx}Page::post_delete",

            # template callbacks
            $pkg . 'edit.template' => "${pfx}Template::edit",
            $pkg
                . 'save_permission_filter.template' =>
                "${pfx}Template::can_save",
            $pkg
                . 'delete_permission_filter.template' =>
                "${pfx}Template::can_delete",
            $pkg . 'pre_save.template'    => "${pfx}Template::pre_save",
            $pkg . 'post_save.template'   => "${pfx}Template::post_save",
            $pkg . 'post_delete.template' => "${pfx}Template::post_delete",

            # tags
            $pkg . 'post_delete.tag' => "${pfx}Tag::post_delete",

            # junk-related callbacks
            #'HandleJunk' => \&_builtin_spam_handler,
            #'HandleNotJunk' => \&_builtin_spam_unhandler,
            $pkg . 'not_junk_test' => "${pfx}Common::not_junk_test",

            # assets
            $pkg . 'edit.asset' => "${pfx}Asset::edit",
            $pkg
                . 'delete_permission_filter.asset' =>
                "${pfx}Asset::can_delete",
            $pkg . 'save_permission_filter.asset' => "${pfx}Asset::can_save",
            $pkg . 'post_save.asset'              => "${pfx}Asset::post_save",
            $pkg . 'post_delete.asset'  => "${pfx}Asset::post_delete",
            'template_param.edit_asset' => "${pfx}Asset::template_param_edit",
            'list_template_param.asset' => "${pfx}Asset::template_param_list",

            # log
            'list_template_param.log' => "${pfx}Log::template_param_list",
            $pkg
                . 'pre_load_filtered_list.log' =>
                "${pfx}Log::cms_pre_load_filtered_list",

            # role
            $pkg
                . 'save_permission_filter.role' =>
                "${pfx}User::can_save_role",
            $pkg
                . 'delete_permission_filter.role' =>
                "${pfx}User::can_delete_role",

            # content_data
            $pkg
                . 'save_permission_filter.content_data' =>
                "${pfx}ContentData::can_save",
            $pkg
                . 'delete_permission_filter.content_data' =>
                "${pfx}ContentData::can_delete",
            $pkg . 'post_save.content_data' => "${pfx}ContentData::post_save",
            $pkg
                . 'post_delete.content_data' =>
                "${pfx}ContentData::post_delete",

            # content_type
            $pkg
                . 'list_permission_filter.content_type' =>
                "${pfx}ContentType::can_list",
            $pkg
                . 'view_permission_filter.content_type' =>
                "${pfx}ContentType::can_view",
            $pkg
                . 'save_permission_filter.content_type' =>
                "${pfx}ContentType::can_save",
            $pkg
                . 'delete_permission_filter.content_type' =>
                "${pfx}ContentType::can_delete",
            $pkg . 'post_save.content_type' => "${pfx}ContentType::post_save",
            $pkg
                . 'post_delete.content_type' =>
                "${pfx}ContentType::post_delete",

            # group callbacks
            $pkg
                . 'view_permission_filter.group' =>
                "${pfx}Group::CMSViewPermissionFilter_group",
            $pkg
                . 'save_permission_filter.group' =>
                "${pfx}Group::CMSSavePermissionFilter_group",
            $pkg
                . 'delete_permission_filter.group' =>
                "${pfx}Group::CMSDeletePermissionFilter_group",
            $pkg
                . 'pre_load_filtered_list.group' =>
                "${pfx}Group::CMSPreLoadFilteredList_group",
            $pkg . 'post_save.group' => "${pfx}Group::post_save",
            $pkg . 'post_delete.group' => "${pfx}Group::post_delete",

        }
    );
}

1;

__END__

=head1 NAME

MT::App::CMS::Common

=head1 DESCRIPTION

The I<MT::App::CMS::Common> module is the common parts of CMS element applications.
This module is used by both CMS.pm and DataAPI.pm.

=cut
