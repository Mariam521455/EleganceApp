/**
 * Élégance App - Global JavaScript
 * Centralise les notifications et les interactions AJAX
 */

document.addEventListener('DOMContentLoaded', () => {
    initToasts();
});

/**
 * Initialise les toasts à partir des attributs data du conteneur
 */
function initToasts() {
    const container = document.getElementById('toastContainer');
    if (!container) return;

    if (container.dataset.success) {
        showToast("Succès", container.dataset.success, "success");
    }
    if (container.dataset.error) {
        showToast("Erreur", container.dataset.error, "error");
    }
}

/**
 * Affiche une notification toast
 * @param {string} title - Titre du message
 * @param {string} message - Corps du message
 * @param {string} type - 'success' ou 'error'
 */
function showToast(title, message, type) {
    const container = document.getElementById('toastContainer');
    if (!container) {
        console.error("Toast container not found!");
        return;
    }

    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    toast.innerHTML = `
        <span class="toast-icon">${type === 'success' ? '✅' : '❌'}</span>
        <div class="toast-content">
            <strong>${title}</strong>
            <p>${message}</p>
        </div>
    `;

    container.appendChild(toast);

    // Entrée animée
    setTimeout(() => {
        toast.style.opacity = '1';
        toast.style.transform = 'translateX(0)';
    }, 10);

    // Disparition automatique après 5s
    setTimeout(() => {
        toast.style.opacity = '0';
        toast.style.transform = 'translateX(100%)';
        setTimeout(() => toast.remove(), 500);
    }, 5000);
}

// --- Fonctions Partagées ---

/**
 * Configuration de base d'Axios pour inclure les headers nécessaires si besoin
 */
// axios.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded';
