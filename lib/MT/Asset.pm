# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id: Asset.pm 969 2006-12-21 01:47:02Z bchoate $

package MT::Asset;

use strict;
use MT::Tag; # Holds MT::Taggable
use base qw( MT::Object MT::Taggable MT::Scorable );

__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'blog_id' => 'integer not null',
        'label' => 'string(255)',
        'url' => 'string(255)',
        'description' => 'text',
        'file_path' => 'string(255)',
        'file_name' => 'string(255)',
        'file_ext' => 'string(20)',
        'mime_type' => 'string(255)',
        'parent' => 'integer',
    },
    indexes => {
        blog_id => 1,
        url => 1,
        label => 1,
        file_path => 1,
        parent => 1,
        created_by => 1,
        created_on => 1,
    },
    class_type => 'file',
    audit => 1,
    meta => 1,
    datasource => 'asset',
    primary_key => 'id',
});

require MT::Asset::Image;

sub extensions {
    undef;
}

# This property is a meta-property.
sub url {
    my $asset = shift;
    my $url = $asset->SUPER::url(@_);
    return $url if defined $url;

    return $asset->cache_property(sub {
        my $blog = $asset->blog or return undef;
        my $url = $blog->site_url;
        $url .= '/' unless $url =~ m!/$!;
        my $path = $asset->file_path;
        $path =~ s!\\!/!g;
        $url .= $path;
        $url;
    }, @_);
}

# Returns a localized name for the asset type. For MT::Asset, this is simply
# 'File'.
sub class_label {
    MT->translate('File');
}

sub class_label_plural {
    MT->translate("Files");
}

# Removes the asset, associated tags and related file.
# TBD: Should we track and remove any generated thumbnail files here too?
sub remove {
    my $asset = shift;
    if (ref $asset) {
        my $blog = MT::Blog->load($asset->blog_id, { cached_ok => 1 });
        if ($blog) {
            my $file = $asset->file_path;
            $blog->file_mgr->delete($file);
        }
        $asset->remove_cached_files;
    }
    $asset->SUPER::remove(@_);
}

sub save {
    my $asset = shift;
    if (defined $asset->file_ext) {
        $asset->file_ext(lc($asset->file_ext));
    }

    unless ($asset->SUPER::save(@_)) {
        print STDERR "error during save: " . $asset->errstr . "\n";
        die $asset->errstr;
    }
}

sub remove_cached_files {
    my $asset = shift;
 
    # remove any asset cache files that exist for this asset
    my $blog = $asset->blog;
    if ($asset->id && $blog) {
        my $path = $blog->site_path;
        my $cache_dir = MT->config('AssetCacheDir');
        if ($path && $cache_dir) {
            my $fmgr = $blog->file_mgr;
            if ($fmgr) {
                my $cache_glob = File::Spec->catfile($path, $cache_dir,
                    $asset->id . '.*');
                my @files = glob($cache_glob);
                foreach my $file (@files) {
                    $fmgr->delete($file);
                }
            }
        }
    }
    1;
}

sub blog {
    my $asset = shift;
    $asset->cache_property(sub {
        my $blog_id = $asset->blog_id or return undef;
        require MT::Blog;
        MT::Blog->load($blog_id, { cached_ok => 1 })
            or return $asset->error("Failed to load blog for file");
    });
}

# Returns a true/false response based on whether the active package
# has extensions registered that match the requested filename.
sub can_handle {
    my ($pkg, $filename) = @_;
    # undef is returned from fileparse if the extension is not known.
    require File::Basename;
    my $ext = $pkg->extensions || [];
    return (File::Basename::fileparse($filename, @$ext))[2] ? 1 : 0;
}

# Given a filename, returns an appropriate MT::Asset class to associate
# with it. This lookup is based purely on file extension! If none can
# be found, it returns MT::Asset.
sub handler_for_file {
    my $pkg = shift;
    my ($filename) = @_;
    my $types;
    # special case to check for all registered classes, not just
    # those that are subclasses of this package.
    if ($pkg eq 'MT::Asset') {
        $types = [ keys %{ $pkg->properties->{__type_to_class} || {} } ];
    }
    $types ||= $pkg->type_list;
    if ($types) {
        foreach my $type (@$types) {
            my $this_pkg = $pkg->class_handler($type);
            if ($this_pkg->can_handle($filename)) {
                return $this_pkg;
            }
        }
    }
    __PACKAGE__;
}

sub type_list {
    my $pkg = shift;
    my $props = $pkg->properties;
    my $col = $props->{class_column};
    my $this_type = $props->{class_type};
    my @classes = values %{ $props->{__class_to_type} };
    @classes = grep { m/^\Q$this_type\E:/ } @classes;
    push @classes, $this_type;
    return \@classes;
}

sub metadata {
    my $asset = shift;
    return {
        MT->translate("Tags") => MT::Tag->join(',', $asset->tags),
        MT->translate("Description") => $asset->description,
        MT->translate("Name") => $asset->label,
        url => $asset->url,
        MT->translate("URL") => $asset->url,
        MT->translate("Location") => $asset->file_path,
        name => $asset->file_name,
        'class' => $asset->class,
        ext => $asset->file_ext,
        mime_type => $asset->mime_type,
        # duration => $asset->duration,
    };
}

sub thumbnail_file {
    undef;
}

sub thumbnail_filename {
    undef;
}

sub stock_icon_url {
    undef;
}

sub thumbnail_url {
    my $asset = shift;
    if (my $blog = $asset->blog) {
        require File::Basename;
        if (my $thumbnail_file = $asset->thumbnail_file(@_)) {
            my $file = File::Basename::basename($thumbnail_file);
            my $site_url = $blog->site_url;
            if ($file && $site_url) {
                $file =~ s/%([A-F0-9]{2})/chr(hex($1))/gei;
                $site_url .= '/' unless $site_url =~ m#/$#;
                $site_url .= MT->config('AssetCacheDir') . '/' . $file;
                return $site_url;
            }
        }
    }
    # Use a stock icon
    return $asset->stock_icon_url(@_);
}

sub as_html {
    my $asset = shift;
    my ($param) = @_;
    my $fname = $asset->file_name;
    require MT::Util;
    my $text = sprintf '<a href="%s">%s</a>',
        MT::Util::encode_html($asset->url),
        MT::Util::encode_html($fname);
    return $asset->enclose($text);
}

sub enclose {
    my $asset = shift;
    my ($html) = @_;
    my $id = $asset->id;
    my $type = $asset->class;
    return qq{<span mt:asset-id="$id" class="mt-enclosure mt-enclosure-$type">$html</span>};
}

# Return a HTML snippet of form options for inserting this asset
# into a web page. Default behavior is no options.
sub insert_options {
    my $asset = shift;
    my ($param) = @_;
    return undef;
}

sub on_upload {
    my $asset = shift;
    my ($param) = @_;
    $asset->remove_cached_files;
    1;
}

1;

__END__

=head1 NAME

MT::Asset

=head1 SYNOPSIS

    use MT::Asset;

    # Example

=head1 DESCRIPTION

This module provides an object definition for a file that is placed under
MT's control for publishing.

=head1 METHODS

=head2 MT::Asset->new

Constructs a new asset object. The base class is the generic asset object,
which represents a generic file.

=head2 MT::Asset->handler_for_file($filename)

Returns a I<MT::Asset> package suitable for the filename given. This
determination is typically made based on the file's extension.

=head1 AUTHORS & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
