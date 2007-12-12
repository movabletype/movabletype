package MT::ObjectDriver::SQL::mysql;

use strict;
use warnings;
use base qw( MT::ObjectDriver::SQL );

sub new {
    my $class = shift;
    my %param = @_;
    my $sql = $class->SUPER::new(%param);
    if (my $cols = $sql->binary) {
        foreach my $col (keys %$cols) {
            my $t = $sql->transform->{$col};
            if ($t && ($t=~ /\)$/)) {
                $sql->transform->{$col} = 'binary ' . $t;
            } elsif ($t) {
                $sql->transform->{$col} = "$t($col)";
            } else {
                $sql->transform->{$col} = "binary($col)";
            }
        }
    }
    return $sql;
}

1;
