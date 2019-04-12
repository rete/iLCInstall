
# declare package
ilcsoft_package( 
  NAME lcgeo
  DEPENDS DD4hep ROOT LCIO GEAR Geant4
)

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/iLCSoft/lcgeo.git"
)

# export variables to init_ilcsoft.sh
ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME lcgeo_DIR VALUE ${install_dir} )
ilcsoft_add_export_variable( NAME PATH VALUE "$lcgeo_DIR/bin" )
ilcsoft_add_export_variable( NAME LD_LIBRARY_PATH VALUE "$lcgeo_DIR/lib" )
ilcsoft_add_export_variable( NAME PYTHONPATH VALUE "$lcgeo_DIR/lib/python" )

# export the package
ilcsoft_export_package()
