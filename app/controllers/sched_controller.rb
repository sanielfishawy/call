class SchedController < ApplicationController
  
  def sched
    @players = Player.all
    @cast_and_crew = {:crew => Player.crew, :cast => Player.cast}
  end
  
end
