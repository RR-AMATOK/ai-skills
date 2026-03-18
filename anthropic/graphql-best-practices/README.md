# GraphQL Best Practices Skill

A comprehensive Claude Code skill for writing clean, maintainable GraphQL queries and mutations following industry best practices and clean code principles.

## Overview

This skill provides expert guidance on modern GraphQL development:

- **Variables**: Proper use of GraphQL variables for dynamic, secure queries
- **Clean Code**: Writing maintainable, readable GraphQL operations
- **Fragments**: Creating reusable query components
- **Naming Conventions**: Industry-standard naming patterns
- **Performance**: Optimization techniques for efficient queries
- **Security**: Protecting against common GraphQL vulnerabilities
- **Error Handling**: Robust error handling patterns
- **Testing**: Writing testable GraphQL operations

## Skill Activation

This skill is automatically activated when you mention:
- GraphQL best practices
- GraphQL variables
- GraphQL query patterns
- GraphQL clean code
- GraphQL fragments
- GraphQL optimization

## Core Principles

### 1. **Always Use Variables**
Never hardcode values in queries. Variables provide:
- Security (prevent injection)
- Reusability
- Type safety
- Better caching
- Easier testing

### 2. **Request Only What You Need**
GraphQL's superpower is precise data fetching. Avoid over-fetching by selecting only required fields.

### 3. **Use Fragments for Reusability**
DRY (Don't Repeat Yourself) principle applies to GraphQL. Use fragments to avoid duplication.

### 4. **Follow Naming Conventions**
- **Operations**: PascalCase (GetUserProfile)
- **Fields/Variables**: camelCase (userId, displayName)
- **Input Types**: Descriptive suffixes (CreateUserInput)
- **Booleans**: is/has/can prefix (isActive, hasAccess)

### 5. **Always Paginate Lists**
Never fetch unbounded lists. Always use pagination with `first`, `after`, and `pageInfo`.

### 6. **Handle Errors Gracefully**
GraphQL returns 200 even with errors. Always check the `errors` array.

## Key Topics Covered

### Variables Usage
```graphql
# ✅ GOOD - Using variables
query GetUser($userId: ID!, $includeProfile: Boolean = false) {
  user(id: $userId) {
    id
    name
    profile @include(if: $includeProfile) {
      avatar
      bio
    }
  }
}
```

**Variables JSON:**
```json
{
  "userId": "123",
  "includeProfile": true
}
```

### Fragments for Reusability
```graphql
fragment UserBasicInfo on User {
  id
  name
  email
  createdAt
}

query GetUsers($first: Int!) {
  users(first: $first) {
    edges {
      node {
        ...UserBasicInfo
        profile {
          avatar
        }
      }
    }
  }
}
```

### Pagination Pattern
```graphql
query GetApplications(
  $first: Int = 50
  $after: String
  $filter: FilterInput
) {
  allFactSheets(first: $first, after: $after, filter: $filter) {
    totalCount
    edges {
      cursor
      node {
        id
        displayName
      }
    }
    pageInfo {
      hasNextPage
      endCursor
    }
  }
}
```

### Mutation Best Practices
```graphql
mutation CreateApplication($input: CreateApplicationInput!) {
  createApplication(input: $input) {
    factSheet {
      id
      displayName
      createdAt
    }
    errors {
      field
      message
      code
    }
  }
}
```

## Usage Examples

### Example 1: Converting Hardcoded Query to Variables
```
User: "How do I make this query more flexible?"

query {
  user(id: "123") {
    name
  }
}
```

The skill will show how to convert it to use variables for better reusability and security.

### Example 2: Optimizing Query Performance
```
User: "This query is slow, how can I optimize it?"
```

The skill will analyze query depth, field selection, and pagination to suggest improvements.

### Example 3: Creating Reusable Fragments
```
User: "I'm repeating the same fields in multiple queries. How can I make this DRY?"
```

The skill will demonstrate how to extract common fields into reusable fragments.

## Reference Documentation

Detailed documentation is available in the `reference/` directory:

- `variables_guide.md` - Complete guide to using GraphQL variables
- `fragments_patterns.md` - Fragment patterns and advanced usage
- `performance_optimization.md` - Performance tips and benchmarks
- `security_guidelines.md` - Security best practices and examples
- `testing_patterns.md` - Writing testable GraphQL code

## Quick Reference

### Variable Declaration
```graphql
query OperationName(
  $required: String!           # Required (non-null)
  $optional: Int = 10          # Optional with default
  $list: [String!]             # Array of non-null strings
  $input: InputType            # Input object
) {
  # Query body
}
```

### Fragment Definition
```graphql
fragment FragmentName on TypeName {
  field1
  field2
  nestedObject {
    field3
  }
}
```

### Error Handling
```javascript
const result = await executeQuery(query, variables);

// Check for GraphQL errors
if (result.errors) {
  console.error('GraphQL Errors:', result.errors);
}

// Check for mutation errors
if (result.data?.mutation?.errors) {
  console.warn('Mutation failed:', result.data.mutation.errors);
}
```

## Industry Standards

This skill follows established GraphQL conventions from:
- GraphQL Specification
- Apollo GraphQL Best Practices
- GraphQL Foundation Guidelines
- Industry clean code principles
- Security best practices (OWASP)

## Best Practices Checklist

**Variables:**
- ✅ Use variables for all dynamic values
- ✅ Define proper types (String!, Int, [ID!], etc.)
- ✅ Provide defaults when appropriate
- ✅ Use input objects for complex data
- ❌ Never hardcode values in queries

**Naming:**
- ✅ PascalCase for operations (GetUserProfile)
- ✅ camelCase for fields (displayName)
- ✅ Descriptive names (GetActiveApplications)
- ✅ Boolean prefixes (isActive, hasAccess)
- ❌ Avoid abbreviations and vague names

**Fragments:**
- ✅ Extract repeated field sets
- ✅ Create focused, cohesive fragments
- ✅ Use descriptive fragment names
- ✅ Compose fragments hierarchically
- ❌ Don't create overly large fragments

**Queries:**
- ✅ Request only needed fields
- ✅ Always paginate list queries
- ✅ Limit query depth (3-5 levels max)
- ✅ Use aliases for multiple queries
- ❌ Avoid deep nesting

**Mutations:**
- ✅ Use input objects
- ✅ Return updated data and errors
- ✅ Include validation errors
- ✅ Support batch operations
- ❌ Don't mutate without returning data

**Error Handling:**
- ✅ Check errors array
- ✅ Log errors appropriately
- ✅ Provide user-friendly messages
- ✅ Use error codes
- ❌ Never ignore errors silently

**Performance:**
- ✅ Paginate all lists
- ✅ Limit query complexity
- ✅ Avoid over-fetching
- ✅ Use DataLoader for batching
- ❌ Don't fetch unnecessary data

**Security:**
- ✅ Validate input server-side
- ✅ Implement rate limiting
- ✅ Set query depth limits
- ✅ Use persisted queries
- ❌ Never trust client input

## Integration with Other Skills

This skill complements:
- `leanix-graphql` - SAP LeanIX-specific GraphQL operations
- `javascript-best-practices` - For JavaScript client code
- `leanix-api` - For authentication and API setup

## Contributing

To extend this skill:
1. Update `SKILL.md` with new patterns
2. Add examples to reference files
3. Keep aligned with GraphQL specification
4. Focus on practical, real-world examples
5. Include both good and bad examples

## Version

- **GraphQL Specification**: October 2021
- **Skill Version**: 1.0
- **Last Updated**: 2026-03-18

## License

Part of the Claude Code AI Skills collection for SAP LeanIX.
