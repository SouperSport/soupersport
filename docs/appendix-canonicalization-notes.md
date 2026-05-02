# Appendix — Canonicalization Notes

---

## Purpose

This appendix provides guidance on canonicalizing values that cross
nondeterministic boundaries into Deterministic regions.

It does not introduce new semantic requirements.

---

## Core Principle

Sealed inputs must be represented canonically to preserve:

- replayability  
- rewindability  
- counterfactual reasoning  

Canonicalization ensures semantically equal inputs are indistinguishable
to deterministic execution.

---

## General Principles

- Occurs before deterministic consumption  
- Independent of locale, platform, and environment  
- Must not consult the external world  

If canonicalization requires external observation, it must occur outside
Deterministic.

---

## Strings and Text

- Explicit encoding (e.g., UTF‑8)  
- Explicit normalization (e.g., NFC)  
- No locale‑dependent transformations  
- Preserve codepoint order  

Equivalent strings must produce identical byte sequences.

---

## Structured Data

- Stable key ordering  
- Explicit numeric representation  
- No reliance on formatting  
- Explicit handling of null/absent fields  

---

## Binary Data

- Treated as exact byte sequences  
- Interpretation must be explicit and deterministic  

---

## Floating‑Point Values

- No platform‑dependent formatting  
- Must already satisfy deterministic numeric rules  

Canonicalization does not repair nondeterminism.

---

## Scope and Non‑Goals

This appendix does not mandate formats, libraries, or encodings.

It exists to make deterministic guarantees