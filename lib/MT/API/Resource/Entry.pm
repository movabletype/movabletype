package MT::API::Resource::Entry;

use strict;
use warnings;

use boolean ();

sub updatable_fields {
    [   qw(
            status
            allowComments
            allowTrackbacks
            title
            body
            more
            excerpt
            keywords
            basename
            date
            tags
            customFields
            )
    ];
}

sub fields {
    [   {   name        => 'author',
            from_object => sub {
                my ( $app, $obj ) = @_;
                $app->convert_object( $obj->author );
            },
        },
        {   name        => 'blog',
            from_object => sub {
                my ( $app, $obj ) = @_;
                $app->convert_object( $obj->blog );
            },
        },
        {   name        => 'categories',
            from_object => sub {
                my ( $app, $obj ) = @_;
                my $rows = $obj->__load_category_data or return;

                my $primary = do {
                    my @rows = grep { $_->[1] } @$rows;
                    @rows ? $rows[0]->[0] : 0;
                };

                my $cats = MT::Category->lookup_multi(
                    [ map { $_->[0] } @$rows ] );
                $app->convert_object(
                    [   sort {
                                  $a->id == $primary ? 1
                                : $b->id == $primary ? -1
                                : $a->label cmp $b->label
                            } @$cats
                    ]
                );
            },
        },
        'id',
        'class',
        {   name        => 'status',
            from_object => sub {
                my ( $app, $obj ) = @_;
                MT::Entry::status_text( $obj->status );
            },
            to_object => sub {
                my ( $app, $hash ) = @_;
                MT::Entry::status_int( $hash->{status} );
            },
        },
        {   name        => 'allowComments',
            alias       => 'allow_comments',
            from_object => sub {
                my ( $app, $obj ) = @_;

                # TODO ok?
                $obj->allow_comments ? boolean::true() : boolean::false();
            },
            to_object => sub {
                my ( $app, $hash ) = @_;
                $hash->{allowComments} ? 1 : 0;
            },
        },
        {   name        => 'allowTrackbacks',
            alias       => 'allow_pings',
            from_object => sub {
                my ( $app, $obj ) = @_;

                # TODO ok?
                $obj->allow_pings ? boolean::true() : boolean::false();
            },
            to_object => sub {
                my ( $app, $hash ) = @_;
                $hash->{allowTrackbacks} ? 1 : 0;
            },
        },
        'title',
        {   name  => 'body',
            alias => 'text',
        },
        {   name  => 'more',
            alias => 'text_more',
        },
        {   name  => 'commentCount',
            alias => 'comment_count',
        },
        {   name  => 'trackbackCount',
            alias => 'ping_count',
        },
        {   name        => 'comments',
            from_object => sub {
                my ( $app, $obj ) = @_;
                my $args = undef;
                if ( defined( $app->param('maxComments') ) ) {
                    $args = { limit => int( $app->param('maxComments') ), };
                }
                $app->convert_object( $obj->comments( undef, $args ) );
            },
        },
        {   name        => 'trackbacks',
            from_object => sub {
                my ( $app, $obj ) = @_;
                my $args = undef;
                if ( defined( $app->param('maxTrackbacks') ) ) {
                    $args = { limit => int( $app->param('maxTrackbacks') ), };
                }
                $app->convert_object( $obj->pings( undef, $args ) );
            },
        },
    ];
}

1;
