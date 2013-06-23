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
            compile:
                name: '<%= pkg.name %>'
                description: '<%= pkg.description %>'
                version: '<%= pkg.version %>'
                url: '<%= pkg.homepage %>'
                syntaxtype: 'coffee'
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

            parsley:
                files:
                    'parsley2.js': 'parsley2.coffee'

            demo:
                files:
                    'demo/demo.js': 'demo/demo.coffee'

        watch:
            scripts:
                files: ['parsley.coffee', 'parsley.extend.coffee']
                tasks: ['coffee:compileBare']
                options:
                    nospawn: true

            parsley:
                files: ['parsley2.coffee']
                tasks: ['coffee:parsley']
                options:
                    nospawn: true

            demo:
                files: ['demo/demo.coffee']
                tasks: ['coffee:demo']
                options:
                    nospawn: true




    # Load the plugin that provides the "uglify" task.
    grunt.loadNpmTasks('grunt-contrib-uglify')
    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks('grunt-contrib-watch')
    #grunt.loadNpmTasks('grunt-contrib-yuidoc')

    # Default task(s).
    grunt.registerTask('default', ['coffee'])
    grunt.registerTask('dist', ['coffee', 'uglify'])
    #grunt.registerTask('doc', ['yuidoc'])
