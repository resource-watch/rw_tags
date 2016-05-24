class TaggableConstraint
  def self.matches?(request)
    request.params['cat'] == 'find'
  end
end
