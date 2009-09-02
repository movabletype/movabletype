# $Id: Cache.pm 342 2007-04-02 18:50:11Z ykerherve $

package Data::ObjectDriver::Driver::Cache::Cache;
use strict;
use warnings;

use base qw( Data::ObjectDriver::Driver::BaseCache );

sub deflate {
    my $driver = shift;
    my($obj) = @_;
    $obj->deflate;
}

sub inflate {
    my $driver = shift;
    my($class, $data) = @_;
    $class->inflate($data);
}

sub get_from_cache    { shift->cache->thaw(@_)   }
sub add_to_cache      { shift->cache->freeze(@_) }
sub update_cache      { shift->cache->freeze(@_) }
sub remove_from_cache { shift->cache->remove(@_) }

1;
