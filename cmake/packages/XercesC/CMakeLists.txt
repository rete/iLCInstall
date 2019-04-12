
# declare package
ilcsoft_package( 
  NAME XercesC 
  BASE 
)

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/apache/xerces-c.git"
)

# export variables to init_ilcsoft.sh
ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME XercesC_HOME VALUE ${install_dir} )
ilcsoft_add_export_variable( NAME PATH VALUE "$XercesC_HOME/bin" )
ilcsoft_add_export_variable( NAME LD_LIBRARY_PATH VALUE "$XercesC_HOME/lib" )

# export the package
ilcsoft_export_package()
