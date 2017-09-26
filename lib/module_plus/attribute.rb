#-*-mode: ruby; coding: utf-8-*-

require 'module_plus/exception'

module ModulePlus
  module Attribute
    include ModulePlus::Exception
    module ExtendGuard
      def extended( klass )
        raise NotPermittedToExtend.new( "#{self.name} by #{klass}" )
      end
    end

    module IncludeGuard
      def included( klass )
        raise NotPermittedToInclude.new( "#{self.name} by #{klass}" )
      end
    end

    module ExtendOnly
      extend IncludeGuard
      def self.extended( klass )
        klass.extend( IncludeGuard )
      end
    end

    module IncludeOnly
      extend ExtendGuard
      def self.included( klass )
        klass.extend( ExtendGuard )
      end
    end
  end
end

include ModulePlus::Attribute
