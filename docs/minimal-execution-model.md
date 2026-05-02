# Minimal Execution Model

---

## Purpose

This document defines the minimum structures required for execution.

It specifies what must exist, not how to implement it.

---

## 1. State

---

### Definition

State is declared persistent data.

Not included:

- transient values  
- caches  
- runtime artifacts  

---

### Initial State

Must be:

- explicit  
- complete  
- reproducible  

---

### State Evolution

State changes must:

- be declared  
- be attributable  
- have explicit cause  

---

### State Equivalence

Equivalent if:

- components match under rules  
- no undeclared influence  

---

## 2. Execution Ordering

---

### Meaning

Ordering expresses dependency, not time.

---

### Requirements

Dependencies must be:

- explicit  
- complete  

No implicit dependence is allowed.

---

### Properties

- partial ordering allowed  
- total ordering only if declared  

---

## 3. Trace

---

### Purpose

Trace enables:

- replay  
- explanation  

---

### Required Content

- steps  
- dependencies  
- transitions  
- rules  

---

### Properties

- supports replay  
- supports explanation  

---

## 4. Counterfactuals

---

### Definition

Single change to:

- input  
- rule  
- dependency  

---

### Must Identify

- affected steps  
- resulting divergence  
- causal explanation  

---

## Status

This model defines sufficient structure for semantic reasoning.