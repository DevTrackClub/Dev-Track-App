# Variables
MODE ?= local

# Echo color
GREEN = \033[0;32m
BLUE = \033[0;34m
YELLOW = \033[0;33m
NC = \033[0m

run:
	APP_MODE=$(MODE) python manage.py runserver

# fmt:
# 	black .

debug:
	APP_MODE=$(MODE) python -m debugpy --listen 5678 --wait-for-client manage.py runserver

mm:
	APP_MODE=$(MODE) python manage.py makemigrations

migrate:
	APP_MODE=$(MODE) python manage.py migrate

su:
	APP_MODE=$(MODE) python manage.py createsuperuser


# collectstatic:
# 	APP_MODE=$(MODE) python manage.py collectstatic

clear_db:
	find . -path "*/migrations/*.py" -not -name "__init__.py" -delete
	find . -path "*/migrations/*.pyc" -delete

freeze:
	pip freeze > requirements.txt
