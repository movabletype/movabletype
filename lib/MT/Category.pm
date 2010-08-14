# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Category;

use strict;
use base qw( MT::Object );
use MT::Util qw( weaken );

use MT::Blog;

__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'blog_id' => 'integer not null',
        'label' => 'string(100) not null',
        'author_id' => 'integer',
        'ping_urls' => 'text',
        'description' => 'text',
        'parent' => 'integer',
        'allow_pings' => 'boolean',
        'basename' => 'string(255)',

        'show_fields' => 'string meta',
    },
    indexes => {
        blog_id => 1,
        label => 1,
        parent => 1,
        blog_basename => {
            columns => [ 'blog_id', 'basename' ],
        },
        blog_class => {
            columns => [ 'blog_id', 'class' ],
        },
    },
    defaults => {
        parent => 0,
        allow_pings => 0,
    },
    class_type => 'category',
    child_of => 'MT::Blog',
    audit => 1,
    meta => 1,
    child_classes => ['MT::Placement', 'MT::Trackback', 'MT::FileInfo'],
    datasource => 'category',
    primary_key => 'id',
});

sub list_props {
    return {
        parent => {
            auto  => 1,
            label => 'Parent',
        },
        entry_count => {
            base    => '__common.integer',
            label => 'Entry count',
            raw => sub {
                my ( $prop, $obj ) = @_;
                return MT->model('placement')->count({ category_id => $obj->id });
            },
        },
        custom_sort => {
            class => 'category',
            bulk_sort => sub {
                my ( $prop, $objs ) = @_;
                require MT::Category;
                require MT::Blog;
                my $rep  = $objs->[0] or return;
                my $blog = MT::Blog->load({ id => $rep->blog_id }, { no_class => 1 });
                my $meta = $prop->class . '_order';
                my $text = $blog->$meta || '';
                my @cats = _sort_by_id_list( $text, $objs );
                @cats = grep { ref $_ } MT::Category::_flattened_category_hierarchy( \@cats );
                return @cats;
            },
        },
    };
}

sub class_label {
    MT->translate("Category");
}

sub class_label_plural {
    MT->translate("Categories");
}

sub contents_label {
    MT->translate("Entry");
}

sub contents_label_plural {
    MT->translate("Entries");
}

sub basename_prefix {
    my $this = shift;
    my ($dash) = @_;
    my $prefix = 'cat';
    if ($dash) {
        $prefix .= MT->instance->config('CategoryNameNodash') ? '' : '-';
    }
    $prefix;
}

sub ping_url_list {
    my $cat = shift;
    return [] unless $cat->ping_urls && $cat->ping_urls =~ /\S/;
    [ split /\r?\n/, $cat->ping_urls ];
}

sub publish_path {
    my $cat = shift;
    return $cat->{__path} if exists $cat->{__path};
    my $result = $cat->basename;
    my $orig = $cat;
    do {
        $cat = $cat->parent ? __PACKAGE__->load($cat->parent) : undef;
        $result = join "/", $cat->basename, $result if $cat;
    } while ($cat);
    # caching this information may be problematic IF
    # parent category basenames are changed.
    $orig->{__path} = $result;
}
*category_path = \&publish_path;

sub category_label_path {
    my $cat = shift;
    return $cat->{__label_path} if exists $cat->{__label_path};
    my $result = $cat->label =~ m!/! ? '[' . $cat->label . ']' : $cat->label;
    my $orig = $cat;
    do {
        $cat = $cat->parent ? __PACKAGE__->load($cat->parent) : undef;
        $result = join "/", ($cat->label =~ m!/! ? '[' . $cat->label . ']' : $cat->label),
            $result if $cat;
    } while ($cat);
    # caching this information may be problematic IF
    # parent category labels are changed.
    $orig->{__label_path} = $result;
}

sub cache_obj {
    my $pkg = shift;
    my (%param) = @_;
    my $blog_id = $param{blog_id};
    my $sess_id = 'blog:' . $blog_id;
    require MT::Session;
    my $cat_cache = MT::Session::get_unexpired_value(60 * 60, {
        kind => 'CC',  # category cache
        id => $sess_id
    });
    if (!$cat_cache) {
        $cat_cache = new MT::Session;
        $cat_cache->kind('CC');
        $cat_cache->id($sess_id);
        $cat_cache->start(time);
        $cat_cache->duration(time + 60 * 60);
    }
    $cat_cache;
}

sub clear_cache {
    my $pkg = shift;
    my (%param) = @_;
    my $cat_cache = $pkg->cache_obj(@_);
    $cat_cache->remove;
}

sub cache {
    my $pkg = shift;
    my (%param) = @_;
    my $blog_id = $param{blog_id};
    my $sess_id = 'blog:' . $blog_id;
    my $cat_cache = $pkg->cache_obj(@_);
    my $data = $cat_cache->get('category_cache');
    if (!$data) {
        my $cat_iter = $pkg->load_iter({blog_id => $blog_id});
        $data = [];
        while (my $cat = $cat_iter->()) {
            push @$data, [ $cat->id, $cat->label, $cat->parent ];
        }
        $cat_cache->set('category_cache', $data);
        $cat_cache->save;
    }
    $data || [];
}

sub save {
    my $cat = shift;
    my $pkg = ref($cat);

    my $clear_cache;
    if ($cat->id) {
        my $orig_cat = $pkg->load($cat->id);
        if (!$orig_cat || ($orig_cat->label ne $cat->label) || ($orig_cat->parent != $cat->parent)) {
            $clear_cache = 1;
        }
    } else {
        # new category-- invalidate any cache
        $clear_cache = 1;
    }

    # check that the parent is legit.
    if ($cat->parent && $cat->parent ne '0') {
        my $parent = $pkg->load($cat->parent);
        $cat->parent(0) unless $parent;
    }

    if ($cat->parent && $cat->parent ne '0') {
        my $parent = $pkg->load($cat->parent);
        if (!$parent) {
            return $cat->error(MT->translate("Categories must exist within the same blog"))
                if ($cat->blog_id != $parent->blog_id);
            return $cat->error(MT->translate("Category loop detected"))
                if ($cat->id && $cat->is_ancestor($parent));
        }
    }

    $cat->SUPER::save(@_) or return;

    # set category basename after save, because of cat_id needed.
    if (!defined($cat->basename) || ($cat->basename eq '')) {
        require MT::Util;
        my $name = MT::Util::make_unique_category_basename($cat);
        $cat->basename($name);
        $cat->SUPER::save(@_) or return;
    }

    ## If pings are allowed on this entry, create or update
    ## the corresponding Trackback object for this entry.
    require MT::Trackback;
    if ($cat->allow_pings) {
        my $tb;
        unless ($tb = MT::Trackback->load({
                                 category_id => $cat->id })) {
            $tb = MT::Trackback->new;
            $tb->blog_id($cat->blog_id);
            $tb->category_id($cat->id);
            $tb->entry_id(0);   ## entry_id can't be NULL
        }
        if (defined(my $pass = $cat->{__tb_passphrase})) {
            $tb->passphrase($pass);
        }
        $tb->title($cat->label);
        $tb->description($cat->description);
        my $blog = MT::Blog->load($cat->blog_id)
            or return;
        my $url = $blog->archive_url;
        $url .= '/' unless $url =~ m!/$!;
        $url .= MT::Util::archive_file_for(undef, $blog,
            'Category', $cat);
        $tb->url($url);
        $tb->is_disabled(0);
        $tb->save
            or return $cat->error($tb->errstr);
    } else {
        ## If there is a TrackBack item for this category, but
        ## pings are now disabled, make sure that we mark the
        ## object as disabled.
        if (my $tb = MT::Trackback->load({
                                  category_id => $cat->id })) {
            $tb->is_disabled(1);
            $tb->save
                or return $cat->error($tb->errstr);
        }
    }
    if ($clear_cache) {
        $pkg->clear_cache('blog_id' => $cat->blog_id);
    }
    1;
}

sub remove {
    my $cat = shift;
    $cat->remove_children({ key => 'category_id' });
    if (ref $cat) {
        my $pkg = ref($cat);
        # orphan my children up to the root level
        my @children = $cat->children_categories;
        if (scalar @children) {
            foreach my $child (@children) {
                $child->parent(($cat->parent) ? $cat->parent : '0');
                $child->save or return $cat->error($child->save);
            }
        } else {
            $pkg->clear_cache('blog_id' => $cat->blog_id);
        }
    }
    $cat->SUPER::remove(@_);
}


sub _flattened_category_hierarchy {
    # Either the class name or a MT::Category object
    my $cat = shift;
    my $class = ref($cat) || $cat;
    my @cats = ();
    my @flattened_cats = ();

    # the starting point is the category instance
    if ( ref $cat && UNIVERSAL::isa($cat, 'MT::Category') ) {
        @cats = ($cat);

        # Depth-first search time
        foreach my $c (@cats) {
            # Push the current category onto the list
            push @flattened_cats, $c;

            # If it has any children
            my @children = $c->children_categories;
            if (scalar @children) {

                # Indicate the start of the children

                push @flattened_cats, "BEGIN_SUBCATS";

                # Add all the kids (and their associated subcategories)
                foreach my $kid (@children) {
                    push @flattened_cats, ($kid->_flattened_category_hierarchy);
                }

                # Indicate the end of the children
                push @flattened_cats, "END_SUBCATS";
            }
        }
        return @flattened_cats;
    }


    if (!ref ($cat)) {
        # If it is the class name (i.e. called "statically")
        # Grab the blog_id from the parameters list and get the top level categories
        my $blog_id = shift or return ();

        @cats = $class->load({ blog_id => $blog_id }, { 'sort' => 'label' });
    }
    else {
        @cats = @$cat;
    }

    my $children = {};
    foreach my $cat (@cats) {
        if ($cat->parent) {
            my $list = $children->{$cat->parent} ||= [];
            push @$list, $cat;
        }
    }
    sub __pusher {
        my ($children, $id) = @_;
        my $list = $children->{$id};
        return () unless $list && @$list;
        my @flat;
        push @flat, 'BEGIN_SUBCATS';
        foreach (@$list) {
            push @flat, $_;
            if ($children->{$_->id}) {
                push @flat, __pusher($children, $_->id);
            }
        }
        push @flat, 'END_SUBCATS';
        @flat;
    }
    foreach my $cat (@cats) {
        if (!$cat->parent) {
            push @flattened_cats, $cat;
            push @flattened_cats, __pusher($children, $cat->id)
                    if $children->{$cat->id};
        }
    }
    return @flattened_cats;
}

sub _sort_by_id_list {
    my ( $text, $objs ) = @_;
    my @ids = split ',', $text;
    my %id_map = map { $_->id => $_ } @$objs;
    my @objs;
    for my $id ( @ids ) {
        push @objs, delete $id_map{$id} if $id_map{$id};
    }
    if ( scalar %id_map ) {
        push @objs, sort { $a->label cmp $b->label } values %id_map;
    }
    @objs;
}

# Deprecated routine -- also assumes MT::Category class, so it won't
# work with folders for instance.
sub _buildCatHier {
    my ($blog_id) = @_;
  
    require MT::Request;

    my %children;

    my $r = MT::Request->instance;
    my $all_cats = $r->cache('sub_cats_cats');
    unless ($all_cats) {
        $r->cache('sub_cats_cats', $all_cats = {});
    }
    my $cats;
    if (defined $all_cats->{$blog_id}) {
        my $children = $all_cats->{$blog_id}{'children'};
        return ($children);
    }

    # Start by loading all the categories for the given blog
    # and default to setting all of their parents to '0'
  
    my @cats = MT::Category->load({ blog_id => $blog_id });
    foreach my $cat (@cats) {
        push @{$children{($cat->parent) ? $cat->parent : '0'}}, $cat;
    }

    foreach my $i (keys %children) {
        @{$children{$i}} = sort { $a->label cmp $b->label } @{$children{$i}};
    }

    $all_cats->{$blog_id}{'children'} = \%children;
    $r->cache('sub_cats_cats', $all_cats);
 
    (\%children);
}

sub top_level_categories {
    my ($class, $blog_id) = @_;
    my @cats = $class->load({ blog_id => $blog_id, parent => '0' }, { 'sort' => 'label' });
}

sub copy_cat {
    my $class = shift;
    my $cat = $class->new;
    my $old_cat = shift;
    $cat->set_values($old_cat->column_values);
    $cat;
}

sub parent_categories {
    my $cat = shift;

    return () if (!$cat->parent_category);
    ($cat->parent_category, $cat->parent_category->parent_categories);
}

sub parent_category {
    my $cat = shift;
    my $class = ref($cat);
    unless ($cat->{__parent_category}) {
        $cat->{__parent_category} = ($cat->parent) ? $class->load($cat->parent) : undef;
        weaken( $cat->{__parent_category} )
            if !MT->config->DisableObjectCache;
    }
    $cat->{__parent_category};
}

sub children_categories {
    my $cat = shift;
    my $class = ref($cat);
    unless ($cat->{__children}) {
        @{$cat->{__children}} = sort { $a->label cmp $b->label }
        $class->load({ blog_id => $cat->blog_id,
            parent => $cat->id });
    }
    @{$cat->{__children}};
}

sub is_ancestor {
    my $cat = shift;
    my ($possible_child) = @_;

    # Catch the different blog edge case
    return 0 if $cat->blog_id != $possible_child->blog_id;

    return 1 if $cat->id == $possible_child->id;

    # Keep having the child bump up one level in the hierarchy
    # to see if it ever reaches the current category
    # (more efficient then descending from the current category
    # as the children lists do not need to be calculated

    my $class = ref($cat);
    while (my $id = $possible_child->parent) {
        $possible_child = $class->load($id);
        return 1 if $cat->id == $possible_child->id;
    }
  
    # Looks like we didn't find it
    0;
}

sub is_descendant {
    my $cat = shift;
    my ($possible_parent) = @_;
    $possible_parent->is_ancestor($cat);
}

sub entry_count {
    my $cat = shift;
    $cat->cache_property('entry_count', sub {
        require MT::Placement;
        my $class = MT->model( $cat->class eq 'folder' ? 'page' : 'entry' );
        my @args = ({ blog_id => $cat->blog_id,
                      status  => $class->RELEASE() },
                    { 'join'  => [ 'MT::Placement', 'entry_id',
                                 { category_id => $cat->id } ] });
        scalar $class->count(@args);
    }, @_);
}

sub populate_category_hierarchy {
    my $class = shift;
    my ( $blog_id, $parent_id, $depth ) = @_;

    my @cats;
    # sort in reverse order since we unshift objects here
    my $iter = $class->load_iter(
        { blog_id => $blog_id, parent => $parent_id },
        { sort => 'label', direction => 'descend' }
    );
    while ( my $cat = $iter->() ) {
        my $subcats = $class->populate_category_hierarchy( $blog_id, $cat->id, $depth + 1 );
        unshift @cats, @$subcats if @$subcats;

        my $values = $cat->get_values;
        my $fields = $cat->show_fields;
        $values->{selected_fields} = $fields;
        $values->{category_pixel_depth} = 10 * $depth;
        unshift @cats, $values;
    }
    return \@cats;
}


1;
__END__

=head1 NAME

MT::Category - Movable Type category record

=head1 SYNOPSIS

    use MT::Category;
    my $cat = MT::Category->new;
    $cat->blog_id($blog->id);
    $cat->label('My Category');
    my @children = $cat->children;
    $cat->save
        or die $cat->errstr;

=head1 DESCRIPTION

An I<MT::Category> object represents a category in the Movable Type system.
It is essentially a wrapper around the category label; by wrapping the label
in an object with a numeric ID, we can use the ID as a "foreign key" when
mapping entries into categories. Thus, if the category label changes, the
mappings don't break. This object does not contain any information about the
category-entry mappings--for those, look at the I<MT::Placement> object.

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::Category> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

=head1 DATA ACCESS METHODS

The I<MT::Category> object holds the following pieces of data. These fields
can be accessed and set using the standard data access methods described in
the I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the category.

=item * blog_id

The numeric ID of the blog to which this category belongs.

=item * label

The label of the category.

=item * author_id

The numeric ID of the author you created this category.

=item * parent_category

Returns a I<MT::Category> object representing the immediate parent category.
Returns undef if there is none.

=item * parent_categories

Returns an array of I<MT::Category> objects representing the path from the
category to the top level of categories, with the first member of the array
being the immediate parent.  Returns an empty array if the category is already
at the top level.

=item * children_categories

Returns an array of I<MT::Category> objects representing all of the
immediate children of the category.

=item * $subcat->is_descendant($parent)

Returns a true value if the category is a descendant of $parent.

=item * $subcat->is_ancestor($child)

Returns a true value if the category is an ancestor of $child.

=back

=head1 DATA LOOKUP

In addition to numeric ID lookup, you can look up or sort records by any
combination of the following fields. See the I<load> documentation in
I<MT::Object> for more information.

=over 4

=item * blog_id

=item * label

=back

=head1 NOTES

=over 4

=item *

When you remove a category using I<MT::Category::remove>, in addition to
removing the category record, all of the entry-category mappings
(I<MT::Placement> objects) will be removed.

=back

=head1 CLASS METHODS

=over 4

=item * MT::Category->top_level_categories($blog_id)

Returns an array of I<MT::Category> objects representing the top level of
the category hierarchy in the blog identified by $blog_id.

=back

=over 4

=item * MT::Category->populate_category_hierarchy($blog_id, $parent_id, $depth)

Returns a reference to an array of hashrefs that contains category objects of
the specified blog, ordered in a "thread"; parent category comes first, children
next, grand children third, and the next parent, etc.

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
