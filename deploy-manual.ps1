# Script per deploy manuale Amplify
$APP_NAME = "eurovallemotori"
$REGION = "eu-south-1"

Write-Host "Creazione app Amplify..." -ForegroundColor Cyan

# Crea app
$result = aws amplify create-app --name $APP_NAME --region $REGION | ConvertFrom-Json
$appId = $result.app.appId

Write-Host "App creata: $appId" -ForegroundColor Green
Write-Host "Default Domain: $($result.app.defaultDomain)" -ForegroundColor Yellow

# Crea branch
Write-Host "`nCreazione branch..." -ForegroundColor Cyan
aws amplify create-branch --app-id $appId --branch-name main --region $REGION | Out-Null

# Crea ZIP
Write-Host "Creazione ZIP..." -ForegroundColor Cyan
if (Test-Path "deploy.zip") { Remove-Item "deploy.zip" }
Compress-Archive -Path "public\*" -DestinationPath "deploy.zip"

# Crea deployment
Write-Host "Upload files..." -ForegroundColor Cyan
$deployment = aws amplify create-deployment --app-id $appId --branch-name main --region $REGION | ConvertFrom-Json
$uploadUrl = $deployment.zipUploadUrl

# Upload ZIP
Write-Host "Uploading to S3..." -ForegroundColor Cyan
curl.exe -X PUT -T "deploy.zip" "$uploadUrl"

# Avvia job
Write-Host "Avvio deployment..." -ForegroundColor Cyan
aws amplify start-deployment --app-id $appId --branch-name main --job-id $deployment.jobId --region $REGION | Out-Null

Write-Host "`n=== COMPLETATO ===" -ForegroundColor Green
Write-Host "App ID: $appId" -ForegroundColor White
Write-Host "URL: https://main.$($result.app.defaultDomain)" -ForegroundColor White
Write-Host "Console: https://eu-south-1.console.aws.amazon.com/amplify/home?region=eu-south-1#/$appId" -ForegroundColor White
