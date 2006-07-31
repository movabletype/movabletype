# Original Copyright 2001-2002 Jay Allen.
# Modifications and integration Copyright 2001-2006 Six Apart.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

## todo:
## optimize by combining query into a compiled sub

package MT::App::Search;
use strict;

use File::Spec;
use MT::Util qw( encode_html );

use MT::App;
@MT::App::Search::ISA = qw( MT::App );

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->add_methods( search => \&execute );
    $app->{default_mode} = 'search';
    $app;
}

sub init_request{
    my $app = shift;
    $app->SUPER::init_request(@_);

    foreach (qw(searchparam templates search_string results
                user __have_throttle)) {
        delete $app->{$_} if exists $app->{$_}
    }

    my $q = $app->param;
    my $cfg = $app->config;

    my $tag = $q->param('tag') || '';
    $app->param('Type', 'tag') if $tag;
    $app->param('search', $tag) if $tag;
    my $blog_id = $q->param('blog_id') || '';
    my $include_blog_id = $q->param('IncludeBlogs') || '';

    unless ($include_blog_id){
        $app->param('IncludeBlogs', $blog_id) if $blog_id;
    }

    ## Check whether IP address has searched in the last
    ## minute which is still progressing. If so, block it.
    return $app->error($app->translate(
        "You are currently performing a search. Please wait " .
        "until your search is completed.")) unless $app->throttle_control();

    my %no_override = map { $_ => 1 } split /\s*,\s*/, $cfg->NoOverride;

    ## Combine user-selected included/excluded blogs
    ## with config file settings.
    for my $type (qw( IncludeBlogs ExcludeBlogs )) {
        $app->{searchparam}{$type} = { };
        if (my $list = $cfg->$type()) {
            $app->{searchparam}{$type} =
                { map { $_ => 1 } split /\s*,\s*/, $list };
        }
        next if $no_override{$type};
        for my $blog_id ($q->param($type)) {
            if ($blog_id =~ m/,/) {
                my @ids = split /,/, $blog_id;
                $app->{searchparam}{$type}{$_} = 1 for @ids;
            } else {
                $app->{searchparam}{$type}{$blog_id} = 1;
            }
        }
    }

    ## If IncludeBlogs has not been set, we need to build a list of
    ## the blogs to search. If ExcludeBlogs was set, exclude any blogs
    ## set in that list from our final list.
    if (!keys %{ $app->{searchparam}{IncludeBlogs} }) {
        my $exclude = $app->{searchparam}{ExcludeBlogs};
        require MT::Blog;
        my $iter = MT::Blog->load_iter;
        while (my $blog = $iter->()) {
            $app->{searchparam}{IncludeBlogs}{$blog->id} = 1
                unless $exclude && $exclude->{$blog->id};
        }
    }

    ## Set other search params--prefer per-query setting, default to
    ## config file.
    for my $key (qw( RegexSearch CaseSearch ResultDisplay SearchCutoff
                     CommentSearchCutoff ExcerptWords SearchElement
                     Type MaxResults SearchSortBy )) {
        $app->{searchparam}{$key} = $no_override{$key} ?
            $cfg->$key() : ($q->param($key) || $cfg->$key());
    }
    $app->{searchparam}{Template} = $q->param('Template') ||
        ($app->{searchparam}{Type} eq 'newcomments' ? 'comments' : 'default');

    ## Define alternate user templates from config file
    if (my @tmpls = $cfg->AltTemplate) {
        for my $tmpl (@tmpls) {
            next unless defined $tmpl;
            my($nickname, $file) = split /\s+/, $tmpl;
            $app->{templates}{$nickname} = $file;
        }
    }

    $app->{templates}{default} = $cfg->DefaultTemplate;
    $app->{searchparam}{SearchTemplatePath} = $cfg->SearchTemplatePath;

    ## Set search_string (for display only)
    if ($app->{searchparam}{Type} eq 'straight') {
        $app->{search_string} = $q->param('search') || '';
    } elsif ($app->{searchparam}{Type} eq 'tag') {
        $app->{search_string} = $q->param('search') || '';
    }

    ## Get login information if user is logged in (via cookie).
    ## If no login cookie, this fails silently, and that's fine.
    ($app->{user}) = $app->login;
}

sub throttle_control {
    my $app = shift;

    my $type = $app->param('Type') || '';

    # Don't throttle tag listings
    return 1 if $type eq 'tag';

    my $ip = $app->remote_ip;
    my $whitelist = $app->config('SearchThrottleIPWhitelist');
    if ($whitelist) {
        # check for $ip in $whitelist
        my @list = split /(\s*[,;]\s*|\s+)/, $whitelist;
        foreach (@list) {
            next unless $_ =~ m/^\d{1,3}(\.\d{0,3}){0,3}$/;
            if (($ip eq $_) || ($ip =~ m/^\Q$_\E/)) {
                return 1;
            }
        }
    }

    if (eval { require DB_File; 1 }) {
        my $file = File::Spec->catfile($app->config('TempDir'), 'mt-throttle.db');
        my $DB = tie my %db, 'DB_File', $file;
        if ($DB) {
            if (my $time = $db{$ip}) {
                if ($time > time - $app->config('ThrottleSeconds')) {
                    return 0;
                }
            }
            $db{$ip} = time;
            undef $DB;
            untie %db;
            $app->{__have_throttle} = 1;
        }
    }

    1;
}

sub takedown {
    my $app = shift;
    if ($app->{__have_throttle}) {
        my $file = File::Spec->catfile($app->config('TempDir'),
                                       'mt-throttle.db');
        if (tie my %db, 'DB_File', $file) {
            my $time = $db{$app->remote_ip};
            delete $db{$app->remote_ip} if ($time && $time < (time - $app->config('ThrottleSeconds')));
            untie %db;
        }
    }
    $app->SUPER::takedown(@_);
}

sub execute {
    my $app = shift;
    return $app->error($app->errstr) if $app->errstr;

    my @results;
    if ($app->{searchparam}{RegexSearch}) {
        eval { m/$app->{search_string}/ };
        return $app->error($app->translate("Search failed. Invalid pattern given: [_1]", $@))
            if $@;
    }
    if ($app->{searchparam}{Type} eq 'newcomments') {
        $app->_new_comments
            or return $app->error($app->translate(
                "Search failed: [_1]", $app->errstr));
        @results = $app->{results} ? @{ $app->{results} } : ();
    } elsif ($app->{searchparam}{Type} eq 'tag') {
        $app->_tag_search
            or return $app->error($app->translate(
                "Search failed: [_1]", $app->errstr));
        my $col = $app->{searchparam}{SearchSortBy};
        my $order = $app->{searchparam}{ResultDisplay} || 'ascend';
        for my $blog (sort keys %{ $app->{results} }) {
            my @res = @{ $app->{results}{$blog} };
            if ($col) {
                @res = $order eq 'ascend' ?
                  sort { $a->{entry}->$col() cmp $b->{entry}->$col() } @res :
                  sort { $b->{entry}->$col() cmp $a->{entry}->$col() } @res;
            }
            $res[0]{blogheader} = 1;
            my $max = $#res;
            $res[$max]{blogfooter} = 1;
            push @results, @res;
        }
    } else {
        $app->_straight_search
            or return $app->error($app->translate(
                "Search failed: [_1]", $app->errstr));
        ## Results are stored per-blog, so we sort the list of blogs by name,
        ## then add in the results to the final list.
        my $col = $app->{searchparam}{SearchSortBy};
        my $order = $app->{searchparam}{ResultDisplay} || 'ascend';
        for my $blog (sort keys %{ $app->{results} }) {
            my @res = @{ $app->{results}{$blog} };
            if ($col) {
                @res = $order eq 'ascend' ?
                  sort { $a->{entry}->$col() cmp $b->{entry}->$col() } @res :
                  sort { $b->{entry}->$col() cmp $a->{entry}->$col() } @res;
            }
            $res[0]{blogheader} = 1;
            my $max = $#res;
            $res[$max]{blogfooter} = 1;
            push @results, @res;
        }
    }

    ## We need to put a blog in context so that includes and <$MTBlog*$>
    ## tags will work, if they are used. So we choose the first blog in
    ## the result list. If there is no result list, just load the first
    ## blog from the database.
    my($blog);
    if (@results) {
        $blog = $results[0]{blog};
    }
    my $include;
    unless ($blog) {
        $include = $app->{searchparam}{IncludeBlogs};
        if ($include && keys(%$include) == 1) {
            $blog = MT::Blog->load((keys %$include)[0]);
        } else {
            $blog = MT::Blog->load;
        }
    }

    if (!$include || ($include && !%$include)) {
        $include = { $blog->id => 1 };
    } else {
        my $self_blog_id = $app->param('blog_id');
        if ($self_blog_id) {
            $include = { $blog->id => $self_blog_id };
        } else {
            $include = { $blog->id => 1 };
        }
    }

    ## Initialize and set up the context object.
    my $ctx = MT::App::Search::Context->new;
    my $include_blog = $app->{searchparam}{IncludeBlogs};
    $ctx->stash('blog', $blog);
    $ctx->stash('blog_id', $blog->id);
    $ctx->stash('results', \@results);
    $ctx->stash('user', $app->{user});
    $ctx->stash('include_blogs', join ',', keys %$include_blog);
    if (my $str = $app->{search_string}) {
        $ctx->stash('search_string', encode_html($str));
    }
    $ctx->stash('template_id', $app->{searchparam}{Template});

    my $str;
    if ($include_blog && keys(%$include_blog) == 1) {
        if ($app->{searchparam}{Template} eq 'default') {
            # look for a 'search_template'
            my ($blog_id) = keys %$include;
            require MT::Template;
            my $tmpl = MT::Template->load({blog_id => $blog_id, type => 'search_template'});
            $str = $tmpl->text if $tmpl;
        }
    }

    if (!$str) {
        ## Load the search template.
        my $tmpl_file = $app->{templates}{ $app->{searchparam}{Template} }
            or return $app->error($app->translate("No alternate template is specified for the Template '[_1]'", $app->{searchparam}{Template}));
        my $tmpl = File::Spec->catfile($app->{searchparam}{SearchTemplatePath},
            $tmpl_file);
        local *FH;
        open FH, $tmpl
            or return $app->error($app->translate(
                "Opening local file '[_1]' failed: [_2]", $tmpl, "$!" ));

        { local $/; $str = <FH> };
        close FH;
    }
    $str = $app->translate_templatized($str);

    ## Compile and build the search template with results.
    require MT::Builder;
    my $build = MT::Builder->new;
    my $tokens = $build->compile($ctx, $str)
        or return $app->error($app->translate(
            "Building results failed: [_1]", $build->errstr));
    defined(my $res = $build->build($ctx, $tokens, { 
        NoSearch => $app->{query}->param('help') ||
                    ($app->{searchparam}{Type} ne 'newcomments' &&
                      (!$ctx->stash('search_string') ||
                      $ctx->stash('search_string') !~ /\S/)) ? 1 : 0,
        IfTagSearch => ($app->{searchparam}{Type} eq 'tag'),
        IfStraightSearch => ($app->{searchparam}{Type} eq 'straight'),
        NoSearchResults => $ctx->stash('search_string') &&
                           $ctx->stash('search_string') =~ /\S/ &&
                           !scalar @results,
        SearchResults => scalar @results,
        } ))
        or return $app->error($app->translate(
            "Building results failed: [_1]", $build->errstr));
    $res = $app->_set_form_elements($res);
    if (defined($ctx->stash('content_type'))) {
        $app->{no_print_body} = 1;
        $app->send_http_header($ctx->stash('content_type'));
        $app->print($res);
    }
    $res;
}

sub _tag_search {
    my $app = shift;
    return 1 unless $app->{search_string} =~ /\S/;

    # since this technically isn't a search, but a dynamic view
    # of data, suppress logging...
    #require MT::Log;
    #$app->log({
    #    message => $app->translate("Search: query for '[_1]'",
    #          $app->{search_string}),
    #    level => MT::Log::INFO(),
    #    class => 'search',
    #    category => 'tag_search',
    #    metadata => $app->{search_string}
    #});

    my %terms = (status => MT::Entry::RELEASE());
    my %args = (direction => $app->{searchparam}{ResultDisplay},
        'sort' => 'created_on');

    require MT::Tag;
    require MT::ObjectTag;
    my $tags = $app->{search_string};
    my @tag_names = MT::Tag->split(',', $tags);
    my %tags = map { $_ => 1, MT::Tag->normalize($_) => 1 } @tag_names;
    my @tags = MT::Tag->load({ name => [ keys %tags ] });
    my @tag_ids;
    foreach (@tags) {
        push @tag_ids, $_->id;
        my @more = MT::Tag->load({ n8d_id => $_->n8d_id ? $_->n8d_id : $_->id });
        push @tag_ids, $_->id foreach @more;
    }
    @tag_ids = ( 0 ) unless @tags;
    $args{'join'} = ['MT::ObjectTag', 'object_id',
        { tag_id => \@tag_ids, object_datasource => MT::Entry->datasource }, { unique => 1 } ];

    ## Load available blogs and iterate through entries looking for search term
    require MT::Util;
    require MT::Blog;
    require MT::Entry;

    if ($app->{searchparam}{SearchCutoff} &&
        $app->{searchparam}{SearchCutoff} != 9999999) {
        my @ago = MT::Util::offset_time_list(time - 3600 * 24 *
            $app->{searchparam}{SearchCutoff});
        my $ago = sprintf "%04d%02d%02d%02d%02d%02d",
            $ago[5]+1900, $ago[4]+1, @ago[3,2,1,0];
        $terms{created_on} = [ $ago ];
        $args{range} = { created_on => 1 };
    }

    if (keys %{ $app->{searchparam}{IncludeBlogs} }) {
        $terms{blog_id} = [ keys %{ $app->{searchparam}{IncludeBlogs} } ];
    }
    my $iter = MT::Entry->load_iter(\%terms, \%args);
    my(%blogs, %hits);
    my $max = $app->{searchparam}{MaxResults}; 
    while (my $entry = $iter->()) {
        my $blog_id = $entry->blog_id;
        next if $hits{$blog_id} && $hits{$blog_id} >= $max;
        if ($app->_search_hit($entry)) {
            my $blog = $blogs{$blog_id} || MT::Blog->load($blog_id);
            $app->_store_hit_data($blog, $entry, $hits{$blog_id}++);
        }
    }
    1;
}

sub _straight_search {
    my $app = shift;
    return 1 unless $app->{search_string} =~ /\S/;

    ## Parse, tokenize and optimize the search query.
    $app->query_parse;

    ## Load available blogs and iterate through entries looking for search term
    require MT::Util;
    require MT::Blog;
    require MT::Entry;

    my %terms = (status => MT::Entry::RELEASE());
    my %args = (direction => $app->{searchparam}{ResultDisplay},
                'sort' => 'created_on');
    if ($app->{searchparam}{SearchCutoff} &&
        $app->{searchparam}{SearchCutoff} != 9999999) {
        my @ago = MT::Util::offset_time_list(time - 3600 * 24 *
                  $app->{searchparam}{SearchCutoff});
        my $ago = sprintf "%04d%02d%02d%02d%02d%02d",
            $ago[5]+1900, $ago[4]+1, @ago[3,2,1,0];
        $terms{created_on} = [ $ago ];
        $args{range} = { created_on => 1 };
    }

    if (keys %{ $app->{searchparam}{IncludeBlogs} }) {
        $terms{blog_id} = [ keys %{ $app->{searchparam}{IncludeBlogs} } ];
    }

    my $blog_id;
    if ($terms{blog_id} && (scalar(@{ $terms{blog_id} }) == 1)) {
        $blog_id = $terms{blog_id}[0];
    }

    require MT::Log;
    $app->log({
        message => $app->translate("Search: query for '[_1]'",
              $app->{search_string}),
        level => MT::Log::INFO(),
        class => 'search',
        category => 'straight_search',
        metadata => $app->{search_string},
        $blog_id ? (blog_id => $blog_id) : ()
    });

    my $iter = MT::Entry->load_iter(\%terms, \%args);
    my(%blogs, %hits);
    my $max = $app->{searchparam}{MaxResults}; 
    while (my $entry = $iter->()) {
        my $blog_id = $entry->blog_id;
        next if $hits{$blog_id} && $hits{$blog_id} >= $max;
        if ($app->_search_hit($entry)) {
            my $blog = $blogs{$blog_id} || MT::Blog->load($blog_id);
            $app->_store_hit_data($blog, $entry, $hits{$blog_id}++);
        }
    }
    1;
}

sub _new_comments {
    my $app = shift;
    return 1 if $app->param('help');

    require MT::Log;
    $app->log({
        message => $app->translate("Search: new comment search"),
        level => MT::Log::INFO(),
        class => 'search',
        category => 'comment_search'
    });
    require MT::Entry;
    require MT::Blog;
    require MT::Util;
    my %args = ('join' => [
                    'MT::Comment', 'entry_id', { visible => 1 },
                    { 'sort' => 'created_on',
                       direction => 'descend',
                       unique => 1, }
               ]);
    if ($app->{searchparam}{CommentSearchCutoff} &&
        $app->{searchparam}{CommentSearchCutoff} != 9999999) {
        my @ago = MT::Util::offset_time_list(time - 3600 * 24 *
                  $app->{searchparam}{CommentSearchCutoff});
        my $ago = sprintf "%04d%02d%02d%02d%02d%02d",
            $ago[5]+1900, $ago[4]+1, @ago[3,2,1,0];
        $args{'join'}->[2]{created_on} = [ $ago ];
        $args{'join'}->[3]{range} = { created_on => 1 };
    } elsif ($app->{searchparam}{MaxResults} &&
             $app->{searchparam}{MaxResults} != 9999999) {
        $args{limit} = $app->{searchparam}{MaxResults};
    }
    my $iter = MT::Entry->load_iter({ status => MT::Entry::RELEASE() }, \%args);
    my %blogs;
    my $include = $app->{searchparam}{IncludeBlogs};
    while (my $entry = $iter->()) {
        next unless $include->{ $entry->blog_id };
        my $blog = $blogs{ $entry->blog_id } || MT::Blog->load($entry->blog_id);
        $app->_store_hit_data($blog, $entry);
    }
    1;
}

sub _set_form_elements {
    my($app, $tmpl) = @_;
    ## Fill in user-defined template with proper form settings.
    if ($app->{searchparam}{Type} eq 'newcomments') {
        if ($app->{searchparam}{CommentSearchCutoff}) {
            $tmpl =~ s/(<select name="CommentSearchCutoff">.*<option value="$app->{searchparam}{CommentSearchCutoff}")/$1 selected="selected"/si;
        } else {
            $tmpl =~ s/(<select name="CommentSearchCutoff">.*<option value="9999999")/$1 selected="selected"/si;
        }
    } else {
        if ($app->{searchparam}{SearchCutoff}) {
            $tmpl =~ s/(<select name="SearchCutoff">.*<option value="$app->{searchparam}{SearchCutoff}")/$1 selected="selected"/si;
        } else {
            $tmpl =~ s/(<select name="SearchCutoff">.*<option value="9999999")/$1 selected="selected"/si;
        }

        if ($app->{searchparam}{CaseSearch}) {
            $tmpl =~ s/(<input type="checkbox"[^>]+name="CaseSearch")/$1 checked="checked"/g;
        }
        if ($app->{searchparam}{RegexSearch}) {
            $tmpl =~ s/(<input type="checkbox"[^>]+name="RegexSearch")/$1 checked="checked"/g;
        }
        $tmpl =~ s/(<input type="radio"[^>]+?$app->{searchparam}{SearchElement}\")/$1 checked="checked"/g;
        for my $type (qw( IncludeBlogs ExcludeBlogs )) {
            for my $blog_id (keys %{ $app->{searchparam}{$type} }) {
                $tmpl =~ s/(<input type="checkbox"[^>]+?$type" value="$blog_id")/$1 checked="checked"/g;    #"
            }
        }
    }
    if ($app->{searchparam}{MaxResults}) {
        $tmpl =~ s/(<select name="MaxResults">.*<option value="$app->{searchparam}{MaxResults}")/$1 selected="selected"/si;
    } else {
        $tmpl =~ s/(<select name="MaxResults">.*<option value="9999999")/$1 selected="selected"/si;
    }
    $tmpl;
}

sub is_a_match { 
    my($app, $txt) = @_;
    use utf8;
    $txt = MT::I18N::decode_utf8($txt);
    my $keyword = MT::I18N::decode_utf8($app->{search_string});

    if ($app->{searchparam}{RegexSearch}) {
        if ($app->{searchparam}{CaseSearch}) {
            return unless $txt =~ m/$keyword/;
        } else {
            return unless $txt =~ m/$keyword/i;
        }
    } else {
        my $casemod = $app->{searchparam}{CaseSearch} ? '' : '(?i)';
        for (@{$app->{searchparam}{search_keys}{AND}}) {
            return unless $txt =~ /$casemod$_/;
    }
    for (@{$app->{searchparam}{search_keys}{NOT}}) {
            return if $txt =~ /$casemod$_/;
        }
    }
    1;
}       

sub query_parse {
    my $app = shift;
    return unless $app->{search_string};
    use utf8;
    local $_ = MT::I18N::decode_utf8($app->{search_string});

    s/^\s//;            # Remove leading whitespace
    s/\s$//;            # Remove trailing whitespace
    s/\s+AND\s+/ /g;    # Remove AND because it's implied
    s/\s{2,}/ /g;       # Remove contiguous spaces

    my @search_keys;
    my @tokens = split;
    while (my $atom = shift @tokens) {
        my($type);
        if ($atom eq 'NOT' || $atom eq 'AND') {
            $type = $atom;
            $atom = shift @tokens;
            $atom = find_phrase($atom, \@tokens) if $atom =~ /^\"/;
        } elsif ($atom eq 'OR') {
            $atom = shift @tokens;
            $atom = find_phrase($atom, \@tokens) if $atom =~ /^\"/;
            ## OR new atom with last atom
            $search_keys[-1]{atom} =
                '(?:' . $search_keys[-1]{atom} .'|' . quotemeta($atom) . ')';
            next;
        } elsif ($atom =~ /^-(.*)/) {
            $type = 'NOT';
            $atom = $1;
            $atom = find_phrase($atom, \@tokens) if $atom =~ /^\"/;
        } else {
            $type = 'AND';
            $atom = find_phrase($atom, \@tokens) if $atom =~ /^\"/;
        }
        push @search_keys, { atom => quotemeta($atom),
                             type => $type };
    }

    $app->{searchparam}{search_keys} = \@search_keys;
    $app->query_optimize;
}

sub find_phrase {
    my($atom, $tokenref) = @_;
    while (my $next = shift @$tokenref) {
        $atom = $atom . ' ' . $next;
        last if $atom =~ /\"$/;
    }
    $atom =~ s/^"(.*)"$/$1/;
    $atom;
}

sub query_optimize {
    my $app = shift;

    ## Sort keys longest to shortest for search efficiency.
    $app->{searchparam}{search_keys} = [
        reverse sort { length($a->{atom}) <=> length($b->{atom}) }
        @{ $app->{searchparam}{search_keys} }
    ];
    
    ## Sort keys by contents. Any ORs immediately get a lower priority.
    my %terms;
    for my $key (@{ $app->{searchparam}{search_keys} }) {
        if ($key->{atom} =~ /\(.*\|.*\)/) {
            push(@{ $terms{$key->{type}}{low} }, $key);
        } else {
            push(@{ $terms{$key->{type}}{high} }, $key);
        }
    }

    ## Final priority: AND long, AND short, AND with OR (long/short),
    ## NOT long/short
    ##  This should give us the most efficient search in that it is
    ##  searching for the harder-to-match keys first.
    my %regex;
    for my $type (qw( AND NOT )) {
        for my $pri (qw( high low )) {
            for my $obj (@{ $terms{$type}{$pri} }) {
                push(@{ $regex{$type} }, $obj->{atom});
            }
        }
    }

    $app->{searchparam}{search_keys} = \%regex;
}


sub _search_hit {
    my($app, $entry) = @_;
    my @text_elements;
    if ($app->{searchparam}{SearchElement} ne 'comments') {
        @text_elements = ($entry->title, $entry->text, $entry->text_more,
                          $entry->keywords);
    }
    if ($app->{searchparam}{SearchElement} ne 'entries') {
        my $comments = $entry->comments;
        for my $comment (@$comments) {
            push @text_elements, $comment->text, $comment->author,
                                 $comment->url;
        }
    }
    return 1 if $app->is_a_match(join("\n", map $_ || '', @text_elements));
}

sub _store_hit_data {
    my $app = shift;
    my($blog, $entry, $banner_seen) = @_;
    my %result_data = (blog => $blog);
    ## Need to create entry excerpt here, because we can't rely on
    ## the user's per-blog setting.
    unless ($entry->excerpt) {
        $entry->excerpt($entry->get_excerpt($app->{searchparam}{ExcerptWords}));
    }
    $result_data{entry} = $entry;
    if ($app->{searchparam}{Type} eq 'newcomments') {
        push @{ $app->{results} }, \%result_data;
    } else {
        push(@{ $app->{results}{ $blog->name } }, \%result_data);
    }
}


package MT::App::Search::Context;
use MT::Template::Context;
@MT::App::Search::Context::ISA = qw( MT::Template::Context );

sub init {
    my $ctx = shift;
    $ctx->SUPER::init(@_);
    $ctx->register_handler(EntryEditLink => \&_hdlr_entry_edit_link);
    $ctx->register_handler(IfTagSearch =>
        [ \&MT::Template::Context::_hdlr_pass_tokens, 1 ]);
    $ctx->register_handler(IfStraightSearch =>
        [ \&MT::Template::Context::_hdlr_pass_tokens, 1 ]);
    $ctx->register_handler(SearchResults => [ \&_hdlr_results, 1 ]);
    $ctx->register_handler(SearchResultCount => \&_hdlr_result_count);
    $ctx->register_handler(SearchString => \&_hdlr_search_string);
    $ctx->register_handler(NoSearchResults =>
        [ \&MT::Template::Context::_hdlr_pass_tokens, 1 ]);
    $ctx->register_handler(NoSearch =>
        [ \&MT::Template::Context::_hdlr_pass_tokens, 1 ]);
    $ctx->register_handler(BlogResultHeader =>
        [ \&MT::Template::Context::_hdlr_pass_tokens, 1 ]);
    $ctx->register_handler(BlogResultFooter =>
        [ \&MT::Template::Context::_hdlr_pass_tokens, 1 ]);
    $ctx->register_handler(SearchIncludeBlogs => \&_hdlr_include_blogs);
    $ctx->register_handler(SearchTemplateID => \&_hdlr_template_id);
    $ctx;
}

sub _hdlr_include_blogs { $_[0]->stash('include_blogs') || '' }
sub _hdlr_search_string { $_[0]->stash('search_string') || '' }
sub _hdlr_template_id { $_[0]->stash('template_id') || '' }


sub _hdlr_result_count {
    my $results = $_[0]->stash('results');
    $results && ref($results) eq 'ARRAY' ? scalar @$results : 0;
}

sub _hdlr_results {
    my($ctx, $args, $cond) = @_;

    ## If there are no results, return the empty string, knowing
    ## that the handler for <MTNoSearchResults> will fill in the
    ## no results message.
    my $results = $ctx->stash('results') or return '';

    my $output = '';
    my $build = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    for my $res (@$results) {
        $ctx->stash('entry', $res->{entry});
        local $ctx->{__stash}{blog} = $res->{blog};
        $ctx->stash('result', $res);
        local $ctx->{current_timestamp} = $res->{entry}->created_on;
        defined(my $out = $build->build($ctx, $tokens,
            { %$cond, BlogResultHeader => $res->{blogheader} ? 1 : 0, BlogResultFooter => $res->{blogfooter} ? 1 : 0 }
            )) or return $ctx->error( $build->errstr );
        $output .= $out;
    }
    $output;
}

sub _hdlr_entry_edit_link {   
    my($ctx, $args) = @_;
    my $user = $ctx->stash('user') or return '';
    my $entry = $ctx->stash('entry')
        or return $ctx->error(MT->translate(
            'You used an [_1] tag outside of the proper context.',
            '<$MTEntryEditLink$>' ));
    my $blog_id = $entry->blog_id;
    my $cfg = MT::ConfigMgr->instance;
    my $url = $cfg->AdminCGIPath || $cfg->CGIPath;
    $url .= '/' unless $url =~ m!/$!;
    require MT::Permission;
    my $perms = MT::Permission->load({ author_id => $user->id,
                                       blog_id => $blog_id });
    return '' unless $perms && $perms->can_edit_entry($entry, $user);
    my $app = MT->instance;
    my $edit_text = $args->{text} || $app->translate("Edit");
    sprintf
        q([<a href="%s%s%s">%s</a>]),
        $url,
        $cfg->AdminScript,
        $app->uri_params('mode' => 'view',
            args => {'_type' => 'entry', id => $entry->id, blog_id => $blog_id}),
        $edit_text;
}

1;
