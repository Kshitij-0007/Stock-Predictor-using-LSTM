import asyncio
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.v1 import auth_routes, trading_routes, portfolio_routes, market_routes, prediction_routes, analytics_routes
from app.core.config import settings
from app.db.session import connect_to_mongo, close_mongo_connection
from app.api.v1.market_routes import stream_market_data

# Use modern lifespan context manager for startup/shutdown events
from contextlib import asynccontextmanager

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup actions
    await connect_to_mongo()
    # Execute the mock market stream as a background asyncio task
    asyncio.create_task(stream_market_data())
    yield
    # Shutdown actions
    await close_mongo_connection()

app = FastAPI(
    title=settings.PROJECT_NAME,
    openapi_url=f"{settings.API_V1_STR}/openapi.json",
    lifespan=lifespan
)

if settings.BACKEND_CORS_ORIGINS:
    app.add_middleware(
        CORSMiddleware,
        allow_origins=[str(origin) for origin in settings.BACKEND_CORS_ORIGINS],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

app.include_router(auth_routes.router, prefix=f"{settings.API_V1_STR}/auth", tags=["auth"])
app.include_router(trading_routes.router, prefix=f"{settings.API_V1_STR}/trading", tags=["trading"])
app.include_router(portfolio_routes.router, prefix=f"{settings.API_V1_STR}/portfolio", tags=["portfolio"])
app.include_router(market_routes.router, prefix=f"{settings.API_V1_STR}/market", tags=["market"])
app.include_router(prediction_routes.router, prefix=f"{settings.API_V1_STR}/prediction", tags=["prediction"])
app.include_router(analytics_routes.router, prefix=f"{settings.API_V1_STR}/analytics", tags=["analytics"])

@app.get("/")
def root():
    # Model reloaded at: 2026-04-17T12:08:45
    return {"message": "Welcome to the AI Stock Trading Platform API"}
