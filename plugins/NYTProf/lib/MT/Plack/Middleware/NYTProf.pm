package MT::Plack::Middleware::NYTProf;
use strict;
use warnings;
use parent qw(Plack::Middleware);
use Plack::Util;

sub call {
    require Devel::NYTProf;
    my ($self, $env) = @_;
    DB::enable_profile("nytprof-tmp/nytprof.out.". time(). '.'. $$);
    my $res = $self->app->($env);
    return Plack::Util::response_cb($res, sub {
        DB::finish_profile();
    });
}

1;
