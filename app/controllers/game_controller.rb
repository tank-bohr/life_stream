# encoding: utf-8

class GameController < ApplicationController
  include ActionController::Live

  def index
    # SSE expects the `text/event-stream` content type
    response.headers['Content-Type'] = 'text/event-stream'
    sse = ServerSideEvent.new(response.stream)

    first_generation = Life::PatternLoader.pattern(params[:pattern])
    world = Life::World.new(first_generation)
    delay = params[:delay].try(:to_f) || 1
    begin
      sse.write({
        rows: first_generation.count,
        columns: first_generation[0].count
      }, event: 'build')
      loop do
        world.next_generation!
        sse.write({world: world.to_a}, event: 'update')
        sleep delay
      end
    rescue IOError
      # When the client disconnects, we'll get an IOError on write
    ensure
      sse.close
    end
  end
end
