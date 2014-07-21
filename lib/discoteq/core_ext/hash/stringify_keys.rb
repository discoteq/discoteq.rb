# extend Hash to provide key normalization
class Hash
  # ensure keys are strings
  def stringify_keys
    Hash[map {|k, v| [k.to_s, v]}]
  end
end
