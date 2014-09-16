lochild_process = require 'child_process'
gulp          = require 'gulp'
gutil         = require 'gulp-util'
sass          = require 'gulp-sass'
coffee        = require 'gulp-coffee'
jade          = require 'gulp-jade'
livereload    = require 'gulp-livereload'
changed       = require 'gulp-changed'
open          = require 'open'
http          = require 'http'
path          = require 'path'
ecstatic      = require 'ecstatic'
notify        = require 'gulp-notify'
concat        = require 'gulp-concat'
clean         = require 'gulp-clean'
cache         = require 'gulp-cache'
protractor    = require 'gulp-protractor'
runSequence   = require 'run-sequence'

paths = 
  public: ['public/**']
  assets: ['assets/**']
  styles: [
    'app/css/app/*.scss'
    'app/css/app.scss'
    "public/components/bootstrap/dist/css/bootstrap.css"
    "public/components/components-font-awesome/css/font-awesome.css"
  ]
  fonts: [
    "public/components/components-font-awesome/fonts/fontawesome-webfont.*"
    "public/components/bootstrap/dist/fonts/glyphicons-halflings-regular.*"
  ]
  scripts: 
    vendor: [
      "public/components/jquery/dist/jquery.js"
      "public/components/angular/angular.js"
      "public/components/angular-bootstrap/ui-bootstrap-tpls.js"
      "public/components/angular-animate/angular-animate.js"
      
      "public/components/angular-resource/angular-resource.js"
      "public/components/lodash/dist/lodash.js"
      "public/components/restangular/dist/restangular.js"
      "public/components/angular-ui-router/release/angular-ui-router.js"
    ]
    app: [
      'app/js/app.coffee'
      'app/js/*.coffee'
    ]
  templates: ['app/**/*.jade']

destinations = 
  public: 'www'
  styles: 'www/css'
  scripts: 'www/js'
  templates: 'www'
  livereload: ['www/**']
  fonts: 'www/fonts'
  assets: 'www'

options =
  open: true
  httpPort: 4400


gulp.task 'clean', ->
  gulp.src('www', read: false)
    .pipe(clean())


gulp.task 'public', ->
  gulp.src(paths.public)
    .pipe(changed(destinations.public))
    .pipe(gulp.dest(destinations.public))

gulp.task 'styles', ->
  gulp.src(paths.styles)
    .pipe(changed(destinations.styles, extension: '.css'))
    .pipe(sass({
   
    }))
    .on('error', notify.onError((error) -> error.message))
    .pipe(gulp.dest(destinations.styles))

gulp.task 'fonts', ->
  gulp.src(paths.fonts)
    .pipe(changed(destinations.fonts))
    .pipe(gulp.dest(destinations.fonts))

gulp.task 'assets', ->
  gulp.src(paths.assets)
    .pipe(changed(destinations.assets))
    .pipe(gulp.dest(destinations.assets))

gulp.task 'scripts:vendor', ->
  gulp.src(paths.scripts.vendor)
    .pipe(concat('vendor.js'))
    .pipe(gulp.dest(destinations.scripts))


gulp.task 'scripts:app', ->
  gulp.src(paths.scripts.app)
    .pipe(coffee({
      sourceMap: false
    }))
    .on('error', notify.onError((error) -> error.message))
    .pipe(concat('app.js'))
    .pipe(gulp.dest(destinations.scripts))


gulp.task 'scripts', ['scripts:vendor', 'scripts:app']


gulp.task 'templates', ->
  gulp.src(paths.templates)
    .pipe(changed(destinations.templates, extension: '.html'))
    .pipe(jade({
      pretty: true
    }))
    .on('error', notify.onError((error) -> error.message))
    .pipe(gulp.dest(destinations.templates))


gulp.task 'watch', ->
  gulp.watch(paths.public, ['public'])
  gulp.watch(paths.scripts.app, ['scripts:app'])
  gulp.watch(paths.scripts.vendor, ['scripts:vendor'])
  gulp.watch(paths.assets, ['assets'])
  gulp.watch(paths.styles, ['styles'])
  gulp.watch(paths.fonts, ['fonts'])
  gulp.watch(paths.templates, ['templates'])

  livereloadServer = livereload()
  gulp.watch(destinations.livereload).on 'change', (file) ->
    livereloadServer.changed(file.path)


gulp.task 'server', ->
  http.createServer(ecstatic(root: "www")).listen(options.httpPort)
  gutil.log gutil.colors.blue "HTTP server listening on #{options.httpPort}"
  if options.open
    url = "http://localhost:#{options.httpPort}/"
    open(url)
    gutil.log gutil.colors.blue "Opening #{url} in the browser..."


gulp.task 'build', (cb) ->
  runSequence 'clean',
    [
      'public'
      'styles'
      'fonts'
      'scripts'
      'assets'
      'templates'
    ], cb


gulp.task 'default', (cb) ->
  runSequence 'build', ['watch', 'server'], cb
