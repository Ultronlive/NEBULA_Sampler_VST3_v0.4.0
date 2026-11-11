# NEBULA SAMPLER — Native VST3 Instrument v0.4.0

32 tracks | 128 pads | 64 voices | native JUCE UI | MIDI input | large graphite faders | 93 delay presets

**Status:** build-ready C++ source project. A compiled and DAW-tested `.vst3` is not included. See `Docs/LEIA-PRIMEIRO.md`.

**Windows:** run `COMPILAR_VST3_WINDOWS.bat` with VS 2022 C++/CMake/Git installed. Or push this tree to GitHub and run `.github/workflows/build-vst3-windows.yml`, then download the generated artifact.

**Not the old standalone EXE:** this is an entirely new plugin architecture. The host DAW handles MIDI device routing and ASIO audio setup.
