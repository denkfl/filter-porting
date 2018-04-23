##############################################################################################
# ADTF Example for data triggered filters
# Use example as is! No additional support provided!
#
# (c) Audi Electronics Venture GmbH
##############################################################################################

cmake_minimum_required(VERSION 3.10.0)
project(arduino_us_sensors)

if (NOT TARGET adtf::filtersdk)
    find_package(ADTF COMPONENTS filtersdk)
endif()

set (EXAMPLE_TARGETNAME arduino_us_sensors)
set (EXAMPLE_CATEGORY   adtf/streaming_sources)
set (EXAMPLE_SOURCES    arduino_us_sensors.h
                        arduino_us_sensors.cpp)

#we use the special ADTF CMake command to add an shared object/DLL which has an extension called .adtfplugin
adtf_add_streaming_service(${EXAMPLE_TARGETNAME} ${EXAMPLE_SOURCES})

#install the program you need 
adtf_install_target(${EXAMPLE_TARGETNAME} bin)

#this is to add a folder within the ADTF examples solution
set_property(TARGET ${EXAMPLE_TARGETNAME} PROPERTY FOLDER arduino/${EXAMPLE_CATEGORY})

adtf_create_plugindescription(
    TARGET
        ${EXAMPLE_TARGETNAME}
    PLUGIN_SUBDIR
        "bin"
    MERGE_DESCRIPTION
        "arduino_us_sensors.plugindescription"

)
