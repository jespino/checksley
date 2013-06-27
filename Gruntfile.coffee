module.exports = (grunt) ->
    # Project configuration.
    grunt.initConfig
        pkg: grunt.file.readJSON('package.json')
        uglify:
            options:
                banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
            build:
                files:
                    'dist/checksley.min.js': 'checksley.js'
                    'dist/checksley.extend.min.js': 'checksley.extend.js'
                    'dist/checksley-standalone.min.js': 'dist/checksley-standalone.js'
        concat:
            options:
                separator: ';'
            dist:
                src: [
                    'tests/resources/zepto-1.0rc1*.js'
                    'tests/resources/lodash.compat.js'
                    'checksley.js'
                ]
                dest: 'dist/checksley-standalone.js'

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
            checksley:
                files:
                    'checksley.js': 'checksley.coffee'
                    'checksley.extend.js': 'checksley.extend.coffee'
                    'l10n/checksley.es.js': 'l10n/checksley.es.coffee'
                    'l10n/checksley.us.js': 'l10n/checksley.us.coffee'

            demo:
                files:
                    'demo/demo.js': 'demo/demo.coffee'

            tests:
                files:
                    "tests.js": "tests.coffee"

        coffeelint:
            app:
                files:
                    src: ['checksley.coffee', 'checksley.extend.coffee', 'l10n/*.coffee']
                options:
                    max_line_length:
                        value: 120
                        level: "error"
                    indentation:
                        value: 4
                        level: "error"

        watch:
            checksley:
                files: ['checksley.coffee', 'checksley.extend.coffee', 'l10n/*.coffee']
                tasks: ['coffee:checksley']
                options:
                    nospawn: false

            demo:
                files: ['demo/demo.coffee']
                tasks: ['coffee:demo']
                options:
                    nospawn: false

            tests:
                files: ["tests.coffee"]
                tasks: ["coffee:tests"]
                options:
                    nospawn: false

        mocha_phantomjs:
            all: ['tests/index.html']

        clean: [
            'checksley.js'
            'checksley.extend.js'
            'l10n/*.js'
            'dist'
            'doc'
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
    grunt.registerTask('default', ['coffee', 'watch'])
    grunt.registerTask('dist', ['coffee', 'concat', 'uglify'])
    grunt.registerTask('doc', ['coffee', 'yuidoc'])
    grunt.registerTask('test', ['coffee', 'mocha_phantomjs'])
    grunt.registerTask('lint', ['coffeelint'])
