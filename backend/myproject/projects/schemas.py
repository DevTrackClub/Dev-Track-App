from ninja import ModelSchema
from pydantic import BaseModel, Field
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
    cycle_name : str
    start_date : str 
    end_date : str 
    is_active : bool = Field(default=False)


