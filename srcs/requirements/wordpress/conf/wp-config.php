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
 * * ABSPATH
 *
 * @link https://wordpress.org/documentation/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'dbname' );

/** Database username */
define( 'DB_USER', 'user' );

/** Database password */
define( 'DB_PASSWORD', 'passwd' );

/** Database hostname */
define( 'DB_HOST', 'localhost' );

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
define( 'AUTH_KEY',         'J#`y<xkb oaE4&1Nz6M7AzIEov*-Qv!cM)5Q1-^|Yw1BFWl)FmZ?{XucR:,>@MXt' );
define( 'SECURE_AUTH_KEY',  'XTW[y:7{-<a*+bE!cI>q>?`jEX<JH%dL3p8Ifh%Z13ysQ?-jt7)pc$}al-9p|W_E' );
define( 'LOGGED_IN_KEY',    '>XD.<j+1$|`(vt#+u4sM,-[T=,Ueg-P_io5{=7z<[FgPh.#,`O9u.J]&>6O],m#0' );
define( 'NONCE_KEY',        '4~rXH$dpxnS-##f|6<l{(9%Q<XS,Vcj?ZS|7Sa_)rG,-XwzBLw-+7(RKIK5:dDD-' );
define( 'AUTH_SALT',        'a`G(PqKXgl!I0JAz)QkTrfnKxp|UTk4fSbVy})JjsNq6Sj6Ip34_~PGy~O0lR8a-' );
define( 'SECURE_AUTH_SALT', 'Y-Rj3sk/vn+^+5{w315X+wL_rgzj1md1+F^L/_fnS>0s|`*OAX/6+K)Pml|rv})+' );
define( 'LOGGED_IN_SALT',   'E>Lq?v6*t{h*y!!pJFayySq* V*%zQ;rdkJo!sZPOK+^c>|3Tx:b;l 4fo:USxtn' );
define( 'NONCE_SALT',       'T-hF[u2`Ne1M+-<Lc:QiG2E?Lfp3DC2Di-Q=(%{0ZTu*T[L`|7H;?c: iI|mxJ G' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

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
 * @link https://wordpress.org/documentation/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/var/www/html/wordpress' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
