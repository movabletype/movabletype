# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Template::Handler;
use strict;
use warnings;

sub EL_CODE  {0}
sub EL_TYPE  {1}
sub EL_SUPER {2}

sub new {
    my $class = shift;
    return bless [@_], $class;
}

sub code {
    my $handler = shift;
    return $handler->[ EL_CODE() ] = shift if @_;
    return $handler->[ EL_CODE() ];
}

sub type {
    my $handler = shift;
    return $handler->[ EL_TYPE() ] = shift if @_;
    return $handler->[ EL_TYPE() ];
}

sub super {
    my $handler = shift;
    return $handler->[ EL_SUPER() ] = shift if @_;
    return $handler->[ EL_SUPER() ];
}

sub values { @{ $_[0] } }

sub invoke {
    my $self = shift;
    my ( $ctx, $args, $cond ) = @_;
    my $code = $self->[ EL_CODE() ];
    unless ( ref $code ) {
        $code = $self->[ EL_CODE() ] = MT->handler_to_coderef($code);
        return unless $code;
        $self->[ EL_CODE() ] = $code;
    }
    local $ctx->{__stash}{__handler} = $self;
    return $code->( $ctx, $args, $cond );
}

sub invoke_super {
    my $self = shift;
    my ( $ctx, $args, $cond ) = @_;
    my $super = $self->super;
    return unless defined $super;
    if ( !ref $super || ref $super ne 'MT::Template::Handler' ) {
        $super = $self->[ EL_SUPER() ] = MT::Template::Handler->new(@$super);
    }
    my $tag = lc $ctx->stash('tag');
    local $ctx->{__handlers}{$tag} = $super;
    $super->invoke(@_);
}

1;
__END__

=head1 NAME

MT::Template::Handler - Movable Type Template Handler

=head1 SYNOPSIS

    use MT::Template::Handler;
    my $hdlr = MT::Template::Handler->new(
        \&_hdlr_foo,    # handler coderef
        1,              # type of handler
        \$orig_hdlr,    # ref to parent handler
    ); 

    $hdlr->invoke( $ctx, $args, $cond );
    $hdlr->invoke_super( $ctx, $args, $cond );

=head1 USAGE

=head2 MT::Template::Handler->new

=head2 $hdlr->invoke

invoke this handler. takes $ctx, $args, $cond for handling context.

=head2 $hdlr->invoke_super

invoke parent handler. takes $ctx, $args, $cond for handling context.

=head1 DATA ACCESS METHODS

=head2 $hdlr->code

set/get handlers coderef. it's able to set Movable Type handler string (e.g. $MyPlugin::MyPlugin::Module::foo) too.

=head2 $hdlr->type

set/get handler type.

=head2 $hdlr->super

set/get super handler of this handler. it must be either object of I<MT::Template::Handler> or arrayref as C<[ $code, $type, $super ]>.

=head2 $hdlr->values

convinience method. returns array of three values above.

=cut
