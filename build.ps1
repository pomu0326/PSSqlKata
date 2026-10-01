$ErrorActionPreference = "Stop"

$projectPath = Join-Path $PSScriptRoot ".\src\pomu0326.PSSqlKata.Deps.csproj"
$outputPath = Join-Path $PSScriptRoot "src\bin"

Write-Host "--- モジュールのビルド (依存DLLの取得) を開始します ---" -ForegroundColor Cyan

# dotnet publishを実行して、指定したbinフォルダにDLLを出力
# --no-self-contained: ランタイムを含めず、純粋なライブラリだけを出力
# -v quiet: ログ出力をすっきりさせる
dotnet publish $projectPath `
    --configuration Release `
    --output $outputPath `
    --no-self-contained `
    --verbosity quiet

if ($LASTEXITCODE -eq 0)
{
    Write-Host "ビルド成功" -ForegroundColor Green
} else
{
    Write-Error "ビルドに失敗しました。dotnetコマンドのエラーを確認してください。"
}
