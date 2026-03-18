# JavaScript Best Practices Skill

A comprehensive Claude Code skill for modern JavaScript development following **ECMAScript 2023 (ES2023)** standards and industry best practices.

> **Note**: This skill is specifically designed for **ECMAScript 2023 (ES2023)** features and modern JavaScript patterns. It focuses on the ES2023 specification including new array methods, immutable operations, and contemporary best practices.

## Overview

This skill provides expert guidance on modern JavaScript development based on the **ECMAScript 2023 (ES2023)** specification:

- **ECMAScript 2023 Features**: Latest JavaScript language features (findLast, immutable arrays, etc.)
- **Best Practices**: Industry-standard patterns and conventions for ES2023+
- **Code Quality**: Writing clean, maintainable, and readable code
- **Performance**: Optimization techniques for faster JavaScript
- **Security**: Writing secure code and avoiding vulnerabilities
- **Testing**: Making code testable and maintainable

All examples and recommendations are aligned with **ES2023 standards** and modern JavaScript development practices.

## Skill Activation

This skill is automatically activated when you mention:
- JavaScript best practices
- ES2023 or ECMAScript 2023
- Modern JavaScript patterns
- Code quality improvements
- JavaScript optimization

## Key Topics Covered

### ES2023 Features
- `findLast()` and `findLastIndex()` array methods
- Immutable array methods (`toSorted`, `toReversed`, `toSpliced`, `with`)
- Hashbang grammar for scripts
- Symbols as WeakMap keys

### Modern JavaScript Patterns
- Variable declarations (const, let)
- Arrow functions and function best practices
- Async/await patterns
- Object and array operations
- Template literals
- Destructuring
- Spread/rest operators
- Optional chaining and nullish coalescing

### Code Quality
- Naming conventions
- Function design principles
- Comments and documentation (JSDoc)
- Single Responsibility Principle
- Pure functions and immutability

### Performance Optimization
- Efficient loops and iterations
- Appropriate data structures (Set, Map)
- Avoiding unnecessary operations
- Memory management

### Security Best Practices
- Input validation and sanitization
- Avoiding eval() and similar constructs
- Secure data handling
- XSS prevention

## Usage Examples

### Example 1: Getting ES2023 Array Methods Help
```
User: "How do I find the last element in an array that matches a condition?"
```
The skill will explain `findLast()` and `findLastIndex()` methods with practical examples.

### Example 2: Code Review
```
User: "Can you review this JavaScript code for best practices?"
```
The skill will analyze the code against modern JavaScript standards and suggest improvements.

### Example 3: Performance Optimization
```
User: "How can I make this loop faster?"
```
The skill will suggest appropriate array methods, data structures, and optimization techniques.

## Reference Documentation

Additional detailed documentation is available in the `reference/` directory:

- `es2023_features.md` - Complete guide to ES2023 features
- `performance_optimization.md` - Performance tips and benchmarks
- `security_guidelines.md` - Security best practices and examples
- `testing_patterns.md` - Writing testable JavaScript code

## Quick Reference

### Variable Declarations
```javascript
const constant = 'value';  // Preferred for immutable bindings
let variable = 0;          // When reassignment is needed
// Avoid 'var'
```

### Functions
```javascript
// Arrow functions for concise syntax
const add = (a, b) => a + b;

// Named functions for better stack traces
function processData(data) { ... }
```

### Async Operations
```javascript
// Always use async/await
async function fetchData() {
  try {
    const response = await fetch(url);
    return await response.json();
  } catch (error) {
    console.error(error);
    throw error;
  }
}
```

### Array Operations
```javascript
// Use appropriate array methods
const doubled = numbers.map(n => n * 2);
const evens = numbers.filter(n => n % 2 === 0);
const sum = numbers.reduce((acc, n) => acc + n, 0);

// ES2023 immutable methods
const sorted = original.toSorted();
const reversed = original.toReversed();
```

## Contributing

To extend this skill:
1. Update `SKILL.md` with new patterns or practices
2. Add detailed examples to reference files
3. Keep content aligned with ECMAScript specifications
4. Focus on practical, real-world examples

## Version

- **ECMAScript Version**: ES2023 (ECMAScript 2023)
- **Skill Version**: 1.0
- **Last Updated**: 2026-03-18

## Related Skills

- `leanix-javascript` - LeanIX-specific JavaScript for Calculations and Automations
- `claude-api` - Building applications with Claude API using JavaScript/TypeScript

## License

Part of the Claude Code AI Skills collection.
