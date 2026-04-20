\# Golden Determinism Certificate Policy



Golden certificates define the canonical semantics of the system.



\## Rules



1\. Golden certificates MUST NOT change as a side effect of refactoring.

2\. Any change to a golden certificate represents an intentional semantic change.

3\. Updates to golden certificates must:

&#x20;  - be isolated in their own commit, and

&#x20;  - mention the reason for the semantic change in the commit message.



\## Update Procedure



1\. Update the implementation.

2\. Regenerate the golden certificate explicitly.

3\. Commit ONLY the golden certificate change with a message explaining why semantics changed.



CI enforces that all ordinary changes preserve golden semantics.

