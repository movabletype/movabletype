# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Template::Tags::CategorySet;

use strict;

###########################################################################

=head2 CategorySets

Produces a list of category sets defined for the current content type. 
When using in the contents type context, category sets defined
for the current content type is targeted.

=head4 Attributes

=over

=item * glue (optional)

If specified, this string is placed in between each result from the loop.

=item * id (optional)

If specified, selects a single category set matching the given category set ID.

    <mt:CategorySets id="10">

=item * content_type (optional)

If specified, selects category sets defined for the content type matching the given unique ID.

    <mt:CategorySets content_type="a0b1c2d3e4f5g6h7i8j9k0l1m2n3o4p5q6r7s8t9">

=cut

sub _hdlr_category_sets {
    my ( $ctx, $args, $cond ) = @_;

    my $blog         = $ctx->stash('blog');
    my $content_type = $ctx->stash('content_type');

    my @category_sets;
    if ( my $set_id = $args->{id} ) {
        my $category_set = MT->model('category_set')->load($set_id)
            or return $ctx->error(
            MT->translate('Category set was not found.') );
        push @category_sets, $category_set;
    }
    else {
        if ( my $unique_id = $args->{content_type} ) {
            if ( !$content_type
                || ( $content_type && $content_type->unique_id != $unique_id )
                )
            {
                ($content_type)
                    = MT->model('content_type')
                    ->load( { unique_id => $unique_id } )
                    or return $ctx->error(
                    MT->translate('Content Type was not found.') );
            }
        }
        if ($content_type) {
            my @set_ids;
            foreach my $f ( @{ $content_type->fields } ) {
                if ( $f->{type} eq 'categories' ) {
                    push @set_ids, $f->{options}{category_set};
                }
            }
            @category_sets
                = MT->model('category_set')->load( { id => [@set_ids] } )
                if @set_ids;
        }
        else {
            my $blog_id
                = $content_type ? $content_type->blog_id
                : $blog         ? $blog->id
                :                 '';
            @category_sets
                = MT->model('category_set')->load( { blog_id => $blog_id } )
                if $blog_id;
        }
    }

    my $res     = '';
    my $tok     = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');
    my $i       = 0;
    local $ctx->{__stash}{category_sets}
        = ( @category_sets && defined $category_sets[0] )
        ? \@category_sets
        : undef;
    my $glue = $args->{glue};
    my $vars = $ctx->{__stash}{vars} ||= {};

    for my $category_set (@category_sets) {
        local $vars->{__first__}       = !$i;
        local $vars->{__last__}        = !defined $category_sets[ $i + 1 ];
        local $vars->{__odd__}         = ( $i % 2 ) == 0;
        local $vars->{__even__}        = ( $i % 2 ) == 1;
        local $vars->{__counter__}     = $i + 1;
        local $ctx->{__stash}{blog}    = $blog;
        local $ctx->{__stash}{blog_id} = $blog->id;
        local $ctx->{__stash}{category_set} = $category_set;

        my $out = $builder->build( $ctx, $tok, $cond );
        return $ctx->error( $builder->errstr ) unless defined $out;
        $res .= $glue if defined $glue && $i && length($res) && length($out);
        $res .= $out;
        $i++;
    }

    $res;
}

1;
