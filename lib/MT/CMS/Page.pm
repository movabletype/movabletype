package MT::CMS::Page;

use strict;
use MT::CMS::Entry;

sub edit {
    require MT::CMS::Entry;
    MT::CMS::Entry::edit(@_);
}
sub list {
    my $app = shift;
    $app->param( 'type', 'page' );
    return $app->forward('list_entry', { type => 'page' } );
}

sub save_pages {
    my $app = shift;
    return $app->forward('save_entries');
}

sub can_view {
    my ( $eh, $app, $id, $objp ) = @_;
    my $perms = $app->permissions;
    if ( !$perms->can_manage_pages ) {
        return 0;
    }
    1;
}

sub can_save {
    my ( $eh, $app, $id ) = @_;
    unless ( ref $id ) {
        $id = MT->model('page')->load($id)
            or return;
    }
    return unless $id->isa('MT::Page');

    my $author = $app->user;
    return $author->permissions($id->blog_id)->can_manage_pages;
}

sub can_delete {
    my ( $eh, $app, $id ) = @_;
    unless ( ref $id ) {
        $id = MT->model('page')->load($id)
            or return;
    }
    return unless $id->isa('MT::Page');

    my $author = $app->user;
    return $author->permissions($id->blog_id)->can_manage_pages;
}

sub pre_save {
    require MT::CMS::Entry;
    MT::CMS::Entry::pre_save(@_);
}

sub CMSPostSave_page {
    require MT::CMS::Entry;
    MT::CMS::Entry::post_save(@_);
}

1;
