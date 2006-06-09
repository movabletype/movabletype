# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Tag;
use strict;

use MT::Blog;
use MT::Object;
@MT::Tag::ISA = qw( MT::Object );

__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment primary key',
        'name' => 'string(255) not null',
        'n8d_id' => 'integer',
        'is_private' => 'boolean'
    },
    indexes => {
        name => 1,
        is_private => 1,
        n8d_id => 1,
    },
    defaults => {
        n8d_id => 0,
        is_private => 0,
    },
    child_classes => ['MT::ObjectTag'],
    datasource => 'tag',
    primary_key => 'id',
});

sub save {
    my $tag = shift;
    my $name = $tag->name;
    return $tag->error(MT->translate("Tag must have a valid name"))
        unless defined($name) && length($name);
    my $n8d = $tag->normalize;
    return $tag->error(MT->translate("Tag must have a valid name"))
        unless defined($n8d) && length($n8d);
    if ($n8d ne $name) {
        my $n8d_tag = MT::Tag->load({ name => $n8d });
        if (!$n8d_tag) {
            $n8d_tag = new MT::Tag;
            $n8d_tag->name($n8d);
            $n8d_tag->save;
        }
        if (!$tag->n8d_id || ($tag->n8d_id != $n8d_tag->id)) {
            $tag->n8d_id($n8d_tag->id);
        }
    }
    # maintain the private flag...
    $tag->is_private( $name =~ m/^@/ ? 1 : 0 );
    $tag->SUPER::save();
}

sub normalize {
    my $tag = shift;
    my ($str) = @_;
    if (!@_ && !(ref $tag)) {
        $str = $tag;
    } elsif (!$str && (ref $tag)) {
        $str = $tag->name;
    }
    # FIXME: character set issues here...
    my $private = $str =~ m/^@/;
    $str =~ s/[@!`\\<>\*&#\/~\?'"\.\,=\(\)\${}\[\];:\ \+\-\r\n]+//gs;
    $str = lc $str;
    $str = '@' . $str if $private;
    $str;
}

sub remove {
    my $tag = shift;
    my $n8d_tag;
    if (!$tag->n8d_id) {
        # normalized tag! we can't delete if others reference us
        my $child_tags = MT::Tag->count({n8d_id => $tag->id});
        return $tag->error(MT->translate("This tag is referenced by others."))
            if $child_tags;
    } else {
        $n8d_tag = MT::Tag->load($tag->n8d_id);
    }
    $tag->remove_children({key => 'tag_id'});
    $tag->SUPER::remove;
    # check for an orphaned normalized tag and delete if necessary
    if ($n8d_tag) {
        # Normalized tag, no longer referenced by other tags...
        if (!MT::Tag->count({n8d_id => $n8d_tag->id})) {
            # Noramlized tag that no longer has any object tag associations
            require MT::ObjectTag;
            if (!MT::ObjectTag->count({tag_id => $n8d_tag->id})) {
                $n8d_tag->remove;
            }
        }
    }
}

sub split {
    my $pkg = shift;
    my ($delim, $str) = @_;
    $delim = quotemeta($delim);
    my @tags;
    $str =~ s/(^\s+|\s+$)//gs;
    while (length($str) && ($str =~ m/^(((['"])(.*?)\3|.*?)($delim\s*|$))/s)) {
        $str = substr($str, length($1));
        my $tag = defined $4 ? $4 : $2;
        $tag =~ s/(^\s+|\s+$)//gs;
        $tag =~ s/\s+/ /gs;
        push @tags, $tag if $tag ne '';
    }
    @tags;
}

sub join {
    my $obj = shift;
    my ($delim, @tags) = @_;
    my $tags = '';
    foreach (@tags) {
        $tags .= $delim . ($delim eq ' ' ? '' : ' ') if $tags ne '';
        if (m/\Q$delim\E/) {
            $tags .= '"' . $_ . '"';
        } else {
            $tags .= $_;
        }
    }
    $tags;
}

sub load_by_datasource {
    my $pkg = shift;
    my ($datasource, $terms, $args) = @_;
    $args ||= {};
    $args->{'sort'} ||= 'name';
    my $blog_id;
    if ($terms->{blog_id}) {
        $blog_id = $terms->{blog_id};
        delete $terms->{blog_id};
    }
    $args->{'join'} ||= ['MT::ObjectTag', 'tag_id', {
        $blog_id ? (blog_id => $blog_id) : (),
        object_datasource => $datasource
    }, { unique => 1 }];
    my @tags = MT::Tag->load($terms, $args);
    @tags;
}

# static method for tag cache control
sub cache_obj {
    my $pkg = shift;
    my (%param) = @_;
    my $blog_id = $param{blog_id};
    my $ds = $param{datasource};

    require MT::Session;
    # Clear any tag cache if tags were modified upon saving
    my $sess_id = ($blog_id ? 'blog:' . $blog_id . ';' : '') . 'datasource:' . $ds;
    my $tag_cache = MT::Session::get_unexpired_value(60 * 60, {
        kind => 'TC',  # tag cache
        id => $sess_id
    });
    if (!$tag_cache) {
        $tag_cache = new MT::Session;
        $tag_cache->kind('TC');
        $tag_cache->id($sess_id);
        $tag_cache->start(time);
    }
    $tag_cache;
}

sub clear_cache {
    my $pkg = shift;
    my $tag_cache = $pkg->cache_obj(@_);
    $tag_cache->remove;
}

sub cache {
    my $pkg = shift;
    my (%param) = @_;
    my $blog_id = $param{blog_id};
    my $ds = $param{datasource};

    my $tag_cache = $pkg->cache_obj(@_);
    my $data = $tag_cache->get('tag_cache');
    if (!$data) {
        my $tag_count;
        require MT::ObjectTag;
        if (MT::Object->driver->can('count_group_by')) {
            $tag_count = {};
            my $tag_count_iter =
                MT::ObjectTag->count_group_by({
                    ($blog_id ? (blog_id => $blog_id) : ()),
                    object_datasource => $ds
                }, { group => ['tag_id']});
            while (my ($count, $tag_id) = $tag_count_iter->()) {
                $tag_count->{$tag_id} = $count;
            }
        }
        my @tags = MT::Tag->load(undef,
            { 'join' => ['MT::ObjectTag', 'tag_id',
            { ($blog_id ? (blog_id => $blog_id) : ()), object_datasource => $ds },
            { unique => 1 } ]
        });
        $data = {};
        foreach my $tag (@tags) {
            $data->{$tag->name} = $tag_count->{$tag->id} || 1;
        }
        $tag_cache->set('tag_cache', $data);
        $tag_cache->save;
    }
    $data || {};
}

# An interface for any MT::Object that wishes to utilize tags themselves

package MT::Taggable;

sub get_tags {
    my $obj = shift;
    return @{ $obj->{__tags} } if $obj->{__tags};
    require MT::ObjectTag;
    my @tags = MT::Tag->load(undef, {  
        sort => 'name',  
        join => [ 'MT::ObjectTag', 'tag_id', { object_id => $obj->id,
            object_datasource => $obj->datasource }, { unique => 1 } ],       
    });
    my @tagnames;
    foreach (@tags) {  
        push @tagnames, $_->name;
    }  
    $obj->{__tags} = \@tagnames;
    @tagnames;
}

sub set_tags {
    my $obj = shift;
    $obj->{__tags} = \@_;
    $obj->{__save_tags} = 1;
}

sub save_tags {
    my $obj = shift;
    return 1 unless $obj->{__save_tags};
    require MT::ObjectTag;
    my $clear_cache = 0;
    my @tags = @{ $obj->{__tags} };
    my $blog_id = $obj->column('blog_id') || 0;
    my @existing_tags = MT::ObjectTag->load({object_id => $obj->id,
        object_datasource => $obj->datasource });
    my %existing_tags = map { $_->tag_id => $_ } @existing_tags;
    foreach my $tag_name (@tags) {
        my $tag = MT::Tag->load({ name => $tag_name },
            { binary => { name => 1 } } );
        if ($tag) {
            if (exists $existing_tags{$tag->id}) {
                $existing_tags{$tag->id} = 0;
                next;
            }
        } else {
            # new tag
            $tag = new MT::Tag;
            $tag->name($tag_name);
            $tag->save or return;
            $clear_cache = 1;
        }
        my $otag = new MT::ObjectTag;
        $otag->blog_id($blog_id);
        $otag->tag_id($tag->id);
        $otag->object_id($obj->id);
        $otag->object_datasource($obj->datasource);
        $otag->save or return $obj->error($otag->errstr);
        $existing_tags{$tag->id} = 0;
        $clear_cache = 1;
    }

    foreach my $otag (values %existing_tags) {
        next unless ref $otag;
        my $this_tag_id = $otag->tag_id;
        $otag->remove;
        if (! MT::ObjectTag->count({tag_id => $this_tag_id})) {
            # no more references to this tag... just delete it now
            if (my $tag = MT::Tag->load($this_tag_id)) {
                $tag->remove;
            }
        }
        $clear_cache = 1;
    }
    delete $obj->{__save_tags};
    if ($clear_cache) {
        MT::Tag->clear_cache(datasource => $obj->datasource, ($blog_id ? (blog_id => $blog_id) : ()));
    }
    1;
}

sub tags {
    my $obj = shift;
    $obj->set_tags(@_) if @_;
    $obj->get_tags;
}

sub add_tags {
    my $obj = shift;
    my (@tags) = @_;
    my @etags = $obj->tags;
    push @tags, @etags;
    my %uniq;
    @uniq{@tags} = ();
    $obj->set_tags(keys %uniq);
}

sub remove_tags {
    my $obj = shift;
    my (@tags) = @_;
    if (@tags) {
        my @etags = $obj->tags;
        my %uniq;
        @uniq{@etags} = ();
        delete $uniq{$_} for @tags;
        $obj->set_tags(keys %uniq);
    } else {
        require MT::ObjectTag;
        my @et = MT::ObjectTag->load({ object_id => $obj->id,
                                       object_datasource => $obj->datasource });
        $_->remove for @et;
        delete $obj->{__save_tags};
        MT::Tag->clear_cache(datasource => $obj->datasource,
            ($obj->blog_id ? (blog_id => $obj->blog_id) : ())) if @et;
    }
}

sub has_tag {
    my $obj = shift;
    my ($tag) = @_;
    # this should also check normalized versions
    $tag = $tag->name if ref $tag;
    my $n8d_tag = MT::Tag->normalize($tag);
    my @tags = $obj->tags;
    foreach (@tags) {
        return 1 if $tag eq $_;
        return 1 if ($tag ne $n8d_tag) && ($n8d_tag eq MT::Tag->normalize($_));
    }
    0;
}

# counts number of tags
sub tag_count {
    my $obj = shift;
    my ($terms) = @_;
    my $pkg = ref $obj ? ref $obj : $obj;
    $terms ||= {};
    my $jterms = {};
    if (ref $obj) {
        $terms->{object_id} = $obj->id if $obj->id;
        $jterms->{blog_id} = $obj->blog_id if $obj->column('blog_id');
    }
    if ($terms->{blog_id}) {
        $jterms->{blog_id} = $terms->{blog_id};
        delete $terms->{blog_id};
    }
    $jterms->{object_datasource} = $obj->datasource;
    require MT::ObjectTag;
    MT::Tag->count(undef, { join => ['MT::ObjectTag', 'tag_id', $jterms, { unique => 1 } ] });
}

# counts number of objects tagged with a given tag
sub tagged_count {
    my $obj = shift;
    my ($tag_id, $terms) = @_;
    $terms ||= {};
    my $jterms = {};
    my $pkg = ref $obj ? ref $obj : $obj;
    if (defined $tag_id && ($tag_id =~ m/\D/)) {
        my $n8d_tag = MT::Tag->normalize($tag_id);
        my $tag = MT::Tag->load({ name => [ $tag_id, $n8d_tag ] },
            { binary => { name => 1 } });
        return 0 unless $tag;
        $tag_id = $tag->id;
    }
    if (ref $obj) {
        $terms->{object_id} = $obj->id if $obj->id;
        $jterms->{blog_id} = $obj->blog_id if $obj->column('blog_id');
    } else {
        $jterms->{blog_id} = $terms->{blog_id} if $terms->{blog_id};
    }
    $jterms->{object_datasource} = $pkg->datasource;
    $jterms->{tag_id} = $tag_id if $tag_id;
    my $args = { join => ['MT::ObjectTag', 'object_id', $jterms, { unique => 1 }] };
    require MT::ObjectTag;
    $pkg->count($terms, $args);
}

1;
__END__

=head1 NAME

MT::Tag - Movable Type tag record

=head1 SYNOPSIS

    use MT::Tag;
    my $tag = MT::Tag->new;
    $tag->name('favorite');
    $tag->save
        or die $tag->errstr;

=head1 DESCRIPTION

=head1 USAGE

=head1 DATA ACCESS METHODS

The I<MT::Tag> object holds the following pieces of data. These fields
can be accessed and set using the standard data access methods described in
the L<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the tag.

=item * name

The name of the tag.

=item * n8d_id

The ID of a "normalized" version of this tag. If undef or 0, it would
signifiy this tag is a normalized tag name.

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

When you remove a tag using I<MT::Tag::remove>, in addition to
removing the tag record, all of the related I<MT::ObjectTag> records are
removed as well.

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
