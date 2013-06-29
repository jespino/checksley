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
        coffee:
            checksley:
                files:
                    'checksley.js': 'checksley.coffee',
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
                tasks: ['coffee:checksley']
                files: [
                    'checksley.coffee',
                    'checksley.extend.coffee',
                    'l10n/*.coffee',
                    'i18n/*.coffee'
                ]

            demo:
                tasks: ['coffee:demo']
                files: ['demo/demo.coffee']

            tests:
                tasks: ["coffee:tests"]
                files: ["tests.coffee"]

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
    grunt.registerTask('dist', ['coffee', 'uglify'])
    grunt.registerTask('test', ['coffee', 'mocha_phantomjs'])
    grunt.registerTask('lint', ['coffeelint'])
