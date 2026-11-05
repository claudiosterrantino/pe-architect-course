from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Dict
import uuid
from datetime import datetime

app = FastAPI(
    title="Teams API",
    description="A simple API for team leads to create and manage teams",
    version="1.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# La sintassi definisce un dizionario in memoria chiamato teams_store che viene utilizzato per memorizzare le informazioni sulle squadre (teams) create tramite l'API.
# In-memory storage
teams_store: Dict[str, Dict] = {}

# Pydantic models
class TeamCreate(BaseModel):
    name: str

# Questa sintassi viene utilizzata per definire un modello di dati che rappresenta una squadra (team) con un solo attributo, il nome della squadra. 
# Il modello TeamCreate eredita da BaseModel di Pydantic, che fornisce funzionalità di validazione dei dati e serializzazione. 
# In questo caso, il modello TeamCreate viene utilizzato per ricevere i dati di input quando si crea una nuova squadra tramite l'API.
class Team(BaseModel):
    id: str
    name: str
    created_at: datetime

@app.get("/")
async def root():
    return {"message": "Teams API is running"}

@app.post("/teams", response_model=Team)
async def create_team(team: TeamCreate):
    """Create a new team"""
    # Check if team name already exists
    for existing_team in teams_store.values():
        if existing_team["name"].lower() == team.name.lower():
            raise HTTPException(status_code=400, detail="Team name already exists")

    # Generate unique ID and create team
    team_id = str(uuid.uuid4())
    new_team = {
        "id": team_id,
        "name": team.name,
        "created_at": datetime.now()
    }

    # Aggiunge il nuovo team al dizionario teams_store utilizzando l'ID univoco generato come chiave. 
    # In questo modo, il team appena creato viene memorizzato in memoria e può essere recuperato successivamente tramite le API.
    teams_store[team_id] = new_team
    return Team(**new_team)

@app.get("/teams", response_model=List[Team])
async def get_teams():
    """Get all teams"""
    # Avendo definito il response_model come List[Team], FastAPI si aspetta che la funzione restituisca una lista di oggetti Team.
    # La sintassi list(teams_store.values()) è molto più pulita e converte i valori del dizionario teams_store in una lista, che viene poi restituita come risposta all'endpoint GET /teams.
    #return [Team(**team) for team in teams_store.values()]
    return list(teams_store.values())

@app.get("/teams/{team_id}", response_model=Team)
async def get_team(team_id: str):
    """Get a specific team by ID"""
    if team_id not in teams_store:
        raise HTTPException(status_code=404, detail="Team not found")

    #return Team(**teams_store[team_id])
    return teams_store[team_id]

@app.delete("/teams/{team_id}")
async def delete_team(team_id: str):
    """Delete a team"""
    if team_id not in teams_store:
        raise HTTPException(status_code=404, detail="Team not found")

    deleted_team = teams_store.pop(team_id)
    return {"message": f"Team '{deleted_team['name']}' deleted successfully"}

@app.get("/health")
async def health_check():
    """Health check endpoint for Kubernetes"""
    return {"status": "healthy", "teams_count": len(teams_store)}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
