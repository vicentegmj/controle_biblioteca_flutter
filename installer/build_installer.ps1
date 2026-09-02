$ErrorActionPreference = 'Stop'

$projectDir = Split-Path -Parent $PSScriptRoot
$releaseExe = Join-Path $projectDir 'build\windows\x64\runner\Release\controle_biblioteca.exe'
$issFile = Join-Path $PSScriptRoot 'controle_biblioteca.iss'
$isccCandidates = @(
    (Join-Path $env:LOCALAPPDATA 'Programs\Inno Setup 6\ISCC.exe'),
    (Join-Path $env:ProgramFiles 'Inno Setup 6\ISCC.exe'),
    (Join-Path ${env:ProgramFiles(x86)} 'Inno Setup 6\ISCC.exe')
)
$iscc = $isccCandidates | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1

if (-not $iscc) {
    throw 'Inno Setup 6 não encontrado. Instale com: winget install JRSoftware.InnoSetup'
}

Push-Location $projectDir
try {
    flutter build windows --release
    if ($LASTEXITCODE -ne 0) {
        throw 'Falha ao gerar o build Release do Flutter.'
    }

    if (-not (Test-Path -LiteralPath $releaseExe)) {
        throw "Executável Release não encontrado: $releaseExe"
    }

    & $iscc $issFile
    if ($LASTEXITCODE -ne 0) {
        throw 'Falha ao compilar o instalador com o Inno Setup.'
    }
} finally {
    Pop-Location
}

Write-Host "Instalador gerado em: $projectDir\dist\BibliotecaEscolar-Setup-1.0.0.exe"
