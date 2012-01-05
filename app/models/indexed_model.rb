module IndexedModel

  def self.included(base)
    base.class_eval do

      if !Rails.env.test?
        include Tire::Model::Search
        include Tire::Model::Callbacks
        index_name AppConfig.elastic_index + '_' +  self.base_class.name.downcase

        def self.index_import list
          self.index.import(list)
        end

      else
        #stub mapping
        def self.mapping
        end
        def self.index_import list
        end
      end
      cattr_accessor :class_index_options


      def self.index_options options={}
          self.class_index_options = options
      end




    end
  end

  #mocked methods for testing
  if Rails.env.test?
    def update_index
    end

  end


  def to_indexed_json

    to_ret = {}
    attrs = attributes.keys.collect{|key| key.to_sym}
    attrs += self.lazy_attributes if self.respond_to?(:lazy_attributes)
    
    if self.class.class_index_options[:json]
      options = self.class.class_index_options[:json]
      if options[:only]
        attrs = options[:only]
      elsif options[:except]
        attrs -= options[:except]
      end
    end
    
    (attrs).each{|attr|
      to_ret[attr] = self.send(attr)
    }

    if self.class.class_index_options[:extended_json]
      to_ret.merge!(self.send(self.class.class_index_options[:extended_json]))
    end
        
    to_ret.to_json
  end

end
