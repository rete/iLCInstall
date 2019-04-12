
# RAIDA CMake options
option( RAIDA_DEBUG_VERBOSE_FACTORY "Set to ON to additional verbosity" OFF )

# declare package
ilcsoft_package( 
  NAME RAIDA
  DEPENDS ILCUTIL ROOT
)

ilcsoft_add_cmake_env( VAR RAIDA_DEBUG_VERBOSE_FACTORY VALUE ${RAIDA_DEBUG_VERBOSE_FACTORY} )

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/iLCSoft/RAIDA.git"
)

# export variables to init_ilcsoft.sh
ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME RAIDA_HOME VALUE ${install_dir} )
ilcsoft_add_export_variable( NAME PATH VALUE "$RAIDA_HOME/bin" )

# export the package
ilcsoft_export_package()
