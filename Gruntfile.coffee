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
                    'dist/parsley-standalone.min.js': 'dist/parsley-standalone.js'
        concat:
            options:
                separator: ';'
            dist:
                src: [
                    'tests/resources/zepto-1.0rc1*.js'
                    'parsley.js'
                ]
                dest: 'dist/parsley-standalone.js'

        yuidoc:
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

        coffeelint:
            app:
                files:
                    src: ['parsley.coffee', 'parsley.extend.coffee']
                options:
                    max_line_length:
                        value: 120
                        level: "error"
                    indentation:
                        value: 4
                        level: "error"

        watch:
            scripts:
                files: ['parsley.coffee', 'parsley.extend.coffee']
                tasks: ['default']
                options:
                    nospawn: true

        mocha_phantomjs:
            all: ['tests/index.html']

        clean: [
            'parsley.js'
            'parsley.extend.js'
            'dist'
        ]



    # Load the plugin that provides the "uglify" task.
    grunt.loadNpmTasks('grunt-contrib-uglify')
    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks('grunt-contrib-watch')
    grunt.loadNpmTasks('grunt-contrib-yuidoc')
    grunt.loadNpmTasks('grunt-contrib-concat')
    grunt.loadNpmTasks('grunt-contrib-clean')
    grunt.loadNpmTasks('grunt-mocha-phantomjs')
    grunt.loadNpmTasks('grunt-coffeelint')

    # Default task(s).
    grunt.registerTask('default', ['coffee'])
    grunt.registerTask('dist', ['coffee', 'concat', 'uglify'])
    grunt.registerTask('doc', ['coffee', 'yuidoc'])
    grunt.registerTask('test', ['mocha_phantomjs'])
    grunt.registerTask('lint', ['coffeelint'])
