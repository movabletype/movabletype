# $Id: BaseView.pm 552 2008-12-24 02:15:57Z ykerherve $

package Data::ObjectDriver::BaseView;
use strict;
use warnings;

use base qw( Data::ObjectDriver::BaseObject );

use Carp ();
use Storable;

sub search {
    my $class = shift;
    my($terms, $args) = @_;
    $args->{sql_statement} = $class->base_statement($terms, $args);
    $args = Storable::dclone($args);

    # quick hack: don't use HAVING if view class has datasource
    if (! $class->properties->{datasource}) {
        my %cols = map { $_ => 1 } @{ $class->properties->{columns} };
        my %having;
        for my $key (keys %$terms) {
            if ($cols{$key} && ! $args->{sql_statement}->has_where($key)) {
                # Don't need to delete from $term, because D::OD ignores
                # it anyway when used as View class
                $having{$key} = $terms->{$key};
            }
        }
        $args->{having} = \%having;
    }

    $class->_proxy('search', $terms, $args)
}

1;
