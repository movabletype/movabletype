# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Page;

use strict;
use warnings;
use base qw( MT::Entry );
use MT::Util qw( archive_file_for );

__PACKAGE__->install_properties(
    {   class_type    => 'page',
        child_of      => 'MT::Blog',
        child_classes => [
            'MT::Comment',   'MT::Placement',
            'MT::Trackback', 'MT::FileInfo'
        ],
    }
);

# Callbacks: clean list of changed columns to only
# include versioned columns
MT->add_callback( 'data_api_pre_save.' . 'page',
    9, undef, \&MT::Revisable::mt_presave_obj );
MT->add_callback( 'api_pre_save.' . 'page',
    9, undef, \&MT::Revisable::mt_presave_obj );
MT->add_callback( 'cms_pre_save.' . 'page',
    9, undef, \&MT::Revisable::mt_presave_obj );

# Callbacks: object-level callbacks could not be
# prioritized and thus caused problems with plugins
# registering a post_save and saving
MT->add_callback( 'data_api_post_save.' . 'page',
    9, undef, \&MT::Revisable::mt_postsave_obj );
MT->add_callback( 'api_post_save.' . 'page',
    9, undef, \&MT::Revisable::mt_postsave_obj );
MT->add_callback( 'cms_post_save.' . 'page',
    9, undef, \&MT::Revisable::mt_postsave_obj );

# Register page post-save callback for rebuild triggers
MT->add_callback(
    'cms_post_save.page', 10,
    MT->component('core'),
    sub { MT->model('rebuild_trigger')->runner( 'post_entry_save', @_ ); }
);
MT->add_callback(
    'api_post_save.page', 10,
    MT->component('core'),
    sub { MT->model('rebuild_trigger')->runner( 'post_entry_save', @_ ); }
);
MT->add_callback(
    'cms_post_bulk_save.pages',
    10,
    MT->component('core'),
    sub {
        MT->model('rebuild_trigger')->runner( 'post_entries_bulk_save', @_ );
    }
);

__PACKAGE__->add_callback(
    'post_remove', 0,
    MT->component('core'),
    \&MT::Revisable::mt_postremove_obj
);

sub list_props {
    return {
        id          => { base => 'entry.id',          order => 100, },
        title       => { base => 'entry.title',       order => 200, },
        author_name => { base => 'entry.author_name', order => 300, },
        blog_name   => {
            base    => '__common.blog_name',
            display => 'default',
            order   => 400,
        },
        folder => {
            base             => 'entry.category',
            label            => 'Folder',
            filter_label     => 'Folder',
            display          => 'default',
            order            => 500,
            category_class   => 'folder',
            zero_state_label => '(root)',
        },
        folder_id => {
            base             => 'entry.category_id',
            label            => 'Folder',
            filter_label     => 'Folder',
            display          => 'default',
            view_filter      => [ 'blog', 'website' ],
            order            => 500,
            category_class   => 'folder',
            zero_state_label => '(root)',
            label_via_param  => sub {
                my $prop = shift;
                my ( $app, $val ) = @_;
                my $cat = MT->model('folder')->load($val)
                    or return $prop->error(
                    MT->translate(
                        '[_1] ( id:[_2] ) does not exists.',
                        $prop->datasource->container_label,
                        defined $val ? $val : ''
                    )
                    );
                my $label = MT->translate(
                    'Pages in folder: [_1]',
                    $cat->label . " (ID:" . $cat->id . ")",
                );
                $prop->{filter_label} = MT::Util::encode_html($label);
                $label;
            },
        },
        created_on  => { base => 'entry.created_on', order => 600, },
        modified_on => {
            order   => 700,
            base    => 'entry.modified_on',
            display => 'default',
        },
        unpublished_on => { base => 'entry.unpublished_on', },
        text           => { base => 'entry.text' },
        text_more      => { base => 'entry.text_more' },
        excerpt        => {
            base    => 'entry.excerpt',
            display => 'none',
            label   => 'Excerpt',
        },
        authored_on => {
            base    => 'entry.authored_on',
            display => 'optional',
        },
        status => {
            base                  => 'entry.status',
            single_select_options => [
                {   label => MT->translate('Draft'),
                    value => 1,
                    text  => 'Draft',
                },
                {   label => MT->translate('Published'),
                    value => 2,
                    text  => 'Publish',
                },
                {   label => MT->translate('Scheduled'),
                    value => 4,
                    text  => 'Future',
                },
                {   label => MT->translate('Unpublished (End)'),
                    value => 6,
                    text  => 'Unpublish',
                },
            ],
        },
        basename => { base => 'entry.basename' },
        tag      => {
            base   => 'entry.tag',
            tag_ds => 'entry',
        },
        modified_by => {
            base    => 'entry.modified_by',
            display => 'optional',
        },
        current_user =>
            { base => 'entry.current_user', label => 'My Pages', },
        author_status   => { base => 'entry.author_status' },
        current_context => { base => '__common.current_context' },
        content         => {
            base    => '__virtual.content',
            fields  => [qw(title text text_more keywords excerpt basename)],
            display => 'none',
        },
        blog_id => {
            auto            => 1,
            col             => 'blog_id',
            display         => 'none',
            filter_editable => 0,
        },
        __mobile => {
            base     => 'entry.__mobile',
            date_col => 'modified_on',
        },
    };
}

sub system_filters {
    return {
        current_website => {
            label => 'Pages in This Site',
            items => [ { type => 'current_context' } ],
            order => 100,
            view  => 'website',
        },
        published => {
            label => 'Published Pages',
            items => [ { type => 'status', args => { value => '2' }, }, ],
            order => 200,
        },
        draft => {
            label => 'Draft Pages',
            items => [ { type => 'status', args => { value => '1' }, }, ],
            order => 300,
        },
        unpublished => {
            label => 'Unpublished Pages',
            items => [ { type => 'status', args => { value => '6' }, }, ],
            order => 350,
        },
        future => {
            label => 'Scheduled Pages',
            items => [ { type => 'status', args => { value => '4' }, }, ],
            order => 400,
        },
        my_posts_on_this_context => {
            label => 'My Pages',
            items => sub {
                [ { type => 'current_user' }, { type => 'current_context' } ]
                ,;
            },
            order => 500,
        },
    };
}

sub class_label {
    return MT->translate("Page");
}

sub class_label_plural {
    MT->translate("Pages");
}

sub container_label {
    MT->translate("Folder");
}

sub container_type {
    return "folder";
}

sub folder {
    return $_[0]->category;
}

sub archive_file {
    my $page = shift;
    my $blog = $page->blog()
        || return $page->error(
        MT->translate( "Loading blog failed: [_1]", MT::Blog->errstr ) );
    return archive_file_for( $page, $blog, 'Page' );
}

sub archive_url {
    my $page = shift;
    my $blog = $page->blog()
        || return $page->error(
        MT->translate( "Loading blog failed: [_1]", MT::Blog->errstr ) );
    my $file = $page->archive_file(@_) or return;
    my $url = $blog->site_url || "";
    MT::Util::caturl( $url, $file );
}

sub permalink {
    my $page = shift;
    return $page->archive_url(@_);
}

sub all_permalinks {
    my $page = shift;
    return ( $page->permalink(@_) );
}

sub status_text {
    my $page = shift;
    $page->SUPER::status_text(@_);
}

sub status_int {
    my $page = shift;
    $page->SUPER::status_int(@_);
}

1;
__END__

=head1 NAME

MT::Page - Movable Type page record

=head1 SYNOPSIS

    use MT::Page;
    my $page = MT::Page->new;
    $page->blog_id($blog->id);
    $page->author_id($author->id);
    $page->title('Page title');
    $page->text('Some text');
    $page->save
        or die $page->errstr;

=head1 DESCRIPTION

The C<MT::Page> class is a subclass of L<MT::Entry>. Pages are very similar
to entries, except that they are not published in a reverse-chronological
listing, typically. Pages are published into folders, represented by
L<MT::Folder> instead of categories.

=head2 MT::Page->class_label

Returns the localized descriptive name for this class.

=head2 MT::Page->class_label_plural

Returns the localized, plural descriptive name for this class.

=head2 MT::Page->container_label

Returns the localized phrase identifying the "container" type for
pages (ie: "Folder").

=head2 MT::Page->container_type

Returns the string "folder", which is the MT type identifier for
the L<MT::Folder> class.

=head2 MT::Page->list_props

Returns the list_properties registry of this class.

=head2 MT::Page->system_filters

Returns the system_filters registry of this class.

=head2 $page->folder

Returns the L<MT::Folder> the page is assigned to.

=head2 $page->archive_file

Returns the filename for the published page.

=head2 $page->archive_url

Returns the permalink for the page, based on the site_url of the
blog, and folder assignment for the page.

=head2 $page->permalink

Returns the permalink for the page.

=head2 $page->all_permalinks

Returns the permalink for the page.

=cut
