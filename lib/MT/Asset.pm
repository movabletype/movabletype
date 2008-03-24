# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

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
        label => 1,
        file_ext => 1,
        parent => 1,
        created_by => 1,
        created_on => 1,
        blog_class_date => {
            columns => ['blog_id','class','created_on'],
        },
    },
    class_type => 'file',
    audit => 1,
    meta => 1,
    datasource => 'asset',
    primary_key => 'id',
});

require MT::Asset::Image;
require MT::Asset::Audio;
require MT::Asset::Video;

sub extensions {
    undef;
}

# This property is a meta-property.
sub file_path {
    my $asset = shift;
    my $path = $asset->SUPER::file_path(@_);
    return $path if defined($path) && ($path !~ m!^\$!) && (-f $path);

    $path = $asset->cache_property(sub {
        my $path = $asset->SUPER::file_path();
        if ($path && ($path =~ m!^\%([ras])!)) {
            my $blog = $asset->blog;
            my $root = !$blog || $1 eq 's' ? MT->instance->static_file_path
                     : $1 eq 'r'           ? $blog->site_path
                     :                       $blog->archive_path
                     ;
            $root =~ s!(/|\\)$!!;
            $path =~ s!^\%[ras]!$root!;
        }
        $path;
    }, @_);
    return $path;
}

sub url {
    my $asset = shift;
    my $url = $asset->SUPER::url(@_);
    return $url if defined($url) && ($url !~ m!^\%!) && ($url =~ m!^https://!);

    $url = $asset->cache_property(sub {
        my $url = $asset->SUPER::url();
        if ($url =~ m!^\%([ras])!) {
            my $blog = $asset->blog;
            my $root = !$blog || $1 eq 's' ? MT->instance->static_path
                     : $1 eq 'r'           ? $blog->site_url
                     :                       $blog->archive_url
                     ;
            $root =~ s!/$!!;
            $url =~ s!^\%[ras]!$root!;
        }
        return $url;
    }, @_);
    return $url;
}

# Returns a localized name for the asset type. For MT::Asset, this is simply
# 'File'.
sub class_label {
    MT->translate('Asset');
}

sub class_label_plural {
    MT->translate("Assets");
}

# Removes the asset, associated tags and related file.
# TBD: Should we track and remove any generated thumbnail files here too?
sub remove {
    my $asset = shift;
    if (ref $asset) {
        my $blog = MT::Blog->load($asset->blog_id);
        require MT::FileMgr;
        my $fmgr = $blog ? $blog->file_mgr : MT::FileMgr->new('Local');
        my $file = $asset->file_path;
        $fmgr->delete($file);
        $asset->remove_cached_files;

        # remove children.
        my $class = ref $asset;
        my $iter = __PACKAGE__->load_iter({ parent => $asset->id, class => '*' });
        while(my $a = $iter->()) {
            $a->remove;
        }

        # Remove MT::ObjectAsset records
        $class = MT->model('objectasset');
        $iter = $class->load_iter({ asset_id => $asset->id });
        while (my $o = $iter->()) {
            $o->remove;
        }
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
        my $cache_dir = $asset->_make_cache_path;
        if ($cache_dir) {
            require MT::FileMgr;
            my $fmgr = $blog->file_mgr || MT::FileMgr->new('Local');
            if ($fmgr) {
                my $basename = $asset->file_name;
                my $ext = '.'.$asset->file_ext;
                $basename =~ s/$ext$//;
                my $cache_glob = File::Spec->catfile($cache_dir,
                    $basename . '-thumb-*' . $ext);
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
    my $blog_id = $asset->blog_id or return undef;
    return $asset->{__blog} if $blog_id && $asset->{__blog} && ($asset->{__blog}->id == $blog_id);
    require MT::Blog;
    return $asset->{__blog} = MT::Blog->load($blog_id)
        or return $asset->error("Failed to load blog for file");
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

sub has_thumbnail {
    0;
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
    my (%param) = @_;

    require File::Basename;
    if (my ($thumbnail_file, $w, $h) = $asset->thumbnail_file(@_)) {
        return $asset->stock_icon_url(@_) if !defined $thumbnail_file;
        my $file = File::Basename::basename($thumbnail_file);
        my $asset_file_path = $asset->SUPER::file_path();
        my $site_url;
        my $blog = $asset->blog;
        if (!$blog) {
            $site_url = $param{Pseudo} ? '%s' : MT->instance->static_path;
            $site_url .= '/' unless $site_url =~ m!/$!;
            $site_url .= 'support/';
        }
        elsif ( $asset_file_path =~ m/^%a/ ) {
            $site_url = $param{Pseudo} ? '%a' : $blog->archive_url;
        }
        else {
            $site_url = $param{Pseudo} ? '%r' : $blog->site_url;
        }

        if ($file && $site_url) {
            require MT::Util;
            my $path = $param{Path};
            if (!defined $path) {
                $path = MT::Util::caturl(MT->config('AssetCacheDir'), unpack('A4A2', $asset->created_on));
            } else {
                require File::Spec;
                my @path = File::Spec->splitdir($path);
                $path = '';
                for my $p (@path) {
                    $path = MT::Util::caturl($path, $p);
                }
            }
            $file =~ s/%([A-F0-9]{2})/chr(hex($1))/gei;
            $site_url = MT::Util::caturl($site_url, $path, $file);
            return ($site_url, $w, $h);
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
    return qq{<form mt:asset-id="$id" class="mt-enclosure mt-enclosure-$type" style="display: inline;">$html</form>};
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
    1;
}

sub edit_template_param {
    my $asset = shift;
    my ($cb, $app, $param, $tmpl) = @_;
    return;
}

sub set_values_from_query {
    my $asset = shift;
    my ($q) = @_;

    # Set the known columns from the form, if they're set. Subclasses can
    # opt out or decorate this behavior by overriding the method.
    my $names = $asset->column_names;
    my %values;
    for my $field (@$names) {
        $values{$field} = $q->param($field)
            if defined $q->param($field);
    }
    $asset->set_values(\%values);

    1;
}

# $pseudo parameter causes function to return '%r' as
# root instead of blog site path
sub _make_cache_path {
    my $asset = shift;
    my ($path, $pseudo) = @_;
    my $blog = $asset->blog;

    require File::Spec;
    my $year_stamp = '';
    my $month_stamp = '';
    if  (!defined $path) {
        $year_stamp = unpack 'A4', $asset->created_on;
        $month_stamp = unpack 'x4 A2', $asset->created_on;
        $path = MT->config('AssetCacheDir');
    } else {
        my $merge_path = '';
        my @split = File::Spec->splitdir($path);
        for my $p (@split) {
            $merge_path = File::Spec->catfile($merge_path, $p);
        }
        $path = $merge_path if $merge_path;
    }

    my $asset_file_path = $asset->SUPER::file_path();
    my $format;
    my $root_path;
    if ( !$blog ) {
        $format = '%s';
        $root_path = File::Spec->catdir(MT->instance->static_file_path, 'support');
    }
    elsif ( $asset_file_path =~ m/^%a/ ) {
        $format = '%a';
        $root_path = $blog->archive_path;
    }
    else {
        $format = '%r';
        $root_path = $blog->site_path;
    }

    my $real_cache_path = File::Spec->catdir($root_path, $path, $year_stamp,
        $month_stamp);
    if (!-d $real_cache_path) {
        require MT::FileMgr;
        my $fmgr = $blog ? $blog->file_mgr : MT::FileMgr->new('Local');
        $fmgr->mkpath($real_cache_path) or return undef;
    }

    my $asset_cache_path = File::Spec->catdir(($pseudo ? $format : $root_path),
        $path, $year_stamp, $month_stamp);
    $asset_cache_path;
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
