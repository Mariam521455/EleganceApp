/**
 * Élégance App - Global JavaScript
 * Centralise les notifications et les interactions AJAX
 */

// Configurer Axios globalement
if (window.axios) {
    axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';
    console.log("Axios configuré pour Élégance ✨");
}

document.addEventListener('DOMContentLoaded', () => {
    initToasts();
    initSearch();
});

/**
 * Ajoute un article au panier via AJAX
 * @param {number} articleId - ID de l'article
 */
async function addToCart(articleId) {
    if (!articleId) return;

    try {
        const params = new URLSearchParams();
        params.append('action', 'add');
        params.append('id', articleId);

        const baseUrl = (typeof CONTEXT_PATH !== 'undefined') ? CONTEXT_PATH : '';
        const response = await axios.post(`${baseUrl}/cart`, params);

        if (response.status === 200) {
            showToast("Panier ✨", "Article ajouté à votre sélection !", "success");
            animateCartBadge();
        }
    } catch (err) {
        console.error('Erreur panier:', err);
        if (err.response && err.response.status === 401) {
            showToast("Connexion requise", "Connectez-vous pour commander.", "error");
        } else {
            showToast("Oups ! ❌", "Impossible d'ajouter l'article.", "error");
        }
    }
}

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
        // Fallback simple si pas de conteneur
        console.log(`[Toast ${type}] ${title}: ${message}`);
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
 * Initialise la recherche en temps réel sur la grille d'articles
 */
function initSearch() {
    const searchInput = document.getElementById('searchInput');
    const articlesGrid = document.getElementById('articlesGrid');
    if (!searchInput || !articlesGrid) return;

    searchInput.addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase().trim();
        const cards = articlesGrid.querySelectorAll('.article-card');

        cards.forEach(card => {
            const title = card.querySelector('h3')?.textContent.toLowerCase() || '';
            const category = card.dataset.category || '';
            const content = title + ' ' + category;

            if (content.includes(query)) {
                card.style.display = 'block';
                card.style.animation = 'none';
                card.offsetHeight;
                card.style.animation = null;
            } else {
                card.style.display = 'none';
            }
        });

        let noResults = articlesGrid.querySelector('.no-results-message');
        const visibleCards = Array.from(cards).filter(c => c.style.display !== 'none');

        if (visibleCards.length === 0 && query !== '') {
            if (!noResults) {
                noResults = document.createElement('div');
                noResults.className = 'no-results-message reveal-lux';
                noResults.style.gridColumn = '1 / -1';
                noResults.style.textAlign = 'center';
                noResults.style.padding = '3rem';
                noResults.style.color = 'var(--color-gold)';
                noResults.innerHTML = `
                    <i class="fas fa-search-minus" style="font-size: 3rem; margin-bottom: 1rem; display: block;"></i>
                    <p style="font-family: 'Playfair Display', serif; font-size: 1.5rem;">Aucun article trouvé pour "${query}"</p>
                `;
                articlesGrid.appendChild(noResults);
            }
        } else if (noResults) {
            noResults.remove();
        }
    });
}

/**
 * Gère le bouton Retour en haut
 */
window.addEventListener('scroll', () => {
    const scrollBtn = document.getElementById('scrollToTop');
    if (scrollBtn) {
        if (window.scrollY > 300) {
            scrollBtn.classList.add('show');
        } else {
            scrollBtn.classList.remove('show');
        }
    }
});

document.addEventListener('DOMContentLoaded', () => {
    const scrollBtn = document.getElementById('scrollToTop');
    if (scrollBtn) {
        scrollBtn.addEventListener('click', () => {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });
    }
});

/**
 * Fonction décorative pour animer le compteur du panier
 */
function animateCartBadge() {
    const badge = document.querySelector('.cart-count-badge') || document.getElementById('cart-icon');
    if (badge) {
        badge.classList.remove('cart-pulse');
        void badge.offsetWidth; // Trigger reflow
        badge.classList.add('cart-pulse');
        setTimeout(() => badge.classList.remove('cart-pulse'), 1000);
    }
}

/**
 * Gère le partage d'un article
 */
async function handleShare(articleName) {
    const shareData = {
        title: articleName,
        text: `Découvrez cet article d'exception chez Élégance : ${articleName}`,
        url: window.location.href
    };

    try {
        if (navigator.share) {
            await navigator.share(shareData);
        } else {
            await navigator.clipboard.writeText(window.location.href);
            showToast("Partage", "Lien copié dans le presse-papier ✨", "success");
        }
    } catch (err) {
        console.error('Erreur lors du partage:', err);
    }
}

/**
 * Gère les étapes du tunnel d'achat (Checkout)
 */
function goToStep(step) {
    document.querySelectorAll('.checkout-section').forEach(sec => sec.classList.remove('active'));
    const targetSection = document.getElementById(`checkout-step-${step}`);
    if (targetSection) {
        targetSection.classList.add('active');
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    document.querySelectorAll('.checkout-stepper .step').forEach((s, idx) => {
        if (idx + 1 === step) s.classList.add('active');
        else if (idx + 1 < step) {
            s.classList.add('completed');
            s.classList.remove('active');
        } else s.classList.remove('active', 'completed');
    });
}

/**
 * Gère l'ajout/suppression des favoris via AJAX (Optimistic UI)
 */
async function toggleFavorite(btn) {
    if (!btn) return;

    // Récupération de l'ID via l'attribut data (plus robuste)
    const articleId = btn.dataset.articleId || btn.getAttribute('data-article-id');
    const heartIcon = btn.querySelector('i');

    if (!heartIcon) return;

    // --- PHASE 1 : Changement Visuel Immédiat (Optimistic / User Request) ---
    // Le code utilisateur demandait un toggle simple : toggle('favorite-active')
    // Nous conservons notre logique far/fas pour un rendu solide (filled) vs vide (outline)
    const wasFavorite = heartIcon.classList.contains('favorite-active');

    if (wasFavorite) {
        heartIcon.classList.remove('fas', 'favorite-active');
        heartIcon.classList.add('far');
        heartIcon.style.color = '';
    } else {
        heartIcon.classList.remove('far');
        heartIcon.classList.add('fas', 'favorite-active');
        heartIcon.style.color = '#e74c3c';
    }

    // Animation de "pop"
    btn.style.transform = 'scale(1.4)';
    setTimeout(() => { btn.style.transform = 'scale(1)'; }, 200);

    // --- PHASE 2 : Synchronisation avec le Serveur (Bonus) ---
    if (!articleId) return; // Si pas d'ID, on s'arrête au visuel

    try {
        btn.style.pointerEvents = 'none';

        const params = new URLSearchParams();
        params.append('articleId', articleId);

        // Usage de CONTEXT_PATH défini dans header.jsp
        const baseUrl = (typeof CONTEXT_PATH !== 'undefined') ? CONTEXT_PATH : '';
        const response = await axios.post(`${baseUrl}/favorites`, params, {
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        });

        if (response.data && response.data.status === 'success') {
            const isAdded = response.data.added;

            // Correction éventuelle si le serveur dit autre chose que l'UI
            if (isAdded) {
                heartIcon.classList.remove('far');
                heartIcon.classList.add('fas', 'favorite-active');
                heartIcon.style.color = '#e74c3c';
                // Optionnel : Toast réduit pour ne pas spammer
                // showToast("Favoris", "Ajouté aux favoris", "success");
            } else {
                heartIcon.classList.remove('fas', 'favorite-active');
                heartIcon.classList.add('far');
                heartIcon.style.color = '';

                // Gestion auto-suppression page favoris (si applicable)
                if (window.location.href.includes('/favorites')) {
                    const card = btn.closest('.article-card');
                    if (card) card.remove();
                }
            }
        }
    } catch (err) {
        console.error('Erreur favoris:', err);
        // Rollback visuel en cas d'erreur réseau
        if (wasFavorite) {
            heartIcon.classList.add('fas', 'favorite-active');
            heartIcon.classList.remove('far');
            heartIcon.style.color = '#e74c3c';
        } else {
            heartIcon.classList.remove('fas', 'favorite-active');
            heartIcon.classList.add('far');
            heartIcon.style.color = '';
        }
        showToast("Erreur", "Impossible de synchroniser le favori", "error");
    } finally {
        btn.style.pointerEvents = 'auto';
    }
}
