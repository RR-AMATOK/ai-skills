# GraphQL Security Best Practices

Security is critical when exposing GraphQL APIs. This guide covers common vulnerabilities, attack vectors, and best practices for securing GraphQL applications.

## Core Security Principles

1. **Never Trust Client Input** - Validate everything
2. **Implement Authentication** - Know who is making requests
3. **Enforce Authorization** - Control what users can access
4. **Limit Query Complexity** - Prevent resource exhaustion attacks
5. **Rate Limiting** - Protect against abuse
6. **Input Validation** - Sanitize and validate all inputs
7. **Audit and Monitor** - Track suspicious activity

## Common GraphQL Vulnerabilities

### 1. Query Depth Attack (DoS)

Malicious queries with deep nesting can overwhelm the server.

#### Attack Example
```graphql
query MaliciousDeepQuery {
  user {
    posts {
      comments {
        author {
          posts {
            comments {
              author {
                posts {
                  comments {
                    # ... infinitely deep
                  }
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

#### Defense: Limit Query Depth
```javascript
import depthLimit from 'graphql-depth-limit';

const server = new ApolloServer({
  validationRules: [
    depthLimit(
      7, // Max depth
      { ignore: ['_internal', 'pageInfo'] } // Ignore certain fields
    ),
  ],
});
```

### 2. Query Complexity Attack (DoS)

Expensive queries can exhaust server resources.

#### Attack Example
```graphql
query ExpensiveQuery {
  # Request 10,000 users
  users(first: 10000) {
    edges {
      node {
        # Each with 1,000 posts
        posts(first: 1000) {
          edges {
            node {
              # Each with 1,000 comments
              comments(first: 1000) {
                edges {
                  node {
                    id
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
# Total: 10,000 * 1,000 * 1,000 = 10 billion records!
```

#### Defense: Complexity Analysis
```javascript
import { createComplexityLimitRule } from 'graphql-validation-complexity';

const server = new ApolloServer({
  validationRules: [
    createComplexityLimitRule(1000, {
      onCost: (cost) => {
        console.log('Query cost:', cost);
      },
      createError: (cost, node) => {
        return new GraphQLError(
          `Query too complex: ${cost}. Maximum allowed: 1000`
        );
      },
      scalarCost: 1,
      objectCost: 5,
      listFactor: 10,
    }),
  ],
});
```

#### Assign Field Costs
```graphql
type Query {
  # Simple field
  user(id: ID!): User @cost(complexity: 1)

  # List field with multiplier
  users(first: Int!): [User!]! @cost(complexity: 5, multipliers: ["first"])

  # Expensive operation
  generateReport: Report @cost(complexity: 100)
}
```

### 3. Batch Attack

Sending many queries in a single request.

#### Attack Example
```javascript
// 1000 queries in one request!
const batchedQueries = [];
for (let i = 0; i < 1000; i++) {
  batchedQueries.push({
    query: EXPENSIVE_QUERY,
    variables: { id: i }
  });
}

fetch('/graphql', {
  method: 'POST',
  body: JSON.stringify(batchedQueries)
});
```

#### Defense: Limit Batch Size
```javascript
const server = new ApolloServer({
  // Disable batching
  allowBatchedHttpRequests: false,
});

// Or limit batch size
app.use('/graphql', (req, res, next) => {
  if (Array.isArray(req.body) && req.body.length > 10) {
    return res.status(400).json({
      error: 'Batch size limited to 10 queries'
    });
  }
  next();
});
```

### 4. Introspection Abuse

Attackers use introspection to map your schema and find vulnerabilities.

#### Disable in Production
```javascript
const server = new ApolloServer({
  introspection: process.env.NODE_ENV !== 'production',
  playground: process.env.NODE_ENV !== 'production',
});
```

#### Or Require Authentication
```javascript
const server = new ApolloServer({
  plugins: [
    {
      requestDidStart() {
        return {
          didResolveOperation({ request, context }) {
            // Only allow introspection for authenticated admins
            if (
              request.operationName === 'IntrospectionQuery' &&
              !context.user?.isAdmin
            ) {
              throw new GraphQLError('Introspection disabled');
            }
          },
        };
      },
    },
  ],
});
```

### 5. SQL Injection via Variables

GraphQL doesn't prevent SQL injection in resolvers.

#### ❌ Vulnerable Code
```javascript
const resolvers = {
  Query: {
    user: async (_, { id }) => {
      // DANGEROUS - SQL injection possible!
      const query = `SELECT * FROM users WHERE id = '${id}'`;
      return db.query(query);
    },
  },
};
```

**Attack:**
```json
{
  "id": "1' OR '1'='1"
}
```

#### ✅ Safe Code - Use Parameterized Queries
```javascript
const resolvers = {
  Query: {
    user: async (_, { id }) => {
      // Safe - parameterized query
      return db.query('SELECT * FROM users WHERE id = ?', [id]);
    },
  },
};
```

## Authentication & Authorization

### Authentication: Verify Identity

#### JWT Token Authentication
```javascript
import jwt from 'jsonwebtoken';

const server = new ApolloServer({
  context: ({ req }) => {
    // Get token from header
    const token = req.headers.authorization?.replace('Bearer ', '');

    if (!token) {
      return { user: null };
    }

    try {
      // Verify and decode token
      const user = jwt.verify(token, process.env.JWT_SECRET);
      return { user };
    } catch (error) {
      console.error('Invalid token:', error);
      return { user: null };
    }
  },
});
```

#### Require Authentication
```javascript
const resolvers = {
  Query: {
    me: (_, __, { user }) => {
      // Require authentication
      if (!user) {
        throw new GraphQLError('Not authenticated', {
          extensions: { code: 'UNAUTHENTICATED' },
        });
      }
      return user;
    },
  },
};
```

### Authorization: Control Access

#### Field-Level Authorization
```javascript
const resolvers = {
  User: {
    email: (user, _, { user: currentUser }) => {
      // Only show email to self or admins
      if (user.id !== currentUser?.id && !currentUser?.isAdmin) {
        throw new GraphQLError('Not authorized', {
          extensions: { code: 'FORBIDDEN' },
        });
      }
      return user.email;
    },

    salary: (user, _, { user: currentUser }) => {
      // Only HR can see salaries
      if (!currentUser?.roles.includes('HR')) {
        return null; // Or throw error
      }
      return user.salary;
    },
  },

  Query: {
    users: (_, __, { user }) => {
      // Only admins can list all users
      if (!user?.isAdmin) {
        throw new GraphQLError('Admin access required', {
          extensions: { code: 'FORBIDDEN' },
        });
      }
      return db.users.findAll();
    },
  },

  Mutation: {
    deleteUser: async (_, { id }, { user }) => {
      // Only admins or self can delete
      if (!user?.isAdmin && user?.id !== id) {
        throw new GraphQLError('Not authorized', {
          extensions: { code: 'FORBIDDEN' },
        });
      }
      return db.users.delete(id);
    },
  },
};
```

#### Directive-Based Authorization
```graphql
directive @auth(requires: Role = USER) on FIELD_DEFINITION | OBJECT

enum Role {
  USER
  ADMIN
  HR
}

type Query {
  me: User @auth(requires: USER)
  users: [User!]! @auth(requires: ADMIN)
  salaries: [Salary!]! @auth(requires: HR)
}

type Mutation {
  deleteUser(id: ID!): Boolean @auth(requires: ADMIN)
}
```

```javascript
// Directive implementation
class AuthDirective extends SchemaDirectiveVisitor {
  visitFieldDefinition(field) {
    const { resolve = defaultFieldResolver } = field;
    const requiredRole = this.args.requires;

    field.resolve = async function (...args) {
      const context = args[2];
      const { user } = context;

      if (!user) {
        throw new GraphQLError('Not authenticated');
      }

      if (!user.roles.includes(requiredRole)) {
        throw new GraphQLError('Not authorized');
      }

      return resolve.apply(this, args);
    };
  }
}
```

## Input Validation & Sanitization

### Validate All Inputs

#### Schema Validation
```graphql
input CreateUserInput {
  name: String! @constraint(minLength: 2, maxLength: 100)
  email: String! @constraint(format: "email")
  age: Int @constraint(min: 18, max: 120)
  username: String! @constraint(pattern: "^[a-zA-Z0-9_]+$")
}
```

#### Resolver Validation
```javascript
import validator from 'validator';
import { z } from 'zod';

const CreateUserSchema = z.object({
  name: z.string().min(2).max(100),
  email: z.string().email(),
  age: z.number().int().min(18).max(120).optional(),
  username: z.string().regex(/^[a-zA-Z0-9_]+$/),
});

const resolvers = {
  Mutation: {
    createUser: async (_, { input }) => {
      // Validate input
      try {
        const validated = CreateUserSchema.parse(input);
      } catch (error) {
        throw new GraphQLError('Validation failed', {
          extensions: {
            code: 'BAD_USER_INPUT',
            validationErrors: error.errors,
          },
        });
      }

      // Additional validation
      if (!validator.isEmail(input.email)) {
        throw new GraphQLError('Invalid email format');
      }

      // Sanitize
      const sanitized = {
        name: validator.escape(input.name),
        email: validator.normalizeEmail(input.email),
        username: validator.escape(input.username),
        age: input.age,
      };

      return db.users.create(sanitized);
    },
  },
};
```

### Prevent XSS

#### Sanitize HTML Input
```javascript
import DOMPurify from 'isomorphic-dompurify';

const resolvers = {
  Mutation: {
    createPost: async (_, { input }) => {
      // Sanitize HTML content
      const sanitized = {
        title: validator.escape(input.title),
        content: DOMPurify.sanitize(input.content, {
          ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'p', 'br'],
          ALLOWED_ATTR: [],
        }),
      };

      return db.posts.create(sanitized);
    },
  },
};
```

## Rate Limiting

### Request-Based Rate Limiting
```javascript
import rateLimit from 'express-rate-limit';

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Max 100 requests per window
  message: 'Too many requests, please try again later',
  standardHeaders: true,
  legacyHeaders: false,
});

app.use('/graphql', limiter);
```

### Query Cost-Based Rate Limiting
```javascript
import { RateLimiterMemory } from 'rate-limiter-flexible';

const rateLimiter = new RateLimiterMemory({
  points: 1000, // 1000 points
  duration: 60, // Per 60 seconds
});

const server = new ApolloServer({
  plugins: [
    {
      requestDidStart: () => ({
        didResolveOperation: async ({ request, context }) => {
          const cost = calculateQueryCost(request); // Calculate cost
          const userId = context.user?.id || context.ip;

          try {
            await rateLimiter.consume(userId, cost);
          } catch (error) {
            throw new GraphQLError('Rate limit exceeded', {
              extensions: {
                code: 'RATE_LIMIT_EXCEEDED',
                retryAfter: error.msBeforeNext / 1000,
              },
            });
          }
        },
      }),
    },
  ],
});
```

### Per-Field Rate Limiting
```javascript
const resolvers = {
  Mutation: {
    sendEmail: async (_, { input }, { user, rateLimiters }) => {
      const key = `sendEmail:${user.id}`;

      try {
        await rateLimiters.email.consume(key, 1);
      } catch (error) {
        throw new GraphQLError('Email rate limit exceeded', {
          extensions: {
            code: 'RATE_LIMIT_EXCEEDED',
            retryAfter: error.msBeforeNext / 1000,
          },
        });
      }

      return sendEmail(input);
    },
  },
};
```

## Timeout Protection

### Query Timeout
```javascript
const server = new ApolloServer({
  plugins: [
    {
      requestDidStart: () => {
        const timeout = setTimeout(() => {
          throw new GraphQLError('Query timeout');
        }, 5000); // 5 second timeout

        return {
          willSendResponse: () => {
            clearTimeout(timeout);
          },
        };
      },
    },
  ],
});
```

## Secure Error Handling

### Don't Leak Sensitive Information

#### ❌ BAD: Exposing Internal Details
```javascript
const resolvers = {
  Query: {
    user: async (_, { id }) => {
      try {
        return await db.query('SELECT * FROM users WHERE id = ?', [id]);
      } catch (error) {
        // Exposes database structure!
        throw new Error(error.message);
      }
    },
  },
};
```

#### ✅ GOOD: Generic Error Messages
```javascript
const resolvers = {
  Query: {
    user: async (_, { id }) => {
      try {
        return await db.query('SELECT * FROM users WHERE id = ?', [id]);
      } catch (error) {
        // Log internally
        console.error('Database error:', error);

        // Return generic message to client
        throw new GraphQLError('Failed to fetch user', {
          extensions: {
            code: 'INTERNAL_SERVER_ERROR',
          },
        });
      }
    },
  },
};
```

### Production Error Formatting
```javascript
const server = new ApolloServer({
  formatError: (error) => {
    // Log full error server-side
    console.error('GraphQL Error:', error);

    // In production, hide internal errors
    if (process.env.NODE_ENV === 'production') {
      // Don't expose internal errors
      if (error.extensions?.code === 'INTERNAL_SERVER_ERROR') {
        return {
          message: 'An error occurred',
          extensions: {
            code: 'INTERNAL_SERVER_ERROR',
          },
        };
      }
    }

    // Return safe errors
    return {
      message: error.message,
      extensions: error.extensions,
    };
  },
});
```

## Persisted Queries

Only allow pre-approved queries in production.

### Server Setup
```javascript
import { RedisCache } from 'apollo-server-cache-redis';

const server = new ApolloServer({
  persistedQueries: {
    cache: new RedisCache({
      host: 'redis-server',
    }),
  },
});
```

### Whitelist Only
```javascript
const approvedQueries = new Map([
  ['getUser', GET_USER_QUERY],
  ['getApplications', GET_APPLICATIONS_QUERY],
  // ... pre-approved queries
]);

const server = new ApolloServer({
  plugins: [
    {
      requestDidStart: ({ request }) => ({
        didResolveOperation: () => {
          if (process.env.NODE_ENV === 'production') {
            const queryId = request.extensions?.persistedQuery?.sha256Hash;

            if (!queryId || !approvedQueries.has(queryId)) {
              throw new GraphQLError('Query not approved', {
                extensions: { code: 'QUERY_NOT_ALLOWED' },
              });
            }
          }
        },
      }),
    },
  ],
});
```

## CORS Configuration

```javascript
const server = new ApolloServer({
  cors: {
    origin: process.env.ALLOWED_ORIGINS?.split(',') || ['http://localhost:3000'],
    credentials: true,
  },
});
```

## Audit Logging

```javascript
const server = new ApolloServer({
  plugins: [
    {
      requestDidStart: ({ request, context }) => {
        const startTime = Date.now();

        return {
          willSendResponse: ({ response }) => {
            const duration = Date.now() - startTime;

            // Log all operations
            auditLog.info({
              operation: request.operationName,
              query: request.query,
              variables: request.variables,
              user: context.user?.id,
              ip: context.ip,
              duration,
              errors: response.errors?.length || 0,
              timestamp: new Date().toISOString(),
            });

            // Alert on suspicious activity
            if (duration > 5000 || response.errors?.length > 0) {
              securityAlert.warn({
                operation: request.operationName,
                user: context.user?.id,
                issue: 'Slow query or errors',
              });
            }
          },
        };
      },
    },
  ],
});
```

## Security Checklist

**Authentication & Authorization:**
- [ ] Implement authentication (JWT, OAuth, etc.)
- [ ] Verify auth token on every request
- [ ] Implement field-level authorization
- [ ] Use role-based access control (RBAC)
- [ ] Protect sensitive fields

**Query Protection:**
- [ ] Limit query depth (max 5-7 levels)
- [ ] Implement query complexity analysis
- [ ] Set maximum query cost
- [ ] Limit pagination size (max 100-1000)
- [ ] Disable batching or limit batch size

**Input Validation:**
- [ ] Validate all inputs server-side
- [ ] Sanitize user input
- [ ] Use parameterized queries (prevent SQL injection)
- [ ] Validate file uploads
- [ ] Check input length limits

**Rate Limiting:**
- [ ] Implement request-based rate limiting
- [ ] Implement cost-based rate limiting
- [ ] Rate limit per user/IP
- [ ] Rate limit expensive operations
- [ ] Return retry-after headers

**Production Security:**
- [ ] Disable introspection in production
- [ ] Disable GraphQL Playground in production
- [ ] Use persisted queries
- [ ] Implement CORS properly
- [ ] Use HTTPS only
- [ ] Set security headers

**Error Handling:**
- [ ] Don't expose internal errors
- [ ] Log errors securely
- [ ] Return generic error messages
- [ ] Use error codes, not detailed messages
- [ ] Monitor error rates

**Monitoring:**
- [ ] Log all operations
- [ ] Track query performance
- [ ] Monitor failed authentications
- [ ] Alert on suspicious activity
- [ ] Regular security audits

## Summary

**Key Takeaways:**
- ✅ Authenticate and authorize every request
- ✅ Limit query depth and complexity
- ✅ Validate and sanitize all inputs
- ✅ Implement rate limiting
- ✅ Use parameterized queries
- ✅ Disable introspection in production
- ✅ Log and monitor all activity
- ✅ Use HTTPS and secure headers
- ❌ Never trust client input
- ❌ Don't expose internal errors
- ❌ Never concatenate user input in queries
- ❌ Don't allow unlimited query depth

GraphQL security requires defense in depth. Implement multiple layers of protection to secure your API against various attack vectors.
