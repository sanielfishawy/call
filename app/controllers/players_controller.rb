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
      @avails = JSON.parse params[:avails]
      new
    end
  end

  def edit
    @player ||= Player.find params[:id]
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
      edit
    end
  end
  
  def destroy
    player = Player.find(params[:id]).destroy
    redirect_to "/sched/sched"
  end
  
  def players_json
    render :json => Player.all.sort{|a,b| a.first_name <=> b.first_name}.map{ |p| p.attributes.merge(:avails => p.avails.map{|a| a.attributes}) }
  end
  
  private
  
  def normalize_params
    params[:player][:first_name] &&= params[:player][:first_name].strip.capitalize_words
    params[:player][:last_name] &&= params[:player][:last_name].strip.capitalize_words
  end
  
end
