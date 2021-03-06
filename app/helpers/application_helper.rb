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
    
  def availability_on(day, time, availability)
    a = ""
    availability.each do |avail|
      avail = avail.symbolize_keys
      if day == avail[:day].to_sym && time.to_i == avail[:time].to_i
        a = "available"
        break
      end
    end
    return a
  end
  
end
