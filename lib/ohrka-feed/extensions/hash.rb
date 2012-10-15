class Hash
  # Provide compatibility between Dalli and Hash
  def set(name, value)
    store(name, value)
  end

  def get(name)
    fetch(name, nil)
  end
end
