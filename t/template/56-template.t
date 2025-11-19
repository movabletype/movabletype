#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Template;
use MT::Template::Node ':constants';
MT->instance;

subtest 'getElementsByTagName' => sub {
    my $tmpl = MT::Template->new_string( \<<__TMPL__);
    <mt:setvar name="foo" value="foo_value">
    <mt:setvar name="bar" value="bar_value">

    <mt:if name="foo">
      <mt:if name="bar">
        <mt:var name="foo">

        Contents

        <mt:var name="bar">
        <mt:include name="include/actions_bar.tmpl">
      </mt:if>
    </mt:if>

    <mt:var name="bar">
__TMPL__

    my %map = (
        'setvar'  => 2,
        'var'     => 3,
        'unknown' => undef,
    );

    for my $tag ( sort keys %map ) {
        my $expected = $map{$tag};
        my $elms     = $tmpl->getElementsByTagName($tag);
        if ( defined($expected) ) {
            is( scalar @$elms, $expected, qq(for "$tag" is $expected) );
        }
        else {
            is( $elms, undef, qq(for "$tag" is undef) );
        }
    }
};

subtest 'getElementsByClassName' => sub {
    my $tmpl = MT::Template->new_string( \<<__TMPL__);
    <mtapp:statusmsg id="generic-error" class="error">Error</mtapp:statusmsg>
    <mtapp:statusmsg id="saved" class="success">Saved</mtapp:statusmsg>
    <mtapp:statusmsg id="deleted" class="success">Deleted</mtapp:statusmsg>

    <mt:if name="foo">
      <mt:if name="bar">
        <mtapp:statusmsg id="changed" class="success">Changed</mtapp:statusmsg>
        <mtapp:statusmsg id="not_found" class="error">Not Found</mtapp:statusmsg>
      </mt:if>
    </mt:if>
__TMPL__

    my %map = (
        'success' => 3,
        'error'   => 2,
        'unknown' => undef,
    );

    for my $class ( sort keys %map ) {
        my $expected = $map{$class};
        my @elms     = $tmpl->getElementsByClassName($class);
        if ( defined($expected) ) {
            is( scalar @elms, $expected, qq(for "$class" is $expected) );
        }
        else {
            is( scalar @elms, 0, qq(for "$class" is 0) );
        }
    }
};

subtest 'getElementsByName' => sub {
    my $tmpl = MT::Template->new_string( \<<__TMPL__);
    <mt:include name="include/header.tmpl" />

    <mt:if name="foo">
      <mt:if name="bar">
        <mt:include name="include/actions_bar.tmpl" />

        Contents

        <mt:include name="include/actions_bar.tmpl" />
      </mt:if>
    </mt:if>

    <mt:include name="include/footer.tmpl" />
__TMPL__

    my %map = (
        'include/header.tmpl'      => 1,
        'include/actions_bar.tmpl' => 2,
        'not_included'             => undef,
    );

    for my $name ( sort keys %map ) {
        my $expected = $map{$name};
        my $elms     = $tmpl->getElementsByName($name);
        if ( defined($expected) ) {
            is( scalar @$elms, $expected, qq(for "$name" is $expected) );
        }
        else {
            is( $elms, undef, qq(for "$name" is undef) );
        }
    }
};

subtest 'getElementById' => sub {
    my $tmpl = MT::Template->new_string( \<<__TMPL__);
    <mt:setvarblock id="header" name="header"></mt:setvarblock>
    <mt:if name="foo">
      <mt:if name="bar">
        <mt:setvarblock id="content" name="content">
          Content
        </mt:setvarblock>
      </mt:if>
    </mt:if>
    <mt:setvarblock id="footer" name="footer"></mt:setvarblock>
__TMPL__

    my %map = (
        'header'  => 1,
        'footer'  => 1,
        'content' => 1,
        'unknown' => undef,
    );

    for my $id ( sort keys %map ) {
        my $expected = $map{$id};
        my $elm      = $tmpl->getElementById($id);
        if ($expected) {
            ok( $elm && (ref $elm eq 'MT::Template::Node'), qq(for "$id" is a node) );
        }
        else {
            ok( !$elm, qq(for "$id" is undef) );
        }
    }
};

subtest 'insertAfter' => sub {
    my $tmpl = MT::Template->new_string( \<<__TMPL__);
    <mt:setvarblock name="foo">
      <div>Foo</div>
    </mt:setvarblock>
    <mt:setvarblock name="bar">
      <div>Bar
      <mt:if name="foo">
        <mt:setvarblock name="inside_bar">
          <div>Inside Bar</div>
        </mt:setvarblock>
        <mt:var id="inside_bar" name="inside_bar">
      </mt:if>
      </div>
    </mt:setvarblock>
    <mt:setvarblock name="baz">
      <div>Baz</div>
    </mt:setvarblock>
    <mt:var name="foo">
    <mt:var id="bar" name="bar">
    <mt:var name="baz">
__TMPL__

    subtest 'insert into the top' => sub {
        ok my $new  = $tmpl->createTextNode('<div>First</div>'), 'created a node';
        ok my $node = $tmpl->getElementById('bar'), 'found a node';
        ok $tmpl->insertAfter($new, $node), "insertAfter succeeds";
        my $html = $tmpl->output;
        $html =~ s/\s//gs;
        is $html => '<div>Foo</div><div>Bar<div>InsideBar</div></div><div>First</div><div>Baz</div>', 'new node is inserted';
    };

    subtest 'insert into a child' => sub {
        ok my $new  = $tmpl->createTextNode('<div>Second</div>'), 'created a node';
        ok my $node = $tmpl->getElementById('inside_bar'), 'found a node';
        ok $tmpl->insertAfter($new, $node), "insertAfter succeeds";
        my $html = $tmpl->output;
        $html =~ s/\s//gs;
        is $html => '<div>Foo</div><div>Bar<div>InsideBar</div><div>Second</div></div><div>First</div><div>Baz</div>', 'new node is inserted';
    }
};

subtest 'insertBefore' => sub {
    my $tmpl = MT::Template->new_string( \<<__TMPL__);
    <mt:setvarblock name="foo">
      <div>Foo</div>
    </mt:setvarblock>
    <mt:setvarblock name="bar">
      <div>Bar
      <mt:if name="foo">
        <mt:setvarblock name="inside_bar">
          <div>Inside Bar</div>
        </mt:setvarblock>
        <mt:var id="inside_bar" name="inside_bar">
      </mt:if>
      </div>
    </mt:setvarblock>
    <mt:setvarblock name="baz">
      <div>Baz</div>
    </mt:setvarblock>
    <mt:var name="foo">
    <mt:var id="bar" name="bar">
    <mt:var name="baz">
__TMPL__

    subtest 'insert into the top' => sub {
        ok my $new  = $tmpl->createTextNode('<div>First</div>'), 'created a node';
        ok my $node = $tmpl->getElementById('bar'), 'found a node';
        ok $tmpl->insertBefore($new, $node), "insertBefore succeeds";
        my $html = $tmpl->output;
        $html =~ s/\s//gs;
        is $html => '<div>Foo</div><div>First</div><div>Bar<div>InsideBar</div></div><div>Baz</div>', 'new node is inserted';
    };

    subtest 'insert into a child' => sub {
        ok my $new  = $tmpl->createTextNode('<div>Second</div>'), 'created a node';
        ok my $node = $tmpl->getElementById('inside_bar'), 'found a node';
        ok $tmpl->insertBefore($new, $node), "insertBefore succeeds";
        my $html = $tmpl->output;
        $html =~ s/\s//gs;
        is $html => '<div>Foo</div><div>First</div><div>Bar<div>Second</div><div>InsideBar</div></div><div>Baz</div>', 'new node is inserted';
    }
};

subtest 'appendChild' => sub {
    my $tmpl = MT::Template->new_string( \<<__TMPL__);
    <mt:setvarblock name="foo">
      <div>Foo</div>
    </mt:setvarblock>
    <mt:setvarblock name="bar">
      <div>Bar
      <mt:if name="foo">
        <mt:setvarblock name="inside_bar">
          <div>Inside Bar</div>
        </mt:setvarblock>
        <mt:var id="inside_bar" name="inside_bar">
      </mt:if>
      </div>
    </mt:setvarblock>
    <mt:setvarblock name="baz">
      <div>Baz</div>
    </mt:setvarblock>
    <mt:var name="foo">
    <mt:var id="bar" name="bar">
    <mt:var name="baz">
__TMPL__

    ok my $new = $tmpl->createTextNode('<div>Appended</div>'), 'created a node';
    ok $tmpl->appendChild($new), "appendChild succeeds";
    my $html = $tmpl->output;
    $html =~ s/\s//gs;
    is $html => '<div>Foo</div><div>Bar<div>InsideBar</div></div><div>Baz</div><div>Appended</div>', 'new node is inserted';
};

subtest 'stray non-ascii in tags' => sub {
    # The expectations are the actual output since MTC-4386 to mt9.0.1 (at least)

    subtest 'wide space for delimiter' => sub {
        require version;
        plan skip_all => 'Need to support array type of config directives in config.yaml' if version->parse($^V) > version->parse(5.32.1);
        plan skip_all => 'Not for MT::Builder::Fast' if $MT::Builder eq 'MT::Builder::Fast';
        my $tmpl_str = qq!<MTVar\x{3000}name="foo" value="xxx">a<MTVar name="foo">b!;
        my $tmpl = MT::Template->new_string(\$tmpl_str);
        my $ret  = $tmpl->build;
        is $ret, undef;
    };
    subtest 'bare wide character for attribute value' => sub {
        my $tmpl_str = qq!<MTVar name="foo" value=\x{3042}>a<MTVar name="foo">b!;
        my $tmpl = MT::Template->new_string(\$tmpl_str);
        my $ret  = $tmpl->build;
        is $ret, "a\x{3042}b";
    };
    subtest 'wide character in attribute value' => sub {
        my $tmpl_str = qq!<MTVar name="foo" value="\x{3042}">a<MTVar name="foo">b!;
        my $tmpl = MT::Template->new_string(\$tmpl_str);
        my $ret  = $tmpl->build;
        is $ret, "a\x{3042}b";
    };
    subtest 'wide character for attribute name' => sub {
        my $tmpl_str = qq!<MTVar name="foo" value="2" \x{3042}="a">a<MTVar name="foo">b!;
        my $tmpl = MT::Template->new_string(\$tmpl_str);
        my $ret  = $tmpl->build;
        is $ret, "ab";
    };
};

done_testing();
