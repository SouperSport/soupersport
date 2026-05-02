# Representation Candidates

This document evaluates representation families that may satisfy the
semantic model.

It does not introduce semantics or select an approach.

---

## 1. Constraints

Representations must:

- preserve explicit state  
- express dependency ordering  
- support replayable traces  
- support counterfactual reasoning  

Evaluation is purely semantic.

---

## 2. Candidates

---

### Graph-Based

- nodes = steps  
- edges = dependencies  
- ordering from graph  

Focus: causality

---

### Transition Log

- indexed steps  
- explicit ordering  

Focus: replay clarity

---

### Functional Core

- immutable state  
- rule-based derivation  

Focus: declarative meaning

---

### Relational

- relations as state  
- derivation logic  

Focus: explanation

---

## 3. Fit and Risks

Each model:

- supports semantics  
- introduces specific risks  

Risks include:

- implicit ordering  
- hidden mutation  
- inadequate trace detail  
- conflating execution with scheduling  

---

## 4. Risk Register

Must avoid:

- implicit behavior  
- hidden state  
- insufficient trace detail  

---

## 5. Non‑Decision

No representation is selected.

This document constrains future decisions.

---

## Status

- candidates defined  
- risks identified  
- no commitment made  

Further selection must be explicit.