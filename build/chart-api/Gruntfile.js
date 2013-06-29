module.exports = function (grunt) {
  'use strict';
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);

  // Project configuration.
  grunt.initConfig({
    watch: {
      preprocess: {
        files: ['src/**.js'],
        tasks: ['preprocess']
      },
      css: {
        files: ['css/**.css'],
        tasks: ['cssmin']
      }
    },
    preprocess: {
      core: {
        files: {
          'dist/core/mtchart.core.js': 'src/build/mtchart.core.js'
        }
      },
      amd: {
        files: {
          'dist/core/amd/mtchart.core.amd.js': 'src/build/mtchart.core.amd.js'
        }
      },
      all: {
        files: {
          'dist/mtchart.js': 'src/build/mtchart.js'
        }
      }
    },
    clean: {
      build: ['dist']
    },
    copy: {
      build: {
        files: [{
            expand: true,
            src: ['deps/**'],
            dest: 'dist/'
          }
        ]
      }
    },
    cssmin: {
      build: {
        files: {
          'dist/mtchart.css': ['css/morris.css', 'css/mtchart.css']
        }
      }
    },
    uglify: {
      options: {
        beautify: {
          width: 1000000
        },
        compress: {
          sequences: false,
          global_defs: {
            DEBUG: false
          },
          unsafe: true
        },
        warnings: true,
        mangle: true,
        unsafe: true
      },
      core: {
        files: {
          'dist/core/mtchart.core.min.js': ['dist/core/mtchart.core.js']
        }
      },
      amd: {
        files: {
          'dist/core/amd/mtchart.core.amd.min.js': ['dist/core/amd/mtchart.core.amd.js']
        }
      },
      all: {
        files: {
          'dist/mtchart.min.js': ['dist/mtchart.js']
        }
      }
    }
  });
  grunt.registerTask('build', ['clean', 'preprocess', 'copy', 'cssmin', 'uglify']);
};
