# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::Revision;

use strict;
use warnings;
use MT::Util qw(format_ts);

sub js_save_rev {
    my $app = shift;
    $app->validate_magic or return;

    my $user  = $app->user;
    my $perms = $app->permissions
        or return $app->permission_denied();

    $app->validate_param({
        'id'            => [qw/ID/],
        'rev_number'    => [qw/INT/],
        'revision-note' => [qw/TEXT/],
    }) or return $app->json_error($app->translate('Invalid request.'), 400);

    my $param = $app->param;
    my $type  = $param->param('_type');
    my $class = $app->model($type);

    return $app->json_error($app->translate('Invalid request.'), 200)
        unless $class->isa('MT::Revisable');

    my $id     = $param->param('id');
    my $rn     = $param->param('r');
    my $obj_ds = $class->datasource;
    my $id_col = $obj_ds . '_id';
    my $obj    = $class->load({ id => $id })
        or return $app->json_error($app->translate('Invalid request.'), 200);

    if ($type eq 'entry') {
        return $app->permission_denied()
            unless $perms->can_edit_entry($obj, $user);
    } elsif ($type eq 'content_data') {
        return $app->permission_denied()
            unless $perms->can_edit_content_data($obj, $user);
    }

    my $rev = $class->revision_pkg->load({ $id_col => $id, rev_number => $rn })
        or return $app->json_error($app->translate('Invalid request.'), 200);

    my $old = $rev->description // '';
    my $new = $param->param('revision-note');
    $rev->description($new);
    $rev->save or die $rev->errstr;

    my $ts_formatted = format_ts('%Y-%m-%d %H:%M:%S', $rev->created_on, $obj->blog, $user->preferred_language);
    my $message      = $app->translate(
        "[_1] (ID:[_2])'s change note ([_3]) edited by user '[_4]'",
        $class->class_label, $obj->id, $ts_formatted, $user->name
    );
    $app->log({
        message  => $message,
        level    => MT::Log::NOTICE(),
        class    => $class->revision_pkg,
        category => 'edit',
        metadata => $new,
    });

    return $app->json_result({ success => 1 });
}

1;
