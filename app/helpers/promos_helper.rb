module PromosHelper
  def self.current_time
    format = "%Y-%m-%d %H:%M:%S"
    DateTime.now.new_offset(-5/24).change(offset: "+0000").strftime(format)
  end
end
