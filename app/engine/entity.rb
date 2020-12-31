# possible directions for an entity to move
DIRECTIONS=[:up, :down, :left, :right, :up_left, :up_right, :down_left, :down_right]
# screen bounds
BOUNDS={:top => 720, :right => 1280, :bottom => 0, :left => 0}

# Base class for all Sprites of the game
class Sprite
  attr_accessor :x, :y, :w, :h, :path, :angle, :a, :r, :g, :b,
  :source_x, :source_y, :source_w, :source_h,
  :tile_x, :tile_y, :tile_w, :tile_h,
  :flip_horizontally, :flip_vertically,
  :angle_anchor_x, :angle_anchor_y

  def primitive_marker
    :sprite
  end

  def serialize
    { x: @x, y: @y, w: @w, h: @h }
  end

  def inspect
    serialize.to_s
  end

  def to_s
    serialize.to_s
  end
end

# Base class for all Entities. An entity is not a sprite, but something we can move, animate, and interact within the game.
class Entity
  attr_accessor :sprite, :direction, :animation_frames_interval

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

  def initialize sprite, anim_frames_interval
    self.sprite = sprite
    self.animation_frames_interval = anim_frames_interval
    @last_frames_count = 0
    @actual_frame = 0
  end

  def serialize
    { sprite: @sprite, direction: @direction, last_frames_count: @last_frames_count, 
      actual_frame: @actual_frame,  animation_frames_interval: @animation_frames_interval }
  end

  def inspect
    serialize.to_s
  end

  def to_s
    serialize.to_s
  end

  def moving_right?
    @direction == :right || @direction == :up_right || @direction == :down_right
  end

  def moving_left?
    @direction == :left || @direction == :up_left || @direction == :down_left
  end

  def moving_up?
    @direction == :up || @direction == :up_left || @direction == :up_right
  end

  def moving_down?
    @direction == :down || @direction == :down_right || @direction == :down_left
  end

  # moves the sprite to the given direction and speed
  def move d, speed
    @direction = d
    self.sprite.x += DIR_CALC[d][0] * speed
    self.sprite.y += DIR_CALC[d][1] * speed
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
end
