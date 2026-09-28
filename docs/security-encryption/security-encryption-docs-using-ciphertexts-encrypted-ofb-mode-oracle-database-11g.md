# Using Ciphertexts Encrypted in OFB Mode in Oracle Database Release 11g

In Oracle Database Release 11g, ciphertexts configured to use output feedback (OFB) used electronic codebook (ECB) mode instead.
In Oracle Database Release 11*g*, if you set the `DBMS_CRYPTO.CHAIN_OFB` block cipher chaining modifier to configure ciphertext encryption to use output feedback (OFB) mode, then due to Oracle Bug 13001552, the result is that the configuration used electronic codebook (ECB) mode erroneously. This bug has been fixed in Oracle Database Release 12c. Therefore, after an upgrade from Oracle Database release 11g to Release 12c, the ciphertexts that were encrypted using OFB mode in release 11g will no longer decrypt properly in the corrected OFB mode in Oracle Database Release 12c or later.
To remedy this problem:
````
- Log in to the database as a user who has the EXECUTE privilege for the DBMS_CRYPTO PL/SQL package.
- Decrypt the cyphertexts using the DBMS_CRYPTO.CHAIN_ECB block cipher chaining modifier.
The following example, `dbmscrypto11.sql`, shows the wrong behavior in Oracle Database Release 11*g*:
```
dbmscrypto11.sql:
set serveroutput on declare l_mod_ofb pls_integer;
l_mod_ecb pls_integer;
v_key raw(32);
v_iv  raw(16);
v_test_in raw(16);
v_ciphertext raw(16);
v_test_out_ECB raw(16);
v_test_out_OFB raw(16);
begin l_mod_ofb := dbms_crypto.ENCRYPT_AES256 + dbms_crypto.CHAIN_OFB + DBMS_CRYPTO.PAD_NONE ;
l_mod_ecb := dbms_crypto.ENCRYPT_AES256 + dbms_crypto.CHAIN_ECB + DBMS_CRYPTO.PAD_NONE ;
v_key := hextoraw ('603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4');
v_iv :=   hextoraw('000102030405060708090A0B0C0D0E0F');
v_test_in := hextoraw('6bc1bee22e409f96e93d7e117393172a');
v_ciphertext := dbms_crypto.encrypt(src => v_test_in, TYP => l_mod_ofb, key => v_key, iv => v_iv);
v_test_out_ECB := dbms_crypto.decrypt(src => v_ciphertext, TYP => l_mod_ecb, key => v_key, iv => v_iv);
v_test_out_OFB := dbms_crypto.decrypt(src => v_ciphertext, TYP => l_mod_ofb, key => v_key, iv => v_iv);
dbms_output.put_line ('Input plaintext                      : '||rawtohex(v_test_in));
dbms_output.put_line ('11g: Ciphertext (encrypt in OFB mode): '||rawtohex(v_ciphertext));
dbms_output.put_line ('11g: Output of decrypt in ECB mode   : '||rawtohex(v_test_out_ECB));
dbms_output.put_line ('11g: Output of decrypt in OFB mode   : '||rawtohex(v_test_out_OFB));
end;
/
```
The resulting output is as follows:
```
SQL> @dbmscrypto11.sql Input plaintext                      : 6BC1BEE22E409F96E93D7E117393172A 11g: Ciphertext (encrypt in OFB mode): F3EED1BDB5D2A03C064B5A7E3DB181F8 11g: Output of decrypt in ECB mode   : 6BC1BEE22E409F96E93D7E117393172A 11g: Output of decrypt in OFB mode   : 6BC1BEE22E409F96E93D7E117393172A
```
This output illustrates that in Oracle Database release 11*g*, OFB mode is wrongly ECB mode, and therefore decrypting in either OFB or ECB mode results in the correct plaintext.
The next example, `dbmscrypto12from11.sql`, shows that, after an upgrade from Oracle Database release 11*g* to release 12*c*, ECB mode and not OFB mode has to be used in order to properly decrypt a ciphertext encrypted in OFB mode in Release 11*g*.
```
dbmscrypto12from11.sql:
set serveroutput on declare l_mod_ofb pls_integer;
l_mod_ecb pls_integer;
v_key raw(32);
v_iv  raw(16);
v_test_in raw(16);
v_ciphertext11 raw(16);
v_test_out_ECB raw(16);
v_test_out_OFB raw(16);
begin l_mod_ofb := dbms_crypto.ENCRYPT_AES256 + dbms_crypto.CHAIN_OFB + DBMS_CRYPTO.PAD_NONE ;
l_mod_ecb := dbms_crypto.ENCRYPT_AES256 + dbms_crypto.CHAIN_ECB + DBMS_CRYPTO.PAD_NONE ;
v_key := hextoraw ('603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4');
v_iv :=   hextoraw('000102030405060708090A0B0C0D0E0F');
v_test_in := hextoraw('6bc1bee22e409f96e93d7e117393172a');
v_ciphertext11 := hextoraw('F3EED1BDB5D2A03C064B5A7E3DB181F8');
v_test_out_ECB := dbms_crypto.decrypt(src => v_ciphertext11, TYP => l_mod_ecb, key => v_key, iv => v_iv);
v_test_out_OFB := dbms_crypto.decrypt(src => v_ciphertext11, TYP => l_mod_ofb, key => v_key, iv => v_iv);
dbms_output.put_line ('Input plaintext (to 11g)             : '||rawtohex(v_test_in));
dbms_output.put_line ('11g: Ciphertext (encrypt in OFB mode): '||rawtohex(v_ciphertext11));
dbms_output.put_line ('12c: Output of decrypt in ECB mode   : '||rawtohex(v_test_out_ECB));
dbms_output.put_line ('12c: Output of decrypt in OFB mode   : '||rawtohex(v_test_out_OFB));
end;
/
```
The resulting output is as follows:
```
SQL> @dbmscrypto12from11.sql Input plaintext (to 11g)             : 6BC1BEE22E409F96E93D7E117393172A 11g: Ciphertext (encrypt in OFB mode): F3EED1BDB5D2A03C064B5A7E3DB181F8 12c: Output of decrypt in ECB mode   : 6BC1BEE22E409F96E93D7E117393172A 12c: Output of decrypt in OFB mode   : 4451EBE041EB29E191BBA0E9D67FAEB2
```
If you are preparing to upgrade from Oracle Database Release 11*g* to Release 12*c*, then edit any scripts that you may have in which OFB mode is specified so that the decrypt operations use ECB mode. This way, the scripts will work in both release 11g and release 12c and later, ensuring business continuity.
