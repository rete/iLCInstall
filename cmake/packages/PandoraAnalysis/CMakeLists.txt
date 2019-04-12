

ilcsoft_package( 
  NAME PandoraAnalysis
  DEPENDS ROOT Marlin MarlinUtil LCIO DD4hep ILCUTIL
)

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/PandoraPFA/LCPandoraAnalysis.git"
)

# export variables to init_ilcsoft.sh
ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME PANDORA_ANALYSIS_DIR VALUE ${install_dir} )
ilcsoft_add_export_variable( NAME PATH VALUE "$PANDORA_ANALYSIS_DIR/bin" )
ilcsoft_add_export_variable( NAME LD_LIBRARY_PATH VALUE "$PANDORA_ANALYSIS_DIR/lib" )

# export the package
ilcsoft_export_package()
