# Script PowerShell per Deploy AWS Amplify
# Eurovallemotori - eurovallemotori.dimmaweb.com

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Eurovallemotori - AWS Amplify Setup" -ForegroundColor Cyan
Write-Host "Versione: beta 1.0.0" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Configurazione
$APP_NAME = "eurovallemotori"
$REGION = "eu-south-1"
$DOMAIN = "dimmaweb.com"
$SUBDOMAIN = "eurovallemotori"
$BRANCH_NAME = "main"

# Verifica AWS CLI
Write-Host "Verifico AWS CLI..." -ForegroundColor Yellow
try {
    $awsVersion = aws --version 2>&1
    Write-Host "✓ AWS CLI installato: $awsVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ AWS CLI non trovato. Installa AWS CLI prima di continuare." -ForegroundColor Red
    Write-Host "Download: https://aws.amazon.com/cli/" -ForegroundColor Yellow
    exit 1
}

# Verifica credenziali AWS
Write-Host "Verifico credenziali AWS..." -ForegroundColor Yellow
try {
    $identity = aws sts get-caller-identity --region $REGION 2>&1 | ConvertFrom-Json
    Write-Host "✓ Autenticato come: $($identity.Arn)" -ForegroundColor Green
} catch {
    Write-Host "✗ Credenziali AWS non configurate. Esegui 'aws configure' prima." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Opzioni di Deployment:" -ForegroundColor Cyan
Write-Host "1) Deployment con Repository Git (consigliato)" -ForegroundColor White
Write-Host "2) Deployment Manuale (solo file)" -ForegroundColor White
Write-Host "3) Solo inizializzazione Git locale" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Scegli opzione (1-3)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "=== Deployment con Repository Git ===" -ForegroundColor Cyan
        
        # Inizializza Git se necessario
        if (!(Test-Path ".git")) {
            Write-Host "Inizializzo repository Git..." -ForegroundColor Yellow
            git init
            git add .
            git commit -m "Initial commit - Eurovallemotori beta 1.0.0"
            Write-Host "✓ Repository Git inizializzato" -ForegroundColor Green
        }
        
        Write-Host ""
        Write-Host "Hai già un repository GitHub/CodeCommit? (s/n)" -ForegroundColor Yellow
        $hasRepo = Read-Host
        
        if ($hasRepo -eq "n") {
            Write-Host ""
            Write-Host "Crea manualmente un repository su GitHub o CodeCommit e poi:" -ForegroundColor Yellow
            Write-Host "git remote add origin <URL_REPOSITORY>" -ForegroundColor White
            Write-Host "git push -u origin main" -ForegroundColor White
            Write-Host ""
            Write-Host "Premi INVIO quando hai completato..." -ForegroundColor Yellow
            Read-Host
        }
        
        $repoUrl = Read-Host "Inserisci l'URL del repository (es: https://github.com/user/repo.git)"
        
        Write-Host ""
        Write-Host "Creo app AWS Amplify..." -ForegroundColor Yellow
        
        $createAppCmd = @"
aws amplify create-app ``
    --name "$APP_NAME" ``
    --description "Eurovallemotori Dashboard Beta 1.0.0" ``
    --repository "$repoUrl" ``
    --platform WEB ``
    --region $REGION ``
    --enable-branch-auto-build
"@
        
        Write-Host $createAppCmd -ForegroundColor Gray
        $appResult = Invoke-Expression $createAppCmd | ConvertFrom-Json
        $APP_ID = $appResult.app.appId
        
        Write-Host "✓ App creata con ID: $APP_ID" -ForegroundColor Green
        
        # Crea branch
        Write-Host "Creo branch main..." -ForegroundColor Yellow
        aws amplify create-branch `
            --app-id $APP_ID `
            --branch-name $BRANCH_NAME `
            --enable-auto-build `
            --region $REGION | Out-Null
        
        Write-Host "✓ Branch configurato" -ForegroundColor Green
        
        # Configura dominio
        Write-Host "Configuro dominio personalizzato..." -ForegroundColor Yellow
        $domainConfig = @{
            prefix = $SUBDOMAIN
            branchName = $BRANCH_NAME
        }
        
        aws amplify create-domain-association `
            --app-id $APP_ID `
            --domain-name $DOMAIN `
            --sub-domain-settings ($domainConfig | ConvertTo-Json -Compress) `
            --region $REGION | Out-Null
        
        Write-Host "✓ Dominio configurato: $SUBDOMAIN.$DOMAIN" -ForegroundColor Green
        
        # Avvia deployment
        Write-Host "Avvio deployment..." -ForegroundColor Yellow
        aws amplify start-deployment `
            --app-id $APP_ID `
            --branch-name $BRANCH_NAME `
            --region $REGION | Out-Null
        
        Write-Host "✓ Deployment avviato!" -ForegroundColor Green
        
        Write-Host ""
        Write-Host "==================================" -ForegroundColor Cyan
        Write-Host "DEPLOYMENT COMPLETATO!" -ForegroundColor Green
        Write-Host "==================================" -ForegroundColor Cyan
        Write-Host "App ID: $APP_ID" -ForegroundColor White
        Write-Host "URL Console: https://eu-south-1.console.aws.amazon.com/amplify/home?region=eu-south-1#/$APP_ID" -ForegroundColor White
        Write-Host ""
        Write-Host "IMPORTANTE: Configura DNS!" -ForegroundColor Yellow
        Write-Host "Nel tuo provider DNS, aggiungi un record CNAME:" -ForegroundColor White
        Write-Host "  Nome: $SUBDOMAIN" -ForegroundColor White
        Write-Host "  Tipo: CNAME" -ForegroundColor White
        Write-Host "  Valore: (vedi console AWS Amplify)" -ForegroundColor White
        Write-Host ""
    }
    
    "2" {
        Write-Host ""
        Write-Host "=== Deployment Manuale ===" -ForegroundColor Cyan
        
        Write-Host "Creo app AWS Amplify..." -ForegroundColor Yellow
        
        $createAppCmd = @"
aws amplify create-app ``
    --name "$APP_NAME" ``
    --description "Eurovallemotori Dashboard Beta" ``
    --region $REGION
"@
        
        $appResult = Invoke-Expression $createAppCmd | ConvertFrom-Json
        $APP_ID = $appResult.app.appId
        
        Write-Host "✓ App creata con ID: $APP_ID" -ForegroundColor Green
        
        Write-Host ""
        Write-Host "Per completare il deployment manuale:" -ForegroundColor Yellow
        Write-Host "1. Vai su: https://eu-south-1.console.aws.amazon.com/amplify/home?region=eu-south-1#/$APP_ID" -ForegroundColor White
        Write-Host "2. Carica i file dalla cartella 'public'" -ForegroundColor White
        Write-Host "3. Configura il dominio personalizzato dalla console" -ForegroundColor White
        Write-Host ""
    }
    
    "3" {
        Write-Host ""
        Write-Host "=== Inizializzazione Git ===" -ForegroundColor Cyan
        
        if (Test-Path ".git") {
            Write-Host "✓ Repository Git già esistente" -ForegroundColor Green
        } else {
            Write-Host "Inizializzo repository Git..." -ForegroundColor Yellow
            git init
            git add .
            git commit -m "Initial commit - Eurovallemotori beta 1.0.0"
            Write-Host "✓ Repository Git inizializzato" -ForegroundColor Green
        }
        
        Write-Host ""
        Write-Host "Per continuare:" -ForegroundColor Yellow
        Write-Host "1. Crea un repository su GitHub/CodeCommit" -ForegroundColor White
        Write-Host "2. git remote add origin <URL>" -ForegroundColor White
        Write-Host "3. git push -u origin main" -ForegroundColor White
        Write-Host "4. Riesegui questo script e scegli l'opzione 1" -ForegroundColor White
        Write-Host ""
    }
    
    default {
        Write-Host "Opzione non valida" -ForegroundColor Red
        exit 1
    }
}

Write-Host "Script completato!" -ForegroundColor Green
