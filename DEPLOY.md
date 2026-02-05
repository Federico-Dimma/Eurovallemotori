# Comandi Rapidi AWS Amplify
# Eurovallemotori - Guida Veloce

## Setup Rapido (3 Comandi)

### Opzione 1: Con Repository Git

```powershell
# 1. Crea l'app Amplify
aws amplify create-app --name "eurovallemotori" --description "Eurovallemotori Beta" --region eu-south-1 --platform WEB

# Salva l'APP_ID dal risultato, poi:

# 2. Configura il branch (sostituisci YOUR_APP_ID)
aws amplify create-branch --app-id YOUR_APP_ID --branch-name main --enable-auto-build --region eu-south-1

# 3. Collega il repository e fai il deploy
# Questo va fatto dalla Console AWS Amplify
```

### Opzione 2: Deploy Manuale Veloce

```powershell
# Esegui lo script PowerShell incluso
.\deploy-amplify.ps1
```

## Comandi Utili

### Verifica Setup
```powershell
# Verifica AWS CLI
aws --version

# Verifica credenziali
aws sts get-caller-identity

# Lista app Amplify esistenti
aws amplify list-apps --region eu-south-1
```

### Gestione App
```powershell
# Stato app
aws amplify get-app --app-id YOUR_APP_ID --region eu-south-1

# Stato branch
aws amplify get-branch --app-id YOUR_APP_ID --branch-name main --region eu-south-1

# Avvia nuovo deployment
aws amplify start-deployment --app-id YOUR_APP_ID --branch-name main --region eu-south-1
```

### Dominio
```powershell
# Aggiungi dominio personalizzato
aws amplify create-domain-association --app-id YOUR_APP_ID --domain-name "dimmaweb.com" --sub-domain-settings "prefix=eurovallemotori,branchName=main" --region eu-south-1

# Verifica stato dominio
aws amplify get-domain-association --app-id YOUR_APP_ID --domain-name "dimmaweb.com" --region eu-south-1
```

## Test Locale Prima del Deploy

```powershell
# Installa http-server globalmente (una volta sola)
npm install -g http-server

# Avvia server di test
cd public
http-server -p 8080

# Apri: http://localhost:8080
```

## Rollback/Eliminazione

```powershell
# Elimina dominio
aws amplify delete-domain-association --app-id YOUR_APP_ID --domain-name "dimmaweb.com" --region eu-south-1

# Elimina branch
aws amplify delete-branch --app-id YOUR_APP_ID --branch-name main --region eu-south-1

# Elimina app completa (ATTENZIONE!)
aws amplify delete-app --app-id YOUR_APP_ID --region eu-south-1
```

## Troubleshooting

### Problema: AWS CLI non trovato
```powershell
# Scarica e installa da:
# https://aws.amazon.com/cli/
```

### Problema: Credenziali non configurate
```powershell
aws configure
# Inserisci:
# - AWS Access Key ID
# - AWS Secret Access Key
# - Default region: eu-south-1
# - Default output format: json
```

### Problema: Permessi insufficienti
Assicurati che il tuo utente AWS abbia i permessi:
- AWSAmplifyFullAccess
- CloudFrontFullAccess (per CDN)
- IAMReadOnlyAccess (per verifiche)

## Link Utili

- Console AWS Amplify Milano: https://eu-south-1.console.aws.amazon.com/amplify/
- Documentazione: https://docs.aws.amazon.com/amplify/
- AWS CLI Docs: https://docs.aws.amazon.com/cli/

---

**Pronto per il deploy!** Esegui `.\deploy-amplify.ps1` per iniziare.
