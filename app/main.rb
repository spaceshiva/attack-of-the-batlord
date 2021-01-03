require 'app/engine/entity.rb'
require 'app/enemy.rb'

def defaults args
  args.state.enemy ||= SnakedBat.new(640, 320, 3, 3)
  args.state.direction.last_change ||= args.state.tick_count
  args.state.direction.current ||= args.state.enemy.direction
end

def tick args
  defaults args
  calc args
  render args
end

def calc args
  if args.state.tick_count - args.state.direction.last_change >= 60 * 3
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
  args.state.enemy.move(args.state.direction.current, 1)
  args.state.enemy.spawn(args.state.tick_count)
end

def render args
  args.outputs.background_color = [ 0, 0, 0, 255 ]
  args.state.enemy.animate(args.state.tick_count)
  args.state.enemy.render(args.outputs)
  
  args.outputs.labels << [10,
                          30, 
                          "x: %d, y: %d, w: %d, h: %d, d: %s" % [args.state.enemy.x, args.state.enemy.y, args.state.enemy.w, args.state.enemy.h, args.state.enemy.direction],
                          255, 255, 0]
  #args.outputs.labels << [10,
  #                        60,
  #                        "moving_left: %s, moving_right: %s, moving_down: %s, moving_up: %s" % [args.state.enemy.moving_left?, args.state.enemy.moving_right?, args.state.enemy.moving_down?, args.state.enemy.moving_up?],
  #                        255, 255, 0]
end
