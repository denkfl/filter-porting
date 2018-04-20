# execute just once
if(AADC_FOUND)
    message(STATUS "AADC config file already found.")
    return()
endif(AADC_FOUND)

set(AADC_OPENCV_FOUND FALSE)
set(AADC_PYLON_FOUND FALSE)
set(AADC_BOOST_FOUND FALSE)


#------------------------------------------------------
#-------QT Dir------------------------------------------
#-------------------------------------------------------
# already set in sh/bat script
message(STATUS "Qt Dir is ${Qt_DIR}")

#------------------------------------------------------
#-------OpenCV------------------------------------------
#-------------------------------------------------------
find_package(OpenCV REQUIRED  PATHS 
		"/opt/opencv/3.4.1"		
		"C:/SDK/opencv/3.4.1")

if(NOT OpenCV_LIBS)
    message(FATAL_ERROR "OpenCV lib not found. Please specify the OPENCV_DIR")
else(NOT OpenCV_LIBS)
	set_target_properties(${OpenCV_LIBS} PROPERTIES MAP_IMPORTED_CONFIG_RELWITHDEBINFO RELEASE)
    message(STATUS "OpenCV lib found. OpenCV Version is ${OpenCV_VERSION}")
    set(AADC_OPENCV_FOUND TRUE)	
    message(STATUS "OpenCV Include dir is ${OpenCV_INCLUDE_DIR}")
endif(NOT OpenCV_LIBS)
           
#------------------------------------------------------
#-------boost------------------------------------------
#-------------------------------------------------------
if (WIN32)
	set (BOOST_ROOT "C:/SDK/boost/1.66.0")    
else(WIN32)
	set (BOOST_ROOT "/opt/boost/1.66.0")
endif(WIN32)

set (Boost_USE_STATIC_LIBS OFF CACHE BOOL "use static libraries from Boost")
set (Boost_USE_MULTITHREADED ON)

find_package(Boost 1.58 REQUIRED COMPONENTS system filesystem thread)
			
if(Boost_FOUND)
	if (WIN32)
	  # disable autolinking in boost
	  add_definitions( -DBOOST_ALL_NO_LIB )

	  # force all boost libraries to dynamic link (we already disabled
	  # autolinking, so I don't know why we need this, but we do!)
	  add_definitions( -DBOOST_ALL_DYN_LINK )
	endif()
	message(STATUS "Found Boost. Boost Version is: ${Boost_VERSION}" )
	message(STATUS "Boost Include dir is ${Boost_INCLUDE_DIR}")
	message(STATUS "Boost Lib dir is ${Boost_LIBRARY_DIRS}")
	#message(STATUS "Boost Libs are ${Boost_LIBRARIES}")
	set(AADC_BOOST_FOUND TRUE)
else(Boost_FOUND)
	message(FATAL_ERROR "Boost not found." )		
endif(Boost_FOUND)          

#------------------------------------------------------------------	
#--------lib pylon------------------------------------------
#------------------------------------------------------------------	

if(UNIX)
	set(PYLON_DIR "/opt/pylon/5.0.5")
	set(PYLON_LIBRARY_DIRS "${PYLON_DIR}/lib64")
	set(PYLON_INCLUDE_DIRS "${PYLON_DIR}/include")
else(UNIX)
	set(PYLON_DIR "C:/SDK/pylon/5.0.12")
	set(PYLON_LIBRARY_DIRS "${PYLON_DIR}/Development/lib/x64")
	set(PYLON_INCLUDE_DIRS "${PYLON_DIR}/Development/include")
	set(PYLON_BINARY_DIRS "${PYLON_DIR}/Runtime/x64")	
endif(UNIX)
	
FIND_LIBRARY(PYLON_UTILITY_LIBS NAMES 
		pylonutility
		PylonUtility_MD_VC120_v5_0
		PATHS 
		"${PYLON_LIBRARY_DIRS}"
		)

FIND_LIBRARY(PYLON_BASE_LIBS NAMES 
		pylonbase
		PylonBase_MD_VC120_v5_0
		PATHS 
		"${PYLON_LIBRARY_DIRS}"
		)
					
		
set(PYLON_LIBS "${PYLON_UTILITY_LIBS};${PYLON_BASE_LIBS}")	
		
		
if (PYLON_LIBS)
	message(STATUS "Found pylon. Pylon libs are: ${PYLON_LIBS}")
	set(AADC_PYLON_FOUND TRUE)
else (PYLON_LIBS)
	message(FATAL_ERROR "Pylon libs not found under ${PYLON_LIBRARY_DIRS}")
endif (PYLON_LIBS)


#------------------------------------------------------------------	
#--------Tools for Doc---------------------------------------------
#------------------------------------------------------------------

if(WIN32)
	set(TOOLS_DIR                 "C:/Tools" CACHE PATH "" FORCE)
	set(ADTF_MD5SUM_EXECUTABLE    ${TOOLS_DIR}/cygwin/bin/md5sum.exe CACHE PATH "" FORCE)
	set(DOXYGEN_EXECUTABLE        ${TOOLS_DIR}/doxygen/bin/doxygen.exe CACHE PATH "" FORCE)
	set(DOXYGEN_DOT_EXECUTABLE    ${TOOLS_DIR}/Graphviz/bin CACHE PATH "" FORCE)
	set(MSCGEN_PATH               ${TOOLS_DIR}/Msc-generator CACHE PATH "" FORCE)
	set(HTML_HELP_COMPILER        ${TOOLS_DIR}/HTMLHelpWorkshop/1.3.0/hhc.exe CACHE PATH "" FORCE)
	set(HTML_HELP_INCLUDE_PATH    ${TOOLS_DIR}/HTMLHelpWorkshop/1.3.0/include CACHE PATH "" FORCE)
	set(HTML_HELP_LIBRARY         ${TOOLS_DIR}/HTMLHelpWorkshop/1.3.0/lib/htmlhelp.lib CACHE PATH "" FORCE)
	set(EXACT_MD5SUM_EXECUTABLE   ${TOOLS_DIR}/cygwin/1.7.16/bin/md5sum.exe CACHE PATH "" FORCE)
	set(EXACT_NSIS_EXECUTABLE     ${TOOLS_DIR}/NSIS/2.46.0/makensis.exe CACHE PATH "" FORCE)
endif(WIN32)
#------------------------------------------------------------------
#--------compiler settings-----------------------------------------
#------------------------------------------------------------------

# under windows the size of the pre-compiled-header are limited so we have to extend it manually
if (WIN32)
    SET( CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -Zm140" )
else (WIN32)	
    SET( CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -Wno-unknown-pragmas" )
endif(WIN32)

#------------------------------------------------------------------	
#--------Install Prefix--------------------------------------------
#------------------------------------------------------------------	
#set the install prefix if not already done.
set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/../../_install")
if(MSVC10)
	set(CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}/win64_vc100" CACHE PATH "The install directory" FORCE)     
elseif(CMAKE_COMPILER_IS_GNUCXX)
	set(CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}/linux64" CACHE PATH "The install directory" FORCE)   
endif()
set(CMAKE_INSTALL_BINARY "${CMAKE_INSTALL_PREFIX}/bin" CACHE PATH "The install directory" FORCE)
set(CMAKE_INSTALL_APPS "${CMAKE_INSTALL_PREFIX}/apps" CACHE PATH "The install directory" FORCE)
set(CMAKE_INSTALL_DOC "${CMAKE_INSTALL_PREFIX}/doc" CACHE PATH "The install directory" FORCE)
set(CMAKE_INSTALL_INCLUDE "${CMAKE_INSTALL_PREFIX}/include" CACHE PATH "The install directory" FORCE)
set(CMAKE_INSTALL_LIBRARY "${CMAKE_INSTALL_PREFIX}/lib" CACHE PATH "The install directory" FORCE)
set(CMAKE_INSTALL_DESCRIPTION "${CMAKE_INSTALL_PREFIX}/description" CACHE PATH "The install directory" FORCE)
set(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT FALSE)
message(STATUS "Install dir is ${CMAKE_INSTALL_PREFIX}")


#------------------------------------------------------------------

if(NOT AADC_OPENCV_FOUND OR NOT AADC_BOOST_FOUND OR NOT AADC_PYLON_FOUND)
	message(FATAL_ERROR "At least one of the required libraries is not found")
endif(NOT AADC_OPENCV_FOUND OR NOT AADC_BOOST_FOUND OR NOT AADC_PYLON_FOUND)

