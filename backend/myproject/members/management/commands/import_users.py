import csv
import os
from django.core.management.base import BaseCommand
from members.models import CustomUser  
from django.contrib.auth.hashers import make_password
from django.utils.text import slugify

class Command(BaseCommand):
    help = "Import users from a CSV file and create them in the database"

    def add_arguments(self, parser):
        parser.add_argument("file_path", type=str, help="Path to the CSV file")

    def generate_unique_username(self, email):
        """Generate a unique username based on email."""
        base_username = slugify(email.split('@')[0])  # Convert to a slug
        username = base_username
        counter = 1

        while CustomUser.objects.filter(username=username).exists():
            username = f"{base_username}{counter}"
            counter += 1

        return username

    def handle(self, *args, **kwargs):
        file_path = kwargs["file_path"]
        users_created = 0
        skipped_users = 0

        try:
            with open(file_path, newline='', encoding='utf-8') as csvfile:
                reader = csv.DictReader(csvfile)

                for row in reader:
                    email = row.get("email", "").strip()
                    
                    # Check if user already exists
                    if CustomUser.objects.filter(email=email).exists():
                        print(f"Skipping {email} (User already exists)")
                        skipped_users += 1
                        continue

                    print(f"Creating user: {email}")

                    # Ensure unique username
                    username = row.get("username", "").strip()
                    if not username:
                        username = self.generate_unique_username(email)

                    # Create new user
                    user = CustomUser(
                        email=email,
                        username=username,
                        first_name=row.get("first_name", "").strip(),
                        last_name=row.get("last_name", "").strip(),
                        phone=row.get("phone", "").strip(),
                        srn=row.get("srn", "").strip(),
                        branch=row.get("branch", "").strip(),
                        semester=row.get("semester", "1").strip(),
                        github=row.get("github", "").strip(),
                        linkedin=row.get("linkedin", "").strip(),
                        role="student",
                    )
                    
                    user.set_password("test@123")  # Set default password

                    print(f"Saving user: {user.email}")
                    try:
                        user.save()
                        print(f"User {user.email} saved successfully!")
                        users_created += 1
                        self.stdout.write(self.style.SUCCESS(f"User {email} created successfully!"))
                    except Exception as e:
                        print(f"Error saving user {user.email}: {e}")

        except FileNotFoundError:
            self.stderr.write(self.style.ERROR(f"File {file_path} not found!"))
            return
        
        self.stdout.write(self.style.SUCCESS(f"Import completed: {users_created} new users, {skipped_users} skipped."))
