# frozen_string_literal: true
class TaggableTopicableConstraint
  def self.matches?(request)
    request.params['cat'] == 'find'
  end
end
