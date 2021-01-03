# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Upgrade::v1;

use strict;
use warnings;

sub upgrade_functions {
    return {

        # < 2.0
        'core_create_placements' => {
            version_limit => 2.0,
            priority      => 9.1,
            updater       => {
                type      => 'entry',
                label     => 'Creating entry category placements...',
                condition => sub { $_[0]->category_id },
                code      => sub {
                    require MT::Placement;
                    my $entry    = shift;
                    my $existing = MT::Placement->load(
                        {   entry_id    => $entry->id,
                            category_id => $entry->category_id
                        }
                    );
                    if ( !$existing ) {
                        my $place = MT::Placement->new;
                        $place->entry_id( $entry->id );
                        $place->blog_id( $entry->blog_id );
                        $place->category_id( $entry->category_id );
                        $place->is_primary(1);
                        $place->save;
                    }
                    $entry->category_id(0);
                },
            },
        },
        'core_create_template_maps' => {
            version_limit => 2.0,
            code          => \&core_create_template_maps,
            priority      => 9.1,
        },
    };
}

sub core_create_template_maps {
    my $self = shift;
    my (%param) = @_;

    my $offset = $param{offset};
    require MT::Template;
    require MT::TemplateMap;
    require MT::Blog;

    my $msg = $self->translate_escape("Creating template maps...");
    if ($offset) {
        my $count = MT::Template->count;
        return 1 unless $count;
        $self->progress( sprintf( "$msg (%d%%)", ( $offset / $count * 100 ) ),
            1 );
    }
    else {
        $self->progress( $msg, 1 );
    }

    my $iter = MT::Template->load_iter( undef,
        { offset => $offset, limit => $self->max_rows + 1 } );
    my $start    = time;
    my $continue = 0;
    my $count    = 0;
    while ( my $tmpl = $iter->() ) {
        $offset++;
        my $blog = MT::Blog->load( $tmpl->blog_id );
        my (@at);
        if ( $tmpl->type eq 'archive' ) {
            @at = qw( Daily Weekly Monthly );
        }
        elsif ( $tmpl->type eq 'category' ) {
            @at = ('Category');
        }
        elsif ( $tmpl->type eq 'page' ) {
            @at = ('Page');
        }
        elsif ( $tmpl->type eq 'individual' ) {
            @at = ('Individual');
        }
        else {
            next;
        }
        for my $at (@at) {
            my $meth      = 'archive_tmpl_' . lc($at);
            my $file_tmpl = $blog->$meth();
            my $existing  = MT::TemplateMap->load(
                {   blog_id      => $blog->id,
                    archive_type => $at,
                    template_id  => $tmpl->id
                }
            );
            if ( !$existing ) {
                my $map = MT::TemplateMap->new;
                if ($file_tmpl) {
                    $self->progress(
                        $self->translate_escape(
                            "Mapping template ID [_1] to [_2] ([_3]).",
                            $tmpl->id, $at, $file_tmpl
                        )
                    );
                    $map->file_template($file_tmpl);
                }
                else {
                    $self->progress(
                        $self->translate_escape(
                            "Mapping template ID [_1] to [_2].", $tmpl->id,
                            $at
                        )
                    );
                }
                $map->archive_type($at);
                $map->is_preferred(1);
                $map->template_id( $tmpl->id );
                $map->blog_id( $tmpl->blog_id );
                $map->save
                    or return $self->error(
                    $self->translate_escape(
                        "Error saving record: [_1].",
                        $map->errstr
                    )
                    );
            }
        }
        $count++;
        $continue = 1, last if $count == $self->max_rows;
        $continue = 1, last if time > $start + $self->max_time;
    }
    if ($continue) {
        $iter->end;
        return $offset;
    }
    else {
        $self->progress( "$msg (100%)", 1 );
    }
    1;
}

1;
