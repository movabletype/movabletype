# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Page;

use strict;
use base qw( MT::Entry );
use MT::Util qw( archive_file_for );

__PACKAGE__->install_properties({
    class_type => 'page',
    child_of => 'MT::Blog',
    child_classes => ['MT::Comment','MT::Placement','MT::Trackback','MT::FileInfo'],
});

# Callbacks: clean list of changed columns to only
# include versioned columns
MT->add_callback( 'api_pre_save.' . 'page', 1, undef, \&MT::Revisable::mt_presave_obj );
MT->add_callback( 'cms_pre_save.' . 'page', 1, undef, \&MT::Revisable::mt_presave_obj );

# Callbacks: object-level callbacks could not be 
# prioritized and thus caused problems with plugins
# registering a post_save and saving     
MT->add_callback( 'api_post_save.' . 'page', 9, undef, \&MT::Revisable::mt_postsave_obj );
MT->add_callback( 'cms_post_save.' . 'page', 9, undef, \&MT::Revisable::mt_postsave_obj );               

__PACKAGE__->add_callback( 'post_remove', 0, MT->component('core'), \&MT::Revisable::mt_postremove_obj );

sub list_props {
    return {
        id            => { base => 'entry.id' },
        text          => { base => 'entry.text' },
        text_more     => { base => 'entry.text_more' },
        title         => { base => 'entry.title' },
        authored_on   => { base => 'entry.authored_on' },
        status        => { base => 'entry.status' },
        created_on    => { base => 'entry.created_on' },
        modified_on   => { base => 'entry.modified_on' },
        basename      => { base => 'entry.basename' },
        comment_count => { base => 'entry.comment_count' },
        ping_count    => { base => 'entry.ping_count' },
        commented_on  => { base => 'entry.commented_on' },
        folder => {
            base => 'entry.category',
            label => 'Folder',
            category_class => 'folder',
            zero_state_label => '(root)',
        },
    };
}

sub system_filters {
    return {
        published => {
            label => 'Published Pages',
            items => [
                { type => 'status', args => { value => '2' }, },
            ],
        },
        draft => {
            label => 'Unpublished Pages',
            items => [
                { type => 'status', args => { value => '1' }, },
            ],
        },
        future => {
            label => 'Scheduled Pages',
            items => [
                { type => 'status', args => { value => '4' }, },
            ],
        },
        my_posts_on_this_context => {
            label => 'My Pages',
            items => sub {
                [ { type => 'current_user' }, { type => 'current_context' } ],
            },
        },
        commented_in_last_7_days => {
            label => 'Pages with comments in the last 7 days',
            items => [
                { type => 'commented_on', args => { option => 'days', days => 7 } }
            ],
        },
        _by_date => {
            label => sub {
                require MT::ListProperty;
                my $prop = MT::ListProperty->instance( 'entry', 'authored_on');
                return $prop->label_via_param( MT->app );
            },
            items => sub {
                require MT::ListProperty;
                my $prop = MT::ListProperty->instance( 'entry', 'authored_on');
                items => [{
                    type => 'authored_on',
                    args => $prop->args_via_param(MT->app),
                }],
            },
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
    my $blog = $page->blog() || return $page->error(MT->translate(
                                                     "Load of blog failed: [_1]",
                                                     MT::Blog->errstr));
    return archive_file_for($page, $blog, 'Page');
}

sub archive_url {
    my $page = shift;
    my $blog = $page->blog() || return $page->error(MT->translate(
                                                     "Load of blog failed: [_1]",
                                                     MT::Blog->errstr));
    my $url = $blog->site_url || "";
    $url .= '/' unless $url =~ m!/$!;
    return $url . $page->archive_file(@_);
}

sub permalink {
    my $page = shift;
    return $page->archive_url(@_);
}

sub all_permalinks {
    my $page = shift;
    return ($page->permalink(@_));
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
