workspace "Blind"
	architecture "x64"

	configurations
	{
		"Distribution",
		"Release",
		"Debug"
	}

project_output = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

Dependency = {}
Dependency["GLFW"] = "Blind/vendor/GLFW/include"

include "Blind/vendor/GLFW"

project "Blind"
	location "Blind"
	kind "SharedLib"
	language "C++"
	cppdialect "C++17";
	staticruntime "on"


	targetdir ("bin/" .. project_output .. "/%{prj.name}")
	objdir ("bin-int/" .. project_output .. "/%{prj.name}")

	pchheader "blindpch.h"
	pchsource "Blind/src/blindpch.cpp"

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"%{prj.name}/vendor/spdlog/include",
		"%{prj.name}/src",
		"%{Dependency.GLFW}"
	}
	
	links
	{
		"GLFW",
		"opengl32.lib"
	}

	filter "system:windows"
		systemversion "latest"

		defines 
		{
			"PLATFORM_WINDOWS",
			"BLIND_DLL",
			"GLFW_INCLUDE_NONE",
		}

		postbuildcommands
		{
			("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. project_output .. "/Game")
		}
	filter "configurations:Debug"
		defines "BLIND_DEBUG"
		runtime "Debug"
		defines "BLIND_ENABLE_ASSERTS"
		symbols "on"

	filter "configurations:Release"
		defines "BLIND_RELEASE"
		runtime "Release"
		optimize "on"

	filter "configurations:Distribution"
		defines "BLIND_DIST"
		runtime "Release"
		optimize "on"

project "Game"
	location "Game"
	kind "ConsoleApp"
	language "C++"
	cppdialect "C++17";
	staticruntime "on"

	targetdir ("bin/" .. project_output .. "/%{prj.name}")
	objdir ("bin-int/" .. project_output .. "/%{prj.name}")

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp"
	}

	includedirs
	{
		"Blind/vendor/spdlog/include",
		"Blind/src"
	}
	links
	{
		"Blind"
	}
	filter "system:windows"
		cppdialect "C++17"

		defines 
		{
			"PLATFORM_WINDOWS",
		}
	
	filter "configurations:Debug"
		defines "BLIND_DEBUG"
		runtime "Debug"
		defines "BLIND_ENABLE_ASSERTS"
		symbols "on"

	filter "configurations:Release"
		defines "BLIND_RELEASE"
		runtime "Release"
		optimize "on"

	filter "configurations:Distribution"
		defines "BLIND_DIST"
		runtime "Release"
		optimize "on"