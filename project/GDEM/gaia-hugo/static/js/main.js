/**
 * Gaia Evolución del Ser — JavaScript principal
 * Maneja offcanvas, dropdowns, sticky header para el menú Hugo
 */
document.addEventListener('DOMContentLoaded', function () {
  initOffcanvas();
  initDropdowns();
  initStickyHeader();
});

// --- G01: Offcanvas (menú móvil) ---
function initOffcanvas() {
  var toggleBtn = document.querySelector('.ct-header-trigger');
  var offcanvas = document.querySelector('#offcanvas');
  var closeBtn = offcanvas ? offcanvas.querySelector('.ct-toggle-close') : null;
  if (!toggleBtn || !offcanvas) return;

  toggleBtn.addEventListener('click', function (e) {
    e.preventDefault();
    openOffcanvas(offcanvas);
  });

  if (closeBtn) {
    closeBtn.addEventListener('click', function () {
      closeOffcanvas(offcanvas);
    });
  }

  // Close on overlay click
  offcanvas.addEventListener('click', function (e) {
    if (e.target === offcanvas) {
      closeOffcanvas(offcanvas);
    }
  });

  // Close on Escape key
  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape' && offcanvas.getAttribute('aria-hidden') === 'false') {
      closeOffcanvas(offcanvas);
    }
  });
}

function openOffcanvas(el) {
  el.removeAttribute('inert');
  el.setAttribute('aria-hidden', 'false');
  document.body.classList.add('ct-offcanvas-active');
}

function closeOffcanvas(el) {
  el.setAttribute('inert', '');
  el.setAttribute('aria-hidden', 'true');
  document.body.classList.remove('ct-offcanvas-active');
}

// --- G02: Dropdowns (click-based en desktop, toggle en mobile) ---
function initDropdowns() {
  // Desktop: clicks en <a> con aria-haspopup
  var desktopToggles = document.querySelectorAll('.menu-item-has-children > a[aria-haspopup="true"]');
  desktopToggles.forEach(function (toggle) {
    toggle.addEventListener('click', function (e) {
      if (window.innerWidth < 1000) return; // mobile handled separately
      var nav = toggle.closest('nav');
      if (nav && nav.getAttribute('data-interaction') === 'click:item') {
        e.preventDefault();
        var parent = toggle.closest('.menu-item-has-children');
        if (parent) {
          parent.classList.toggle('submenu-open');
          toggle.setAttribute('aria-expanded', parent.classList.contains('submenu-open'));
        }
      }
    });
  });

  // Mobile: botones de toggle en submenús
  var mobileToggles = document.querySelectorAll('.ct-toggle-dropdown-mobile');
  mobileToggles.forEach(function (btn) {
    btn.addEventListener('click', function (e) {
      e.preventDefault();
      e.stopPropagation();
      var expanded = btn.getAttribute('aria-expanded') === 'true';
      btn.setAttribute('aria-expanded', !expanded);
    });
  });

  // Cerrar dropdowns al hacer click fuera
  document.addEventListener('click', function (e) {
    if (!e.target.closest('.menu-item-has-children') && !e.target.closest('.sub-menu')) {
      document.querySelectorAll('.menu-item-has-children.submenu-open').forEach(function (item) {
        item.classList.remove('submenu-open');
        var link = item.querySelector('a[aria-haspopup]');
        if (link) link.setAttribute('aria-expanded', 'false');
      });
    }
  });
}

// --- G03: Sticky header ---
function initStickyHeader() {
  var header = document.querySelector('#header');
  if (!header) return;
  var stickyClass = 'ct-header--sticky';

  window.addEventListener('scroll', function () {
    if (window.scrollY > 200) {
      header.classList.add(stickyClass);
    } else {
      header.classList.remove(stickyClass);
    }
  }, { passive: true });
}
