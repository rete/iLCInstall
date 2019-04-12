
# declare package
ilcsoft_package( 
  NAME CLHEP 
  BASE 
)

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://gitlab.cern.ch/CLHEP/CLHEP.git"
)

# export variables to init_ilcsoft.sh
ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME CLHEP VALUE ${install_dir} )
ilcsoft_add_export_variable( NAME CLHEP_BASE_DIR VALUE "$CLHEP" )
ilcsoft_add_export_variable( NAME CLHEP_INCLUDE_DIR VALUE "$CLHEP/include" )
ilcsoft_add_export_variable( NAME PATH VALUE "$CLHEP_BASE_DIR/bin" )
ilcsoft_add_export_variable( NAME LD_LIBRARY_PATH VALUE "$CLHEP_BASE_DIR/lib" )

ilcsoft_export_package()
