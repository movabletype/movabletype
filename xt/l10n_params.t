use strict;
use warnings;
use FindBin;
use Cwd;
use File::Find;
use Test::More;
use Test::Deep;
use Encode;
use utf8;

my %Skip = _set_skip();

my $root = Cwd::realpath("$FindBin::Bin/..");

my @dirs = qw(lib addons/*/lib plugins/*/lib);
for my $dir (map { glob "$root/$_" } @dirs) {
    find({
            wanted => sub {
                my $file = $File::Find::name;
                return unless $file =~ m!L10N[\\/](\w+).pm$!;
                return unless $file =~ m!ja\.pm$!;   # for now
                my $body = do { local $/; open my $fh, '<', $file; <$fh> };
                $body =~ s/\A.+\%Lexicon\s*=\s*//s or next;
                $body =~ s/\);\s*1;\s*\z/);/s;
                $body = decode_utf8($body);
                local $SIG{__WARN__} = sub { die "$file: $_[0]" };
                my %lexicon = eval $body;

                if ($@) {
                    fail "$file: $@";
                    return;
                }
                for my $key (sort keys %lexicon) {
                    my ($phrase, $trans) = ($key, $lexicon{$key});
                    next unless $trans;
                    next if $phrase =~ /\A_[A-Z_]+\z/;
                    my @phrase_params = $phrase =~ /\[(?:[^,\[\]]+,\s*)*_(\d+)(?:,\s*[^,\[\]]+)*\]/g;
                    my @trans_params  = $trans  =~ /\[(?:[^,\[\]]+,\s*)*_(\d+)(?:,\s*[^,\[\]]+)*\]/g;
                    next if !@phrase_params && !@trans_params;
                    next if ($Skip{$phrase} // '') eq ($trans // '');
                    cmp_bag \@phrase_params, \@trans_params, encode_utf8("$file: '$phrase' => '$trans'");
                }
            },
            no_chdir => 1,
        },
        $dir
    );
}

done_testing;

sub _set_skip {
    return (
        # lib/MT/L10N/ja.pm
        q{<a href="[_1]">QuickPost to [_2]</a> - Drag this bookmarklet to your browser's toolbar, then click it when you are visiting a site that you want to blog about.} => q{<a href="[_1]">クイック投稿</a>: このリンクをブラウザのツールバーにドラッグし、興味のあるウェブページでクリックすると、ブログへ簡単に投稿できます。},

        q{Before you can upload a file, you need to publish your [_1]. [_2]Configure your [_1]'s publishing paths[_3] and republish your [_1].} => q{ファイルのアップロードができるように、[_1]を再構築する必要があります。[_2]公開パスの設定[_3]をして、[_1]を再構築してください。},

        'Migrating existing [quant,_1,blog,blogs] into websites and their children...' => '既存のブログをウェブサイトで管理できるように移行しています。',

        q{The Movable Type Upgrade Guide can be found <a href='[_1]' target='_blank'>here</a>.} => q{Movable Typeアップグレードガイドは<a href='https://www.movabletype.jp/documentation/upgrade/' target='_blank'>こちらを</a>参照ください。},

        'Author of [_1]' => '作成者',

        'Only 1 [_1] can be selected in "[_2]" field.' => '"[_2]”フィールドはひとつだけ選択できます',

        'Notify ping services of [_1] updates' => 'サイト更新pingサービス通知',

        'This theme cannot be applied to the child site due to [_1] errors' => '次の理由により、テーマを適用できませんでした',
        'This theme cannot be applied to the site due to [_1] errors' => '次の理由により、テーマを適用できませんでした。',

        '[quant,_1,warning,warnings]' => '[quant,_1,,,]件の警告',

        # movabletype-addons/Commercial.pack/lib/MT/Commercial/L10N/ja.pm
        q{The '[_1]' of the template tag '[_2]' that is already in use in [_3] is [_4].} => q{'[_2]'というテンプレートタグが[_3]に既に存在していますが、[_1]が異なるため、重複して作成する事が出来ません。テンプレートタグ名を変えるか、[_1]を同じにする必要があります。([_1]: [_4])},

        'Found mismatched closing tag [_1] at line #' => '</mt:[_1]>に対応する<mt:[_1]>がありません(#行目)',
        'Tag [_1] left unclosed at line #' => '<mt:[_1]>に対応する</mt:[_1]>がありません(#行目)',

        'YEARLY_ARCHIVE_TITLE' => '[_1]年',
    );
}
