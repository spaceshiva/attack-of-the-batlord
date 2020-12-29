class Sprite
  attr_accessor :x, :y, :w, :h, :path, :angle, :a, :r, :g, :b,
  :source_x, :source_y, :source_w, :source_h,
  :tile_x, :tile_y, :tile_w, :tile_h,
  :flip_horizontally, :flip_vertically,
  :angle_anchor_x, :angle_anchor_y

  def primitive_marker
  :sprite
  end
end

# TODO [refactor]: should be an entity, which has a sprite.
class Ship < Sprite
  def initialize x, y
    self.x = x
    self.y = y
    self.w = 19
    self.h = 13
    self.path = 'sprites/bat.png'
  end

  # TODO [refactor]: figure a better way of doing this in Ruby, a Direction map maybe?
  def move direction, speed
    if direction.include?(:up) && direction.include?(:right)
      self.x += speed
      self.y += speed
      return
    end
    if direction.include?(:up) && direction.include?(:left)
      self.x -= speed
      self.y += speed
      return
    end
    if direction.include?(:down) && direction.include?(:right)
      self.x += speed
      self.y -= speed
      return
    end
    if direction.include?(:down) && direction.include?(:left)
      self.x -= speed
      self.y -= speed
      return
    end
    if direction.include?(:up)
      self.y += speed
      return
    end
    if direction.include?(:down)
      self.y -= speed
      return
    end
    if direction.include?(:left)
      self.x -= speed
      return
    end
    if direction.include?(:right)
      self.x += speed
      return
    end
  end
end

def defaults args
  args.state.enemy ||= Ship.new(640, 360)
  args.state.last_direction_change ||= args.state.tick_count
  args.state.curr_direction ||= [:up, :right]
end

def tick args
  defaults args
  calc args
  render args
end

def calc args
  if args.state.tick_count - args.state.last_direction_change >= 60 * 3
    args.state.last_direction_change = args.state.tick_count
    if args.state.curr_direction.include?(:up)
      args.state.curr_direction = [:down, :left]
    else
      args.state.curr_direction = [:up, :right]
    end
  end
  args.state.enemy.move(args.state.curr_direction, 1) 
end

def render args
  args.outputs.sprites << args.state.enemy
  args.outputs.labels << [args.state.enemy.x - args.state.enemy.w * 2, args.state.enemy.y + args.state.enemy.h / 3, "%d, %d" % [args.state.enemy.x, args.state.enemy.y]]
end
