# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Theme::CategorySet;
use strict;
use warnings;

use MT;
use MT::CategorySet;
use MT::Theme::Common
    qw( add_categories build_category_tree generate_order get_ordered_basenames );

sub apply {
    my ( $element, $theme, $blog, $opts ) = @_;
    my $category_sets = $element->{data} || {};

    my $current_lang = MT->current_language;

    for my $cs_key ( keys %{$category_sets} ) {
        my $cs_value = $category_sets->{$cs_key};

        MT->set_language( $blog->language );

        my %terms = (
            name => defined( $cs_value->{name} )
            ? $theme->translate_templatized( $cs_value->{name} )
            : $cs_key,
            blog_id => $blog->id,
        );

        if ( MT::CategorySet->exist( \%terms ) ) {
            MT->set_language($current_lang);
            next;
        }

        my $cs = MT::CategorySet->new(%terms);

        MT->set_language($current_lang);

        $cs->save or die $cs->errstr;

        my $categories = $cs_value->{categories} || {};
        add_categories( $theme, $blog, $categories, 'category', $cs->id );

        my $order = generate_order(
            {   basenames => $cs_value->{categories}{':order'},
                terms     => {
                    class           => 'category',
                    category_set_id => $cs->id,
                },
            }
        );
        $cs->order($order) if $order;

        $cs->save or die $cs->errstr;    # calculate category count
    }

    1;
}

sub info {
    my ( $element, $theme, $blog ) = @_;
    my $category_set_count = scalar %{ $element->{data} };
    sub {
        MT->translate( '[_1] category sets.', $category_set_count );
    };
}

sub template {
    my $app = shift;
    my ( $blog, $saved ) = @_;

    my @category_sets
        = MT->model('category_set')->load( { blog_id => $blog->id } )
        or return;

    my %checked_ids
        = $saved
        ? map { $_ => 1 } @{ $saved->{default_category_set_export_ids} }
        : ();

    my $cat_count = MT->model('category_set')->cat_count_by_blog($blog->id);
    my @list;
    for my $cs (@category_sets) {
        push @list,
            {
            category_set_id   => $cs->id,
            category_set_name => $cs->name,
            categories_count  => $cat_count->{ $cs->id } || 0,
            checked           => $saved ? $checked_ids{ $cs->id } : 1,
            };
    }

    my %param = ( category_sets => \@list );
    return $app->load_tmpl( 'include/theme_exporters/category_set.tmpl',
        \%param );
}

sub export {
    my ( $app, $blog, $settings ) = @_;
    my $terms
        = defined $settings
        ? { id => $settings->{default_category_set_export_ids} }
        : { blog_id => $blog->id };
    my @category_sets = MT->model('category_set')->load($terms);
    my %data;
    for my $cs (@category_sets) {
        my @cats = @{ $cs->categories };

        $data{ $cs->name } = {
            categories =>
                { ':order' => get_ordered_basenames( \@cats, $cs->order ) },
            name => $cs->name,
        };

        my @tops = grep { !$_->parent } @cats;
        for my $top (@tops) {
            $data{ $cs->name }{categories}{ $top->basename }
                = build_category_tree( \@cats, $top );
        }
    }
    %data ? \%data : undef;
}

sub condition {
    my ($blog) = @_;
    MT->model('category_set')->exist( { blog_id => $blog->id } );
}

1;
