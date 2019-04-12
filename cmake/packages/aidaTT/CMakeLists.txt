
# declare package
ilcsoft_package( 
  NAME aidaTT
  DEPENDS GSL GBL DD4hep LCIO
)

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/AIDASoft/aidaTT.git"
)

# export variables to init_ilcsoft.sh
ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME AIDATT VALUE ${install_dir} )
ilcsoft_add_export_variable( NAME PATH VALUE "$AIDATT/bin" )
ilcsoft_add_export_variable( NAME LD_LIBRARY_PATH VALUE "$AIDATT/lib" )

# export the package
ilcsoft_export_package()
