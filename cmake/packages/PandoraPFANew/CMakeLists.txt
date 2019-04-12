
# PandoraPFA CMake options
option( PandoraPFANew_ROOT_SUPPORT "Build PandoraPFANew with ROOT support" OFF )

# declare package
if( PandoraPFANew_ROOT_SUPPORT )
  ilcsoft_package( 
    NAME PandoraPFANew
    DEPENDS ROOT
  )
else()
  ilcsoft_package( 
    NAME PandoraPFANew
  )
endif()

ilcsoft_add_cmake_env( VAR PANDORA_MONITORING VALUE ${PandoraPFANew_ROOT_SUPPORT} )
ilcsoft_add_cmake_env( VAR LC_PANDORA_CONTENT VALUE ON )
ilcsoft_add_cmake_env( VAR EXAMPLE_PANDORA_CONTENT VALUE ON )
if( PandoraPFANew_ROOT_SUPPORT )
  ilcsoft_get_export_package_property( VAR ROOT_install_dir PACKAGE ROOT PROPERTY INSTALL_DIR )
  ilcsoft_add_cmake_env( VAR ROOT_DIR VALUE ${ROOT_install_dir}/cmake )
endif()

# install the git repo
ilcsoft_package_install_target(
  MODE GIT_REPO 
  URL "https://github.com/PandoraPFA/PandoraPFA.git"
)

# export variables to init_ilcsoft.sh
ilcsoft_get_package_property( VAR install_dir PROPERTY INSTALL_DIR )
ilcsoft_add_export_variable( NAME PANDORAPFANEW VALUE ${install_dir} )
ilcsoft_add_export_variable( NAME LD_LIBRARY_PATH VALUE "$PANDORAPFANEW/lib" )

# export the package
ilcsoft_export_package()
