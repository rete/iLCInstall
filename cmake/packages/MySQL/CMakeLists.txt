

ilcsoft_package( 
  NAME MySQL 
  BASE 
)

ilcsoft_get_package_property( VAR pkg_version PROPERTY VERSION )
ilcsoft_get_package_property( VAR pkg_install_dir PROPERTY INSTALL_DIR )

# install from archive using wget
ilcsoft_package_install_target(
  MODE WGET
  URL "http://dev.mysql.com/get/Downloads/MySQL-5.1/mysql-${pkg_version}.tar.gz"
  CONFIGURE_COMMAND ./configure 
    --prefix=${pkg_install_dir}
	  --enable-shared
 	  --enable-static
	  --enable-thread-safe-client
	  --enable-assembler
	  --enable-local-infile
	  --with-fast-mutexes
  	--with-big-tables
	  --with-unix-socket-path=/var/run/mysqld/mysqld.sock
	  --with-mysqld-user=mysql
	  --with-libwrap
	  --with-readline
	  --with-ssl
	  --without-docs
	  --with-extra-charsets=all
	  --with-plugins=max
	  --with-embedded-server
    --with-embedded-privilege-control
  BUILD_IN_SOURCE
)

# export variables to init_ilcsoft.sh
ilcsoft_add_export_variable( NAME MYSQL_HOME VALUE ${pkg_install_dir} )
ilcsoft_add_export_variable( NAME MYSQL VALUE "$MYSQL_HOME" )
ilcsoft_add_export_variable( NAME MYSQL_PATH VALUE "$MYSQL_HOME" )
ilcsoft_add_export_variable( NAME MYSQL_LIBDIR VALUE "$MYSQL_HOME/lib/mysql" )
ilcsoft_add_export_variable( NAME PATH VALUE "$MYSQL_HOME/bin" )
ilcsoft_add_export_variable( NAME LD_LIBRARY_PATH VALUE "$MYSQL_LIBDIR" )

ilcsoft_export_package()
