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


    # Load the plugin that provides the "uglify" task.
    grunt.loadNpmTasks('grunt-contrib-uglify')
    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks('grunt-contrib-watch')

    # Default task(s).
    grunt.registerTask('default', ['coffee'])
    grunt.registerTask('dist', ['coffee', 'uglify'])
