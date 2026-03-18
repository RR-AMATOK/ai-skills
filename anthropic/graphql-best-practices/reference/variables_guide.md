# GraphQL Variables: Complete Guide

Variables are the recommended way to pass dynamic values to GraphQL queries and mutations. This guide covers everything you need to know about using variables effectively.

## Why Variables?

### Security
```graphql
# ❌ DANGEROUS - Vulnerable to injection attacks
query {
  user(id: "${userInput}") {
    name
  }
}

# ✅ SAFE - Variables are properly sanitized
query GetUser($userId: ID!) {
  user(id: $userId) {
    name
  }
}
```

Variables are automatically:
- Type-checked by GraphQL
- Sanitized to prevent injection
- Validated against the schema

### Reusability
```javascript
// Same query, different inputs
const GET_USER = `
  query GetUser($userId: ID!) {
    user(id: $userId) {
      id
      name
      email
    }
  }
`;

// Use with different IDs
const user1 = await client.query(GET_USER, { userId: "123" });
const user2 = await client.query(GET_USER, { userId: "456" });
```

### Caching
```javascript
// Queries with same structure cache better
// Both queries below can use the same cache entry
await client.query(GET_USER, { userId: "123" });
await client.query(GET_USER, { userId: "456" });

// vs hardcoded queries that can't share cache
await client.query(`query { user(id: "123") { ... } }`);
await client.query(`query { user(id: "456") { ... } }`);
```

### Testing
```javascript
test('fetches user by ID', async () => {
  // Easy to test with different inputs
  const result = await executeQuery(GET_USER, { userId: 'test-123' });
  expect(result.user.name).toBe('Test User');
});

test('handles missing user', async () => {
  const result = await executeQuery(GET_USER, { userId: 'invalid' });
  expect(result.errors).toBeDefined();
});
```

## Variable Syntax

### Basic Structure
```graphql
query OperationName($variableName: Type) {
  field(argument: $variableName) {
    subfield
  }
}
```

### Complete Example
```graphql
query GetApplications(
  $first: Int!                    # Required integer
  $after: String                  # Optional string
  $includeInactive: Boolean = false  # Optional with default
) {
  applications(first: $first, after: $after) {
    edges {
      node {
        id
        name
        status @skip(if: $includeInactive)
      }
    }
  }
}
```

**Variables JSON:**
```json
{
  "first": 50,
  "after": "cursor123",
  "includeInactive": true
}
```

## Variable Types

### Scalar Types

#### String
```graphql
query SearchUsers($searchTerm: String!) {
  users(search: $searchTerm) {
    id
    name
  }
}
```
```json
{ "searchTerm": "john" }
```

#### Int
```graphql
query GetApplications($limit: Int = 10) {
  applications(first: $limit) {
    totalCount
  }
}
```
```json
{ "limit": 50 }
```

#### Float
```graphql
query GetHighScores($minScore: Float!) {
  items(minScore: $minScore) {
    id
    score
  }
}
```
```json
{ "minScore": 95.5 }
```

#### Boolean
```graphql
query GetUsers($activeOnly: Boolean!) {
  users(active: $activeOnly) {
    id
    name
  }
}
```
```json
{ "activeOnly": true }
```

#### ID
```graphql
query GetFactSheet($id: ID!) {
  factSheet(id: $id) {
    id
    displayName
  }
}
```
```json
{ "id": "550e8400-e29b-41d4-a716-446655440000" }
```

### Non-Null Types

The `!` suffix indicates a required (non-null) value.

```graphql
query GetUser(
  $userId: ID!        # Required - must provide
  $email: String      # Optional - can be null or omitted
) {
  user(id: $userId, email: $email) {
    id
    name
  }
}
```

```json
// ✅ Valid - userId provided
{ "userId": "123" }

// ✅ Valid - email is optional
{ "userId": "123", "email": "user@example.com" }

// ❌ Invalid - userId is required
{ "email": "user@example.com" }
```

### List Types

```graphql
query GetUsersByIds(
  $ids: [ID!]!        # Non-null list of non-null IDs
  $tags: [String!]    # Nullable list of non-null strings
  $filters: [String]  # Nullable list of nullable strings
) {
  users(ids: $ids, tags: $tags, filters: $filters) {
    id
    name
  }
}
```

**Type Breakdown:**
- `[ID!]!` - Required list, cannot contain null items
- `[String!]` - Optional list, but if provided, cannot contain null items
- `[String]` - Optional list, can contain null items

```json
{
  "ids": ["1", "2", "3"],           // ✅ Valid
  "tags": ["important", "review"],  // ✅ Valid
  "filters": ["active", null, ""]   // ✅ Valid (null allowed)
}
```

```json
{
  "ids": ["1", null, "3"],  // ❌ Invalid - null not allowed in [ID!]!
  "tags": null,             // ✅ Valid - [String!] itself can be null
  "filters": []             // ✅ Valid - empty list is fine
}
```

### Input Object Types

Input objects allow passing complex, structured data.

```graphql
# Schema definition
input CreateUserInput {
  name: String!
  email: String!
  age: Int
  preferences: UserPreferencesInput
}

input UserPreferencesInput {
  theme: String
  notifications: Boolean
  language: String
}

# Query using input object
mutation CreateUser($input: CreateUserInput!) {
  createUser(input: $input) {
    id
    name
    email
  }
}
```

**Variables:**
```json
{
  "input": {
    "name": "John Doe",
    "email": "john@example.com",
    "age": 30,
    "preferences": {
      "theme": "dark",
      "notifications": true,
      "language": "en"
    }
  }
}
```

### Enum Types

```graphql
enum UserRole {
  ADMIN
  USER
  GUEST
}

query GetUsersByRole($role: UserRole!) {
  users(role: $role) {
    id
    name
    role
  }
}
```

**Variables:**
```json
{
  "role": "ADMIN"
}
```

**Note:** Enums are passed as strings in JSON but are type-checked.

## Default Values

Variables can have default values for optional parameters.

```graphql
query GetApplications(
  $first: Int = 50                        # Default: 50
  $includeInactive: Boolean = false       # Default: false
  $sortBy: String = "name"                # Default: "name"
  $order: SortOrder = ASC                 # Default: ASC (enum)
) {
  applications(
    first: $first
    includeInactive: $includeInactive
    sortBy: $sortBy
    order: $order
  ) {
    totalCount
  }
}
```

**Usage:**
```json
// All defaults used
{}

// Override some defaults
{
  "first": 100,
  "includeInactive": true
}

// Override all
{
  "first": 25,
  "includeInactive": true,
  "sortBy": "createdAt",
  "order": "DESC"
}
```

## Advanced Patterns

### Multiple Variables
```graphql
query GetDashboardData(
  $userId: ID!
  $startDate: String!
  $endDate: String!
  $limit: Int = 100
  $includeArchived: Boolean = false
) {
  user(id: $userId) {
    id
    name
    applications(
      startDate: $startDate
      endDate: $endDate
      limit: $limit
      includeArchived: $includeArchived
    ) {
      edges {
        node {
          id
          name
        }
      }
    }
  }
}
```

### Nested Input Objects
```graphql
input FilterInput {
  facetFilters: [FacetFilterInput!]
  fullTextSearch: String
  dateRange: DateRangeInput
}

input FacetFilterInput {
  facetKey: String!
  keys: [String!]!
  operator: FilterOperator = AND
}

input DateRangeInput {
  start: String!
  end: String!
}

query GetFilteredFactSheets($filter: FilterInput!) {
  allFactSheets(filter: $filter) {
    totalCount
  }
}
```

**Variables:**
```json
{
  "filter": {
    "facetFilters": [
      {
        "facetKey": "FactSheetTypes",
        "keys": ["Application"]
      },
      {
        "facetKey": "lifecycle",
        "keys": ["active", "phaseIn"]
      }
    ],
    "fullTextSearch": "customer",
    "dateRange": {
      "start": "2024-01-01",
      "end": "2024-12-31"
    }
  }
}
```

### Dynamic Field Selection with Variables
```graphql
query GetUser(
  $userId: ID!
  $includeProfile: Boolean = false
  $includePosts: Boolean = false
  $includeComments: Boolean = false
) {
  user(id: $userId) {
    id
    name
    email

    # Conditionally include fields
    profile @include(if: $includeProfile) {
      avatar
      bio
      website
    }

    posts @include(if: $includePosts) {
      edges {
        node {
          id
          title
        }
      }
    }

    comments @skip(if: $includeComments) {
      totalCount
    }
  }
}
```

**Usage:**
```json
// Minimal data
{
  "userId": "123"
}

// With profile
{
  "userId": "123",
  "includeProfile": true
}

// Everything
{
  "userId": "123",
  "includeProfile": true,
  "includePosts": true,
  "includeComments": false
}
```

### Variables in Fragments
```graphql
query GetApplications($includeRelations: Boolean = false) {
  applications {
    edges {
      node {
        ...ApplicationInfo
      }
    }
  }
}

fragment ApplicationInfo on Application {
  id
  displayName
  lifecycle

  # Use variable in fragment
  relations @include(if: $includeRelations) {
    edges {
      node {
        id
        type
      }
    }
  }
}
```

## Variables in Mutations

### Create Mutation
```graphql
mutation CreateApplication($input: CreateApplicationInput!) {
  createApplication(input: $input) {
    factSheet {
      id
      displayName
      type
    }
    errors {
      field
      message
    }
  }
}
```

**Variables:**
```json
{
  "input": {
    "name": "Customer Portal",
    "type": "Application",
    "patches": [
      {
        "op": "add",
        "path": "/description",
        "value": "Main customer portal application"
      },
      {
        "op": "add",
        "path": "/alias",
        "value": "CUST-PORTAL"
      }
    ]
  }
}
```

### Update Mutation
```graphql
mutation UpdateFactSheet(
  $id: ID!
  $patches: [PatchInput!]!
  $comment: String
) {
  updateFactSheet(
    id: $id
    patches: $patches
    comment: $comment
  ) {
    factSheet {
      id
      displayName
      rev
      updatedAt
    }
  }
}
```

**Variables:**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "patches": [
    {
      "op": "replace",
      "path": "/description",
      "value": "Updated description"
    }
  ],
  "comment": "Updated via API"
}
```

### Batch Mutation
```graphql
mutation BatchUpdateApplications(
  $updates: [ApplicationUpdateInput!]!
) {
  batchUpdate(updates: $updates) {
    successful {
      id
      displayName
    }
    failed {
      id
      error
    }
  }
}
```

**Variables:**
```json
{
  "updates": [
    {
      "id": "app-1",
      "patches": [{ "op": "replace", "path": "/lifecycle", "value": "active" }]
    },
    {
      "id": "app-2",
      "patches": [{ "op": "replace", "path": "/lifecycle", "value": "phaseOut" }]
    },
    {
      "id": "app-3",
      "patches": [{ "op": "replace", "path": "/lifecycle", "value": "endOfLife" }]
    }
  ]
}
```

## Best Practices

### 1. Always Use Variables for Dynamic Values
```graphql
# ❌ BAD
query {
  user(id: "123") {
    name
  }
}

# ✅ GOOD
query GetUser($userId: ID!) {
  user(id: $userId) {
    name
  }
}
```

### 2. Provide Sensible Defaults
```graphql
query GetApplications(
  $first: Int = 50              # Reasonable page size
  $includeArchived: Boolean = false  # Most common case
  $sortOrder: SortOrder = ASC        # Expected default
) {
  applications(first: $first, includeArchived: $includeArchived, sortOrder: $sortOrder) {
    totalCount
  }
}
```

### 3. Use Non-Null for Required Fields
```graphql
query GetFactSheet(
  $id: ID!                    # Must provide
  $language: String = "en"    # Optional with default
) {
  factSheet(id: $id, language: $language) {
    id
  }
}
```

### 4. Group Related Variables in Input Objects
```graphql
# ❌ BAD - Too many individual parameters
mutation CreateUser(
  $name: String!
  $email: String!
  $age: Int
  $city: String
  $country: String
  $phone: String
) { }

# ✅ GOOD - Grouped in input object
mutation CreateUser($input: CreateUserInput!) { }
```

### 5. Use Descriptive Variable Names
```graphql
# ❌ BAD
query GetData($id: ID!, $n: Int, $f: Boolean) { }

# ✅ GOOD
query GetApplicationData(
  $applicationId: ID!
  $maxResults: Int
  $includeInactive: Boolean
) { }
```

### 6. Document Complex Variables
```graphql
query GetFilteredApplications(
  """
  Maximum number of results to return.
  Default: 50, Maximum: 100
  """
  $first: Int = 50

  """
  Cursor for pagination.
  Use endCursor from previous page's pageInfo.
  """
  $after: String

  """
  Complex filter object for fact sheet filtering.
  Supports facet filters, full-text search, and date ranges.
  """
  $filter: FilterInput
) {
  allFactSheets(first: $first, after: $after, filter: $filter) {
    # ...
  }
}
```

## Common Pitfalls

### 1. Forgetting Non-Null Indicator
```graphql
# ❌ Might accept null when you don't expect it
query GetUser($userId: ID) {
  user(id: $userId) {
    name
  }
}

# ✅ Explicitly require value
query GetUser($userId: ID!) {
  user(id: $userId) {
    name
  }
}
```

### 2. Incorrect List Types
```graphql
# [String]! - Non-null list, but can contain nulls
# [String!] - Nullable list, cannot contain nulls
# [String!]! - Non-null list, cannot contain nulls

query GetUsers($ids: [ID!]!) {  # ✅ Required list, no null items
  users(ids: $ids) {
    id
  }
}
```

### 3. Missing Default Values
```graphql
# ❌ Always requires client to provide
query GetApplications($limit: Int) { }

# ✅ Has sensible default
query GetApplications($limit: Int = 50) { }
```

### 4. Over-Complicated Input Objects
```graphql
# ❌ Too deeply nested
input FilterInput {
  level1: Level1Input
}
input Level1Input {
  level2: Level2Input
}
input Level2Input {
  level3: Level3Input
}

# ✅ Flatten when possible
input FilterInput {
  facetFilters: [FacetFilterInput!]
  searchTerm: String
  dateRange: DateRangeInput
}
```

## Testing with Variables

### Unit Testing
```javascript
import { executeQuery } from './graphql-client';

const GET_USER = `
  query GetUser($userId: ID!) {
    user(id: $userId) {
      id
      name
      email
    }
  }
`;

describe('GetUser Query', () => {
  test('fetches user with valid ID', async () => {
    const result = await executeQuery(GET_USER, {
      userId: 'test-user-123'
    });

    expect(result.data.user).toEqual({
      id: 'test-user-123',
      name: 'Test User',
      email: 'test@example.com'
    });
  });

  test('handles invalid ID', async () => {
    const result = await executeQuery(GET_USER, {
      userId: 'invalid-id'
    });

    expect(result.errors).toBeDefined();
    expect(result.errors[0].message).toContain('User not found');
  });

  test('validates required variable', async () => {
    // Missing required variable
    await expect(
      executeQuery(GET_USER, {})
    ).rejects.toThrow('Variable $userId is required');
  });
});
```

### Integration Testing
```javascript
describe('Application Queries', () => {
  test('fetches applications with pagination', async () => {
    const query = `
      query GetApplications($first: Int!, $after: String) {
        applications(first: $first, after: $after) {
          pageInfo {
            hasNextPage
            endCursor
          }
          edges {
            node {
              id
              displayName
            }
          }
        }
      }
    `;

    // First page
    const page1 = await executeQuery(query, { first: 10 });
    expect(page1.data.applications.edges).toHaveLength(10);
    expect(page1.data.applications.pageInfo.hasNextPage).toBe(true);

    // Second page using cursor
    const page2 = await executeQuery(query, {
      first: 10,
      after: page1.data.applications.pageInfo.endCursor
    });
    expect(page2.data.applications.edges).toHaveLength(10);
  });
});
```

## Summary

**Key Takeaways:**
- ✅ Always use variables for dynamic values
- ✅ Use `!` for required (non-null) types
- ✅ Provide sensible defaults for optional variables
- ✅ Use input objects for complex data structures
- ✅ Validate variable types match schema expectations
- ✅ Document complex variables with descriptions
- ✅ Test queries with different variable combinations
- ❌ Never hardcode values in queries
- ❌ Don't forget to handle missing required variables
- ❌ Avoid overly complex nested input objects

Variables make GraphQL queries secure, reusable, cacheable, and testable. They are fundamental to writing production-quality GraphQL code.
