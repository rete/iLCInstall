########################################################
# CMake helper macros to build iLCSoft
# @author Remi Ete, DESY
include(CMakeParseArguments)

#---------------------------------------------------------------------------------------------------
#  ilcsoft_detect_configuration
#  
#  \author  R.Ete
#  \version 1.0
#  
#---------------------------------------------------------------------------------------------------
function( ilcsoft_detect_configuration )  
  # package versions can be set by command line
  if( ILCSOFT_USE_HEAD )
    set( versions_file ${PROJECT_SOURCE_DIR}/cmake/releases/head/versions.cmake )
  else()
    set( versions_file ${PROJECT_SOURCE_DIR}/cmake/releases/latest/versions.cmake )    
  endif()
  # default path for installation
  set( ILCSOFT_INSTALL_PREFIX "${PROJECT_SOURCE_DIR}/install" CACHE STRING "The ILCSoft install prefix" )
  set( ILCSOFT_PACKAGES_DIR "${PROJECT_SOURCE_DIR}/cmake/packages" CACHE STRING "The path to ILCSoft packages CMake macros" )
  set( ILCSOFT_VERSIONS_FILE "${versions_file}" CACHE STRING "The path to ILCSoft package version definitions" )
  set( CMAKE_BUILD_TYPE Debug CACHE STRING "CMake build type" FORCE )
  set( ILCSOFT_INSTALL_MODE "" CACHE STRING "The ILCSoft install mode (base or ilcsoft)" )
  # local variables
  set( install_prefix ${ILCSOFT_INSTALL_PREFIX} )
  set( binary_dir ${PROJECT_BINARY_DIR}/binary )
  set( packages_dir ${ILCSOFT_PACKAGES_DIR} )
  set( versions_file ${ILCSOFT_VERSIONS_FILE} )
  set( packages_file )
  if( NOT EXISTS ${packages_dir} )
    message( FATAL_ERROR "Path to ilcsoft cmake packages does not exists: ${packages_dir}" )
  endif()
  if( NOT EXISTS ${versions_file} )
    message( FATAL_ERROR "Version file \"${versions_file}\" not found!" )
    message( FATAL_ERROR "Set it with -DILCSOFT_VERSIONS_FILE=/path/to/versionfile.cmake" )
  endif()
  # deal with install mode. The variable ILCSOFT_INSTALL_MODE must be set by command line
  set( ILCSOFT_INSTALL_MODES base ilcsoft )
  if( NOT DEFINED ILCSOFT_INSTALL_MODE )
    message( FATAL_ERROR "ILCSOFT_INSTALL_MODE is not set (base or ilcsoft)!" )
    message( FATAL_ERROR "Please use e.g -DILCSOFT_INSTALL_MODE=base to set it" )    
  endif()
  if( NOT "${ILCSOFT_INSTALL_MODE}" IN_LIST ILCSOFT_INSTALL_MODES )
    message( FATAL_ERROR "ILCSOFT_INSTALL_MODE must be set to \"base\" or \"ilcsoft\"" )
  endif()
  if( ILCSOFT_USE_HEAD )
    set( packages_file ${PROJECT_SOURCE_DIR}/cmake/releases/head/${ILCSOFT_INSTALL_MODE}.cmake )
  else()
    set( packages_file ${PROJECT_SOURCE_DIR}/cmake/releases/latest/${ILCSOFT_INSTALL_MODE}.cmake )
  endif()
  set( ILCSOFT_PACKAGES_FILE ${packages_file} CACHE STRING "The ILCSoft packages CMake file" )
  set( packages_file ${ILCSOFT_PACKAGES_FILE} )
  if( NOT EXISTS ${packages_file} )
    message( FATAL_ERROR "Packages file \"${packages_file}\" not found!" )
    message( FATAL_ERROR "Set it with -DILCSOFT_PACKAGES_FILE=/path/to/packagesfile.cmake" )
  endif()
  set_property( GLOBAL PROPERTY ILCSOFT_INSTALL_PREFIX ${install_prefix} )
  set_property( GLOBAL PROPERTY ILCSOFT_INSTALL_PREFIX_BASE ${install_prefix} )
  set_property( GLOBAL PROPERTY ILCSOFT_INSTALL_PREFIX_FULL ${install_prefix} )
  set_property( GLOBAL PROPERTY ILCSOFT_INSTALL_MODE ${ILCSOFT_INSTALL_MODE} )
  set_property( GLOBAL PROPERTY ILCSOFT_BINARY_DIR ${binary_dir} )
  set_property( GLOBAL PROPERTY ILCSOFT_PACKAGES_DIR ${packages_dir} )
  set_property( GLOBAL PROPERTY ILCSOFT_VERSIONS_FILE ${versions_file} )
  set_property( GLOBAL PROPERTY ILCSOFT_PACKAGES_FILE ${packages_file} )
  message( STATUS "+ Loading versions file ..." )
  include( ${versions_file} )
  message( STATUS "+ Loading versions file ... OK" )
  # set additional properties after getting versions
  set_property( GLOBAL PROPERTY ILCSOFT_PACKAGE_VERSION ${ILCSOFT_PACKAGE_VERSION} )
  set( ${PROJECT_NAME}_VERSION ${ILCSOFT_PACKAGE_VERSION} )  
  if( "${ILCSOFT_INSTALL_MODE}" STREQUAL "ilcsoft" )
    set_property( GLOBAL PROPERTY ILCSOFT_INSTALL_PREFIX_FULL ${install_prefix}/${ILCSOFT_PACKAGE_VERSION} )
  endif()
  message( STATUS "+ Loading packages file ..." )
  include( ${packages_file} )
  message( STATUS "+ Loading packages file ... OK" )
endfunction()

#---------------------------------------------------------------------------------------------------
#  ilcsoft_set_package_version
#
#  Arguments
#  ---------
#  PACKAGE          -> name of the package
#  VERSION          -> Package version to set
#
#  \author  R.Ete
#  \version 1.0
#
#---------------------------------------------------------------------------------------------------
function( ilcsoft_set_package_version )
  cmake_parse_arguments(ARG "" "PACKAGE;VERSION" "" ${ARGN} )
  set_property( GLOBAL PROPERTY PACKAGE_${ARG_PACKAGE}_VERSION ${ARG_VERSION} )
  message( STATUS "++ Package ${ARG_PACKAGE} version set to \"${ARG_VERSION}\"" )
endfunction()


#---------------------------------------------------------------------------------------------------
#  ilcsoft_get_package_version
#
#  Arguments
#  ---------
#  PACKAGE          -> name of the package
#  VAR              -> The package version variable name to receive
#
#  \author  R.Ete
#  \version 1.0
#
#---------------------------------------------------------------------------------------------------
function( ilcsoft_get_package_version )
  cmake_parse_arguments(ARG "" "PACKAGE;VAR" "" ${ARGN} )
  get_property( var GLOBAL PROPERTY PACKAGE_${ARG_PACKAGE}_VERSION )
  set( ${ARG_VAR} ${var} PARENT_SCOPE )
endfunction()


#---------------------------------------------------------------------------------------------------
#  ilcsoft_add_cmake_env
#
#  Arguments
#  ---------
#  VALUE            -> The cmake variable value
#  VAR              -> The cmake variable name
#
#  \author  R.Ete
#  \version 1.0
#
#---------------------------------------------------------------------------------------------------
function( ilcsoft_add_cmake_env )
  cmake_parse_arguments(ARG "" "VAR" "VALUE" ${ARGN} )
  set( CMAKE_ENV_NAME ${ARG_VAR} )
  set( CMAKE_ENV_VALUE ${ARG_VALUE} )
  # check if we are in a package macro
  ilcsoft_get_package_property( VAR pkg_name PROPERTY NAME )
  if( NOT pkg_name )
    # global cmake env case
    # check if the variable is not yet in the registry
    get_property( cmake_envs GLOBAL PROPERTY ILCSOFT_CMAKE_ENV )
    if( NOT "${CMAKE_ENV_NAME}" IN_LIST cmake_envs )
      set_property( GLOBAL APPEND PROPERTY ILCSOFT_CMAKE_ENV ${CMAKE_ENV_NAME} )
    endif()
    # set global cmake variable
    set_property( GLOBAL PROPERTY ILCSOFT_CMAKE_ENV_${CMAKE_ENV_NAME} ${CMAKE_ENV_VALUE} )
  else()
    # package environment case
    # check if the variable is not yet in the registry
    ilcsoft_get_package_property( VAR cmake_envs PROPERTY CMAKE_ENV )
    if( NOT "${CMAKE_ENV_NAME}" IN_LIST cmake_envs )
      ilcsoft_set_package_property( APPEND PROPERTY CMAKE_ENV VALUE ${CMAKE_ENV_NAME} )
    endif()
    # set package cmake variable
    ilcsoft_set_package_property( PROPERTY CMAKE_ENV_${CMAKE_ENV_NAME} VALUE ${CMAKE_ENV_VALUE} )
  endif()
endfunction()


#---------------------------------------------------------------------------------------------------
#  ilcsoft_add_export_variable
#
#  Arguments
#  ---------
#  VALUE            -> The environment variable value
#  NAME             -> The environment variable name
#
#  \author  R.Ete
#  \version 1.0
#
#---------------------------------------------------------------------------------------------------
function( ilcsoft_add_export_variable )
  cmake_parse_arguments(ARG "" "NAME" "VALUE" ${ARGN} )
  # check if we are in a package macro
  ilcsoft_get_package_property( VAR pkg_name PROPERTY NAME )
  if( NOT pkg_name )
    # global export variable case
    # check if the variable is not yet in the registry
    get_property( export_vars GLOBAL PROPERTY ILCSOFT_EXPORT_VARS )
    if( NOT "${ARG_NAME}" IN_LIST export_vars )
      set_property( GLOBAL APPEND PROPERTY ILCSOFT_EXPORT_VARS ${ARG_NAME} )
    endif()
    # set global export variable
    set_property( GLOBAL PROPERTY ILCSOFT_EXPORT_VARS_${ARG_NAME} ${ARG_VALUE} )
  else()
    # package environment case
    # check if the variable is not yet in the registry
    ilcsoft_get_package_property( VAR export_vars PROPERTY EXPORT_VARS )
    if( NOT "${ARG_NAME}" IN_LIST export_vars )
      ilcsoft_set_package_property( APPEND PROPERTY EXPORT_VARS VALUE ${ARG_NAME} )
    endif()
    # set package cmake variable
    ilcsoft_set_package_property( PROPERTY EXPORT_VARS_${ARG_NAME} VALUE ${ARG_VALUE} )
  endif()
endfunction()

#---------------------------------------------------------------------------------------------------
#  ilcsoft_load_package (private)
#
#  Arguments
#  ---------
#  PACKAGE          -> The package to load
#
#  \author  R.Ete
#  \version 1.0
#
#---------------------------------------------------------------------------------------------------
function( ilcsoft_load_package )
  cmake_parse_arguments(ARG "" "PACKAGE" "" ${ARGN} )
  get_property( ILCSOFT_PACKAGES_DIR GLOBAL PROPERTY ILCSOFT_PACKAGES_DIR )
  if( NOT ILCSOFT_PACKAGES_DIR )
    message( FATAL_ERROR "ILCSOFT_PACKAGES_DIR not set! Couldn't load package ${ARG_PACKAGE}" )
  endif()
  set( pkg_include_dir ${ILCSOFT_PACKAGES_DIR}/${ARG_PACKAGE} )
  if( NOT EXISTS ${pkg_include_dir}/CMakeLists.txt )
    message( FATAL_ERROR "Couldn't find package configuration file (package ${ARG_PACKAGE})" )
  endif()
  if( NOT ILCSOFT_PACKAGE_${ARG_PACKAGE}_INSTALL_MODE )
    message( FATAL_ERROR "Loading package ${ARG_PACKAGE} with undefined mode ..." )
  endif()
  message( STATUS "Loading package ${ARG_PACKAGE} (mode: ${ILCSOFT_PACKAGE_${ARG_PACKAGE}_INSTALL_MODE})" )
  add_subdirectory( ${pkg_include_dir} )
endfunction()

#---------------------------------------------------------------------------------------------------
#  ilcsoft_install_package
#
#  Arguments
#  ---------
#  PACKAGE          -> The package to install
#
#  \author  R.Ete
#  \version 1.0
#
#---------------------------------------------------------------------------------------------------
function( ilcsoft_install_package )
  cmake_parse_arguments(ARG "" "PACKAGE" "" ${ARGN} )
  set( ILCSOFT_PACKAGE_${ARG_PACKAGE}_INSTALL_MODE "install" )
  ilcsoft_load_package( PACKAGE ${ARG_PACKAGE} )
endfunction()

#---------------------------------------------------------------------------------------------------
#  ilcsoft_link_package
#
#  Arguments
#  ---------
#  PACKAGE          -> The package to link
#  PATH             -> The path to where the package should be linked (optional)
#
#  \author  R.Ete
#  \version 1.0
#
#---------------------------------------------------------------------------------------------------
function( ilcsoft_link_package )
  cmake_parse_arguments(ARG "" "PACKAGE;PATH" "" ${ARGN} )
  set( ILCSOFT_PACKAGE_${ARG_PACKAGE}_INSTALL_MODE "link" )
  if( NOT DEFINED ARG_PATH )
    get_property( base_prefix GLOBAL PROPERTY ILCSOFT_INSTALL_PREFIX_BASE )
    ilcsoft_get_package_version( VAR pkg_version PACKAGE ${ARG_PACKAGE} )
    set( ARG_PATH ${base_prefix}/${ARG_PACKAGE}/${pkg_version} )
  endif()
  set( ILCSOFT_PACKAGE_${ARG_PACKAGE}_LINK_PATH "${ARG_PATH}" )
  # load the package macro
  ilcsoft_load_package( PACKAGE ${ARG_PACKAGE} )
  if( NOT EXISTS ${ARG_PATH} )
    message( FATAL_ERROR "Couldn't create symbolic link for package ${ARG_PACKAGE}: link target does not exists!" )
  endif()
  ilcsoft_get_export_package_property( VAR pkg_install_dir PACKAGE ${ARG_PACKAGE} PROPERTY INSTALL_DIR )
  get_filename_component( parent_dir ${pkg_install_dir} DIRECTORY )
  message( STATUS "Install mode set to 'link'")
  message( STATUS "+=> Link target: ${ARG_PATH}" )
  message( STATUS "+=> Link name: ${pkg_install_dir}" )
  message( STATUS "+=> Package directory: ${parent_dir}" )
  if( NOT parent_dir )
    message( FATAL_ERROR "Couldn't get the parent directory name of the symlink for package ${ARG_PACKAGE}" )
  endif()
  if( NOT EXISTS ${parent_dir} )
    message( STATUS "[DEBUG] creating ${ARG_PACKAGE} package directory ${parent_dir}" )
    file( MAKE_DIRECTORY ${parent_dir} )
  endif()
  ADD_CUSTOM_TARGET( 
    ${ARG_PACKAGE}_link ALL 
    COMMAND ${CMAKE_COMMAND} -E create_symlink ${ARG_PATH} ${pkg_install_dir} 
  )
endfunction()


#---------------------------------------------------------------------------------------------------
#  ilcsoft_install_marlinpkg
#
#  Arguments
#  ---------
#  PACKAGE          -> The package to link
#  PATH             -> The path to where the package should be linked (optional)
#
#  \author  R.Ete
#  \version 1.0
#
#---------------------------------------------------------------------------------------------------
function( ilcsoft_install_marlinpkg )
  cmake_parse_arguments(ARG "" "PACKAGE;GIT_USER;GIT_REPO" "DEPENDS" ${ARGN} )
  set( GIT_USER "iLCSoft" )
  set( GIT_REPO ${ARG_PACKAGE} )
  if( ARG_GIT_USER )
    set( GIT_USER ${ARG_GIT_USER} )
  endif()
  if( ARG_GIT_REPO )
    set( GIT_REPO ${ARG_GIT_REPO} )
  endif()
  set( MarlinPkg_NAME ${ARG_PACKAGE} )
  set( MarlinPkg_GITURL "https://github.com/${GIT_USER}/${GIT_REPO}.git" )
  set( MarlinPkg_DEPENDS Marlin LCIO ${ARG_DEPENDS} )
  get_property( binary_dir GLOBAL PROPERTY ILCSOFT_BINARY_DIR )
  set( pkg_cmake_dir ${binary_dir}/${MarlinPkg_NAME} )
  configure_file( 
    ${PROJECT_SOURCE_DIR}/cmake/packages/MarlinPkg.cmake.in
    ${pkg_cmake_dir}/CMakeLists.txt
    @ONLY
  )
  set( ILCSOFT_PACKAGE_${MarlinPkg_NAME}_INSTALL_MODE "install" )
  message( STATUS "Loading package ${MarlinPkg_NAME} (mode: ${ILCSOFT_PACKAGE_${MarlinPkg_NAME}_INSTALL_MODE})" )
  add_subdirectory( ${pkg_cmake_dir} )
endfunction()




#---------------------------------------------------------------------------------------------------
#  ilcsoft_package
#
#  Arguments
#  ---------
#  NAME               -> The package name to declare
#  BASE               -> Whether the package is a base package
#
#  \author  R.Ete
#  \version 1.0
#
#---------------------------------------------------------------------------------------------------
function( ilcsoft_package )
  cmake_parse_arguments( ARG "BASE" "NAME" "DEPENDS" ${ARGN} )
  set( pkg_full_depends )
  set( pkg_depends ${ARG_DEPENDS} )
  set( pkg_name ${ARG_NAME} )
  # package name
  ilcsoft_set_package_property( PROPERTY NAME VALUE ${pkg_name} )
  # package version
  ilcsoft_get_package_version( VAR pkg_version PACKAGE ${pkg_name} )
  if( NOT pkg_version )
    message( FATAL_ERROR "Package version not set for package '${pkg_name}'" )
  endif()
  # give the possibility to overwrite a package version by command line
  set( PACKAGE_${pkg_name}_VERSION "" CACHE STRING "The ${pkg_name} package version" )
  if( NOT ${PACKAGE_${pkg_name}_VERSION} STREQUAL "" )
    set( pkg_version ${PACKAGE_${pkg_name}_VERSION} )
  endif()
  ilcsoft_set_package_property( PROPERTY VERSION VALUE ${pkg_version} )
  message( STATUS "-----------------------------------------------------" )
  message( STATUS "++ New package detected: ${pkg_name} (${pkg_version})" )
  # is the package a base package ?
  # the install path also depends on this
  get_property( ILCSOFT_INSTALL_PREFIX_FULL GLOBAL PROPERTY ILCSOFT_INSTALL_PREFIX_FULL )
  ilcsoft_set_package_property( PROPERTY INSTALL_DIR VALUE ${ILCSOFT_INSTALL_PREFIX_FULL}/${pkg_name}/${pkg_version} )
  if( DEFINED ARG_BASE )
    ilcsoft_set_package_property( PROPERTY BASE VALUE True )
  else()
    ilcsoft_set_package_property( PROPERTY BASE VALUE False )
  endif()
  # build the full list of package dependencies
  if( pkg_depends )
    foreach( pkg ${pkg_depends} )
      ilcsoft_get_export_package_property( VAR pkg_exported PACKAGE ${pkg} PROPERTY EXPORTED )
      if( NOT pkg_exported )
        message( FATAL_ERROR "Missing package dependency: ${pkg}" )
      endif()
      ilcsoft_get_export_package_property( VAR pkg_deps PACKAGE ${pkg} PROPERTY DEPENDS )
      if( pkg_deps )
        list( APPEND pkg_full_depends ${pkg_deps} )
      endif()

    endforeach()
    list( APPEND pkg_full_depends ${pkg_depends} )
    list( REMOVE_DUPLICATES pkg_full_depends )
    ilcsoft_set_package_property( PROPERTY DEPENDS VALUE ${pkg_full_depends} )
  endif()
  # create high level package options
  set( PACKAGE_${pkg_name}_URL "" CACHE STRING "The ${pkg_name} package url (git url or wget source)" )
  if( NOT ${PACKAGE_${pkg_name}_URL} STREQUAL "" )
    ilcsoft_set_package_property( PROPERTY URL VALUE ${PACKAGE_${pkg_name}_URL} )
  endif()
  ilcsoft_set_package_property( PROPERTY INSTALL_MODE VALUE ${ILCSOFT_PACKAGE_${ARG_PACKAGE}_INSTALL_MODE} )
endfunction()

#---------------------------------------------------------------------------------------------------
#  ilcsoft_set_package_property
#
#  Arguments
#  ---------
#  PROPERTY           -> The property name to set
#  VALUE              -> The property value
#  APPEND             -> Whether the value should be appended or overwritten
#
#  \author  R.Ete
#  \version 1.0
#
#---------------------------------------------------------------------------------------------------
function( ilcsoft_set_package_property )
  cmake_parse_arguments( ARG "APPEND" "PROPERTY" "VALUE" ${ARGN} )
  if( ARG_APPEND )
    set_property( DIRECTORY APPEND PROPERTY ILCSOFT_PACKAGE_${ARG_PROPERTY} ${ARG_VALUE} )
  else()
    set_property( DIRECTORY PROPERTY ILCSOFT_PACKAGE_${ARG_PROPERTY} ${ARG_VALUE} )
  endif()
endfunction()

#---------------------------------------------------------------------------------------------------
#  ilcsoft_get_package_property
#
#  Arguments
#  ---------
#  PROPERTY           -> The property name to get
#  VAR                -> The property value to receive
#
#  \author  R.Ete
#  \version 1.0
#
#---------------------------------------------------------------------------------------------------
function( ilcsoft_get_package_property )
  cmake_parse_arguments( ARG "" "VAR;PROPERTY" "" ${ARGN} )
  get_property( var DIRECTORY PROPERTY ILCSOFT_PACKAGE_${ARG_PROPERTY} )
  set( ${ARG_VAR} ${var} PARENT_SCOPE )
endfunction()

#---------------------------------------------------------------------------------------------------
#  ilcsoft_get_export_package_property
#
#  Arguments
#  ---------
#  PROPERTY           -> The property name to get
#  VAR                -> The property value to receive
#
#  \author  R.Ete
#  \version 1.0
#
#---------------------------------------------------------------------------------------------------
function( ilcsoft_get_export_package_property )
  cmake_parse_arguments( ARG "" "VAR;PACKAGE;PROPERTY" "" ${ARGN} )  
  get_property( var GLOBAL PROPERTY ILCSOFT_PKG_EXPORT_${ARG_PACKAGE}_${ARG_PROPERTY} )
  set( ${ARG_VAR} ${var} PARENT_SCOPE )
endfunction()

#---------------------------------------------------------------------------------------------------
#  ilcsoft_package_install_target
#
#  Arguments
#  ---------
#  NO_INSTALL         -> Whether to suppress the install command
#  MODE               -> The installation mode of package (GIT_REPO, SVN_REPO or WGET)
#  TARGET             -> The target name (optional). Default is package name
#  URL                -> The http url (for WGET) or the git url (for GIT_REPO) or svn repo (for SVN_REPO) 
#  BUILD_COMMAND      -> The build command (overwrite the default 'make -jN')
#  CONFIGURE_COMMAND  -> The configure command (overwrite 'cmake')
#  BUILD_IN_SOURCE    -> Whether to build the package in the source directory
#
#  \author  R.Ete
#  \version 1.0
#
#---------------------------------------------------------------------------------------------------
function( ilcsoft_package_install_target )
  include( ExternalProject )
  cmake_parse_arguments( ARG "SOURCE_INSTALL;NO_INSTALL;BUILD_IN_SOURCE" "SVN_PATH;MODE;TARGET;URL" "BUILD_COMMAND;CONFIGURE_COMMAND;INSTALL_COMMAND" ${ARGN} )
  # get needed properties  
  ilcsoft_get_package_property( VAR pkg_name PROPERTY NAME )
  ilcsoft_get_package_property( VAR pkg_version PROPERTY VERSION )
  ilcsoft_get_package_property( VAR pkg_depends PROPERTY DEPENDS )
  ilcsoft_get_package_property( VAR PKG_INSTALL_DIR PROPERTY INSTALL_DIR )
  ilcsoft_get_package_property( VAR pkg_url PROPERTY URL )
  ilcsoft_get_package_property( VAR pkg_install_mode PROPERTY INSTALL_MODE )
  get_property( ILCSOFT_BINARY_DIR GLOBAL PROPERTY ILCSOFT_BINARY_DIR )
  get_property( COMPILE_CORES GLOBAL PROPERTY COMPILE_CORES )
  if( NOT "${pkg_install_mode}" STREQUAL "install" )
    return()
  endif()
  # not in a package directory ?
  if( NOT pkg_name )
    message( FATAL_ERROR "ilcsoft_package_install_target must be called from within a package macro !" )
  endif()
  set( available_modes GIT_REPO WGET SVN_REPO )
  message( STATUS "[DEBUG] available_modes: ${available_modes}" )
  message( STATUS "[DEBUG] ARG_MODE: ${ARG_MODE}" )
  if( NOT "${ARG_MODE}" IN_LIST available_modes )
    message( FATAL_ERROR "Package ${pkg_name} unknown install mode (${ARG_MODE} ?)" )
  endif()
  # set the target name, either the one specified by the user or the package name 
  if( NOT DEFINED ARG_TARGET )
    set( ARG_TARGET ${pkg_name} )
  endif()
  # handle package dependencies 
  set( pkg_target_depends "" )
  foreach( pkg_dep ${pkg_depends} )
    if( TARGET ${pkg_dep} )
      list( APPEND pkg_target_depends ${pkg_dep} )
    endif()
  endforeach()
  if( NOT pkg_depends )
    set( pkg_depends "" )
  endif()
  # install command
  set( INSTALL_COMMAND make install )
  if( ARG_INSTALL_COMMAND )
    message( STATUS "[DEBUG] providing install command : ${ARG_INSTALL_COMMAND}" )
    set( INSTALL_COMMAND ${ARG_INSTALL_COMMAND} )
  elseif( ARG_NO_INSTALL )
    message( STATUS "[DEBUG] switching OFF install command" )
    set( INSTALL_COMMAND "" )
  endif()
  set( BUILD_IN_SOURCE False )
  if( ARG_BUILD_IN_SOURCE )
    set( BUILD_IN_SOURCE ${ARG_BUILD_IN_SOURCE} )
  endif()
  set( SOURCE_DIR ${ILCSOFT_BINARY_DIR}/${pkg_name}/src_${pkg_version} )
  set( BINARY_DIR )
  if( NOT ${BUILD_IN_SOURCE} )
    set( BINARY_DIR ${ILCSOFT_BINARY_DIR}/${pkg_name}/build_${pkg_version} )
  endif()
  if( ARG_SOURCE_INSTALL )
    set( SOURCE_DIR ${PKG_INSTALL_DIR} )
    if( NOT BUILD_IN_SOURCE )
      set( BINARY_DIR ${SOURCE_DIR}/build )
    endif()
  endif()
  set( BUILD_COMMAND make -j${COMPILE_CORES} )
  if( DEFINED ARG_BUILD_COMMAND )
    set( BUILD_COMMAND ${ARG_BUILD_COMMAND} )
  endif()
  set( FULL_CONFIGURE_COMMAND )
  if( DEFINED ARG_CONFIGURE_COMMAND )
    set( FULL_CONFIGURE_COMMAND CONFIGURE_COMMAND ${ARG_CONFIGURE_COMMAND} )
  endif()
  # build cmake argument list
  set( CMAKE_ARGS "" )
  # get the install path of dependencies
  set( pkg_cmake_prefix )
  foreach( pkg_depend ${pkg_depends} )
    get_property( pkg_depend_install_dir GLOBAL PROPERTY ILCSOFT_PKG_EXPORT_${pkg_depend}_INSTALL_DIR )
    if( pkg_depend_install_dir )
      list( APPEND pkg_cmake_prefix ${pkg_depend_install_dir} )
    endif()
  endforeach()
  if( pkg_cmake_prefix )
    foreach( _path ${pkg_cmake_prefix} )
      set( pkg_cmake_prefix_full ${pkg_cmake_prefix_full}%${_path} )
    endforeach()
    list( APPEND CMAKE_ARGS -DCMAKE_PREFIX_PATH=${pkg_cmake_prefix_full} )
  endif()
  ilcsoft_get_package_property( VAR cmake_envs PROPERTY CMAKE_ENV )
  foreach( cmake_var ${cmake_envs} )
    ilcsoft_get_package_property( VAR cmake_var_value PROPERTY CMAKE_ENV_${cmake_var} )
    if( DEFINED cmake_var_value )
      list( APPEND CMAKE_ARGS "-D${cmake_var}=${cmake_var_value}" )
    endif()
  endforeach()
  get_property( glob_cmake_envs GLOBAL PROPERTY ILCSOFT_CMAKE_ENV )
  foreach( cmake_var ${glob_cmake_envs} )
    get_property( cmake_var_value GLOBAL PROPERTY ILCSOFT_CMAKE_ENV_${cmake_var} )
    # don't override cmake var if the package has re-defined it
    # priority to package variables !
    if( NOT "${cmake_var}" IN_LIST cmake_envs )
      if( cmake_var_value )
        list( APPEND CMAKE_ARGS "-D${cmake_var}=${cmake_var_value} " )
      endif()      
    endif()
  endforeach()
  list( APPEND CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${PKG_INSTALL_DIR} )
  set( FULL_CMAKE_ARGS )
  if( NOT ARG_CONFIGURE_COMMAND )
    set( FULL_CMAKE_ARGS CMAKE_ARGS "${CMAKE_ARGS}" )
  endif()
  # overwrite the package url if specified by user
  if( pkg_url )
    set( ARG_URL ${pkg_url} )
  endif()
  # here we treat the install mode: GIT_REPO, SVN_REPO or WGET
  set( FULL_MODE_COMMAND )
  if( "${ARG_MODE}" STREQUAL "GIT_REPO" )
    set( FULL_MODE_COMMAND GIT_REPOSITORY ${ARG_URL} GIT_TAG ${pkg_version} )
  elseif( "${ARG_MODE}" STREQUAL "WGET" )
    set( FULL_MODE_COMMAND URL ${ARG_URL} )
  elseif( "${ARG_MODE}" STREQUAL "SVN_REPO" )
    if( ${pkg_version} STREQUAL "trunk" )
      set( FULL_MODE_COMMAND SVN_REPOSITORY ${ARG_URL}/trunk/${ARG_SVN_PATH} )
    else()
      set( FULL_MODE_COMMAND SVN_REPOSITORY ${ARG_URL}/tags/${pkg_version}/${ARG_SVN_PATH} )
    endif()
  endif()
  # print summary
  message( STATUS "++ Package ${pkg_name} install summary" )
  message( STATUS "+++=> DEPENDS = ${pkg_depends}" )
  message( STATUS "+++=> MODE = ${ARG_MODE}" )
  message( STATUS "+++=> URL = ${ARG_URL}" )
  message( STATUS "+++=> VERSION = ${pkg_version}" )
  message( STATUS "+++=> SOURCE_DIR = ${SOURCE_DIR}" )
  if( BINARY_DIR )
    message( STATUS "+++=> BINARY_DIR = ${BINARY_DIR}" )
  endif()
  message( STATUS "+++=> BUILD_IN_SOURCE = ${BUILD_IN_SOURCE}" )
  message( STATUS "+++=> BUILD_COMMAND = ${BUILD_COMMAND}" )
  message( STATUS "+++=> INSTALL_COMMAND = ${INSTALL_COMMAND}" )
  message( STATUS "+++=> INSTALL_DIR = ${PKG_INSTALL_DIR}" )
  if( ARG_CONFIGURE_COMMAND )
    message( STATUS "+++=> CONFIGURE_COMMAND = ${ARG_CONFIGURE_COMMAND}" )
  endif()
  if( NOT ARG_CONFIGURE_COMMAND )
    message( STATUS "+++=> CMAKE_ARGS = ${CMAKE_ARGS}" )
  endif()
  if( BINARY_DIR )
    set( FULL_BINARY_DIR BINARY_DIR ${BINARY_DIR} )
  endif()
  set( DEPENDS_FULL )
  if( pkg_target_depends )
    set( DEPENDS_FULL DEPENDS ${pkg_target_depends} )
  endif()
  if( INSTALL_COMMAND )
    # create a target to install the package
    ExternalProject_Add(
      ${ARG_TARGET}
      ${DEPENDS_FULL}
      ${FULL_MODE_COMMAND}
      BUILD_IN_SOURCE ${BUILD_IN_SOURCE}
      SOURCE_DIR ${SOURCE_DIR}
      ${FULL_BINARY_DIR}
      ${FULL_CMAKE_ARGS}
      BUILD_COMMAND ${BUILD_COMMAND}
      ${FULL_CONFIGURE_COMMAND}
      INSTALL_DIR ${PKG_INSTALL_DIR}
      LIST_SEPARATOR %
      ${FULL_INSTALL_COMMAND}
    )
  else()
    # create a target to install the package
    ExternalProject_Add(
      ${ARG_TARGET}
      ${DEPENDS_FULL}
      ${FULL_MODE_COMMAND}
      BUILD_IN_SOURCE ${BUILD_IN_SOURCE}
      SOURCE_DIR ${SOURCE_DIR}
      ${FULL_BINARY_DIR}
      ${FULL_CMAKE_ARGS}
      BUILD_COMMAND ${BUILD_COMMAND}
      ${FULL_CONFIGURE_COMMAND}
      INSTALL_DIR ${PKG_INSTALL_DIR}
      LIST_SEPARATOR %
      INSTALL_COMMAND ""
    )
  endif()
endfunction()


function( ilcsoft_package_add_marlindll )
  cmake_parse_arguments( ARG "" "" "LIBRARIES" ${ARGN} )
  # get the package name
  ilcsoft_get_package_property( VAR pkg_name PROPERTY NAME )
  if( NOT pkg_name )
    message( FATAL_ERROR "ilcsoft_package_add_marlindll must be called from within a package macro !" )
  endif()
  # if no library provided, build the name from the 
  # package name as {installdir}/lib/lib{Pkg}.{ext}
  if( NOT ARG_LIBRARIES )
    ilcsoft_get_package_property( VAR pkg_install_dir PROPERTY INSTALL_DIR )
    set( ARG_LIBRARIES "${pkg_install_dir}/lib/lib${pkg_name}${CMAKE_SHARED_LIBRARY_SUFFIX}" )
  endif()
  message( STATUS "++=> Package ${pkg_name}, adding MARLIN_DLL library ${ARG_LIBRARIES}" )
  ilcsoft_set_package_property( APPEND PROPERTY MARLIN_DLL VALUE ${ARG_LIBRARIES} )
endfunction()

#---------------------------------------------------------------------------------------------------
#  ilcsoft_export_package
#  
#  \author  R.Ete
#  \version 1.0
#
#---------------------------------------------------------------------------------------------------
function( ilcsoft_export_package )
  # get the package name
  ilcsoft_get_package_property( VAR pkg_name PROPERTY NAME )
  if( NOT pkg_name )
    message( FATAL_ERROR "ilcsoft_export_package must be called from a package macro !" )
  endif()
  get_property( pkg_list GLOBAL PROPERTY ILCSOFT_PACKAGE_LIST )
  if( "${pkg_name}" IN_LIST pkg_list )
    message( FATAL_ERROR "Package ${pkg_name} already exported" )
  endif()
  set_property( GLOBAL APPEND PROPERTY ILCSOFT_PACKAGE_LIST ${pkg_name} )
  # export all package properties
  ilcsoft_get_package_property( VAR pkg_version PROPERTY VERSION )
  set_property( GLOBAL PROPERTY ILCSOFT_PKG_EXPORT_${pkg_name}_VERSION ${pkg_version} )
  ilcsoft_get_package_property( VAR pkg_install_dir PROPERTY INSTALL_DIR )
  set_property( GLOBAL PROPERTY ILCSOFT_PKG_EXPORT_${pkg_name}_INSTALL_DIR ${pkg_install_dir} )
  ilcsoft_get_package_property( VAR pkg_depends PROPERTY DEPENDS )
  set_property( GLOBAL PROPERTY ILCSOFT_PKG_EXPORT_${pkg_name}_DEPENDS ${pkg_depends} )
  ilcsoft_get_package_property( VAR pkg_export_vars PROPERTY EXPORT_VARS )
  set_property( GLOBAL PROPERTY ILCSOFT_PKG_EXPORT_${pkg_name}_EXPORT_VARS ${pkg_export_vars} )
  foreach( pkg_export_var ${pkg_export_vars} )
    ilcsoft_get_package_property( VAR pkg_export_val PROPERTY EXPORT_VARS_${pkg_export_var} )
    set_property( GLOBAL PROPERTY ILCSOFT_PKG_EXPORT_${pkg_name}_EXPORT_VARS_${pkg_export_var} ${pkg_export_val} )
  endforeach()
  # append MARLIN_DLL 
  ilcsoft_get_package_property( VAR pkg_marlin_dll PROPERTY MARLIN_DLL )
  set_property( GLOBAL APPEND PROPERTY ILCSOFT_PKG_EXPORT_MARLIN_DLL ${pkg_marlin_dll} )
  set_property( GLOBAL PROPERTY ILCSOFT_PKG_EXPORT_${pkg_name}_EXPORTED ON )
endfunction()

#---------------------------------------------------------------------------------------------------
#  ilcsoft_write_cmake_file
#  
#  \author  R.Ete
#  \version 1.0
#
#---------------------------------------------------------------------------------------------------
function( ilcsoft_write_cmake_file )
  get_property( ILCSOFT_INSTALL_PREFIX_FULL GLOBAL PROPERTY ILCSOFT_INSTALL_PREFIX_FULL )
  set( ILCSOFT_CMAKE_FILE ${ILCSOFT_INSTALL_PREFIX_FULL}/ILCSoft.cmake )
  # remove existing copy of ILCSoft.cmake file
  if( EXISTS ${ILCSOFT_CMAKE_FILE} )
    file( REMOVE ${ILCSOFT_CMAKE_FILE} )
  endif()
  string( TIMESTAMP current_time UTC )
  file( APPEND ${ILCSOFT_CMAKE_FILE} 
    "################################################################################\n"
    "# Environment script generated by ILCInstall package on ${current_time}\n"
    "# for the installation located at [ ${ILCSOFT_INSTALL_PREFIX_FULL} ]\n"
    "################################################################################\n\n"
  )
  file( APPEND ${ILCSOFT_CMAKE_FILE} 
    "SET( ILC_HOME \"${ILCSOFT_INSTALL_PREFIX_FULL}\" CACHE PATH \"Path to ILC Software\" FORCE)\n"
    "MARK_AS_ADVANCED( ILC_HOME )\n\n"
  )
  file( APPEND ${ILCSOFT_CMAKE_FILE} 
    "SET( CMAKE_PREFIX_PATH \n"
  )
  get_property( pkg_list GLOBAL PROPERTY ILCSOFT_PACKAGE_LIST )
  get_property( install_prefix GLOBAL PROPERTY ILCSOFT_INSTALL_PREFIX_FULL )
  
  foreach( pkg ${pkg_list} )
    ilcsoft_get_export_package_property( VAR pkg_install_dir PACKAGE ${pkg} PROPERTY INSTALL_DIR )
    if( pkg_install_dir )
      # check if install dir from package contains base path from ilcsoft
      string( FIND pkg_install_dir install_prefix pkg_is_ilcsoft )
      if( pkg_is_ilcsoft )
        ilcsoft_get_export_package_property( VAR pkg_version PACKAGE ${pkg} PROPERTY VERSION )
        file( APPEND ${ILCSOFT_CMAKE_FILE} 
          "\t\${ILC_HOME}/${pkg}/${pkg_version};\n"
        )
      else()
        file( APPEND ${ILCSOFT_CMAKE_FILE} 
          "${pkg_install_dir};\n"
        )
      endif()
    endif()
  endforeach()
  file( APPEND ${ILCSOFT_CMAKE_FILE} 
    "CACHE PATH \"CMAKE_PREFIX_PATH\" FORCE )\n\n"
  )
  file( APPEND ${ILCSOFT_CMAKE_FILE} 
    "option( USE_CXX11 \"Use cxx11\" ${ILCSOFT_USE_CXX11} )\n"
    "option( Boost_NO_BOOST_CMAKE \"dont use cmake find module for boost\" ${ILCSOFT_NO_BOOST_CMAKE} )\n"
    "set( CMAKE_CXX_FLAGS_RELWITHDEBINFO \"-O2 -g\" CACHE STRING \"\" FORCE )\n"
  )
endfunction()


#---------------------------------------------------------------------------------------------------
#  ilcsoft_write_init_file
#  
#  \author  R.Ete
#  \version 1.0
#
#---------------------------------------------------------------------------------------------------
function( ilcsoft_write_init_file )
  get_property( ILCSOFT_INSTALL_PREFIX_FULL GLOBAL PROPERTY ILCSOFT_INSTALL_PREFIX_FULL )
  set( ILCSOFT_INIT_FILE ${ILCSOFT_INSTALL_PREFIX_FULL}/init_ilcsoft.sh )
  # remove existing copy of init_ilcsoft.sh file
  if( EXISTS ${ILCSOFT_INIT_FILE} )
    file( REMOVE ${ILCSOFT_INIT_FILE} )
  endif()
  # find python executable
  find_package( PythonInterp REQUIRED )
  get_filename_component( python_interp_dir ${PYTHON_EXECUTABLE} DIRECTORY )
  get_filename_component( python_dir ${python_interp_dir} DIRECTORY )
  message( STATUS "---------------------------------" )
  message( STATUS "++ Python interpreter settings" )
  message( STATUS "+=> Python executable: ${PYTHON_EXECUTABLE}" )
  message( STATUS "+=> Python version: ${PYTHON_VERSION_STRING}" )
  message( STATUS "+=> Python executable dir: ${python_interp_dir}" )
  message( STATUS "+=> Python dir: ${python_dir}" )
  # compiler settings
  get_filename_component( cxx_bin_dir ${CMAKE_CXX_COMPILER} DIRECTORY )
  get_filename_component( cxx_dir ${cxx_bin_dir} DIRECTORY )
  get_filename_component( cxx_name ${CMAKE_CXX_COMPILER} NAME )
  get_filename_component( c_bin_dir ${CMAKE_C_COMPILER} DIRECTORY )
  get_filename_component( c_dir ${c_bin_dir} DIRECTORY )
  get_filename_component( c_name ${CMAKE_C_COMPILER} NAME )
  message( STATUS "---------------------------------" )
  message( STATUS "+ Compiler settings" )
  message( STATUS "+=> CXX compiler : ${CMAKE_CXX_COMPILER}" )
  message( STATUS "+=> CXX compiler dir: ${cxx_bin_dir}" )
  message( STATUS "+=> CXX dir: ${cxx_dir}" )
  message( STATUS "+=> C compiler : ${CMAKE_C_COMPILER}" )
  message( STATUS "+=> C compiler dir: ${c_bin_dir}" )
  message( STATUS "+=> C dir: ${c_dir}" )
  # write init script
  file( APPEND ${ILCSOFT_INIT_FILE} 
    "export ILCSOFT=${ILCSOFT_INSTALL_PREFIX_FULL}\n"
    "\n# -------------------------------------------------------------------- ---\n"
    "\n# ---  Use the same compiler and python as used for the installation   ---\n"
    "\n# -------------------------------------------------------------------- ---\n"
    "export PATH=${c_bin_dir}:${python_interp_dir}:\$PATH\n"
    "export LD_LIBRARY_PATH=${cxx_dir}/lib64:${cxx_dir}/lib:${c_dir}/lib64:${c_dir}/lib:${python_dir}/lib:\$LD_LIBRARY_PATH\n\n"
    "export CXX=${cxx_name}\n"
    "export CC=${c_name}\n"
  )
  get_property( pkg_list GLOBAL PROPERTY ILCSOFT_PACKAGE_LIST )
  foreach( pkg ${pkg_list} )
    ilcsoft_get_export_package_property( PACKAGE ${pkg} VAR pkg_export_vars PROPERTY EXPORT_VARS )
    if( pkg_export_vars )
      file( APPEND ${ILCSOFT_INIT_FILE}
        "\n\n"
        "#--------------------------------------------------------------------------------\n"
        "#    ${pkg}\n"
        "#--------------------------------------------------------------------------------\n"
      )
    endif()
    foreach( pkg_export_var ${pkg_export_vars} )
      ilcsoft_get_export_package_property( PACKAGE ${pkg} VAR pkg_export_val PROPERTY EXPORT_VARS_${pkg_export_var} )
      if( "${pkg_export_var}" STREQUAL "PATH" 
       OR "${pkg_export_var}" STREQUAL "LD_LIBRARY_PATH" 
       OR "${pkg_export_var}" STREQUAL "PYTHONPATH" )
        file( APPEND ${ILCSOFT_INIT_FILE} 
          "export ${pkg_export_var}=${pkg_export_val}:\$${pkg_export_var}\n"
        )
      else()
        file( APPEND ${ILCSOFT_INIT_FILE} 
          "export ${pkg_export_var}=${pkg_export_val}\n"
        )
      endif()
    endforeach()
  endforeach()
  # export the MARLIN_DLL from all packages 
  get_property( all_marlin_dll GLOBAL PROPERTY ILCSOFT_PKG_EXPORT_MARLIN_DLL )
  if( all_marlin_dll )
    set( MARLIN_DLL_STR "export MARLIN_DLL=" )
    foreach( marlin_dll ${all_marlin_dll} )
      set( MARLIN_DLL_STR "${MARLIN_DLL_STR}${marlin_dll}:" )
    endforeach()
    set( MARLIN_DLL_STR "${MARLIN_DLL_STR}$MARLIN_DLL" )
  endif()
  file( APPEND ${ILCSOFT_INIT_FILE}
    "\n"
    "#--------------------------------------------------------------------------------\n"
    "#    export MARLIN_DLL from all installed packages\n"
    "#--------------------------------------------------------------------------------\n"
    "\n${MARLIN_DLL_STR}\n"
  )
endfunction()

#---------------------------------------------------------------------------------------------------
#  ilcsoft_setup_install
#  
#  \author  R.Ete
#  \version 1.0
#
#---------------------------------------------------------------------------------------------------
function( ilcsoft_setup_install )
  # detect input config files to use
  ilcsoft_detect_configuration()
  # setup global cmake variables to pass to every package
  ilcsoft_add_cmake_env( VAR "USE_CXX11" VALUE ${ILCSOFT_USE_CXX11} )
  ilcsoft_add_cmake_env( VAR "INSTALL_DOC" VALUE ${ILCSOFT_INSTALL_DOC} )
  ilcsoft_add_cmake_env( VAR "CMAKE_BUILD_TYPE" VALUE ${CMAKE_BUILD_TYPE} )
  ilcsoft_add_cmake_env( VAR "Boost_NO_BOOST_CMAKE" VALUE ${ILCSOFT_NO_BOOST_CMAKE} )
  if( NOT "${COMPILE_CORES}" MATCHES "^[0-9]+$" ) 
    message( WARNING "Value supplied for COMPILE_CORES is not a number (${COMPILE_CORES}). Setting COMPILE_CORES to 1 !" )
    set( COMPILE_CORES "1" CACHE STRING "The number of cores to use for compiling each package" )
  endif()
  set_property( GLOBAL PROPERTY COMPILE_CORES ${COMPILE_CORES} )
endfunction()

#---------------------------------------------------------------------------------------------------
#  ilcsoft_print_summary
#  
#  \author  R.Ete
#  \version 1.0
#
#---------------------------------------------------------------------------------------------------
function( ilcsoft_print_summary )
  get_property( ILCSOFT_INSTALL_MODE GLOBAL PROPERTY ILCSOFT_INSTALL_MODE )
  get_property( ILCSOFT_INSTALL_PREFIX GLOBAL PROPERTY ILCSOFT_INSTALL_PREFIX )
  get_property( ILCSOFT_INSTALL_PREFIX_BASE GLOBAL PROPERTY ILCSOFT_INSTALL_PREFIX_BASE )
  get_property( ILCSOFT_INSTALL_PREFIX_FULL GLOBAL PROPERTY ILCSOFT_INSTALL_PREFIX_FULL )
  get_property( ILCSOFT_BINARY_DIR GLOBAL PROPERTY ILCSOFT_BINARY_DIR )
  get_property( ILCSOFT_VERSIONS_FILE GLOBAL PROPERTY ILCSOFT_VERSIONS_FILE )
  get_property( ILCSOFT_PACKAGES_FILE GLOBAL PROPERTY ILCSOFT_PACKAGES_FILE )
  get_property( ILCSOFT_PACKAGES_DIR GLOBAL PROPERTY ILCSOFT_PACKAGES_DIR )
  get_property( COMPILE_CORES GLOBAL PROPERTY COMPILE_CORES )
  message( STATUS "---------------------------------" )
  message( STATUS "-- ILCSOFT INSTALLATION SUMMARY -" )
  message( STATUS "---------------------------------" )
  message( STATUS "+ Installation config:" )
  message( STATUS "+=> ILCSOFT_INSTALL_MODE = ${ILCSOFT_INSTALL_MODE}" )
  message( STATUS "+=> ILCSOFT_INSTALL_PREFIX = ${ILCSOFT_INSTALL_PREFIX}" )
  message( STATUS "+=> ILCSOFT_INSTALL_PREFIX_BASE = ${ILCSOFT_INSTALL_PREFIX_BASE}" )
  message( STATUS "+=> ILCSOFT_INSTALL_PREFIX_FULL = ${ILCSOFT_INSTALL_PREFIX_FULL}" )
  message( STATUS "+=> ILCSOFT_BINARY_DIR = ${ILCSOFT_BINARY_DIR}" )
  message( STATUS "+=> ILCSOFT_VERSIONS_FILE = ${ILCSOFT_VERSIONS_FILE}" )
  message( STATUS "+=> ILCSOFT_PACKAGES_FILE = ${ILCSOFT_PACKAGES_FILE}" )
  message( STATUS "+=> ILCSOFT_PACKAGES_DIR = ${ILCSOFT_PACKAGES_DIR}" )
  message( STATUS "+=> COMPILE_CORES = ${COMPILE_CORES}" )
  message( STATUS "+=> CMAKE_ROOT = ${CMAKE_ROOT}" )
  get_property( cmake_envs GLOBAL PROPERTY ILCSOFT_CMAKE_ENV )
  foreach( cmake_var ${cmake_envs} )
    get_property( cmake_var_value GLOBAL PROPERTY ILCSOFT_CMAKE_ENV_${cmake_var} )
    if( cmake_var_value )
      message( STATUS "+=> ${cmake_var} = ${cmake_var_value}" )
    endif()
  endforeach()
endfunction()

