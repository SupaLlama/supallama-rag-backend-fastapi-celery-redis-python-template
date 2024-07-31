from fastapi import FastAPI


def create_fastapi_app() -> FastAPI:
    """FastAPI Factory Function"""

    app = FastAPI()

    @app.get("/ping")
    async def root():
        return {"message": "pong"}
    
    return app
