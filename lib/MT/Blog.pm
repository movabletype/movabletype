# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Blog;

use strict;
use base qw( MT::Object );

use MT::FileMgr;
use MT::Util;

__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'name' => 'string(255) not null',
        'description' => 'text',
        'archive_type' => 'string(255)',
        'archive_type_preferred' => 'string(25)',
        'site_path' => 'string(255)',
        'site_url' => 'string(255)',
        'days_on_index' => 'integer',
        'entries_on_index' => 'integer',
        'file_extension' => 'string(10)',
        'email_new_comments' => 'boolean',
        'allow_comment_html' => 'boolean',
        'autolink_urls' => 'boolean',
        'sort_order_posts' => 'string(8)',
        'sort_order_comments' => 'string(8)',
        'allow_comments_default' => 'boolean',
        'server_offset' => 'float',
        'convert_paras' => 'string(30)',
        'convert_paras_comments' => 'string(30)',
        'allow_pings_default' => 'boolean',
        'status_default' => 'smallint',
        'allow_anon_comments' => 'boolean',
        'words_in_excerpt' => 'smallint',
        'moderate_unreg_comments' => 'boolean',
        'moderate_pings' => 'boolean',
        'allow_unreg_comments' => 'boolean',
        'allow_reg_comments' => 'boolean',
        'allow_pings' => 'boolean',
        'manual_approve_commenters' => 'boolean',
        'require_comment_emails' => 'boolean',
        'junk_folder_expiry' => 'integer',
        'ping_weblogs' => 'boolean',
        'mt_update_key' => 'string(30)',
        'language' => 'string(5)',
        'welcome_msg' => 'text',
        'google_api_key' => 'string(32)',
        'email_new_pings' => 'boolean',
        'ping_blogs' => 'boolean',
        'ping_technorati' => 'boolean',
        'ping_google' => 'boolean',
        'ping_others' => 'text',
        'autodiscover_links' => 'boolean',
        'sanitize_spec' => 'string(255)',
        'cc_license' => 'string(255)',
        'is_dynamic' => 'boolean',
        'remote_auth_token' => 'string(50)',
        'children_modified_on' => 'datetime',
        'custom_dynamic_templates' => 'string(25)',
        'junk_score_threshold' => 'float',
        'internal_autodiscovery' => 'boolean',
        'basename_limit' => 'smallint',
        'use_comment_confirmation' => 'boolean',
        'allow_commenter_regist' => 'boolean',
## Have to keep these around for use in mt-upgrade.cgi.
        'archive_url' => 'string(255)',
        'archive_path' => 'string(255)',
        'old_style_archive_links' => 'boolean',
        'archive_tmpl_daily' => 'string(255)',
        'archive_tmpl_weekly' => 'string(255)',
        'archive_tmpl_monthly' => 'string(255)',
        'archive_tmpl_category' => 'string(255)',
        'archive_tmpl_individual' => 'string(255)',
    },
    meta => 1,
    audit => 1,
    indexes => {
        name => 1,
        children_modified_on => 1,
    },
    defaults => {
        'custom_dynamic_templates' => 'none',
    },
    child_classes => ['MT::Entry', 'MT::Page', 'MT::Template', 'MT::Asset',
                      'MT::Category', 'MT::Folder', 'MT::Notification', 'MT::Log',
                      'MT::ObjectTag', 'MT::Association', 'MT::Comment',
                      'MT::TBPing', 'MT::Trackback', 'MT::TemplateMap'],
    datasource => 'blog',
    primary_key => 'id',
});
__PACKAGE__->install_meta({
    columns => [
        'image_default_wrap_text',
        'image_default_align',
        'image_default_thumb',
        'image_default_width',
        'image_default_wunits',
        'image_default_constrain',
        'image_default_popup',
        'commenter_authenticators',
        'require_typekey_emails',
        'nofollow_urls',
        'follow_auth_links',
        'update_pings',
        'captcha_provider',
        'publish_queue',
        'nwc_smart_replace',
        'nwc_replace_field',
        'template_set',
    ],
});

# Image upload defaults.
use constant ALIGN => 'left';
use constant UNITS => 'pixels';

sub class_label {
    MT->translate("Blog");
}

sub class_label_plural {
    MT->translate("Blogs");
}

{
my $default_text_format;
sub set_defaults {
    my $blog = shift;
    unless ($default_text_format) {
        if (my $allowed = MT->config('AllowedTextFilters')) {
            $allowed =~ s/\s*,.*//;
            $default_text_format = $allowed; # choose first allowed format
        } else {
            $default_text_format = 'richtext'; # MT system default
        }
        my $filters = MT->registry("text_filters");
        # If the 'richtext' filter exists,
        # and is uncondition or it meets the condition, use
        # it as the blog default text format.
        if (!($filters->{$default_text_format} && (!$filters->{$default_text_format}{condition} || $filters->{$default_text_format}{condition}->('blog')))) {
            $default_text_format = '__default__';
        }
    }
    $blog->set_values_internal({
        days_on_index => 0,
        entries_on_index => 10,
        words_in_excerpt => 40,
        sort_order_posts => 'descend',
        language => MT->config('DefaultLanguage'),
        sort_order_comments => 'ascend',
        file_extension => 'html',
        convert_paras => $default_text_format,
        allow_unreg_comments => 0,
        allow_reg_comments => 1,
        allow_pings => 1,
        moderate_unreg_comments => MT::Blog::MODERATE_UNTRSTD(),
        moderate_pings => 1,
        require_comment_emails => 1,
        allow_comments_default => 1,
        allow_comment_html => 1,
        autolink_urls => 1, 
        allow_pings_default => 1,
        require_comment_emails => 0,
        convert_paras_comments => 1,
        email_new_pings => 1,
        email_new_comments => 1,
        allow_commenter_regist => 1,
        use_comment_confirmation => 1,
        sanitize_spec => 0,
        ping_weblogs => 0,
        ping_blogs => 0,
        ping_technorati => 0,
        ping_google => 0,
        archive_type => 'Individual,Monthly,Category,Category-Monthly,Page',
        archive_type_preferred => 'Individual',
        status_default => 2,
        junk_score_threshold => 0,
        junk_folder_expiry => 14, # 14 days
        custom_dynamic_templates => 'none',
        internal_autodiscovery => 0,
        basename_limit => 30,
        server_offset => MT->config('DefaultTimezone') || 0,
        # something far in the future to force dynamic side to read it.
        children_modified_on => '20101231120000',
    });
    return $blog;
}
}

sub create_default_blog {
    my $class = shift;
    my ($blog_name, $blog_template) = @_;
    $blog_name ||= MT->translate("First Blog");
    $class = ref $class if ref $class;

    my $blog = new $class;
    $blog->name($blog_name);

    # Enable nofollow options
    $blog->nofollow_urls(1);
    $blog->follow_auth_links(1);
    
    # Enable default commenter authentication
    $blog->commenter_authenticators(MT->config('DefaultCommenterAuth'));

    $blog->save or return $class->error($blog->errstr);
    $blog->create_default_templates($blog_template || 'mt_blog')
        or return $class->error($blog->errstr);
    return $blog;
}

sub create_default_templates {
    my $blog = shift;

    require MT::DefaultTemplates;
    my $tmpl_list = MT::DefaultTemplates->templates( @_ );
    return $blog->error(MT->translate("No default templates were found."))
        if !$tmpl_list || (ref($tmpl_list) ne 'ARRAY') || (!@$tmpl_list);

    require MT::Template;
    my @arch_tmpl;
    for my $val (@$tmpl_list) {
        next if $val->{global};

        my $obj = MT::Template->new;
        my $p = $val->{plugin} || 'MT'; # component and/or MT package for translate
        local $val->{name} = $val->{name}; # name field is translated in "templates" call
        local $val->{text} = $p->translate_templatized($val->{text});
        $obj->build_dynamic(0);
        foreach my $v (keys %$val) {
            $obj->column($v, $val->{$v}) if $obj->has_column($v);
        }
        $obj->blog_id($blog->id);
        $obj->save;
        if ($val->{mappings}) {
            push @arch_tmpl, {
                template => $obj,
                mappings => $val->{mappings},
                exists($val->{preferred}) ? (preferred => $val->{preferred}) : ()
            };
        }
    }

    if (@arch_tmpl) {
        require MT::TemplateMap;
        for my $map_set (@arch_tmpl) {
            my $tmpl = $map_set->{template};
            my $mappings = $map_set->{mappings};
            foreach my $map_key (keys %$mappings) {
                my $m = $mappings->{$map_key};
                my $at = $m->{archive_type};
                # my $preferred = $mappings->{$map_key}{preferred};
                my $map = MT::TemplateMap->new;
                $map->archive_type($at);
                if ( exists $m->{preferred} ) {
                    $map->is_preferred($m->{preferred});
                }
                else {
                    $map->is_preferred(1);
                }
                $map->template_id($tmpl->id);
                $map->file_template($m->{file_template}) if $m->{file_template};
                $map->blog_id($tmpl->blog_id);
                $map->save;
            }
        }
    }

    return $blog;
}

# As of MT 4, we always manage fileinfo records.
sub needs_fileinfo {
    return 1;
}

sub current_timestamp {
    my $blog = shift;
    require MT::Util;
    my @ts = MT::Util::offset_time_list(time, $blog->id);
    return sprintf '%04d%02d%02d%02d%02d%02d',
        $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0];
}

sub site_url {
    my $blog = shift;
    if (!@_ && $blog->is_dynamic) {
        my $cfg = MT->config;
        my $path = $cfg->CGIPath;
        $path .= '/' unless $path =~ m!/$!;
        return $path . $cfg->ViewScript . '/' . $blog->id;
    } else {
        return $blog->SUPER::site_url(@_);
    }
}

sub archive_url {
    my $blog = shift;
    if (!@_ && $blog->is_dynamic) {
        $blog->site_url;
    } else {
        $blog->SUPER::archive_url(@_) || $blog->site_url;
    }
}

sub archive_path {
    my $blog = shift;
    $blog->SUPER::archive_path(@_) || $blog->site_path;
}

sub comment_text_filters {
    my $blog = shift;
    my $filters = $blog->convert_paras_comments;
    return [] unless $filters;
    if ($filters eq '1') {
        return [ '__default__' ];
    } else {
        return [ split /\s*,\s*/, $filters ];
    }
}

sub cc_license_url {
    my $cc = $_[0]->cc_license or return '';
    MT::Util::cc_url($cc);
}

sub email_all_comments {
    return $_[0]->email_new_comments == 1;
}

sub email_attn_reqd_comments {
    return $_[0]->email_new_comments == 2;
}

sub email_all_pings {
    return $_[0]->email_new_pings == 1;
}

sub email_attn_reqd_pings {
    return $_[0]->email_new_pings == 2;
}

use constant MODERATE_NONE => 0;
use constant MODERATE_UNAUTHD => 3;
use constant MODERATE_UNTRSTD => 2;
use constant MODERATE_ALL => 1;

sub publish_trusted_commenters {
    !($_[0]->moderate_unreg_comments == MODERATE_ALL);
}

sub publish_authd_untrusted_commenters {
    return $_[0]->moderate_unreg_comments == MODERATE_UNAUTHD
        || $_[0]->moderate_unreg_comments == MODERATE_NONE;
}

sub publish_unauthd_commenters {
    $_[0]->moderate_unreg_comments == MODERATE_NONE;
}

sub file_mgr {
    my $blog = shift;
    unless (exists $blog->{__file_mgr}) {
## xxx need to add remote_host, remote_user, remote_pwd fields
## then pull params from there; if remote_host is defined, we
## assume we are using FTP?
        $blog->{__file_mgr} = MT::FileMgr->new('Local');
    }
    $blog->{__file_mgr};
}

sub remove {
    my $blog = shift;
    $blog->remove_children({ key => 'blog_id'});
    my $res = $blog->SUPER::remove(@_);
    if ((ref $blog) && $res) {
        require MT::Permission;
        MT::Permission->remove({ blog_id => $blog->id });
    }
    $res;
}

# deprecated: use $blog->remote_auth_token instead
sub effective_remote_auth_token {
    my $blog = shift;
    if (scalar @_) {
        return $blog->remote_auth_token(@_);
    }
    if ($blog->remote_auth_token()) {
        return $blog->remote_auth_token();
    }
    undef;
}

sub has_archive_type {
    my $blog = shift;
    my ($type) = @_;
    my %at = map { lc $_ => 1 } split(/,/, $blog->archive_type);
    return exists $at{lc $type} ? 1 : 0;
}

sub accepts_registered_comments {
    $_[0]->allow_reg_comments && $_[0]->commenter_authenticators;
}

sub accepts_comments {
    $_[0]->accepts_registered_comments || $_[0]->allow_unreg_comments;
}

sub count_static_templates {
    my $blog = shift;
    my ($archive_type) = @_;
    my $result = 0;
    require MT::TemplateMap;
    my @maps = MT::TemplateMap->load({blog_id => $blog->id,
                                      archive_type => $archive_type});
    return 0 unless @maps;
    require MT::Template;
    foreach my $map (@maps) {  
        my $tmpl = MT::Template->load($map->template_id);
        $result++ if !$tmpl->build_dynamic;
    }
    #$result ||= 1 if ($blog->custom_dynamic_templates || '') ne 'custom';
    return $result;
}

sub touch {
    my $blog = shift;
    my ($s,$m,$h,$d,$mo,$y) = localtime(time);
    my $mod_time = sprintf("%04d%02d%02d%02d%02d%02d",
                           1900+$y, $mo+1, $d, $h, $m, $s);
    $blog->children_modified_on($mod_time);
    $mod_time;
}

sub clone {
    my $blog = shift;
    my ($param) = @_;
    if ($param && $param->{Children}) {
        $blog->clone_with_children(@_);
    } else {
        $blog->SUPER::clone(@_);
    }
}

sub clone_with_children {
    my $blog = shift;
    my ($params) = @_;
    my $callback = $params->{Callback} || sub {};
    my $classes = $params->{Classes};
    my $blog_name = $params->{BlogName};
    delete $$params{Children} if ($params->{Children});
    my $old_blog_id = $blog->id;

    # we must clone:
    #    Blog record
    #    Entry records
    #       - Comment records
    #       - TrackBack records
    #       - TBPing records
    #       - ObjectTag records (if running 3.3)
    #    Category records
    #    Placement records
    #    Template records
    #    Permission records
    #    IPBanList records???
    #    Notification records???

    my $new_blog_id;
    my (%entry_map, %cat_map, %tb_map, %tmpl_map, $counter, $iter);

    # Cloning blog
    my $new_blog = $blog->clone($params);
    $new_blog->name(MT->translate($blog_name ? $blog_name : "Clone of [_1]", $blog->name));
    delete $new_blog->{column_values}->{id};
    delete $new_blog->{changed_cols}->{id};
    $new_blog->save or die $new_blog->errstr;
    $new_blog_id = $new_blog->id;
    $callback->(MT->translate("Cloned blog... new id is [_1].",
        $new_blog_id));

    if ((!exists $classes->{'MT::Permission'}) || $classes->{'MT::Permission'}) {
        # Cloning PERMISSIONS records
        $counter = 0;
        my $state = MT->translate("Cloning permissions for blog:");
        $callback->($state, "perms");
        require MT::Permission;
        $iter = MT::Permission->load_iter({blog_id => $old_blog_id});
        while (my $perm = $iter->()) {
            $callback->($state . " " . MT->translate("[_1] records processed...", $counter), 'perms')
                if $counter && ($counter % 100 == 0);
            $counter++;
            delete $perm->{column_values}->{id};
            delete $perm->{changed_cols}->{id};
            $perm->blog_id($new_blog_id);
            $perm->save or die $perm->errstr;
        }
        $callback->($state . " " . MT->translate("[_1] records processed.", $counter), 'perms');
    }

    if ((!exists $classes->{'MT::Association'}) || $classes->{'MT::Association'}) {
        # Cloning association records
        $counter = 0;
        my $state = MT->translate("Cloning associations for blog:");
        $callback->($state, "assoc");
        require MT::Association;
        $iter = MT::Association->load_iter({blog_id => $old_blog_id});
        while (my $assoc = $iter->()) {
            $callback->($state . " " . MT->translate("[_1] records processed...", $counter), 'assoc')
                if $counter && ($counter % 100 == 0);
            $counter++;
            delete $assoc->{column_values}->{id};
            delete $assoc->{changed_cols}->{id};
            $assoc->blog_id($new_blog_id);
            $assoc->save or die $assoc->errstr;
        }
        $callback->($state . " " . MT->translate("[_1] records processed.", $counter), 'assoc');
    }

    # include/exclude class logic
    # if user has not specified 'Classes' element, clone everything
    # if user has specified Classes, but a particular class is not
    # identified, clone it (forward compatibility). if a class is
    # specified and the flag is '1', clone it. if a class is specified
    # but the flag is '0', skip it.

    # MT::Entry -> MT::Category, MT::Comment, MT::Tracback, MT::TBPing
    # MT::Page -> MT::Folder, MT::Comment, MT::Trackback, MT::TBPing

    if ((!exists $classes->{'MT::Entry'}) || $classes->{'MT::Entry'}) {
        # Cloning ENTRY records
        my $state = MT->translate("Cloning entries for blog...");
        $callback->($state, "entries");
        $counter = 0;
        require MT::Entry;
        $iter = MT::Entry->load_iter({blog_id => $old_blog_id, class => '*'});
        while (my $entry = $iter->()) {
            $callback->($state . " " . MT->translate("[_1] records processed...", $counter), 'entries')
                if $counter && ($counter % 100 == 0);
            $counter++;
            my $entry_id = $entry->id;
            delete $entry->{column_values}->{id};
            delete $entry->{changed_cols}->{id};
            $entry->blog_id($new_blog_id);
            $entry->save or die $entry->errstr;
            $entry_map{$entry_id} = $entry->id;
        }
        $callback->($state . " " . MT->translate("[_1] records processed.", $counter), 'entries');

        if ((!exists $classes->{'MT::Category'}) || $classes->{'MT::Category'}) {
            # Cloning CATEGORY records
            my $state = MT->translate("Cloning categories for blog...");
            $callback->($state, "cats");
            $counter = 0;
            require MT::Category;
            $iter = MT::Category->load_iter({ blog_id => $old_blog_id, class => '*' });
            my %cat_parents;
            while (my $cat = $iter->()) {
                $callback->($state . " " . MT->translate("[_1] records processed...", $counter), 'cats')
                    if $counter && ($counter % 100 == 0);
                $counter++;
                my $cat_id = $cat->id;
                my $old_parent = $cat->parent;
                delete $cat->{column_values}->{id};
                delete $cat->{changed_cols}->{id};
                $cat->blog_id($new_blog_id);
                # temporarily wipe the parent association
                # to avoid constraint issues.
                $cat->parent(0);
                $cat->save or die $cat->errstr;
                $cat_map{$cat_id} = $cat->id;
                if ($old_parent) {
                    $cat_parents{$cat->id} = $old_parent;
                }
            }
            # reassign the new category parents
            foreach (keys %cat_parents) {
                my $cat = MT::Category->load($_);
                if ($cat) {
                    $cat->parent($cat_map{$cat_parents{$cat->id}});
                    $cat->save or die $cat->errstr;
                }
            }
            $callback->($state . " " . MT->translate("[_1] records processed.", $counter), 'cats');

            # Placements are automatically cloned if categories are
            # cloned.
            $state = MT->translate("Cloning entry placements for blog...");
            $callback->($state, "places");
            require MT::Placement;
            $iter = MT::Placement->load_iter({ blog_id => $old_blog_id });
            $counter = 0;
            while (my $place = $iter->()) {
                $callback->($state . " " . MT->translate("[_1] records processed...", $counter), 'places')
                    if $counter && ($counter % 100 == 0);
                $counter++;
                delete $place->{column_values}->{id};
                delete $place->{changed_cols}->{id};
                $place->blog_id($new_blog_id);
                $place->category_id($cat_map{$place->category_id});
                $place->entry_id($entry_map{$place->entry_id});
                $place->save or die $place->errstr;
            }
            $callback->($state . " " . MT->translate("[_1] records processed.", $counter), 'places');
        }

        if ((!exists $classes->{'MT::Comment'}) || $classes->{'MT::Comment'}) {
            # Comments can only be cloned if entries are cloned.
            my $state = MT->translate("Cloning comments for blog...");
            $callback->($state, "comments");
            require MT::Comment;
            $iter = MT::Comment->load_iter({ blog_id => $old_blog_id });
            $counter = 0;
            while (my $comment = $iter->()) {
                $callback->($state . " " . MT->translate("[_1] records processed...", $counter), 'comments')
                    if $counter && ($counter % 100 == 0);
                $counter++;
                delete $comment->{column_values}->{id};
                delete $comment->{changed_cols}->{id};
                $comment->entry_id($entry_map{$comment->entry_id});
                $comment->blog_id($new_blog_id);
                $comment->save or die $comment->errstr;
            }
            $callback->($state . " " . MT->translate("[_1] records processed.", $counter), 'comments');
        }

        if ((!exists $classes->{'MT::ObjectTag'}) || $classes->{'MT::ObjectTag'}) {
            # conditionally do MT::ObjectTag since it is only
            # available with MT 3.3.
            if ($MT::VERSION >= 3.3) {
                my $state = MT->translate("Cloning entry tags for blog...");
                $callback->($state, "tags");
                require MT::ObjectTag;
                $iter = MT::ObjectTag->load_iter({ blog_id => $old_blog_id, object_datasource => 'entry' });
                $counter = 0;
                while (my $entry_tag = $iter->()) {
                    $callback->($state . " " . MT->translate("[_1] records processed...", $counter), "tags")
                        if $counter && ($counter % 100 == 0);
                    $counter++;
                    delete $entry_tag->{column_values}->{id};
                    delete $entry_tag->{changed_cols}->{id};
                    $entry_tag->blog_id($new_blog_id);
                    $entry_tag->object_id($entry_map{$entry_tag->object_id});
                    $entry_tag->save or die $entry_tag->errstr;
                }
                $callback->($state . " " . MT->translate("[_1] records processed.", $counter), 'tags');
            }
        }
    }

    if ((!exists $classes->{'MT::Trackback'}) || $classes->{'MT::Trackback'}) {
        my $state = MT->translate("Cloning TrackBacks for blog...");
        $callback->($state, "tbs");
        require MT::Trackback;
        $iter = MT::Trackback->load_iter({ blog_id => $old_blog_id });
        $counter = 0;
        while (my $tb = $iter->()) {
            next unless ($tb->entry_id && $entry_map{$tb->entry_id}) ||
                ($tb->category_id && $cat_map{$tb->category_id});

            $callback->($state . " " . MT->translate("[_1] records processed...", $counter), 'tbs')
                if $counter && ($counter % 100 == 0);
            $counter++;
            my $tb_id = $tb->id;
            delete $tb->{column_values}->{id};
            delete $tb->{changed_cols}->{id};

            if ($tb->category_id) {
                if (my $cid = $cat_map{$tb->category_id}) {
                    my $cat_tb = MT::Trackback->load(
                        { category_id => $cid }
                    );
                    if ($cat_tb) {
                        my $changed;
                        if ($tb->passphrase) {
                            $cat_tb->passphrase($tb->passphrase);
                            $changed = 1;
                        }
                        if ($tb->is_disabled) {
                            $cat_tb->is_disabled(1);
                            $changed = 1;
                        }
                        $cat_tb->save if $changed;
                        $tb_map{$tb_id} = $cat_tb->id;
                        next;
                    }
                }
            }
            elsif ($tb->entry_id) {
                if (my $eid = $entry_map{$tb->entry_id}) {
                    my $entry_tb = MT::Entry->load($eid)->trackback;
                    if ($entry_tb) {
                        my $changed;
                        if ($tb->passphrase) {
                            $entry_tb->passphrase($tb->passphrase);
                            $changed = 1;
                        }
                        if ($tb->is_disabled) {
                            $entry_tb->is_disabled(1);
                            $changed = 1;
                        }
                        $entry_tb->save if $changed;
                        $tb_map{$tb_id} = $entry_tb->id;
                        next;
                    }
                }
            }

            # A trackback wasn't created when saving the entry/category,
            # (perhaps trackbacks are now disabled for the entry/category?)
            # so create one now
            $tb->entry_id($entry_map{$tb->entry_id})
                if $tb->entry_id && $entry_map{$tb->entry_id};
            $tb->category_id($cat_map{$tb->category_id})
                if $tb->category_id && $cat_map{$tb->category_id};
            $tb->blog_id($new_blog_id);
            $tb->save or die $tb->errstr;
            $tb_map{$tb_id} = $tb->id;
        }
        $callback->($state . " " . MT->translate("[_1] records processed.", $counter), 'tbs');

        if ((!exists $classes->{'MT::TBPing'}) || $classes->{'MT::TBPing'}) {
            my $state = MT->translate("Cloning TrackBack pings for blog...");
            $callback->($state, "pings");
            require MT::TBPing;
            $iter = MT::TBPing->load_iter({ blog_id => $old_blog_id });
            $counter = 0;
            while (my $ping = $iter->()) {
                next unless $tb_map{$ping->tb_id};
                $callback->($state . " " . MT->translate("[_1] records processed...", $counter), 'pings')
                    if $counter && ($counter % 100 == 0);
                $counter++;
                delete $ping->{column_values}->{id};
                delete $ping->{changed_cols}->{id};
                $ping->tb_id($tb_map{$ping->tb_id});
                $ping->blog_id($new_blog_id);
                $ping->save or die $ping->errstr;
            }
            $callback->($state . " " . MT->translate("[_1] records processed.", $counter), 'pings');
        }
    }

    if ((!exists $classes->{'MT::Template'}) || $classes->{'MT::Template'}) {
        my $state = MT->translate("Cloning templates for blog...");
        $callback->($state, "tmpls");
        require MT::Template;
        $iter = MT::Template->load_iter({ blog_id => $old_blog_id });
        $counter = 0;
        while (my $tmpl = $iter->()) {
            $callback->($state . " " . MT->translate("[_1] records processed...", $counter), 'tmpls')
                if $counter && ($counter % 100 == 0);
            my $tmpl_id = $tmpl->id;
            $counter++;
            delete $tmpl->{column_values}->{id};
            delete $tmpl->{changed_cols}->{id};
            # linked_file won't be cloned for now because
            # new blog does not have site_path - breaks relative path
            delete $tmpl->{column_values}->{linked_file};
            delete $tmpl->{column_values}->{linked_file_mtime};
            delete $tmpl->{column_values}->{linked_file_size};
            $tmpl->blog_id($new_blog_id);
            $tmpl->save or die $tmpl->errstr;
            $tmpl_map{$tmpl_id} = $tmpl->id;
        }
        $callback->($state . " " . MT->translate("[_1] records processed.", $counter), 'tmpls');

        $state = MT->translate("Cloning template maps for blog...");
        $callback->($state, "tmplmaps");
        require MT::TemplateMap;
        $iter = MT::TemplateMap->load_iter({ blog_id => $old_blog_id });
        $counter = 0;
        while (my $map = $iter->()) {
            $callback->($state . " " . MT->translate("[_1] records processed...", $counter), 'tmplmaps')
                if $counter && ($counter % 100 == 0);
            $counter++;
            delete $map->{column_values}->{id};
            delete $map->{changed_cols}->{id};
            $map->template_id($tmpl_map{$map->template_id});
            $map->blog_id($new_blog_id);
            $map->save or die $map->errstr;
        }
        $callback->($state . " " . MT->translate("[_1] records processed.", $counter), 'tmplmaps');
    }

    MT->run_callbacks(ref($blog). '::post_clone',
        OldBlogId => $blog->id, old_blog_id => $blog->id,
        NewBlogId => $new_blog->id, new_blog_id => $new_blog->id,
        OldObject => $blog, old_object => $blog,
        NewObject => $new_blog, new_object => $new_blog,
        EntryMap => \%entry_map, entry_map => \%entry_map,
        CategoryMap => \%cat_map, category_map => \%cat_map,
        TrackbackMap => \%tb_map, trackback_map => \%tb_map,
        TemplateMap => \%tmpl_map, template_map => \%tmpl_map,
        Callback => $callback, callback => $callback,
    );
    $new_blog;
}

sub smart_replace {
    my $blog = shift;
    if (@_) {
        $blog->nwc_smart_replace(@_);
        return;
    }
    my $val = $blog->nwc_smart_replace;
    return defined($val) ? $val : MT->config->NwcSmartReplace;
}

sub smart_replace_fields {
    my $blog = shift;
    if (@_) {
        $blog->nwc_replace_field(@_);
        return;
    }
    my $val = $blog->nwc_replace_field;
    return defined($val) ? $val : MT->config->NwcReplaceField;
}

#trans('blog')
#trans('blogs')

1;
__END__

=head1 NAME

MT::Blog - Movable Type blog record

=head1 SYNOPSIS

    use MT::Blog;
    my $blog = MT::Blog->load($blog_id);
    $blog->name('Some new name');
    $blog->save
        or die $blog->errstr;

=head1 DESCRIPTION

An I<MT::Blog> object represents a blog in the Movable Type system. It
contains all of the settings, preferences, and configuration for a particular
blog. It does not contain any per-author permissions settings--for those,
look at the I<MT::Permission> object.

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::Blog> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

The following methods are unique to the I<MT::Blog> interface:

=head2 $blog->file_mgr

Returns the I<MT::FileMgr> object specific to this particular blog.

=head1 DATA ACCESS METHODS

The I<MT::Blog> object holds the following pieces of data. These fields can
be accessed and set using the standard data access methods described in the
I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the blog.

=item * name

The name of the blog.

=item * description

The blog description.

=item * site_path

The path to the directory containing the blog's output index templates.

=item * site_url

The URL corresponding to the I<site_path>.

=item * archive_path

The path to the directory where the blog's archives are stored.

=item * archive_url

The URL corresponding to the I<archive_path>.

=item * server_offset

A slight misnomer, this is actually the timezone that the B<user> has
selected; the value is the offset from GMT.

=item * archive_type

A comma-separated list of archive types used in this particular blog, where
an archive type is one of the following: C<Individual>, C<Daily>, C<Weekly>,
C<Monthly>, or C<Category>. For example, a blog's I<archive_type> would be
C<Individual,Monthly> if the blog were using C<Individual> and C<Monthly>
archives.

=item * archive_type_preferred

The "preferred" archive type, which is used when constructing a link to the
archive page for a particular archive--if multiple archive types are selected,
for example, the link can only point to one of those archives. The preferred
archive type (which should be one of the archive types set in I<archive_type>,
above) specifies to which archive this link should point (among other things).

=item * days_on_index

The number of days to be displayed on the index.

=item * file_extension

The file extension to be used for archive pages.

=item * email_new_comments

A boolean flag specifying whether authors should be notified of new comments
posted on entries they have written.

=item * allow_comment_html

A boolean flag specifying whether HTML should be allowed in comments. If it
is not allowed, it is automatically stripped before building the page (note
that the content stored in the database is B<not> stripped).

=item * autolink_urls

A boolean flag specifying whether URLs in comments should be turned into
links. Note that this setting is only taken into account if
I<allow_comment_html> is turned off.

=item * sort_order_posts

The default sort order for entries. Valid values are either C<ascend> or
C<descend>.

=item * sort_order_comments

The default sort order for comments. Valid values are either C<ascend> or
C<descend>.

=item * allow_comments_default

The default value for the I<allow_comments> field in the I<MT::Entry> object.

=item * convert_paras

A comma-separated list of text filters to apply to each entry when it
is built.

=item * convert_paras_comments

A comma-separated list of text filters to apply to each comment when it
is built.

=item * status_default

The default value for the I<status> field in the I<MT::Entry> object.

=item * allow_anon_comments 

A boolean flag specifying whether anonymous comments (those posted without
a name or an email address) are allowed.

=item * allow_unreg_comments

A boolean flag specifying whether unregistered comments (those posted
without a validated email/password pair) are allowed.

=item * words_in_excerpt

The number of words in an auto-generated excerpt.

=item * ping_weblogs

A boolean flag specifying whether the system should send an XML-RPC ping to
I<weblogs.com> after an entry is saved.

=item * mt_update_key

The Movable Type Recently Updated Key to be sent to I<movabletype.org> after
an entry is saved.

=item * language

The language for date and time display for this particular blog.

=item * welcome_msg

The welcome message to be displayed on the main Editing Menu for this blog.
Should contain all desired HTML formatting.

=back

=head1 METHODS

=over 4

=item * clone( [ \%parameters ] )

MT::Blog provides a clone method that supports cloning of all known child
records related to the MT::Blog object. To invoke this behavior, you
simply specify a parameter hash with a 'Children' key set.

    # Clones blog and all data related to this blog within the database.
    my $new_blog = $original_blog->clone({ Children => 1 });

You may further specify what kind of records are cloned in the process
of cloning child objects. Use the 'Classes' parameter to specifically
exclude particular classes:

    # Clones everything except comments and trackback pings
    my $new_blog = $original_blog->clone({
        Children => 1,
        Classes => { 'MT::Comments' => 0, 'MT::TBPing' => 0 }
    });

Note: Certain exclusions will prevent the clone process from including
other classes. For instance, if you exclude MT::Trackback, all MT::TBPing
objects are automatically excluded.

=back

=head1 DATA LOOKUP

In addition to numeric ID lookup, you can look up or sort records by any
combination of the following fields. See the I<load> documentation in
I<MT::Object> for more information.

=over 4

=item * name

=back

=head1 NOTES

=over 4

=item *

When you remove a blog using I<MT::Blog::remove>, in addition to removing the
blog record, all of the entries, notifications, permissions, comments,
templates, and categories in that blog will also be removed.

=item *

Because the system needs to load I<MT::Blog> objects from disk relatively
often during the duration of one request, I<MT::Blog> objects are cached by
the I<MT::Blog::load> object so that each blog only need be loaded once. The
I<MT::Blog> objects are cached in the I<MT::Request> singleton object; note
that this caching B<only occurs> if the blogs are loaded by numeric ID.

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
