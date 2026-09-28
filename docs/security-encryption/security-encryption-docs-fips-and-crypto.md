# FIPS and Certified Cryptography

Configure FIPS mode with the next-generation cryptographic provider, or use the legacy FIPS 140-2 parameters for existing deployments.
## When FIPS Mode Is Required
Enable the applicable FIPS mode when required by organizational policy, procurement, or regulation. Confirm the Oracle Database 19c release update, platform, cryptographic provider, allowed algorithms, and module validation status with the compliance owner.
## FIPS Support by Cryptographic Provider
Oracle Database 19c supports FIPS 140-2 and FIPS 140-3 with the next-generation cryptographic provider, and FIPS 140-2 with the legacy provider. Only one provider can be active in a database instance.

| Cryptographic provider | FIPS standard | Configuration |
|---|---|---|
| Next-generation cryptographic provider | FIPS 140-2 and FIPS 140-3 | Set FIPS_140=TRUE in fips.ora for FIPS 140-2. Set both FIPS_140=TRUE and FIPS_140_3=TRUE in fips.ora for FIPS 140-3. |
| Legacy provider | FIPS 140-2 | Use the legacy parameters for TDE and DBMS_CRYPTO, TLS, and native network encryption. |

FIPS and post-quantum cryptography (PQC) address different requirements. FIPS concerns use of a validated cryptographic provider. PQC concerns resilience against future quantum attacks.
## Configure FIPS 140-3 with the Next-Generation Cryptographic Provider
For new FIPS deployments, use the next-generation cryptographic provider. To configure FIPS 140-3, set the required parameters in `fips.ora`. Before changing the parameters, switch the database to the next-generation provider.
```
FIPS_140=TRUE
FIPS_140_3=TRUE
```
- In fips.ora, set the following parameters:
- Restart the database instance and Oracle Net listener.
`FIPS_140_3=TRUE` enables FIPS 140-3 mode with the next-generation cryptographic provider. `FIPS_140_3` does not enable FIPS mode by itself; set both parameters.
**Note:** Do not use `FIPS_140` and `FIPS_140_3` to configure FIPS 140-2 with the legacy provider. Use the legacy parameters instead. The `SSLFIPS_140` parameter remains supported but is deprecated when the next-generation provider is active.
## Use Legacy FIPS 140-2 Parameters
FIPS 140-2 remains supported with the legacy provider. Use the following parameters for existing deployments, and for Oracle Database versions that use the legacy provider.
  ````- DBFIPS_140=TRUE is an initialization parameter that enables FIPS 140-2 mode for Transparent Data Encryption (TDE) and DBMS_CRYPTO.
  ``````- SSLFIPS_140=TRUE in fips.ora enables FIPS 140-2 mode for Transport Layer Security (TLS). When using Oracle Instant Client, also set SSLFIPS_LIB to the FIPS library location.
  ````- SQLNET.FIPS_140=TRUE in sqlnet.ora enables FIPS 140-2 mode for native network encryption.
Restart the database and affected Oracle Net services after changing FIPS configuration.
**Note:** The legacy parameters are deprecated when the next-generation provider is active. Use `FIPS_140` and `FIPS_140_3` for FIPS 140-3 with the next-generation cryptographic provider.
## Related Topics
  - Oracle Database FIPS Settings
  - Switching the Cryptographic Provider for Oracle Database 19c
