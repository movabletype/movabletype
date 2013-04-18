package MT::API::Resource::Entry;

use strict;
use warnings;

use boolean ();
use MT::API::Resource::Common;

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
    [   {   name => 'author',
            type => 'MT::API::Resource::DataType::Object',
        },
        {   name        => 'blog',
            from_object => sub {
                my ($obj) = @_;
                +{ id => $obj->blog_id, };
            },
        },
        {   name        => 'categories',
            from_object => sub {
                my ($obj) = @_;
                my $rows = $obj->__load_category_data or return;

                my $primary = do {
                    my @rows = grep { $_->[1] } @$rows;
                    @rows ? $rows[0]->[0] : 0;
                };

                my $cats = MT::Category->lookup_multi(
                    [ map { $_->[0] } @$rows ] );
                MT::API::Resource->from_object(
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
                my ($obj) = @_;
                MT::Entry::status_text( $obj->status );
            },
            to_object => sub {
                my ($hash) = @_;
                MT::Entry::status_int( $hash->{status} );
            },
        },
        {   name        => 'allowComments',
            alias       => 'allow_comments',
            from_object => sub {
                my ($obj) = @_;
                $obj->allow_comments ? boolean::true() : boolean::false();
            },
            to_object => sub {
                my ($hash) = @_;
                $hash->{allowComments} ? 1 : 0;
            },
        },
        {   name        => 'allowTrackbacks',
            alias       => 'allow_pings',
            from_object => sub {
                my ($obj) = @_;
                $obj->allow_pings ? boolean::true() : boolean::false();
            },
            to_object => sub {
                my ($hash) = @_;
                $hash->{allowTrackbacks} ? 1 : 0;
            },
        },
        {   name    => 'title',
            default => '',
        },
        {   name    => 'body',
            alias   => 'text',
            default => '',
        },
        {   name    => 'more',
            alias   => 'text_more',
            default => '',
        },
        {   name        => 'excerpt',
            from_object => sub {
                my ($obj) = @_;
                $obj->get_excerpt;
            },
        },
        {   name    => 'keywords',
            default => '',
        },
        'basename',
        'permalink',
        {   name  => 'pingsSentURL',
            alias => 'pinged_url_list',
        },
        {   name  => 'date',
            alias => 'authored_on',
            type  => 'MT::API::Resource::DataType::ISO8601',
        },
        {   name  => 'createdDate',
            alias => 'created_on',
            type  => 'MT::API::Resource::DataType::ISO8601',
        },
        {   name  => 'modifiedDate',
            alias => 'modified_on',
            type  => 'MT::API::Resource::DataType::ISO8601',
        },
        {   name  => 'commentCount',
            alias => 'comment_count',
        },
        {   name  => 'trackbackCount',
            alias => 'ping_count',
        },
        {   name        => 'comments',
            from_object => sub {
                my ($obj) = @_;
                my $app   = MT->instance;
                my $args  = undef;
                if ( $app->can('param')
                    && defined( $app->param('maxComments') ) )
                {
                    $args = { limit => int( $app->param('maxComments') ), };
                }
                MT::API::Resource->from_object(
                    $obj->comments( undef, $args ) );
            },
        },
        {   name        => 'trackbacks',
            from_object => sub {
                my ($obj) = @_;
                my $app   = MT->instance;
                my $args  = undef;
                if ( $app->can('param')
                    && defined( $app->param('maxTrackbacks') ) )
                {
                    $args = { limit => int( $app->param('maxTrackbacks') ), };
                }
                MT::API::Resource->from_object( $obj->pings( undef, $args )
                        || [] );
            },
        },
        {   name        => 'assets',
            from_object => sub {
                my ($obj) = @_;
                MT::API::Resource->from_object( $obj->assets );
            },
        },
        $MT::API::Resource::Common::fields{tags},
    ];
}

1;
