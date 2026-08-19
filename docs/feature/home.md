# HOME FEATURE — Git Branch & Project Structure Guide

## Git Branch Naming Convention

### General Rule

```text
<type>/<feature-name>
```

Use lowercase letters and `kebab-case`.

For the Home feature:

```text
feature/home
```

Examples:

```text
feature/home
feature/home-search
feature/home-occasion
feature/home-categories
feature/home-best-seller
feature/home-product-details

bugfix/home-search
bugfix/home-loading
bugfix/home-product-details

hotfix/home-crash

refactor/home-repository
refactor/home-cubit

chore/home-dependencies

test/home
test/home-use-cases
test/home-repository
```

---

# Branch Types

| Type        | Description                                 |
| ----------- | ------------------------------------------- |
| `feature/`  | New Home feature development                |
| `bugfix/`   | Fixing a non-critical Home bug              |
| `hotfix/`   | Urgent Home production fix                  |
| `refactor/` | Code improvements without changing behavior |
| `chore/`    | Maintenance tasks related to Home           |
| `docs/`     | Home documentation updates                  |
| `test/`     | Adding or updating Home tests               |
| `release/`  | Preparing a release version                 |

---

# Home Feature Main Branch

The main branch for the Home feature is:

```text
feature/home
```

All Home development should be done on this branch unless the team decides to create a separate task branch.

---

# Home Feature Structure

```text
features/
│
├── auth/
│
└── home/
    │
    ├── api/
    │   ├── client/
    │   │   └── home_api_client.dart
    │   │
    │   └── data_source_impl/
    │       ├── local/
    │       │   └── local_data_source_impl.dart
    │       │
    │       └── remote/
    │           └── remote_data_source_impl.dart
    │
    ├── data/
    │   │
    │   ├── data_source/
    │   │   ├── local_data_source/
    │   │   │   └── home_local_data_source.dart
    │   │   │
    │   │   └── remote_data_source/
    │   │       └── home_remote_data_source.dart
    │   │
    │   ├── model/
    │   │   │
    │   │   ├── request/
    │   │   │   ├── home_request/
    │   │   │   │   └── home_request_dto.dart
    │   │   │   │
    │   │   │   ├── search_request/
    │   │   │   │   └── search_request_dto.dart
    │   │   │   │
    │   │   │   ├── occasion_request/
    │   │   │   │   └── occasion_request_dto.dart
    │   │   │   │
    │   │   │   ├── categories_request/
    │   │   │   │   └── categories_request_dto.dart
    │   │   │   │
    │   │   │   ├── best_seller_request/
    │   │   │   │   └── best_seller_request_dto.dart
    │   │   │   │
    │   │   │   └── product_details_request/
    │   │   │       └── product_details_request_dto.dart
    │   │   │
    │   │   └── responce/
    │   │       ├── home_response/
    │   │       │   └── home_response_dto.dart
    │   │       │
    │   │       ├── search_response/
    │   │       │   └── search_response_dto.dart
    │   │       │
    │   │       ├── occasion_response/
    │   │       │   └── occasion_response_dto.dart
    │   │       │
    │   │       ├── categories_response/
    │   │       │   └── categories_response_dto.dart
    │   │       │
    │   │       ├── best_seller_response/
    │   │       │   └── best_seller_response_dto.dart
    │   │       │
    │   │       └── product_details_response/
    │   │           └── product_details_response_dto.dart
    │   │
    │   └── repo_impl/
    │       └── home_repo_impl.dart
    │
    ├── domain/
    │   │
    │   ├── entities/
    │   │   ├── home/
    │   │   │   └── home_entity.dart
    │   │   │
    │   │   ├── search/
    │   │   │   └── search_entity.dart
    │   │   │
    │   │   ├── occasion/
    │   │   │   └── occasion_entity.dart
    │   │   │
    │   │   ├── categories/
    │   │   │   └── categories_entity.dart
    │   │   │
    │   │   ├── best_seller/
    │   │   │   └── best_seller_entity.dart
    │   │   │
    │   │   └── product_details/
    │   │       └── product_details_entity.dart
    │   │
    │   ├── repo/
    │   │   └── home_repo.dart
    │   │
    │   └── use_case/
    │       ├── get_home_data_use_case.dart
    │       ├── search_product_use_case.dart
    │       ├── get_occasions_use_case.dart
    │       ├── get_categories_use_case.dart
    │       ├── get_best_seller_use_case.dart
    │       └── get_product_details_use_case.dart
    │
    └── presentation/
        │
        ├── home/
        │   ├── manager/
        │   │   └── cubit/
        │   │       ├── home_cubit.dart
        │   │       ├── home_event.dart
        │   │       └── home_state.dart
        │   │
        │   └── view/
        │       ├── home.dart
        │       └── widgets/
        │
        ├── search/
        │   ├── manager/
        │   │   └── cubit/
        │   │       ├── search_cubit.dart
        │   │       ├── search_event.dart
        │   │       └── search_state.dart
        │   │
        │   └── view/
        │       ├── search.dart
        │       └── widgets/
        │
        ├── occasion/
        │   ├── manager/
        │   │   └── cubit/
        │   │       ├── occasion_cubit.dart
        │   │       ├── occasion_event.dart
        │   │       └── occasion_state.dart
        │   │
        │   └── view/
        │       ├── occasion.dart
        │       └── widgets/
        │
        ├── categories/
        │   ├── manager/
        │   │   └── cubit/
        │   │       ├── categories_cubit.dart
        │   │       ├── categories_event.dart
        │   │       └── categories_state.dart
        │   │
        │   └── view/
        │       ├── categories.dart
        │       └── widgets/
        │
        ├── best_seller/
        │   ├── manager/
        │   │   └── cubit/
        │   │       ├── best_seller_cubit.dart
        │   │       ├── best_seller_event.dart
        │   │       └── best_seller_state.dart
        │   │
        │   └── view/
        │       ├── best_seller.dart
        │       └── widgets/
        │
        └── product_details/
            ├── manager/
            │   └── cubit/
            │       ├── product_details_cubit.dart
            │       ├── product_details_event.dart
            │       └── product_details_state.dart
            │
            └── view/
                ├── product_details.dart
                └── widgets/
```

---

# Test Structure

```text
test/
│
└── features/
    │
    └── home/
        │
        ├── data/
        │   ├── data_source/
        │   ├── model/
        │   └── repo_impl/
        │
        └── domain/
            ├── entities/
            └── use_case/
```

---

# Clean Architecture Layers

The Home feature follows:

```text
Presentation
      ↓
Domain
      ↓
Data
      ↓
API
```

### Presentation

Responsible for:

* UI
* Cubit
* Events
* States
* Widgets

```text
presentation/
```

### Domain

Responsible for:

* Entities
* Repository contracts
* Use Cases

```text
domain/
├── entities/
├── repo/
└── use_case/
```

### Data

Responsible for:

* DTOs
* Data Sources
* Repository implementation

```text
data/
├── data_source/
├── model/
└── repo_impl/
```

### API

Responsible for:

* Retrofit API Client
* Local Data Source Implementation
* Remote Data Source Implementation

```text
api/
├── client/
└── data_source_impl/
```

---

# Naming Convention

## Files

Use lowercase letters with `snake_case`.

Correct:

```text
home_cubit.dart
home_state.dart
home_repo.dart
home_repo_impl.dart
home_entity.dart
home_request_dto.dart
home_response_dto.dart
get_home_data_use_case.dart
```

Incorrect:

```text
HomeCubit.dart
HomeState.dart
HomeRepo.dart
homeRepo.dart
```

---

# DTO Naming

Request DTOs:

```text
<feature>_request_dto.dart
```

Examples:

```text
home_request_dto.dart
search_request_dto.dart
occasion_request_dto.dart
categories_request_dto.dart
best_seller_request_dto.dart
product_details_request_dto.dart
```

Response DTOs:

```text
<feature>_response_dto.dart
```

Examples:

```text
home_response_dto.dart
search_response_dto.dart
occasion_response_dto.dart
categories_response_dto.dart
best_seller_response_dto.dart
product_details_response_dto.dart
```

---

# Entity Naming

Entities are placed inside:

```text
domain/entities/
```

Each feature has its own folder.

```text
home/
└── home_entity.dart

search/
└── search_entity.dart

occasion/
└── occasion_entity.dart

categories/
└── categories_entity.dart

best_seller/
└── best_seller_entity.dart

product_details/
└── product_details_entity.dart
```

---

# Use Case Naming

Use Cases should describe an action.

Format:

```text
<action>_<object>_use_case.dart
```

Examples:

```text
get_home_data_use_case.dart
search_product_use_case.dart
get_occasions_use_case.dart
get_categories_use_case.dart
get_best_seller_use_case.dart
get_product_details_use_case.dart
```

---

# Repository Naming

Interface:

```text
home_repo.dart
```

Implementation:

```text
home_repo_impl.dart
```

The interface belongs to:

```text
domain/repo/
```

The implementation belongs to:

```text
data/repo_impl/
```

---

# Cubit Naming

Each presentation feature has its own Cubit:

```text
home_cubit.dart
search_cubit.dart
occasion_cubit.dart
categories_cubit.dart
best_seller_cubit.dart
product_details_cubit.dart
```

Events:

```text
home_event.dart
search_event.dart
occasion_event.dart
categories_event.dart
best_seller_event.dart
product_details_event.dart
```

States:

```text
home_state.dart
search_state.dart
occasion_state.dart
categories_state.dart
best_seller_state.dart
product_details_state.dart
```

---

# Git Rules

* Use lowercase only.
* Use `-` for multiple words in branch names.
* Keep branch names short and descriptive.
* Do not include developer names.
* One branch should represent one task only.
* Do not work directly on `main`.
* Do not work directly on another developer's feature branch.
* Delete merged branches after the Pull Request is merged.
* Keep commits small and meaningful.
* Do not commit generated files unnecessarily.
* Run tests before creating a Pull Request.

---

# Home Branch Examples

Main Home branch:

```text
feature/home
```

Specific Home tasks:

```text
feature/home-search
feature/home-occasion
feature/home-categories
feature/home-best-seller
feature/home-product-details
```

Bug fixes:

```text
bugfix/home-search
bugfix/home-loading
bugfix/home-product-details
```

Refactoring:

```text
refactor/home-repository
refactor/home-cubit
refactor/home-data-source
```

Testing:

```text
test/home
test/home-use-cases
test/home-repository
```

---

# Commit Convention

Use:

```text
<type>: <description>
```

Examples:

```text
feat: implement home api client
feat: add home entities
feat: implement home repository
feat: add home use cases
feat: implement home cubit
feat: add home ui

test: add home entity tests
test: add home repository tests
test: add home use case tests

fix: handle home api error
fix: fix home loading state

refactor: improve home repository
refactor: simplify home cubit

chore: update home dependencies
```

---

# Pull Request Checklist

Before creating the PR:

* [ ] Code follows Clean Architecture.
* [ ] Naming conventions are followed.
* [ ] DTOs are separated from Entities.
* [ ] Repository interface is inside `domain`.
* [ ] Repository implementation is inside `data`.
* [ ] API client is inside `api`.
* [ ] Use Cases are implemented.
* [ ] Cubit states are handled.
* [ ] Loading state is handled.
* [ ] Success state is handled.
* [ ] Error state is handled.
* [ ] Unit tests are added where required.
* [ ] `flutter analyze` passes.
* [ ] `flutter test` passes.
* [ ] No unnecessary files are committed.
* [ ] No developer name is included in the branch name.
* [ ] PR description clearly explains the changes.

---

# Final Home Feature Flow

```text
UI
 ↓
Cubit
 ↓
Use Case
 ↓
Repository Interface
 ↓
Repository Implementation
 ↓
Data Source
 ↓
API Client
 ↓
Backend API
```

For responses:

```text
Backend Response
 ↓
Response DTO
 ↓
Entity
 ↓
Use Case
 ↓
Cubit
 ↓
UI
```

For requests:

```text
UI / Cubit
 ↓
Use Case
 ↓
Repository
 ↓
Request DTO
 ↓
Remote Data Source
 ↓
API Client
 ↓
Backend API
```

---

# Important

Do not create additional layers or folders unless they are actually needed.

The current Home feature should remain consistent with the existing Auth feature architecture.

The `mapper` layer is intentionally not included.

---

# Home Feature Target

The final goal is to have a Home feature that is:

* Clean Architecture compliant
* Easy to test
* Easy to maintain
* Easy to extend
* Consistent with the Auth feature
* Properly separated into Presentation, Domain, Data, and API
* Using clear Git branches and commit messages
