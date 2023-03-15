import pygame
import config

class Player:
    def __init__(self, x_position, y_position):
        print("player created")
        self.position = [x_position, y_position]
        self.image = pygame.image.load("imgs/player.png")
        #ajustando o tamanho da imagem
        self.image = pygame.transform.scale(self.image, (config.SCALE, config.SCALE))
        self.rect = pygame.Rect(self.position[0] * config.SCALE, self.position[1] * config.SCALE, config.SCALE, config.SCALE)

    def update(self):
        print("player updated")

    #no python toda método numa classe deve passar ele msm, por isso o self
    def update_position(self, new_position):
        self.position[0] = new_position[0]
        self.position[1] = new_position[1]
        self.rect = pygame.Rect(self.position[0] * config.SCALE, self.position[1] * config.SCALE, config.SCALE,
                                config.SCALE)

    def render(self, screen, camera):
        self.rect = pygame.Rect(self.position[0] * config.SCALE, self.position[1] * config.SCALE - (camera[1] * config.SCALE), config.SCALE,
                                config.SCALE)
        screen.blit(self.image, self.rect)
        #desenho do retângulo
        # pygame.draw.rect(screen, config.WHITE, (self.position[0] * config.SCALE, self.position[1] * config.SCALE, config.SCALE, config.SCALE), 4)