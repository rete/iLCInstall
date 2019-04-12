########################################################
# Top-level CMakeLists.txt to build ILCSoft
# @author Remi Ete, DESY
# Based on the CMake implementation of Eldwan Brianne (DESY) for CaliceSoft (Merci ma poule !)
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)
########################################################

# ----- Project name -----
project( ILCSoft )

# ----- CMake settings -----
list( APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake )
include( ILCSoftMacros )
include( ILCSoftOptions )

# detect config files to use for installation
ilcsoft_setup_install()

# print installation summary
ilcsoft_print_summary()

# write ILCSoft.cmake and init_ilcsoft.sh files
ilcsoft_write_cmake_file()
ilcsoft_write_init_file()
