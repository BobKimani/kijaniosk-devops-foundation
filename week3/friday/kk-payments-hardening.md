# KK Payments Hardening

Initial score: 6.5

Changes made:

- Added NoNewPrivileges → 5.8
- Added PrivateTmp → 4.9
- Added ProtectSystem=strict → 3.5
- Added ProtectHome → 2.4

Rejected directives:

- SystemCallFilter → broke application startup
- MemoryDenyWriteExecute → incompatible with runtime

Final score: 2.4

Conclusion:
Balanced security and functionality achieved.
