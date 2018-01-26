# -*-mode: ruby; coding: utf-8 -*-

require 'module_plus/attribute'
require 'module_plus/identification'
require 'module_plus/core_ext/string'
require 'module_plus/core_ext/hash'

require 'ostruct'
require 'pathname'
require 'yaml'


module ModulePlus

  module ConfigConvention
    include ModulePlus::Attribute
    extend ExtendOnly

    class << self
      def extended(klass)
        super
        klass.extend(ModulePlus::Identification)
      end

      attr_reader :config_hash

      def add_def(c)
        array = (c.path << c.key.to_s).reverse
        h = array.inject(c.sample){ |h, k| {k => h}}
        @config_hash ||= Hash.new { |h,k| h[k] = Hash.new(&h.default_proc) }
        @config_hash.deep_merge!( h )

      end

      def field_path_position_top
        @field_path_position ||= 0
      end

      def field_path_position_no_head
        @field_path_position ||= 1
      end

      def field_path(array)
        field_path_position_no_head
        array.drop(@field_path_position)
      end

      def config_file=(f)
        @config_file ||= f
      end

      def config_file
        @config_file || 'config.yml'
      end

      def root_dir=(d)
        @config_root = d
      end

      def root_dir
        @config_root || ENV['HOME']
      end

      def config_dir=(d)
        @config_dir ||= d
      end

      def config_dir
        @config_dir
      end

      def dump(fs)
        YAML.dump(@config_hash, fs)
      end
    end

    def config
      @_config ||= config_load
    end

    #

    def config_dir
      Pathname.new(ConfigConvention.root_dir)
        .join(ConfigConvention.config_dir || '.' + root_name.underscore)
    end
    
    def config_file
      config_dir.join(ConfigConvention.config_file)
    end

    protected

    def config_def(key, attributes = {} )
      @config_defs ||= {}
      c = ConfigDef.new(key, field_path, attributes)
      @config_defs[c.key] = c
      ConfigConvention.add_def(c)
    end

    attr_reader :config_defs


    private
    def config_load
      if config_file.exist? and yaml = YAML.load_file(config_file)                
        c = field_path.inject(yaml) do |h, k|
          if h[k].is_a? Hash
            h[k]
          else
            raise NotFoundField.new( "Not Found Field #{k} in #{config_file}")
          end
        end
        diff = @config_defs.keys - c.keys
        raise NotFoundField.new( "Field Key: #{diff.join(", ")} in #{} #{config_file}") unless diff.empty?
        @config_defs.values.each do |d|
          c[d.key] = d.value(c[d.key])
        end
        ost = OpenStruct.new(c)
        ost.freeze
      else
        ost = OpenStruct.new
        ost.freeze
      end
    end

    def field_path
      ConfigConvention.field_path(full_names.map{ |str| str.underscore })
    end
  end

  class ConfigDef
    attr_reader :key, :type, :desc, :path, :sample
    def initialize(key, path, attributes = {})
      @key  = key.to_s
      @path = path
      @desc = attributes[:desc] || ""
      @type = _type(attributes[:type])
      @type_strict = _type_strict(@type)
      @sample = attributes[:sample] || _sample(@type)
    end

    def field
      "#{@path.join(".")}.#{@key}"
    end

    def value(v)
      raise new NotPermitedValueType.new("#{path}.#{@key}: #{v} is NOT Matched Type for #{@type}") unless @type_strict.call(v)
      v
    end

    private
    def _type(t)
      (t && t.downcase.to_sym) || :string
    end

    def _sample(type)
      case type
      when :string       then; 'string'
      when :int          then; 0
      when :float        then; 0.1
      when :boolean      then; true
      when :string_array then; ['string']
      when :int_array    then; [0]
      when :float_array  then; [0.1]
      else
        nil
      end
    end
    def _type_strict(t)
      case t
      when :string       then; -> (v){ v.is_a? String  }
      when :int          then; -> (v){ v.is_a? Numeric }
      when :float        then; -> (v){ v.is_a? Numeric }
      when :boolean      then; -> (v){ v.is_a? TrueClass or v.is_a? FalseClass }
      when :string_array then; -> (v){ v.is_a? Array and v.all?{ |s| s.is_a? String } }
      when :int_array    then; -> (v){ v.is_a? Array and v.all?{ |s| s.is_a? Numeric } }
      when :float_array  then; -> (v){ v.is_a? Array and v.all?{ |s| s.is_a? Numeric } }
      else
        raise NotPermitedValueType.new( "Type #{t} of Config Key:#{@key} - #{desc} in #{path}")
      end
    end
  end
end
