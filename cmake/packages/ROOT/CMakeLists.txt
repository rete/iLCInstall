
# declare package
ilcsoft_package( 
  NAME ROOT 
  DEPENDS GSL #MySQL
  BASE 
)

# ROOT package options
ilcsoft_add_cmake_env( VAR rpath VALUE ON )
ilcsoft_add_cmake_env( VAR gsl_shared VALUE ON )
ilcsoft_add_cmake_env( VAR gdml VALUE ON )
ilcsoft_add_cmake_env( VAR minuit2 VALUE ON )
ilcsoft_add_cmake_env( VAR roofit VALUE ON )
ilcsoft_add_cmake_env( VAR unuran VALUE ON )
ilcsoft_add_cmake_env( VAR xrootd VALUE ON )
ilcsoft_add_cmake_env( VAR builtin_xrootd VALUE OFF )
ilcsoft_add_cmake_env( VAR fortran VALUE OFF )
ilcsoft_add_cmake_env( VAR mysql VALUE OFF )
# GSL config
ilcsoft_get_export_package_property( VAR gsl_install_dir PACKAGE GSL PROPERTY INSTALL_DIR )
ilcsoft_add_cmake_env( VAR GSL_CONFIG_EXECUTABLE VALUE ${gsl_install_dir}/bin/gsl-config )

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/root-project/root"
)

# export variables to init_ilcsoft.sh
ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME ROOTSYS VALUE ${install_dir} )
ilcsoft_add_export_variable( NAME PATH VALUE "$ROOTSYS/bin" )
ilcsoft_add_export_variable( NAME LD_LIBRARY_PATH VALUE "$ROOTSYS/lib" )
ilcsoft_add_export_variable( NAME PYTHONPATH VALUE "$ROOTSYS/lib" )

# export the package
ilcsoft_export_package()
