# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::BackupRestore::UpgradeModels;


package MT::Object;
use strict;
use warnings;

sub _is_element {
    my $obj = shift;
    my ($def) = @_;
    return (('text' eq $def->{type}) || (('string' eq $def->{type}) && (255 < $def->{size}))) ? 1 : 0;
}

sub to_xml {
    my $obj = shift;
    my ( $namespace, $metacolumns ) = @_;

    my $coldefs  = $obj->column_defs;
    my $colnames = $obj->column_names;
    my $xml;

    my $elem = $obj->datasource;
    unless ( UNIVERSAL::isa( $obj, 'MT::Log' ) ) {
        if ( $obj->properties
            && ( my $ccol = $obj->properties->{class_column} ) )
        {
            if ( my $class = $obj->$ccol ) {

                # use class_type value instead if
                # the value resolves to a Perl package
                $elem = $class
                    if defined( MT->model($class) );
            }
        }
    }

    $xml = '<' . $elem;
    $xml .= " xmlns='$namespace'" if $namespace;

    my ( @elements, @blobs, @meta );
    for my $name (@$colnames) {
        if ($obj->column($name)
            || ( defined( $obj->column($name) )
                && ( '0' eq $obj->column($name) ) )
            )
        {
            if ( ( $obj->properties->{meta_column} || '' ) eq $name ) {
                push @meta, $name;
                next;
            }
            elsif ( $obj->_is_element( $coldefs->{$name} ) ) {
                push @elements, $name;
                next;
            }
            elsif ( 'blob' eq $coldefs->{$name}->{type} ) {
                push @blobs, $name;
                next;
            }
            $xml .= " $name='"
                . MT::Util::encode_xml( $obj->column($name), 1, 1 ) . "'";
        }
    }
    my ( @meta_elements, @meta_blobs );
    if ( $metacolumns && @$metacolumns ) {
        for my $metacolumn (@$metacolumns) {
            my $name = $metacolumn->{name};
            if ($obj->$name || (defined($obj->$name) && ('0' eq $obj->$name))) {
                if ('vclob' eq $metacolumn->{type}) {
                    push @meta_elements, $name;
                } elsif ('vblob' eq $metacolumn->{type}) {
                    push @meta_blobs, $name;
                } else {
                    $xml .= " $name='" . MT::Util::encode_xml($obj->$name, 1, 1) . "'";
                }
            }
        }
    }
    $xml .= '>';
    $xml .= "<$_>" . MT::Util::encode_xml( $obj->column($_), 1, 1 ) . "</$_>" for @elements;
    require MIME::Base64;
    for my $blob_col (@blobs) {
        my $val = $obj->column($blob_col);
        if ( substr( $val, 0, 4 ) eq 'SERG' ) {
            $xml
                .= "<$blob_col>"
                . MIME::Base64::encode_base64( $val, '' )
                . "</$blob_col>";
        }
        else {
            $xml .= "<$blob_col>"
                . MIME::Base64::encode_base64(
                Encode::encode( MT->config->PublishCharset, $val ), '' )
                . "</$blob_col>";
        }
    }
    for my $meta_col (@meta) {
        my $hashref = $obj->$meta_col;
        $xml .= "<$meta_col>"
            . MIME::Base64::encode_base64(
            MT::Serialize->serialize( \$hashref ), '' )
            . "</$meta_col>";
    }
    $xml .= "<$_>" . MT::Util::encode_xml( $obj->$_, 1, 1 ) . "</$_>" for @meta_elements;
    for my $vblob_col (@meta_blobs) {
        my $vblob = $obj->$vblob_col;
        $xml .= "<$vblob_col>" . MIME::Base64::encode_base64(MT::Serialize->serialize(\$vblob), '') . "</$vblob_col>";
    }
    $xml .= '</' . $elem . '>';
    $xml;
}

sub parents {
    my $obj = shift;
    {};
}

sub _restore_id {
    my $obj = shift;
    my ( $key, $val, $data, $objects ) = @_;

    return 0 unless 'ARRAY' eq ref($val);
    return 1 unless $data->{$key};

    my $new_obj;
    my $old_id = $data->{$key};
    for (@$val) {
        $new_obj = $objects->{"$_#$old_id"};
        last if $new_obj;
    }
    return 0 unless $new_obj;
    $data->{$key} = $new_obj->id;
    return 1;
}

sub restore_parent_ids {
    my $obj = shift;
    my ( $data, $objects ) = @_;

    my $parents = $obj->parents;
    my $count   = scalar( keys %$parents );

    my $done = 0;
    while ( my ( $key, $val ) = each(%$parents) ) {
        $val = [$val] unless ( ref $val );
        if ( 'ARRAY' eq ref($val) ) {
            $done += $obj->_restore_id( $key, $val, $data, $objects );
        }
        elsif ( 'HASH' eq ref($val) ) {
            my $v = $val->{class};
            $v = [$v] unless ( ref $v );
            my $result = 0;
            if ( my $relations = $val->{relations} ) {
                my $col = $relations->{key};
                my $ds  = $data->{$col};
                my $ev  = $relations->{ $ds . '_id' };
                $ev = MT->model($ds) unless $ev;
                return 0 unless $ev;
                $ev = [$ev] unless ( ref $ev );
                $done += $obj->_restore_id( $key, $ev, $data, $objects );
            }
            else {
                $result = $obj->_restore_id( $key, $v, $data, $objects );
                $result = 1 if exists( $val->{optional} ) && $val->{optional};
                $data->{$key} = -1
                    if !$result
                    && ( exists( $val->{orphanize} )
                    && $val->{orphanize} );
                $done += $result;
            }
        }
    }
    ( $count == $done ) ? 1 : 0;
}

package MT::Website;
use strict;
use warnings;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    if (@$blog_ids) {
        return {
            terms => { 'id' => $blog_ids, class => 'website' },
            args  => undef,
        };
    } else {
        return { terms => undef, args => undef };
    }
}

package MT::Blog;
use strict;
use warnings;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    my $column     = 'id';
    my $blog_class = MT->model('blog');
    if (my @blogs = $blog_class->load(@$blog_ids)) {
        my $is_blog;
        for my $blog (@blogs) {
            $is_blog = 1, last if $blog->is_blog();
        }
        $column = 'parent_id' if !$is_blog;
    }

    if (@$blog_ids) {
        return {
            terms => { $column => $blog_ids, class => 'blog' },
            args  => undef,
        };
    } else {
        return { terms => { class => 'blog' }, args => undef };
    }
}

sub parents {
    my $obj = shift;
    { parent_id => MT->model('website'), };
}

package MT::Tag;
use strict;
use warnings;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    if ( @$blog_ids ) {
        return {
            terms => undef,
            args  => { 'join' => ['MT::ObjectTag', 'tag_id', { blog_id => $blog_ids }, { unique => 1 }] } };
    } else {
        return { terms => undef, args => undef };
    }
}

package MT::Role;
use strict;
use warnings;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    return { terms => undef, args => undef } unless (@$blog_ids);

    my %role_id;
    my $iter = MT->model('role')->load_iter(
        undef,
        { 'join' => MT->model('association')->join_on('role_id', { blog_id => $blog_ids }, { unique => 1 }) });
    while (my $role = $iter->()) {
        $role_id{ $role->id } = 1;
    }

    my (%content_type_uid_role, %content_field_uid_role);
    $iter = MT->model('role')->load_iter;
    while (my $role = $iter->()) {
        my $content_type_uids = MT::BackupRestore::ContentTypePermission->get_content_type_uids($role->permissions);
        $content_type_uid_role{$_} = $role->id for @$content_type_uids;
        my $content_field_uids = MT::BackupRestore::ContentTypePermission->get_content_field_uids($role->permissions);
        $content_field_uid_role{$_} = $role->id for @$content_field_uids;
    }

    if (%content_type_uid_role) {
        my $ct_iter = MT->model('content_type')->load_iter({
            blog_id   => $blog_ids,
            unique_id => [keys %content_type_uid_role],
        });
        while (my $content_type = $ct_iter->()) {
            $role_id{ $content_type_uid_role{ $content_type->unique_id } } = 1;
        }
    }

    if (%content_field_uid_role) {
        my $cf_iter = MT->model('content_field')->load_iter({
            blog_id   => $blog_ids,
            unique_id => [keys %content_field_uid_role] });
        while (my $content_field = $cf_iter->()) {
            $role_id{ $content_field_uid_role{ $content_field->unique_id } } = 1;
        }
    }

    my $role_ids = %role_id ? [keys %role_id] : 0;
    { terms => { id => $role_ids }, args => undef };
}

package MT::Asset;
use strict;
use warnings;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    if (@$blog_ids) {
        return {
            terms => {
                'blog_id' => $blog_ids,
                'class'   => $class->properties->{class_type}
            },
            args => undef
        };
    } else {
        return {
            terms => { 'class' => $class->properties->{class_type} },
            args  => undef
        };
    }
}

sub parents {
    my $obj = shift;
    {
        blog_id => [MT->model('blog'), MT->model('website')],
        parent  => MT->model('asset') };
}

package MT::PluginData;
use strict;
use warnings;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    if (@$blog_ids) {
        my @terms;
        for my $id (@$blog_ids) {
            push @terms, '-or' if @terms;
            push @terms, { key => { like => "configuration:blog:$id%" } };
        }
        push @terms, '-or' if @terms;
        push @terms, { key => { not_like => "%blog:%" } };
        return { terms => \@terms, args  => undef };
    } else {
        return { terms => undef, args => undef };
    }
}

sub restore_parent_ids {
    my $obj = shift;
    my ($data, $objects) = @_;

    if ($data->{key} =~ /^configuration:blog:(\d+)$/i) {
        my $new_blog = $objects->{ 'MT::Blog#' . $1 };
        $new_blog = $objects->{ 'MT::Website#' . $1 } unless $new_blog;

        if ($new_blog) {
            $data->{key} = 'configuration:blog:' . $new_blog->id;
        }
    }
    return 1;
}

package MT::Association;
use strict;
use warnings;

sub restore_parent_ids {
    my $obj = shift;
    my ($data, $objects) = @_;

    my ($author, $blog, $group, $role) = (0, 0, 0, 0);

    my $processor = sub {
        my ($elem)  = @_;
        my $class   = MT->model($elem);
        my $old_id  = $data->{ $elem . '_id' };
        my $new_obj = $objects->{"$class#$old_id"};
        if (!$new_obj && $class->isa('MT::Blog')) {
            $class   = MT->model('website');
            $new_obj = $objects->{"$class#$old_id"};
        }
        return 0 unless defined($new_obj) && $new_obj;
        $data->{ $elem . '_id' } = $new_obj->id;
        return 1;
    };

    $author = $processor->('author');
    $group  = $processor->('group');
    $blog   = $processor->('blog');
    $role   = $processor->('role');

    # Combination allowed are:
    # USER_BLOG_ROLE  => 1;
    # GROUP_BLOG_ROLE => 2;
    # USER_GROUP      => 3;
    # USER_ROLE       => 4;
    # GROUP_ROLE      => 5;

    ($author && $group)
        || ($author && $role)
        || ($group  && $role)
        ? 1
        : 0;    # || ($author && $blog && $role) || ($group && $blog && $role)
}

package MT::Category;
use strict;
use warnings;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    if (@$blog_ids) {
        return {
            terms => {
                blog_id         => $blog_ids,
                category_set_id => '*',
            },
            args => undef,
        };
    } else {
        return {
            terms => { category_set_id => '*' },
            args  => undef,
        };
    }
}

sub parents {
    my $obj = shift;
    {
        blog_id         => [MT->model('blog'),     MT->model('website')],
        parent          => [MT->model('category'), MT->model('folder')],
        category_set_id => { class => MT->model('category_set'), optional => 1 },
    };
}

package MT::CategorySet;
use strict;
use warnings;

sub parents {
    my $obj = shift;
    { blog_id => [MT->model('blog'), MT->model('website')], };
}

package MT::ContentType;
use strict;
use warnings;

sub parents {
    my $obj = shift;
    { blog_id => [MT->model('blog'), MT->model('website')] };
}

package MT::ContentField;
use strict;
use warnings;

sub parents {
    my $obj = shift;
    {
        blog_id                 => [MT->model('blog'), MT->model('website')],
        content_type_id         => [MT->model('content_type')],
        related_content_type_id => { class => MT->model('content_type'), optional => 1 },
        related_cat_set_id      => { class => MT->model('category_set'), optional => 1 },
    };
}

package MT::ContentData;
use strict;
use warnings;

sub parents {
    my $obj = shift;
    {
        blog_id         => [MT->model('blog'), MT->model('website')],
        author_id       => { class => MT->model('author'), optional => 1, orphanize => 1 },
        content_type_id => [MT->model('content_type')],
    };
}

package MT::Comment;
use strict;
use warnings;

sub parents {
    my $obj = shift;
    {
        entry_id     => [MT->model('entry'), MT->model('page')],
        blog_id      => [MT->model('blog'),  MT->model('website')],
        commenter_id => { class => MT->model('author'), optional => 1 },
    };
}

package MT::Entry;
use strict;
use warnings;

sub parents {
    my $obj = shift;
    {
        blog_id   => [MT->model('blog'), MT->model('website')],
        author_id => { class => MT->model('author'), optional => 1, orphanize => 1 },
    };
}

package MT::FileInfo;
use strict;
use warnings;

sub parents {
    my $obj = shift;
    {
        entry_id => {
            class    => [MT->model('entry'), MT->model('page')],
            optional => 1
        },
        blog_id => {
            class    => [MT->model('blog'), MT->model('website')],
            optional => 1
        },
        templatemap_id => { class => MT->model('templatemap'), optional => 1 },
        template_id    => { class => MT->model('template'),    optional => 1 },
        category_id    => {
            class    => [MT->model('category'), MT->model('folder')],
            optional => 1
        },
        author_id => { class => MT->model('author'), optional => 1 },
    };
}

package MT::Notification;
use strict;
use warnings;

sub parents {
    my $obj = shift;
    { blog_id => [MT->model('blog'), MT->model('website')], };
}

package MT::ObjectTag;
use strict;
use warnings;

sub restore_parent_ids {
    my $obj = shift;
    my ($data, $objects) = @_;

    if ($data->{blog_id} ||= 0) {
        my $blog_class = MT->model('blog');
        my $new_blog   = $objects->{ $blog_class . '#' . $data->{blog_id} };
        if (!$new_blog) {
            $blog_class = MT->model('website');
            $new_blog   = $objects->{ $blog_class . '#' . $data->{blog_id} };
        }
        return 0 if !$new_blog;
        $data->{blog_id} = $new_blog->id;
    }

    my $tag_class = MT->model('tag');
    my $new_tag   = $objects->{ $tag_class . '#' . $data->{tag_id} } or return 0;
    $data->{tag_id} = $new_tag->id;

    my $object_id_class      = MT->model($data->{object_datasource}) or return 0;
    my $new_object_id_object = $objects->{ $object_id_class . '#' . $data->{object_id} };
    if (!$new_object_id_object) {
        if ($data->{object_datasource} eq 'entry') {
            $object_id_class = MT->model('page');
        } else {
            return 0;
        }
        $new_object_id_object = $objects->{ $object_id_class . '#' . $data->{object_id} } or return 0;
    }
    $data->{object_id} = $new_object_id_object->id;

    if ($data->{cf_id} ||= 0) {
        my $content_field_class = MT->model('content_field');
        my $new_content_field   = $objects->{ $content_field_class . '#' . $data->{cf_id} } or return 0;
        $data->{cf_id} = $new_content_field->id;
    }

    1;
}

sub parents {
    my $obj = shift;
    {
        blog_id   => [MT->model('blog'), MT->model('website')],
        tag_id    => MT->model('tag'),
        cf_id     => MT->model('content_field'),
        object_id => {
            relations => {
                key             => 'object_datasource',
                entry_id        => [MT->model('entry'), MT->model('page')],
                content_data_id => MT->model('content_data'),
            },
        },
    };
}

package MT::Permission;
use strict;
use warnings;

sub parents {
    my $obj = shift;
    {
        blog_id   => [MT->model('blog'), MT->model('website')],
        author_id => { class => MT->model('author'), optional => 1 },
    };
}

package MT::Placement;
use strict;
use warnings;

sub parents {
    my $obj = shift;
    {
        category_id => [MT->model('category'), MT->model('folder')],
        blog_id     => [MT->model('blog'),     MT->model('website')],
        entry_id    => [MT->model('entry'),    MT->model('page')],
    };
}

package MT::TBPing;
use strict;
use warnings;

sub parents {
    my $obj = shift;
    {
        blog_id => [MT->model('blog'), MT->model('website')],
        tb_id   => MT->model('trackback'),
    };
}

package MT::Template;
use strict;
use warnings;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    if (@$blog_ids) {
        return {
            terms => { 'blog_id' => $blog_ids },
            args  => { sort      => [{ column => 'type' }, { column => 'id' }] },
        };
    } else {
        return {
            terms => undef,
            args  => { sort => [{ column => 'type' }, { column => 'id' }] },
        };
    }
}

sub parents {
    my $obj = shift;
    {
        blog_id         => [MT->model('blog'), MT->model('website')],
        content_type_id => { class => MT->model('content_type'), optional => 1 },
    };
}

package MT::TemplateMap;
use strict;
use warnings;

sub parents {
    my $obj = shift;
    {
        blog_id      => [MT->model('blog'), MT->model('website')],
        template_id  => MT->model('template'),
        cat_field_id => { class => MT->model('content_field'), optional => 1 },
        dt_field_id  => { class => MT->model('content_field'), optional => 1 },
    };
}

package MT::Trackback;
use strict;
use warnings;

sub restore_parent_ids {
    my $obj = shift;
    my ($data, $objects) = @_;

    my $result     = 0;
    my $blog_class = MT->model('blog');
    my $new_blog   = $objects->{ $blog_class . '#' . $data->{blog_id} };
    if (!$new_blog) {
        $blog_class = MT->model('website');
        $new_blog   = $objects->{ $blog_class . '#' . $data->{blog_id} };
    }
    return 0 if !$new_blog;
    $data->{blog_id} = $new_blog->id;
    if (my $cid = $data->{category_id}) {
        my $cat_class = MT->model('category');
        my $new_obj   = $objects->{ $cat_class . '#' . $cid };
        unless ($new_obj) {
            $cat_class = MT->model('folder');
            $new_obj   = $objects->{ $cat_class . '#' . $cid };
        }
        if ($new_obj) {
            $data->{category_id} = $new_obj->id;
            $result = 1;
        }
    } elsif (my $eid = $data->{entry_id}) {
        my $entry_class = MT->model('entry');
        my $new_obj     = $objects->{ $entry_class . '#' . $eid };
        unless ($new_obj) {
            $entry_class = MT->model('page');
            $new_obj     = $objects->{ $entry_class . '#' . $eid };
        }
        if ($new_obj) {
            $data->{entry_id} = $new_obj->id;
            $result = 1;
        }
    }
    $result;
}

sub parents {
    my $obj = shift;
    {
        blog_id     => [MT->model('blog'),     MT->model('website')],
        entry_id    => [MT->model('entry'),    MT->model('page')],
        category_id => [MT->model('category'), MT->model('folder')],
    };
}

package MT::ObjectAsset;
use strict;
use warnings;

sub restore_parent_ids {
    my $obj = shift;
    my ($data, $objects) = @_;

    if ($data->{blog_id} ||= 0) {
        my $blog_class = MT->model('blog');
        my $new_blog   = $objects->{ $blog_class . '#' . $data->{blog_id} };
        if (!$new_blog) {
            $blog_class = MT->model('website');
            $new_blog   = $objects->{ $blog_class . '#' . $data->{blog_id} };
        }
        return 0 if !$new_blog;
        $data->{blog_id} = $new_blog->id;
    }

    my $asset_class = MT->model('asset');
    my $new_asset   = $objects->{ $asset_class . '#' . $data->{asset_id} };
    return 0 if !$new_asset;
    $data->{asset_id} = $new_asset->id;

    my $object_id_class      = MT->model($data->{object_ds}) or return 0;
    my $new_object_id_object = $objects->{ $object_id_class . '#' . $data->{object_id} };
    if (!$new_object_id_object) {
        if ($data->{object_ds} eq 'blog') {
            $object_id_class = MT->model('website');
        } elsif ($data->{object_ds} eq 'entry') {
            $object_id_class = MT->model('page');
        } elsif ($data->{object_ds} eq 'category') {
            $object_id_class = MT->model('folder');
        } else {
            return 0;
        }
        $new_object_id_object = $objects->{ $object_id_class . '#' . $data->{object_id} } or return 0;
    }
    $data->{object_id} = $new_object_id_object->id;

    if ($data->{cf_id} ||= 0) {
        my $content_field_class = MT->model('content_field');
        my $new_content_field   = $objects->{ $content_field_class . '#' . $data->{cf_id} } or return 0;
        $data->{cf_id} = $new_content_field->id;
    }

    1;
}

sub parents {
    my $obj = shift;
    {
        blog_id   => [MT->model('blog'), MT->model('website')],
        asset_id  => MT->model('asset'),
        cf_id     => MT->model('content_field'),
        object_id => {
            relations => {
                key             => 'object_ds',
                entry_id        => [MT->model('entry'),    MT->model('page')],
                category_id     => [MT->model('category'), MT->model('folder')],
                blog_id         => [MT->model('blog'),     MT->model('website')],
                content_data_id => [MT->model('content_data')],
            },
        },
    };
}

package MT::ObjectCategory;
use strict;
use warnings;

sub restore_parent_ids {
    my $obj = shift;
    my ($data, $objects) = @_;

    if ($data->{blog_id} ||= 0) {
        my $blog_class = MT->model('blog');
        my $new_blog   = $objects->{ $blog_class . '#' . $data->{blog_id} };
        if (!$new_blog) {
            $blog_class = MT->model('website');
            $new_blog   = $objects->{ $blog_class . '#' . $data->{blog_id} };
        }
        return 0 if !$new_blog;
        $data->{blog_id} = $new_blog->id;
    }

    my $category_class = MT->model('category');
    my $new_category   = $objects->{ $category_class . '#' . $data->{category_id} };
    if (!$new_category) {
        $category_class = MT->model('folder');
        $new_category   = $objects->{ $category_class . '#' . $data->{category_id} };
    }
    return 0 unless $new_category;
    $data->{category_id} = $new_category->id;

    my $object_id_class      = MT->model($data->{object_ds}) or return 0;
    my $new_object_id_object = $objects->{ $object_id_class . '#' . $data->{object_id} };
    if (!$new_object_id_object) {
        if ($data->{object_ds} eq 'entry') {
            $object_id_class = MT->model('page');
        } else {
            return 0;
        }
        $new_object_id_object = $objects->{ $object_id_class . '#' . $data->{object_id} } or return 0;
    }
    $data->{object_id} = $new_object_id_object->id;

    if ($data->{cf_id} ||= 0) {
        my $content_field_class = MT->model('content_field');
        my $new_content_field   = $objects->{ $content_field_class . '#' . $data->{cf_id} } or return 0;
        $data->{cf_id} = $new_content_field->id;
    }

    1;
}

sub parents {
    my $obj = shift;
    {
        blog_id     => [MT->model('blog'),     MT->model('website')],
        category_id => [MT->model('category'), MT->model('folder')],
        cf_id       => MT->model('content_field'),
        object_id   => {
            relations => {
                key             => 'object_ds',
                entry_id        => [MT->model('entry'), MT->model('page')],
                content_data_id => MT->model('content_data'),
            },
        },
    };
}

package MT::ObjectScore;
use strict;
use warnings;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    # authors are processed in _populate_obj_to_backup method
    if (@$blog_ids) {
        return {
            terms => { object_ds => ['entry', 'page'], },
            args  => {
                'join' => MT->model('entry')->join_on(
                    undef,
                    {
                        id      => \'=objectscore_object_id',
                        blog_id => $blog_ids,
                    },
                    { unique => 1, }
                ),
            },
        };
    }
    return { terms => undef, args => undef };
}

sub parents {
    my $obj = shift;
    {
        author_id => MT->model('author'),
        object_id => {
            relations => {
                key      => 'object_ds',
                entry_id => [MT->model('entry'), MT->model('page')],
            },
        },
    };
}

package MT::IPBanList;
use strict;
use warnings;

sub parents {
    my $obj = shift;
    { blog_id => [MT->model('blog'), MT->model('website')], };
}

package MT::Blocklist;
use strict;
use warnings;

sub parents {
    my $obj = shift;
    { blog_id => [MT->model('blog'), MT->model('website')], };
}

package MT::Filter;
use strict;
use warnings;

sub restore_parent_ids {
    my $obj = shift;
    my ($data, $objects) = @_;
    my $new_blog = $objects->{ 'MT::Blog#' . $data->{blog_id} };
    $new_blog = $objects->{ 'MT::Website#' . $data->{blog_id} } unless $new_blog;

    if ($new_blog) {
        $data->{blog_id} = $new_blog->id;
        $obj->blog_id($data->{blog_id});
    }

    # Old author_id is changed to new author_id.
    my $old_author_id  = $data->{'author_id'};
    my $new_author_obj = $objects->{"MT::Author#$old_author_id"};
    if (defined($new_author_obj) && $new_author_obj) {
        $data->{'author_id'} = $new_author_obj->id;
    }

    return 1;
}

sub parents {
    my $obj = shift;
    {
        author_id => { class => MT->model('author'), optional => 1 },
        blog_id   => { class => MT->model('blog'),   optional => 1 },
    };
}

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    # Only the filter belonging to specified
    # websites and blogs are extracted.
    my $terms = undef;
    if (@$blog_ids) {
        $terms = { blog_id => $blog_ids };
    }

    return {
        terms => $terms,
        args  => {
            join => [
                MT->model('author'), undef,
                { id => \'=filter_author_id' }, { unique => 1 }
            ],
        },
    };
}

1;
