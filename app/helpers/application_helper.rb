module ApplicationHelper
  
  def times
    t = []
    (10..17).each do |hr|
      ["00", "30"].each do |min|
        t.push (hr.to_s + min).to_i
      end
    end
    t
  end
  
  
  def display_time(time)
    Time.strptime(time.to_s, '%H%M').strftime('%l:%M %P')
  end
  
  def display_role(role)
    role.to_s.capitalize_words
  end
  
  def players_json(players)
    j = JSON.dump players.map{ |p| p.attributes.merge(:avails => p.avails.map{|a| a.attributes}) }
    j.html_safe
  end
end
