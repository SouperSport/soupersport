# Appendix — Canonicalization Notes



This appendix provides guidance on canonicalizing values that cross

nondeterministic boundaries into `Deterministic` regions.



It does not introduce new semantic requirements.

It clarifies how existing determinism guarantees can be upheld in practice.



\## Purpose



Sealed inputs must be represented canonically to preserve replayability,

rewindability, and counterfactual reasoning.



Canonicalization ensures that semantically equal inputs are operationally

indistinguishable to deterministic execution.



\## General Principles



\- Canonicalization occurs \*\*before\*\* deterministic consumption.

\- Canonicalization must be \*\*independent of locale, platform, and environment\*\*.

\- Canonicalization must not consult the external world during deterministic execution.



If canonicalization cannot be performed without nondeterministic observation,

it must occur outside `Deterministic`.



\## Strings and Text



Recommended properties:



\- Explicit character encoding (e.g., UTF‑8 as a named choice).

\- Explicit normalization form (e.g., Unicode NFC or NFKC).

\- No locale‑dependent folding, collation, or casing unless explicitly modeled.

\- Preservation of codepoint order.



Semantically equal strings must produce identical canonical byte sequences.



\## Structured Data (e.g., JSON‑like)



Recommended properties:



\- Stable ordering of object keys.

\- Explicit numeric representations.

\- No reliance on source formatting, whitespace, or serialization order.

\- Explicit treatment of null, absent, or optional fields.



Canonicalization must eliminate ambiguity introduced by serialization variability.



\## Byte Sequences and Binary Data



\- Binary inputs should be treated as exact byte sequences.

\- Any interpretation layered on top must be deterministic and explicit.



\## Floating‑Point Values



\- Canonicalization should not rely on platform formatting.

\- Numeric values must already obey the deterministic numeric rules

&#x20; applicable to their region.



Canonicalization does not repair numeric nondeterminism;

it preserves already‑deterministic values.



\## Scope and Non‑Goals



This appendix does not mandate specific formats, libraries, or encodings.

It exists to make deterministic guarantees practically achievable

without constraining implementation strategy.

