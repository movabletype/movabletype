# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Util::Archive::TempFile;

use strict;
use warnings;
use File::Temp ();

use overload '""' => sub { shift->{file} }, fallback => 1;

# This is just for Win32 compatibility
# Use File::Temp directly if this hack is not necessary

sub new {
    my ($class, $pattern, $dir) = @_;

    $pattern ||= 'mt_temp_XXXX';
    $dir     ||= MT->config->TempDir;

    my $tmpfile = File::Temp::tempnam($dir, $pattern);

    bless { file => $tmpfile, pid => $$ }, $class;
}

sub DESTROY {
    my $self = shift;
    return unless $self->{pid} eq $$;
    return unless -e $self->{file};
    unlink $self->{file};
}

1;
