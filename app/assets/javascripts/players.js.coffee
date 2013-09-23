# ==========
# = Player =
# ==========
$(document).ready -> 
  PlayerLoader.get_players()
  PlayerController.edit window.player_id if window.page_type is "edit"


class window.PlayerLoader
  
  @load: (players) => 
    new Player player for player in players

  @get_players: => 
    $.ajax {
      async: false
      dataType: "json"
      url: "/players/players_json"
      success: (response) => 
        @load response 
    }
    
  
class window.Player
  
  @players: []
  
  @all: => @players
  
  @first: => @all().first()
  
  @last: => @all().last()
  
  @find: (id) => 
    for player in @players
      return player if player.id is id 
    null
      
  constructor: (attrs) ->
    @[key] = attrs[key] for key in keys(attrs)
    Player.players.push @
    
  full_name: => "#{@first_name} #{@last_name}".capitalize_words()
  

# ====================
# = PlayerController =
# ====================
class window.PlayerController
  
  @post: => 
    $("#player_availability").attr("value", JSON.stringify AvailabilityView.availability_data())
    $("#new_player_form").submit()
  
  @delete: (id) => window.location = "/players/destroy/#{id}" if confirm("Delete #{Player.find(id).full_name()}?")
  
  @edit: (id) => AvailabilityView.load_avails(Player.find(id).avails)

  
# ====================
# = PlayerController =
# ====================
class window.AvailabilityView
  
  @table: => $("#availability_table")
  
  @day_all: (day) => @table().find(".time_slot.#{day}.valid").addClass "available"
    
  @day_none: (day) => @table().find(".time_slot.#{day}.valid").removeClass "available"
  
  @week_all: => @table().find(".valid").addClass "available"
  
  @week_none: => @table().find(".valid").removeClass "available"
  
  @time_slot_toggle: (day, time) => @table().find(".time_slot.valid.#{day}.#{time}").toggleClass "available"
  
  @availability_data: =>
    time_slots = @table().find(".valid.available")
    data = []
    data.push @data_for_time_slot(time_slot) for time_slot in time_slots
    data
    
  @data_for_time_slot: (time_slot) => day: $(time_slot).data().day, time: $(time_slot).data().time
  
  @load_avails: (avails) =>
    @table().find(".valid").removeClass "available"
    for avail in avails
      @table().find(".valid.#{avail.day}.time_#{avail.time}").addClass "available"