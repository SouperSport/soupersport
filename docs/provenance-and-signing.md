# Provenance and Signing

**Status:** Enforced  
**CI Mode:** Strict  
**Date Enforced:** 2026‑04‑18  

---

## What This Capability Guarantees

This document describes the cryptographic provenance and signing guarantees
applied to deterministic execution artifacts.

With provenance and signing enforced:

- Golden certificates are cryptographically signed
- Signatures bind:
  - semantic law identity
  - sealed inputs
  - declared initial state
  - output hash
  - trace hash
- CI verifies signatures on every push and pull request

Any missing or invalid signature causes a CI failure.

These guarantees establish tamper‑evidence and attribution for all
deterministic execution artifacts.

---

## Design Notes (Important)

### Key Format Choice

RSA keys are stored as canonical JSON‑encoded `RSAParameters`, not PEM files.

This choice is intentional:

- PEM export is not reliably available across runtimes
  (for example, `RSACng` on Windows)
- JSON‑encoded parameters are deterministic, portable, and verifier‑friendly
- This avoids environment‑specific cryptographic failures

PEM output may be added later as a convenience representation, but JSON
remains the canonical key format for signing and verification.

---

### Rollout Strategy

Provenance and signing enforcement was introduced deliberately:

- CI initially operated in a warning mode
- All existing golden artifacts were signed and verified
- CI was then switched to strict enforcement

The transition was observable, auditable, and intentional.

---

## Invariants After Provenance and Signing Enforcement

With provenance and signing enforced:

- Determinism is enforced
- Counterfactual equivalence checks are enforced
- Provenance is enforced
- All golden artifacts are tamper‑evident

This establishes a legitimacy boundary:

Semantic changes must be explicit, reviewed, and re‑signed.