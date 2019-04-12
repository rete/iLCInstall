

# ILCSoft global options
option( ILCSOFT_USE_HEAD             "Whether to install head versions of ilcsoft packages" OFF )
option( ILCSOFT_USE_CXX11            "Whether to use C++ 11 standard" ON )
option( ILCSOFT_INSTALL_DOC          "Whether to build doxygen documentation" ON )
option( ILCSOFT_NO_BOOST_CMAKE       "Set to True to do not use cmake find module for boost" ON )
set( COMPILE_CORES "1" CACHE STRING "The number of cores to use for compiling each package" )
  
