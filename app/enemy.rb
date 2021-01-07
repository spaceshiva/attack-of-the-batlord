class BatSprite < Sprite
    W=57
    H=36
    def initialize x, y
      self.x = x
      self.y = y
      self.w = W
      self.h = H
      self.path = 'sprites/bat-sheet.png'
      self.tile_x = 0
      self.tile_y = 0
      self.tile_w = W
      self.tile_h = H
      self.num_tiles = 3
    end
end

class Bat < MoveableEntity
    ANIMATION_INTERVAL=12

    def initialize x, y
        super(BatSprite.new(x, y), ANIMATION_INTERVAL)
        self.mass = 300
        self.max_force = 5
        self.max_speed = 5
    end
end

class SnakedBat < CompositeEntity
    @@spawn_interval = 3
    @@last_spawn = 0
    @@move_history = []
    @@max_spawn = 3
    @@total_spawned = 0

    def initialize x, y, spawn_interval, max_spawn
        super([Bat.new(x, y)])
        @@max_spawn = max_spawn if max_spawn != nil
        @@spawn_interval = spawn_interval if spawn_interval != nil
        @@total_spawned = 1
    end

    def spawn tick_count
        if @@total_spawned == @@max_spawn 
            return
        end
        if tick_count - @@last_spawn >= 60 * @@spawn_interval
            last_entity = self.entities.last()
            x = last_entity.x - last_entity.w 
            y = last_entity.y - last_entity.h 
            self.entities.append(Bat.new(x, y))
            @@total_spawned += 1
            @@last_spawn = tick_count
        end
    end
end