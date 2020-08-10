---
title: "Apollo Server"
---

The AppSignal for Node.js integration for Apollo GraphQL (`apollo-server`) v2.0.0+.

## Installation

Add both the `@appsignal/nodejs` and `@appsignal/apollo-server` packages to your `package.json`. Then, run `yarn install`/`npm install`.

You can also add these packages to your `package.json` on the command line:

```bash
yarn add @appsignal/nodejs @appsignal/apollo-server
npm install --save @appsignal/nodejs @appsignal/apollo-server
```

You can then import and use the package in your app.

## Usage

The module includes an Apollo Server plugin for automatically instrumenting the resolvers of your application.

```js
// ENSURE APPSIGNAL IS THE FIRST THING TO BE REQUIRED/IMPORTED
// INTO YOUR APP!
const { Appsignal } = require("@appsignal/nodejs");
const { createApolloPlugin } = require("@appsignal/apollo-server");

// You can also use one of the apollo-server integrations here,
// e.g. `apollo-server-<integration>`. Note that you will also need to require
// the AppSignal integration seperately.
const { ApolloServer } = require("apollo-server");

const appsignal = new Appsignal({
  active: true,
  name: "<YOUR APPLICATION NAME>",
  apiKey: "<YOUR API KEY>",
});

// The GraphQL schema
const typeDefs = gql`
  type Query {
    "A simple type for getting started!"
    hello: String
  }
`;

// A map of functions which return data for the schema.
const resolvers = {
  Query: {
    hello: () => "world",
  },
};

const server = new ApolloServer({
  typeDefs,
  resolvers,
  plugins: [createApolloPlugin(appsignal)],
});

server.listen().then(({ url }) => {
  console.log(`🚀 Server ready at ${url}`);
});
```

!> **NOTE:** You must define an [operation name](https://www.apollographql.com/blog/the-anatomy-of-a-graphql-query-6dffa9e9e747/) for your query to get an action name in the Performance view of AppSignal.com. For example, `query FetchData {}` would get the action name `FetchData` on AppSignal.com. If no operation name is set, the query will be grouped under the action name `[unknown graphql query]`.
