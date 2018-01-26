#-*- mode: ruby; coding: utf-8 -*-

require 'module_plus/config_convention'
require 'module_plus/exception'

include ModulePlus


describe ModulePlus::ConfigConvention do

  ConfigConvention.config_dir = "/tmp"
  before :all do
    hash = { "branch" => { "fields" => {"system_root" => "/opt/any", "port"=> 8080, "timeout" => 3.14, "nest" => {"key" => "string"}} }, "key" => "top"}
    @config_path = Pathname.new(ConfigConvention.config_dir).join(ConfigConvention.config_file)
    File.open(@config_path, "w"){ |fs| YAML.dump( hash, fs) }
  end

  after :all do

  end
  
  module Root
    module Branch
      module Fields
        extend ConfigConvention
        config_def :system_root, type: :string, desc: "system root"
        config_def :port, type: :int, desc: "listen port"
        config_def :timeout, type: :float, desc: "timeout seconds"

        module Nest
          extend ConfigConvention
          config_def :key, type: :string, desc: "nest string"
        end
      end
    end
    extend ConfigConvention
    config_def :key, type: :string, desc: "top string"
  end



  context "registered field keys" do

    it 'load from config file' do
      #ConfigConvention.show
      expect(Root::Branch::Fields.config.system_root).to eq "/opt/any"
      expect(Root::Branch::Fields.config.port).to eq 8080
      expect(Root::Branch::Fields.config.timeout).to eq 3.14
      expect(Root::Branch::Fields::Nest.config.key).to eq "string"
      expect(Root.config.key).to eq "top"
    end
  end
end
