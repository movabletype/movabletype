package MT::Plugin::Diagnosis::Department::Revision;
use strict;
use warnings;
use base 'MT::Plugin::Diagnosis::Department';
use MT::Plugin::Diagnosis;

our $BULK_DELETE = 100;

sub description { translate('Delete revision amount excession.') }

sub scan {
    my ($class) = @_;
    my @result;

    MT->log({
        message   => translate('Disgnosis scan on Revision is started'),
        level     => MT::Log::INFO(),
        author_id => MT->instance->user->id,
    });

    my %target = ('entry' => 1, 'cd' => 1, 'template' => 1);

    my $site_iter = MT::Blog->load_iter({class => '*'});

    while (my $site = $site_iter->()) {

        for my $ds (keys %target) {

            count_iter(
                $ds, $site,
                sub {
                    my ($count, $id, $max) = @_;
                    push @result, {
                        params      => MT::Util::to_json({ ds => $ds, id => $id }),
                        department  => $class->department_name,
                        description => translate('Excession on site id:[_1]. ([_2]/[_3])', $site->id, $count, $max),
                    };
                },
            );
        }
    }

    return @result;
}

sub repair {
    my ($class, $task) = @_;
    my $params       = MT::Util::from_json($task->params);
    my $delete_count = bulk_remove($params->{ds}, $params->{id});
    return 1;
}

sub count_iter {
    my ($ds, $site, $cb) = @_;
    my $model      = MT->model($ds);
    my $col        = 'max_revisions_' . $ds;
    my $max        = $site->$col || $MT::Revisable::MAX_REVISIONS;
    my $count_iter = MT->model($ds . ':revision')->count_group_by(
        undef, {
            join   => $model->join_on(undef, { id => \"= ${ds}_rev_${ds}_id", blog_id => $site->id }),
            group  => ["${ds}_id"],
            having => { "count(${ds}_rev_${ds}_id)" => \"> $max" },
        },
    );

    while (my ($count, $id) = $count_iter->()) {
        $cb->($count, $id, $max);
    }
}

sub bulk_remove {
    my ($ds, $id, $limit) = @_;

    my $rev_class = MT->model($ds . ':revision');

    my %args = (fetchonly => { 'id' => 1 });
    %args = (%args, sort => 'created_on', direction => 'ascend', limit => $limit) if $limit;

    my @ids = map { $_->id } $rev_class->load({ $ds . '_id' => $id }, \%args);

    my $delete_count = $rev_class->remove({ id => \@ids }, { nofetch => 1 });

    return $delete_count;
}

1;
