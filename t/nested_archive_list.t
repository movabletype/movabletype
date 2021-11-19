use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Fixture;
use Mojo::DOM;
use File::Spec;
use Test::Deep;
use utf8;

$test_env->prepare_fixture('db');

my $objs = MT::Test::Fixture->prepare({
    website => [{
        name         => 'my_site',
        site_path    => 'TEST_ROOT/site',
        archive_path => 'TEST_ROOT/site/archive',
    }],
    entry => [{
            title       => 'Entry 2021-11-01',
            text        => 'Entry 2021-11-01',
            authored_on => '20211101000000',
            status      => 'publish',
        },
        {
            title       => 'Entry 2021-11-15',
            text        => 'Entry 2021-11-15',
            authored_on => '20211115000000',
            status      => 'publish',
        },
        {
            title       => 'Entry 2021-10-01',
            text        => 'Entry 2021-10-01',
            authored_on => '20211001000000',
            status      => 'publish',
        },
        {
            title       => 'Entry 2021-10-18',
            text        => 'Entry 2021-10-18',
            authored_on => '20211018000000',
            status      => 'publish',
        },
        {
            title       => 'Entry 2020-11-01',
            text        => 'Entry 2020-11-01',
            authored_on => '20201101000000',
            status      => 'publish',
        },
        {
            title       => 'Entry 2020-11-10',
            text        => 'Entry 2020-11-10',
            authored_on => '20201110000000',
            status      => 'publish',
        },
    ],
    template => [{
            archive_type => 'Yearly',
            name         => 'tmpl_yearly_nested_archivelist',
            mapping      => [{
                    file_template => 'nested/%y/index.html',
                    is_preferred  => 1,
                },
            ],
            text => <<'TMPL',
<mt:ArchiveList type="Yearly" sort_order="ascend">
  <mt:ArchiveListHeader><ul></mt:ArchiveListHeader>
    <li>
    <a class="year" href="<mt:ArchiveLink />"><mt:ArchiveDate format="%Y" setvar="current_year"><mt:var name="current_year">(<mt:ArchiveCount />)
      <mt:ArchiveList type="Monthly" sort_order="ascend">
        <mt:ArchiveListHeader><ul></mt:ArchiveListHeader>
      <mt:If tag="ArchiveDate" format="%Y" eq="$current_year">
          <li class="<mt:var name="current_year">"><a class="month" href="<mt:ArchiveLink />"><mt:ArchiveDate format="%b">(<mt:ArchiveCount />)</a></li>
    </mt:If>
        <mt:ArchiveListFooter></ul></mt:ArchiveListFooter>
      </mt:ArchiveList>
    </li>
  <mt:ArchiveListFooter></ul></mt:ArchiveListFooter>
</mt:ArchiveList>
TMPL
        }, {
            name    => 'tmpl_index_nested_archivelist',
            type    => 'index',
            outfile => 'nested_archivelist.html',
            text    => <<'TMPL',
<mt:ArchiveList type="Yearly" sort_order="ascend">
  <mt:ArchiveListHeader><ul></mt:ArchiveListHeader>
    <li>
    <a class="year" href="<mt:ArchiveLink />"><mt:ArchiveDate format="%Y" setvar="current_year"><mt:var name="current_year">(<mt:ArchiveCount />)
      <mt:ArchiveList type="Monthly" sort_order="ascend">
        <mt:ArchiveListHeader><ul></mt:ArchiveListHeader>
      <mt:If tag="ArchiveDate" format="%Y" eq="$current_year">
          <li class="<mt:var name="current_year">"><a class="month" href="<mt:ArchiveLink />"><mt:ArchiveDate format="%b">(<mt:ArchiveCount />)</a></li>
    </mt:If>
        <mt:ArchiveListFooter></ul></mt:ArchiveListFooter>
      </mt:ArchiveList>
    </li>
  <mt:ArchiveListFooter></ul></mt:ArchiveListFooter>
</mt:ArchiveList>
TMPL
        }, {
            archive_type => 'Monthly',
            name         => 'tmpl_monthly_unnested_archivelist',
            mapping      => [{
                    file_template => 'unnested/%y/%m/index.html',
                    is_preferred  => 1,
                },
            ],
            text => <<'TMPL',
<mt:IfArchiveTypeEnabled archive_type="Monthly">
  <mt:ArchiveList archive_type="Monthly">
    <mt:ArchiveListHeader>
<nav class="widget-archive-dropdown widget">
  <h3 class="widget-header">Archives</h3>
  <div class="widget-content">
    <select>
      <option>Select month...</option>
    </mt:ArchiveListHeader>
      <option value="<$mt:ArchiveLink encode_html="1"$>"><$mt:ArchiveTitle$></option>
    <mt:ArchiveListFooter>
    </select>
  </div>
</nav>
    </mt:ArchiveListFooter>
  </mt:ArchiveList>
</mt:IfArchiveTypeEnabled>
TMPL
        }, {
            name    => 'tmpl_index_unnested_archivelist',
            type    => 'index',
            outfile => 'unnested_archivelist.html',
            text    => <<'TMPL',
<mt:IfArchiveTypeEnabled archive_type="Monthly">
  <mt:ArchiveList archive_type="Monthly">
    <mt:ArchiveListHeader>
<nav class="widget-archive-dropdown widget">
  <h3 class="widget-header">Archives</h3>
  <div class="widget-content">
    <select>
      <option>Select month...</option>
    </mt:ArchiveListHeader>
      <option value="<$mt:ArchiveLink encode_html="1"$>"><$mt:ArchiveTitle$></option>
    <mt:ArchiveListFooter>
    </select>
  </div>
</nav>
    </mt:ArchiveListFooter>
  </mt:ArchiveList>
</mt:IfArchiveTypeEnabled>
TMPL
        }
    ],
});

my $site      = $objs->{website}{my_site};
my $site_path = $site->site_path;

MT->publisher->rebuild(BlogID => $site->id);

$test_env->ls;

for my $name ('nested_archivelist', 'archive/nested/2021/index', 'archive/nested/2020/index') {
    subtest "$name.html" => sub {
        my $html = $test_env->slurp(File::Spec->catfile($site_path, "$name.html"));
        my $dom  = Mojo::DOM->new($html);
        my @url;
        $dom->find('a.year')->each(sub { push @url, $_->{href} });
        cmp_bag \@url => [qw(
            http://narnia.na/nested/2020/
            http://narnia.na/nested/2021/
        )], "expected year href";

        @url = ();
        $dom->find('li.2021 a.month')->each(sub { push @url, $_->{href} });
        cmp_bag \@url => [qw(
            http://narnia.na/2021/10/
            http://narnia.na/2021/11/
        )], "expected months of 2021 href";

        @url = ();
        $dom->find('li.2020 a.month')->each(sub { push @url, $_->{href} });
        cmp_bag \@url => [qw(
            http://narnia.na/2020/11/
        )], "expected months of 2020 href";
    };
}

for my $name ('unnested_archivelist', 'archive/unnested/2021/11/index', 'archive/unnested/2021/10/index', 'archive/unnested/2020/11/index') {
    subtest "$name.html" => sub {
        my $html = $test_env->slurp(File::Spec->catfile($site_path, "$name.html"));
        my $dom  = Mojo::DOM->new($html);
        my @url;
        $dom->find('option')->each(sub { push @url, $_->{value} if defined $_->{value} });
        cmp_bag \@url => [qw(
            http://narnia.na/2020/11/
            http://narnia.na/2021/10/
            http://narnia.na/2021/11/
        )], "expected options";
    };
}

done_testing;
