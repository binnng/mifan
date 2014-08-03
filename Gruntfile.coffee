"use strict"

# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# use this if you want to recursively match all subfolders:
# 'test/spec/**/*.js'
module.exports = (grunt) ->
  
  # Load grunt tasks automatically
  require("load-grunt-tasks") grunt
  
  # Time how long tasks take. Can help when optimizing build times
  require("time-grunt") grunt
  grunt.config.set "ip", (require("ip").address())

  today = grunt.template.today "yyyymmddss"
  md5Today = require("md5").digest_s today
  
  # Define the configuration for all the tasks
  grunt.initConfig
    
    # Project settings
    yeoman:
      
      # configurable paths
      app: require("./bower.json").appPath or "app"
      dist: "dist"

      today: today
      md5: md5Today
      prefix: today

      secret: grunt.file.readJSON "secret.json"

      onlineURL: "http://115.29.49.123/mifan/app"
      onlineTestURL: "http://115.29.49.123/mifan/app/test"

    
    # Watches files for changes and runs tasks based on the changed files
    watch:
      bower:
        files: ["bower.json"]
        tasks: ["bowerInstall"]

      js:
        files: ["<%= yeoman.app %>/scripts/*.js"]
        tasks: [] # "newer:jshint:all"]
        options:
          livereload: true

      controllers:
        files: ["<%= yeoman.app %>/scripts/controllers/*.js"]
        tasks: ["concat:controllers"] # "newer:jshint:all"]
        options:
          livereload: false

      directives:
        files: ["<%= yeoman.app %>/scripts/directives/*.js"]
        tasks: ["concat:directives"] # "newer:jshint:all"]
        options:
          livereload: false

      filters:
        files: ["<%= yeoman.app %>/scripts/filters/*.js"]
        tasks: ["concat:filters"] # "newer:jshint:all"]
        options:
          livereload: false

      requires:
        files: ["<%= yeoman.app %>/scripts/requires/*.js"]
        tasks: ["concat:requires"] # "newer:jshint:all"]
        options:
          livereload: false

      jsTest:
        files: ["test/spec/{,*/}*.js"]
        tasks: [
          # "newer:jshint:test"
          "karma"
        ]

      compass:
        files: ["<%= yeoman.app %>/styles/{,*/}*.{scss,sass}"]
        tasks: [
          "compass:server"
          "autoprefixer"
        ]

      gruntfile:
        files: ["Gruntfile.js"]

      livereload:
        options:
          livereload: "<%= connect.options.livereload %>"

        files: [
          "<%= yeoman.app %>/{,*/}*.html"
          ".tmp/styles/{,*/}*.css"
          "<%= yeoman.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
        ]

    
    # The actual grunt server settings
    connect:
      options:
        port: 9000
        
        # Change this to '0.0.0.0' to access the server from outside.
        hostname: grunt.config.get("ip")
        livereload: 35729

      livereload:
        options:
          open: true
          base: [
            ".tmp"
            "<%= yeoman.app %>"
          ]

      test:
        options:
          port: 9001
          base: [
            ".tmp"
            "test"
            "<%= yeoman.app %>"
          ]

      dist:
        options:
          open: true
          base: "<%= yeoman.dist %>"


    
    # Make sure code styles are up to par and there are no obvious mistakes
    jshint:
      options:
        jshintrc: ".jshintrc"
        reporter: require("jshint-stylish")

      all: [
        "Gruntfile.js"
        "<%= yeoman.app %>/scripts/{,*/}*.js"
      ]
      test:
        options:
          jshintrc: "test/.jshintrc"

        src: ["test/spec/{,*/}*.js"]

    
    # Empties folders to start fresh
    clean:
      dist:
        files: [
          dot: true
          src: [
            ".tmp"
            "<%= yeoman.dist %>/*"
            "!<%= yeoman.dist %>/.git*"
          ]
        ]

      distView:
        files: [
          dot: true
          src: ["<%= yeoman.dist %>/views"]
        ]

      server: ".tmp"

    
    # Add vendor prefixed styles
    autoprefixer:
      options:
        browsers: ["last 1 version"]

      dist:
        files: [
          expand: true
          cwd: ".tmp/styles/"
          src: "{,*/}*.css"
          dest: ".tmp/styles/"
        ]

    
    # Automatically inject Bower components into the app
    bowerInstall:
      app:
        src: ["<%= yeoman.app %>/index.html"]
        ignorePath: "<%= yeoman.app %>/"

      sass:
        src: ["<%= yeoman.app %>/styles/{,*/}*.{scss,sass}"]
        ignorePath: "<%= yeoman.app %>/bower_components/"

    
    # Compiles Sass to CSS and generates necessary files if requested
    compass:
      options:
        sassDir: "<%= yeoman.app %>/styles"
        cssDir: ".tmp/styles"
        specify: "<%= yeoman.app %>/styles/main.scss"
        generatedImagesDir: ".tmp/images/generated"
        imagesDir: "<%= yeoman.app %>/images"
        javascriptsDir: "<%= yeoman.app %>/scripts"
        fontsDir: "<%= yeoman.app %>/styles/fonts"
        importPath: "<%= yeoman.app %>/styles/imports"
        httpImagesPath: "<%= yeoman.app %>/images"
        httpGeneratedImagesPath: "/images/generated"
        httpFontsPath: "<%= yeoman.app %>/fonts"
        relativeAssets: false
        assetCacheBuster: false
        raw: "Sass::Script::Number.precision = 10\n"

      dist:
        options:
          generatedImagesDir: "<%= yeoman.dist %>/images/generated"

      server:
        options:
          debugInfo: false

    
    # Renames files for browser caching purposes
    rev:
      dist:
        files:
          src: [
            "<%= yeoman.dist %>/scripts/{,*/}*.js"
            "<%= yeoman.dist %>/styles/{,*/}*.css"
            # "<%= yeoman.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
            # "<%= yeoman.dist %>/styles/fonts/*"
          ]

    
    # Reads HTML for usemin blocks to enable smart builds that automatically
    # concat, minify and revision files. Creates configurations in memory so
    # additional tasks can operate on them
    useminPrepare:
      html: "<%= yeoman.app %>/index.html"
      options:
        dest: "<%= yeoman.dist %>"
        flow:
          html:
            steps:
              js: [
                "concat"
                "uglifyjs"
              ]
              css: ["cssmin"]

            post: {}

    
    # Performs rewrites based on rev and the useminPrepare configuration
    usemin:
      html: ["<%= yeoman.dist %>/{,*/}*.html"]
      css: ["<%= yeoman.dist %>/styles/{,*/}*.css"]
      options:
        assetsDirs: ["<%= yeoman.dist %>"]

    
    # The following *-min tasks produce minified files in the dist folder
    cssmin:
      options:
        root: "<%= yeoman.app %>"

    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images"
          src: "{,*/}*.{png,jpg,jpeg,gif}"
          dest: "<%= yeoman.dist %>/images"
        ]

    svgmin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images"
          src: "{,*/}*.svg"
          dest: "<%= yeoman.dist %>/images"
        ]

    htmlmin:
      dist:
        options:
          collapseWhitespace: true
          collapseBooleanAttributes: true
          removeCommentsFromCDATA: true
          removeOptionalTags: true
          removeComments: true

        files: [
          expand: true
          cwd: "<%= yeoman.dist %>"
          src: ["*.html"] #'views/{,*/}*.html'],
          dest: "<%= yeoman.dist %>"
        ]

    
    # ngmin tries to make the code safe for minification automatically by
    # using the Angular long form for dependency injection. It doesn't work on
    # things like resolve or inject so those have to be done manually.
    ngmin:
      dist:
        files: [
          expand: true
          cwd: ".tmp/concat/scripts"
          src: "*.js"
          dest: ".tmp/concat/scripts"
        ]

    
    # Replace Google CDN references
    cdnify:
      dist:
        html: ["<%= yeoman.dist %>/*.html"]

    
    # Copies remaining files to places other tasks can use
    copy:
      dist:
        files: [
          {
            expand: true
            dot: true
            cwd: "<%= yeoman.app %>"
            dest: "<%= yeoman.dist %>"
            src: [
              # "*.{ico,png,txt}"
              # ".htaccess"
              "*.html"
              "views/{,*/}*.html"
              "images/{,*/}*.{webp}"
              "fonts/*"
              "fonts/*"
              "lib/*"
              "data/*"
            ]
          }
          {
            expand: true
            cwd: ".tmp/images"
            dest: "<%= yeoman.dist %>/images"
            src: ["generated/*"]
          }
        ]

      styles:
        expand: true
        cwd: "<%= yeoman.app %>/styles"
        dest: ".tmp/styles/"
        src: "{,*/}*.css"


    
    # Run some tasks in parallel to speed up the build process
    concurrent:
      server: ["compass:server"]
      test: ["compass"]
      dist: [
        "compass:dist"
        "imagemin"
        "svgmin"
      ]

    
    # By default, your `index.html`'s <!-- Usemin block --> will take care of
    # minification. These next options are pre-configured if you do not wish
    # to use the Usemin blocks.
    # cssmin: {
    #   dist: {
    #     files: {
    #       '<%= yeoman.dist %>/styles/main.css': [
    #         '.tmp/styles/{,*/}*.css',
    #         '<%= yeoman.app %>/styles/{,*/}*.css'
    #       ]
    #     }
    #   }
    # },
    # uglify: {
    #   dist: {
    #     files: {
    #       '<%= yeoman.dist %>/scripts/scripts.js': [
    #         '<%= yeoman.dist %>/scripts/scripts.js'
    #       ]
    #     }
    #   }
    # },
    # concat: {
    #   dist: {}
    # },

    concat:
      controllers: 
        src: ["<%= yeoman.app %>/scripts/controllers/*.js"]
        dest: "<%= yeoman.app %>/scripts/controllers.js"

      directives: 
        src: ["<%= yeoman.app %>/scripts/directives/*.js"]
        dest: "<%= yeoman.app %>/scripts/directives.js"

      filters: 
        src: ["<%= yeoman.app %>/scripts/filters/*.js"]
        dest: "<%= yeoman.app %>/scripts/filters.js"

      requires: 
        src: ["<%= yeoman.app %>/scripts/requires/*.js"]
        dest: "<%= yeoman.app %>/scripts/requires.js"
    
    # Test settings
    karma:
      unit:
        configFile: "karma.conf.js"
        singleRun: true

    "ng_template":
      
      # The directory of your views
      files: ["<%= yeoman.dist %>/views"]
      options:
        
        # The directory of your app
        appDir: "<%= yeoman.dist %>"
        
        # The main html file to place your inline templates
        indexFile: "index.html"
        
        # Default set to false
        concat: true

    'regex-replace':
      dist:
        actions:[
          {
            search: '/fonts/glyphicons'
            replace: '../fonts/glyphicons'
            flags: 'g'
          }
          {
            search: "#{__dirname}/.tmp"
            replace: '..'
            flags: 'g'
          }
        ]
        src: [
          "<%= yeoman.dist %>/styles/mifan.css"
        ]
      html:
        actions:[
          {
            search: "scripts/mifan.js"
            replace: "scripts/<%= yeoman.prefix %>.mifan.js"
            flags: 'g'
          }
          {
            search: "styles/mifan.css"
            replace: "styles/<%= yeoman.prefix %>.mifan.css"
            flags: 'g' 
          }
        ]
        src: [
          "<%= yeoman.dist %>/index.html"
        ]

    rename:
      dist:
        files: [
          {
            src: "<%= yeoman.dist %>/styles/mifan.css",
            dest: "<%= yeoman.dist %>/styles/<%= yeoman.prefix %>.mifan.css"
          }
          {
            src: "<%= yeoman.dist %>/scripts/mifan.js",
            dest: "<%= yeoman.dist %>/scripts/<%= yeoman.prefix %>.mifan.js"
          }
        ]


    'sftp-deploy':
      build:
        auth:
          host: "<%= yeoman.secret.host %>"
          port: "<%= yeoman.secret.port %>"
          authKey: 'key1'

        src: "<%= yeoman.dist %>"
        dest: "<%= yeoman.secret.path %>"
        exclusions: [
          "<%= yeoman.dist %>/images"
          "<%= yeoman.dist %>/lib"
          "<%= yeoman.dist %>/fonts"
        ]
        serverSep: "/"
        concurrency: 4
        progress: yes

      all:
        auth:
          host: "<%= yeoman.secret.host %>"
          port: "<%= yeoman.secret.port %>"
          authKey: 'key1'

        src: "<%= yeoman.dist %>"
        dest: "<%= yeoman.secret.path %>"
        exclusions: [
          "<%= yeoman.dist %>/lib"
          "<%= yeoman.dist %>/fonts"
        ]
        serverSep: "/"
        concurrency: 4
        progress: yes

      test:
        auth:
          host: "<%= yeoman.secret.host %>"
          port: "<%= yeoman.secret.port %>"
          authKey: 'key1'

        src: "<%= yeoman.dist %>"
        dest: "<%= yeoman.secret.path %>/test"
        exclusions: [
          #"<%= yeoman.dist %>/images"
          #"<%= yeoman.dist %>/scripts"
          #"<%= yeoman.dist %>/styles"
          #"<%= yeoman.dist %>/lib"
          #"<%= yeoman.dist %>/fonts"
        ]
        serverSep: "/"
        concurrency: 4
        progress: yes

    open:
      online:
        path: "<%= yeoman.onlineURL %>"
        app: "Google Chrome"
      test:
        path: "<%= yeoman.onlineTestURL %>"
        app: "Google Chrome"

  grunt.registerTask "serve", (target) ->
    if target is "dist"
      return grunt.task.run([
        "build"
        "connect:dist:keepalive"
      ])
    grunt.task.run [
      "clean:server"
      "bowerInstall"
      "concurrent:server"
      "autoprefixer"
      "connect:livereload"
      "concat:controllers"
      "concat:requires"
      "watch"
    ]
    return

  grunt.registerTask "server", (target) ->
    grunt.log.warn "The `server` task has been deprecated. Use `grunt serve` to start a server."
    grunt.task.run ["serve:" + target]
    return

  grunt.registerTask "test", [
    "clean:server"
    "concurrent:test"
    "autoprefixer"
    "connect:test"
    "karma"
  ]
  grunt.registerTask "build", [
    "clean:dist"
    "bowerInstall"
    "concat:controllers"
    "concat:requires"
    "useminPrepare"
    "concurrent:dist"
    "autoprefixer"
    "concat"
    "ngmin"
    "copy:dist"  
    "cdnify"
    "cssmin"
    "uglify"
    #"rev"
    "usemin"
    "ng_template"
    "htmlmin"
    "clean:distView"
    "regex-replace:dist"
    "regex-replace:html"
    "rename:dist"
  ]
  
  grunt.registerTask "publish", [
    "build"
    "sftp-deploy:build"
    "open:online"
  ]
  
  grunt.registerTask "publishAll", [
    "build"
    "sftp-deploy:all"
    "open:online"
  ]

  grunt.registerTask "publishTest", [
    "build"
    "sftp-deploy:test"
    "open:test"
  ]
  
  grunt.registerTask "publishall", [
    "publishAll"
  ]
  
  grunt.registerTask "publishtest", [
    "publishTest"
  ]

  grunt.registerTask "default", [
    # "newer:jshint"
    # "test"
    "build"
  ]