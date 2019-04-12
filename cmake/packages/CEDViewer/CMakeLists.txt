
# declare package
ilcsoft_package( 
  NAME CEDViewer
  DEPENDS Marlin MarlinUtil LCIO GEAR CLHEP GSL CED
)

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/iLCSoft/CEDViewer.git"
)

# export variables to init_ilcsoft.sh
ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME PATH VALUE "${install_dir}/bin" )
ilcsoft_add_export_variable( NAME LD_LIBRARY_PATH VALUE "${install_dir}/lib" )

# populate MARLIN_DLL property
ilcsoft_package_add_marlindll()

# export the package
ilcsoft_export_package()
