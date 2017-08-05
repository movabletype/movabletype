package MT::Theme::CategoryList;
use strict;
use warnings;

use MT;
use MT::CategoryList;
use MT::Theme::Common qw( add_categories );

sub apply {
    my ( $element, $theme, $blog, $opts ) = @_;
    my $category_lists = $element->{data} || {};

    my $current_lang = MT->current_language;

    for my $cl_key ( keys %{$category_lists} ) {
        my $cl_value = $category_lists->{$cl_key};

        MT->set_language( $blog->language );

        my %terms = (
            name => defined( $cl_value->{name} )
            ? $theme->translate_templatized( $cl_value->{name} )
            : $cl_key,
            blog_id => $blog->id,
        );

        if ( MT::CategoryList->exist( \%terms ) ) {
            MT->set_language($current_lang);
            next;
        }

        my $cl = MT::CategoryList->new(%terms);

        MT->set_language($current_lang);

        $cl->save or die $cl->errstr;

        my $categories = $cl_value->{categories} || {};
        add_categories( $theme, $blog, $categories, 'category', $cl->id );

        $cl->save or die $cl->errstr;    # calculate category count
    }

    1;
}

sub info {
    my ( $element, $theme, $blog ) = @_;
    my $category_list_count = scalar %{ $element->{data} };
    sub {
        MT->translate( '[_1] category lists.', $category_list_count );
    };
}

1;
