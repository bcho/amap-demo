module.exports = (grunt) ->
  grunt.initConfig
    
    # Package meta
    pkg: grunt.file.readJSON 'package.json'
    srcDir: './app'
    buildDir: './dist'

    # Tasks settings

    connect:
      server:
        options:
          port: 9001
          base: '<%= buildDir %>'

    copy:
      build:
        files: [
          expand: true
          cwd: '<%= srcDir %>'
          src: [
            '**/*.*'
            '!{,*/}*.coffee'
          ],
          dest: '<%= buildDir %>'
        ]

    watch:
      pages:
        files: ['<%= srcDir %>/**/*.html']
        tasks: ['copy:build']
        options:
          spawn: false
          livereload: true

      styles:
        files: ['<%= srcDir %>/**/*.css']
        tasks: ['copy:build']
        options:
          spawn: false
          livereload: true

    clean:
      build: ['<%= buildDir %>']
  
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'build', [
    'clean:build'
    'copy:build'
  ]

  grunt.registerTask 'default', [
    'build'
    'connect:server'
    'watch'
  ]
