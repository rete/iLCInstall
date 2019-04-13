
# Geant4 build options
option( GEANT4_WITH_QT            "Whether to build Geant4 with QT support" ON )
option( GEANT4_WITH_CLHEP         "Whether to build Geant4 with CLHEP support" ON )
option( GEANT4_WITH_XERCESX       "Whether to build Geant4 with XercesC support" ON )
option( GEANT4_RPATH_INSTALL      "Build Geant4 with rpath install" ON )

set( Geant4_DEPENDS )
# QT dependency
if( GEANT4_WITH_QT )
  list( APPEND Geant4_DEPENDS QT )
endif()
# CLHEP dependency
if( GEANT4_WITH_CLHEP )
  list( APPEND Geant4_DEPENDS CLHEP )
endif()
# XercesC dependency
if( GEANT4_WITH_XERCESX )
  list( APPEND Geant4_DEPENDS XercesC )
endif()

# declare package
if( Geant4_DEPENDS )
  ilcsoft_package(
    NAME Geant4
    DEPENDS ${Geant4_DEPENDS}
    BASE
  )
else()
  ilcsoft_package(
    NAME Geant4
    BASE
  )
endif()

# setup cmake variables to pass to Geant4
ilcsoft_add_cmake_env( VAR GEANT4_INSTALL_DATA VALUE ON )
ilcsoft_add_cmake_env( VAR GEANT4_USE_SYSTEM_EXPAT VALUE OFF )
ilcsoft_add_cmake_env( VAR GEANT4_USE_OPENGL_X11 VALUE ON )
ilcsoft_add_cmake_env( VAR GEANT4_USE_QT VALUE ${GEANT4_WITH_QT} )
if( ILCSOFT_USE_CXX11 )
  ilcsoft_add_cmake_env( VAR GEANT4_BUILD_CXXSTD VALUE "c++11" )
endif()
ilcsoft_add_cmake_env( VAR GEANT4_USE_SYSTEM_CLHEP VALUE ${GEANT4_WITH_CLHEP} )
ilcsoft_add_cmake_env( VAR CMAKE_INSTALL_RPATH_USE_LINK_PATH VALUE ${GEANT4_RPATH_INSTALL} )

# QT dependency
if( GEANT4_WITH_QT )
  ilcsoft_get_export_package_property( VAR qt_install_dir PACKAGE QT PROPERTY INSTALL_DIR )
  ilcsoft_add_cmake_env( VAR QT_QMAKE_EXECUTABLE VALUE ${qt_install_dir}/bin/qmake )
endif()
# CLHEP dependency
if( GEANT4_WITH_CLHEP )
  ilcsoft_get_export_package_property( VAR clhep_install_dir PACKAGE CLHEP PROPERTY INSTALL_DIR )
  ilcsoft_add_cmake_env( VAR CLHEP_ROOT_DIR VALUE ${clhep_install_dir} )
endif()
# XercesC dependency
if( GEANT4_WITH_XERCESX )
  ilcsoft_get_export_package_property( VAR xercesc_install_dir PACKAGE XercesC PROPERTY INSTALL_DIR )
  ilcsoft_add_cmake_env( VAR XERCESC_ROOT_DIR VALUE ${xercesc_install_dir} )
  ilcsoft_add_cmake_env( VAR GEANT4_USE_GDML VALUE ON )
endif()

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO
  URL "https://gitlab.cern.ch/geant4/geant4.git"
)

# export variables to init_ilcsoft.sh
# These lines are not really correct, but we keep them for
# backward compatibility for the time being.
# TODO adjust these lines for all compilers and plateforms supported by Geant4
if( "${CMAKE_SYSTEM_NAME}" STREQUAL "Linux" )
  ilcsoft_add_export_variable( NAME G4SYSTEM VALUE "Linux-g++" )
elseif( "${CMAKE_SYSTEM_NAME}" STREQUAL "Darwin" )
  ilcsoft_add_export_variable( NAME G4SYSTEM VALUE "Darwin-g++" )
elseif( "${CMAKE_SYSTEM_NAME}" STREQUAL "Windows" )
  ilcsoft_add_export_variable( NAME G4SYSTEM VALUE "Win-g++" )
endif()

ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME G4INSTALL VALUE ${install_dir} )
ilcsoft_add_export_variable( NAME G4ENV_INIT VALUE "$G4INSTALL/bin/geant4.sh" )
ilcsoft_add_custom_export( "test -r $G4ENV_INIT && { cd $(dirname $G4ENV_INIT) ; . ./$(basename $G4ENV_INIT) ; cd $OLDPWD ; }" )

# export the package
ilcsoft_export_package()
