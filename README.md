# GraphQL protocols sinatra sample

> WARNING: We're working on this 💪. For discussion purposes only at this moment.

This is a very hacky sinatra example on how to implement [GraphQL protocols](https://github.com/graphql-protocols/graphql-protocols) in a sinatra ruby app.

![GraphiQL](https://raw.githubusercontent.com/graphql-protocols/graphql-protocols-sinatra-sample/master/images/graphiql.jpg)

To set this up:

```bash
bundle
bundle exec rackup
```

Then navigate to `http://localhost:9292/graphiql` to check out your GraphQL endpoint.

Or you can deploy to heroku:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

And go to your endpoint /graphiql to see your endpoint

## Concept

In this sample we're implementing a couple of protocols. This exists out of 2 parts. The protocols itself and the implementation.

### The vendored protocols

The files under protocols are vendored. They will be supplied by your protocol vendor. These protocols can also be installed via a gem or npm package.

```bash
graphql-protocols-sample-server (master) ∆ tree ./protocols
./protocols
├── contacts
│   └── schema.graphql
├── postbox
│   └── schema.graphql
└── tokens
    └── schema.graphql

7 directories, 7 files
```

You just need to drop them in and extend your `schema.graphql` as done here.

```graphql
type User implements Postbox {
}

type Query implements Postbox, Contacts {
  messages: [Message!]
  contacts: [Contact!]
  viewer: User
}

type Mutation implements PostboxMutatations, TokenRequestMutations {
  sendMessage(message: String): Message
}
```

### The implementation

This is where you come into the picture. After this is done. You need to write the implementation for those protocols. Some vendors supply a sample protocol implementation here. I've just wrote a sample implementation in ruby that returns some data.

```ruby
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
end

class Mutation
  include Messages::Mutations
end
```

Next, hook them up in your resolver. Aaand done! You now have a GraphQL endpoint that adheres to the vendored protocols! 🙌
