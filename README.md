# Eurovallemotori - Configurazione AWS Amplify

## Informazioni Progetto
- **Nome Applicazione**: eurovallemotori
- **Dominio**: eurovallemotori.dimmaweb.com
- **Regione**: eu-south-1 (Milano)
- **Ambiente**: Produzione Beta
- **Versione**: 1.0.0

## Struttura Progetto
```
Eurovallemotori/
├── public/                # File statici del sito
│   ├── index.html        # Pagina Calcolo
│   ├── database.html     # Pagina Database
│   ├── storico.html      # Pagina Storico
│   ├── styles.css        # Stili CSS
│   └── app.js           # JavaScript
├── amplify/              # Configurazioni AWS
├── amplify.yml          # Configurazione build Amplify
├── package.json         # Dipendenze Node.js
└── README.md           # Questo file
```

## Setup AWS Amplify via CLI

### 1. Prerequisiti
- AWS CLI installato e configurato
- Account AWS con permessi Amplify
- Git installato

### 2. Inizializza Repository Git
```powershell
cd "c:\Users\feder\Desktop\Eurovallemotori"
git init
git add .
git commit -m "Initial commit - Eurovallemotori beta 1.0.0"
```

### 3. Crea Repository su GitHub/CodeCommit (opzionale ma consigliato)
```powershell
# Se usi GitHub
gh repo create eurovallemotori --private --source=. --remote=origin --push

# Oppure crea manualmente su GitHub e poi:
git remote add origin https://github.com/TUO-USERNAME/eurovallemotori.git
git branch -M main
git push -u origin main
```

### 4. Crea App Amplify
```powershell
# Crea l'applicazione Amplify nella regione Milano
aws amplify create-app `
    --name "eurovallemotori" `
    --description "Eurovallemotori Dashboard Beta 1.0.0" `
    --repository "https://github.com/TUO-USERNAME/eurovallemotori" `
    --platform "WEB" `
    --region eu-south-1 `
    --enable-branch-auto-build

# Salva l'APP_ID restituito dal comando precedente
```

### 5. Configura Branch
```powershell
# Sostituisci APP_ID con l'ID restituito dal comando precedente
$APP_ID = "your-app-id-here"

aws amplify create-branch `
    --app-id $APP_ID `
    --branch-name "main" `
    --enable-auto-build `
    --region eu-south-1
```

### 6. Configura Dominio Personalizzato
```powershell
# Aggiungi il dominio personalizzato
aws amplify create-domain-association `
    --app-id $APP_ID `
    --domain-name "dimmaweb.com" `
    --sub-domain-settings "prefix=eurovallemotori,branchName=main" `
    --region eu-south-1
```

### 7. Avvia Deployment
```powershell
# Avvia il primo deployment
aws amplify start-deployment `
    --app-id $APP_ID `
    --branch-name "main" `
    --region eu-south-1
```

## Setup Alternativo: Deployment Manuale (senza Git)

Se preferisci non usare Git, puoi fare deployment diretto:

```powershell
# 1. Crea l'app senza repository
aws amplify create-app `
    --name "eurovallemotori" `
    --description "Eurovallemotori Dashboard Beta" `
    --region eu-south-1

# 2. Crea un file ZIP con i contenuti
Compress-Archive -Path "public\*" -DestinationPath "eurovallemotori.zip"

# 3. Carica manualmente tramite Console AWS Amplify
# Vai su: https://eu-south-1.console.aws.amazon.com/amplify/
```

## Configurazione DNS

Dopo aver creato il dominio su Amplify, devi configurare il DNS:

1. Vai al tuo provider DNS (dove è registrato dimmaweb.com)
2. Aggiungi un record CNAME:
   - **Nome**: eurovallemotori
   - **Tipo**: CNAME
   - **Valore**: [Il valore fornito da AWS Amplify]
   - **TTL**: 300

## Verifica Deployment

```powershell
# Verifica lo stato dell'app
aws amplify get-app --app-id $APP_ID --region eu-south-1

# Verifica lo stato del branch
aws amplify get-branch --app-id $APP_ID --branch-name "main" --region eu-south-1

# Lista tutti i deployment
aws amplify list-jobs --app-id $APP_ID --branch-name "main" --region eu-south-1
```

## Comandi Utili

```powershell
# Lista tutte le app Amplify
aws amplify list-apps --region eu-south-1

# Elimina l'app (attenzione!)
aws amplify delete-app --app-id $APP_ID --region eu-south-1

# Aggiorna l'app
aws amplify update-app --app-id $APP_ID --name "eurovallemotori-updated" --region eu-south-1
```

## Test Locale

Prima del deployment, puoi testare localmente:

```powershell
# Installa http-server (se non già installato)
npm install -g http-server

# Avvia server locale
cd public
http-server -p 8080

# Apri browser su: http://localhost:8080
```

## Caratteristiche del Sito

- ✅ Design grigio sbiadito completamente implementato
- ✅ Scritta "beta 1.0.0" in alto a destra
- ✅ Dashboard laterale con 3 menu (Calcolo, Database, Storico)
- ✅ Completamente separato da dimmaweb.com
- ✅ Hosting su AWS Amplify - Regione Milano
- ✅ Dominio personalizzato: eurovallemotori.dimmaweb.com

## Prossimi Passi

1. Esegui i comandi sopra per creare l'istanza Amplify
2. Configura il DNS con il tuo provider
3. Verifica che il sito sia accessibile su eurovallemotori.dimmaweb.com
4. Inizia a sviluppare le funzionalità di calcolo, database e storico

## Supporto

Per problemi con AWS Amplify:
- Documentazione: https://docs.aws.amazon.com/amplify/
- Console AWS: https://console.aws.amazon.com/amplify/

---

**Nota**: Assicurati di avere i permessi corretti su AWS e che il dominio dimmaweb.com sia configurabile dal tuo account.