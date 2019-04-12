
# declare package
ilcsoft_package( 
  NAME MarlinTPC
  DEPENDS LCIO GEAR GSL Marlin LCCD ROOT RAIDA CLHEP KalTest KalDet PathFinder GBL
)

# install the git repo
ilcsoft_package_install_target(
  MODE SVN_REPO 
  URL "https://svnsrv.desy.de/public/marlintpc"
)

# export variables to init_ilcsoft.sh
ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME MARLINTPC VALUE ${install_dir} )
ilcsoft_add_export_variable( NAME PATH VALUE "$MARLINTPC/bin" )

# populate MARLIN_DLL property
ilcsoft_package_add_marlindll()

# export the package
ilcsoft_export_package()
