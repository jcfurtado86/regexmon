#enum: usa sintaxe de índice para retornar membros por nome
from enum import Enum

class GameState(Enum):
    NONE = 0,
    RUNNING = 1,
    ENDED = 2

class CurrentGameState(Enum):
    MAP = 0,
    BATTLE = 1