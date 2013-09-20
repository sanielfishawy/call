class PlayersController < ApplicationController
  
  def new
    render :template => "players/new"
  end
  
  
  def create
    normalize_params
    @player = Player.new params[:player]
    if @player.save
      @player.set_avails(JSON.parse params[:avails])
      redirect_to "/sched/sched"
    else
      new
    end
  end

  def edit
    @player = Player.find params[:id]
    @players = [ @player]
    render :template => "players/edit"
  end
  
  def update
    normalize_params
    @player = Player.find params[:id]
    if @player.update_attributes(params[:player].only(@player.attributes.keys))
      @player.set_avails(JSON.parse params[:avails])
      redirect_to "/sched/sched"
    else
      redirect_to edit_player_path(@player.id)
    end
  end
  
  def destroy
    player = Player.find(params[:id]).destroy
    redirect_to "/sched/sched"
  end
  
  private
  
  def normalize_params
    params[:player][:first_name] &&= params[:player][:first_name].strip.capitalize_words
  end
  
end
