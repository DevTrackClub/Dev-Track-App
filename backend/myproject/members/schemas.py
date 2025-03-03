from ninja import ModelSchema
from .models import CustomUser
from pydantic import BaseModel
from ninja import Schema



class SignInSchema(Schema):
    email: str
    password: str

    class Config:
        arbitrary_types_allowed = True

class RegisterSchema(ModelSchema):
    class Meta:
        model= CustomUser
        fields = [
            'email',
            'first_name',
            'last_name',
            'password',
            'srn',
        ]

    class Config:
        arbitrary_types_allowed = True

class LoginResponseSchema(Schema):
    message: str
    role: str
    csrf_token: str

    class Config:
        arbitrary_types_allowed = True

class UserProfileResponseSchema(Schema):
    username: str
    email: str
    github: str
    fname: str

    class Config:
        arbitrary_types_allowed = True
