# API Overview

## Introduction

This document provides an overview of all the APIs available in the **Dev-Track-App**. Each API is categorized based on its functionality, including authentication, user management, events, notifications, file uploads, AI-powered chatbot interactions, and third-party integrations.

---

## **Projects API**

### **Endpoints**

- **POST** `/projects/domain/create` → `Create domain`
- **GET** `/projects/domains/list` → `List domains`
- **POST** `/projects/cycle/create` → `Create project cycle`
- **POST** `/projects/create` → `Create project` _(commented out)_
- **GET** `/projects/list` → `List projects` _(commented out)_

---

## **Posts API**

### **Endpoints**

- **POST** `/posts/add` → `Add Post`
- **GET** `/posts/` → `List Posts`
- **PUT** `/posts/{post_id}` → `Update Post`
- **DELETE** `/posts/{post_id}` → `Delete Post`

---

## **User Authentication API**

### **Endpoints**

- **POST** `/user/login` → `User login`
- **POST** `/user/logout` → `User logout`
- **GET** `/user/user` → `User profile`
- **PUT** `/user/edit` → `Edit profile`
- **POST** `/user/import-users/` → `Import Users`

---

## **Project Applications API**

### **Endpoints**

- **POST** `/applications/enroll` → `Enroll in Project`
