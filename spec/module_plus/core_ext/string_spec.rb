#-*- mode: ruby; coding: utf-8 -*-

require 'module_plus/core_ext/string'

describe ModulePlus::CoreExt::String do

  context "underscore methods" do

    it 'Camel Case' do
      expect('CamelCase'.underscore).to eq 'camel_case'
    end
    it 'With Double Colon Case' do
      expect('With::ColonCase'.underscore).to eq 'with/colon_case'
    end

    it 'With Single Colon Case' do
      expect('WithSingle:ColonCase'.underscore).to eq 'with_single:colon_case'
    end
    it 'Dash to Underscore' do
      expect('Dash-To-Underscore'.underscore).to eq 'dash_to_underscore'
    end
    it 'Not Found Conversion Charactors' do
      expect('12345'.underscore).to eq '12345'
      expect('?@*+/!'.underscore).to eq '?@*+/!'
      expect('あいうえお'.underscore).to eq 'あいうえお'
    end

    
  end
  
end
