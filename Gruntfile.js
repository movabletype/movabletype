module.exports = function(grunt) {
  'use strict';

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    copy: {
      svg4everybody: {
        expand: true,
        cwd: 'node_modules/svg4everybody/dist',
        src: [
          'svg4everybody.js',
          'svg4everybody.min.js'
        ],
        dest: 'mt-static/lib/svg4everybody'
      }
    },
    svg_sprite: {
      basic: {
        src: ['mt-static/images/svg/*.svg'],
        dest: 'mt-static/images',
        options: {
          shape: {
            transform: [
              {
                svgo: {
                  plugins: [
                    { removeAttrs: { attrs: 'fill' } }
                  ]
                }
              }
            ]
          },
          mode: {
            symbol: {
              dest: '.',
              sprite: 'sprite.svg'
            }
          }
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-svg-sprite');

  grunt.registerTask('default', ['svg_sprite', 'copy']);
};
