class Ambulance < ActiveRecord::Base

  geocoded_by       :address
  after_validation  :geocode

  def proximity dest_loc
    src     = Geocoder.search(current_loc)
    slat    = src[0].latitude
    slong   = src[0].longitude
    src_f   = slat.to_s+","+slong.to_s

    dest    = Geocoder.search(dest_loc)
    dlat    = dest[0].latitude
    dlong   = dest[0].longitude
    dest_f  = dlat.to_s+","+dlong.to_s

    route   = ApplicationHelper::MyGoogleDirections.new(src_f, dest_f)
    time    = route.drive_time_in_minutes
  end

  def address
    self.current_loc
  end

  def equipment_level_label
    label = "None"
    case self.equipment_level
    when 1
      label = "Van"
    when 2
      label = "First Aid"
    when 3
      label = "Cardiac"
    end
    label
  end

  def self.emergency_label level
    label = "None"
    case level
    when 1
      label = "Van"
    when 2
      label = "First Aid"
    when 3
      label = "Cardiac"
    end
    label
  end

end
