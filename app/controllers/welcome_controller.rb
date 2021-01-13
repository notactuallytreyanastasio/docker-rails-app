class WelcomeController < ApplicationController
  def index
    $redis.incr("visits")
    @hits = $redis.get("visits")
  end
end
