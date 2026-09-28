# Securing Passwords in Application Design

Oracle provides strategies for securely invoking password services, such as from scripts, and for applying these strategies to other sensitive data.
- General Guidelines for Securing Passwords in Applications Guidelines for securing passwords in applications cover areas such as platform-specific security threats.
- Use of an External Password Store to Secure Passwords You can store password credentials for connecting to a database by using a client-side Oracle wallet.
````
- Securing Passwords Using the ORAPWD Utility SYSDBA or SYSOPER users can use password files to connect to an application over a network.
- Example: Java Code for Reading Passwords You can create Java packages that can be used to read passwords.
## General Guidelines for Securing Passwords in Applications
Guidelines for securing passwords in applications cover areas such as platform-specific security threats.
- Platform-Specific Security Threats You should be aware of potential security threats, which may not be obvious.
- Guidelines for Designing Applications to Handle Password Input Oracle provides guidelines for designing applications to handle password input.
- Guidelines for Configuring Password Formats and Behavior Oracle Database provides guidelines for configuring password formats and behavior.
- Guidelines for Handling Passwords in SQL Scripts Oracle provides guidelines for handling passwords in SQL scripts.
### Platform-Specific Security Threats
You should be aware of potential security threats, which may not be obvious.
These security threats are as follows:
****
- On UNIX and Linux platforms, command parameters are available for viewing by all operating system users on the same host computer. As a result, passwords entered on the command line could be exposed to other users. However, do not assume that non-UNIX and Linux platforms are safe from this threat.
****
- On some UNIX platforms, such as HP Tru64 and IBM AIX, environment variables for all processes are available for viewing by all operating system users. However, do not assume that non-UNIX and Linux platforms are safe from this threat.
******
- On Microsoft Windows, the command recall feature (the Up arrow) remembers user input across command invocations. For example, if you use the CONNECT SYSTEM/password notation in SQL*Plus, exit, and then press the Up arrow to repeat the CONNECT command, the command recall feature reveals the connect string and displays the password. In addition, do not assume that non-Microsoft Windows platforms are safe from this threat.
### Guidelines for Designing Applications to Handle Password Input
Oracle provides guidelines for designing applications to handle password input.
****
- Design applications to interactively prompt for passwords. For command-line utilities, do not force users to expose passwords at a command prompt. Check the APIs for the programming language you use to design applications for the best way to handle passwords from users. For an example of Java code that handles this functionality, see Example: Java Code for Reading Passwords.
****````
**````
**
- Protect your database against code injection attacks. Code injection attacks most commonly occur in the client application tool that sends SQL to the database (for example, SQL*Plus, or any Oracle Call Interface (OCI) or JDBC application. This includes database drivers that are built using these tools. A SQL injection attack causes SQL statements to behave in a manner that is not intended by the PL/SQL application. The injection attack takes place before the statement is sent to the database. For example, an intruder can bypass password authentication by setting a WHERE clause to TRUE. To address the problem of SQL injection attacks, use bind variable arguments or create validation checks. If you cannot use bind variables, then consider using the DBMS_ASSERT PL/SQL package to validate the properties of input values. Oracle Database PL/SQL Packages and Types Reference describes the DBMS_ASSERT package in detail. You also should review any grants to roles such as PUBLIC. Note that client applications users may not always associate SQL injection with PL/SQL, because the injection could occur before the statement is sent to the database. See Oracle Database PL/SQL Language Reference for more information about preventing SQL injection.
****
  - Use certificates for logins.
  - Authenticate users by using facilities provided by the operating system. For example, applications on Microsoft Windows can use domain authentication.
****
- Mask or encrypt passwords. If you must store passwords, then mask or encrypt them. For example, you can mask passwords in log files and encrypt passwords in recovery files.
****````
- Authenticate each connection. For example, if schema A exists in database 1, then do not assume that schema A in database 2 is the same user. Similarly, the local operating system user psmith is not necessarily the same person as remote user psmith.
****
- Do not store clear text passwords in files or repositories. Storing passwords in files increases the risk of an intruder accessing them.
****
  - You can grant a single database user proxy authentication to act as other database users. In this case, only a single database password is needed. See Proxy User Accounts and the Authorization of Users to Connect Through Them for more information.
**
  - You can create a password wallet, which can be opened by the master password. The wallet then contains the other passwords. See Oracle Database Enterprise User Security Administrator’s Guide for more information about Wallet Manager.
### Guidelines for Configuring Password Formats and Behavior
Oracle Database provides guidelines for configuring password formats and behavior.
****
- Limit the lifetime for passwords. You can set a password lifetime, after which the password expires and must be changed before the user can log in to the account. See About Controlling Password Aging and Expiration for parameters you can use to control the lifetime of a password.
****
- Limit the ability of users to reuse old passwords. See Controlling the User Ability to Reuse Previous Passwords for more information.
****
- Force users to create strong, secure passwords. See Guidelines for Securing Passwords for advice on creating strong passwords. About Password Complexity Verification explains how you can customize password requirements.
****
- Enable case sensitivity in passwords. See Managing Password Case Sensitivity for more information.
### Guidelines for Handling Passwords in SQL Scripts
Oracle provides guidelines for handling passwords in SQL scripts.
**
- *Do not invoke SQLPlus with a password on the command line, either in programs or scripts.** If a password is required but omitted, SQL*Plus prompts the user for it and then automatically disables the echo feature so that the password is not displayed. The following examples are secure because passwords are not exposed on the command line. Oracle Database also automatically encrypts these passwords over the network.
```
$ sqlplus system Enter password: password SQL> CONNECT SYSTEM Enter password: password
```
The following example exposes the password to other operating system users:
```
sqlplus system/password
```
The next example poses two security risks. First, it exposes the password to other users who may be watching over your shoulder. Second, on some platforms, such as Microsoft Windows, it makes the password vulnerable to a command line recall attack.
```
$ sqlplus /nolog SQL> CONNECT SYSTEM/password
```
  ****- For SQL scripts that require passwords or secret keys, for example, to create an account or to log in as an account, do not use positional parameters, such as substitution variables &1, &2, and so on. Instead, design the script to prompt the user for the value. You should also disable the echo feature, which displays output from a script or if you are using spool mode. To disable the echo feature, use the following setting:
```
SET ECHO OFF
```
A good practice is to ensure that the script makes the purpose of the value clear. For example, it should be clear whether or not the value will establish a new value, such as an account or a certificate, or if the value will authenticate, such as logging in to an existing account.
The following example is secure because it prevents users from invoking the script in a manner that poses security risks: It does not echo the password; it does not record the password in a spool file.
```
SET VERIFY OFF ACCEPT user CHAR PROMPT 'Enter user to connect to: ' ACCEPT password CHAR PROMPT 'Enter the password for that user: ' HIDE CONNECT &user/&password
```
In this example:
````````
- SET VERIFY OFF prevents the password from being displayed. (SET VERIFY lists each line of the script before and after substitution.) Combining the SET VERIFY OFF command with the HIDE command is a useful technique for hiding passwords and other sensitive input data.
``````
- ACCEPT password CHAR PROMPT includes the HIDE option for the ACCEPT password prompt, which prevents the input password from being echoed.
The next example, which uses positional parameters, poses security risks because a user may invoke the script by passing the password on the command line. If the user does not enter a password and instead is prompted, the danger lies in that whatever the user types is echoed to the screen and to a spool file if spooling is enabled.
```
CONNECT &1/&2
```
****
- Control the log in times for batch scripts. For batch scripts that require passwords, configure the account so that the script can only log in during the time in which it is supposed to run. For example, suppose you have a batch script that runs for an hour each evening starting at 8 p.m. Set the account so that the script can only log in during this time. If an intruder manages to gain access, then he or she has less of a chance of exploiting any compromised accounts.
****
- Be careful when using DML or DDL SQL statements that prompt for passwords. In this case, sensitive information is passed in clear text over the network. You can remedy this problem by using Oracle strong authentication. The following example of altering a password is secure because the password is not exposed:
```
password psmith Changing password for psmith New password: password Retype new password: password
```
This example poses a security risk because the password is exposed both at the command line and on the network:
```
ALTER USER psmith IDENTIFIED BY password
```
## Use of an External Password Store to Secure Passwords
You can store password credentials for connecting to a database by using a client-side Oracle wallet.
An Oracle wallet is a secure software container that stores the authentication and signing credentials needed for a user to log in.
## Securing Passwords Using the ORAPWD Utility
`SYSDBA` or `SYSOPER` users can use password files to connect to an application over a network.
  - To create the password file, use the ORAPWD utility.
## Example: Java Code for Reading Passwords
You can create Java packages that can be used to read passwords.
Example 12-1 demonstrates how to create a Java package that can be used to read passwords.
Example 12-1 Java Code for Reading Passwords
```
// Change the following line to a name for your version of this package package passwords.sysman.emSDK.util.signing;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PushbackInputStream;
import java.util.Arrays;
/**
 * The static readPassword method in this class issues a password prompt
 * on the console output and returns the char array password
 * entered by the user on the console input.
*/ public final class ReadPassword { //---------------------------------- /**
  * Test driver for readPassword method.
  * @param args the command line args
*/ public static void main(String[] args) { char[] pass = ReadPassword.readPassword("Enter password: ");
System.out.println("The password just entered is "" + new String(pass) + """);
System.out.println("The password length is " + pass.length);
}
  * Issues a password prompt on the console output and returns
  * the char array password entered by the user on the console input.
  * The password is not displayed on the console (chars are not echoed).
  * As soon as the returned char array is not needed,
  * it should be erased for security reasons (Arrays.fill(charArr, ' '));
  * A password should never be stored as a java String.
*
  * Note that Java 6 has a Console class with a readPassword method,
  * but there is no equivalent in Java 5 or Java 1.4.
  * The readPassword method here is based on Sun's suggestions at
  * http://java.sun.com/developer/technicalArticles/Security/pwordmask.
*
  * @param prompt the password prompt to issue
  * @return new char array containing the password
  * @throws RuntimeException if some error occurs
*/ public static final char[] readPassword(String prompt) throws RuntimeException { try { StreamMasker masker = new StreamMasker(System.out, prompt);
Thread threadMasking = new Thread(masker);
int firstByte = -1;
PushbackInputStream inStream = null;
try { threadMasking.start();
inStream = new PushbackInputStream(System.in);
firstByte = inStream.read();
} finally { masker.stopMasking();
} try { threadMasking.join();
} catch (InterruptedException e) { throw new RuntimeException("Interrupt occurred when reading password");
} if (firstByte == -1) { throw new RuntimeException("Console input ended unexpectedly");
} if (System.out.checkError()) { throw new RuntimeException("Console password prompt output error");
} inStream.unread(firstByte);
return readLineSecure(inStream);
} catch (IOException e) { throw new RuntimeException("I/O error occurred when reading password");
} } //---------------------------------- /**
  * Reads one line from an input stream into a char array in a secure way
  * suitable for reading a password.
  * The char array will never contain a '\n' or '\r'.
*
  * @param inStream the pushback input stream
  * @return line as a char array, not including end-of-line-chars;
  * never null, but may be zero length array
  * @throws RuntimeException if some error occurs
*/ private static final char[] readLineSecure(PushbackInputStream inStream) throws RuntimeException { if (inStream == null) { throw new RuntimeException("readLineSecure inStream is null");
} try { char[] buffer = null;
try { buffer = new char[128];
int offset = 0;
// EOL is '\n' (unix), '\r\n' (windows), '\r' (mac) loop:
while (true) { int c = inStream.read();
switch (c) { case -1:
case '\n':
break loop;
case '\r':
int c2 = inStream.read();
if ((c2 != '\n') && (c2 != -1)) inStream.unread(c2);
break loop;
default:
buffer = checkBuffer(buffer, offset);
buffer[offset++] = (char) c;
break;
} } char[] result = new char[offset];
System.arraycopy(buffer, 0, result, 0, offset);
return result;
} finally { if (buffer != null) Arrays.fill(buffer, ' ');
} } catch (IOException e) { throw new RuntimeException("I/O error occurred when reading password");
} } //---------------------------------- /**
  * This is a helper method for readLineSecure.
*
  * @param buffer the current char buffer
  * @param offset the current position in the buffer
  * @return the current buffer if it is not yet full;
  * otherwise return a larger buffer initialized with a copy
  * of the current buffer and then erase the current buffer
  * @throws RuntimeException if some error occurs
*/ private static final char[] checkBuffer(char[] buffer, int offset) throws RuntimeException { if (buffer == null) throw new RuntimeException("checkBuffer buffer is null");
if (offset < 0) throw new RuntimeException("checkBuffer offset is negative");
if (offset < buffer.length) return buffer;
else { try { char[] bufferNew = new char[offset + 128];
System.arraycopy(buffer, 0, bufferNew, 0, buffer.length);
return bufferNew;
} finally { Arrays.fill(buffer, ' ');
} } } //---------------------------------- /**
  * This private class prints a one line prompt
  * and erases reply chars echoed to the console.
*/ private static final class StreamMasker extends Thread { private static final String BLANKS = StreamMasker.repeatChars(' ', 10);
private String m_promptOverwrite;
private String m_setCursorToStart;
private PrintStream m_out;
private volatile boolean m_doMasking;
//---------------------------------- /**
  * Constructor.
  * @throws RuntimeException if some error occurs
*/ public StreamMasker(PrintStream outPrint, String prompt) throws RuntimeException { if (outPrint == null) throw new RuntimeException("StreamMasker outPrint is null");
if (prompt == null) throw new RuntimeException("StreamMasker prompt is null");
if (prompt.indexOf('\r') != -1) throw new RuntimeException("StreamMasker prompt contains a CR");
if (prompt.indexOf('\n') != -1) throw new RuntimeException("StreamMasker prompt contains a NL");
m_out = outPrint;
m_setCursorToStart = StreamMasker.repeatChars('\010', prompt.length() + BLANKS.length());
m_promptOverwrite = m_setCursorToStart + prompt + BLANKS + m_setCursorToStart + prompt;
} //---------------------------------- /**
  * Begin masking until asked to stop.
  * @throws RuntimeException if some error occurs
*/ public void run() throws RuntimeException { int priorityOriginal = Thread.currentThread().getPriority();
Thread.currentThread().setPriority(Thread.MAX_PRIORITY);
try { m_doMasking = true;
while (m_doMasking) { m_out.print(m_promptOverwrite);
if (m_out.checkError()) throw new RuntimeException("Console output error writing prompt");
try { Thread.currentThread().sleep(1);
} catch (InterruptedException ie) { Thread.currentThread().interrupt();
return;
} } m_out.print(m_setCursorToStart);
} finally { Thread.currentThread().setPriority(priorityOriginal);
} } //---------------------------------- /**
  * Instructs the thread to stop masking.
*/ public void stopMasking() { m_doMasking = false;
} //---------------------------------- /**
  * Returns a repeated char string.
*
  * @param c the char to repeat
  * @param length the number of times to repeat the char
  * @throws RuntimeException if some error occurs
*/ private static String repeatChars(char c, int length) throws RuntimeException { if (length < 0) throw new RuntimeException("repeatChars length is negative");
StringBuffer sb = new StringBuffer(length);
for (int i = 0; i < length; i++) sb.append(c);
return sb.toString();
} } }
```
## Related Topics
  - Minimum Requirements for Passwords
  - About Password Complexity Verification
  - Managing the Secure External Password Store for Password Credentials for more information about the secure external password store
  **- Oracle Database Enterprise User Security Administrator’s Guide for information about using Oracle Wallet Manager to configure Oracle wallets
  **- Oracle Database Administrator’s Guide for more information about creating and maintaining a password file
