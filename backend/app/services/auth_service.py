from bson import ObjectId
from datetime import datetime
from fastapi import HTTPException, status
from app.db.session import get_database
from app.core.security import get_password_hash, verify_password, create_access_token
from app.schemas.user_schema import UserCreate, UserLogin
from app.schemas.portfolio_schema import PortfolioBase

async def register_user(user_in: UserCreate):
    db = get_database()
    users_collection = db["users"]
    
    # Check if user exists
    user = await users_collection.find_one({"email": user_in.email})
    if user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="User with this email already exists"
        )
    
    user_dict = user_in.dict()
    user_dict["hashed_password"] = get_password_hash(user_dict.pop("password"))
    user_dict["created_at"] = datetime.utcnow()
    
    result = await users_collection.insert_one(user_dict)
    user_id = str(result.inserted_id)
    
    # Initialize Portfolio
    portfolios_collection = db["portfolios"]
    await portfolios_collection.insert_one({
        "user_id": user_id,
        "balance": 100000.0,
        "holdings": []
    })
    
    user_dict["_id"] = user_id
    return user_dict

async def authenticate_user(user_in: UserLogin):
    db = get_database()
    user = await db["users"].find_one({"email": user_in.email})
    if not user:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Incorrect email or password")
    if not verify_password(user_in.password, user["hashed_password"]):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Incorrect email or password")
    
    user["_id"] = str(user["_id"])
    return user

async def get_user_by_id(user_id: str):
    db = get_database()
    user = await db["users"].find_one({"_id": ObjectId(user_id)})
    if user:
        user["_id"] = str(user["_id"])
    return user
