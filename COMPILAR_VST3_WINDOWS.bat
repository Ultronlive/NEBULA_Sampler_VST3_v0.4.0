@echo off
setlocal
cd /d "%~dp0"
chcp 65001 >nul
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist "%VSWHERE%" (
  echo ERRO: Visual Studio 2022 Build Tools nao detectado.
  echo Instale Desktop development with C++ no instalador do Visual Studio.
  pause
  exit /b 1
)
"%VSWHERE%" -latest -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath > "%TEMP%\nebula_vs_path.txt"
set /p VSPATH=<"%TEMP%\nebula_vs_path.txt"
if not defined VSPATH (
  echo ERRO: C++ Build Tools nao encontrados.
  pause
  exit /b 1
)
if not exist "%VSPATH%\VC\Auxiliary\Build\vcvars64.bat" (
  echo ERRO: Ambiente de compilacao x64 ausente.
  pause
  exit /b 1
)
call "%VSPATH%\VC\Auxiliary\Build\vcvars64.bat"
where cmake >nul 2>nul
if errorlevel 1 (
  echo ERRO: CMake 3.22+ nao encontrado. Instale CMake e adicione ao PATH.
  pause
  exit /b 1
)
echo.
echo [1/3] Preparando JUCE e a solucao VST3...
cmake -S . -B build -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=Release
if errorlevel 1 goto fail
echo [2/3] Compilando NEBULA VST3 x64...
cmake --build build --config Release --target NEBULASampler_VST3 --parallel 4
if errorlevel 1 goto fail
set "SRC=%~dp0build\NEBULASampler_artefacts\Release\VST3\NEBULA Sampler.vst3"
if not exist "%SRC%" set "SRC=%~dp0build\NEBULASampler_artefacts\VST3\NEBULA Sampler.vst3"
if not exist "%SRC%" (
  echo ERRO: Compilou, mas nao achei o pacote VST3 no diretorio esperado.
  echo Verifique build\NEBULASampler_artefacts\Release\VST3
  pause
  exit /b 2
)
echo [3/3] Copiando plugin para a pasta VST3 padrao...
set "DEST=%CommonProgramFiles%\VST3\NEBULA Sampler.vst3"
robocopy "%SRC%" "%DEST%" /E /NFL /NDL /NJH /NJS /NP
if errorlevel 8 goto fail
echo.
echo CONCLUIDO: %DEST%
echo Abra sua DAW e execute o rescan VST3.
pause
exit /b 0
:fail
echo.
echo FALHA DE COMPILACAO. Envie a saida desta janela para diagnostico.
pause
exit /b 1
