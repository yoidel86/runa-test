# class to inherit from activeRecord
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
