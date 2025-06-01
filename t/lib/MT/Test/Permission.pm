# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#

package MT::Test::Permission;

use strict;
use warnings;

sub clear_cache {
    require MT::ObjectDriver::Driver::Cache::RAM;
    MT::ObjectDriver::Driver::Cache::RAM->clear_cache();
    MT->request->reset;
}

sub make_author {
    my $pkg    = shift;
    my %params = @_;

    require MT::Author;
    my $values = {
        email        => 'test@example.com',
        url          => 'http://example.com/',
        auth_type    => 'MT',
        created_on   => '19780131074500',
        type         => MT::Author::AUTHOR(),
        is_superuser => 0,
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    my $count = MT::Author->count( { type => MT::Author::AUTHOR() } );
    if ( !$values->{name} ) {
        $values->{name} = 'test' . $count;
    }
    if ( !$values->{nickname} ) {
        $values->{nickname} = 'test' . $count;
    }

    my $author;
    $author = MT::Author->load($values->{id}) if $values->{id};
    $author ||= MT::Author->new();
    $author->set_values($values);
    $author->set_password($values->{password} || "pass");
    $author->can_sign_in_cms(1);
    $author->can_sign_in_data_api(1);
    $author->save()
        or die "Couldn't save author record: " . $author->errstr;

    clear_cache();

    return $author;
}

sub make_website {
    my $pkg    = shift;
    my %params = @_;

    my $test_root = $ENV{MT_TEST_ROOT} || "$ENV{MT_HOME}/t";
    my $values = {
        name                     => 'Test site',
        site_url                 => 'http://narnia.na/',
        site_path                => $test_root,
        description              => "Narnia None Test Website",
        custom_dynamic_templates => 'custom',
        convert_paras            => 1,
        allow_data_api           => 1,
        allow_reg_comments       => 1,
        allow_unreg_comments     => 0,
        allow_pings              => 1,
        sort_order_posts         => 'descend',
        sort_order_comments      => 'ascend',
        remote_auth_token        => 'token',
        convert_paras_comments   => 1,
        cc_license           => '',
        server_offset        => '-3.5',
        children_modified_on => '20000101000000',
        language             => 'en_us',
        file_extension       => 'html',
        theme_id             => 'classic_website',
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::Website;
    my $website;
    $website = MT::Website->load($values->{id}) if $values->{id};
    $website ||= MT::Website->new();
    $website->set_values($values);
    $website->class('website');
    $website->save() or die "Couldn't save website: " . $website->errstr;

    require MT::Theme;
    my $theme = MT::Theme->load( $values->{theme_id} )
        or die MT::Theme->errstr;
    $theme->apply($website);
    $website->save() or die "Couldn't save blog: " . $website->errstr;

    clear_cache();

    return $website;
}

sub make_blog {
    my $pkg    = shift;
    my %params = @_;

    my $test_root = $ENV{MT_TEST_ROOT} || "$ENV{MT_HOME}/t";
    my $values = {
        name         => 'none',
        site_url     => '/::/nana/',
        archive_url  => '/::/nana/archives/',
        site_path    => "$test_root/site/",
        archive_path => "$test_root/site/archives/",
        archive_type => 'Individual,Monthly,Weekly,Daily,Category,Page',
        archive_type_preferred   => 'Individual',
        description              => "Narnia None Test Blog",
        custom_dynamic_templates => 'custom',
        convert_paras            => 1,
        allow_data_api           => 1,
        allow_reg_comments       => 1,
        allow_unreg_comments     => 0,
        allow_pings              => 1,
        sort_order_posts         => 'descend',
        sort_order_comments      => 'ascend',
        remote_auth_token        => 'token',
        convert_paras_comments   => 1,
        google_api_key           => 'r9Vj5K8PsjEu+OMsNZ/EEKjWmbCeQAv1',
        cc_license           => '',
        server_offset        => '-3.5',
        children_modified_on => '20000101000000',
        language             => 'en_us',
        file_extension       => 'html',
        theme_id             => 'classic_blog',
        parent_id            => 1,
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::Blog;
    my $blog;
    $blog = MT::Blog->load($values->{id}) if $values->{id};
    $blog ||= MT::Blog->new();
    $blog->set_values($values);
    $blog->class('blog');
    $blog->save() or die "Couldn't save blog: " . $blog->errstr;

    require MT::Theme;
    my $theme = MT::Theme->load( $values->{theme_id} )
        or die MT::Theme->errstr;
    $theme->apply($blog);
    $blog->save() or die "Couldn't save blog: " . $blog->errstr;

    clear_cache();

    return $blog;
}

sub make_role {
    my $pkg = shift;
    my (%params) = @_;

    require MT::Role;
    my $role;
    my $name = MT->translate($params{name});
    $role = MT::Role->load({ name => $name });
    $role ||= MT::Role->new();
    $role->set_values(
        {   name        => $name,
            permissions => $params{permissions},
        }
    );

    $role->save
        or die "Couldn't save role record: " . $role->errstr;

    clear_cache();

    return $role;
}

sub make_entry {
    my $pkg    = shift;
    my %params = @_;

    require MT::Entry;
    my $values = {
        title          => 'A Rainy Day',
        text           => 'On a drizzly day last weekend,',
        text_more      => 'I took my grandpa for a walk.',
        excerpt        => 'A story of a stroll.',
        keywords       => 'keywords',
        created_on     => '19780131074500',
        modified_on    => '19780131074600',
        authored_on    => '19780131074500',
        author_id      => 1,
        pinged_urls    => 'http://technorati.com/',
        allow_comments => 1,
        allow_pings    => 1,
        status         => MT::Entry::RELEASE(),
        convert_breaks => '__default__',
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    my $entry;
    $entry = MT::Entry->load($values->{id}) if $values->{id};
    $entry ||= MT::Entry->new();
    $entry->set_values($values);
    $entry->save() or die "Couldn't save entry record: " . $entry->errstr;
    $entry->clear_cache();

    clear_cache();

    return $entry;
}

sub make_asset {
    my $pkg    = shift;
    my %params = @_;

    my $class = 'file';
    $class = delete $params{class}
        if %params && exists $params{class};

    my $values = {
        url         => 'http://narnia.na/nana/files/test.tmpl',
        file_path   => File::Spec->catfile( $ENV{MT_HOME}, "t", 'test.tmpl' ),
        file_name   => 'test.tmpl',
        file_ext    => 'tmpl',
        mime_type   => 'text/plain',
        label       => 'Template',
        description => 'This is a test template.',
        created_by  => 1,
        created_on  => '19780131074500',
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require File::Basename;
    my ( $name, $dirs, $ext ) = File::Basename::fileparse( $values->{file_path}, qr/\.[^.]*/ );
    $values->{file_name} = "$name$ext";
    $ext =~ s/^\.// if $ext;
    $values->{file_ext} = $ext;

    require MT::Asset;
    my $pkg_class = MT::Asset->class_handler($class);
    my $asset;
    $asset = $pkg_class->load($values->{id}) if $values->{id};
    $asset ||= $pkg_class->new();

    foreach my $k ( keys %$values ) {
        $asset->$k( $values->{$k} );
    }
    $asset->save() or die "Couldn't save asset record: " . $asset->errstr;

    clear_cache();

    return $asset;
}

sub make_comment {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        text =>
            'Postmodern false consciousness has always been firmly rooted in post-Freudian Lacanian neo-Marxist bojangles. Needless to say, this quickly and asymptotically approches a purpletacular jouissance of etic jumpinmypants.',
        entry_id   => 1,
        author     => 'v14GrUH 4 cheep',
        visible    => 1,
        email      => 'jake@fatman.com',
        url        => 'http://fatman.com/',
        blog_id    => 1,
        ip         => '127.0.0.1',
        created_on => '20040714182800',
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::Comment;
    my $comment;
    $comment = MT::Comment->load($values->{id}) if $values->{id};
    $comment ||= MT::Comment->new();

    foreach my $k ( keys %$values ) {
        $comment->$k( $values->{$k} );
    }
    $comment->save()
        or die "Couldn't save comment record: " . $comment->errstr;

    clear_cache();

    return $comment;
}

my $template_name_index = 0;

sub make_template {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        blog_id => 1,
        name    => 'blog-name ' . $template_name_index++,
        text    => '<MTBlogName>',
        type    => 'custom',
        outfile => 'blog.html',
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::Template;
    my $tmpl;
    $tmpl = MT::Template->load($values->{id}) if $values->{id};
    $tmpl ||= MT::Template->new();

    foreach my $k ( keys %$values ) {
        $tmpl->$k( $values->{$k} );
    }
    $tmpl->save() or die "Couldn't save template record: " . $tmpl->errstr;

    clear_cache();

    return $tmpl;
}

sub make_page {
    my $pkg    = shift;
    my %params = @_;

    require MT::Page;
    my $values = {
        blog_id     => 1,
        title       => 'But in ourselves, that we are underlings.',
        text        => 'Men at some time are masters of their fates:',
        text_more   => 'The fault, dear Brutus, is not in our stars,',
        keywords    => 'no folder',
        excerpt     => 'excerpt',
        created_on  => '19780131074500',
        authored_on => '19780131074500',
        modified_on => '19780131074600',
        author_id   => 1,
        status      => MT::Entry::RELEASE(),
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    my $page;
    $page = MT::Page->load($values->{id}) if $values->{id};
    $page ||= MT::Page->new();
    $page->set_values($values);
    $page->save() or die "Couldn't save page record: " . $page->errstr;
    $page->clear_cache();

    clear_cache();

    return $page;
}

sub make_folder {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        blog_id     => 2,
        label       => 'foo',
        description => 'foo',
        author_id   => 1,
        parent      => 0,
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::Folder;
    my $folder;
    $folder = MT::Folder->load($values->{id}) if $values->{id};
    $folder ||= MT::Folder->new();

    foreach my $k ( keys %$values ) {
        $folder->$k( $values->{$k} );
    }
    $folder->save() or die "Couldn't save folder record: " . $folder->errstr;

    clear_cache();

    return $folder;
}

sub make_templatemap {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        is_preferred => 0,
        blog_id      => 1,
        template_id  => 1,
        archive_type => 'Individual',
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::TemplateMap;
    my $map;
    $map = MT::TemplateMap->load($values->{id}) if $values->{id};
    $map ||= MT::TemplateMap->new();

    foreach my $k ( keys %$values ) {
        $map->$k( $values->{$k} );
    }
    $map->save() or die "Couldn't save templatemap record: " . $map->errstr;

    clear_cache();

    return $map;
}

sub make_category {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        blog_id     => 2,
        label       => 'foo',
        description => 'foo',
        author_id   => 1,
        parent      => 0,
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::Category;
    my $cat;
    $cat = MT::Category->load($values->{id}) if $values->{id};
    $cat ||= MT::Category->new();

    foreach my $k ( keys %$values ) {
        $cat->$k( $values->{$k} );
    }
    $cat->save() or die "Couldn't save category record: " . $cat->errstr;

    clear_cache();

    return $cat;
}

sub make_banlist {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        blog_id => 2,
        ip      => '1.1.1.1',
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::IPBanList;
    my $banlist;
    $banlist = MT::IPBanList->load($values->{id}) if $values->{id};
    $banlist ||= MT::IPBanList->new();

    foreach my $k ( keys %$values ) {
        $banlist->$k( $values->{$k} );
    }
    $banlist->save()
        or die "Couldn't save banlist record: " . $banlist->errstr;

    clear_cache();

    return $banlist;
}

sub make_notification {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        blog_id => 2,
        name    => 'John Doe',
        email   => 'john@example.com',
        url     => 'http://example.com',
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::Notification;
    my $notification;
    $notification = MT::Notification->load($values->{id}) if $values->{id};
    $notification ||= MT::Notification->new();

    foreach my $k ( keys %$values ) {
        $notification->$k( $values->{$k} );
    }
    $notification->save()
        or die "Couldn't save notification record: " . $notification->errstr;

    clear_cache();

    return $notification;
}

sub make_fileinfo {
    my $pkg    = shift;
    my %params = @_;

    my $values = { blog_id => 2, };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::FileInfo;
    my $fileinfo;
    $fileinfo = MT::FileInfo->load($values->{id}) if $values->{id};
    $fileinfo ||= MT::FileInfo->new();

    foreach my $k ( keys %$values ) {
        $fileinfo->$k( $values->{$k} );
    }
    $fileinfo->save()
        or die "Couldn't save fileinfo record: " . $fileinfo->errstr;

    clear_cache();

    return $fileinfo;
}

sub make_log {
    my $pkg    = shift;
    my %params = @_;

    my $values = { blog_id => 2, };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::Log;
    my $log;
    $log = MT::Log->load($values->{id}) if $values->{id};
    $log ||= MT::Log->new();

    foreach my $k ( keys %$values ) {
        $log->$k( $values->{$k} );
    }
    $log->save() or die "Couldn't save log record: " . $log->errstr;

    clear_cache();

    return $log;
}

sub make_objectasset {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        blog_id   => 2,
        object_id => 1,
        object_ds => 'entry',
        asset_id  => 1,
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::ObjectAsset;
    my $os;
    $os = MT::ObjectAsset->load($values->{id}) if $values->{id};
    $os ||= MT::ObjectAsset->new();

    foreach my $k ( keys %$values ) {
        $os->$k( $values->{$k} );
    }
    $os->save() or die "Couldn't save objectasset record: " . $os->errstr;

    clear_cache();

    return $os;
}

sub make_objectscore {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        namespace => 'sample',
        object_id => 1,
        object_ds => 'entry',
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::ObjectScore;
    my $os;
    $os = MT::ObjectScore->load($values->{id}) if $values->{id};
    $os ||= MT::ObjectScore->new();

    foreach my $k ( keys %$values ) {
        $os->$k( $values->{$k} );
    }
    $os->save() or die "Couldn't save objectscore record: " . $os->errstr;

    clear_cache();

    return $os;
}

sub make_objecttag {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        blog_id           => 2,
        object_id         => 1,
        object_datasource => 'entry',
        tag_id            => 1,
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::ObjectTag;
    my $os;
    $os = MT::ObjectTag->load($values->{id}) if $values->{id};
    $os ||= MT::ObjectTag->new();

    foreach my $k ( keys %$values ) {
        $os->$k( $values->{$k} );
    }
    $os->save() or die "Couldn't save objecttag record: " . $os->errstr;

    clear_cache();

    return $os;
}

sub make_permission {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        blog_id   => 0,
        author_id => 1,
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::Permission;
    my $perm;
    $perm = MT::Permission->load($values->{id}) if $values->{id};
    $perm ||= MT::Permission->new();

    foreach my $k ( keys %$values ) {
        $perm->$k( $values->{$k} );
    }
    $perm->save() or die "Couldn't save permission record: " . $perm->errstr;

    clear_cache();

    return $perm;
}

sub make_placement {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        blog_id     => 0,
        entry_id    => 1,
        category_id => 1,
        is_primary  => 1,
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::Placement;
    my $place;
    $place = MT::Placement->load($values->{id}) if $values->{id};
    $place ||= MT::Placement->new();

    foreach my $k ( keys %$values ) {
        $place->$k( $values->{$k} );
    }
    $place->save() or die "Couldn't save placement record: " . $place->errstr;

    clear_cache();

    return $place;
}

sub make_session {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        id    => '0123456789',
        start => time,
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::Session;
    my $sess;
    $sess = MT::Session->load($values->{id}) if $values->{id};
    $sess ||= MT::Session->new();

    foreach my $k ( keys %$values ) {
        $sess->$k( $values->{$k} );
    }
    $sess->save() or die "Couldn't save session record: " . $sess->errstr;

    clear_cache();

    return $sess;
}

sub make_tag {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        name       => 'Tag',
        n8d_id     => 0,
        is_private => 0,
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::Tag;
    my $tag;
    $tag = MT::Tag->load($values->{id}) if $values->{id};
    $tag ||= MT::Tag->new();

    foreach my $k ( keys %$values ) {
        $tag->$k( $values->{$k} );
    }
    $tag->save() or die "Couldn't save tag record: " . $tag->errstr;

    clear_cache();

    return $tag;
}

sub make_ping {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        blog_id       => 2,
        tb_id         => 1,
        title         => 'Trackback Title',
        excerpt       => 'Body',
        source_url    => 'http://example.com/1',
        ip            => '127.0.0.1',
        blog_name     => 'From Blog',
        visible       => 1,
        junk_status   => 1,
        last_moved_on => '20000101000000',
        junk_score    => 0,
        junk_log      => '',
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::TBPing;
    my $ping;
    $ping = MT::TBPing->load($values->{id}) if $values->{id};
    $ping ||= MT::TBPing->new();

    foreach my $k ( keys %$values ) {
        $ping->$k( $values->{$k} );
    }
    $ping->save() or die "Couldn't save tbping record: " . $ping->errstr;

    clear_cache();

    return $ping;
}

sub make_tb {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        blog_id     => 2,
        entry_id    => 1,
        category_id => 0,
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::Trackback;
    my $tb;
    $tb = MT::Trackback->load($values->{id}) if $values->{id};
    $tb ||= MT::Trackback->new();

    foreach my $k ( keys %$values ) {
        $tb->$k( $values->{$k} );
    }
    $tb->save() or die "Couldn't save trackback record: " . $tb->errstr;

    clear_cache();

    return $tb;
}

sub make_touch {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        blog_id     => 2,
        object_type => 'blog',
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::Touch;
    my $touch;
    $touch = MT::Touch->load($values->{id}) if $values->{id};
    $touch ||= MT::Touch->new();

    foreach my $k ( keys %$values ) {
        $touch->$k( $values->{$k} );
    }
    $touch->save() or die "Couldn't save touch record: " . $touch->errstr;

    clear_cache();

    return $touch;
}

sub make_plugindata {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        plugin => 'Dummy',
        key    => 'Dummy Key',
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::PluginData;
    my $plugindata;
    $plugindata = MT::PluginData->load($values->{id}) if $values->{id};
    $plugindata ||= MT::PluginData->new();

    foreach my $k ( keys %$values ) {
        $plugindata->$k( $values->{$k} );
    }
    $plugindata->save()
        or die "Couldn't save plugindata record: " . $plugindata->errstr;

    clear_cache();

    return $plugindata;
}

sub make_field {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        blog_id     => 2,
        name        => 'Sample Field',
        description => 'This is a sample.',
        obj_type    => 'entry',
        type        => 'text',
        tag         => 'samplefield',
        basename    => 'sample_field',
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require CustomFields::Field;
    my $cf;
    $cf = CustomFields::Field->load($values->{id}) if $values->{id};
    $cf ||= CustomFields::Field->new();

    foreach my $k ( keys %$values ) {
        $cf->$k( $values->{$k} );
    }
    $cf->save() or die "Couldn't save field record: " . $cf->errstr;

    clear_cache();

    return $cf;
}

sub make_group {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        name         => 'Sample Group',
        display_name => 'Sample Group',
        status       => 1,
    };

    if (%params) {
        foreach my $key ( keys %params ) {
            $values->{$key} = $params{$key};
        }
    }

    require MT::Group;
    my $grp;
    $grp = MT::Group->load($values->{id}) if $values->{id};
    $grp ||= MT::Group->new();

    foreach my $k ( keys %$values ) {
        $grp->$k( $values->{$k} );
    }
    $grp->save() or die "Couldn't save group record: " . $grp->errstr;

    clear_cache();

    return $grp;
}

sub make_category_set {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        blog_id => 2,
        name    => 'Sample Category Set',
        %params,
    };

    require MT::CategorySet;
    my $cs;
    $cs = MT::CategorySet->load($values->{id}) if $values->{id};
    $cs ||= MT::CategorySet->new;

    $cs->$_( $values->{$_} ) for keys %{$values};
    $cs->save or die q{Couldn't save category set record: } . $cs->errstr;

    clear_cache();

    $cs;
}

my $content_type_name_index = 0;

sub make_content_type {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        name        => 'Sample Content Type ' . $content_type_name_index++,
        description => 'This is a sample.',
        blog_id     => 2,
        %params,
    };

    require MT::ContentType;
    my $ct;
    $ct = MT::ContentType->load($values->{id}) if $values->{id};
    $ct ||= MT::ContentType->new;

    $ct->$_( $values->{$_} ) for keys %{$values};
    $ct->save or die q{Couldn't save content type record: } . $ct->errstr;

    clear_cache();
    _mock_perms_from_registry();

    $ct;
}

sub make_content_field {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        blog_id     => 2,
        type        => 'single_line_text',
        name        => 'Sample Content Field',
        description => 'This is a sample single_line_text field.',
        %params,
    };

    require MT::ContentField;
    my $cf;
    $cf = MT::ContentField->load($values->{id}) if $values->{id};
    $cf ||= MT::ContentField->new;

    $cf->$_( $values->{$_} ) for keys %{$values};
    $cf->save or die q{Couldn't save content field record: } . $cf->errstr;

    clear_cache();
    _mock_perms_from_registry();

    $cf;
}

sub make_content_data {
    my $pkg    = shift;
    my %params = @_;

    require MT::ContentStatus;
    my $values = {
        blog_id        => 2,
        status         => MT::ContentStatus::RELEASE(),
        author_id      => 1,
        authored_on    => '20170530163600',
        %params,
    };

    require MT::ContentData;
    my $cd;
    $cd = MT::ContentData->load($values->{id}) if $values->{id};
    $cd ||= MT::ContentData->new;

    $cd->$_( $values->{$_} ) for keys %{$values};
    $cd->save or die q{Couldn't save content data record: } . $cd->errstr;

    clear_cache();

    $cd;
}

{

    my $mock_permission;

    sub _mock_perms_from_registry {
        eval { require Test::MockModule } or return;

        $mock_permission = Test::MockModule->new('MT::Permission');
        $mock_permission->mock(
            'perms_from_registry',
            sub {
                my %perms = %{ $mock_permission->original('perms_from_registry')->() };
                my $content_type_perm
                    = MT->app->model('content_type')->all_permissions;
                foreach my $k ( keys %$content_type_perm ) {
                    next if exists $perms{$k};
                    $perms{$k} = $content_type_perm->{$k};
                }
                \%perms;
            }
        ) if !$mock_permission->is_mocked('perms_from_registry');
    }
}

sub make_filter {
    my $pkg    = shift;
    my %params = @_;

    my $values = {
        blog_id     => 1,
        author_id  => 1,
        label => 'Test filter',
        object_ds => 'entry',
        %params,
    };

    require MT::Filter;
    my $filter;
    $filter = MT::Filter->load($values->{id}) if $values->{id};
    $filter ||= MT::Filter->new;

    $filter->$_( $values->{$_} ) for keys %{$values};
    $filter->save or die q{Couldn't save filter record: } . $filter->errstr;

    clear_cache();

    return $filter;
}

1;
