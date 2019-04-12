
# declare package
ilcsoft_package( 
  NAME GBL
  DEPENDS ROOT
)

# install the git repo
ilcsoft_package_install_target(
  MODE SVN_REPO 
  URL "https://svnsrv.desy.de/public/GeneralBrokenLines"
)

# export variables to init_ilcsoft.sh
ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME GBL VALUE ${install_dir} )
ilcsoft_add_export_variable( NAME LD_LIBRARY_PATH VALUE "$GBL/lib" )

# export the package
ilcsoft_export_package()
