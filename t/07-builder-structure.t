use strict;
use warnings;
use lib qw( t t/lib lib extlib );

use MT::Test;
use Test::More;
use MT;
use MT::Builder;
use MT::Template::Context;
use YAML;

my $mt = MT->new;

my($tokens, $out);

my $builder = MT::Builder->new;
ok($builder, "Builder constructed okay");

my $ctx = MT::Template::Context->new;
ok($ctx, "Context constructed okay");

binmode DATA, ":utf8";
my $content = do { local $/ = <DATA> };
close DATA;
my ($text, $yaml) = split /_________DELIMITER_COMPILER_TEST__________/, $content, 2;
my $got_tokens = $builder->compile($ctx, $text);
my $expected_tokens = Load($yaml);

foreach my $token (@$got_tokens) {
    delete_parents($token, undef);
}

is_deeply($expected_tokens, $got_tokens, "token structure is equal");

done_testing();

sub delete_parents {
    my ($token, $parent) = @_;
    if ($token->[0] ne 'TEXT') {
        # TEXT tokens have a bug that the parent is not always set
        is($token->[5], $parent, "token has the correct parent, " . $token->[0]);
    }
    splice @$token, 5;
    if ($token->[2]) { # have child nodes
        foreach my $child (@{ $token->[2] }) {
            delete_parents($child, $token);
        }
    }
}

__DATA__
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" id="sixapart-standard">
<head>
    <$mt:Include module="HTMLヘッダー"$>
    <$mt:Var name="comments_per_page" value="50"$>
    <mt:EntryPrevious><link rel="prev bookmark" href="<$mt:EntryPermalink$>" title="<$mt:EntryTitle encode_html="1"$>" /></mt:EntryPrevious>
    <mt:EntryNext><link rel="next bookmark" href="<$mt:EntryPermalink$>" title="<$mt:EntryTitle encode_html="1"$>" /></mt:EntryNext>
    <$mt:EntryTrackbackData$>
    <mt:If tag="EntryCommentCount" gt="$comments_per_page">
	    <script type="text/javascript">
         MT.entryID = <$mt:EntryID$>;
         MT.commentsPerPage = <$mt:Var name="comments_per_page"$>;
         MT.entryCommentCount = <$mt:EntryCommentCount$>;
         MT.commentIds = [<mt:Comments sort_order="ascend" glue=","><mt:CommentID></mt:Comments>];
	    </script>
	  </mt:If>
    <title><$mt:EntryTitle encode_html="1"$> - <$mt:BlogName encode_html="1"$></title>
</head>
<body id="<$mt:BlogThemeID$>" class="mt-entry-archive <$mt:Var name="page_layout"$>">
    <div id="container">
        <div id="container-inner">


            <$mt:Include module="バナーヘッダー"$>


            <div id="content">
                <div id="content-inner">


                    <div id="alpha">
                        <div id="alpha-inner">


                            <div id="entry-<$mt:EntryID$>" class="entry-asset asset hentry">
                                <div class="asset-header">
                                    <h1 id="page-title" class="asset-name entry-title"><$mt:EntryTitle$></h1>
                                    <div class="asset-meta">
                                        <span class="byline">
<mt:If tag="EntryAuthorDisplayName">
                                            <span class="vcard author"><$mt:EntryAuthorLink show_hcard="1"$></span> (<abbr class="published" title="<$mt:EntryDate format_name="iso8601"$>"><$mt:EntryDate format="%x %X"$></abbr>)
<mt:Else>
                                            <abbr class="published" title="<$mt:EntryDate format_name="iso8601"$>"><$mt:EntryDate format="%x %X"$></abbr>
</mt:If>
                                        </span>
<mt:IfCommentsActive>
                                        <span class="separator">|</span> <a href="<$mt:EntryPermalink$>#comments"><$mt:EntryCommentCount singular="コメント(1)" plural="コメント(#)" none="コメント(0)"$></a>
</mt:IfCommentsActive>
<mt:IfPingsActive>
                                        <span class="separator">|</span> <a href="<$mt:EntryPermalink$>#trackbacks"><$mt:EntryTrackbackCount singular="トラックバック(1)" plural="トラックバック(#)" none="トラックバック(0)"$></a>
</mt:IfPingsActive>
                                    </div>
                                </div>
                                <div class="asset-content entry-content">
<mt:If tag="EntryBody">
                                    <div class="asset-body">
                                        <$mt:EntryBody$>
                                    </div>
</mt:If>
<mt:If tag="EntryMore" convert_breaks="0">
                                    <div id="more" class="asset-more">
                                        <$mt:EntryMore$>
                                    </div>
</mt:If>
                                </div>
                                <div class="asset-footer">
<mt:IfArchiveTypeEnabled archive_type="Category">
    <mt:If tag="EntryCategories">
                                    <div class="entry-categories">
                                        <h4>カテゴリ<span class="delimiter">:</span></h4>
                                        <ul>
                                            <li class="entry-category"><mt:EntryCategories glue='<span class="delimiter">,</span></li> <li class="entry-category">'><a href="<$mt:CategoryArchiveLink$>" rel="tag"><$mt:CategoryLabel$></a></mt:EntryCategories></li>
                                        </ul>
                                    </div>
    </mt:If>
</mt:IfArchiveTypeEnabled>
<mt:EntryIfTagged>
                                    <div class="entry-tags">
                                        <h4>タグ<span class="delimiter">:</span></h4>
                                        <ul>
                                            <li><mt:EntryTags glue='<span class="delimiter">,</span></li> <li>'><a href="javascript:void(0)" onclick="location.href='<$mt:TagSearchLink encode_js="1"$>';return false;" rel="tag"><$mt:TagName$></a></mt:EntryTags></li>
                                        </ul>
                                    </div>
</mt:EntryIfTagged>
                                </div>
                            </div>


                    <$mt:Include module="トラックバック"$>
                    <$mt:Include module="コメント"$>


                        </div>
                    </div>


                    <$mt:Include module="サイドバー"$>


                </div>
            </div>


            <$mt:Include module="バナーフッター"$>


        </div>
    </div>
</body>
</html>
_________DELIMITER_COMPILER_TEST__________
---
- !!perl/array:MT::Template::Node
  - TEXT
  - |-
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml" id="sixapart-standard">
    <head>
        
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - Include
  - module: HTMLヘッダー
  - ~
  - ~
  - []
- !!perl/array:MT::Template::Node
  - TEXT
  - "\n    "
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - Var
  - name: comments_per_page
    value: 50
  - ~
  - ~
  - []
- !!perl/array:MT::Template::Node
  - TEXT
  - "\n    "
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - EntryPrevious
  - {}
  -
    - !!perl/array:MT::Template::Node
      - TEXT
      - <link rel="prev bookmark" href="
      - ~
      - ~
      - ~
    - !!perl/array:MT::Template::Node
      - EntryPermalink
      - {}
      - ~
      - ~
      - []
    - !!perl/array:MT::Template::Node
      - TEXT
      - '" title="'
      - ~
      - ~
      - ~
    - !!perl/array:MT::Template::Node
      - EntryTitle
      - encode_html: 1
      - ~
      - ~
      -
        -
          - encode_html
          - 1
    - !!perl/array:MT::Template::Node
      - TEXT
      - '" />'
      - ~
      - ~
      - ~
  - '<link rel="prev bookmark" href="<$mt:EntryPermalink$>" title="<$mt:EntryTitle encode_html="1"$>" />'
  - []
- !!perl/array:MT::Template::Node
  - TEXT
  - "\n    "
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - EntryNext
  - {}
  -
    - !!perl/array:MT::Template::Node
      - TEXT
      - <link rel="next bookmark" href="
      - ~
      - ~
      - ~
    - !!perl/array:MT::Template::Node
      - EntryPermalink
      - {}
      - ~
      - ~
      - []
    - !!perl/array:MT::Template::Node
      - TEXT
      - '" title="'
      - ~
      - ~
      - ~
    - !!perl/array:MT::Template::Node
      - EntryTitle
      - encode_html: 1
      - ~
      - ~
      -
        -
          - encode_html
          - 1
    - !!perl/array:MT::Template::Node
      - TEXT
      - '" />'
      - ~
      - ~
      - ~
  - '<link rel="next bookmark" href="<$mt:EntryPermalink$>" title="<$mt:EntryTitle encode_html="1"$>" />'
  - []
- !!perl/array:MT::Template::Node
  - TEXT
  - "\n    "
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - EntryTrackbackData
  - {}
  - ~
  - ~
  - []
- !!perl/array:MT::Template::Node
  - TEXT
  - "\n    "
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - If
  - gt: $comments_per_page
    tag: EntryCommentCount
  -
    - !!perl/array:MT::Template::Node
      - TEXT
      - |-2
        
        	    <script type="text/javascript">
                 MT.entryID = 
      - ~
      - ~
      - ~
    - !!perl/array:MT::Template::Node
      - EntryID
      - {}
      - ~
      - ~
      - []
    - !!perl/array:MT::Template::Node
      - TEXT
      - |-
        ;
                 MT.commentsPerPage = 
      - ~
      - ~
      - ~
    - !!perl/array:MT::Template::Node
      - Var
      - name: comments_per_page
      - ~
      - ~
      - []
    - !!perl/array:MT::Template::Node
      - TEXT
      - |-
        ;
                 MT.entryCommentCount = 
      - ~
      - ~
      - ~
    - !!perl/array:MT::Template::Node
      - EntryCommentCount
      - {}
      - ~
      - ~
      - []
    - !!perl/array:MT::Template::Node
      - TEXT
      - ";\n         MT.commentIds = ["
      - ~
      - ~
      - ~
    - !!perl/array:MT::Template::Node
      - Comments
      - glue: ','
        sort_order: ascend
      -
        - !!perl/array:MT::Template::Node
          - CommentID
          - {}
          - ~
          - ~
          - []
      - '<mt:CommentID>'
      - []
    - !!perl/array:MT::Template::Node
      - TEXT
      - "];\n\t    </script>\n\t  "
      - ~
      - ~
      - ~
  - |-2
    
    	    <script type="text/javascript">
             MT.entryID = <$mt:EntryID$>;
             MT.commentsPerPage = <$mt:Var name="comments_per_page"$>;
             MT.entryCommentCount = <$mt:EntryCommentCount$>;
             MT.commentIds = [<mt:Comments sort_order="ascend" glue=","><mt:CommentID></mt:Comments>];
    	    </script>
    	  
  - []
- !!perl/array:MT::Template::Node
  - TEXT
  - "\n    <title>"
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - EntryTitle
  - encode_html: 1
  - ~
  - ~
  -
    -
      - encode_html
      - 1
- !!perl/array:MT::Template::Node
  - TEXT
  - ' - '
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - BlogName
  - encode_html: 1
  - ~
  - ~
  -
    -
      - encode_html
      - 1
- !!perl/array:MT::Template::Node
  - TEXT
  - "</title>\n</head>\n<body id=\""
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - BlogThemeID
  - {}
  - ~
  - ~
  - []
- !!perl/array:MT::Template::Node
  - TEXT
  - '" class="mt-entry-archive '
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - Var
  - name: page_layout
  - ~
  - ~
  - []
- !!perl/array:MT::Template::Node
  - TEXT
  - |-
    ">
        <div id="container">
            <div id="container-inner">
    
    
                
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - Include
  - module: バナーヘッダー
  - ~
  - ~
  - []
- !!perl/array:MT::Template::Node
  - TEXT
  - |-2
    
    
    
                <div id="content">
                    <div id="content-inner">
    
    
                        <div id="alpha">
                            <div id="alpha-inner">
    
    
                                <div id="entry-
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - EntryID
  - {}
  - ~
  - ~
  - []
- !!perl/array:MT::Template::Node
  - TEXT
  - |-
    " class="entry-asset asset hentry">
                                    <div class="asset-header">
                                        <h1 id="page-title" class="asset-name entry-title">
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - EntryTitle
  - {}
  - ~
  - ~
  - []
- !!perl/array:MT::Template::Node
  - TEXT
  - |
    </h1>
                                        <div class="asset-meta">
                                            <span class="byline">
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - If
  - tag: EntryAuthorDisplayName
  -
    - !!perl/array:MT::Template::Node
      - TEXT
      - |-2
        
                                                    <span class="vcard author">
      - ~
      - ~
      - ~
    - !!perl/array:MT::Template::Node
      - EntryAuthorLink
      - show_hcard: 1
      - ~
      - ~
      - []
    - !!perl/array:MT::Template::Node
      - TEXT
      - </span> (<abbr class="published" title="
      - ~
      - ~
      - ~
    - !!perl/array:MT::Template::Node
      - EntryDate
      - format_name: iso8601
      - ~
      - ~
      - []
    - !!perl/array:MT::Template::Node
      - TEXT
      - '">'
      - ~
      - ~
      - ~
    - !!perl/array:MT::Template::Node
      - EntryDate
      - format: '%x %X'
      - ~
      - ~
      - []
    - !!perl/array:MT::Template::Node
      - TEXT
      - "</abbr>)\n"
      - ~
      - ~
      - ~
    - !!perl/array:MT::Template::Node
      - Else
      - {}
      -
        - !!perl/array:MT::Template::Node
          - TEXT
          - |-2
            
                                                        <abbr class="published" title="
          - ~
          - ~
          - ~
        - !!perl/array:MT::Template::Node
          - EntryDate
          - format_name: iso8601
          - ~
          - ~
          - []
        - !!perl/array:MT::Template::Node
          - TEXT
          - '">'
          - ~
          - ~
          - ~
        - !!perl/array:MT::Template::Node
          - EntryDate
          - format: '%x %X'
          - ~
          - ~
          - []
        - !!perl/array:MT::Template::Node
          - TEXT
          - "</abbr>\n"
          - ~
          - ~
          - ~
      - |2
        
                                                    <abbr class="published" title="<$mt:EntryDate format_name="iso8601"$>"><$mt:EntryDate format="%x %X"$></abbr>
      - []
  - |2
    
                                                <span class="vcard author"><$mt:EntryAuthorLink show_hcard="1"$></span> (<abbr class="published" title="<$mt:EntryDate format_name="iso8601"$>"><$mt:EntryDate format="%x %X"$></abbr>)
    <mt:Else>
                                                <abbr class="published" title="<$mt:EntryDate format_name="iso8601"$>"><$mt:EntryDate format="%x %X"$></abbr>
  - []
- !!perl/array:MT::Template::Node
  - TEXT
  - |2
    
                                            </span>
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - IfCommentsActive
  - {}
  -
    - !!perl/array:MT::Template::Node
      - TEXT
      - |-2
        
                                                <span class="separator">|</span> <a href="
      - ~
      - ~
      - ~
    - !!perl/array:MT::Template::Node
      - EntryPermalink
      - {}
      - ~
      - ~
      - []
    - !!perl/array:MT::Template::Node
      - TEXT
      - '#comments">'
      - ~
      - ~
      - ~
    - !!perl/array:MT::Template::Node
      - EntryCommentCount
      - none: コメント(0)
        plural: コメント(#)
        singular: コメント(1)
      - ~
      - ~
      - []
    - !!perl/array:MT::Template::Node
      - TEXT
      - "</a>\n"
      - ~
      - ~
      - ~
  - |2
    
                                            <span class="separator">|</span> <a href="<$mt:EntryPermalink$>#comments"><$mt:EntryCommentCount singular="コメント(1)" plural="コメント(#)" none="コメント(0)"$></a>
  - []
- !!perl/array:MT::Template::Node
  - TEXT
  - "\n"
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - IfPingsActive
  - {}
  -
    - !!perl/array:MT::Template::Node
      - TEXT
      - |-2
        
                                                <span class="separator">|</span> <a href="
      - ~
      - ~
      - ~
    - !!perl/array:MT::Template::Node
      - EntryPermalink
      - {}
      - ~
      - ~
      - []
    - !!perl/array:MT::Template::Node
      - TEXT
      - '#trackbacks">'
      - ~
      - ~
      - ~
    - !!perl/array:MT::Template::Node
      - EntryTrackbackCount
      - none: トラックバック(0)
        plural: トラックバック(#)
        singular: トラックバック(1)
      - ~
      - ~
      - []
    - !!perl/array:MT::Template::Node
      - TEXT
      - "</a>\n"
      - ~
      - ~
      - ~
  - |2
    
                                            <span class="separator">|</span> <a href="<$mt:EntryPermalink$>#trackbacks"><$mt:EntryTrackbackCount singular="トラックバック(1)" plural="トラックバック(#)" none="トラックバック(0)"$></a>
  - []
- !!perl/array:MT::Template::Node
  - TEXT
  - |2
    
                                        </div>
                                    </div>
                                    <div class="asset-content entry-content">
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - If
  - tag: EntryBody
  -
    - !!perl/array:MT::Template::Node
      - TEXT
      - |-2
        
                                            <div class="asset-body">
                                                
      - ~
      - ~
      - ~
    - !!perl/array:MT::Template::Node
      - EntryBody
      - {}
      - ~
      - ~
      - []
    - !!perl/array:MT::Template::Node
      - TEXT
      - |2
        
                                            </div>
      - ~
      - ~
      - ~
  - |2
    
                                        <div class="asset-body">
                                            <$mt:EntryBody$>
                                        </div>
  - []
- !!perl/array:MT::Template::Node
  - TEXT
  - "\n"
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - If
  - convert_breaks: 0
    tag: EntryMore
  -
    - !!perl/array:MT::Template::Node
      - TEXT
      - |-2
        
                                            <div id="more" class="asset-more">
                                                
      - ~
      - ~
      - ~
    - !!perl/array:MT::Template::Node
      - EntryMore
      - {}
      - ~
      - ~
      - []
    - !!perl/array:MT::Template::Node
      - TEXT
      - |2
        
                                            </div>
      - ~
      - ~
      - ~
  - |2
    
                                        <div id="more" class="asset-more">
                                            <$mt:EntryMore$>
                                        </div>
  - []
- !!perl/array:MT::Template::Node
  - TEXT
  - |2
    
                                    </div>
                                    <div class="asset-footer">
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - IfArchiveTypeEnabled
  - archive_type: Category
  -
    - !!perl/array:MT::Template::Node
      - TEXT
      - "\n    "
      - ~
      - ~
      - ~
    - !!perl/array:MT::Template::Node
      - If
      - tag: EntryCategories
      -
        - !!perl/array:MT::Template::Node
          - TEXT
          - |-2
            
                                                <div class="entry-categories">
                                                    <h4>カテゴリ<span class="delimiter">:</span></h4>
                                                    <ul>
                                                        <li class="entry-category">
          - ~
          - ~
          - ~
        - !!perl/array:MT::Template::Node
          - EntryCategories
          - glue: '<span class="delimiter">,</span></li> <li class="entry-category">'
          -
            - !!perl/array:MT::Template::Node
              - TEXT
              - <a href="
              - ~
              - ~
              - ~
            - !!perl/array:MT::Template::Node
              - CategoryArchiveLink
              - {}
              - ~
              - ~
              - []
            - !!perl/array:MT::Template::Node
              - TEXT
              - '" rel="tag">'
              - ~
              - ~
              - ~
            - !!perl/array:MT::Template::Node
              - CategoryLabel
              - {}
              - ~
              - ~
              - []
            - !!perl/array:MT::Template::Node
              - TEXT
              - '</a>'
              - ~
              - ~
              - ~
          - '<a href="<$mt:CategoryArchiveLink$>" rel="tag"><$mt:CategoryLabel$></a>'
          - []
        - !!perl/array:MT::Template::Node
          - TEXT
          - |-
            </li>
                                                    </ul>
                                                </div>
                
          - ~
          - ~
          - ~
      - |-2
        
                                            <div class="entry-categories">
                                                <h4>カテゴリ<span class="delimiter">:</span></h4>
                                                <ul>
                                                    <li class="entry-category"><mt:EntryCategories glue='<span class="delimiter">,</span></li> <li class="entry-category">'><a href="<$mt:CategoryArchiveLink$>" rel="tag"><$mt:CategoryLabel$></a></mt:EntryCategories></li>
                                                </ul>
                                            </div>
            
      - []
    - !!perl/array:MT::Template::Node
      - TEXT
      - "\n"
      - ~
      - ~
      - ~
  - |2
    
        <mt:If tag="EntryCategories">
                                        <div class="entry-categories">
                                            <h4>カテゴリ<span class="delimiter">:</span></h4>
                                            <ul>
                                                <li class="entry-category"><mt:EntryCategories glue='<span class="delimiter">,</span></li> <li class="entry-category">'><a href="<$mt:CategoryArchiveLink$>" rel="tag"><$mt:CategoryLabel$></a></mt:EntryCategories></li>
                                            </ul>
                                        </div>
        </mt:If>
  - []
- !!perl/array:MT::Template::Node
  - TEXT
  - "\n"
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - EntryIfTagged
  - {}
  -
    - !!perl/array:MT::Template::Node
      - TEXT
      - |-2
        
                                            <div class="entry-tags">
                                                <h4>タグ<span class="delimiter">:</span></h4>
                                                <ul>
                                                    <li>
      - ~
      - ~
      - ~
    - !!perl/array:MT::Template::Node
      - EntryTags
      - glue: '<span class="delimiter">,</span></li> <li>'
      -
        - !!perl/array:MT::Template::Node
          - TEXT
          - <a href="javascript:void(0)" onclick="location.href='
          - ~
          - ~
          - ~
        - !!perl/array:MT::Template::Node
          - TagSearchLink
          - encode_js: 1
          - ~
          - ~
          -
            -
              - encode_js
              - 1
        - !!perl/array:MT::Template::Node
          - TEXT
          - "';return false;\" rel=\"tag\">"
          - ~
          - ~
          - ~
        - !!perl/array:MT::Template::Node
          - TagName
          - {}
          - ~
          - ~
          - []
        - !!perl/array:MT::Template::Node
          - TEXT
          - '</a>'
          - ~
          - ~
          - ~
      - "<a href=\"javascript:void(0)\" onclick=\"location.href='<$mt:TagSearchLink encode_js=\"1\"$>';return false;\" rel=\"tag\"><$mt:TagName$></a>"
      - []
    - !!perl/array:MT::Template::Node
      - TEXT
      - |
        </li>
                                                </ul>
                                            </div>
      - ~
      - ~
      - ~
  - |2
    
                                        <div class="entry-tags">
                                            <h4>タグ<span class="delimiter">:</span></h4>
                                            <ul>
                                                <li><mt:EntryTags glue='<span class="delimiter">,</span></li> <li>'><a href="javascript:void(0)" onclick="location.href='<$mt:TagSearchLink encode_js="1"$>';return false;" rel="tag"><$mt:TagName$></a></mt:EntryTags></li>
                                            </ul>
                                        </div>
  - []
- !!perl/array:MT::Template::Node
  - TEXT
  - |-2
    
                                    </div>
                                </div>
    
    
                        
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - Include
  - module: トラックバック
  - ~
  - ~
  - []
- !!perl/array:MT::Template::Node
  - TEXT
  - "\n                    "
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - Include
  - module: コメント
  - ~
  - ~
  - []
- !!perl/array:MT::Template::Node
  - TEXT
  - |-2
    
    
    
                            </div>
                        </div>
    
    
                        
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - Include
  - module: サイドバー
  - ~
  - ~
  - []
- !!perl/array:MT::Template::Node
  - TEXT
  - |-2
    
    
    
                    </div>
                </div>
    
    
                
  - ~
  - ~
  - ~
- !!perl/array:MT::Template::Node
  - Include
  - module: バナーフッター
  - ~
  - ~
  - []
- !!perl/array:MT::Template::Node
  - TEXT
  - |2
    
    
    
            </div>
        </div>
    </body>
    </html>
  - ~
  - ~
  - ~
