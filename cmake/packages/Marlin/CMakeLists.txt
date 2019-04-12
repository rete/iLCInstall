
# Marlin CMake options
option( MARLIN_AIDA_SUPPORT    "Set to ON to build Marlin with AIDA" ON )
option( MARLIN_CLHEP_SUPPORT   "Set to ON to build Marlin with CLHEP" ON )
option( MARLIN_LCCD_SUPPORT    "Set to ON to build Marlin with LCCD" ON )
option( MARLIN_GUI_SUPPORT     "Set to ON to build Marlin with QT" OFF )

set( MARLIN_DEPENDS ILCUTIL LCIO GEAR )
if( MARLIN_AIDA_SUPPORT )
  list( APPEND MARLIN_DEPENDS RAIDA )
endif()
if( MARLIN_CLHEP_SUPPORT )
  list( APPEND MARLIN_DEPENDS CLHEP )
endif()
if( MARLIN_LCCD_SUPPORT )
  list( APPEND MARLIN_DEPENDS LCCD )
endif()
if( MARLIN_GUI_SUPPORT )
  list( APPEND MARLIN_DEPENDS QT )
endif()

# declare package
ilcsoft_package( 
  NAME Marlin
  DEPENDS ${MARLIN_DEPENDS}
)

ilcsoft_add_cmake_env( VAR MARLIN_AIDA VALUE ${MARLIN_AIDA_SUPPORT} )
ilcsoft_add_cmake_env( VAR MARLIN_CLHEP VALUE ${MARLIN_CLHEP_SUPPORT} )
ilcsoft_add_cmake_env( VAR MARLIN_LCCD VALUE ${MARLIN_LCCD_SUPPORT} )
ilcsoft_add_cmake_env( VAR MARLIN_GUI VALUE ${MARLIN_GUI_SUPPORT} )

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/iLCSoft/Marlin.git"
)

# export variables to init_ilcsoft.sh
ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME MARLIN VALUE ${install_dir} )
ilcsoft_add_export_variable( NAME PATH VALUE "$MARLIN/bin" )

# export the package
ilcsoft_export_package()
