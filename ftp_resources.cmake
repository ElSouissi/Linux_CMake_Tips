# Specify the resources and their FTP locations
set(resources
    resources1
    resources2
)

set(FTP_SERVER "ftp://example.com/dependencies")

# Define platform-specific RESOURCES paths
if(WIN32)
    set(RESOURCES_SUBDIR "windows")
elseif(UNIX)
    set(RESOURCES_SUBDIR "linux")
else()
    message(FATAL_ERROR "Unsupported platform")
endif()

# Function to download and extract dependencies
function(download_and_extract RESOURCES_name RESOURCES_url output_dir)
    if(NOT EXISTS ${output_dir})
        file(DOWNLOAD ${RESOURCES_url} ${output_dir}/${RESOURCES_name}.zip SHOW_PROGRESS)
        execute_process(
            COMMAND ${CMAKE_COMMAND} -E tar xzf ${output_dir}/${RESOURCES_name}.zip --directory ${output_dir}
            RESULT_VARIABLE result
        )
        if(NOT result EQUAL 0)
            message(FATAL_ERROR "Failed to extract ${RESOURCES_name}.zip")
        endif()
        file(REMOVE ${output_dir}/${RESOURCES_name}.zip)
    else()
        message(STATUS "RESOURCES ${RESOURCES_name} already exists in ${output_dir}, skipping download.")
    endif()
endfunction()

set(RESOURCES_OUTPUT_DIR ${CMAKE_BINARY_DIR}/dependencies)

# Download and prepare dependencies
foreach(RESOURCES ${DEPENDENCIES})
	# Path to the .propertie file
	set(PROPERTIES_FILE ${XXXXXXXX_SOURCE_DIR}/config.properties)

	# Ensure the .propertie file exist in the folder
	if(NOT EXISTS ${PROPERTIES_FILE})
		message(FATAL_ERROR "Properties file not found: ${PROPERTIES_FILE} for RESOURCES ${RESOURCES}")
	endif()

	# Read the file content
	file(READ ${PROPERTIES_FILE} PROPERTIES_CONTENT)

	# Parse the content of .propertie file line by line
	foreach(LINE IN LISTS PROPERTIES_CONTENT)
		
		# Remove leading/trailing spaces
		string(STRIP ${LINE} LINE)

		# Match key=value format
		if(LINE MATCHES "=")
			string(REPLACE "=" ";" KEY_VALUE ${LINE})
			list(GET KEY_VALUE 0 KEY)
			list(GET KEY_VALUE 1 VALUE)
			set(${KEY} ${VALUE})  
			
			# Retreive URL and VERION related to a RESOURCES
			if(${KEY} STREQUAL "FTP_URL")
				set(FTP_SERVER ${VALUE} CACHE INTERNAL "")
			elseif(${KEY} STREQUAL "VERSION")
				set(RESOURCES_VERSION ${VALUE} CACHE INTERNAL "")
			endif()
		endif()
	endforeach()
	
    set(RESOURCES_URL ${FTP_SERVER}/${RESOURCES_SUBDIR}/${RESOURCES_VERSION}/${RESOURCES}.zip)
    set(RESOURCES_DIR ${RESOURCES_OUTPUT_DIR}/${RESOURCES})
    download_and_extract(${RESOURCES} ${RESOURCES_URL} ${RESOURCES_OUTPUT_DIR})
	
endforeach()
