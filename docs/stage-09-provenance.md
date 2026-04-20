\# Stage 9 — Provenance \& Signing (COMPLETE)



\*\*Status:\*\* Enforced  

\*\*CI Mode:\*\* Strict  

\*\*Date Completed:\*\* 2026‑04‑18



\## What Stage 9 Guarantees



Stage 9 adds cryptographic provenance to deterministic execution:



\- Golden certificates are cryptographically signed

\- Signatures bind:

&#x20; - semantic law

&#x20; - sealed inputs

&#x20; - initial state

&#x20; - output hash

&#x20; - trace hash

\- CI verifies signatures on every push and PR



Any missing or invalid signature causes CI failure.



\## Design Notes (Important)



\### Key Format Choice

RSA keys are stored as canonical JSON‑encoded `RSAParameters`, not PEM files.



This is intentional:

\- PEM export is not reliably available across runtimes (e.g., RSACng on Windows)

\- JSON parameters are deterministic, portable, and verifier‑friendly

\- This avoids environment‑specific crypto failures



PEM may be added later as a convenience output, but JSON remains canonical.



\### Rollout Strategy

\- Stage 9 was introduced in CI warn mode

\- Once all goldens were signed and verified, CI was flipped to strict mode

\- The transition was deliberate and observable



\## Invariants After Stage 9



After this stage:

\- Determinism is enforced

\- Counterfactual equivalence is enforced

\- Provenance is enforced

\- All golden artifacts are tamper‑evident



This establishes a legitimacy boundary: semantic changes must be explicit, reviewed, and re‑signed.

