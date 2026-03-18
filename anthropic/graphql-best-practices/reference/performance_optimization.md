# GraphQL Performance Optimization

Optimizing GraphQL queries is crucial for building fast, scalable applications. This guide covers performance best practices, common pitfalls, and optimization techniques.

## Core Performance Principles

1. **Request Only What You Need** - GraphQL's strength is precise data fetching
2. **Limit Query Depth** - Prevent expensive nested queries
3. **Always Paginate** - Never fetch unbounded lists
4. **Batch Operations** - Reduce round trips with DataLoader
5. **Cache Strategically** - Leverage GraphQL's caching capabilities

## Query Complexity

### The N+1 Problem

The most common GraphQL performance issue.

#### Problem Example
```graphql
query GetApplicationsWithComponents {
  applications(first: 100) {
    edges {
      node {
        id
        name
        # This causes N+1 queries!
        components {
          id
          name
        }
      }
    }
  }
}
```

**What happens:**
1. 1 query to fetch 100 applications
2. 100 queries to fetch components for each application
3. **Total: 101 database queries!**

#### Solution: DataLoader
```javascript
// Server-side batching with DataLoader
const componentLoader = new DataLoader(async (applicationIds) => {
  // Single batched query
  const components = await db.query(`
    SELECT * FROM components
    WHERE application_id IN (?)
  `, applicationIds);

  // Group by application ID
  return applicationIds.map(id =>
    components.filter(c => c.application_id === id)
  );
});

// In resolver
const resolvers = {
  Application: {
    components: (application) =>
      componentLoader.load(application.id)
  }
};
```

**Result: 2 queries instead of 101!**

### Query Depth Limits

Prevent deeply nested queries that can overwhelm the server.

#### Problem: Unbounded Depth
```graphql
query DeepQuery {
  user {
    posts {
      comments {
        author {
          posts {
            comments {
              author {
                posts {
                  # Can go infinitely deep!
                }
              }
            }
          }
        }
      }
    }
  }
}
```

#### Solution: Limit Depth
```javascript
// Server configuration
const server = new ApolloServer({
  validationRules: [
    depthLimit(5), // Max depth of 5 levels
  ],
});
```

#### Best Practice: Design Shallow Queries
```graphql
# ✅ GOOD - Limit depth, use specific queries
query GetUserWithPosts($userId: ID!, $first: Int = 10) {
  user(id: $userId) {
    id
    name
    posts(first: $first) {
      edges {
        node {
          id
          title
          # Stop here - get comments separately if needed
        }
      }
    }
  }
}

# Separate query for comments if needed
query GetPostComments($postId: ID!, $first: Int = 20) {
  post(id: $postId) {
    id
    comments(first: $first) {
      edges {
        node {
          id
          text
          author {
            id
            name
          }
        }
      }
    }
  }
}
```

### Query Complexity Analysis

Assign costs to fields and limit total query complexity.

#### Complexity Calculation
```graphql
type Query {
  # Simple field: cost = 1
  user(id: ID!): User # cost: 1

  # List field: cost = limit * field_cost
  users(first: Int!): [User] # cost: first * 5
}

type User {
  id: ID!              # cost: 1
  name: String!        # cost: 1
  email: String!       # cost: 1
  posts(first: Int!): [Post] # cost: first * 3
}
```

#### Example Query Cost
```graphql
query GetUsers($first: Int = 10) {
  users(first: $first) {  # 10 * 5 = 50
    id                     # 10 * 1 = 10
    name                   # 10 * 1 = 10
    posts(first: 5) {      # 10 * 5 * 3 = 150
      id                   # 10 * 5 * 1 = 50
      title                # 10 * 5 * 1 = 50
    }
  }
}
# Total cost: 50 + 10 + 10 + 150 + 50 + 50 = 320
```

#### Server Implementation
```javascript
import { createComplexityLimitRule } from 'graphql-validation-complexity';

const server = new ApolloServer({
  validationRules: [
    createComplexityLimitRule(1000, {
      scalarCost: 1,
      objectCost: 5,
      listFactor: 10,
    }),
  ],
});
```

## Pagination Best Practices

### Always Use Pagination

#### ❌ BAD: Unbounded Query
```graphql
query GetAllApplications {
  applications {
    edges {
      node {
        id
        name
        # Returns ALL applications - could be thousands!
      }
    }
  }
}
```

#### ✅ GOOD: Paginated Query
```graphql
query GetApplications(
  $first: Int = 50
  $after: String
) {
  applications(first: $first, after: $after) {
    totalCount
    pageInfo {
      hasNextPage
      endCursor
    }
    edges {
      cursor
      node {
        id
        name
      }
    }
  }
}
```

### Cursor-Based Pagination

More efficient than offset-based for large datasets.

```graphql
# First page
query FirstPage {
  applications(first: 50) {
    pageInfo {
      hasNextPage
      endCursor  # "cursor_abc123"
    }
    edges {
      node {
        id
        name
      }
    }
  }
}

# Next page using cursor
query NextPage {
  applications(first: 50, after: "cursor_abc123") {
    pageInfo {
      hasNextPage
      endCursor  # "cursor_def456"
    }
    edges {
      node {
        id
        name
      }
    }
  }
}
```

**Benefits:**
- Consistent results even if data changes
- More efficient database queries
- Works with distributed databases

### Bidirectional Pagination
```graphql
query GetPage(
  $first: Int
  $after: String
  $last: Int
  $before: String
) {
  applications(
    first: $first
    after: $after
    last: $last
    before: $before
  ) {
    pageInfo {
      hasNextPage
      hasPreviousPage
      startCursor
      endCursor
    }
    edges {
      cursor
      node {
        id
        name
      }
    }
  }
}
```

## Field Selection Optimization

### Request Only Needed Fields

#### ❌ BAD: Over-Fetching
```graphql
query GetUserName($userId: ID!) {
  user(id: $userId) {
    id
    name
    email
    phone
    address
    preferences
    profile {
      avatar
      bio
      website
      socialLinks
    }
    posts {
      # ... lots more data
    }
    # Only using 'name' but fetching everything!
  }
}
```

#### ✅ GOOD: Precise Selection
```graphql
query GetUserName($userId: ID!) {
  user(id: $userId) {
    id
    name
    # Only fetch what's needed
  }
}
```

### Use Fragments Wisely

```graphql
# Create fragments for common needs
fragment UserListItem on User {
  id
  name
  avatar
  # Only fields needed for list view
}

fragment UserDetailView on User {
  ...UserListItem
  email
  bio
  createdAt
  # Additional fields for detail view
}

# Use appropriate fragment for context
query GetUserList($first: Int!) {
  users(first: $first) {
    edges {
      node {
        ...UserListItem  # Minimal data
      }
    }
  }
}

query GetUserDetail($userId: ID!) {
  user(id: $userId) {
    ...UserDetailView  # Full data
  }
}
```

## Batching and Caching

### Query Batching

Combine multiple queries in a single HTTP request.

```javascript
// Client-side batching with Apollo
import { ApolloClient, HttpLink } from '@apollo/client';
import { BatchHttpLink } from '@apollo/client/link/batch-http';

const link = new BatchHttpLink({
  uri: '/graphql',
  batchMax: 10, // Max 10 queries per batch
  batchInterval: 20, // Wait 20ms to batch
});

const client = new ApolloClient({ link });
```

### Parallel Queries

Use aliases to fetch multiple datasets in parallel.

```graphql
query GetDashboardData(
  $activeFilter: FilterInput!
  $retiredFilter: FilterInput!
  $inProgressFilter: FilterInput!
) {
  # Three parallel queries
  active: allFactSheets(filter: $activeFilter, first: 100) {
    totalCount
    edges {
      node {
        ...ApplicationCore
      }
    }
  }

  retired: allFactSheets(filter: $retiredFilter, first: 100) {
    totalCount
    edges {
      node {
        ...ApplicationCore
      }
    }
  }

  inProgress: allFactSheets(filter: $inProgressFilter, first: 100) {
    totalCount
    edges {
      node {
        ...ApplicationCore
      }
    }
  }
}
```

**Benefits:**
- Single HTTP request
- Queries execute in parallel on server
- Reduced network latency

### Client-Side Caching

#### Cache Normalization
```javascript
import { InMemoryCache } from '@apollo/client';

const cache = new InMemoryCache({
  typePolicies: {
    Application: {
      keyFields: ['id'],
      fields: {
        // Cache by ID
      },
    },
  },
});
```

#### Cache-First Strategy
```javascript
// Fetch from cache first, network as fallback
const { data } = useQuery(GET_APPLICATION, {
  variables: { id: '123' },
  fetchPolicy: 'cache-first', // Try cache first
});
```

#### Cache Invalidation
```javascript
// After mutation, update cache
const [updateApp] = useMutation(UPDATE_APPLICATION, {
  update(cache, { data: { updateApplication } }) {
    cache.modify({
      id: cache.identify(updateApplication.factSheet),
      fields: {
        displayName() {
          return updateApplication.factSheet.displayName;
        },
      },
    });
  },
});
```

## Server-Side Optimization

### DataLoader Pattern

Batch and cache requests within a single request context.

```javascript
import DataLoader from 'dataloader';

// Create loaders
const createLoaders = () => ({
  user: new DataLoader(async (ids) => {
    const users = await db.users.findByIds(ids);
    return ids.map(id => users.find(u => u.id === id));
  }),

  application: new DataLoader(async (ids) => {
    const apps = await db.applications.findByIds(ids);
    return ids.map(id => apps.find(a => a.id === id));
  }),
});

// Use in context
const server = new ApolloServer({
  context: () => ({
    loaders: createLoaders(),
  }),
  resolvers: {
    Query: {
      user: (_, { id }, { loaders }) =>
        loaders.user.load(id),
    },
    Application: {
      owner: (app, _, { loaders }) =>
        loaders.user.load(app.ownerId),
    },
  },
});
```

### Query Complexity Limits

```javascript
import { createComplexityLimitRule } from 'graphql-validation-complexity';

const server = new ApolloServer({
  validationRules: [
    depthLimit(7),                    // Max depth
    createComplexityLimitRule(1000),  // Max complexity
  ],
});
```

### Response Caching

```javascript
import responseCachePlugin from 'apollo-server-plugin-response-cache';

const server = new ApolloServer({
  plugins: [
    responseCachePlugin({
      sessionId: (ctx) => ctx.request.http.headers.get('session-id'),
    }),
  ],
});

// In schema
type Query {
  applications: [Application!]! @cacheControl(maxAge: 300)
  user(id: ID!): User @cacheControl(maxAge: 60)
}
```

### Persistent Queries

Only allow pre-approved queries from clients.

```javascript
const server = new ApolloServer({
  persistedQueries: {
    cache: new RedisCache({
      host: 'redis-server',
    }),
  },
});

// Client sends hash instead of full query
{
  "query": null,
  "queryId": "abc123hash",
  "variables": { "userId": "123" }
}
```

## Monitoring and Profiling

### Query Timing

```javascript
const server = new ApolloServer({
  plugins: [
    {
      requestDidStart() {
        const start = Date.now();
        return {
          willSendResponse() {
            const duration = Date.now() - start;
            console.log(`Query took ${duration}ms`);
          },
        };
      },
    },
  ],
});
```

### Apollo Studio Integration

```javascript
const server = new ApolloServer({
  apollo: {
    key: process.env.APOLLO_KEY,
    graphRef: 'my-graph@production',
  },
});
```

**Provides:**
- Query performance metrics
- Error tracking
- Schema change validation
- Query complexity analysis

## Performance Checklist

**Query Design:**
- [ ] Use pagination for all list queries
- [ ] Limit query depth (max 5-7 levels)
- [ ] Request only needed fields
- [ ] Use fragments to avoid duplication
- [ ] Avoid recursive queries

**Batching:**
- [ ] Use DataLoader on server
- [ ] Batch multiple queries client-side
- [ ] Use aliases for parallel queries
- [ ] Group related queries together

**Caching:**
- [ ] Implement cache normalization
- [ ] Use cache-first policy where appropriate
- [ ] Set appropriate cache TTLs
- [ ] Invalidate cache after mutations
- [ ] Use persisted queries for production

**Server Optimization:**
- [ ] Implement query complexity limits
- [ ] Set query depth limits
- [ ] Use DataLoader to prevent N+1
- [ ] Cache expensive operations
- [ ] Monitor query performance

**Network:**
- [ ] Enable compression (gzip)
- [ ] Use HTTP/2 when possible
- [ ] Batch HTTP requests
- [ ] Implement CDN caching for public data

## Common Performance Pitfalls

### 1. Over-Fetching
```graphql
# ❌ Fetching entire user object when only need name
query GetUserNames {
  users {
    id
    name
    email
    profile { ... }
    posts { ... }
    # Only using 'name'!
  }
}

# ✅ Fetch only what's needed
query GetUserNames {
  users {
    id
    name
  }
}
```

### 2. Missing Pagination
```graphql
# ❌ Unbounded query
query {
  allApplications {
    id
    name
  }
}

# ✅ Always paginate
query GetApplications($first: Int = 50, $after: String) {
  applications(first: $first, after: $after) {
    pageInfo { hasNextPage, endCursor }
    edges {
      node {
        id
        name
      }
    }
  }
}
```

### 3. Deep Nesting
```graphql
# ❌ Too deep
query {
  user {
    posts {
      comments {
        author {
          posts {
            comments {
              # Too deep!
            }
          }
        }
      }
    }
  }
}

# ✅ Shallow, focused queries
query GetUserPosts($userId: ID!) {
  user(id: $userId) {
    posts(first: 10) {
      edges {
        node {
          id
          title
          commentCount
        }
      }
    }
  }
}
```

### 4. Sequential Queries
```javascript
// ❌ BAD - Sequential (slow)
const user = await client.query(GET_USER, { id: '123' });
const posts = await client.query(GET_POSTS, { userId: '123' });
const comments = await client.query(GET_COMMENTS, { userId: '123' });

// ✅ GOOD - Parallel (fast)
const [user, posts, comments] = await Promise.all([
  client.query(GET_USER, { id: '123' }),
  client.query(GET_POSTS, { userId: '123' }),
  client.query(GET_COMMENTS, { userId: '123' }),
]);

// ✅ BETTER - Single query with aliases
const result = await client.query(GET_USER_DATA, {
  userId: '123',
  postsFirst: 10,
  commentsFirst: 20,
});
```

## Benchmarking Example

```javascript
// Measure query performance
const { performance } = require('perf_hooks');

async function benchmarkQuery(query, variables) {
  const iterations = 100;
  const times = [];

  for (let i = 0; i < iterations; i++) {
    const start = performance.now();
    await client.query({ query, variables });
    const end = performance.now();
    times.push(end - start);
  }

  const avg = times.reduce((a, b) => a + b) / times.length;
  const min = Math.min(...times);
  const max = Math.max(...times);

  console.log(`Average: ${avg.toFixed(2)}ms`);
  console.log(`Min: ${min.toFixed(2)}ms`);
  console.log(`Max: ${max.toFixed(2)}ms`);
}

// Benchmark different approaches
await benchmarkQuery(QUERY_WITH_FRAGMENTS, vars);
await benchmarkQuery(QUERY_WITHOUT_FRAGMENTS, vars);
```

## Summary

**Key Takeaways:**
- ✅ Always paginate list queries
- ✅ Limit query depth and complexity
- ✅ Request only needed fields
- ✅ Use DataLoader to prevent N+1 queries
- ✅ Implement caching at multiple levels
- ✅ Batch queries when possible
- ✅ Monitor query performance
- ✅ Use fragments for reusability
- ❌ Never fetch unbounded lists
- ❌ Avoid deeply nested queries
- ❌ Don't over-fetch data
- ❌ Don't ignore performance metrics

Performance optimization is about making smart trade-offs. Start with the basics (pagination, field selection) and add complexity (caching, batching) as needed.
