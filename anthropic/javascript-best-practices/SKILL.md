---
description: JavaScript ES2023 expert - helps with modern JavaScript best practices, ECMAScript 2023 features, and clean code patterns
trigger:
  - javascript best practices
  - es2023
  - ecmascript 2023
  - modern javascript
  - javascript patterns
  - clean javascript
  - javascript standards
  - javascript code quality
  - javascript performance
  - javascript optimization
---

# JavaScript ES2023 Best Practices Expert

You are a JavaScript expert with deep knowledge of ECMAScript 2023 (ES2023) specification and modern JavaScript best practices.

## Your Expertise

You help with:
- **ES2023 Features**: Understanding and using the latest ECMAScript features
- **Modern JavaScript Patterns**: Writing clean, maintainable, and idiomatic code
- **Code Quality**: Following best practices for readability and maintainability
- **Performance**: Optimizing JavaScript code for better performance
- **Security**: Writing secure JavaScript code and avoiding vulnerabilities
- **Async Programming**: Mastering promises, async/await, and concurrent operations
- **Error Handling**: Implementing robust error handling patterns
- **Testing**: Writing testable JavaScript code
- **Type Safety**: Using JSDoc for type hints and better IDE support

## ECMAScript 2023 (ES2023) Features

### Key ES2023 Features
1. **Array findLast() and findLastIndex()**: Find elements from the end of arrays
2. **Hashbang Grammar**: Support for `#!/usr/bin/env node` in scripts
3. **Symbols as WeakMap Keys**: Use symbols in WeakMaps
4. **Change Array by Copy**: Immutable array methods (toSorted, toReversed, toSpliced, with)

### Array Methods - Find from End
```javascript
// findLast() - find the last element that matches
const numbers = [1, 2, 3, 4, 5, 6];
const lastEven = numbers.findLast(n => n % 2 === 0); // 6

// findLastIndex() - find the index of last matching element
const lastEvenIndex = numbers.findLastIndex(n => n % 2 === 0); // 5

// Useful for searching from the end without reversing
const logs = ['info', 'warn', 'error', 'info', 'error'];
const lastError = logs.findLastIndex(log => log === 'error'); // 4
```

### Immutable Array Methods
```javascript
const original = [3, 1, 4, 1, 5];

// toSorted() - returns sorted copy without mutating original
const sorted = original.toSorted(); // [1, 1, 3, 4, 5]
console.log(original); // [3, 1, 4, 1, 5] - unchanged

// toReversed() - returns reversed copy
const reversed = original.toReversed(); // [5, 1, 4, 1, 3]

// toSpliced() - like splice() but returns new array
const spliced = original.toSpliced(1, 2, 9, 8); // [3, 9, 8, 1, 5]

// with() - returns new array with element at index changed
const withChange = original.with(2, 99); // [3, 1, 99, 1, 5]

// Chainable for functional programming
const result = original
  .toSorted()
  .toReversed()
  .with(0, 100); // [100, 4, 3, 1, 1]
```

## Modern JavaScript Best Practices

### 1. Variable Declarations
```javascript
// ❌ Avoid var - function scoped and can cause bugs
var x = 1;

// ✅ Use const by default - immutable binding
const PI = 3.14159;
const user = { name: 'John' };

// ✅ Use let only when reassignment is needed
let counter = 0;
counter += 1;

// ✅ Destructuring for cleaner code
const { name, age } = user;
const [first, second] = array;
```

### 2. Functions
```javascript
// ✅ Arrow functions for concise syntax and lexical 'this'
const add = (a, b) => a + b;
const square = x => x * x;

// ✅ Default parameters
const greet = (name = 'Guest') => `Hello, ${name}!`;

// ✅ Rest parameters for variable arguments
const sum = (...numbers) => numbers.reduce((a, b) => a + b, 0);

// ✅ Named functions for better stack traces
function processData(data) {
  // Named function shows up in error stack
  return data.map(item => transform(item));
}

// ❌ Avoid function expressions when arrow functions work
const multiply = function(a, b) { return a * b; };
// ✅ Use arrow function instead
const multiply = (a, b) => a * b;
```

### 3. Async/Await Patterns
```javascript
// ✅ Use async/await for cleaner async code
async function fetchUserData(userId) {
  try {
    const response = await fetch(`/api/users/${userId}`);
    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Failed to fetch user:', error);
    throw error;
  }
}

// ✅ Parallel async operations with Promise.all
async function fetchMultipleUsers(userIds) {
  const promises = userIds.map(id => fetchUserData(id));
  return await Promise.all(promises);
}

// ✅ Use Promise.allSettled for operations that can fail independently
async function fetchWithFallback(urls) {
  const results = await Promise.allSettled(
    urls.map(url => fetch(url))
  );

  return results
    .filter(result => result.status === 'fulfilled')
    .map(result => result.value);
}

// ❌ Avoid mixing callbacks and promises
fetch(url).then(response => {
  response.json().then(data => { // nested then - harder to read
    console.log(data);
  });
});

// ✅ Chain promises or use async/await
const response = await fetch(url);
const data = await response.json();
console.log(data);
```

### 4. Error Handling
```javascript
// ✅ Always handle errors in async functions
async function safeOperation() {
  try {
    const result = await riskyOperation();
    return { success: true, data: result };
  } catch (error) {
    console.error('Operation failed:', error);
    return { success: false, error: error.message };
  }
}

// ✅ Custom error classes for better error handling
class ValidationError extends Error {
  constructor(message, field) {
    super(message);
    this.name = 'ValidationError';
    this.field = field;
  }
}

// ✅ Use nullish coalescing and optional chaining
const value = user?.profile?.email ?? 'no-email@example.com';

// ❌ Avoid silent failures
try {
  riskyOperation();
} catch (error) {
  // Empty catch block - errors are swallowed
}

// ✅ At minimum, log the error
try {
  riskyOperation();
} catch (error) {
  console.error('Operation failed:', error);
  throw error; // Re-throw if caller should know
}
```

### 5. Object and Array Operations
```javascript
// ✅ Object spread for shallow cloning/merging
const userDefaults = { theme: 'light', notifications: true };
const userPrefs = { theme: 'dark' };
const settings = { ...userDefaults, ...userPrefs };

// ✅ Array spread and rest
const numbers = [1, 2, 3];
const moreNumbers = [...numbers, 4, 5];
const [first, ...rest] = numbers;

// ✅ Object destructuring with renaming
const { name: userName, age: userAge } = user;

// ✅ Computed property names
const field = 'email';
const user = {
  [field]: 'user@example.com',
  [`${field}Verified`]: true
};

// ✅ Shorthand property and method syntax
const name = 'John';
const age = 30;
const user = {
  name,
  age,
  greet() {
    return `Hello, I'm ${this.name}`;
  }
};
```

### 6. Array Methods
```javascript
// ✅ Use appropriate array methods
const numbers = [1, 2, 3, 4, 5];

// Map - transform each element
const doubled = numbers.map(n => n * 2);

// Filter - select matching elements
const evens = numbers.filter(n => n % 2 === 0);

// Reduce - accumulate to single value
const sum = numbers.reduce((acc, n) => acc + n, 0);

// Find - get first matching element
const firstEven = numbers.find(n => n % 2 === 0);

// Every/Some - test all/any elements
const allPositive = numbers.every(n => n > 0);
const hasEven = numbers.some(n => n % 2 === 0);

// ✅ Chain methods for functional pipelines
const result = numbers
  .filter(n => n > 2)
  .map(n => n * 2)
  .reduce((acc, n) => acc + n, 0);

// ❌ Avoid for loops when array methods work
let doubled = [];
for (let i = 0; i < numbers.length; i++) {
  doubled.push(numbers[i] * 2);
}
// ✅ Use map instead
const doubled = numbers.map(n => n * 2);
```

### 7. String Operations
```javascript
// ✅ Template literals for string interpolation
const name = 'World';
const greeting = `Hello, ${name}!`;

// ✅ Multi-line strings
const html = `
  <div>
    <h1>${title}</h1>
    <p>${content}</p>
  </div>
`;

// ✅ String methods
const text = '  Hello World  ';
text.trim(); // 'Hello World'
text.startsWith('  Hello'); // true
text.includes('World'); // true
text.replaceAll('l', 'L'); // '  HeLLo WorLd  '

// ✅ Nullish coalescing for default strings
const displayName = userName ?? 'Anonymous';
```

### 8. Optional Chaining and Nullish Coalescing
```javascript
// ✅ Optional chaining (?.) for safe property access
const user = { profile: { email: 'user@example.com' } };
const email = user?.profile?.email; // 'user@example.com'
const phone = user?.profile?.phone; // undefined (no error)

// ✅ Optional chaining with methods
const result = obj?.method?.();

// ✅ Optional chaining with arrays
const firstItem = array?.[0];

// ✅ Nullish coalescing (??) - only null/undefined trigger default
const count = 0;
const display1 = count || 100; // 100 (0 is falsy)
const display2 = count ?? 100; // 0 (0 is not null/undefined)

// ✅ Combine both for robust default handling
const value = user?.settings?.theme ?? 'light';
```

### 9. Modules (ES Modules)
```javascript
// ✅ Named exports (recommended for multiple exports)
export const API_URL = 'https://api.example.com';
export function fetchData() { /* ... */ }
export class DataStore { /* ... */ }

// ✅ Named imports
import { API_URL, fetchData } from './api.js';

// ✅ Default export (use for single main export)
export default class Application { /* ... */ }

// ✅ Default import
import Application from './Application.js';

// ✅ Import everything
import * as utils from './utils.js';

// ✅ Re-export
export { fetchData } from './api.js';
export * from './constants.js';

// ❌ Avoid mixing default and named exports excessively
```

### 10. Classes (Modern Syntax)
```javascript
// ✅ Class fields (public)
class User {
  name = 'Anonymous'; // Public field
  #password = ''; // Private field (ES2022)

  constructor(name, password) {
    this.name = name;
    this.#password = password;
  }

  // Public method
  greet() {
    return `Hello, ${this.name}!`;
  }

  // Private method
  #validatePassword() {
    return this.#password.length >= 8;
  }

  // Getter
  get isValid() {
    return this.#validatePassword();
  }

  // Static method
  static create(name, password) {
    return new User(name, password);
  }
}

// ✅ Inheritance
class Admin extends User {
  #permissions = [];

  constructor(name, password, permissions) {
    super(name, password);
    this.#permissions = permissions;
  }

  hasPermission(permission) {
    return this.#permissions.includes(permission);
  }
}
```

## Performance Best Practices

### 1. Efficient Loops and Iterations
```javascript
// ✅ Use for...of for arrays
for (const item of items) {
  process(item);
}

// ✅ Use for...in for objects (check hasOwnProperty)
for (const key in obj) {
  if (Object.hasOwn(obj, key)) {
    process(obj[key]);
  }
}

// ✅ Cache length in performance-critical loops
const len = items.length;
for (let i = 0; i < len; i++) {
  // Tight loop
}
```

### 2. Avoid Unnecessary Operations
```javascript
// ❌ Creating functions in loops
for (let i = 0; i < items.length; i++) {
  items[i].handler = function() { return i; };
}

// ✅ Define function once
const handler = (index) => () => index;
for (let i = 0; i < items.length; i++) {
  items[i].handler = handler(i);
}

// ✅ Or use arrow functions with proper closure
items.forEach((item, i) => {
  item.handler = () => i;
});
```

### 3. Use Appropriate Data Structures
```javascript
// ✅ Use Set for unique values and fast lookups
const uniqueIds = new Set([1, 2, 2, 3, 3, 4]); // Set {1, 2, 3, 4}
uniqueIds.has(2); // true - O(1) lookup

// ✅ Use Map for key-value pairs with any key type
const cache = new Map();
cache.set(user, userData);
cache.get(user); // Fast lookup

// ❌ Don't use arrays for lookups
const ids = [1, 2, 3, 4, 5];
ids.includes(3); // O(n) lookup

// ✅ Use Set instead
const idSet = new Set([1, 2, 3, 4, 5]);
idSet.has(3); // O(1) lookup
```

## Security Best Practices

### 1. Avoid eval and Similar Constructs
```javascript
// ❌ Never use eval
eval('alert("XSS")'); // Dangerous!

// ❌ Avoid Function constructor
const fn = new Function('return alert("XSS")');

// ✅ Use safe alternatives
const data = JSON.parse(jsonString);
```

### 2. Sanitize User Input
```javascript
// ✅ Validate and sanitize input
function sanitizeInput(input) {
  if (typeof input !== 'string') {
    throw new TypeError('Input must be a string');
  }
  return input.trim().slice(0, 100); // Limit length
}

// ✅ Use proper encoding for HTML
function escapeHtml(unsafe) {
  return unsafe
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
}
```

### 3. Secure Data Handling
```javascript
// ✅ Use const for sensitive data that shouldn't change
const API_KEY = process.env.API_KEY;

// ✅ Don't log sensitive information
// ❌ console.log('Password:', password);
// ✅ console.log('Authentication attempt for user:', username);

// ✅ Clear sensitive data when done
let tempPassword = getUserInput();
// ... use password ...
tempPassword = null; // Help garbage collector
```

## Code Quality Practices

### 1. Naming Conventions
```javascript
// ✅ camelCase for variables and functions
const userName = 'John';
function getUserData() { }

// ✅ PascalCase for classes
class UserAccount { }

// ✅ UPPER_SNAKE_CASE for constants
const MAX_RETRY_COUNT = 3;
const API_ENDPOINT = 'https://api.example.com';

// ✅ Descriptive names
const isUserLoggedIn = checkAuthStatus();
const filteredActiveUsers = users.filter(u => u.active);

// ❌ Avoid abbreviations and single letters (except in loops)
const usr = getUsr(); // Bad
const user = getUser(); // Good
```

### 2. Function Design
```javascript
// ✅ Single Responsibility - functions do one thing
function calculateTotal(items) {
  return items.reduce((sum, item) => sum + item.price, 0);
}

function applyDiscount(total, discountRate) {
  return total * (1 - discountRate);
}

// ✅ Pure functions when possible (no side effects)
function add(a, b) {
  return a + b; // Always same output for same input
}

// ✅ Keep functions small and focused
// ❌ Don't create god functions that do everything
```

### 3. Comments and Documentation
```javascript
// ✅ Use JSDoc for function documentation
/**
 * Calculates the total price with tax
 * @param {number} price - The base price
 * @param {number} taxRate - The tax rate (0-1)
 * @returns {number} The total price including tax
 */
function calculateWithTax(price, taxRate) {
  return price * (1 + taxRate);
}

// ✅ Comment "why", not "what"
// Retry failed requests to handle temporary network issues
const maxRetries = 3;

// ❌ Don't comment obvious code
// Increment counter by 1
counter++;
```

## Testing Considerations

### 1. Write Testable Code
```javascript
// ✅ Separate pure logic from side effects
function calculatePrice(items) {
  return items.reduce((sum, item) => sum + item.price, 0);
}

async function displayPrice(items) {
  const total = calculatePrice(items); // Testable without UI
  document.getElementById('total').textContent = total;
}

// ✅ Dependency injection for easier testing
class UserService {
  constructor(apiClient) {
    this.apiClient = apiClient; // Inject dependency
  }

  async getUser(id) {
    return await this.apiClient.get(`/users/${id}`);
  }
}
```

### 2. Avoid Hard-to-Test Patterns
```javascript
// ❌ Direct DOM manipulation scattered everywhere
function updateUI() {
  document.getElementById('user').textContent = getUser();
  document.getElementById('count').textContent = getCount();
}

// ✅ Separate data logic from rendering
function getUserData() {
  return { user: getUser(), count: getCount() };
}

function render(data) {
  document.getElementById('user').textContent = data.user;
  document.getElementById('count').textContent = data.count;
}
```

## Common Pitfalls to Avoid

### 1. Type Coercion Issues
```javascript
// ❌ Loose equality can cause bugs
0 == '0' // true
null == undefined // true
false == '' // true

// ✅ Use strict equality
0 === '0' // false
null === undefined // false

// ✅ Explicit conversion when needed
const num = Number(str);
const bool = Boolean(value);
```

### 2. Reference vs Value
```javascript
// ❌ Shallow copy pitfall
const original = { nested: { value: 1 } };
const copy = { ...original };
copy.nested.value = 2; // Modifies original.nested.value!

// ✅ Deep clone when needed
const deepCopy = JSON.parse(JSON.stringify(original));
// Or use structuredClone (modern browsers)
const deepCopy = structuredClone(original);
```

### 3. Async Pitfalls
```javascript
// ❌ Forgetting to await
async function loadData() {
  const data = fetchData(); // Missing await!
  console.log(data); // Promise, not data
}

// ✅ Always await async functions
async function loadData() {
  const data = await fetchData();
  console.log(data); // Actual data
}

// ❌ Sequential when parallel is possible
const user = await fetchUser();
const posts = await fetchPosts(); // Waits unnecessarily

// ✅ Run in parallel
const [user, posts] = await Promise.all([
  fetchUser(),
  fetchPosts()
]);
```

## Quick Reference Checklist

- [ ] Use `const` by default, `let` only when reassignment needed
- [ ] Use arrow functions for callbacks and short functions
- [ ] Use template literals instead of string concatenation
- [ ] Use destructuring for cleaner object/array access
- [ ] Use optional chaining (`?.`) and nullish coalescing (`??`)
- [ ] Prefer array methods (`map`, `filter`, `reduce`) over loops
- [ ] Use `async/await` instead of raw promises
- [ ] Handle all promise rejections (try/catch or .catch())
- [ ] Use strict equality (`===`) instead of loose (`==`)
- [ ] Write pure functions when possible (no side effects)
- [ ] Use meaningful variable and function names
- [ ] Keep functions small and focused (single responsibility)
- [ ] Use JSDoc comments for complex functions
- [ ] Avoid `eval()` and `Function()` constructor
- [ ] Validate and sanitize user input
- [ ] Use appropriate data structures (Set, Map, etc.)
- [ ] Make code testable (pure functions, dependency injection)

## When to Use This Skill

Invoke this skill when users ask about:
- "What are JavaScript best practices?"
- "How do I use ES2023 features?"
- "Show me modern JavaScript patterns"
- "How should I structure my JavaScript code?"
- "What are the new array methods in ES2023?"
- "How do I write clean JavaScript?"
- "JavaScript performance optimization"
- "Secure JavaScript coding practices"
- Modern JavaScript development
- ECMAScript 2023 specification
- Clean code patterns
- JavaScript code quality

## Reference Files

For more detailed information, see:
- `reference/es2023_features.md` - Complete ES2023 feature guide
- `reference/performance_optimization.md` - Performance tips and tricks
- `reference/security_guidelines.md` - Security best practices
- `reference/testing_patterns.md` - Writing testable JavaScript
