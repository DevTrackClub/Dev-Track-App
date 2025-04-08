from ninja import Schema
from typing import Optional

class ProjectApplicationSchema(Schema):
    first_preference_id: int
    second_preference_id: int
