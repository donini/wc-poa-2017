/* jshint node:true */
'use strict';

module.exports = function( grunt ) {

	// auto load grunt tasks
	require( 'load-grunt-tasks' )( grunt );

	grunt.initConfig({
		pkg: grunt.file.readJSON( 'package.json' ),
		config: {
			server: 'public/wp-content/themes/<%= pkg.name %>',
			build: 'build',
		},

		// watch for changes for files and execute an execute a task
		watch: {
			livereload: {
				files: ['public/**/*', '!**/*.log'],
				options: {
					livereload: true
				}
			},
			theme: {
				files: 'theme/src/**/*',
				tasks: ['sync:theme']
			},
			stylus: {
				files: ['.stylintrc', 'theme/stylus/**/*.styl'],
				tasks: ['stylint', 'stylus:dev']
			}
		},

		// sync the files with local test wordpress
		sync : {
			theme : {
				files : [ {
					cwd : 'theme/src',
					src : '**',
					dest : '<%= config.server %>'
				} ],
				pretend : false,
				verbose: true,
				updateAndDelete: true,
				ignoreInDest: 'assets/**'
			}
		},

		// compile stylus file
		stylus: {
			dev: {
				options: {
					compress: false,
					linenos: true,
					'include css': true
				},
				files : {
					'<%= config.server %>/assets/css/style.css' : 'theme/stylus/style.styl'
				}
			},
			dist: {
				options: {
					'include css': true
				},
				files : {
					'<%= config.build %>/style.css' : 'theme/stylus/style.styl'
				}
			}
		},

		// lint stylus files
		stylint: {
			src: ['theme/stylus/**/*.styl']
		},

		// lint javascript files
		jshint: {
			files: ['Gruntfile.js']
		},

		// generate build package
		compress : {
			build : {
				options : {
					archive : '<%= config.build %>/build.zip'
				},
				files : [ {
					expand: true,
					cwd: '<%= config.build %>',
					src : [ '**/*', '!build.zip' ],
					dest : '.'
				} ]
			}
		}
	});

	grunt.task.registerTask( 'default', [
		'sync:theme',
		'stylint',
		'stylus:dev'
	]);

	grunt.task.registerTask( 'build', [
		'stylint',
		'stylus:dist'
	]);
};
