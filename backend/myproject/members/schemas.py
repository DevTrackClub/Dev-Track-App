from ninja import ModelSchema
from .models import CustomUser
from pydantic import BaseModel
from ninja import Schema



class SignInSchema(BaseModel):
    email: str
    password: str

    model_config = {"arbitrary_types_allowed": True}


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

    model_config = {"arbitrary_types_allowed": True}

class LoginResponseSchema(Schema):
    message: str
    role: str
    csrf_token: str

    model_config = {
        "arbitrary_types_allowed": True,
    }


class UserProfileResponseSchema(Schema):
    username: str
    email: str
    github: str
    fname: str

    model_config = {"arbitrary_types_allowed": True}