# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Callback::User;

use strict;
use warnings;

use MT::I18N;
use MT::App::CMS;
use MT::CMS::User;

sub pre_load_filtered_list {
    my ( $cb, $app, $filter, $opts, $cols ) = @_;
    my $user = $app->user;

    my $terms = $opts->{terms};
    $terms->{type} = MT::Author::AUTHOR();

    unless ( $user && $user->is_superuser ) {
        $terms->{status} = MT::Author::ACTIVE();
    }
}

sub can_view {
    my ( $eh, $app, $id, $objp ) = @_;
    my $obj = $objp->force();
    return $obj->status == MT::Author::ACTIVE();
}

sub save_filter {
    my ( $eh, $app, $obj, $original, $opts ) = @_;

    MT::CMS::User::save_filter(@_) or return;

    my $user_json = $app->param('user');
    my $user_hash = $app->current_format->{unserialize}->($user_json);
    if ( exists $user_hash->{password} && length $user_hash->{password} ) {
        my $error = $app->verify_password_strength( $obj->name,
            $user_hash->{password} );
        if ($error) {
            return $app->error($error);
        }
    }

    my $languages = MT::I18N::languages_list($app);
    my @langs = map { $_->{l_tag} } @$languages;
    push @langs, 'en_us';
    if ( $obj->preferred_language
        && !( grep { lc( $obj->preferred_language ) eq $_ } @langs ) )
    {
        return $app->errtrans( 'Invalid language: [_1]',
            $obj->preferred_language );
    }

    if ( $obj->date_format
        && !( grep { $obj->date_format eq $_ } qw/ relative full / ) )
    {
        return $app->errtrans( 'Invalid dateFormat: [_1]',
            $obj->date_format );
    }

    my $filters = MT::App::CMS::load_text_filters( $app, 0, 'entry' );
    my @filter_keys = map { $_->{key} } @$filters;
    if ( defined( $obj->text_format )
        && !( grep { $obj->text_format eq $_ } @filter_keys ) )
    {
        return $app->errtrans( 'Invalid textFormat: [_1]',
            $obj->text_format );
    }

    return 1;
}

1;

__END__

=head1 NAME

MT::DataAPI::Callback::User - Movable Type class for Data API's callbacks about the MT::Author.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
