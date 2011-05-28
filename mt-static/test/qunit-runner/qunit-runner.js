/*
// <copyright project "Salient.QualityControl" file="qunit.runner.js" company="Sky Sanders">
// This source is a Public Domain Dedication. 
// http://salientqc.codeplex.com
// Attribution is appreciated.
// </copyright> 
*/

/* this file can safely be added to the tail of your qunit.js to simplify deployment */

(function(window) {
    var runner = function(tests, sequential, done) {
        this.failures = 0;
        this.total = 0;
        this.currentIndex = 0;
        this.sequential = sequential;
        this.tests = tests;
        this.done = done || this.done;
        var that = this;
        $(document).ready(function() {
            $(".runner-test-page-header").live("click", function() { $(this).next(".runner-test-page-frame").slideToggle(100); });
            that.runPage();
        });
    }

    runner.prototype.nextPage = function() {
        if (this.currentIndex + 1 < this.tests.length) {
            this.currentIndex++;
            this.runPage();
        }
    }

    runner.prototype.runPage = function() {
        // update page counter
        $("#qunit-runner-userAgent").html('<span class="runner-test-page-counter">Test Page '
                + (this.currentIndex + 1) + " of " + this.tests.length + "</span>" + window.navigator.userAgent);

        var test = this.tests[this.currentIndex];
        test.title = test.title || test.page;

        // load the test page in an iframe
        test.header = $('<p class="runner-test-page-header">' + test.title + "</p>").addClass("passed")[0];
        $("#runner-test-page-container").append(test.header);

        test.frame = $('<iframe class="runner-test-page-frame" src="' + test.page + '" width="100%" height="200"></iframe>')[0];
        $("#runner-test-page-container").append(test.frame);

        if (!this.sequential) {
            this.nextPage();
        }
    }

    runner.prototype.pageProgress = function(frame, failures, total, testName, isDone) {
        var that = this;
        $.grep(this.tests, function(test, index) {
            if (test.frame === frame) {
                $(test.header).removeClass("passed").addClass(failures > 0 ? "failed" : "passed")
                            .html(test.title + " " + testName
                            + (total == 0 ? "" : "  " + failures + " failed, " + total + " total"));
                if (isDone) {
                    test.complete = true;
                    that.failures += failures;
                    that.total += total;
                    // are all pages finished?
                    if ($.grep(that.tests, function(test, index) { return !test.complete; }).length == 0) {
                        $("#qunit-banner").addClass(that.failures > 0 ? "qunit-fail" : "qunit-pass");
                        that.done(that.failures, that.total);
                    }
                    else {
                        if (that.sequential) {
                            that.nextPage();
                        }
                    }
                }
            }
        });
    }

    // if you need to be notified the runner is finished..
    runner.prototype.done = function(failures, total) {
    }

    QUnit.run = function(tests, sequential, done) {
        /// <param name="tests" type="Array"></param>
        /// <param name="sequential" type="Boolean"></param>
        /// <param name="done" type="Function">Function(failures, total) will be called when all tests complete.</param>
        if (window.__qunit_runner) {
            throw new Error("One runner per page please.");
        }
        window.__qunit_runner = new runner(tests, sequential, done);
    }


    // runner test page hooks - if this page has a runner as parent
    // then set up the metric callbacks
    if (top.__qunit_runner) {
        var runner = top.__qunit_runner;
        QUnit.done = function(stat) {
            runner.pageProgress(window.frameElement, stat['failed'], stat['total'], "done", true);
        };
        QUnit.testStart = function(name) {
            runner.pageProgress(window.frameElement, 0, 0, name + " started");
        }
        QUnit.testDone = function(name, failures, total) {
            runner.pageProgress(window.frameElement, failures, total, name);
        }
    }
})(this);
