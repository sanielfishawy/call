class SchedController < ApplicationController
  
  def sched
    @players = Player.all
    @cast_and_crew = {:crew => Player.crew.sort{|a,b| a.first_name <=> b.first_name}, :cast => Player.cast.sort{|a,b| a.first_name <=> b.first_name}}
  end
  
end
