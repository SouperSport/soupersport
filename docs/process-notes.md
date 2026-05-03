## Process Notes

### Purpose

This document records key observations and decisions made during development.

It exists to preserve context:
- what failed
- what was investigated
- what changed
- why those changes matter

This document does not define semantics.
It records how the system became correct.

---

### Terminology Transition

Earlier work used the term "phase" inconsistently.

This has been replaced with:
- state-based descriptions
- explicit definitions of system condition

Historical terminology is retained only where needed for traceability.

---

### CI Incident — Missing Artifact Persistence

A CI failure exposed a mismatch between:
- what the executor computed
- what CI expected

The executor produced correct results but did not persist them.

#### Result

Verification failed even though computation was correct.

#### Correction

Execution was updated to:
- write outputs to artifact files
- treat artifact generation as part of system behavior

#### Principle

Standard output is not a reliable system boundary.

Outputs must be:
- explicit
- persistent
- verifiable

---

### Runtime Incident — UCRT64 File I/O Failure

A critical failure was observed during execution under MSYS2 UCRT64.

#### Observed Behavior

- file open operations succeeded  
- write calls appeared to succeed  
- files were created but often had zero length  
- no runtime errors were reported  
- behavior depended on write order  
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

None explained the behavior.

#### Conclusion

The problem was not in the program.

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
- produces inconsistent results  
- fails without reporting errors  

---

### Project Directory Change

The working project directory was moved out of a synchronized or managed location into a standard root-level directory.

#### Reason

- avoid interference from external file synchronization  
- eliminate inconsistent file state  
- ensure predictable file access  

#### Result

- simpler execution environment  
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
- observed failures  
- investigation steps  
- final conclusions  

Changes are made by:
- correction  
- clarification  
- extension  

History is not rewritten.

---

### Summary

Two key system truths emerged:

1. Correct computation is not sufficient.
   Outputs must be explicitly written and preserved.

2. Runtime behavior determines system validity.
   A system depends on a stable and predictable execution environment.

These findings are now treated as part of the system definition.

