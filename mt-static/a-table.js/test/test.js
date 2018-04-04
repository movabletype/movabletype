var Nightmare = require('nightmare')
var assert = require('assert')
var fs = require('fs')
var path = require('path')
var pkg = require('../package.json')
require.extensions['.html'] = function (module, filename) {
    module.exports = fs.readFileSync(filename, 'utf8')
}

var nightmare = Nightmare({
    webPreferences  : {
    partition : 'nopersist',
    preload:path.resolve(__dirname,'./preload.js')
  },
  show: true
});

var test_url = "file:///"+path.resolve(__dirname,"../examples/index.html");

describe('test',function(){
  it('align-right',function(done){
    nightmare.goto(test_url)
      .mousedown('[data-cell-id="0-0"]')
      .click('[data-action-click="align(right)"]')
      .evaluate(function () {
        return document.querySelector('.test').innerText;
      })
      .then(function (result) {
        assert.equal(result,require('./test.html'));
        done();
      })
      .catch(function (error) {
        done(error);
      });
  });
});
