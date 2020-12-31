class ShipSprite < Sprite
    attr_accessor :num_tiles

    def initialize x, y
      self.x = x
      self.y = y
      self.w = 57
      self.h = 36
      self.path = 'sprites/bat-sheet.png'
      self.tile_x = 0
      self.tile_y = 0
      self.tile_w = 57
      self.tile_h = 36
      self.num_tiles = 3
    end
end

class Ship < Entity
    def initialize x, y
        super(ShipSprite.new(x, y), 12)
        self.direction = :up_right
    end
end
