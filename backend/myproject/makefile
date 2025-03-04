# Variables
MODE ?= local
path = "C:\Users\bhara\Desktop\Dev-Track-App\backend\myproject"

export DJANGO_ENV

# Echo color
GREEN = \033[0;32m
BLUE = \033[0;34m
YELLOW = \033[0;33m
NC = \033[0m

run:
	@echo "Running in $(DJANGO_ENV) mode"
	python manage.py runserver

prod:
	@echo "Switching to production mode..."
	@powershell -Command "(Get-Content .env) -replace '^DJANGO_ENV=.*', 'DJANGO_ENV=production' | Set-Content .env"

test:
	@echo "Switching to test mode..."
	@powershell -Command "(Get-Content .env) -replace '^DJANGO_ENV=.*', 'DJANGO_ENV=test' | Set-Content .env"


debug:
	APP_MODE=$(MODE) python -m debugpy --listen 5678 --wait-for-client manage.py runserver

mm:
	python manage.py makemigrations

migrate:
	python manage.py migrate

su:
	python manage.py createsuperuser


# collectstatic:
# 	APP_MODE=$(MODE) python manage.py collectstatic

clear_db:
	python -c "import os, glob; [os.remove(f) for f in glob.glob('**/migrations/*.py', recursive=True) if '__init__.py' not in f]"
	python -c "import os, glob; [os.remove(f) for f in glob.glob('**/migrations/*.pyc', recursive=True)]"

freeze:
	pip freeze > requirements.txt
