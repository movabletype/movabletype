# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::Theme::Entry;
use strict;
use MT;
use MT::Entry;

sub import_pages {
    my ( $element, $theme, $obj_to_apply ) = @_;
    my $entries = $element->{data};
    _add_entries( $theme, $obj_to_apply, $entries, 'page' )
        or die "Failed to create theme default Pages";
    return 1;
}

sub _add_entries {
    my ( $theme, $blog, $entries, $class ) = @_;
    my $app = MT->instance;
    my @text_fields = qw(
        title   text     text_more
        excerpt keywords
    );
    for my $basename ( keys %$entries ) {
        my $entry = $entries->{$basename};
        next if MT->model($class)->count({
            basename => $basename,
            blog_id  => $blog->id,
        });
        next if MT->model($class)->count({
            title => $entry->{title},
            blog_id  => $blog->id,
        });
        my $obj = MT->model($class)->new();
        my $current_lang = MT->current_language;
        MT->set_language($blog->language);
        $obj->set_values({
            map { $_ => $theme->translate_templatized( $entry->{$_} ) }
            grep { exists $entry->{$_} }
            @text_fields
        });
        MT->set_language( $current_lang );

        $obj->basename( $basename );
        $obj->blog_id( $blog->id );
        $obj->author_id( $app->user->id );
        $obj->status(
            exists $entry->{status} ? $entry->{status} : MT::Entry::RELEASE()
        );
        if ( my $tags = $entry->{tags} ) {
            my @tags = ref $tags ? @$tags : split( /\s*\,\s*/, $tags );
            $obj->set_tags( @tags );
        }

        $obj->save or die $obj->errstr;

        my $path_str;
        if ( $class eq 'page' && ($path_str = $entry->{folder}) ) {
            my @paths = split( '/', $path_str );
            my ($current, $parent);
            PATH: while ( my $path = shift @paths ) {
                my $terms = {
                    blog_id  => $blog->id,
                    basename => $path,
                };
                $terms->{parent} = $parent->id if $parent;
                $current = MT->model('folder')->load($terms);
                if ( !$current ) {
                    unshift @paths, $path;
                    while ( my $new = shift @paths ) {
                        my $f = MT->model('folder')->new();
                        $f->set_values({
                            blog_id   => $blog->id,
                            author_id => $app->user->id,
                            label     => $new,
                            basename  => $new,
                        });
                        $f->parent( $parent->id ) if $parent;
                        $f->save;
                        $parent = $f;
                    }
                    last PATH;
                }
                $parent = $current;
            }
            my $place = MT->model('placement')->new;
            $place->set_values({
                blog_id     => $blog->id,
                entry_id    => $obj->id,
                category_id => $parent->id,
                is_primary  => 1,
            });
            $place->save;
        }
    }
    1;
}

sub info_pages {
    my ( $element, $theme, $blog ) = @_;
    my $data = $element->{data};

    return sub {
        MT->translate( '[_1] pages', scalar keys %{$element->{data}} );
    };
}

1;

