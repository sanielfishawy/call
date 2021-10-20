class Avail < ActiveRecord::Base
  # include EnumHandler
  
  attr_accessible :player_id, :day, :time
  belongs_to :player
  
  # define_enum :day, [:mon, :tue, :wed, :thu, :fri, :sat, :sun]
  
  # ==========
  # = Scopes =
  # ==========
  # scope :cast_members, -> { where(role: :cast) }
  # scope :crew_members, -> { where(role: :crew) }
  scope :cast_members, -> { where(role: 'cast') }
  scope :crew_members, -> { where(role: 'crew') }
  
  # =================
  # = Class Methods =
  # =================
  
  
end
