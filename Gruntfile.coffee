module.exports = (grunt) ->
    # Project configuration.
    grunt.initConfig
        pkg: grunt.file.readJSON('package.json')
        uglify:
            options:
                banner: "/*! <%= pkg.name %> <%= grunt.template.today('yyyy-mm-dd') %>*/\n" +
                        "/*! Version: <%= pkg.version %> */\n" +
                        "/*! License: BSD */\n"

                mangle: false
                report: "min"

            build:
                files:
                    'dist/checksley.min.js': 'dist/_checksley.js'
                    'dist/checksley.extend.min.js': 'dist/_checksley.extend.js'
                    'dist/checksley.angular.min.js': 'dist/_checksley.angular.js'
                    'dist/l10n/checksley.es.min.js': 'dist/l10n/_checksley.es.js'
                    'dist/l10n/checksley.us.min.js': 'dist/l10n/_checksley.us.js'

        concat:
            options:
                stripBanners: false,
                banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
                        '<%= grunt.template.today("yyyy-mm-dd") %> */\n'

            dist:
                files:
                    "dist/checksley.js": ['dist/_checksley.js']
                    "dist/checksley.extend.js": ["dist/_checksley.extend.js"]
                    "dist/checksley.angular.js": ["dist/_checksley.angular.js"]
                    "dist/l10n/checksley.es.js": ["dist/l10n/_checksley.es.js"]
                    "dist/l10n/checksley.us.js": ["dist/l10n/_checksley.us.js"]

        coffee:
            dev:
                files:
                    'dist/_checksley.js': 'checksley.coffee',
                    'dist/_checksley.extend.js': 'checksley.extend.coffee'
                    'dist/_checksley.angular.js': 'checksley.angular.coffee'
                    'dist/l10n/_checksley.es.js': 'l10n/checksley.es.coffee'
                    'dist/l10n/_checksley.us.js': 'l10n/checksley.us.coffee'

            demo:
                files:
                    'web/demo/demo.js': 'web/demo/demo.coffee'

            tests:
                files:
                    "tests/tests.js": "tests/tests.coffee"

        coffeelint:
            app:
                files:
                    src: ['checksley.coffee', 'checksley.extend.coffee', 'l10n/*.coffee', 'i18n/*.coffee']
                options:
                    max_line_length:
                        value: 120
                        level: "error"
                    indentation:
                        value: 4
                        level: "error"

        watch:
            checksley:
                tasks: ['coffee', 'concat']
                files: [
                    'checksley.coffee',
                    'checksley.extend.coffee',
                    'checksley.angular.coffee',
                    'l10n/*.coffee',
                    'i18n/*.coffee'
                ]

            demo:
                tasks: ['coffee:demo']
                files: ['demo/demo.coffee']

            tests:
                tasks: ["coffee:tests"]
                files: ["tests/tests.coffee"]


        mocha:
            all:
                src: [ 'tests/index.html' ]
                options:
                    bail: true
                    log: true
                    mocha:
                        ignoreLeaks: false
                    reporter: 'Spec'
                    run: true

        connect:
            server:
                options:
                    port: 9000

        clean: [
            'dist/*.js'
            'l10n/*.js'
            'dist'
            'doc'
            '*.js'
        ]


    # Load the plugin that provides the "uglify" task.
    grunt.loadNpmTasks('grunt-contrib-uglify')
    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks('grunt-contrib-watch')
    grunt.loadNpmTasks('grunt-contrib-yuidoc')
    grunt.loadNpmTasks('grunt-contrib-concat')
    grunt.loadNpmTasks('grunt-contrib-clean')
    grunt.loadNpmTasks('grunt-contrib-connect')
    grunt.loadNpmTasks('grunt-mocha')
    grunt.loadNpmTasks('grunt-coffeelint')

    # Default task(s).
    grunt.registerTask('default', ['coffee', 'concat', 'watch'])
    grunt.registerTask('dist', ['coffee', 'concat', 'uglify'])
    grunt.registerTask('test', ['coffee', 'concat', 'mocha'])
    grunt.registerTask('lint', ['coffeelint'])
