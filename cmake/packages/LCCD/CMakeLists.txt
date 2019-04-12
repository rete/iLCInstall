
# LCCD build options
option( LCCD_CONDDBMYSQL_SUPPORT "Build LCCD with CondDBMySQL support" ON )

set( LCCD_DEPENDS ILCUTIL LCIO )
if( LCCD_CONDDBMYSQL_SUPPORT )
  list( APPEND LCCD_DEPENDS CondDBMySQL )
endif()

# declare package
ilcsoft_package( 
  NAME LCCD
  DEPENDS ${LCCD_DEPENDS}
)

ilcsoft_add_cmake_env( VAR LCCD_CONDDBMYSQL VALUE ${LCCD_CONDDBMYSQL_SUPPORT} )

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/iLCSoft/LCCD.git"
)

# export variables to init_ilcsoft.sh
ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME LCCD VALUE ${install_dir} )

# export the package
ilcsoft_export_package()
