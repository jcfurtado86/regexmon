import configmonster

import utilities
import config
from monster import Monster

class MonsterFactory:
    def __init__(self):
        self.count = 0

    def create_monster(self, monster_type):
        random_number = -1
        if monster_type == "G":
            random_number = utilities.generate_random_number(configmonster.GRASS_TYPE_START, configmonster.GRASS_TYPE_END)
        print(random_number)

        monster = Monster(monster_type, random_number)
        self.count = self.count + 1

        return monster

