# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Template::Tags::Folder;

use strict;
use warnings;

use MT;
use MT::Template::Tags::Category;

###########################################################################

=head2 IfFolder

A conditional tag used to test for the folder assignment for the page
in context, or generically to test for which folder is in context.

B<Attributes:>

=over 4

=item * name (or label; optional)

The name of a folder. If given, tests the folder in context (or
folder of an entry in context) to see if it matches with the given
folder name.

=back

B<Example:>

    <mt:IfFolder name="News">
        (current page in context is in the "News" folder)
    </mt:IfFolder>

=for tags pages, folders

=cut

sub _hdlr_if_folder {
    my ( $ctx, $args, $cond ) = @_;
    my $e = $ctx->stash('entry');
    return undef if ( $e && !defined $e->category );
    return $ctx->invoke_handler( 'ifcategory', $args, $cond );
}

###########################################################################

=head2 FolderHeader

The contents of this container tag will be displayed when the first
folder listed by a L<Folders> tag is reached.

=cut

sub _hdlr_folder_header {
    return undef unless &_check_folder(@_);
    my ($ctx) = @_;
    $ctx->stash('folder_header');
}

###########################################################################

=head2 FolderFooter

The contents of this container tag will be displayed when the last
folder listed by a L<Folders> tag is reached.

=for tags folders

=cut

sub _hdlr_folder_footer {
    return undef unless &_check_folder(@_);
    my ($ctx) = @_;
    $ctx->stash('folder_footer');
}

###########################################################################

=head2 HasSubFolders

Returns true if the current folder has a sub-folder.

=for tags folders

=cut

sub _hdlr_has_sub_folders {
    MT::Template::Tags::Category::_hdlr_has_sub_categories(@_);
}

###########################################################################

=head2 HasNoSubFolders

Returns true if the current category has no sub-folders.

=for tags folders

=cut

sub _hdlr_has_no_sub_folders {
    !&_hdlr_has_sub_folders;
}

###########################################################################

=head2 HasParentFolder

Returns true if the current folder has a parent folder other than the
root.

=for tags folders

=cut

sub _hdlr_has_parent_folder {
    MT::Template::Tags::Category::_hdlr_has_parent_category(@_);
}

sub _check_folder {
    return MT::Template::Tags::Category::_get_category_context(@_);
}

###########################################################################

=head2 HasNoParentFolder

Returns true if the current folder does not have a parent folder
other than the root.

B<Example:>

    <mt:Folders>
      <mt:HasNoParentFolder>
        <mt:FolderLabel> is but an orphan and has no parents.
      <mt:else>
        <mt:FolderLabel> has a parent folder!
      </mt:HasNoParentFolder>
    </mt:Folders>

=for tags folders

=cut

sub _hdlr_has_no_parent_folder {
    return !&_hdlr_has_parent_folder;
}

###########################################################################

=head2 PageFolder

A container tag which holds folder context relating to the page.

=for tags pages, folders

=cut

sub _hdlr_page_folder {
    my ( $ctx, $args, $cond ) = @_;

    return undef unless $ctx->check_page;
    require MT::Page;
    $args->{class_type} = MT::Page->properties->{class_type};
    local $ctx->{inside_mt_categories} = 1;
    $ctx->invoke_handler( 'entrycategories', $args, $cond );
}

###########################################################################

=head2 Folders

A container tags which iterates over a list of all folders and subfolders.

B<Attributes:>

=over 4

=item * show_empty

Setting this optional attribute to true (1) will include folders with no
pages assigned. The default is false (0), where only folders with pages
assigned.

=back

=for tags folders

=cut

sub _hdlr_folders {
    my ( $ctx, $args, $cond ) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    local $args->{category_set_id};
    local $ctx->{__stash}{category_set};
    $ctx->invoke_handler( 'categories', $args, $cond );
}

###########################################################################

=head2 FolderPrevious

A container tag which creates a folder context of the previous folder
relative to the current page folder or archived folder.

=for tags folders, archives

=cut

###########################################################################

=head2 FolderNext

A container tag which creates a folder context of the next folder
relative to the current page folder or archived folder.

=for tags folders, archives

=cut

sub _hdlr_folder_prevnext {
    my ( $ctx, $args, $cond ) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    require MT::Template::Tags::Category;
    MT::Template::Tags::Category::_hdlr_category_prevnext( $ctx, $args,
        $cond );

}

###########################################################################

=head2 SubFolders

A specialized version of the L<Folders> container tag that respects
the hierarchical structure of folders.

B<Attributes:>

=over 4

=item * include_current

An optional boolean attribute that controls the inclusion of the
current folder in the list.

=item * sort_method

An optional and advanced usage attribute. A fully qualified Perl method
name to be used to sort the folders.

=item * sort_order

Specifies the sort order of the folder labels. Recognized values
are "ascend" and "descend." The default is "ascend." This attribute
is ignored if C<sort_method> is unspecified.

=item * top

If set to 1, displays only top level folders. Same as using
L<TopLevelFolders>.

=back

=for tags folders

=cut

sub _hdlr_sub_folders {
    my ( $ctx, $args, $cond ) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    local $args->{category_set_id};
    local $ctx->{__stash}{category_set};
    $ctx->invoke_handler( 'subcategories', $args, $cond );
}

###########################################################################

=head2 ParentFolders

A block tag that lists all the ancestors of the current folder.

B<Attributes:>

=over 4

=item * glue

This optional attribute is a shortcut for connecting each folder label
with its value. Single and double quotes are not permitted in the string.

=item * exclude_current

This optional boolean attribute controls the exclusion of the current
folder in the list.

=back

=for tags folders

=cut

sub _hdlr_parent_folders {
    my ( $ctx, $args, $cond ) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    $ctx->invoke_handler( 'parentcategories', $args, $cond );
}

###########################################################################

=head2 ParentFolder

A container tag that creates a context to the current folder's parent.

B<Example:>

    <mt:ParentFolder>
        Up: <a href="<mt:ArchiveLink>"><mt:FolderLabel></a>
    </mt:ParentFolder>

=for tags folders

=cut

sub _hdlr_parent_folder {
    my ( $ctx, $args, $cond ) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    $ctx->invoke_handler( 'parentcategory', $args, $cond );
}

###########################################################################

=head2 TopLevelFolders

A block tag listing the folders that do not have a parent and exist at "the
top" of the folder hierarchy. Same as using C<E<lt>mt:SubFolders top="1"E<gt>>.

B<Example:>

    <mt:TopLevelFolders>
        <!-- do something -->
    </mt:TopLevelFolders>

=cut

sub _hdlr_top_level_folders {
    my ( $ctx, $args, $cond ) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    local $args->{category_set_id};
    local $ctx->{__stash}{category_set};
    $ctx->invoke_handler( 'toplevelcategories', $args, $cond );
}

###########################################################################

=head2 TopLevelFolder

A container tag that creates a context to the top-level ancestor of
the current folder.

=for tags folders

=cut

sub _hdlr_top_level_folder {
    my ( $ctx, $args, $cond ) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    $ctx->invoke_handler( 'toplevelparent', $args, $cond );
}

###########################################################################

=head2 FolderBasename

Produces the dirified basename defined for the folder in context.

B<Attributes:>

=over 4

=item * default

A value to use in the event that no folder is in context.

=item * separator

Valid values are "_" and "-", dash is the default value. Specifying
an underscore will convert any dashes to underscores. Specifying a
dash will convert any underscores to dashes.

=back

B<Example:>

    <$mt:FolderBasename$>

=for tags folders

=cut

sub _hdlr_folder_basename {
    shift->invoke_handler( 'categorybasename', @_ );
}

###########################################################################

=head2 FolderDescription

The description for the folder in context.

B<Example:>

    <$mt:FolderDescription$>

=for tags folders

=cut

sub _hdlr_folder_description {
    shift->invoke_handler( 'categorydescription', @_ );
}

###########################################################################

=head2 FolderID

The numeric system ID of the folder.

B<Example:>

    <$mt:FolderID$>

=for tags folders

=cut

sub _hdlr_folder_id {
    shift->invoke_handler( 'categoryid', @_ );
}

###########################################################################

=head2 FolderLabel

The label of the folder in context.

B<Example:>

    <$mt:FolderLabel$>

=for tags folders

=cut

sub _hdlr_folder_label {
    shift->invoke_handler( 'categorylabel', @_ );
}

###########################################################################

=head2 FolderCount

The number published pages in the folder.

B<Example:>

    <$mt:FolderCount$>

=for tags folders, pages

=cut

sub _hdlr_folder_count {
    shift->invoke_handler( 'categorycount', @_ );
}

###########################################################################

=head2 FolderPath

The path to the folder, relative to the L<BlogURL>.

B<Attributes:>

=item * separator

Valid values are "_" and "-", dash is the default value. Specifying an
underscore will convert any dashes to underscores. Specifying a dash will
convert any underscores to dashes.

=back


B<Example:>

For the folder "Bar" in a folder "Foo" C<E<lt>$mt:FolderPath$E<gt>>
becomes foo/bar.

=for tags folders

=cut

sub _hdlr_folder_path {
    shift->invoke_handler( 'subcategorypath', @_ );
}

###########################################################################

=head2 SubFolderRecurse

Recursively call the L<SubFolders> or L<TopLevelFolders> container
with the subfolders of the folder in context. This tag, when placed at the
end of loop controlled by one of the tags above will cause them to
recursively descend into any subfolders that exist during the loop.

B<Attributes:>

=over 4

=item * max_depth (optional)

Specifies the maximum number of times the system should recurse. The default
is infinite depth.

=back

B<Examples:>

The following code prints out a recursive list of folders/subfolders, linking
those with entries assigned to their folder archive pages.

    <mt:TopLevelFolders>
      <mt:SubFolderIsFirst><ul></mt:SubFolderIsFirst>
        <mt:If tag="FolderCount">
            <li><a href="<$mt:FolderArchiveLink$>"
            title="<$mt:FolderDescription$>"><$mt:FolderLabel$></a>
        <mt:Else>
            <li><$mt:FolderLabel$>
        </mt:If>
        <$mt:SubFolderRecurse$>
        </li>
    <mt:SubFolderIsLast></ul></mt:SubFolderIsLast>
    </mt:TopLevelFolders>

Or more simply:

    <mt:TopLevelFolders>
        <$mt:FolderLabel$>
        <$mt:SubFolderRecurse$>
    </mt:TopLevelFolders>

=for tags folders

=cut

sub _hdlr_sub_folder_recurse {
    my ( $ctx, $args, $cond ) = @_;

    require MT::Folder;
    $args->{class_type} = MT::Folder->properties->{class_type};
    $ctx->invoke_handler( 'subcatsrecurse', $args, $cond );
}

1;
