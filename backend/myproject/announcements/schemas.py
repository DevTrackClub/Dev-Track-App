from ninja import Schema
from typing import Optional
from datetime import datetime


class PostSchema(Schema):
    id: int
    title: str
    description: str
    created_at: datetime
    created_by: int

    @classmethod
    def from_orm(cls, obj):
        return cls(
            id=obj.id,
            title=obj.title,
            description=obj.description,
            created_at=obj.created_at,
            created_by=obj.created_by.id,
        )

class PostCreateSchema(Schema):
    title: str
    description: Optional[str] = ""

class PostUpdateSchema(Schema):
    title: Optional[str] = None
    description: Optional[str] = None
