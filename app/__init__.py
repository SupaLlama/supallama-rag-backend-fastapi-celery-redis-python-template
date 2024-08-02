from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.celery_utils import create_celery


def create_fastapi_app() -> FastAPI:
    """FastAPI Factory Function"""

    app = FastAPI()

    # Allow all origins for CORS (customize as needed) 
    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    #  Call Celery Factory function *BEFORE* loading routes
    app.celery_app = create_celery()

    # Load API routes
    # from app.routes.llm import llm_router
    # app.include_router(llm_router)

    @app.get("/ping")
    async def root():
        return {"message": "pong"}
    
    return app
