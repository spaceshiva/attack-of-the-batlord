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

class Bat < Entity
    ANIMATION_INTERVAL=12

    def initialize x, y
        super(BatSprite.new(x, y), ANIMATION_INTERVAL)
        self.direction = :up_right
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

    def move d, speed 
        if d != self.entities[0].direction 
            @@move_history.append({d: d, x: self.entities[0].x, y: self.entities[0].y, idx: 0})
        end
        if self.entities.length() > 1
            bat_idx = 1
            while bat_idx < self.entities.length() do
                @@move_history.each do |h|
                    if bat_idx < h[idx] && h[x] == self.entities[bat_idx].x && h[y] == self.entities[bat_idx].y
                        self.entities[bat_idx].move(h[d], speed)
                        h[idx] += 1
                        break
                    end
                end
                bat_idx += 1
            end
        end
        # the first one always move in the given direction
        self.entities[0].move(d, speed)
    end

    def spawn tick_count
        if @@total_spawned == @@max_spawn 
            return
        end
        if tick_count - @@last_spawn >= 60 * @@spawn_interval
            last_entity = self.entities.last()
            x = last_entity.x - last_entity.w * MoveableEntity::DIR_CALC[last_entity.direction][0]
            y = last_entity.y - last_entity.h * MoveableEntity::DIR_CALC[last_entity.direction][1]
            self.entities.append(Bat.new(x, y))
            @@total_spawned += 1
            @@last_spawn = tick_count
        end
    end
end