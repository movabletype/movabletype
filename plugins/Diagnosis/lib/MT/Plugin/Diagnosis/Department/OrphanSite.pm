package MT::Plugin::Diagnosis::Department::OrphanSite;
use strict;
use warnings;
use MT;
use base 'MT::Plugin::Diagnosis::Department';
use MT::Plugin::Diagnosis;

sub description { translate('Delete parent mission sites.') }

sub scan {
    my ($class) = @_;
    my @result;

    MT->log({
        message   => translate('Disgnosis scan on OrphanSite is started'),
        level     => MT::Log::INFO(),
        author_id => MT->instance->user->id,
    });

    my $site_iter = MT->model('blog')->load_iter({ class => 'blog', 'parent_id' => undef });

    while (my $site = $site_iter->()) {
        my $target_str = sprintf(qq{Child site "%s"(id:%d)\n}, $site->name, $site->id);
        push @result, {
            params      => MT::Util::to_json({ id => $site->id }),
            department  => $class->department_name,
            description => translate('Parent is missing for site "[_1]".', $site->name),
        };
    }

    return @result;
}

sub repair {
    my ($class, $task) = @_;
    my $params = MT::Util::from_json($task->params);
    MT->model('blog')->remove({id => $params->{id}}, { nofetch => 1 });
    return 1;
}

1;
