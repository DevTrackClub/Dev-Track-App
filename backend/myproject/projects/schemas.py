from ninja import ModelSchema
from pydantic import BaseModel, Field
from datetime import date, datetime
from ninja import Schema
from projects.models import ProjectModel, DomainModel


class CreateDomainSchema(Schema):
    name : str 
    description : str 


class ListDomainSchema(Schema):
    id : int 
    name : str


class ListProjectSchema(Schema):
    name : str 
    domain : str
    created_at : str


class CreateProjectSchema(Schema):
    name : str 
    domain_id : int  
    github_link : str 
    youtube_link : str 



class CreateProjectCycleSchema(Schema):
    cycle_name: str
    start_date: date
    end_date: date
    is_active: bool = Field(default=False)



class PCSchema(Schema):
    id: int
    cycle_name: str
    start_date: datetime
    end_date: datetime
    is_active: bool
    

class UpdateProjectCycleSchema(Schema):
    cycle_name: str
    start_date: datetime
    end_date: datetime
    is_active: bool

