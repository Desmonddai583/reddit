module Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :generate_slug!
    class_attribute :slug_column
  end

  def generate_slug!
    the_slug = to_slug(self.send(self.class.slug_column))
    tmp_slug = nil
    count = 0
    while true
      tmp_slug = tmp_slug || the_slug
      object = self.class.find_by slug: tmp_slug
      if object
        count += 1
        tmp_slug = the_slug + '-' + count.to_s
      else
        self.slug = tmp_slug.blank? ? the_slug : tmp_slug
        break
      end
    end
  end

  def to_slug(name)
    str = name.strip
    str.gsub!(/\s*[^A-Za-z0-9]\s*/, '-')
    str.gsub!(/-+/, '-')
    if str[-1] == '-'
      str = str[0...-1]
    end
    str = str.downcase
  end

  def to_param
    self.slug
  end

  module ClassMethods
    def sluggable_column(col_name)
      self.slug_column = col_name
    end
  end
end
