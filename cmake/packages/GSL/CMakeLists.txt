
# declare package
ilcsoft_package( 
  NAME GSL 
  BASE 
)

ilcsoft_get_package_property( VAR pkg_version PROPERTY VERSION )
ilcsoft_get_package_property( VAR pkg_install_dir PROPERTY INSTALL_DIR )

# install from archive using wget
ilcsoft_package_install_target(
  MODE WGET
  URL "ftp://ftp.gnu.org/gnu/gsl/gsl-${pkg_version}.tar.gz"
  CONFIGURE_COMMAND ./configure --prefix=${pkg_install_dir}
  BUILD_IN_SOURCE
)

# export variables to init_ilcsoft.sh
ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME GSL_HOME VALUE ${install_dir} )
ilcsoft_add_export_variable( NAME PATH VALUE "$GSL_HOME/bin" )
ilcsoft_add_export_variable( NAME LD_LIBRARY_PATH VALUE "$GSL_HOME/lib" )

# export the package
ilcsoft_export_package()
