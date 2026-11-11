$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
$version = (cmake --version | Select-Object -First 1)
Write-Host "NEBULA VST3 v0.4.0 - $version" -ForegroundColor Cyan
cmake -S . -B build -G "Visual Studio 17 2022" -A x64
if ($LASTEXITCODE -ne 0) { throw "Configuração do CMake falhou." }
cmake --build build --config Release --target NEBULASampler_VST3 --parallel 4
if ($LASTEXITCODE -ne 0) { throw "Compilação VST3 falhou." }
$names = @(
  "build\NEBULASampler_artefacts\Release\VST3\NEBULA Sampler.vst3",
  "build\NEBULASampler_artefacts\VST3\NEBULA Sampler.vst3"
)
$source = $names | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $source) { throw "Pacote .vst3 não encontrado nos caminhos esperados." }
$target = Join-Path ([Environment]::GetFolderPath('CommonProgramFiles')) 'VST3\NEBULA Sampler.vst3'
New-Item -ItemType Directory -Force -Path (Split-Path $target) | Out-Null
Copy-Item -Path $source -Destination $target -Recurse -Force
Write-Host "Instalado em $target" -ForegroundColor Green
Write-Host "Abra a DAW e reescaneie os plugins VST3."
