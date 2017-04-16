package ContentType::Feed;
use strict;
use warnings;

use MT::Blog;
use MT::Entry;
use MT::ContentType;
use MT::Permission;

sub feed_content_data {
    my ( $cb, $app, $view, $feed ) = @_;

    my $user = $app->user;

    my $blog;

    # verify user has permission to view content data for given site
    my $blog_id = $app->param('blog_id');
    if ($blog_id) {
        if ( !$user->is_superuser ) {
            my $perm = MT::Permission->load(
                { author_id => $user->id, blog_id => $blog_id } );
            return $cb->error( $app->translate("No permissions.") )
                unless ( $perm && $perm->can_do("get_${view}_feed") )
                ;    # TODO: fix permission
        }

        $blog = MT::Blog->load($blog_id) or return;
    }
    else {
        if ( !$user->is_superuser ) {

       # limit activity log view to only weblogs this user has permissions for
            my @perms = MT::Permission->load( { author_id => $user->id } );
            return $cb->error( $app->translate("No permissions.") )
                unless @perms;
            my @blog_list = map { $_->blog_id }
                grep { $_->can_do("get_${view}_feed") }
                @perms;    # TODO: fix permission
            $blog_id = join ',', @blog_list;
        }
    }

    my ($content_type_id) = $view =~ /content_data_(\d+)/;
    my $content_type = MT::ContentType->load($content_type_id);

    my $link = $app->base
        . $app->mt_uri(
        mode => 'list',
        args => {
            '_type' => $view,
            ( $blog ? ( blog_id => $blog_id ) : () )
        }
        );
    my $param = {
        feed_link  => $link,
        feed_title => $blog
        ? $app->translate( '[_1] "[_2]" Content Data',
            $blog->name, $content_type->name )
        : $app->translate( 'All "[_1]" Content Data', $content_type->name )
    };

    # user has permissions to view this type of feed... continue
    my $terms = $app->apply_log_filter(
        {   filter     => 'class',
            filter_val => $view,
            $blog_id ? ( blog_id => $blog_id ) : (),
        }
    );
    $$feed = $app->process_log_feed( $terms, $param );
}

sub filter_content_data {
    my ( $cb, $app, $item ) = @_;
    my $user = $app->user;
    my $view = $app->param('view');

    return 0 if !exists $item->{'log.cd.id'};

    my $content_data = MT->model('content_data')->load( $item->{'log.cd.id'} )
        or return 0;

    my $own  = $content_data->author_id == $user->id;
    my $perm = $user->permissions( $content_data->blog_id )
        or return 0;

    if (   !$app->can_do('get_all_system_feed')
        && !$perm->can_do('get_system_feed') )
    {
        return 0
            if !$own
            && !$perm->can_do("edit_all_${view}");    # TODO: fix permission
    }

    $item->{'log.cd.can_edit'}
        = $perm->can_edit_content_data( $content_data, $user,
        ( $content_data->status eq MT::Entry::RELEASE() ? 1 : () ) ) ? 1 : 0;

    # TODO: fix permission
    $item->{'log.cd.can_change_status'}
        = $perm->can_do("publish_all_${view}") ? 1
        : $own && $perm->can_do("publish_own_${view}") ? 1
        :                                                0;

    return 1;
}

1;

