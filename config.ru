
$stdout.sync = true
require "./app"
require "rack/contrib/try_static"
require 'rack-graphiql'

map '/graphiql' do
  run Rack::GraphiQL.new(endpoint: '/graphql')
end

run TestAPI::App
