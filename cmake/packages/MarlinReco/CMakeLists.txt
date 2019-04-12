
# MarlinReco CMake options
option( MarlinReco_AIDA_SUPPORT "Set to ON to build MarlinReco with AIDA" ON )

set( MarlinReco_DEPENDS ILCUTIL Marlin Boost MarlinUtil MarlinTrk MarlinKinfit GEAR GSL DD4hep )

if( MarlinReco_AIDA_SUPPORT )
  list( APPEND MarlinReco_DEPENDS RAIDA )
endif()

# declare package
ilcsoft_package( 
  NAME MarlinReco
  DEPENDS ${MarlinReco_DEPENDS}
)

ilcsoft_add_cmake_env( VAR MARLINRECO_FORTRAN VALUE OFF )
ilcsoft_add_cmake_env( VAR MARLINRECO_AIDA VALUE ${MarlinReco_AIDA_SUPPORT} )

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/iLCSoft/MarlinReco.git"
)

# populate MARLIN_DLL property
ilcsoft_package_add_marlindll()

# export the package
ilcsoft_export_package()
