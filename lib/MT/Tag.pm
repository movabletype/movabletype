# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Tag;

use strict;
use base qw( MT::Object );

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

sub class_label {
    return MT->translate('Tag');
}

sub class_label_plural {
    return MT->translate('Tags');
}

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
    } else {
        $tag->n8d_id(0) if $tag->n8d_id;
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

    my $private = $str =~ m/^@/;
    $str = MT::I18N::encode_text( $str, MT->instance->config->PublishCharset, 'utf-8' );
    $str =~ s/[@!`\\<>\*&#\/~\?'"\.\,=\(\)\${}\[\];:\ \+\-\r\n]+//gs;
    $str = lc $str;
    $str = '@' . $str if $private;
    $str = MT::I18N::encode_text( $str, 'utf-8', MT->instance->config->PublishCharset );
    $str;
}

sub remove {
    my $tag = shift;
    my $n8d_tag;
    if (ref $tag) {
        if (!$tag->n8d_id) {
            # normalized tag! we can't delete if others reference us
            my $child_tags = MT::Tag->count({n8d_id => $tag->id});
            return $tag->error(MT->translate("This tag is referenced by others."))
                if $child_tags;
        } else {
            $n8d_tag = MT::Tag->load($tag->n8d_id);
        }
    }
    $tag->remove_children({key => 'tag_id'});
    $tag->SUPER::remove(@_)
        or return $tag->error($tag->errstr);
    # check for an orphaned normalized tag and delete if necessary
    if ($n8d_tag) {
        # Normalized tag, no longer referenced by other tags...
        if (!MT::Tag->count({n8d_id => $n8d_tag->id})) {
            # Noramlized tag that no longer has any object tag associations
            require MT::ObjectTag;
            if (!MT::ObjectTag->count({tag_id => $n8d_tag->id})) {
                $n8d_tag->remove
                    or return $tag->error($n8d_tag->errstr);
            }
        }
    }
    1;
}

sub split {
    my $pkg = shift;
    my ($delim, $str) = @_;
    $delim = quotemeta($delim);
    my @tags;
    $str =~ s/(^\s+|\s+$)//gs;
    while (length($str) && ($str =~ m/^(((['"])(.*?)\3[^$delim]*?|.*?)($delim\s*|$))/s)) {
        $str = substr($str, length($1));
        my $tag = defined $4 ? $4 : $2;
        #$tag =~ s/(^[\s,]+|[\s,]+$)//gs;
        $tag =~ s/(^\s+|\s+$)//gs;
        $tag =~ s/\s+/ /gs;
        my $n8d_tag = MT::Tag->normalize($tag);
        next if $n8d_tag eq '';
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
            if (m/"/) {
                $tags .= "'" . $_ . "'";
            } else {
                $tags .= '"' . $_ . '"';
            }
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
    my %jargs;
    if ($terms->{blog_id}) {
        $blog_id = $terms->{blog_id};
        delete $terms->{blog_id};
        if ($args->{not} && $args->{not}{blog_id}) {
            $jargs{not}{blog_id} = 1;
        }
    }
    $args->{'join'} ||= MT::ObjectTag->join_on('tag_id', {
        $blog_id ? (blog_id => $blog_id) : (),
        object_datasource => $datasource
    }, { unique => 1, %jargs });
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
    my $sess_id = ($blog_id ? 'blog:' . $blog_id . ';' : '') . 'datasource:' . $ds . ($param{private} ? ';private' : '');
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
    my (%param) = @_;
    my $tag_cache = $pkg->cache_obj(\%param);
    $tag_cache->remove;

    $param{private} = 1;
    $tag_cache = $pkg->cache_obj(\%param);
    $tag_cache->remove;
}

sub cache {
    my $pkg = shift;
    my (%param) = @_;
    my $blog_id = $param{blog_id};
    my $class = $param{class};
    if (ref($class) eq 'SCALAR') {
        $class = eval "use $class;";
        if (my $err = $@) {
            $class = eval 'use MT::Entry;';
        }
    }
    my $ds = $class->datasource;
    $param{datasource} = $ds;

    my $tag_cache = $pkg->cache_obj(%param);
    my $data = $tag_cache->get('tag_cache');
    if (!$data) {
        my $tag_count;
        require MT::ObjectTag;
        $tag_count = {};
        my $tag_count_iter =
            MT::ObjectTag->count_group_by({
                ($blog_id ? (blog_id => $blog_id) : ()),
                object_datasource => $ds
            }, { group => ['tag_id']});
        while (my ($count, $tag_id) = $tag_count_iter->()) {
            $tag_count->{$tag_id} = $count;
        }
        my $iter = $class->load_iter(undef,
            { 'join' => ['MT::ObjectTag', 'object_id',
            { ($blog_id ? (blog_id => $blog_id) : ()), object_datasource => $ds },
            { unique => 1 } ],
              sort => 'modified_on', direction => 'descend' 
        });
        my @tags;
        my %tags_seen;
        my $limit = MT->config->MaxTagAutoCompletionItems;
        while (my $entry = $iter->()) {
            my @etags = $entry->tags;
            @etags = grep /^[^@]/, @etags unless $param{private};
            @etags = grep { !exists($tags_seen{$_}) } @etags;
            next if 0 == scalar(@etags);

            $tags_seen{$_} = 1 for @etags;

            my @ttags = MT::Tag->load({ 'name' => \@etags },
                { 'join' => ['MT::ObjectTag', 'tag_id',
                { ($blog_id ? (blog_id => $blog_id) : ()), object_datasource => $ds },
                { unique => 1 } ]
            });
            if (scalar(@tags) + scalar(@ttags) <= $limit) {
                push @tags, @ttags;
            } else {
                for (0..($limit - scalar(@tags)) - 1) {
                    push @tags, $ttags[$_];
                }
            }
            last if ($limit <= scalar(@tags));
        }
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

use constant TAG_CACHE_TIME => 7 * 24 * 60 * 60;  ## 1 week

sub tag_cache_key {
    my $obj = shift;
    return undef unless $obj->id;
    return sprintf "%stags-%d", $obj->datasource, $obj->id;
}

sub __load_tags {
    my $obj = shift;
    if (!$obj->id) {
        $obj->{__tags} = [];
        return $obj->{__tag_objects} = [];
    }
    return if exists $obj->{__tag_objects};

    require MT::Memcached;
    my $cache = MT::Memcached->instance;
    my $memkey = $obj->tag_cache_key;
    my @tags;
    if (my $tag_ids = $cache->get($memkey)) {
        @tags = grep { defined } @{ MT::Tag->lookup_multi($tag_ids) };
    } else {
        require MT::ObjectTag;
        @tags = MT::Tag->search(undef, {  
            sort => 'name',  
            join => [ 'MT::ObjectTag', 'tag_id', { object_id => $obj->id,
                object_datasource => $obj->datasource }, { unique => 1 } ],       
        });
        $cache->set($memkey, [ map { $_->id } @tags ], TAG_CACHE_TIME);
    }
    $obj->{__tags} = [ map { $_->name } @tags ];
    $obj->{__tag_objects} = \@tags;
}

sub get_tags {
    my $obj = shift;
    $obj->__load_tags unless $obj->{__tags} && @{ $obj->{__tags} };
    return @{ $obj->{__tags} };
}

sub get_tag_objects {
    my $obj = shift;
    $obj->__load_tags;
    return $obj->{__tag_objects};
}

sub set_tags {
    my $obj = shift;
    $obj->{__tags} = [ sort @_ ];
    $obj->{__save_tags} = 1;
}

sub save_tags {
    my $obj = shift;
    return 1 unless $obj->{__save_tags};
    require MT::ObjectTag;
    my $clear_cache = 0;
    my @tags = @{ $obj->{__tags} };
    return 1 unless @tags;
    $obj->{__tag_objects} = [];
    my $blog_id = $obj->has_column('blog_id') ? $obj->blog_id : 0;
    my @existing_tags = MT::ObjectTag->load({object_id => $obj->id,
        object_datasource => $obj->datasource });
    my %existing_tags = map { $_->tag_id => $_ } @existing_tags;
    foreach my $tag_name (@tags) {
        my $tag = MT::Tag->load({ name => $tag_name },
            { binary => { name => 1 } } );
        if ($tag) {
            if (exists $existing_tags{$tag->id}) {
                $existing_tags{$tag->id} = 0;
                push @{ $obj->{__tag_objects} }, $tag;
                next;
            }
        } else {
            # new tag
            $tag = new MT::Tag;
            $tag->name($tag_name);
            $tag->save or next;
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

        push @{ $obj->{__tag_objects} }, $tag;
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

        require MT::Memcached;
        MT::Memcached->instance->delete( $obj->tag_cache_key );
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
        if (keys %uniq) {
            $obj->set_tags(keys %uniq);
            return;
        }
    }
    require MT::ObjectTag;
    my @et = MT::ObjectTag->load({ object_id => $obj->id,
                                   object_datasource => $obj->datasource });
    $_->remove for @et;
    delete $obj->{__save_tags};
    MT::Tag->clear_cache(datasource => $obj->datasource,
        ($obj->blog_id ? (blog_id => $obj->blog_id) : ())) if @et;

    require MT::Memcached;
    MT::Memcached->instance->delete( $obj->tag_cache_key );
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
    my $pkg_terms = {};
    $pkg_terms->{id} = \'=objecttag_object_id';
    if ( $pkg->class_type eq 'entry' or $pkg->class_type eq 'page' ) {
        $pkg_terms->{class} = $pkg->class_type;
    }
    require MT::ObjectTag;
    MT::Tag->count(
        undef,
        {
            join => MT::ObjectTag->join_on(
                'tag_id', $jterms,
                { unique => 1, join => $pkg->join_on( undef, $pkg_terms ) }
            )
        }
    );
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

MT::Tag - Movable Type tag record and methods

=head1 SYNOPSIS

    use MT::Tag;
    my $tag = MT::Tag->new;
    $tag->name('favorite');
    $tag->save
        or die $tag->errstr;

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

=head1 OTHER METHODS

=head2 cache

Return the entry tags. If there are no cached tags, they are loaded
first. If the tags have already been loaded with this method, that
data is returned instead.

=head2 cache_obj

Cache the session tags.

=head2 clear_cache

Remove the tag cache.

=head2 join($seperator, @tags)

Return the given I<tags> as a string with the defined I<seperator>.

=head2 split($seperator, $tags)

Split-up the given I<tags> string by the given I<seperator>.

=head2 normalize($tag)

Sanitize the text (remove potentially characters) and lower-case the
I<tag>. The I<tag> may be given as a string or as a tag object. In the
case of the latter, C<$tag-E<gt>name> attribute is used.

=head2 load_by_datasource($datasource, $terms, $args)

Return a list of tags given by an object I<datasource> type, selection
I<terms> and I<arguments>.

=head2 $tag->save()

Save the literal as well as a normalized copy if one does not exist.

=head2 $tag->remove()

Remove the tag and all its children unless it is referenced by another
entry.

=head1 NOTES

=over 4

=item *

When you remove a tag using I<MT::Tag::remove>, in addition to
removing the tag record, all of the related I<MT::ObjectTag> records are
removed as well.

=back

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
