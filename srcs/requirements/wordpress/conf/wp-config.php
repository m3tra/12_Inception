<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * Localized language
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'mysql' );

/** Database password */
define( 'DB_PASSWORD', 'Quarentae2' );

/** Database hostname */
define( 'DB_HOST', 'mariadb' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',          '/UUZXnCw^? |~G+5B4SLXe,P/>q%cKzZ^!<rE,gy?2=kR$1Bts;$BD9gn#MS4Vz.' );
define( 'SECURE_AUTH_KEY',   'bc9Sg=sdfyR.qszy-{[5%Ga8N=5n-@Ib+sni73|PsjSYhqma(w*sM`h|d29a(P6q' );
define( 'LOGGED_IN_KEY',     'JRAH _y{@4$V J|#UgQ!e/w*Lip0_L*lLenfU;/^v28BgbcrrNWh$Mwc*DHEWBi^' );
define( 'NONCE_KEY',         '>7w]x#c~IMM;IVBW8{!T.ekH1JXBo`ir^C;C_r[MMzAwts7}4ACyMs*yUJG/vIG)' );
define( 'AUTH_SALT',         'kk&qKt]`YLtBc:E;;W`#=w%B.)bRgP8~6M0h 4MgT1lleqq&})u0~q=Vmc`qw.2~' );
define( 'SECURE_AUTH_SALT',  '>taU83]m3~7PGH}h],WH<(fSQr]llz:0CP>tAS6qw.&|.n`G,#M6{kM2zt3$VONU' );
define( 'LOGGED_IN_SALT',    'v3myao%x^~~NN?x/uJ>W_<n4,s,KtNhK&:EJ?jVG_9$^=e_?Gl-S>tk8:SwLG|&@' );
define( 'NONCE_SALT',        '$[RU4<VOqmqD4.Ib:erP4(4YmEv1q?}?v3RIIkp^ovPC&j8%8NHbP^Q($X>-L?A`' );
define( 'WP_CACHE_KEY_SALT', '9mC2r}SKdSu@od+$ (r=j.g*A{`83 e2]d$:qm!R!#xoU8.Sz8P.L8yl4GXOBT;H' );


/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';


/* Add any custom values between this line and the "stop editing" line. */



/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
if ( ! defined( 'WP_DEBUG' ) ) {
        define( 'WP_DEBUG', false );
}

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
