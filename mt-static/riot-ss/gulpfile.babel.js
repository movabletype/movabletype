'use strict'

var gu = require('gulp')
var uglify = require('gulp-uglify')
var rename = require('gulp-rename')
var riot = require('gulp-riot')

function dest(d){
    return gu.dest(d)
}

function build() {
    gu.src('./ss.tag')
        .pipe(riot())
        .pipe(rename('index.js'))
        .pipe(dest('./'))

    gu.src('./index.js')
        .pipe(uglify())
        .pipe(rename('riot.ss.min.js'))
        .pipe(dest('./'))
}

gu
    .task('build', build)
