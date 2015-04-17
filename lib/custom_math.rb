require 'mathn'

module CustomMath
  def self.converter
    180 * Math::PI
  end

  def self.to_rad angle
    angle / self.converter
  end
end
