# Process Notes

---

## Purpose

This document records process history and decisions.

It preserves context without altering semantic definitions.

---

## Terminology Transition

Earlier terminology used “phase” inconsistently.

The project now avoids timeline-based labels in favor of:

- state-based descriptions  
- explicit definitions  

Historical references are preserved for auditability.

---

## CI Incident — Determinism Certificate Failure

A CI failure revealed a mismatch between:

- executor output  
- CI expectations  

The executor produced correct results but did not persist them.

---

### Correction

Execution now:

- produces durable artifact files  
- maintains explicit outputs  

---

### Principle

STDOUT is not a stable semantic boundary.

Artifacts must be:

- persistent  
- verifiable  

---

## Documentation Standardization

Documentation was normalized to:

- remove formatting artifacts  
- improve readability  

No semantic changes occurred.

---

## Preservation Principle

The project prefers:

- forward correction  
- explicit documentation  
- auditability  

Over rewriting history.