# encoding: utf-8

class GameController < ApplicationController
  include ActionController::Live

  def index
    # SSE expects the `text/event-stream` content type
    response.headers['Content-Type'] = 'text/event-stream'
    sse = LifeStream::SSE.new(response.stream)
    world = Life::World.new([
      [0, 0, 0, 0],
      [0, 1, 1, 1],
      [1, 1, 1, 0],
      [0, 0, 0, 0],
    ])
    begin
      loop do
        world.next_generation!
        sse.write({world: world.to_a}, event: 'update')
        sleep 1
      end
    rescue IOError
      # When the client disconnects, we'll get an IOError on write
    ensure
      sse.close
    end
  end
end
