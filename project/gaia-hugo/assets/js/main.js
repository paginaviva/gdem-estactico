/**
 * Gaia Evolución del Ser — JavaScript principal
 * Vanilla JS (sin jQuery, sin Elementor JS)
 * Funcionalidad: menú móvil, sticky header, dropdowns, Clarity analytics
 */

document.addEventListener('DOMContentLoaded', function () {
  initMobileMenu();
  initStickyHeader();
  initDropdowns();
});

// --- G01: Menú móvil (offcanvas toggle) ---
function initMobileMenu() {
  const toggleBtn = document.querySelector('.ct-header-trigger');
  const offcanvas = document.querySelector('#offcanvas');
  const closeBtn = offcanvas ? offcanvas.querySelector('.ct-toggle-close') : null;

  if (!toggleBtn || !offcanvas) return;

  toggleBtn.addEventListener('click', function (e) {
    e.preventDefault();
    offcanvas.classList.add('active');
    document.body.classList.add('ct-offcanvas-active');
  });

  if (closeBtn) {
    closeBtn.addEventListener('click', function () {
      offcanvas.classList.remove('active');
      document.body.classList.remove('ct-offcanvas-active');
    });
  }

  // Close on overlay click
  offcanvas.addEventListener('click', function (e) {
    if (e.target === offcanvas) {
      offcanvas.classList.remove('active');
      document.body.classList.remove('ct-offcanvas-active');
    }
  });
}

// --- G02: Sticky header ---
function initStickyHeader() {
  const header = document.querySelector('#header');
  if (!header) return;

  let lastScrollY = window.scrollY;
  const stickyClass = 'ct-header--sticky';

  window.addEventListener('scroll', function () {
    const scrollY = window.scrollY;

    if (scrollY > 200) {
      header.classList.add(stickyClass);
    } else {
      header.classList.remove(stickyClass);
    }

    lastScrollY = scrollY;
  }, { passive: true });
}

// --- G03: Dropdowns (click-based, como el original) ---
function initDropdowns() {
  const dropdownToggles = document.querySelectorAll('.menu-item-has-children > a, .ct-menu-link[aria-haspopup="true"]');

  dropdownToggles.forEach(function (toggle) {
    toggle.addEventListener('click', function (e) {
      const parent = toggle.closest('.menu-item-has-children');
      if (!parent) return;

      // In mobile menu, toggle submenu
      if (window.innerWidth < 1000) {
        e.preventDefault();
        parent.classList.toggle('submenu-open');
      }
      // In desktop, follow data-interaction (click:item behavior)
      else if (toggle.getAttribute('data-interaction') === 'click:item') {
        e.preventDefault();
        parent.classList.toggle('submenu-open');
      }
    });
  });

  // Close dropdowns when clicking outside
  document.addEventListener('click', function (e) {
    if (!e.target.closest('.menu-item-has-children')) {
      document.querySelectorAll('.menu-item-has-children.submenu-open').forEach(function (item) {
        item.classList.remove('submenu-open');
      });
    }
  });
}
