# -*-mode: ruby; coding: utf-8 -*-

module ModulePlus
  module CoreExt
    module String
      #
      # Camel case string to under score string
      #
      # double column("::") to slash("/")
      # dash("-") to underscore("_")
      # reference ActiveSupport (MIT License)
      # https://github.com/rails/rails/blob/master/activesupport/lib/active_support/inflector/methods.rb#L92
      #
      def self.underscore(origin)
        return origin unless /[A-Z-]|::/.match?(origin)
        word = origin.to_s.gsub('::', '/')
        word.gsub!(acronyms_underscore_regex) { "#{$1 && '_'.freeze }#{$2.downcase}" }
        word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2'.freeze)
        word.gsub!(/([a-z\d])([A-Z])/, '\1_\2'.freeze)
        word.tr!("-".freeze, "_".freeze)
        word.downcase!
        word
      end

      def self.acronyms_underscore_regex
        /(?:(?<=([A-Za-z\d]))|\b)(#{acronym_regex})(?=\b|[^a-z])/
      end
      def self.acronym_regex
        /(?=a)b/
      end
    end
  end
end

class String
  def underscore
    ModulePlus::CoreExt::String.underscore(self)
  end
end
