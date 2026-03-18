# ECMAScript 2023 (ES2023) Features Guide

A comprehensive reference for all ECMAScript 2023 features and enhancements.

## Table of Contents
1. [Array Methods](#array-methods)
2. [Hashbang Grammar](#hashbang-grammar)
3. [Symbols as WeakMap Keys](#symbols-as-weakmap-keys)
4. [Browser Support](#browser-support)

---

## Array Methods

### findLast() and findLastIndex()

These methods search arrays from the end, which is more efficient than reversing an array and using `find()` or `findIndex()`.

#### findLast()
Returns the last element in an array that satisfies the provided testing function.

```javascript
const numbers = [1, 2, 3, 4, 5, 6, 7, 8];

// Find the last even number
const lastEven = numbers.findLast(n => n % 2 === 0);
console.log(lastEven); // 8

// Find the last number greater than 5
const lastGreaterThan5 = numbers.findLast(n => n > 5);
console.log(lastGreaterThan5); // 8

// Returns undefined if no match found
const lastGreaterThan10 = numbers.findLast(n => n > 10);
console.log(lastGreaterThan10); // undefined
```

**Real-world example: Finding most recent error in logs**
```javascript
const logs = [
  { level: 'info', message: 'App started', timestamp: 1000 },
  { level: 'warn', message: 'Slow query', timestamp: 2000 },
  { level: 'error', message: 'Connection failed', timestamp: 3000 },
  { level: 'info', message: 'Retry succeeded', timestamp: 4000 },
  { level: 'error', message: 'Timeout', timestamp: 5000 }
];

// Find the most recent error
const lastError = logs.findLast(log => log.level === 'error');
console.log(lastError);
// { level: 'error', message: 'Timeout', timestamp: 5000 }
```

#### findLastIndex()
Returns the index of the last element that satisfies the testing function.

```javascript
const numbers = [1, 2, 3, 4, 5, 6, 7, 8];

// Find index of last even number
const lastEvenIndex = numbers.findLastIndex(n => n % 2 === 0);
console.log(lastEvenIndex); // 7

// Returns -1 if no match found
const lastGreaterThan10Index = numbers.findLastIndex(n => n > 10);
console.log(lastGreaterThan10Index); // -1
```

**Real-world example: Finding insertion point**
```javascript
const sortedData = [10, 20, 30, 40, 50, 60, 70];

// Find where to insert a value (e.g., 45)
const insertIndex = sortedData.findLastIndex(n => n < 45) + 1;
console.log(insertIndex); // 4
// Would insert at position 4: [10, 20, 30, 40, 45, 50, 60, 70]
```

#### Performance Comparison

```javascript
const largeArray = Array.from({ length: 1000000 }, (_, i) => i);

// ❌ Old approach - reverse and find (creates new array)
console.time('reverse');
const oldWay = largeArray.slice().reverse().find(n => n < 500000);
console.timeEnd('reverse'); // Slower - creates reversed copy

// ✅ New approach - findLast (no array copy)
console.time('findLast');
const newWay = largeArray.findLast(n => n < 500000);
console.timeEnd('findLast'); // Faster - no extra allocation
```

---

## Change Array by Copy (Immutable Array Methods)

These methods return new arrays instead of mutating the original, enabling functional programming patterns.

### toSorted()
Returns a new sorted array without modifying the original.

```javascript
const numbers = [3, 1, 4, 1, 5, 9, 2, 6];

// toSorted() - returns new array
const sorted = numbers.toSorted();
console.log(sorted);  // [1, 1, 2, 3, 4, 5, 6, 9]
console.log(numbers); // [3, 1, 4, 1, 5, 9, 2, 6] - unchanged

// Custom sort function
const descending = numbers.toSorted((a, b) => b - a);
console.log(descending); // [9, 6, 5, 4, 3, 2, 1, 1]

// Sorting objects
const users = [
  { name: 'Charlie', age: 35 },
  { name: 'Alice', age: 25 },
  { name: 'Bob', age: 30 }
];

const sortedByAge = users.toSorted((a, b) => a.age - b.age);
console.log(sortedByAge);
// [{ name: 'Alice', age: 25 }, { name: 'Bob', age: 30 }, { name: 'Charlie', age: 35 }]
console.log(users); // Original unchanged
```

**Comparison with sort()**
```javascript
const original = [3, 1, 4];

// ❌ sort() mutates original
const sorted1 = original.sort();
console.log(original); // [1, 3, 4] - modified!
console.log(sorted1);  // [1, 3, 4]

// ✅ toSorted() preserves original
const original2 = [3, 1, 4];
const sorted2 = original2.toSorted();
console.log(original2); // [3, 1, 4] - unchanged
console.log(sorted2);   // [1, 3, 4]
```

### toReversed()
Returns a new reversed array without modifying the original.

```javascript
const numbers = [1, 2, 3, 4, 5];

// toReversed() - returns new array
const reversed = numbers.toReversed();
console.log(reversed); // [5, 4, 3, 2, 1]
console.log(numbers);  // [1, 2, 3, 4, 5] - unchanged

// Comparison with reverse()
const original = [1, 2, 3];

// ❌ reverse() mutates
const reversed1 = original.reverse();
console.log(original);  // [3, 2, 1] - modified!

// ✅ toReversed() preserves original
const original2 = [1, 2, 3];
const reversed2 = original2.toReversed();
console.log(original2); // [1, 2, 3] - unchanged
console.log(reversed2); // [3, 2, 1]
```

### toSpliced()
Returns a new array with elements removed and/or added at a specific position.

```javascript
const months = ['Jan', 'Mar', 'Apr', 'Jun'];

// Insert 'Feb' at index 1
const withFeb = months.toSpliced(1, 0, 'Feb');
console.log(withFeb); // ['Jan', 'Feb', 'Mar', 'Apr', 'Jun']
console.log(months);  // ['Jan', 'Mar', 'Apr', 'Jun'] - unchanged

// Remove 1 element at index 2, insert 'May'
const fixed = months.toSpliced(3, 1, 'May', 'Jun');
console.log(fixed); // ['Jan', 'Mar', 'Apr', 'May', 'Jun']

// Remove elements without insertion
const removed = months.toSpliced(1, 2);
console.log(removed); // ['Jan', 'Jun']

// Comparison with splice()
const original = ['a', 'b', 'c'];

// ❌ splice() mutates
const result1 = original.splice(1, 1, 'x');
console.log(original); // ['a', 'x', 'c'] - modified!
console.log(result1);  // ['b'] - returns removed elements

// ✅ toSpliced() preserves original
const original2 = ['a', 'b', 'c'];
const result2 = original2.toSpliced(1, 1, 'x');
console.log(original2); // ['a', 'b', 'c'] - unchanged
console.log(result2);   // ['a', 'x', 'c'] - returns new array
```

**Parameters:**
- `start`: Index to start changing the array
- `deleteCount`: Number of elements to remove
- `...items`: Items to add to the array

### with()
Returns a new array with the element at the given index replaced.

```javascript
const numbers = [1, 2, 3, 4, 5];

// Replace element at index 2
const updated = numbers.with(2, 99);
console.log(updated); // [1, 2, 99, 4, 5]
console.log(numbers); // [1, 2, 3, 4, 5] - unchanged

// Negative index (from end)
const updated2 = numbers.with(-1, 100);
console.log(updated2); // [1, 2, 3, 4, 100]

// Comparison with bracket notation
const original = [1, 2, 3];

// ❌ Bracket notation mutates
original[1] = 99;
console.log(original); // [1, 99, 3] - modified!

// ✅ with() preserves original
const original2 = [1, 2, 3];
const updated = original2.with(1, 99);
console.log(original2); // [1, 2, 3] - unchanged
console.log(updated);   // [1, 99, 3]
```

### Method Chaining with Immutable Methods

The power of these methods shines when chaining operations:

```javascript
const numbers = [3, 1, 4, 1, 5, 9, 2, 6];

// Chain multiple operations
const result = numbers
  .toSorted()           // [1, 1, 2, 3, 4, 5, 6, 9]
  .toReversed()         // [9, 6, 5, 4, 3, 2, 1, 1]
  .with(0, 100)         // [100, 6, 5, 4, 3, 2, 1, 1]
  .toSpliced(2, 2);     // [100, 6, 1, 1]

console.log(result);  // [100, 6, 1, 1]
console.log(numbers); // [3, 1, 4, 1, 5, 9, 2, 6] - original unchanged!
```

**Real-world example: Processing user data**
```javascript
const users = [
  { id: 3, name: 'Charlie', score: 85 },
  { id: 1, name: 'Alice', score: 92 },
  { id: 2, name: 'Bob', score: 78 }
];

// Get top 2 users by score, sorted by name
const topUsers = users
  .toSorted((a, b) => b.score - a.score) // Sort by score desc
  .slice(0, 2)                            // Take top 2
  .toSorted((a, b) => a.name.localeCompare(b.name)); // Sort by name

console.log(topUsers);
// [{ id: 1, name: 'Alice', score: 92 }, { id: 3, name: 'Charlie', score: 85 }]
console.log(users); // Original array unchanged
```

---

## Hashbang Grammar

ES2023 adds official support for hashbang (`#!`) at the beginning of JavaScript files, making them executable as scripts.

### What is Hashbang?

Hashbang (also called shebang) tells the operating system which interpreter to use for executing a script.

```javascript
#!/usr/bin/env node

// Rest of your JavaScript code
console.log('Hello from executable script!');
```

### Usage

**Before ES2023:**
Hashbangs worked in practice but weren't part of the ECMAScript specification.

**With ES2023:**
Hashbangs are officially part of the language specification.

```javascript
#!/usr/bin/env node

import fs from 'fs';
import path from 'path';

// Your script logic
const files = fs.readdirSync(process.cwd());
console.log('Files:', files);
```

### Making Scripts Executable

1. Add hashbang to your JavaScript file:
```javascript
#!/usr/bin/env node

console.log('This is an executable script');
```

2. Make the file executable (Unix/Linux/Mac):
```bash
chmod +x script.js
```

3. Run it directly:
```bash
./script.js
```

### Common Interpreters

```javascript
#!/usr/bin/env node        // Node.js
#!/usr/bin/env deno        // Deno
#!/usr/bin/env bun         // Bun
```

---

## Symbols as WeakMap Keys

ES2023 allows using Symbols as keys in WeakMaps, expanding the use cases for WeakMaps.

### What Changed

**Before ES2023:**
Only objects could be WeakMap keys.

```javascript
const weakMap = new WeakMap();
const obj = {};

weakMap.set(obj, 'value'); // ✅ Works
weakMap.set(Symbol('key'), 'value'); // ❌ TypeError
```

**With ES2023:**
Symbols can also be WeakMap keys.

```javascript
const weakMap = new WeakMap();
const sym = Symbol('key');

weakMap.set(sym, 'value'); // ✅ Works in ES2023!
console.log(weakMap.get(sym)); // 'value'
```

### Why This Matters

Symbols are unique and can be used for private metadata storage:

```javascript
const privateData = new WeakMap();
const SECRET = Symbol('secret');

class User {
  constructor(name, secret) {
    this.name = name;
    privateData.set(SECRET, secret);
  }

  revealSecret() {
    return privateData.get(SECRET);
  }
}

const user = new User('Alice', 'my-secret');
console.log(user.revealSecret()); // 'my-secret'
// Secret is not accessible from outside
```

### Use Cases

1. **Private metadata** associated with symbols
2. **Unique identifiers** that can be garbage collected
3. **Enhanced encapsulation** patterns

---

## Browser Support

### ES2023 Feature Support (as of 2026)

| Feature | Chrome | Firefox | Safari | Node.js | Deno | Bun |
|---------|--------|---------|--------|---------|------|-----|
| findLast/findLastIndex | 110+ | 104+ | 16.4+ | 20+ | 1.25+ | 0.6+ |
| Immutable Array Methods | 110+ | 115+ | 16.0+ | 20+ | 1.31+ | 0.6+ |
| Hashbang Grammar | 74+ | 67+ | 13.1+ | 12+ | 1.0+ | 0.1+ |
| Symbols in WeakMap | 108+ | 102+ | 16.4+ | 19+ | 1.24+ | 0.5+ |

### Checking Support

```javascript
// Check for findLast support
const hasFindLast = typeof Array.prototype.findLast === 'function';

// Check for toSorted support
const hasToSorted = typeof Array.prototype.toSorted === 'function';

// Feature detection example
if (hasFindLast) {
  const last = array.findLast(predicate);
} else {
  // Fallback for older browsers
  const last = array.slice().reverse().find(predicate);
}
```

### Polyfills

For older environments, you can use polyfills:

```javascript
// Polyfill for findLast
if (!Array.prototype.findLast) {
  Array.prototype.findLast = function(predicate) {
    for (let i = this.length - 1; i >= 0; i--) {
      if (predicate(this[i], i, this)) {
        return this[i];
      }
    }
    return undefined;
  };
}
```

**Note:** Modern build tools and transpilers (Babel, TypeScript) can automatically add polyfills.

---

## Summary

ES2023 brings valuable additions to JavaScript:

1. **Array search from end**: `findLast()` and `findLastIndex()` make searching backwards efficient
2. **Immutable operations**: `toSorted()`, `toReversed()`, `toSpliced()`, and `with()` enable functional programming patterns
3. **Official hashbang support**: Makes JavaScript scripts more portable
4. **Symbols in WeakMap**: Expands private data patterns

These features improve code clarity, reduce bugs from mutations, and enhance JavaScript's functional programming capabilities.
