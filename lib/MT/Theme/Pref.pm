# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::Theme::Pref;
use strict;
use MT;

sub apply {
    my ( $element, $theme, $obj_to_apply ) = @_;
    my $data = $element->{data};
    if (   ref $obj_to_apply ne MT->model('blog')
        && ref $obj_to_apply ne MT->model('website') )
    {
        return $element->errtrans(
            'this element cannot apply for non blog object.');
    }
    my $blog = $obj_to_apply;
    for my $conf ( keys %$data ) {
        if ( $blog->has_column($conf) ) {
            my $value = $data->{$conf};
            $blog->$conf($value);
        }
        else {
            die "fatal error!";
        }
    }
    $blog->save
        or return $element->errtrans( 'Failed to save blog object: [_1]',
        $blog->errstr );
    return 1;
}

sub info {
    my ( $element, $theme, $blog ) = @_;
    my $class = defined $blog ? $blog->class : '';
    return $class
        ? sub {
        MT->translate( 'default settings for [_1]', MT->translate($class) );
        }
        : sub { MT->translate('default settings') };
}

1;
