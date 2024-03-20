module Api::Printer
    extend ActiveSupport::Concern
    
    included do
        # Use self.json_attrs to drive json rendering for 
        # API model responses (index, show and update ones).
        # For reference:
        # https://api.rubyonrails.org/classes/ActiveModel/Serializers/JSON.html
        # The object passed accepts only these keys:
        # - only: list [] of model fields to be shown in JSON serialization
        # - except: exclude these fields from the JSON serialization, is a list []
        # - methods: include the result of some method defined in the model
        # - include: include associated models, it's an object {} which also accepts the keys described here
        cattr_accessor :json_attrs
        self.json_attrs = ::ModelDrivenApi.smart_merge (json_attrs || {}), {
            methods: [ :is_online ]
        }
        
        # Here you can add custom actions to be called from the API
        # The action must return an serializable (JSON) object.
        # Here you can find an example, in the API could be called like:
        # 
        # GET /api/v2/:model/:id?do=test&custom_parameter=hello
        #
        # Please uncomment it to test with a REST client.
        # Please take note on the fact that, if the do params is test, the custom
        # action definition must be, like below self.custom_action_test.
        # def self.custom_action_test id=nil, params=nil
        #     { test: [ :first, :second, :third ], id: id, params: params}
        # end
    end
end
