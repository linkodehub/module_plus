#-*- mode: ruby; coding: utf-8-*-

require 'module_plus/attribute'
require 'module_plus/exception'

#require ''

include ModulePlus::Exception
include ModulePlus::Attribute

describe ModulePlus::Attribute do
  describe ModulePlus::Attribute::IncludeGuard do
    module NeverInclude
      extend IncludeGuard
    end
    it "never permit to include" do
      expect {
        class TryInclude
          include NeverInclude
        end
      }.to raise_error( NotPermittedToInclude )
    end
    it "permit to extend" do
      expect {
        class TryExtend
          extend NeverInclude
        end
      }.not_to raise_error
    end

    describe "using by" do
      it "include" do
        expect {
          module IncludeGuardByInclude
            include IncludeGuard
          end
          class NoGuard
            include IncludeGuardByInclude
          end
        }.not_to raise_error
      end
    end
  end

  describe ModulePlus::Attribute::ExtendGuard do
    module NeverExtend
      extend ExtendGuard
    end
    it "never permit to extend" do
      expect {
        class TryExtend
          extend NeverExtend
        end
      }.to raise_error( NotPermittedToExtend )
    end
    it "permit to include" do
      expect {
        class TryInclude
          include NeverExtend
        end
      }.not_to raise_error
    end

    describe "using by" do
      it "include" do
        expect {
          module ExtendGuardByInclude
            include ExtendGuard
          end
          class NoGuard
            extend ExtendGuardByInclude
          end
        }.not_to raise_error
      end
    end
  end

  describe ModulePlus::Attribute::IncludeOnly do
    module OnlyInclude
      include IncludeOnly
    end
    it "permit to include" do
      expect {
        class TryInclude
          include IncludeOnly
        end
      }.not_to raise_error
    end
    it "never permit to extend" do
      expect {
        class TryExtend
          extend NeverExtend
        end
      }.to raise_error( NotPermittedToExtend )
    end

    describe "using by" do
      it "extend, raise error" do
        expect {
          module IncludeOnlyByExtend
            extend IncludeOnly
          end
        }.to raise_error( NotPermittedToExtend )
      end
    end
  end

  describe ModulePlus::Attribute::ExtendOnly do
    module OnlyExtend
      extend ExtendOnly
    end
    it "permit to extend" do
      expect {
        class TryExtend
          extend OnlyExtend
        end
      }.not_to raise_error
    end
    it "never permit to include" do
      expect {
        class TryInclude
          include OnlyExtend
        end
      }.to raise_error( NotPermittedToInclude )
    end
    describe "using by" do
      it "include, raise error" do
        expect {
          module ExtendOnlyByInclude
            include ExtendOnly
          end
        }.to raise_error( NotPermittedToInclude )
      end
    end
  end
end
