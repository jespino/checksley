module.exports = (grunt) ->
    # Project configuration.
    grunt.initConfig
        pkg: grunt.file.readJSON('package.json')
        uglify:
            options:
                banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
            build:
                files:
                    'dist/parsley.min.js': 'parsley.js'
                    'dist/parsley.extend.min.js': 'parsley.extend.js'
                    'dist/parsley-standalone.min.js': ['parsley.js', 'parsley.extend.js']
        yuidoc:
            options:
                syntaxtype: 'coffee'
            compile:
                name: '<%= pkg.name %>'
                description: '<%= pkg.description %>'
                version: '<%= pkg.version %>'
                url: '<%= pkg.homepage %>'
                options:
                    paths: "."
                    outdir: 'doc/api'

        coffee:
            compileBare:
                options:
                    bare: true
                files:
                    'parsley.js': 'parsley.coffee'
                    'parsley.extend.js': 'parsley.extend.coffee'

        watch:
            scripts:
                files: ['parsley.coffee', 'parsley.extend.coffee']
                tasks: ['default']
                options:
                    nospawn: true

        mocha_phantomjs:
            all: ['tests/index.html']


    # Load the plugin that provides the "uglify" task.
    grunt.loadNpmTasks('grunt-contrib-uglify')
    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks('grunt-contrib-watch')
    grunt.loadNpmTasks('grunt-contrib-yuidoc')
    grunt.loadNpmTasks('grunt-mocha-phantomjs')

    # Default task(s).
    grunt.registerTask('default', ['coffee'])
    grunt.registerTask('dist', ['coffee', 'uglify'])
    grunt.registerTask('doc', ['yuidoc'])
    grunt.registerTask('test', ['mocha_phantomjs'])
