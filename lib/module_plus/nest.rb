#-*- mode: ruby; coding: utf-8 -*-

require 'module_plus/attribute'
require 'module_plus/exception'

module ModulePlus
  module Nest
    extend ExtendOnly

    def nest_names
      nest_klass_names.inject([]){ |list, name| list << (list.empty? ? name : list.last + "::" + name) }
    end

    def root_name
      nest_names.first
    end
    def outer_names
      r = nest_names
      r.take(r.size - 1)
    end

    def nests
      nest_names.map{ |name| eval( name ) }
    end
    
    def root
      eval( root_name )
    end

    def outers
      outer_names.map{ |n| eval(n) }
    end

    private
    def nest_klass_names
      self.to_s.split(/::/)
    end
  end
end

