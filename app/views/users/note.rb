@achievementtypes.each do |type|
  type.achievementtype
  achievements << type.achievementtype
  if achievementhash.has_key?(type.achievementtype)