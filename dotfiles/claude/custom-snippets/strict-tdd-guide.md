# Strict Test-Driven Development (TDD) Guide for Claude Code

## Core Principle
**Write the test first. Always. No exceptions.**

When implementing new features or fixing bugs, you MUST follow this sequence:
1. Write a failing test that describes the first smallest step of the desired behavior
2. Run the test and confirm it fails for the right reason
3. Create a stop point to check in with the human user. Never write code and tests at the same time.
4. Write the minimum code to make the test pass.
5. Run the test and confirm it passes, or that there is a new failure.
6. Write the minimal code to solve that failure.
7. Repeate 5 and 6 until the test passes.
8. Refactor if needed while keeping tests green. Change only implementation code.
9. Run 1-8 with the next smallest step to move towards the desired behavior.

## When to Use TDD

Use strict TDD for:
- ✅ New feature implementation
- ✅ Bug fixes (write test that reproduces the bug first)
- ✅ Refactoring (tests protect against regressions)
- ✅ API/interface design (tests define the contract)

You may skip TDD for:
- ⚠️ Exploratory coding (spike work that will be thrown away)
- ⚠️ Documentation-only changes
- ⚠️ Build/config changes that can't be unit tested

## The TDD Cycle (Red-Green-Refactor)

### Red: Write a Failing Test
```go
// Example: Testing a new function before it exists
func TestCalculateDiscount(t *testing.T) {
    result := calculateDiscount(100, 0.1)
    assert.Equal(t, 90.0, result)
}
```

**Run the test:**
```bash
go test ./path/to/package -run TestCalculateDiscount
```

**Expected result:** Test fails (function doesn't exist or returns wrong value)

### Green: Write Minimal Code to Pass
```go
func calculateDiscount(price float64, discount float64) float64 {
    return price - (price * discount)
}
```

**Run the test again:**
```bash
go test ./path/to/package -run TestCalculateDiscount
```

**Expected result:** Test passes

### Refactor: Improve Code While Keeping Tests Green
```go
// If needed, improve implementation
func calculateDiscount(price, discountRate float64) float64 {
    if discountRate < 0 || discountRate > 1 {
        return price
    }
    return price * (1 - discountRate)
}
```

**Run all tests:**
```bash
go test ./path/to/package/...
```

**Expected result:** All tests still pass

## TDD Workflow Steps

### Step 1: Understand the Requirement
Before writing any test, ensure you understand:
- What behavior needs to be implemented?
- What are the inputs and expected outputs?
- What are the edge cases?
- What are the error conditions?
- What tests and functionality already exist?

### Step 2: Write One Test Case
Start with the simplest, most obvious test case:
```psuedo-code
assert Class.newGetMethodWithFilter returns anInstanceOfClass
```

**Do NOT write:**
- The implementation yet
- Multiple test cases at once
- Complex test setup before confirming the simple case works

### Step 3: Run the Test and Watch It Fail

**Verify the failure reason:**
- Method/class etc does not exist ✅ Good
- Compilation error? (Method doesn't exist) ✅ Good
- Assertion failed? (Method returns wrong value) ✅ Good
- Test passes unexpectedly? ⚠️ Test might be wrong

### Step 4: Write Minimal Implementation
Write just enough code to make THIS test pass. Resist the urge to:
- ❌ Add error handling for cases not tested yet
- ❌ Optimize prematurely
- ❌ Implement features not required by the test
- ❌ Add "nice to have" functionality

### Step 5: Run the Test Again

If it fails, revise the implementation. If it passes, move to the next test case.

### Step 6: Add Next Test Case
Now add the next most important test case:
```pseudo-code
assert do
returnedObject = Class.newGetMethodWithFilter
returnedObject.meetsFilterCriteria
```

### Step 7: Repeat Red-Green-Refactor
Continue this cycle until all requirements are met.

## Test Organization

### Test File Naming
Follow language-specific idioms and also existing test patterns in the repo

### Test Function Naming
Use descriptive and language-specific idiomatic naming. A test name should clearly describe what will be tested, and why this test case is different from other cases
Each case should test just one thing

### Table-Driven Tests
Use table-driven tests for multiple similar cases in languages that make sense like go

## Testing Best Practices

### DO:
- ✅ Test behavior, not implementation details
- ✅ Use mocks sparingly and only when needed
- ✅ Write tests that read like specifications
- ✅ Use descriptive test names
- ✅ Test one thing per test function
- ✅ Use table-driven tests for similar scenarios for languages that encourage it
- ✅ Test edge cases and error conditions
- ✅ Keep tests independent (no shared state)
- ✅ Use helper functions to reduce test setup duplication
- ✅ Run tests frequently (after every small change)

### DON'T:
- ❌ Skip writing tests to "save time"
- ❌ Write tests after implementation
- ❌ Test private implementation details
- ❌ Write overly complex tests
- ❌ Make tests depend on execution order
- ❌ Use real external dependencies (database, APIs, etc.)
- ❌ Leave failing tests in the codebase
- ❌ Comment out or skip tests instead of fixing them
- ❌ Change the behavior of a test so it no longer tests anything instead of fixing it
- ❌ Write tests that only test the functioning of mocks

## TDD for Different Scenarios

### Fixing a Bug

1. **Write test that reproduces the bug**

2. **Confirm test fails correctly**

3. **Fix the bug**

4. **Confirm test passes**

### Refactoring Code

1. **Ensure existing tests pass**
2. **Refactor code while keeping tests green**
3. **If tests need to change, that's a code smell - consider if you're testing implementation details**

