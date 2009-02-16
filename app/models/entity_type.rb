class EntityType < ActiveRecord::Base
	has_many :entities

  validates_presence_of(:name, :message => "Debe introducir el nombre del tipo de entidad.")
  validates_uniqueness_of(:name, :message => "El nombre de tipo de entidad ya existe.") 
end
