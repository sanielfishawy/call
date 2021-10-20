class Player < ActiveRecord::Base
  include EnumHandler
  
  attr_accessible :first_name, :last_name, :role, :note
  
  # define_enum :role, [:cast, :crew], :primary => true
  
  has_many :avails, :dependent => :destroy
  
  validates :first_name, :last_name, :role, :presence => true
  validates :first_name, :uniqueness => {:scope => :last_name, :message => "  :: A player with this first and last name exists."}
  
  def full_name
    "#{first_name} #{last_name}".capitalize_words
  end
  
  def set_avails(new_avails)
    # Get rid any existing avails for the player
    avails.each{|a| a.destroy}
    
    # Add the new ones for him
    new_avails = new_avails.map{|a| a.merge({:player_id => id})}
    new_avails.each{|a| Avail.create(a)}
  end

  def self.crew
    Player.where({role: 'crew'})
  end
  
  def self.cast
    Player.where({role: 'cast'})
  end 

end
