param(
    [Parameter(Mandatory=$true)][ValidatePattern('^[a-zA-Z0-9][a-zA-Z0-9._-]*$')][string]$Stage,
    [string]$RepositoryPath = 'E:\ANU\COMP6120\assignment4&5\mockito',
    [switch]$FormatOnly
)
$ErrorActionPreference = 'Stop'
$rootPath = 'E:\ANU\COMP6120\assignment4&5'
$outputPath = Join-Path $rootPath ('outputs\issue-3592\' + $Stage)
if (Test-Path -LiteralPath $outputPath) { throw 'Use a new stage name to preserve previous evidence.' }
New-Item -ItemType Directory -Path $outputPath -Force | Out-Null
$startedUtc = [DateTime]::UtcNow
$oldJavaHome = $env:JAVA_HOME
$oldGradleHome = $env:GRADLE_USER_HOME
$env:JAVA_HOME = 'C:\Users\H-F\.jdks\ms-17.0.18'
$env:GRADLE_USER_HOME = Join-Path $rootPath 'work\gradle-home'
$productionPath = Join-Path $RepositoryPath 'mockito-core\src\main\java\org\mockito\internal\configuration\DefaultDoNotMockEnforcer.java'
$beforeHash = (Get-FileHash -LiteralPath $productionPath -Algorithm SHA256).Hash
$arguments = @(':mockito-core:test', '--tests', 'org.mockitousage.annotation.DoNotMockMessageTest', '--tests', 'org.mockitousage.annotation.DoNotMockTest', ':mockito-core:spotlessJavaCheck', '--continue', '--no-build-cache', '--no-daemon', '--no-scan', '--console=plain')
$arguments += @('--init-script', (Join-Path $PSScriptRoot 'no-retry.init.gradle'))
if ($FormatOnly) { $arguments = @(':mockito-core:spotlessJavaCheck', '--no-daemon', '--no-scan', '--console=plain') }
$exitCode = 1
Push-Location $RepositoryPath
try {
    $sha = (git rev-parse HEAD)
    $status = @(git status --porcelain=v1)
    $wrapperJar = Join-Path $RepositoryPath 'gradle\wrapper\gradle-wrapper.jar'
    "java -jar $wrapperJar $($arguments -join ' ')" | Set-Content -LiteralPath (Join-Path $outputPath 'command.txt') -Encoding utf8
    & (Join-Path $env:JAVA_HOME 'bin\java.exe') '-Xmx64m' '-Xms64m' '-Dorg.gradle.appname=gradlew' '-jar' $wrapperJar @arguments 2>&1 |
        Tee-Object -FilePath (Join-Path $outputPath 'gradle.log')
    $exitCode = $LASTEXITCODE
    $summaries = @()
    if (-not $FormatOnly) {
        $xmlRoot = Join-Path $RepositoryPath 'mockito-core\build\test-results\test'
        if (Test-Path -LiteralPath $xmlRoot) {
            foreach ($file in Get-ChildItem -LiteralPath $xmlRoot -Filter 'TEST-*.xml') {
                if ($file.LastWriteTimeUtc -lt $startedUtc) { continue }
                Copy-Item -LiteralPath $file.FullName -Destination $outputPath
                [xml]$xml = Get-Content -LiteralPath $file.FullName -Raw
                $summaries += [pscustomobject]@{class=$xml.testsuite.name;tests=[int]$xml.testsuite.tests;failures=[int]$xml.testsuite.failures;errors=[int]$xml.testsuite.errors;skipped=[int]$xml.testsuite.skipped;cases=@($xml.testsuite.testcase | ForEach-Object { [pscustomobject]@{name=$_.name;failed=($null -ne $_.failure);failure_message=$_.failure.message} })}
            }
        }
    }
    $record = [ordered]@{stage=$Stage;repository=$RepositoryPath;started_utc=$startedUtc.ToString('o');finished_utc=[DateTime]::UtcNow.ToString('o');head=$sha;status=$status;java='Microsoft OpenJDK 17.0.18';gradle='8.14.2';arguments=$arguments;exit_code=$exitCode;production_sha256_before=$beforeHash;production_sha256_after=(Get-FileHash -LiteralPath $productionPath -Algorithm SHA256).Hash;suites=$summaries}
    $record | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath (Join-Path $outputPath 'run.json') -Encoding utf8
}
finally {
    Pop-Location
    $env:JAVA_HOME = $oldJavaHome
    $env:GRADLE_USER_HOME = $oldGradleHome
}
Write-Host "Evidence: $outputPath"
exit $exitCode
