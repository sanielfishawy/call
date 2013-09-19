class window.SchedController
  
  @player_list: => $(".player_list")
  
  @toggle: (id) => 
    $(".player_block.id_#{id}").toggleClass "selected"
    @show_matching()
  
  @show_matching: =>
    return AvailabilityView.week_all() if @selected_players().is_blank()
    avails = Avail.combined_avails(@selected_players())
    AvailabilityView.load_avails(avails)
  
  @selected_player_ids: => $(".player_list .player_block.selected").get().map (p) -> $(p).data().id
  
  @selected_players: => @selected_player_ids().map (id) -> Player.find(id)



class window.Avail
  
  @combined_avails: (players) => 
    matching = players.first().avails
      
    for player in players[1..-1]
      matching = @matching_avails(matching, player.avails)
      
    matching
  
  @matching_avails: (as, bs) => 
    r = []
    for a in as
      for b in bs
        r.push b if @matching_avail(a,b)
    r

  @matching_avail: (a, b) => a.day is b.day and a.time is b.time
