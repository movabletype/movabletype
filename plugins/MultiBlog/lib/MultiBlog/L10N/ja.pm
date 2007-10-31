package MultiBlog::L10N::ja;
# $Id$
use strict;
use base 'MultiBlog::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
    ## plugins/MultiBlog/multiblog.pl
    'MultiBlog allows you to publish templated or raw content from other blogs and define rebuild dependencies and access controls between them.' => 'MultiBlogを使うと、他のブログにあるテンプレートコンテンツあるいは通常のコンテンツを公開することができます。再構築時の依存関係やアクセス制御を設定することもできます。',
    '* All Weblogs' => '* すべてのブログ',
    'Select to apply this trigger to all weblogs' => '選択してこのトリガーをすべてのブログに適用',
    'MultiBlog' => 'MultiBlog',
    'Create New Trigger' => '新しいトリガーを作成する',
    'Search Weblogs' => 'ブログを検索',
    'saves an entry' => 'エントリーの保存時',
    'publishes an entry' => 'エントリーの公開時',
    'publishes a comment' => 'コメントの公開時',
    'publishes a ping' => 'トラックバックの公開時',
    'rebuild indexes.' => 'インデックスを再構築する',
    'rebuild indexes and send pings.' => 'インデックスを再構築して更新情報を送信する',

    ## plugins/MultiBlog/tmpl/blog_config.tmpl
    'When' => '',  # This is intentional. At the time of this writing, the string only appears in plugin settings template.
    'Any Weblog' => 'あらゆるブログ',
    'Trigger' => 'トリガー',
    'Action' => 'アクション',
    'Content Privacy:' => 'コンテンツのプライバシー:',
    'Use system default' => 'システムの既定値を使用',
    'Allow' => '許可',
    'Disallow' => '不許可',
    'Specify whether other blogs in the installation may publish content from this blog. This setting takes precedence over the default system aggregation policy found in the system-level MultiBlog configuration.' => '同じMovable Type内の他のブログがこのブログのコンテンツを公開できるかどうかを指定します。この設定はシステムレベルのMultiBlogの構成で指定された既定のアグリゲーションポリシーよりも優先されます。',
    'MTMultiBlog tag default arguments:' => 'MTMultiBlogタグの既定の引数:',
    'Include blogs' => '含めるブログ',
    'Exclude blogs' => '除外するブログ',
    'Current Rebuild Triggers:' => '現在の再構築トリガー',
    'Create New Rebuild Trigger' => '新しい再構築トリガーを作成する',
    'You have not defined any rebuild triggers.' => '再構築トリガーを設定していません。',
    'Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes.<br />Comma-separated BlogIDs or \'all\' (include_blogs only) are acceptable values.' => 'MTMultiBlogタグをinclude_blogs/exclude_blogs属性なしで利用できるようにします。<br />ブログIDをカンマで区切るか、または\'all\'（include_blogsのみ）を指定できます。',

    ## plugins/MultiBlog/tmpl/system_config.tmpl
    'Default system aggregation policy:' => '既定のアグリゲーションポリシー',
    'Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.' => 'ブログをまたがったアグリゲーションが既定で許可されます。個別のブログレベルでのMultiBlogの設定で他のブログからのコンテンツへのアクセスを制限できます。',
    'Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.' => 'ブログをまたがったアグリゲーションが既定で不許可になります。個別のブログレベルでのMultiBlogの設定で他のブログからのコンテンツへのアクセスを許可することもできます。',

    ## plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl
    'When this' => 'トリガー: ',

    ## plugins/MultiBlog/lib/MultiBlog/Tags/MultiBlog.pm
    'MTMultiBlog tags cannot be nested.' => 'MTMultiBlogタグはネストできません。',
    'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => '[_1]はmodeパラメータの値として不正です。loopまたはcontextが正しい値です。',

    ## plugins/MultiBlog/lib/MultiBlog/Tags/LocalBlog.pm

    ## plugins/MultiBlog/lib/MultiBlog/Tags.pm

    ## plugins/MultiBlog/lib/MultiBlog.pm
    'The include_blogs, exclude_blogs, blog_ids and blog_id attributes cannot be used together.' => 'include_blogs、exclude_blogs、blog_ids、blog_id属性は併用できません。',
    'The attribute exclude_blogs cannot take "all" for a value.' => 'exclude_blogsにはallは指定できません。',
    'The value of the blog_id attribute must be a single blog ID.' => 'blog_id属性には単一のブログIDしか指定できません。',
    'The value for the include_blogs/exclude_blogs attributes must be one or more blog IDs, separated by commas.' => 'include_blogs属性とexclude_blogs属性にはブログIDをカンマで区切って複数指定します。',
);

1;

