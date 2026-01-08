---
name: refactoring-methodology
description: Expert refactoring guide based on Martin Fowler principles. Use when refactoring code, improving code structure, or when refactoring approach is discussed.
---

# Refactoring Methodology

## Definition

**Refactoring (noun)**: A change made to the internal structure of software to make it easier to understand and cheaper to modify without changing its observable behavior.

**Refactoring (verb)**: To restructure software by applying a series of refactorings without changing its observable behavior.

## Core Requirements

When refactoring, you MUST:

1. **Keep tests unchanged** - Touch ONLY code OR test files, never both at once
2. **Preserve observable behavior** - No functional changes during refactoring
3. **Keep tests green** - Tests must pass before and after refactoring
4. **Apply specific refactorings** - Use one of the named refactorings from the catalog

## Refactoring Catalog

Based on Martin Fowler and Kent Beck's book *Refactoring*.

### Complete List of Refactorings

**Change Function Declaration**
Add Parameter • Change Signature • Remove Parameter • Rename Function • Rename Method

**Change Reference to Value**
**Change Value to Reference**
**Collapse Hierarchy**
**Combine Functions into Class**
**Combine Functions into Transform**
**Consolidate Conditional Expression**
**Decompose Conditional**
**Encapsulate Collection**
**Encapsulate Record**
Replace Record with Data Class

**Encapsulate Variable**
Encapsulate Field • Self-Encapsulate Field

**Extract Class**
**Extract Function**
Extract Method

**Extract Superclass**
**Extract Variable**
Introduce Explaining Variable

**Hide Delegate**
**Inline Class**
**Inline Function**
Inline Method

**Inline Variable**
Inline Temp

**Introduce Assertion**
**Introduce Parameter Object**
**Introduce Special Case**
Introduce Null Object

**Move Field**
**Move Function**
Move Method

**Move Statements into Function**
**Move Statements to Callers**
**Parameterize Function**
Parameterize Method

**Preserve Whole Object**
**Pull Up Constructor Body**
**Pull Up Field**
**Pull Up Method**
**Push Down Field**
**Push Down Method**
**Remove Dead Code**
**Remove Flag Argument**
Replace Parameter with Explicit Methods

**Remove Middle Man**
**Remove Setting Method**
**Remove Subclass**
Replace Subclass with Fields

**Rename Field**
**Rename Variable**
**Replace Command with Function**
**Replace Conditional with Polymorphism**
**Replace Constructor with Factory Function**
Replace Constructor with Factory Method

**Replace Control Flag with Break**
Remove Control Flag

**Replace Derived Variable with Query**
**Replace Error Code with Exception**
**Replace Exception with Precheck**
Replace Exception with Test

**Replace Function with Command**
Replace Method with Method Object

**Replace Inline Code with Function Call**
**Replace Loop with Pipeline**
**Replace Magic Literal**
Replace Magic Number with Symbolic Constant

**Replace Nested Conditional with Guard Clauses**
**Replace Parameter with Query**
Replace Parameter with Method

**Replace Primitive with Object**
Replace Data Value with Object • Replace Type Code with Class

**Replace Query with Parameter**
**Replace Subclass with Delegate**
**Replace Superclass with Delegate**
Replace Inheritance with Delegation

**Replace Temp with Query**
**Replace Type Code with Subclasses**
Extract Subclass • Replace Type Code with State/Strategy

**Return Modified Value**
**Separate Query from Modifier**
**Slide Statements**
Consolidate Duplicate Conditional Fragments

**Split Loop**
**Split Phase**
**Split Variable**
Remove Assignments to Parameters • Split Temp

**Substitute Algorithm**

### Most Common Refactorings

The most frequently used refactorings include:
- **Extract Function** / Extract Method
- **Extract Variable** / Introduce Explaining Variable
- **Inline Function** / Inline Method
- **Move Function** / Move Method
- **Rename Variable** / Rename Function
- **Replace Temp with Query**
- **Split Phase**
- **Replace Conditional with Polymorphism**

## Process

1. Ensure tests are green
2. Choose one specific refactoring from the catalog
3. Apply it incrementally
4. Run tests after each step
5. Commit when green
6. Repeat as needed
