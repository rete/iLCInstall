
option( DD4hep_RPATH_INSTALL "Build DD4hep with rpath install" OFF )

# declare package
ilcsoft_package(
  NAME DD4hep
  DEPENDS ROOT LCIO GEAR Geant4 CLHEP Boost
)

ilcsoft_get_export_package_property( VAR boost_install_dir PACKAGE Boost PROPERTY INSTALL_DIR )
ilcsoft_add_cmake_env( VAR BOOST_ROOT VALUE ${boost_install_dir} )
ilcsoft_add_cmake_env( VAR DD4HEP_USE_GEANT4 VALUE ON )
ilcsoft_add_cmake_env( VAR DD4HEP_USE_LCIO VALUE ON )
ilcsoft_add_cmake_env( VAR DD4HEP_USE_XERCESC VALUE OFF )
ilcsoft_add_cmake_env( VAR DD4HEP_USE_PYROOT VALUE OFF )
ilcsoft_add_cmake_env( VAR DD4HEP_USE_GEAR VALUE ON )
ilcsoft_add_cmake_env( VAR DD4HEP_USE_BOOST VALUE ON )
if( DD4hep_RPATH_INSTALL )
  ilcsoft_add_cmake_env( VAR CMAKE_INSTALL_RPATH_USE_LINK_PATH VALUE ON )
endif()
if( ILCSOFT_USE_CXX11 )
  ilcsoft_add_cmake_env( VAR DD4HEP_USE_CXX11 VALUE ON )
endif()

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO
  URL "https://github.com/AIDASoft/DD4hep.git"
)

# export variables to init_ilcsoft.sh
ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME DD4HEP VALUE ${install_dir} )
ilcsoft_add_export_variable( NAME DD4hepINSTALL VALUE ${install_dir} )
ilcsoft_add_export_variable( NAME DD4hep_DIR VALUE ${install_dir} )
ilcsoft_add_export_variable( NAME DD4hep_ROOT VALUE ${install_dir} )
ilcsoft_add_export_variable( NAME PATH VALUE "$DD4HEP/bin" )
ilcsoft_add_export_variable( NAME LD_LIBRARY_PATH VALUE "$DD4HEP/lib" )
ilcsoft_add_export_variable( NAME PYTHONPATH VALUE "$DD4HEP/python:$DD4HEP/DDCore/python" )

# export the package
ilcsoft_export_package()
