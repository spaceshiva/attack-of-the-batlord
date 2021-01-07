# screen bounds
BOUNDS={:top => 720, :right => 1280, :bottom => 0, :left => 0}

# Base class for all objects that can be inpected by GTK. Sub classes must implement `serialize`
class Inspectable
  def serialize
    
  end

  def inspect
    serialize.to_s
  end

  def to_s
    serialize.to_s
  end
end

# Base class for all Sprites of the game
class Sprite < Inspectable
  attr_sprite

  attr_accessor :num_tiles

  def primitive_marker
    :sprite
  end

  def serialize
    { x: @x, y: @y, w: @w, h: @h }
  end
end

# Base class for all Entities. An entity is not a sprite, but something we can move, animate, and interact within the game.
class Entity < Inspectable
  attr_accessor :animation_frames_interval, :sprite, :position

  def initialize sprite, anim_frames_interval
    self.sprite = sprite
    self.animation_frames_interval = anim_frames_interval
    self.position = [self.sprite.x, self.sprite.y]
    @last_frames_count = 0
    @actual_frame = 0
  end

  def serialize
    { sprite: @sprite, direction: @direction, last_frames_count: @last_frames_count, 
      actual_frame: @actual_frame,  animation_frames_interval: @animation_frames_interval }
  end

  def animate frames_count
    if @last_frames_count == 0
      @last_frames_count = frames_count
    end
    if frames_count - @last_frames_count >= @animation_frames_interval
      @last_frames_count = frames_count
      @actual_frame += 1
      if @actual_frame >= self.sprite.num_tiles
        @actual_frame = 0
      end
      self.sprite.tile_x = self.sprite.w * @actual_frame 
    end
  end

  def x
    self.sprite.x
  end

  def y
    self.sprite.y
  end

  def w
    self.sprite.w
  end

  def h
    self.sprite.h
  end

  def render outputs
    outputs.sprites << self.sprite
  end
end

# An entity tha can move
class MoveableEntity < Entity
  attr_accessor :steering, :velocity, :mass, :max_force, :max_speed, :slowing_distance
  
  SLOWING_DISTANCE=200

  def serialize
    { sprite: @sprite, steering: @steering, velocity: @velocity, mass: @mass, max_force: @max_force, max_speed: @max_speed }
  end

  def initialize sprite, anim_frames_interval
    super(sprite, anim_frames_interval)
    self.velocity = [0, 0]
    self.slowing_distance = SLOWING_DISTANCE
  end

  def seek(target)
    desired_velocity = Vectors::multiply_n(Vectors::normalize(Vectors::subtract(target, self.position)), self.max_speed)
    self.steering = Vectors::truncate(Vectors::subtract(desired_velocity, self.velocity), self.max_force)
    self.steering = Vectors::divide_n(self.steering, self.mass)
    self.move()
  end

  def flee(target)
    desired_velocity = Vectors::multiply_n(Vectors::normalize(Vectors::subtract(self.position, target)), self.max_speed)
    self.steering = Vectors::truncate(Vectors::subtract(desired_velocity, self.velocity), self.max_force)
    self.steering = Vectors::divide_n(self.steering, self.mass)
    self.move()
  end

  def arrival(target, slowing_distance=SLOWING_DISTANCE)
    desired_velocity = Vectors::subtract(target, self.position)
    distance = Vectors::mag(desired_velocity)
    if distance < self.slowing_distance
      desired_velocity = Vectors::multiply_n(Vectors::multiply_n(Vectors::normalize(desired_velocity), self.max_speed), (distance / self.slowing_distance))
    else
      desired_velocity = Vectors::multiply_n(Vectors::normalize(desired_velocity), self.max_speed)
    end
    self.steering = Vectors::subtract(desired_velocity, self.velocity)
    self.move()
  end

  def move()
    self.velocity = Vectors::truncate(Vectors::add(self.velocity, self.steering), self.max_speed)
    self.sprite.x += self.velocity[0] 
    self.sprite.y += self.velocity[1]
    self.position = [self.sprite.x, self.sprite.y]
  end
end

# Base class for composed entities. For example: you wish to control a group of entities to work on a similar manner.
# By default, x, y, w and h refers to the first entity within the composition. 
# Override these methods if needed.
class CompositeEntity < MoveableEntity
  attr_accessor :entities

  def initialize entities
    @entities=entities
  end

  def serialize
    { entities: @entities }
  end

  def animate frames_count
    @entities.each { |e| e.animate(frames_count) }
  end

  def x
    self.entities[0].x
  end

  def y
    self.entities[0].y
  end

  def w
    self.entities[0].w
  end

  def h
    self.entities[0].h
  end

  def render outputs
    self.entities.each { |e| e.render(outputs) }
  end
end