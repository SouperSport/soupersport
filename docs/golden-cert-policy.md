\# Golden Determinism Certificate Policy



\---



\## Purpose



Golden certificates define canonical semantic behavior.



\---



\## Rules



1\. Golden certificates MUST NOT change due to refactoring  



2\. Any change represents a semantic change  



3\. Updates MUST:



&#x20;  - be isolated in their own commit  

&#x20;  - explicitly state the reason for the change  



\---



\## Update Procedure



1\. Update implementation  



2\. Regenerate certificate  



3\. Commit ONLY the certificate change  

&#x20;  with an explanation of the semantic change  



\---



\## Enforcement



CI enforces:



\- stability of golden artifacts  

\- rejection of unintended changes  



Semantic change must be explicit.

