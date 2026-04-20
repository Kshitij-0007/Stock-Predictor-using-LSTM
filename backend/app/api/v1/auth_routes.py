from fastapi import APIRouter, Depends
from fastapi.security import OAuth2PasswordRequestForm
from app.schemas.user_schema import UserCreate, UserResponse, Token
from app.services.auth_service import register_user, authenticate_user
from app.core.security import create_access_token

router = APIRouter()

@router.post("/register", response_model=UserResponse)
async def register(user_in: UserCreate):
    return await register_user(user_in)

@router.post("/login", response_model=Token)
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    from app.schemas.user_schema import UserLogin
    user = await authenticate_user(UserLogin(email=form_data.username, password=form_data.password))
    
    access_token = create_access_token(subject=user["_id"])
    return {"access_token": access_token, "token_type": "bearer"}
