# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::PSGI::ServeStatic;

use strict;
use warnings;
use parent qw(Plack::App::Directory);

# adapted from Plack::App::File::locate_file
sub locate_file {
    my ($self, $env) = @_;

    my $path = $env->{PATH_INFO} || '';

    if ($path =~ /\0/) {
        return $self->return_400;
    }

    my @path = split /[\\\/]/, $path, -1; # -1 *MUST* be here to avoid security issues!
    if (@path) {
        shift @path if $path[0] eq '';
    } else {
        @path = ('.');
    }

    if (grep /^\.{2,}$/, @path) {
        return $self->return_403;
    }

    my @docroots = ref $self->root ? @{$self->root} : $self->root;
    @docroots = ('.') unless @docroots;

    my ($file, @path_info);
    my @path_copy = @path;
LOOP:
    for my $docroot (@docroots) {
        @path_info = ();
        @path = @path_copy unless @path;
        while (@path) {
            my $try = File::Spec::Unix->catfile($docroot, @path);
            if ($self->should_handle($try)) {
                $file = $try;
                last LOOP;
            } elsif (!$self->allow_path_info) {
                last;
            }
            unshift @path_info, pop @path;
        }
    }

    if (!$file) {
        return $self->return_404;
    }

    if (!-r $file) {
        return $self->return_403;
    }

    return $file, join("/", "", @path_info);
}

1;
