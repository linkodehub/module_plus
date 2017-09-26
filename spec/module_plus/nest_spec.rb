#-*- mode: ruby; coding: utf-8-*-

require 'module_plus/nest'
require 'module_plus/exception'

#require ''

include ModulePlus

describe ModulePlus::Nest do
  module Root
    module Branch
      class LeafClass
        extend  Nest
      end
    end
  end
  subject{ Root::Branch::LeafClass }

  let(:routes){ [Root, Root::Branch, Root::Branch::LeafClass] }
  it "nest_names" do
    expect(subject.nest_names).to eq routes.map{ |r| r.to_s }
  end

  it "root_name" do
    expect(subject.root_name).to eq "Root"
  end

  it "outer_names" do
    expect(subject.outer_names).to eq routes.take(routes.size - 1).map{ |r| r.to_s }
  end

  it "nests" do
    expect(subject.nests).to eq routes
  end
  
  it "root" do
    expect(subject.root).to eq Root
  end

  it "outers" do
    expect(subject.outers).to eq routes.take(routes.size - 1)
  end

  
end


