#-*- mode: ruby; coding: utf-8 -*-

require 'module_plus/attribute'
require 'module_plus/exception'

module ModulePlus
  module Identification
    def full_name
      my_klass.to_s
    end
    def full_names
      full_name.split(/::/)
    end
    def nest_names
      full_names.inject([]) do |list, name|
        list << (list.empty? ? name : "#{list.last}::#{name}")
      end
    end

    def root_name
      nest_names.first
    end

    def outer_names
      r = nest_names
      r.take(r.size - 1)
    end

    def nests
      #
      nest_names.map { |name| eval(name) } # rubocop:disable Security/Eval
    end

    def root
      eval(root_name) # rubocop:disable Security/Eval
    end

    def outers
      outer_names.map { |n| eval(n) } # rubocop:disable Security/Eval
    end

    private


    def my_klass
      if self.is_a? Module
        self
      else
        self.class
      end
    end
  end
end
