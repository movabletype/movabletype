# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::ContentFieldType::List;
use strict;
use warnings;

use MT::ContentField;
use MT::ContentFieldType::Common
    qw( get_cd_ids_by_inner_join get_cd_ids_by_left_join );
use MT::Util;

sub field_html_params {
    my ( $app, $field_data ) = @_;
    my $value = $field_data->{value};
    $value = ''       unless defined $value;
    $value = [$value] unless ref $value eq 'ARRAY';

    my $required
        = $field_data->{options}{required} ? 'data-mt-required="1"' : '';

    {   list_value => $value,
        required   => $required,
    };
}

sub html {
    my $prop = shift;
    my ( $content_data, $app, $load_options ) = @_;

    my $field = MT::ContentField->load( $prop->content_field_id );
    my $bullet_or_numbered = $field->options->{bullet_or_numbered} || '';
    my $list_style_type
        = $bullet_or_numbered eq 'numbered' ? 'decimal' : 'disc';

    my $values = $content_data->data->{ $prop->content_field_id } || [];
    my $values_html = join '', (
        map {
            qq{<li class="role-item" style="list-style-type: ${list_style_type}">$_</li>}
        } @{$values}
    );

    "<ul>${values_html}</ul>";
}

sub terms {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $option = $args->{option} || '';
    my $join_args = undef;

    if ( $option eq 'not_contains' ) {
        my $col    = $prop->col;
        my $string = $args->{string};
        my $join_terms
            = { $col => [ \'IS NULL', { like => "%${string}%" } ] };
        my $cd_ids
            = get_cd_ids_by_inner_join( $prop, $join_terms, $join_args, @_ );
        $cd_ids ? { id => { not => $cd_ids } } : ();
    }
    else {
        my $join_terms = $prop->super(@_);
        my $cd_ids
            = get_cd_ids_by_inner_join( $prop, $join_terms, $join_args, @_ );
        { id => $cd_ids };
    }
}

sub tag_handler {
    my ( $ctx, $args, $cond, $field_data, $value ) = @_;
    my $tok     = $ctx->stash('tokens');
    my $builder = $ctx->stash('builder');
    my $vars    = $ctx->{__stash}{vars} ||= {};
    my $out     = '';
    my $i       = 1;
    my $glue    = $args->{glue};

    for my $v ( @{$value} ) {
        local $vars->{__first__}   = $i == 1;
        local $vars->{__last__}    = $i == scalar @{$value};
        local $vars->{__odd__}     = ( $i % 2 ) == 1;
        local $vars->{__even__}    = ( $i % 2 ) == 0;
        local $vars->{__counter__} = $i;
        local $vars->{__value__}   = $v;

        defined(
            my $res = $builder->build(
                $ctx, $tok,
                {   %{$cond},
                    ContentFieldHeader => $i == 1,
                    ContentFieldFooter => $i == scalar @$value,
                }
            )
        ) or return $ctx->error( $builder->errstr );

        if ( $res ne '' ) {
            $out .= $glue
                if defined $glue && $i > 1 && length($out) && length($res);
            $out .= $res;
            $i++;
        }
    }

    $out;
}

sub feed_value_handler {
    my ( $app, $field_data, $values ) = @_;
    my @list_values;
    if ( defined $values && $values ne '' ) {
        if ( ref $values eq 'ARRAY' ) {
            @list_values = @$values;
        }
        else {
            @list_values = ($values);
        }
    }
    my $contents = join '',
        map { '<li>' . MT::Util::encode_html($_) . '</li>' } @list_values;
    return "<ul>$contents</ul>";
}

sub preview_handler {
    my ( $field_data, $values, $content_data ) = @_;
    return '' unless $values;
    unless ( ref $values eq 'ARRAY' ) {
        $values = [$values];
    }
    return '' unless @$values;

    my $contents = join '',
        map { '<li>' . MT::Util::encode_html($_) . '</li>' } @$values;
    return qq{<ul class="list-unstyled">$contents</ul>};
}

sub replace_handler {
    my ($search_regex, $replace_string, $field_data,
        $values,       $content_data
    ) = @_;
    return (0, $values) unless defined $values;
    $values = [$values] unless ref $values eq 'ARRAY';
    my $replaced = 0;
    for (@$values) {
        $replaced += $_ =~ s!$search_regex!$replace_string!g;
    }
    return ($replaced > 0, $values);
}

sub search_handler {
    my ( $search_regex, $field_data, $values, $content_data ) = @_;
    return 0 unless defined $values;
    $values = [$values] unless ref $values eq 'ARRAY';
    ( grep { defined $_ ? $_ =~ /$search_regex/ : 0 } @$values ) ? 1 : 0;
}

1;

