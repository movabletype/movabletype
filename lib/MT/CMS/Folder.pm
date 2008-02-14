package MT::CMS::Folder;

use strict;

sub edit {
    require MT::CMS::Category;
    return MT::CMS::Category::edit(@_);
}

sub can_view {
    my ( $eh, $app, $id ) = @_;
    my $perms = $app->permissions;
    return $perms->can_manage_pages();
}

sub can_save {
    my ( $eh, $app, $id ) = @_;
    my $perms = $app->permissions;
    return $perms->can_manage_pages();
}

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    return 1 if $app->user->is_superuser();
    my $perms = $app->permissions;
    return $perms && $perms->can_manage_pages();
}

sub pre_save {
    my $eh = shift;
    my ( $app, $obj ) = @_;
    my $pkg      = $app->model('folder');
    my @siblings = $pkg->load(
        {
            parent  => $obj->parent,
            blog_id => $obj->blog_id
        }
    );
    foreach (@siblings) {
        next if $obj->id && ( $_->id == $obj->id );
        return $eh->error(
            $app->translate(
"The folder '[_1]' conflicts with another folder. Folders with the same parent must have unique basenames.",
                $_->label
            )
        ) if $_->basename eq $obj->basename;
    }
    1;
}

sub post_save {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;

    if ( !$original->id ) {
        $app->log(
            {
                message => $app->translate(
                    "Folder '[_1]' created by '[_2]'", $obj->label,
                    $app->user->name
                ),
                level    => MT::Log::INFO(),
                class    => 'folder',
                category => 'new',
            }
        );
    }
    1;
}

sub save_filter {
    my $eh = shift;
    my ($app) = @_;
    return $app->errtrans( "The name '[_1]' is too long!",
        $app->param('label') )
      if ( length( $app->param('label') ) > 100 );
    return 1;
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {
            message => $app->translate(
                "Folder '[_1]' (ID:[_2]) deleted by '[_3]'",
                $obj->label, $obj->id, $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'delete'
        }
    );
}

1;
