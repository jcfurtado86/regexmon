import pygame
import config
from game_state import GameState


from game import Game
from menu import Menu

pygame.init()


screen = pygame.display.set_mode((config.SCREEN_WIDTH, config.SCREEN_HEIGHT))

pygame.display.set_caption("Regexmon Game")

#adiciona o frame rate
clock = pygame.time.Clock()

game = Game(screen)

menu = Menu(screen, game)
menu.set_up()

#handle menus
while game.game_state != GameState.ENDED:
    #controla o frame rate
    clock.tick(50)

    if game.game_state == GameState.NONE:
        menu.update()

    if game.game_state == GameState.RUNNING:
        game.update()

    pygame.display.flip()
