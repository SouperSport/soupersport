## Process Notes

### Purpose

This document records key observations and decisions made during development.

It preserves context:
- what failed
- what was investigated
- what was corrected
- why those corrections matter

This document does not define semantics.  
It records how the system became correct.

---

### Terminology Transition

Early work used the term "phase" inconsistently.

This has been replaced with:
- state-based descriptions
- explicit definitions of system condition

Historical terminology is retained only where needed for traceability.

---

### CI Incident — Missing Artifact Persistence

A CI failure exposed a mismatch between:

- what the executor computed
- what CI expected to observe

The executor produced correct results, but did not persist them to disk.

#### Result

Verification failed even though computation was correct.

#### Correction

Execution was updated to:
- write outputs to artifact files
- define artifact generation as part of system behavior

#### Principle

Standard output is not a reliable system boundary.

Outputs must be:
- explicit
- persistent
- verifiable

---

### Runtime Incident — UCRT64 File I/O Failure

A critical failure was observed during execution under:

MSYS2 UCRT64

#### Observed Behavior

- file open operations succeeded
- write calls appeared to succeed
- files were created but often had zero length
- no runtime errors were reported
- behavior varied depending on write order
- final writes (especially provenance) were unreliable
- output appeared nondeterministic

Example:

OPEN PROVENANCE IOS = 0  
file exists  
size = 0 bytes  

#### Impact

- broke determinism guarantees
- invalidated produced artifacts
- caused silent data loss
- made verification unreliable

#### Investigation

The issue was initially treated as a program defect.

Multiple areas were examined:
- string handling
- buffering
- file modes
- write ordering
- hashing logic

None of these explained the behavior.

#### Conclusion

The problem was not in the program logic.

It was caused by the runtime:

UCRT64 gfortran exhibits unstable file I/O behavior in this environment.

#### Correction

Execution was moved to a stable runtime environment using the MinGW toolchain.

#### Result

- file writes became reliable
- no silent truncation occurred
- artifacts were fully written
- verification passed consistently

#### Principle

The runtime environment is part of system correctness.

A system cannot be considered valid if its runtime:
- silently drops data
- produces inconsistent outputs
- fails without signaling errors

---

### Project Directory Change

The working project directory was moved out of a synchronized or managed location into a standard root-level project directory.

#### Reason

- remove interference from external file synchronization
- eliminate inconsistent file state behavior
- ensure stable and predictable file access

#### Result

- simplified execution environment
- consistent file behavior
- reliable artifact generation

---

### Documentation Cleanup

Documentation was revised to:

- remove formatting artifacts
- eliminate inconsistent structure
- improve readability

No semantic meaning was changed.

---

### Preservation Principle

The project preserves:

- recorded failures
- investigation steps
- final conclusions

Corrections are made by:

- adding new information
- clarifying existing behavior

History is not rewritten.

---

### Summary

Two critical truths emerged during development:

1. Correct computation alone is not sufficient.  
   Outputs must be explicitly written and preserved.

2. Runtime behavior determines system validity.  
   A system depends on a stable and predictable execution environment.

These findings are now treated as part of the system definition, not implementation details.