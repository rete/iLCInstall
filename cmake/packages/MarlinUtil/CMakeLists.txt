
# declare package
ilcsoft_package( 
  NAME MarlinUtil
  DEPENDS ILCUTIL Marlin CED GEAR CLHEP GSL DD4hep ROOT
)

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/iLCSoft/MarlinUtil.git"
)

# export variables to init_ilcsoft.sh
ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME LD_LIBRARY_PATH VALUE ${install_dir}/lib )

# export the package
ilcsoft_export_package()
