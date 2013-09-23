$(document).ready -> Login.login_if_necessary()

class window.Login
  @login_if_necessary: => @login() unless @is_signed_in()
  
  @login: => 
    @pw = prompt("Enter Password")
    @wrong() unless @pw is "priory"
    localStorage.signed_in = true
  
  @wrong: => 
    alert "Wrong password. Try again."
    @login()
  
  @is_signed_in: => localStorage.signed_in is "true"
    
  
class window.SchedController
  
  @player_list: => $(".player_list")
  
  @toggle: (id) => 
    $(".player_block.id_#{id}").toggleClass "selected"
    @show_all()
    
  @show_all: =>
    @show_matching()
    @show_special_avials()
  
  @unselect_all: =>
    $(".player_block").removeClass "selected"
    @show_all()
      
  @show_special_avials: =>
    players = @selected_players().filter (p) -> p.note
    return $(".special_avails").html "None" if players.is_blank()
    
    notes_html = ""
    notes_html += @note_html(player) for player in players
    $(".special_avails").html notes_html
  
  @note_html: (player) =>
    """
<div class="name">#{player.full_name()}</div>
<pre class="note">
#{player.note}
</pre>
    """
  
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
