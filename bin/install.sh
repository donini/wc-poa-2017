#!/bin/bash

# Verify if Composer is installed
if ! composer -V > /dev/null 2>&1; then
    echo 'Composer is required to run the script.';
    exit 1;
fi

# Verify if NPM is installed
if ! npm -v > /dev/null 2>&1; then
    echo 'NPM is required to run the script.';
    exit 1;
fi

# Install WP-CLI and WPackagist plugins and themes
composer install

# Install NPM packages
npm install

# Set WP-CLI command path
WP='vendor/bin/wp'

# Verify if the WordPress is installed, if not download and create the
# wp-config.php
if [ ! -f public/wp-load.php ]; then
    echo 'Downloading WordPress'
    $WP core download
fi

# Create the wp-config.php file, if not exists
if [ ! -f public/wp-config.php ]; then
    echo 'Configuring WordPress'
    $WP core config
fi

# Install the WordPress if it isn't
if ! wp core is-installed 2> /dev/null; then
    $WP db reset --yes 2> /dev/null || wp db create
    $WP core install
fi

# Install extra plugins
plugins=extra/plugins/*.zip
if [ $(ls -la ${plugins} 2> /dev/null | wc -l) -gt 0 ]; then # verify if has packages inner the directory
    for plugin in $plugins
    do
        if ! $WP plugin is-installed $(basename $plugin .zip); then
            $WP plugin install $plugin
        fi
    done
fi

# Install extra themes
themes=extra/themes/*.zip
if [ $(ls -la ${themes} 2> /dev/null | wc -l) -gt 0 ]; then # verify if has packages inner the directory
    for theme in $themes
    do
        if ! $WP theme is-installed $(basename $theme .zip); then
            $WP theme install $theme
        fi
    done
fi

# Activate all plugins
wp plugin activate --all

# Remove menu items before import
wp post delete $(wp post list --post_type='nav_menu_item' --format=ids) 2> /dev/null

# Import data
datafiles=extra/data/*.xml
if [ $(ls -la ${datafiles} 2> /dev/null | wc -l) -gt 0 ]; then # verify if has packages inner the directory
    if ! $WP plugin is-installed wordpress-importer; then
        $WP plugin install wordpress-importer
    fi

    $WP plugin activate wordpress-importer

    for data in $datafiles
    do
        $WP import $data --authors=create
    done
fi

# Update language
$WP core language update

# Build the theme
grunt

# activate the theme
$WP theme activate ${PWD##*/}
