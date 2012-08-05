require 'emeb/error'

module EMEB
  
  # The VirtualHost routes messages from exchanges to queues via bindings. It
  # is responsible for pulling messages from exchanges, determining if a message
  # should be routed to a queue via any bindings the exchange possesses
  class VirtualHost
    
    attr_reader :name
    attr_reader :broker
    attr_reader :exchanges
    
    # @param name [String] The name of the VirtualHost
    # @param broker [Broker] The broker to which the VirtualHost belongs
    def initialize name, broker
      @name = name
      @broker = broker
      @exchanges = []
    end
    
    # Informs VirtualHost instance that it should manage the given exchange
    # @param exchange_to_be_declared [Exchange, #virtual_host, #name, #bindings] The exchange to manage
    # @raise [DuplicateExchangeNameError] Raised if the name of the exchange to be declared
    #   matches the name of an already declared exchange
    # @raise [ExchangeVirtualHostNotSelfError] Raised if the #virtual_host return value
    #   of the given exchange does not equal the VirtualHost instance to which the
    #   exchange is being declared
    def declare_exchange exchange_to_be_declared
      ensure_exchange_name_not_declared exchange_to_be_declared
      ensure_exchange_virtual_host_matches_self exchange_to_be_declared
      @exchanges << exchange_to_be_declared
    end
    
    # Raise applicable exceptions if any previously declared exchange has a name
    # equal to the exchange to be declared
    def ensure_exchange_name_not_declared exchange_to_be_declared
      raise Error::DuplicateExchangeName if exchanges.any? do |previously_declared_exchange| 
        previously_declared_exchange.name == exchange_to_be_declared.name
      end
    end
    private :ensure_exchange_name_not_declared
    
    # Raise applicable exceptions if the given exchange's virtual_host does not equal
    # self
    def ensure_exchange_virtual_host_matches_self exchange_to_be_declared
      raise Error::ExchangeVirtualHostNotReflexive if exchange_to_be_declared.virtual_host != self
    end
    private :ensure_exchange_virtual_host_matches_self
    
    # All available Bindings via declared Exchanges
    # @return [Binding] The set of available Bindings
    def bindings
      exchanges.map(&:bindings)
    end
    
    # Raised when an error occured during an operation on a VirtualHost object.
    class Error < EMEB::Error
      
      # Raised when the name of the exchange to be declared matches the name of a
      # previously declared exchange. See (VirtualHost#declare_exchange).
      class DuplicateExchangeName < VirtualHost::Error
      end
      
      # Raised when the virtual_host of the exchange to be declared does not equal
      # the VirtualHost instance to which the exchange is being declared
      class ExchangeVirtualHostNotReflexive < VirtualHost::Error
      end
      
    end
    
  end
  
end
