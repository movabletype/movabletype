# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::Trackback;

use strict;
use warnings;

use MT::DataAPI::Resource::Common;

sub updatable_fields {
    [   qw(
            status
            )
    ];
}

sub _parents {
    my ( $objs, $hashs, $f, $stash ) = @_;

    return $stash->{parents} if exists $stash->{parents};

    my %parents = ();
    my @parent_ids = grep {$_} map { $_->tb_id } @$objs;
    my @parents
        = @parent_ids
        ? MT->model('trackback')->load( { id => \@parent_ids, } )
        : ();
    $parents{ $_->id } = $_ for @parents;

    $stash->{parents} = \%parents;
}

sub _entries {
    my ( $objs, $hashs, $f, $stash ) = @_;

    return $stash->{entries} if exists $stash->{entries};

    my $parents = _parents(@_);

    my %entries = ();
    my @entry_ids = grep {$_} map { $_->entry_id } values %$parents;
    my @entries
        = @entry_ids
        ? MT->model('entry')->load( { id => \@entry_ids, } )
        : ();
    my %entry_map = ();
    $entry_map{ $_->id } = $_ for @entries;

    for my $o (@$objs) {
        my $p = $parents->{ $o->id }
            or next;
        my $e = $entry_map{ $p->entry_id }
            or next;
        $entries{ $o->id } = $e;
    }

    $stash->{entries} = \%entries;
}

sub _categories {
    my ( $objs, $hashs, $f, $stash ) = @_;

    return $stash->{categories} if exists $stash->{categories};

    my $parents = _parents(@_);

    my %categories = ();
    my @category_ids = grep {$_} map { $_->category_id } values %$parents;
    my @categories
        = @category_ids
        ? MT->model('category')->load( { id => \@category_ids, } )
        : ();
    my %category_map = ();
    $category_map{ $_->id } = $_ for @categories;

    for my $o (@$objs) {
        my $p = $parents->{ $o->id }
            or next;
        my $e = $category_map{ $p->category_id }
            or next;
        $categories{ $o->id } = $e;
    }

    $stash->{categories} = \%categories;
}

sub fields {
    [   $MT::DataAPI::Resource::Common::fields{blog},
        {   name             => 'entry',
            bulk_from_object => sub {
                my ( $objs, $hashs, $f, $stash ) = @_;
                my $parents = _parents(@_);

                my $size = scalar(@$objs);
                for ( my $i = 0; $i < $size; $i++ ) {
                    my $p = $parents->{ $objs->[$i]->tb_id } || undef;

                    $hashs->[$i]{entry} = $p
                        && $p->entry_id ? +{ id => $p->entry_id } : undef;
                }
            },
        },
        {   name => 'id',
            type => 'MT::DataAPI::Resource::DataType::Integer',
        },
        {   name  => 'date',
            alias => 'created_on',
            type  => 'MT::DataAPI::Resource::DataType::ISO8601',
        },
        'title',
        'excerpt',
        'blogName',
        {   name  => 'url',
            alias => 'source_url',
        },
        'ip',
        $MT::DataAPI::Resource::Common::fields{status},
        {   name             => 'updatable',
            type             => 'MT::DataAPI::Resource::DataType::Boolean',
            bulk_from_object => sub {
                my ( $objs, $hashs, $f, $stash ) = @_;
                my $app  = MT->instance;
                my $user = $app->user;

                if ( $user->is_superuser ) {
                    $_->{updatable} = 1 for @$hashs;
                    return;
                }

                my %blog_perms = ();
                my $entries    = _entries(@_);
                my $categories = _categories(@_);

                for ( my $i = 0; $i < scalar @$objs; $i++ ) {
                    my $obj = $objs->[$i];

                    my ( $perms, $entry, $cat );
                    $perms = $blog_perms{ $obj->blog_id }
                        ||= $user->blog_perm( $obj->blog_id );
                    $entry = $entries->{ $obj->id };
                    $cat   = $categories->{ $obj->id };

                    $hashs->[$i]{updatable}
                        = $perms
                        && ( $entry || $cat )
                        && (
                        $cat
                        ? $perms->can_do(
                            'open_category_trackback_edit_screen')
                        : $user->id == $entry->author_id ? $perms->can_do(
                            'open_own_entry_trackback_edit_screen')
                        : $perms->can_do('open_all_trackback_edit_screen')
                        );
                }
            },
        }
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::Trackback - Movable Type class for resources definitions of the MT::TBPing.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
