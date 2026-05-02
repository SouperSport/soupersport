# Deterministic Execution Provenance Payload

**Status:** Normative  
**Applies to:** Deterministic execution certificates  

---

## Overview

This document defines the canonical provenance payload
for deterministic execution.

It specifies the minimum set of facts required to make an
execution result:

- verifiable  
- non‑repudiable  
- tamper‑evident  

Any signature MUST cover this payload exactly.

---

## 1. Payload Identity

- Payload name: souper.provenance.deterministic-execution  
- Payload version: 1.0.0  

---

## 2. Required Fields

### Semantic Law

- Identifier of governing law  

---

### Declared Inputs

- Hash of sealed inputs  

---

### Initial State

- Hash of initial state snapshot  

---

### Execution Results

- output hash  
- trace hash  

---

### Trace Schema

- schema name  
- schema version  

---

### Tool Identity

- tool name  
- tool version  

---

### Source Context

- content identifier (e.g., commit hash)  
- repository identifier (optional)  

---

## 3. Canonicalization

Before signing:

- serialization must be deterministic  
- key order must be stable  
- formatting must not affect hashing  

Only canonical payloads may be signed.

---

## 4. Certificates

Certificates MUST:

- include or reference full payload  
- include all required fields  

They MAY include extra metadata if excluded from payload.

---

## 5. Signature Meaning

A signature asserts:

"This execution was produced under these inputs,
rules, tools, and context."

Verification ensures:

- no tampering  
- no substitution  
- clear attribution  

---

**End of payload definition**