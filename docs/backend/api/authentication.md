# Authentication Documentation

## Overview

The authentication system in **Dev-Track-App** is based on **token-based authentication with Bearer tokens**. Users authenticate using a **custom user model** and receive a token upon login, which must be included in API requests.

---

## Authentication Mechanism

### 1. Authentication Type

- The project uses **token-based authentication with Bearer tokens**.
- API requests must include an `Authorization` header in the following format:

  ```http
  Authorization: Bearer <TOKEN>
  ```

### 2. Custom User Model

- The default Django `User` model is replaced with a custom model in the `members` app.
- Configured in `settings.py`:

  ```python
  AUTH_USER_MODEL = 'members.CustomUser'
  ```

- User authentication and management are handled via `CustomUser`.

### 3. Password Validation

- Passwords must comply with Django’s validation rules (`AUTH_PASSWORD_VALIDATORS` in `settings.py`).

### 4. Token-Based Authentication

- Users log in with credentials (email/password or username/password).
- Upon successful authentication, a **token is generated and returned**.
- The token must be included in subsequent API requests.

### 5. Django REST Framework (DRF) Integration

- The project uses DRF’s authentication system:

  ```python
  REST_FRAMEWORK = {
      'DEFAULT_AUTHENTICATION_CLASSES': (
          'rest_framework.authentication.TokenAuthentication',
          'rest_framework.authentication.SessionAuthentication',
      ),
  }
  ```

- The `TokenAuthentication` class enables **token-based authentication**.
- `SessionAuthentication` allows authentication for web-based sessions.

---

## Authentication Components

### 1. Session ID

- Django uses **Session IDs** to track user sessions in `SessionAuthentication`.
- The session ID is stored in the database and linked to a user.
- Session-based authentication allows users to stay logged in while interacting with the web application.

### 2. Cookies

- **Session cookies** store session IDs when users log in via web-based authentication.
- Cookies are used for maintaining authenticated sessions in browsers.
- Django’s `SESSION_COOKIE_SECURE = True` ensures cookies are transmitted securely over HTTPS.

### 3. Session Token ID

- The **Session Token ID** is a unique identifier for an authenticated user’s session.
- It is used to validate active sessions and ensure continuity.
- Token IDs are stored in the backend and referenced in API requests.

### 4. CSRF Token

- Django enforces **Cross-Site Request Forgery (CSRF) protection**.
- CSRF tokens are required for all **state-changing requests (POST, PUT, DELETE)**.
- Tokens are included in forms and validated against session cookies.

### 5. Admin-Based Authentication

- Some endpoints are **restricted to registered admin users**.
- Admin authentication is based on **predefined admin IDs** in the database.
- Only users with admin privileges can access protected routes.
- Admin users authenticate the same way as regular users but have elevated permissions.

---

## API Endpoints

### 1. User Registration

- **Endpoint:** `/api/auth/register/`
- **Method:** `POST`
- **Request Body:**

  ```json
  {
    "username": "john_doe",
    "email": "user1@gmail.com",
    "password": "test@123"
  }
  ```

- **Response:**

  ```json
  {
    "message": "User registered successfully",
    "user_id": 1
  }
  ```

### 2. User Login

- **Endpoint:** `/api/auth/login/`
- **Method:** `POST`
- **Request Body:**

  ```json
  {
    "username": "user1@gmail.com",
    "password": "test@123"
  }
  ```

- **Response:**

  ```json
  {
    "token": "abc123xyz456"
  }
  ```

### 3. Accessing Protected API Endpoints

- **Include the token in the request header:**

  ```http
  GET /api/protected-endpoint/
  Authorization: Bearer abc123xyz456
  ```

### 4. Logging Out

- **Endpoint:** `/api/auth/logout/`
- **Method:** `POST`
- **Action:** Invalidates the token.

---

## Authentication APIs

### UserAuthAPI Class

- Handles user authentication-related API calls using the Django Ninja framework.

### Login Endpoint

- **Endpoint:** `/user/login`
- **Method:** `POST`
- **Functionality:** Authenticates users based on provided credentials (username and password). Calls `login_user` from `UserAuthService`. Returns an authentication token on success. Responds with `401 Unauthorized` for invalid credentials.

### Logout Endpoint

- **Endpoint:** `/user/logout`
- **Method:** `POST`
- **Functionality:** Logs out the authenticated user. Calls `logout_user` from `UserAuthService`.

### User Profile Endpoint

- **Endpoint:** `/user`
- **Method:** `GET`
- **Functionality:** Retrieves authenticated user's profile. Calls `get_user_profile` from `UserAuthService`. Responds with `401 Unauthorized` if the user is not logged in.

### Edit Profile Endpoint

- **Endpoint:** `/user/edit`
- **Method:** `PUT`
- **Functionality:** Allows authenticated users to update profile details. Calls `edit_user_profile` from `UserAuthService`.

### Import Users Endpoint

- **Endpoint:** `/user/import-users/`
- **Method:** `POST`
- **Functionality:** Enables bulk user import from a file using a management command. The `import_users` method handles the file upload.

---

## Authentication System Overview

- Implements token-based authentication using **Bearer tokens**.
- Uses a custom user model (`CustomUser`) for user management.
- Authentication-related business logic is encapsulated within `UserAuthService`.
- **CSRF protection** enforced for state-changing requests.
