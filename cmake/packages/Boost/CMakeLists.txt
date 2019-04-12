

ilcsoft_package( 
  NAME Boost 
  BASE 
)

ilcsoft_get_package_property( VAR pkg_version PROPERTY VERSION )
ilcsoft_get_package_property( VAR pkg_install_dir PROPERTY INSTALL_DIR )
get_property( COMPILE_CORES GLOBAL PROPERTY COMPILE_CORES )

# install from archive using wget
ilcsoft_package_install_target(
  MODE GIT_REPO
  URL "https://github.com/boostorg/boost.git"
  CONFIGURE_COMMAND ./bootstrap.sh 
  BUILD_COMMAND ./b2 install 
		--prefix=${pkg_install_dir}
		--threading=multi
		--link=shared
    -j${COMPILE_CORES}
  BUILD_IN_SOURCE
  NO_INSTALL
)

# export variables to init_ilcsoft.sh
ilcsoft_add_export_variable( NAME BOOST_ROOT VALUE ${pkg_install_dir} )

ilcsoft_export_package()
