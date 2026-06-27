# Guía de flujo git — Trabajo con ramas integrado con OAC

> **Propósito:** Explicar cómo usar ramas git para aislar desarrollos y cómo integrarlo con el flujo de trabajo de OAC.
> **Última actualización:** 2026-06-12

---

## ¿Por qué usar ramas?

Trabajar siempre en `main` tiene riesgos:

- Si un desarrollo se queda a medias, `main` queda en un estado inconsistente
- Si surge una urgencia, no puedes separar lo que está en curso de lo que hay que arreglar
- No puedes tener varios desarrollos en paralelo
- Si algo sale mal, es difícil volver atrás sin perder otros cambios

Las ramas solucionan esto: cada desarrollo vive en su propia rama aislada. Cuando está completo y validado, se fusiona a `main`.

---

## Estructura recomendada

```
main                    ← Rama principal. Siempre estable y desplegable.
├── desarrollo/auth     ← Rama para un desarrollo concreto
├── fix/error-404       ← Rama para una corrección
└── mejora/pendientes   ← Rama para una mejora
```

**Convención de nombres:**
| Tipo | Prefijo | Ejemplo |
|------|---------|---------|
| Desarrollo nuevo | `desarrollo/` | `desarrollo/migracion-form-editor` |
| Corrección | `fix/` | `fix/error-404-subida` |
| Mejora | `mejora/` | `mejora/upload-multiple` |
| Experimentación | `experimento/` | `experimento/nuevo-stage` |

---

## Flujo de trabajo paso a paso

### 1. Al iniciar un desarrollo (01 o 02)

Cuando ejecutas `01-P-iniciar-desarrollo` o `02-P-iniciar-mejora`, el agente crea el plan. **Tú decides cuándo crear la rama.** Normalmente justo antes de decir "procede con el plan":

```bash
# Asegúrate de estar en main y tener la última versión
git checkout main
git pull

# Crea una rama para tu desarrollo
git checkout -b desarrollo/migracion-form-editor
```

La rama se crea a partir de `main`. Ahora puedes trabajar sin miedo a romper nada.

### 2. Durante el desarrollo

Trabaja normalmente. El agente OAC creará archivos, los modificará, etc.

```bash
# Para ver qué archivos has tocado
git status

# Para ver los cambios pendientes
git diff
```

Cuando completes una unidad lógica (ej: el frontend del FEX), haz commit:

```bash
# Añade los archivos de esa unidad
git add public/artefactos/forms/externos/fex-wc-product-editor/

# Haz commit con un mensaje descriptivo
git commit -m "feat: crear frontend Alpine.js del FEX WooCommerce"
```

**Recomendación:** Haz commits pequeños y frecuentes. Un commit = un cambio lógico.

### 3. Al finalizar el desarrollo

Cuando el desarrollo está completo y validado:

```bash
# 1. Asegúrate de tener todo commiteado
git status                      # Debe decir "nothing to commit"
git log --oneline               # Revisa los commits de tu rama

# 2. Vuelve a main y actualiza
git checkout main
git pull

# 3. Vuelve a tu rama y fusiona main (por si hubo cambios)
git checkout desarrollo/migracion-form-editor
git merge main                  # Resuelve conflictos si los hay

# 4. Vuelve a main y fusiona tu rama
git checkout main
git merge desarrollo/migracion-form-editor

# 5. Sube los cambios
git push
```

**Alternativa con pull request (si usas GitHub):**
```bash
git push -u origin desarrollo/migracion-form-editor
```
Luego crea un Pull Request en GitHub y fusiónalo desde la interfaz web.

### 4. Después del merge

Una vez fusionado a `main`, puedes eliminar la rama:

```bash
# Eliminar rama local
git branch -d desarrollo/migracion-form-editor

# Eliminar rama remota (si la subiste)
git push origin --delete desarrollo/migracion-form-editor
```

---

## Integración con el flujo OAC

### Opción A: Tú gestionas git, OAC se centra en código

Es la más sencilla. OAC trabaja en los archivos; tú haces los commits y merges.

```
1. 01-P-iniciar-desarrollo → plan creado
2. Tú: git checkout -b desarrollo/tema
3. Tú: "Procede con el plan" → OAC desarrolla
4. [OAC trabaja. Tú haces commits cuando toca]
5. Tú: "Terminado" → OAC valida
6. Tú: git add + commit + merge a main
7. 07-P-cerrar-desarrollo → informe de cierre
```

### Opción B: OAC gestiona git (avanzado)

Pídele a OAC que gestione los commits. Es útil si prefieres no salir del chat:

```
1. 01-P-iniciar-desarrollo → plan creado
2. "Procede con el plan. Crea la rama desarrollo/tema y haz commits"
3. OAC crea la rama, desarrolla y hace commits
4. Al final: "He terminado. Haz merge a main cuando quieras"
```

**Importante:** Aunque el agente haga commits, **el merge a main siempre debe aprobarlo el usuario** para evitar conflictos no deseados.

---

## Resolución de conflictos

Si al hacer `git merge main` aparecen conflictos:

```bash
# Git te dirá qué archivos están en conflicto
git status

# Edita los archivos conflictivos (busca las marcas <<<<<<<)
# Decide qué versión conservar

# Una vez resueltos, añádelos y completa el merge
git add [archivos resueltos]
git commit -m "merge: resolver conflictos con main"
```

Si no estás seguro de cómo resolver un conflicto, OAC puede ayudarte:
```
Ejecuta ... para Resolver conflicto git en [archivo]
```

---

## Buenas prácticas

| Práctica | Motivo |
|----------|--------|
| **Una rama por desarrollo** | Cada desarrollo es independiente |
| **Commits pequeños** | Fáciles de revisar y revertir si algo falla |
| **Pull antes de merge** | Asegura que tienes la última versión de main |
| **No borrar ramas hasta fusionar** | No pierdes el trabajo si algo sale mal |
| **Mensajes de commit descriptivos** | `feat: añadir endpoint upload` mejor que `cambios varios` |
| **Merge a main después del cierre** | Primero el informe de cierre (07), luego el merge |

### Formato de mensajes de commit

Usa prefijos para identificar el tipo de cambio:

| Prefijo | Significado |
|---------|-------------|
| `feat:` | Nueva funcionalidad |
| `fix:` | Corrección de error |
| `refactor:` | Cambio de código sin cambiar funcionalidad |
| `docs:` | Documentación |
| `test:` | Tests |
| `chore:` | Mantenimiento, configuración |

**Ejemplos:**
```
feat: crear frontend Alpine.js del FEX WooCommerce
fix: corregir error 404 en subida de archivos
refactor: separar lógica de validación en helper
docs: actualizar README con nuevos endpoints
test: añadir tests unitarios para upload
```
