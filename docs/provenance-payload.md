# Deterministic Execution Provenance Payload

**Status:** Normative  
**Applies to:** Deterministic execution certificates  
**Stage:** Provenance & Signing (Stage 9)

This document defines the **canonical provenance payload** for a deterministic
execution.

The payload enumerates the minimum set of facts that must be bound together to
make an execution result **verifiable, non‑repudiable, and tamper‑evident**, even
outside the source repository.

Any cryptographic signature applied to a deterministic artifact MUST cover this
payload exactly.

---

## 1. Payload Identity

**Payload name:** `souper.provenance.deterministic-execution`  
**Payload version:** `1.0.0`

The payload version exists to allow evolution of provenance requirements without
retroactively invalidating historical artifacts.

---

## 2. Required Fields

A provenance payload MUST include the following fields:

### 2.1 Semantic Law

- Identifier of the governing semantic law (e.g., `Deterministic Replayability`)
- The law defines the meaning of trace equality and replayability

### 2.2 Declared Inputs

- Hash of the sealed input payload
- Hash MUST be computed after canonical sealing

### 2.3 Declared Initial State

- Hash of the initial state snapshot
- Hash MUST reflect the complete referenced state at entry

### 2.4 Execution Results

- `output_hash`
- `trace_hash`

These hashes jointly define observable semantic behavior.

### 2.5 Trace Schema

- Schema name
- Schema version

Trace hashes are only comparable under identical schema versions.

### 2.6 Tool Identity

- Tool name
- Tool version

Tool identity ensures that results can be attributed to a specific evaluator
implementation.

### 2.7 Source Context

- Git commit SHA (or equivalent content‑hash)
- Repository identifier (optional but recommended)

This binds the execution to its source context without relying solely on
version‑control trust.

---

## 3. Canonicalization Rules

Before signing:

- All payload fields MUST be serialized deterministically.
- Key order MUST be stable.
- Whitespace and formatting differences MUST NOT affect the payload hash.
- Any auxiliary metadata not listed above MUST be excluded.

Only the canonicalized payload is eligible for signature.

---

## 4. Interaction with Certificates

Certificates produced by deterministic execution:

- MUST contain (or reference) the complete provenance payload.
- MUST NOT omit any required field.
- MAY include additional metadata, provided it is explicitly excluded from the
  provenance payload.

Golden certificates implicitly fix the provenance payload.

---

## 5. Signature Semantics (Forward Reference)

A signature over the provenance payload asserts:

> “This execution result was produced from these declared inputs and initial
> state, under these semantic laws, using this tool, at this source context.”

Signature verification is sufficient to:

- detect tampering,
- detect substitution,
- attribute responsibility.

Signature mechanisms are defined in subsequent steps of Stage 9.

---

**End of provenance payload definition.**