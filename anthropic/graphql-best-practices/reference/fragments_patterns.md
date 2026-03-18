# GraphQL Fragments: Patterns and Best Practices

Fragments are a powerful feature in GraphQL that allow you to reuse common field selections across multiple queries. This guide covers fragment patterns, best practices, and advanced usage.

## What Are Fragments?

Fragments define reusable pieces of a GraphQL query. They help you:
- **DRY Principle**: Don't repeat field selections
- **Consistency**: Ensure same fields requested across queries
- **Maintainability**: Update fields in one place
- **Readability**: Give meaningful names to field sets
- **Composition**: Build complex queries from smaller pieces

## Basic Fragment Syntax

```graphql
fragment FragmentName on TypeName {
  field1
  field2
  nestedObject {
    field3
  }
}

query QueryName {
  someField {
    ...FragmentName
  }
}
```

## Simple Fragment Examples

### Basic User Information
```graphql
fragment UserBasicInfo on User {
  id
  name
  email
  createdAt
}

query GetAllUsers {
  users {
    edges {
      node {
        ...UserBasicInfo
      }
    }
  }
}

query GetUserById($userId: ID!) {
  user(id: $userId) {
    ...UserBasicInfo
    profile {
      avatar
      bio
    }
  }
}
```

**Benefits:**
- User fields defined once
- Consistent across all queries
- Easy to update (add/remove fields)

### Application Information
```graphql
fragment ApplicationCore on Application {
  id
  displayName
  alias
  description
  lifecycle
  businessCriticality
  technicalSuitability
}

query GetApplications($first: Int!) {
  allFactSheets(
    filter: {
      facetFilters: [
        { facetKey: "FactSheetTypes", keys: ["Application"] }
      ]
    }
    first: $first
  ) {
    edges {
      node {
        ...ApplicationCore
      }
    }
  }
}

query GetApplicationById($id: ID!) {
  factSheet(id: $id) {
    ... on Application {
      ...ApplicationCore
      tags {
        id
        name
      }
    }
  }
}
```

## Fragment Composition

Fragments can include other fragments for hierarchical composition.

### Nested Fragments
```graphql
# Base fragment
fragment UserBasic on User {
  id
  name
  email
}

# Extended fragment using base
fragment UserWithProfile on User {
  ...UserBasic
  profile {
    avatar
    bio
    website
  }
}

# Further extended fragment
fragment UserComplete on User {
  ...UserWithProfile
  preferences {
    theme
    language
    notifications
  }
  stats {
    postCount
    followerCount
  }
}

# Use in query
query GetUserProfile($userId: ID!) {
  user(id: $userId) {
    ...UserComplete
  }
}
```

### Application with Relations
```graphql
fragment FactSheetBasic on FactSheet {
  id
  displayName
  type
  description
}

fragment RelationInfo on Relation {
  id
  type
  description
  createdAt
}

fragment ITComponentBasic on ITComponent {
  ...FactSheetBasic
  category
  technicalSuitability
}

fragment ApplicationBasic on Application {
  ...FactSheetBasic
  alias
  lifecycle
  businessCriticality
}

fragment ApplicationWithComponents on Application {
  ...ApplicationBasic
  relApplicationToITComponent {
    edges {
      node {
        ...RelationInfo
        factSheet {
          ...ITComponentBasic
        }
      }
    }
  }
}

query GetApplicationLandscape($first: Int!) {
  allFactSheets(
    filter: {
      facetFilters: [
        { facetKey: "FactSheetTypes", keys: ["Application"] }
      ]
    }
    first: $first
  ) {
    edges {
      node {
        ...ApplicationWithComponents
      }
    }
  }
}
```

## Inline Fragments (Type Conditions)

Use inline fragments to handle different types in union or interface fields.

### Basic Inline Fragments
```graphql
query GetSearchResults($query: String!) {
  search(query: $query) {
    # Common interface fields
    __typename
    id

    # Type-specific fields
    ... on Application {
      displayName
      alias
      lifecycle
    }

    ... on ITComponent {
      displayName
      category
      technicalSuitability
    }

    ... on BusinessCapability {
      displayName
      level
      parentCapability {
        id
        displayName
      }
    }
  }
}
```

### Combining Named and Inline Fragments
```graphql
fragment ApplicationFields on Application {
  alias
  lifecycle
  businessCriticality
}

fragment ITComponentFields on ITComponent {
  category
  technicalSuitability
  hostingType
}

query GetAllFactSheets($first: Int!) {
  allFactSheets(first: $first) {
    edges {
      node {
        # Common fields
        id
        displayName
        description

        # Type-specific fields using fragments
        ...ApplicationFields
        ...ITComponentFields

        # Type-specific inline fragment
        ... on Interface {
          protocol
          dataFormat
          integrationPattern
        }
      }
    }
  }
}
```

## Advanced Fragment Patterns

### Conditional Fragments with Directives
```graphql
fragment UserProfile on User {
  avatar
  bio
  website
  socialLinks {
    platform
    url
  }
}

fragment UserStats on User {
  postCount
  followerCount
  followingCount
  lastActive
}

query GetUser(
  $userId: ID!
  $includeProfile: Boolean = false
  $includeStats: Boolean = false
) {
  user(id: $userId) {
    id
    name
    email

    # Conditionally include fragment
    ...UserProfile @include(if: $includeProfile)
    ...UserStats @include(if: $includeStats)
  }
}
```

### Fragment Variables (Advanced)
```graphql
# Fragments can use variables from the query
fragment UserPosts on User {
  posts(first: $postsLimit, status: $postStatus) {
    edges {
      node {
        id
        title
        publishedAt
      }
    }
  }
}

query GetUserWithPosts(
  $userId: ID!
  $postsLimit: Int = 10
  $postStatus: PostStatus = PUBLISHED
) {
  user(id: $userId) {
    id
    name
    ...UserPosts
  }
}
```

### Recursive Fragments (Careful!)
```graphql
# For tree structures like org hierarchies
fragment OrgUnit on OrganizationalUnit {
  id
  name
  level

  # Recursive - get children (limit depth!)
  children(first: 10) {
    edges {
      node {
        id
        name
        level

        # Go one more level
        children(first: 10) {
          edges {
            node {
              id
              name
              level
            }
          }
        }
      }
    }
  }
}

query GetOrgHierarchy($rootId: ID!) {
  organizationalUnit(id: $rootId) {
    ...OrgUnit
  }
}
```

**⚠️ Warning:** Be cautious with recursive fragments - they can create deep queries that impact performance.

## Fragment Best Practices

### 1. Name Fragments Descriptively
```graphql
# ❌ BAD - Vague names
fragment A on User { }
fragment UserFrag on User { }
fragment Data on Application { }

# ✅ GOOD - Clear, descriptive names
fragment UserBasicInfo on User { }
fragment ApplicationCoreFields on Application { }
fragment RelationWithFactSheet on Relation { }
```

### 2. Keep Fragments Focused
```graphql
# ❌ BAD - Too much in one fragment
fragment UserEverything on User {
  id
  name
  email
  profile { ... }
  posts { ... }
  comments { ... }
  followers { ... }
  preferences { ... }
  stats { ... }
  history { ... }
}

# ✅ GOOD - Focused, composable fragments
fragment UserBasic on User {
  id
  name
  email
}

fragment UserProfile on User {
  profile {
    avatar
    bio
    website
  }
}

fragment UserStats on User {
  stats {
    postCount
    followerCount
  }
}

# Compose as needed
query GetUserProfile($userId: ID!) {
  user(id: $userId) {
    ...UserBasic
    ...UserProfile
    ...UserStats
  }
}
```

### 3. Use Fragment Composition
```graphql
# Build from simple to complex
fragment PersonName on Person {
  firstName
  lastName
  fullName
}

fragment PersonContact on Person {
  email
  phone
  address {
    street
    city
    country
  }
}

fragment PersonBasic on Person {
  ...PersonName
  ...PersonContact
  createdAt
}

fragment PersonComplete on Person {
  ...PersonBasic
  profile { ... }
  preferences { ... }
}
```

### 4. Fragments for Pagination
```graphql
fragment PageInfo on PageInfo {
  hasNextPage
  hasPreviousPage
  startCursor
  endCursor
}

fragment ApplicationConnection on ApplicationConnection {
  totalCount
  pageInfo {
    ...PageInfo
  }
  edges {
    cursor
    node {
      ...ApplicationCore
    }
  }
}

query GetApplications($first: Int!, $after: String) {
  applications(first: $first, after: $after) {
    ...ApplicationConnection
  }
}
```

### 5. Fragments for Error Handling
```graphql
fragment ErrorInfo on Error {
  message
  code
  field
  path
}

fragment MutationResponse on MutationResponse {
  success
  errors {
    ...ErrorInfo
  }
}

mutation CreateApplication($input: CreateApplicationInput!) {
  createApplication(input: $input) {
    ...MutationResponse
    factSheet {
      ...ApplicationCore
    }
  }
}
```

## Common Patterns

### Pattern 1: Dashboard Data Fragment
```graphql
fragment DashboardMetrics on Dashboard {
  totalApplications
  activeApplications
  retiredApplications
  lifecycleDistribution {
    phase
    count
    percentage
  }
}

fragment DashboardCharts on Dashboard {
  businessCriticalityChart {
    category
    value
  }
  technicalDebtChart {
    category
    value
  }
}

query GetDashboard {
  dashboard {
    ...DashboardMetrics
    ...DashboardCharts
    lastUpdated
  }
}
```

### Pattern 2: Relation Traversal Fragment
```graphql
fragment RelationEdge on RelationEdge {
  cursor
  node {
    id
    type
    description
  }
}

fragment ApplicationRelations on Application {
  # IT Components
  relApplicationToITComponent(first: 20) {
    edges {
      ...RelationEdge
      node {
        factSheet {
          ...ITComponentBasic
        }
      }
    }
  }

  # Business Capabilities
  relApplicationToBusinessCapability(first: 10) {
    edges {
      ...RelationEdge
      node {
        factSheet {
          ...BusinessCapabilityBasic
        }
      }
    }
  }
}

query GetApplicationWithRelations($id: ID!) {
  factSheet(id: $id) {
    ... on Application {
      ...ApplicationBasic
      ...ApplicationRelations
    }
  }
}
```

### Pattern 3: Multi-Type Search Fragment
```graphql
fragment SearchResultBase on SearchResult {
  __typename
  id
  displayName
  type
  score
}

fragment ApplicationSearchResult on Application {
  ...SearchResultBase
  alias
  lifecycle
}

fragment ITComponentSearchResult on ITComponent {
  ...SearchResultBase
  category
}

fragment InterfaceSearchResult on Interface {
  ...SearchResultBase
  protocol
}

query Search($query: String!, $first: Int = 20) {
  search(query: $query, first: $first) {
    edges {
      node {
        ...ApplicationSearchResult
        ...ITComponentSearchResult
        ...InterfaceSearchResult
      }
    }
  }
}
```

### Pattern 4: Audit Trail Fragment
```graphql
fragment AuditInfo on Auditable {
  createdAt
  createdBy {
    id
    name
    email
  }
  updatedAt
  updatedBy {
    id
    name
    email
  }
}

fragment FactSheetWithAudit on FactSheet {
  id
  displayName
  ...AuditInfo
  revisions(first: 5) {
    edges {
      node {
        rev
        timestamp
        author {
          id
          name
        }
        changes {
          field
          oldValue
          newValue
        }
      }
    }
  }
}
```

## Fragment Organization

### File Structure
```
src/graphql/
├── fragments/
│   ├── application.graphql
│   ├── user.graphql
│   ├── relation.graphql
│   ├── pagination.graphql
│   └── common.graphql
├── queries/
│   ├── getApplications.graphql
│   └── getUsers.graphql
└── mutations/
    ├── createApplication.graphql
    └── updateApplication.graphql
```

### Example: application.graphql
```graphql
# Core application fields
fragment ApplicationCore on Application {
  id
  displayName
  alias
  description
  lifecycle
  businessCriticality
  technicalSuitability
}

# Application with tags
fragment ApplicationWithTags on Application {
  ...ApplicationCore
  tags {
    id
    name
    color
  }
}

# Application with immediate relations
fragment ApplicationWithRelations on Application {
  ...ApplicationCore
  relApplicationToITComponent(first: 20) {
    edges {
      node {
        ...RelationInfo
        factSheet {
          ...ITComponentBasic
        }
      }
    }
  }
}

# Full application data
fragment ApplicationComplete on Application {
  ...ApplicationWithRelations
  ...ApplicationWithTags
  ...AuditInfo
}
```

## Testing with Fragments

### Unit Tests
```javascript
import { ApplicationCore, ApplicationWithTags } from './fragments/application';
import { GET_APPLICATION } from './queries/getApplication';

describe('Application Fragments', () => {
  test('ApplicationCore includes all core fields', () => {
    const query = `
      query {
        factSheet(id: "test-id") {
          ...ApplicationCore
        }
      }
      ${ApplicationCore}
    `;

    const result = executeQuery(query);

    expect(result.data.factSheet).toHaveProperty('id');
    expect(result.data.factSheet).toHaveProperty('displayName');
    expect(result.data.factSheet).toHaveProperty('lifecycle');
  });

  test('Fragment composition works correctly', () => {
    const query = `
      query {
        factSheet(id: "test-id") {
          ...ApplicationWithTags
        }
      }
      ${ApplicationWithTags}
      ${ApplicationCore}
    `;

    const result = executeQuery(query);

    expect(result.data.factSheet).toHaveProperty('displayName'); // from Core
    expect(result.data.factSheet).toHaveProperty('tags'); // from WithTags
  });
});
```

## Common Pitfalls

### 1. Fragment Cycles
```graphql
# ❌ BAD - Circular dependency
fragment A on TypeA {
  ...B
}

fragment B on TypeB {
  ...A  # Circular!
}

# ✅ GOOD - Break the cycle
fragment A on TypeA {
  fieldFromB {
    ...BFields
  }
}

fragment BFields on TypeB {
  field1
  field2
}
```

### 2. Over-Fragmentation
```graphql
# ❌ BAD - Too many tiny fragments
fragment UserId on User { id }
fragment UserName on User { name }
fragment UserEmail on User { email }

# ✅ GOOD - Reasonable granularity
fragment UserBasic on User {
  id
  name
  email
}
```

### 3. Type Mismatch
```graphql
# ❌ BAD - Fragment type doesn't match
fragment UserInfo on User {
  id
  name
}

query {
  application {  # Application type, not User!
    ...UserInfo  # Error!
  }
}

# ✅ GOOD - Matching types
fragment ApplicationInfo on Application {
  id
  displayName
}

query {
  application {
    ...ApplicationInfo
  }
}
```

### 4. Unused Fragments
```graphql
# ❌ BAD - Defined but never used
fragment UnusedFragment on User {
  field1
  field2
}

query GetUsers {
  users {
    id
    name
    # ...UnusedFragment not included
  }
}

# ✅ GOOD - Remove unused fragments
query GetUsers {
  users {
    id
    name
  }
}
```

## Summary

**Key Takeaways:**
- ✅ Use fragments to avoid duplicating field selections
- ✅ Name fragments descriptively (UserBasicInfo, not UserFrag)
- ✅ Keep fragments focused and composable
- ✅ Use inline fragments for union/interface types
- ✅ Organize fragments in separate files by domain
- ✅ Compose complex fragments from simpler ones
- ✅ Test fragments independently
- ❌ Avoid circular fragment dependencies
- ❌ Don't over-fragment (balance granularity)
- ❌ Don't define unused fragments

Fragments are essential for maintainable GraphQL code. They promote reusability, consistency, and make complex queries easier to understand and modify.
