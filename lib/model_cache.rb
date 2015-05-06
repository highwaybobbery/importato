class ModelCache

  def initialize(model)
    @model = model
    @cache = {}
  end

  def write(attributes)
    find_or_create attributes
  end

  private

  attr_reader :cache, :model

  def find_or_create(attributes)
    key = cache_key(attributes)
    find(key) || create(key, attributes)
  end

  def cache_key(attributes)
    Digest::MD5.hexdigest(attributes.inspect)
  end

  def find(key)
    cache[key]
  end

  def create(key, attributes)
    cache[key] = model.find_or_create_by(attributes).id
  end

end
