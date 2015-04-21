module PromosHelper
  def self.current_time
    DateTime.now.new_offset(-5/24).change(offset: "+0000")
  end
end
