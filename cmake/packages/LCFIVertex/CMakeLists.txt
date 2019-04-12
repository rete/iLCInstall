
# MarlinReco CMake options
option( LCFIVertex_AIDA_SUPPORT "Set to ON to build LCFIVertex with AIDA" ON )

set( LCFIVertex_DEPENDS ILCUTIL Marlin MarlinUtil LCIO Boost )

if( LCFIVertex_AIDA_SUPPORT )
  list( APPEND LCFIVertex_DEPENDS RAIDA )
endif()

# declare package
ilcsoft_package( 
  NAME LCFIVertex
  DEPENDS ${LCFIVertex_DEPENDS}
)

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/iLCSoft/LCFIVertex.git"
)

ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )

# populate MARLIN_DLL property
ilcsoft_package_add_marlindll( 
  LIBRARIES ${install_dir}/lib/libLCFIVertexProcessors${CMAKE_SHARED_LIBRARY_SUFFIX} 
)

# export variables to init_ilcsoft.sh
ilcsoft_add_export_variable( NAME LD_LIBRARY_PATH VALUE "${install_dir}/lib" )

# export the package
ilcsoft_export_package()
