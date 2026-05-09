/**
 * Système de Toast Notifications pour Élégance App
 * Affiche des messages de succès/erreur non-intrusifs
 */

// Création du conteneur de toasts s'il n'existe pas
if (!document.getElementById('toast-container')) {
    const toastContainer = document.createElement('div');
    toastContainer.id = 'toast-container';
    toastContainer.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 10000;
        display: flex;
        flex-direction: column;
        gap: 10px;
        pointer-events: none;
    `;
    document.body.appendChild(toastContainer);
}

/**
 * Affiche un toast de succès
 * @param {string} message - Le message à afficher
 * @param {number} duration - Durée d'affichage en ms (défaut: 3000)
 */
function showSuccess(message, duration = 3000) {
    showToast(message, 'success', duration);
}

/**
 * Affiche un toast d'erreur
 * @param {string} message - Le message à afficher
 * @param {number} duration - Durée d'affichage en ms (défaut: 5000)
 */
function showError(message, duration = 5000) {
    showToast(message, 'error', duration);
}

/**
 * Affiche un toast d'information
 * @param {string} message - Le message à afficher
 * @param {number} duration - Durée d'affichage en ms (défaut: 4000)
 */
function showInfo(message, duration = 4000) {
    showToast(message, 'info', duration);
}

/**
 * Fonction principale pour afficher un toast
 * @param {string} message - Le message à afficher
 * @param {string} type - Type de toast (success, error, info)
 * @param {number} duration - Durée d'affichage en ms
 */
function showToast(message, type, duration) {
    const container = document.getElementById('toast-container');
    if (!container) return;

    // Création de l'élément toast
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    
    // Styles du toast
    const baseStyles = `
        padding: 12px 20px;
        border-radius: 8px;
        font-family: 'Inter', sans-serif;
        font-size: 14px;
        font-weight: 500;
        min-width: 250px;
        max-width: 350px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        pointer-events: auto;
        cursor: pointer;
        transform: translateX(100%);
        transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
        display: flex;
        align-items: center;
        gap: 10px;
    `;

    // Styles selon le type
    const typeStyles = {
        success: {
            background: 'linear-gradient(135deg, #28a745, #20c997)',
            color: 'white',
            borderLeft: '4px solid #20c997'
        },
        error: {
            background: 'linear-gradient(135deg, #dc3545, #c82333)',
            color: 'white',
            borderLeft: '4px solid #c82333'
        },
        info: {
            background: 'linear-gradient(135deg, #17a2b8, #138496)',
            color: 'white',
            borderLeft: '4px solid #138496'
        }
    };

    // Application des styles
    toast.style.cssText = baseStyles;
    Object.assign(toast.style, typeStyles[type] || typeStyles.info);

    // Icône selon le type
    const icons = {
        success: '✓',
        error: '✕',
        info: 'ℹ'
    };

    toast.innerHTML = `
        <span style="font-size: 16px; font-weight: bold;">${icons[type] || icons.info}</span>
        <span>${message}</span>
    `;

    // Ajout au conteneur
    container.appendChild(toast);

    // Animation d'entrée
    setTimeout(() => {
        toast.style.transform = 'translateX(0)';
        toast.style.opacity = '1';
    }, 50);

    // Fonction pour fermer le toast
    const closeToast = () => {
        toast.style.transform = 'translateX(100%)';
        toast.style.opacity = '0';
        setTimeout(() => {
            if (toast.parentNode) {
                toast.parentNode.removeChild(toast);
            }
        }, 300);
    };

    // Click pour fermer
    toast.addEventListener('click', closeToast);

    // Fermeture automatique
    setTimeout(closeToast, duration);
}

// Export des fonctions pour utilisation globale
window.showSuccess = showSuccess;
window.showError = showError;
window.showInfo = showInfo;
window.showToast = showToast;
