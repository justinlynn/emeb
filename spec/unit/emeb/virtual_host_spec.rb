require 'spec_helper'

describe EMEB::VirtualHost do
  
  before :each do
    @name = 'test_virtualhost'
    @broker = double 'Broker'
    @virtual_host = EMEB::VirtualHost.new(@name, @broker)
  end
  
  it 'has a name, and knows it was passed in the initializer' do
    @virtual_host.name.should eql(@name)
  end
  
  it 'belongs to a broker, and knows it was passed in the initializer' do
    @virtual_host.broker.should eql(@broker)
  end
  
  it 'by default, has no declared exchanges' do
    @virtual_host.exchanges.should be_empty
  end
  
  context 'declaring an exchange' do
    
    before :each do
      @exchange = double('Exchange', :name => 'test_exchange', :virtual_host => @virtual_host, :bindings => [double('Exchange Binding')])
    end
    
    it 'adds declared exchanges to the set of known exchanges' do
      @virtual_host.declare_exchange(@exchange)
      @virtual_host.exchanges.should include(@exchange)
    end
    
    it 'has knowledge of many bindings, through declared exchanges' do
      @virtual_host.declare_exchange(@exchange)
      @virtual_host.bindings.should include(@exchange.bindings)
    end
    
    context 'while attempting to declare an exchange with a name equal to a previously declared exchange' do
      
      it 'raises a DuplicateExchangeName exception' do
        exchange = double('Exchange', :name => 'test_exchange', :virtual_host => @virtual_host)
        exchange_duplicate = double('Duplicate Exchange', :name => 'test_exchange', :virtual_host => @virtual_host)
        @virtual_host.declare_exchange(exchange)
        expect{ @virtual_host.declare_exchange(exchange_duplicate) }.to raise_error(EMEB::VirtualHost::Error::DuplicateExchangeName)
      end
      
    end
    
    context 'while attempting to declare an exchange with a virtual_host not equal to the VirtualHost instance to which the exchange is being declared' do
      
      it 'raises a ExchangeVirtualHostNotReflexive exception' do
        exchange = double('Exchange', :name => 'test_exchange', :virtual_host => double('Invalid VirtualHost'))
        expect{ @virtual_host.declare_exchange(exchange) }.to raise_error(EMEB::VirtualHost::Error::ExchangeVirtualHostNotReflexive)
      end
      
    end
  
  end
  
end
