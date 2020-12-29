# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Callback::Asset;

use strict;
use warnings;

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;
    if ( !$app->param('relatedAssets') ) {
        $load_options->{terms}{parent} = [ \'IS NULL', 0, '' ];
    }
    $load_options->{args}{no_class} = 1;
    return 1;
}

# TODO: Should merge with MT::CMS::Asset::pre_save?
sub pre_save {
    my ( $cb, $app, $obj ) = @_;

    # save normalized tags
    my @tags = $obj->tags;
    return 1 unless @tags;

    my $blog = $app->blog;
    my $fields
        = $blog
        ? $blog->smart_replace_fields
        : MT->config->NwcReplaceField;
    return 1 unless $fields && $fields =~ m/tags/ig;

    require MT::App::CMS;
    @tags = map { MT::App::CMS::_convert_word_chars( $app, $_ ) } @tags;

    if (@tags) {
        $obj->set_tags(@tags);
    }
    else {
        $obj->remove_tags();
    }

    return 1;
}

1;

__END__

=head1 NAME

MT::DataAPI::Callback::Asset - Movable Type class for Data API's callbacks about the MT::Asset.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
