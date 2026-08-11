# Flutter Clean Architecture Naming Convention

## General Rules

* Use `snake_case` for all file and folder names.
* Every file name must start with the **feature name**.
* Keep names short, descriptive, and consistent.
* Avoid abbreviations unless they are well known.

---

# API Layer

| Type          | Naming Pattern                 | Example                   |
| ------------- | ------------------------------ | ------------------------- |
| API Client    | `<feature>_api_client.dart`    | `auth_api_client.dart`    |


## Data Source Implemenation

| Type                      | Naming Pattern                   | Example                     |
| ------------------------- | -------------------------------- | --------------------------- |
| Repository Implementation | `<feature>_data_source_impl.dart` | `auth_data_source_impl.dart` |


---------------------------------------------------------------

# Data Layer

## Models

| Type     | Naming Pattern            | Example               |
| -------- | ------------------------- | --------------------- |
| DTO    | `<feature>_dto.dart`    | `auth_dto.dart`     |
| Request  | `<feature>_request.dart`  | `login_request.dart`  |
| Response | `<feature>_response.dart` | `login_response.dart` |

## Data Sources

| Type               | Naming Pattern                      | Example                        |
| ------------------ | ----------------------------------- | ------------------------------ |
| Remote Data Source | `<feature>_remote_data_source.dart` | `auth_remote_data_source.dart` |
| Local Data Source  | `<feature>_local_data_source.dart`  | `auth_local_data_source.dart`  |



## Repository Implemenation

| Type                      | Naming Pattern                   | Example                     |
| ------------------------- | -------------------------------- | --------------------------- |
| Repository Implementation | `<feature>_repo_impl.dart` | `auth_repo_impl.dart` |


---------------------------------------------------------------

# Domain Layer

## Entity

| Type   | Naming Pattern          | Example            |
| ------ | ----------------------- | ------------------ |
| Entity | `<feature>_entity.dart` | `auth_entity.dart` |

## Repository

| Type       | Naming Pattern              | Example                |
| ---------- | --------------------------- | ---------------------- |
| Repository | `<feature>_repo.dart` | `auth_repo.dart` |


## Use Cases

Use Cases should always start with an action (Verb).

| Pattern                            | Example                        |
| ---------------------------------- | ------------------------------ |
| `<action>_<feature>_use_case.dart` | `login_auth_use_case.dart`     |
|                                    | `register_auth_use_case.dart`  |
|                                    | `logout_auth_use_case.dart`    |
|                                    | `get_profile_use_case.dart`    |
|                                    | `update_profile_use_case.dart` |
|                                    | `get_subjects_use_case.dart`   |


---------------------------------------------------------------

# Presentation Layer

## Manager

| Type  | Naming Pattern         | Example           |
| ----- | ---------------------- | ----------------- |
| Cubit | `<feature>_cubit.dart` | `auth_cubit.dart` |
| State | `<feature>_state.dart` | `auth_state.dart` |
| Event | `<feature>_event.dart` | `auth_event.dart` |

## View

| Type         | Naming Pattern                | Example                      |
| ------------ | ----------------------------- | ---------------------------- |
| View         | `<feature>_view.dart`         | `login_view.dart`            |
| Widget       | `<feature>_widget.dart`       | `login_widget.dart`          |
| Dialog       | `<feature>_dialog.dart`       | `delete_account_dialog.dart` |
| Bottom Sheet | `<feature>_bottom_sheet.dart` | `filter_bottom_sheet.dart`   |


---------------------------------------------------------------

# Folder Naming

Use lowercase with snake_case.

Example:

```
auth/
profile/
home/
subjects/
exams/
```

---

# Constants

```
api_strings.dart
app_colors.dart
app_assets.dart
app_images.dart
app_icons.dart
app_routes.dart
app_strings.dart
app_text_styles.dart
```

---

# Extensions

```
string_extensions.dart
context_extensions.dart
date_extensions.dart
widget_extensions.dart
```

---

# Utilities

```
validators.dart
helpers.dart
formatters.dart
exceptions.dart
failure.dart
```

---

# Naming Summary
| Item         | Pattern                            |
| ------------ | ---------------------------------- |
| Feature File | `<feature>_<type>.dart`            |
| Use Case     | `<action>_<feature>_use_case.dart` |
| Folder       | `snake_case`                       |
| Class        | `PascalCase`                       |
| Variable     | `camelCase`                        |
| Method       | `camelCase`                        |
| Constant     | `camelCase` (use `const`)          |

---

## Examples

```
auth_repository.dart
auth_repository_impl.dart
auth_remote_data_source.dart
auth_local_data_source.dart
auth_api_client.dart
auth_model.dart
auth_entity.dart
auth_mapper.dart
auth_cubit.dart
auth_state.dart
auth_event.dart
login_auth_use_case.dart
register_auth_use_case.dart
login_screen.dart
login_view.dart
login_widget.dart
```

Following this convention ensures consistency, readability, and maintainability across the project.
