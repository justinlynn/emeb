require 'spec_helper'

describe EMEB::ConvenienceInterface do
  
  it 'is extended by the ActiveSupport Concern module' do
    subject.singleton_class.included_modules.should include(ActiveSupport::Concern)
  end
  
end

describe EMEB::ConvenienceInterface::ClassMethods do
  
  describe 'defining a consumer' do
  
    it 'defines the on method' do
      subject.instance_methods.should include(:on)
    end
  
  end
  
  describe 'publishing a message' do
      
    it 'defines the publish method' do
      subject.instance_methods.should include(:publish)
    end

  end
  
end