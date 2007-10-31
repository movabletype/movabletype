# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::ObjectDriver::SQL::SQLite;

use strict;
use warnings;
use base qw( MT::ObjectDriver::SQL );

#--------------------------------------#
# Instance Methods

sub as_sql {
    my $stmt = shift;
    my $cfg = MT->config;
    return $stmt->SUPER::as_sql(@_);# unless $cfg->UseSQLite2;
}

sub field_decorator {
    my $stmt = shift;
    my ($class) = @_;
    return sub {
        my($term) = @_;
        my $field_prefix = $class->datasource;
        my $new_term = q();
        while ($term =~ /extract\((\w+)\s+from\s+([\w_]+)\)(\s*desc|asc)?/ig) {
            my $extract = "strftime('";
            if ('year' eq lc($1)) {
                $extract .= '%Y';
            } elsif ('month' eq lc($1)) {
                $extract .= '%m';
            } elsif ('day' eq lc($1)) {
                $extract .= '%d';
            }
            $extract .= "', $2)";
            $extract .= $3 if defined $3;
            $new_term .= ', ' if $new_term;
            $new_term .= $extract;
        }
        $new_term = $term unless $new_term;
        for my $col (@{ $class->column_names }) {
            $new_term =~ s/\b$col\b/${field_prefix}_$col/g;
        }
        return $new_term;
    };
}

1;
