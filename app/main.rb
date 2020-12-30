DIRECTIONS=[:up, :down, :left, :right, :up_left, :up_right, :down_left, :down_right]
BOUNDS={:top => 720, :right => 1280, :bottom => 0, :left => 0}

class Sprite
  attr_accessor :x, :y, :w, :h, :path, :angle, :a, :r, :g, :b,
  :source_x, :source_y, :source_w, :source_h,
  :tile_x, :tile_y, :tile_w, :tile_h,
  :flip_horizontally, :flip_vertically,
  :angle_anchor_x, :angle_anchor_y

  attr_writer :direction

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

  def primitive_marker
    :sprite
  end

  def serialize
    { x: @x, y: @y, w: @w, h: @h, direction: @direction }
  end

  def inspect
    serialize.to_s
  end

  def to_s
    serialize.to_s
  end
  
  def direction
    @direction 
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
    self.x += DIR_CALC[d][0] * speed
    self.y += DIR_CALC[d][1] * speed
  end
end

# TODO [refactor]: should be an entity, which has a sprite.
class Ship < Sprite
  def initialize x, y
    self.x = x
    self.y = y
    self.w = 56
    self.h = 39
    self.path = 'sprites/bat.png'
    self.direction = :up_right
  end
end

def defaults args
  args.state.enemy ||= Ship.new(640, 320)
  args.state.direction.last_change ||= args.state.tick_count
  args.state.direction.current ||= args.state.enemy.direction
end

def tick args
  defaults args
  calc args
  render args
end

def calc args
  if args.state.tick_count - args.state.direction.last_change >= 60
    args.state.direction.last_change = args.state.tick_count
    args.state.direction.current = DIRECTIONS[rand(8)]
  end
  if args.state.enemy.x >= BOUNDS[:right] - args.state.enemy.w && !args.state.enemy.moving_left?
    args.state.direction.current = :left
  end
  if args.state.enemy.x <= args.state.enemy.w - BOUNDS[:left] && !args.state.enemy.moving_right?
    args.state.direction.current = :right
  end
  if args.state.enemy.y >= BOUNDS[:top] - args.state.enemy.h && !args.state.enemy.moving_down?
    args.state.direction.current = :down
  end
  if args.state.enemy.y <= args.state.enemy.h - BOUNDS[:bottom] && !args.state.enemy.moving_up?
    args.state.direction.current = :up
  end  
  args.state.enemy.move(args.state.direction.current, 3)
end

def render args
  args.outputs.sprites << args.state.enemy
  #args.outputs.labels << [args.state.enemy.x - args.state.enemy.w * 2, args.state.enemy.y + args.state.enemy.h / 3, "%d, %d" % [args.state.enemy.x, args.state.enemy.y]]
end
