
# declare package
ilcsoft_package( 
  NAME FastJet 
  BASE 
)

ilcsoft_get_package_property( VAR pkg_version PROPERTY VERSION )
ilcsoft_get_package_property( VAR pkg_install_dir PROPERTY INSTALL_DIR )

# install the package using wget
ilcsoft_package_install_target(
  MODE WGET 
  URL "http://fastjet.fr/repo/fastjet-${pkg_version}.tar.gz"
  CONFIGURE_COMMAND ./configure --prefix=${pkg_install_dir} --enable-shared
  BUILD_IN_SOURCE
)

# export variables to init_ilcsoft.sh
ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME FastJet_HOME VALUE ${install_dir} )
ilcsoft_add_export_variable( NAME PATH VALUE "$FastJet_HOME/bin" )
ilcsoft_add_export_variable( NAME LD_LIBRARY_PATH VALUE "$FastJet_HOME/lib" )

# export the package
ilcsoft_export_package()
