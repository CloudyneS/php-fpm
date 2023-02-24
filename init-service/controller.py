"""Main controller for the init-service."""
    
import os, importlib
from dataclasses import dataclass


class Config:
    component_order: str
    
    def __init__(self, component_order, **args):
        self.config = {}
        self.component_order = component_order
        for key, value in args.items():
            setattr(self, key, value)
    
    def get(self, key, default=None):
        return getattr(self, key, default)
    
    @classmethod
    def from_env(cls):
        return cls(
            component_order=os.environ.get(
                'RUN_COMPONENTS', 
                "filesystem/Filesystem:run,database/Database:run,composer/Composer:run,wordpress/Wordpress:run"
            ).split(","),
            **dict(os.environ)
        )

    def run(self):
        for component in self.component_order:
            filename, classname = component.split("/")
            classname, function = classname.split(":")
            try:
                file = importlib.import_module(f"components.{filename}")
            except ModuleNotFoundError:
                raise Exception(f"Component {filename} not found")

            try:
                module = getattr(file, classname)
            except AttributeError:
                raise Exception(f"Class {classname} not found in {filename}")
            
            try:
                instance = module(self)
            except Exception as e:
                raise Exception(f"Could not run {classname}.__init__ in {filename}: {e}")

            try:
                func = getattr(instance, function)
            except Exception as e:
                raise Exception(f"Could not find {classname}.{function} in {filename}: {e}")
            
            func()
            

if __name__ == '__main__':
    # Load configuration
    config = Config.from_env()
    
    # Run initialization
    config.run()
    
    