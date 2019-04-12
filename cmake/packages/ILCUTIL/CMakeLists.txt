
# declare package
ilcsoft_package( 
  NAME ILCUTIL 
  BASE 
)

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/iLCSoft/iLCUtil.git"
)

# export variables to init_ilcsoft.sh
ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME ilcutil VALUE ${install_dir} )
ilcsoft_add_export_variable( NAME LD_LIBRARY_PATH VALUE "$ilcutil/lib" )

# export the package
ilcsoft_export_package()
