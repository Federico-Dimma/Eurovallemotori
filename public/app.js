// JavaScript per Eurovallemotori Dashboard
document.addEventListener('DOMContentLoaded', function() {
    console.log('Eurovallemotori Dashboard beta 1.0.0');
    
    // Evidenzia il menu attivo in base alla pagina corrente
    highlightActiveMenu();
    
    // Aggiungi event listeners per i pulsanti
    addButtonListeners();
});

function highlightActiveMenu() {
    const currentPage = window.location.pathname.split('/').pop() || 'index.html';
    const menuItems = document.querySelectorAll('.menu-item');
    
    menuItems.forEach(item => {
        const href = item.getAttribute('href');
        if (href === currentPage) {
            item.classList.add('active');
        } else {
            item.classList.remove('active');
        }
    });
}

function addButtonListeners() {
    // Event listeners per i pulsanti
    const buttons = document.querySelectorAll('.btn-primary, .btn-secondary, .btn-small');
    
    buttons.forEach(button => {
        button.addEventListener('click', function(e) {
            console.log('Button clicked:', e.target.textContent);
            // Qui puoi aggiungere la logica per i pulsanti
        });
    });
}

// Funzioni di utilità
function showNotification(message, type = 'info') {
    console.log(`[${type.toUpperCase()}] ${message}`);
    // Implementa qui le notifiche toast se necessario
}

// Simulazione dati per sviluppo
function generateMockData() {
    return {
        calcoli: [
            { id: '001', data: '05/02/2026', tipo: 'Standard', stato: 'Completato' },
            { id: '002', data: '04/02/2026', tipo: 'Rapido', stato: 'Completato' }
        ],
        database: [
            { id: 'DB-001', nome: 'Motore X1', categoria: 'Motori' },
            { id: 'DB-002', nome: 'Componente Y2', categoria: 'Componenti' }
        ]
    };
}
