# Movable Type (r) (C) 2005-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package StyleCatcher::Library;
use strict;
use warnings;
use MT;
use base qw( MT::ErrorHandler Class::Accessor::Fast );
use StyleCatcher::Util;

my @KEYS = qw(description_label label order url class no_listify);
__PACKAGE__->mk_accessors( 'key', @KEYS );

sub new {
    my $pkg = shift;
    my ($id) = @_;
    return $pkg->new_default() unless $id;
    my $reg = MT->registry( stylecatcher_libraries => $id );
    if ( !defined $reg ) {

        # Possibly template set specified repository.
        # Will look for...
        my $app  = MT->instance        or return;
        my $blog = $app->blog          or return;
        my $set  = $blog->template_set or return;
        $set = MT->registry( template_sets => $set )
            if !ref $set;

        require MT::Theme;
        if ( my $theme = MT::Theme->load($id) ) {
            $theme->__deep_localize_labels($set);
        }

        $reg = $set->{stylecatcher_libraries}{$id}
            or return $pkg->new_default();
    }
    my $class = $reg && $reg->{class} ? $reg->{class} : 'Default';
    my $inst_class = 'StyleCatcher::Library::' . $class;
    do { eval "require $inst_class"; 1; }
        or die $@;
    my $obj = bless { key => $id }, $inst_class;
    return $obj->init($reg);
}

sub new_default {
    require StyleCatcher::Library::Default;
    return bless {}, 'StyleCatcher::Library::Default';
}

sub init {
    my $self = shift;
    my ($reg) = @_;
    @{$self}{@KEYS} = @{$reg}{@KEYS};
    return $self;
}

sub component {
    return MT->component('StyleCatcher');
}

sub translate {
    my $self = shift;
    return $self->component->translate(@_);
}

sub listify {
    my $self = shift;
    return if $self->no_listify;
    my $hash = {
        key               => $self->key,
        url               => $self->url,
        order             => $self->order,
        label             => $self->label,
        description_label => $self->description_label,
    };
    for (qw( label description_label )) {
        $hash->{$_} = $hash->{$_}->()
            if ref $hash->{$_};
    }
    return $hash;
}

1;
__END__

=head1 NAME

StyleCatcher::Library

=head1 SYNOPSIS

 # in config.yaml

 stylecatcher_libraries:
     professional_themes:
         label: Professional Styles
         order: 100
         description_label: A collection of styles compatible with Professional themes.
         url: '{{static}}addons/Commercial.pack/themes/professional.html'
         class: Local

 # then
 my $repo = StyleCatcher::Library->new($repo_id);
 $repo->fetch_themes();

=head1 DESCRIPTION

Proxy module for StyleCatcher Library(Repository) Classes.

=head1 METHODS

=over 4

=item new

Create an instance of given repository ID. The ID must exists in MT registry under
`stylecatcher_libraries` key. The base class of instance is specified by `class` key.
If `class` key is not defined, StyleCatcher::Library::Default is used for the base
class of instance by default.

=item fetch_themes

Pulls a list of themes available from a particular url. You must override this method
for child classes.

=item download_theme

Returns an URL of theme.

=back






1;
