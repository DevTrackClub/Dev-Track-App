# Dev-Track-App


# ProjectX Dashboard Application

## Table of Contents

1.  [Project Overview](#project-overview)
2.  [Features](#features)
3.  [Tech Stack](#tech-stack)
4.  [Requirements](#requirements)
5.  [Installation](#installation)
6.  [Running the Application](#running-the-application)
7.  [Directory Structure](#directory-structure)
8.  [API Documentation](#api-documentation)
9.  [Contribution Guidelines](#contribution-guidelines)
10.  [Contact Information](#contact-information)
11.  [License](#license)

## Project Overview

ProjectX Dashboard Application is designed to streamline the enrollment process for project cycles, manage deadlines, and provide features for both students and management of the Dev Track Club at Raywaun University.

## Features

-   User authentication (student and management views)
-   Announcements management
-   Project application and tracking
-   Weekly progress updates
-   Scrum meeting scheduling
-   Submissions tracking

## Tech Stack

-   **Backend:** Django, Django Ninja
-   **Frontend:** Flutter
-   **Database:** SQLite (development), PostgreSQL (production)

## Requirements

-   Python 3.8+
-   Django 3.2+
-   Flutter 2.0+
-   Node.js (for frontend dependencies)

## Installation

### Backend

1.  **Clone the Repository:**

    `git clone https://github.com/yourusername/projectx.git
    cd projectx` 
    
2.  **Create a Virtual Environment:**
 
    ``python -m venv venv
    source venv/bin/activate  # On Windows use `venv\Scripts\activate` `` 
    
3.  **Install Dependencies:**
 
    `pip install -r requirements.txt` 
    
4.  **Set Up Environment Variables:**
    
    Create a `.env` file in the project root and add the following:
    
    env
 
    `DEBUG=True
    SECRET_KEY=your_secret_key
    DATABASE_URL=your_database_url` 
    
5.  **Apply Migrations:**

    `python manage.py migrate` 
    
6.  **Create a Superuser:**
 
    `python manage.py createsuperuser` 
    

### Frontend

1.  **Install Flutter:**
    
    Follow the official Flutter installation guide here.
    
2.  **Navigate to the Flutter Directory:**
    
    `cd projectx_flutter` 
    
3.  **Install Dependencies:**

    `flutter pub get` 
    

## Running the Application

### Backend

1.  **Start the Development Server:**
   
    `python manage.py runserver` 
    
2.  **Access the Admin Panel:**
    
    Navigate to `http://127.0.0.1:8000/admin` and log in with the superuser credentials.
    

### Frontend

1.  **Run the Flutter Application:**
    
    `flutter run` 
    
2.  **Specify the Target Device:**
    
    You can run the app on a connected device or emulator.
    

## Directory Structure

....

## API Documentation

Detailed API documentation is generated using Django Ninja. Access the API docs at `http://127.0.0.1:8000/api/docs` after starting the development server.

## Contribution Guidelines

We welcome contributions from the community. To contribute, please follow these steps:

1.  **Fork the Repository:**
    
    Click on the "Fork" button at the top right corner of the repository page.
    
2.  **Clone the Forked Repository:**
    
    `git clone https://github.com/yourusername/projectx.git
    cd projectx` 
    
3.  **Create a New Branch:**
    
    `git checkout -b feature/your-feature-name` 
    
4.  **Make Changes and Commit:**
    
    `git add .
    git commit -m "Add your commit message"` 
    
5.  **Push to Your Forked Repository:**
    
    `git push origin feature/your-feature-name` 
    
6.  **Create a Pull Request:**
    
    Open a pull request from your forked repository to the main repository.
    

## Contact Information

For any queries or support, please contact:

-   **Project Maintainer:** Your Name
-   **Email:** your-email@example.com
-   **GitHub:** [yourusername](https://github.com/yourusername)

## License

This project is licensed under the MIT License. See the LICENSE file for details.
