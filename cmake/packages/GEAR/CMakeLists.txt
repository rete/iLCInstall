
# Whether to build Gear with ROOT TGeo support ?
option( GEAR_TGEO "Build Gear with ROOT TGeo support" ON )

set( GEAR_DEPENDS ILCUTIL CLHEP )
if( GEAR_TGEO )
  list( APPEND GEAR_DEPENDS ROOT )
endif()

# declare package
ilcsoft_package( 
  NAME GEAR
  DEPENDS ${GEAR_DEPENDS}
)

# Gear differentiate out-of source and in-source build for documentation install
# For out-of source the files to install does not exists. 
# TODO Must be fixed in HEAD !
ilcsoft_add_cmake_env( VAR INSTALL_DOC VALUE OFF )
ilcsoft_add_cmake_env( VAR GEAR_TGEO VALUE ${GEAR_TGEO} )

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/iLCSoft/Gear.git"
)

# export variables to init_ilcsoft.sh
ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME GEAR VALUE ${install_dir} )
ilcsoft_add_export_variable( NAME PATH VALUE "$GEAR/tools:$GEAR/bin" )
ilcsoft_add_export_variable( NAME LD_LIBRARY_PATH VALUE "$GEAR/lib" )

# export the package
ilcsoft_export_package()
