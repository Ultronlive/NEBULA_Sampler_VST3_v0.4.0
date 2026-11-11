cmake_minimum_required(VERSION 3.22)
project(NEBULASampler VERSION 0.4.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# To build completely offline, put JUCE 8 in ./JUCE and run CMake.
# Otherwise CMake will download the pinned JUCE release on first build.
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/JUCE/CMakeLists.txt")
    add_subdirectory(JUCE)
else()
    include(FetchContent)
    FetchContent_Declare(juce
        GIT_REPOSITORY https://github.com/juce-framework/JUCE.git
        GIT_TAG 8.0.14
        GIT_SHALLOW TRUE)
    FetchContent_MakeAvailable(juce)
endif()

juce_add_plugin(NEBULASampler
    COMPANY_NAME "NEBULA Audio"
    BUNDLE_ID "com.nebula.audio.sampler"
    PLUGIN_MANUFACTURER_CODE Nebu
    PLUGIN_CODE Nbs4
    PRODUCT_NAME "NEBULA Sampler"
    PLUGIN_NAME "NEBULA Sampler"
    DESCRIPTION "NEBULA portable live sampler - 32 tracks / 128 pads"
    IS_SYNTH TRUE
    NEEDS_MIDI_INPUT TRUE
    NEEDS_MIDI_OUTPUT FALSE
    IS_MIDI_EFFECT FALSE
    EDITOR_WANTS_KEYBOARD_FOCUS TRUE
    VST3_CATEGORIES Instrument Sampler
    FORMATS VST3
    COPY_PLUGIN_AFTER_BUILD FALSE)

juce_generate_juce_header(NEBULASampler)
target_sources(NEBULASampler PRIVATE
    Source/PluginProcessor.cpp
    Source/PluginEditor.cpp)

target_compile_definitions(NEBULASampler PUBLIC
    JUCE_WEB_BROWSER=0
    JUCE_USE_CURL=0
    JUCE_USE_MP3AUDIOFORMAT=1
    JUCE_USE_FLAC=1
    JUCE_USE_OGGVORBIS=1
    JUCE_VST3_CAN_REPLACE_VST2=0)

target_link_libraries(NEBULASampler PRIVATE
    juce::juce_audio_utils
    juce::juce_audio_processors
    juce::juce_audio_formats
    juce::juce_dsp
    juce::juce_gui_extra
    PUBLIC
    juce::juce_recommended_config_flags
    juce::juce_recommended_lto_flags)

# Build: cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
#        cmake --build build --config Release --target NEBULASampler_VST3
