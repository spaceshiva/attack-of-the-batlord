# possible directions for an entity to move
DIRECTIONS=[:up, :down, :left, :right, :up_left, :up_right, :down_left, :down_right]
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

# An entity tha can move
class MoveableEntity < Inspectable
  attr_accessor :sprite, :direction

  DIR_CALC={
    :up => [0, 1],
    :down => [0, -1],
    :left => [-1, 0],
    :right => [1, 0],
    :up_right => [1, 1],
    :up_left => [-1, 1],
    :down_right => [1, -1],
    :down_left => [-1, -1]
  }

  def serialize
    { sprite: @sprite, direction: @direction }
  end

  def initialize sprite
    self.sprite = sprite
  end

  def moving_right?
    self.direction == :right || self.direction == :up_right || self.direction == :down_right
  end

  def moving_left?
    self.direction == :left || self.direction == :up_left || self.direction == :down_left
  end

  def moving_up?
    self.direction == :up || self.direction == :up_left || self.direction == :up_right
  end

  def moving_down?
    self.direction == :down || self.direction == :down_right || self.direction == :down_left
  end

  # moves the sprite to the given direction and speed
  def move d, speed
    self.direction = d
    self.sprite.x += DIR_CALC[d][0] * speed
    self.sprite.y += DIR_CALC[d][1] * speed
  end
end

# Base class for all Entities. An entity is not a sprite, but something we can move, animate, and interact within the game.
class Entity < MoveableEntity
  attr_accessor :animation_frames_interval

  def initialize sprite, anim_frames_interval
    super(sprite)
    self.animation_frames_interval = anim_frames_interval
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

  def move d, speed
    @entities.each { |e| e.move(d, speed) }
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

  def direction
    self.entities[0].direction
  end

  def render outputs
    self.entities.each { |e| e.render(outputs) }
  end
end