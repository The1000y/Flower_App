# Git Branch Naming Convention

## General Rule

```
<type>/<feature-name>
```

Use lowercase letters and `kebab-case`.

Examples:

```
feature/auth
feature/login
feature/profile
feature/home
feature/exams

bugfix/login-validation
bugfix/profile-image

hotfix/login-crash

refactor/auth-repository
refactor/home-ui

chore/update-dependencies
chore/flutter-upgrade
chore/lint-rules

docs/readme
docs/api-documentation

test/auth
test/profile
```

---

# Branch Types

| Type | Description |
|------|-------------|
| `feature/` | New feature development |
| `bugfix/` | Fixing a non-critical bug |
| `hotfix/` | Urgent production fix |
| `refactor/` | Code improvements without changing behavior |
| `chore/` | Maintenance tasks (dependencies, configs, CI, etc.) |
| `docs/` | Documentation updates |
| `test/` | Adding or updating tests |
| `release/` | Preparing a release version |

---

# Examples

```
feature/auth
feature/profile
feature/exams

bugfix/login-validation
bugfix/search

hotfix/crash-on-start

refactor/network-layer
refactor/auth-cubit

chore/flutter-upgrade
chore/update-lints

docs/readme

release/v1.0.0
release/v1.1.0
```

---

# Rules

- Use lowercase only.
- Use `-` (kebab-case) to separate words.
- Keep names short and descriptive.
- Do not include developer names in branch names.
- One branch should represent one task only.
- Delete merged branches after merging into the target branch.