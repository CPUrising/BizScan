# 本机（Windows）运行 BizScanCore 单元测试
# 前置条件：安装 Swift for Windows 工具链（winget install Swift.Toolchain）与 VS 2022 C++ 生成工具
$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
Push-Location $root
try {
    if (-not (Get-Command swift -ErrorAction SilentlyContinue)) {
        throw "未找到 swift。请先安装 Swift for Windows 工具链。"
    }
    swift test --package-path Packages/BizScanCore
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    Write-Host "✓ BizScanCore 验证完成"
}
finally {
    Pop-Location
}
