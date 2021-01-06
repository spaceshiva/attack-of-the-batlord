require 'app/engine/vectors.rb'
require 'app/engine/entity.rb'
require 'app/enemy.rb'

def defaults args
  args.state.enemies ||= [Bat.new(0, 0), Bat.new(1240, 0), Bat.new(0, 720), Bat.new(1240, 720)]
end

def tick args
  defaults args
  calc args
  render args
end

def calc args
  args.state.enemies.each { |e| e.seek([620, 340]) }
  #args.state.enemy.spawn(args.state.tick_count)
end

def render args
  args.outputs.background_color = [ 0, 0, 0, 255 ]
  i = 1
  args.state.enemies.each do |e| 
    e.animate(args.state.tick_count)
    e.render(args.outputs)
    args.outputs.labels << [10,
                              30 * i, 
                              "x: %d, y: %d" % [e.x, e.y],
                              255, 255, 0]
    i += 1
  end
  
  #args.outputs.labels << [10,
  #                        30, 
  #                        "x: %d, y: %d" % [args.state.enemy.x, args.state.enemy.y],
  #                        255, 255, 0]
end
