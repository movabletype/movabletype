# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Theme::CategorySet;
use strict;
use warnings;

use MT;
use MT::CategorySet;
use MT::Theme::Common qw( add_categories );

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

1;
