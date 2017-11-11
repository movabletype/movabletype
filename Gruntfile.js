module.exports = function(grunt) {
  'use strict';

  var path = require('path');

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    copy: {
      bootstrap: {
        expand: true,
        cwd: 'node_modules/bootstrap/dist',
        src: [
          '**/*'
        ],
        dest: 'mt-static/bootstrap'
      },
      popper: {
        expand: true,
        cwd: 'node_modules/popper.js/dist/umd',
        src: [
          '*'
        ],
        dest: 'mt-static/popper'
      },
      riot: {
        expand: true,
        cwd: 'node_modules/riot',
        src: [
          'LICENSE.txt',
          'riot.js',
          'riot.min.js',
          'riot+compiler.js',
          'riot+compiler.min.js'
        ],
        dest: 'mt-static/riot'
      },
      svg4everybody: {
        expand: true,
        cwd: 'node_modules/svg4everybody/dist',
        src: [
          'svg4everybody.js',
          'svg4everybody.min.js'
        ],
        dest: 'mt-static/svg4everybody'
      }
    },
    exec: {
      riot: {
        command: 'yarn run build-riot'
      },
    }
  });

  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-exec');

  grunt.registerTask('default', ['exec:riot', 'copy']);
};
