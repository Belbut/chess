require_relative '../../chess_kit/coordinate'

module MovementUtil
  def self.child_coordinate(direction, parent_coordinate)
    Coordinate.new(direction.first + parent_coordinate.x, direction.last + parent_coordinate.y)
  end

  def self.comply_with_restrictions(parent_coordinate, target_coordinate, requirements)
    requirements.all? do |individual_requirement|
      individual_requirement.call(parent_coordinate, target_coordinate) == true
    end
  end
end
