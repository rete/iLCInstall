
# declare package
ilcsoft_package(
  NAME CondDBMySQL
  DEPENDS ILCUTIL MySQL
  BASE
)

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO
  URL "https://github.com/iLCSoft/CondDBMySQL.git"
)

# export variables to init_ilcsoft.sh
ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME CondDBMySQL VALUE ${install_dir} )
ilcsoft_add_export_variable( NAME COND_DB_DEBUGLOG VALUE /dev/stdout )
ilcsoft_add_export_variable( NAME LD_LIBRARY_PATH VALUE "$CondDBMySQL/lib" )

# export the package
ilcsoft_export_package()
