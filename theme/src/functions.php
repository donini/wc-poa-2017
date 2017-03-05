<?php
/**
 * Theme functions and definitions
 *
 * @link https://developer.wordpress.org/themes/basics/theme-functions/
 *
 * @package WordPress
 * @subpackage WordCampPoa2017
 * @since 0.1.0
 * @version 0.1.0
 */

function wcpoa2017_enqueue_scripts() {
	wp_deregister_style( 'twentyseventeen-style' );

	wp_enqueue_style( 'twentyseventeen-style', get_template_directory_uri() . '/style.css' );
	wp_enqueue_style( 'wcpoa2017-style', get_stylesheet_directory_uri() . '/assets/css/style.css' );
}
add_action( 'wp_enqueue_scripts', 'wcpoa2017_enqueue_scripts' );
