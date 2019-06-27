require "sinatra/base"
require "graphql"

module Messages
  def messages
    [{message: "You are all breathtaking!"}]
  end

  module Mutations
    def sendMessage
      {message: "No! YOU are breathtaking!"}
    end
  end
end

module Contacts
  def contacts
    [{name: "Keanu Reeves"}]
  end
end

class Query
  include Messages
  include Contacts
  def viewer
    nil
  end
end

class Mutation
  include Messages::Mutations
end

module TestAPI
  module Resolver
    def self.call(type, field, obj, args, ctx)
      s = field.name.to_sym
      case type.to_s
      when 'Mutation'
        x = Mutation.new
        x.public_send(s)

      when 'Query'
        x = Query.new
        x.public_send(s)
      else
        return obj[s] if obj.is_a? Hash
        obj.public_send(s)
      end
    end
  end

  class App < Sinatra::Base
    post "/graphql" do
      body = JSON.parse(request.body.read)
      variables = body["variables"]
      query = body["query"]
      operation_name = body["operationName"]
      context = {}

      schema = Dir["#{File.dirname(__FILE__)}/protocols/**/*.graphql","#{File.dirname(__FILE__)}/graphql/schema.graphql"].map { |x|  File.read(x) }.join      

      puts schema

      built_schema = GraphQL::Schema.from_definition(schema, default_resolve: Resolver)
      result = built_schema.execute(query, variables: variables, context: context, operation_name: operation_name)
      content_type :json 
      result.to_json
    end
  end
end
