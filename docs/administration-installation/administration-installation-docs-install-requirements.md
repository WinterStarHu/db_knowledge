# PostgreSQL: Documentation: 18: 17.1. Requirements

PostgreSQL: Documentation: 18: 17.1. Requirements Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
/
9.4
/
9.3
/
9.2
/
9.1
/
9.0
/
8.4
/
8.3
/
8.2
/
8.1
/
8.0
/
7.4
/
7.3
/
7.2
/
7.1
17.1. Requirements
Prev Up Chapter 17. Installation from Source Code Home Next
17.1. Requirements #
In general, a modern Unix-compatible platform should be able to run PostgreSQL. The platforms that had received specific testing at the time of release are described in Section 17.6 below.
The following software packages are required for building PostgreSQL:
GNU make version 3.81 or newer is required; other make programs or older GNU make versions will not work. (GNU make is sometimes installed under the name gmake.) To test for GNU make enter:
make --version Alternatively, PostgreSQL can be built using Meson. This is the only option for building PostgreSQL on Windows using Visual Studio. For other platforms, using Meson is currently experimental. If you choose to use Meson, then you don't need GNU make, but the other requirements below still apply.
The minimum required version of Meson is 0.54.
You need an ISO/ANSI C compiler (at least C99-compliant). Recent versions of GCC are recommended, but PostgreSQL is known to build using a wide variety of compilers from different vendors.
tar is required to unpack the source distribution, in addition to either gzip or bzip2.
Flex and Bison are required. Other lex and yacc programs cannot be used. Bison needs to be at least version 2.3.
Perl 5.14 or later is needed during the build process and to run some test suites. (This requirement is separate from the requirements for building PL/Perl; see below.) The GNU Readline library is used by default. It allows psql (the PostgreSQL command line SQL interpreter) to remember each command you type, and allows you to use arrow keys to recall and edit previous commands. This is very helpful and is strongly recommended. If you don't want to use it then you must specify the --without-readline option to configure. As an alternative, you can often use the BSD-licensed libedit library, originally developed on NetBSD. The libedit library is GNU Readline-compatible and is used if libreadline is not found, or if --with-libedit-preferred is used as an option to configure. If you are using a package-based Linux distribution, be aware that you need both the readline and readline-devel packages, if those are separate in your distribution.
The zlib compression library is used by default. If you don't want to use it then you must specify the --without-zlib option to configure. Using this option disables support for compressed archives in pg_dump and pg_restore.
The ICU library is used by default. If you don't want to use it then you must specify the --without-icu option to configure. Using this option disables support for ICU collation features (see Section 23.2).
ICU support requires the ICU4C package to be installed. The minimum required version of ICU4C is currently 4.2.
By default, pkg-config will be used to find the required compilation options. This is supported for ICU4C version 4.6 and later. For older versions, or if pkg-config is not available, the variables ICU_CFLAGS and ICU_LIBS can be specified to configure, like in this example:
./configure ... ICU_CFLAGS='-I/some/where/include' ICU_LIBS='-L/some/where/lib -licui18n -licuuc -licudata' (If ICU4C is in the default search path for the compiler, then you still need to specify nonempty strings in order to avoid use of pkg-config, for example, ICU_CFLAGS=' '.) The following packages are optional. They are not required in the default configuration, but they are needed when certain build options are enabled, as explained below:
To build the server programming language PL/Perl you need a full Perl installation, including the libperl library and the header files. The minimum required version is Perl 5.14. Since PL/Perl will be a shared library, the  libperl library must be a shared library also on most platforms. This appears to be the default in recent Perl versions, but it was not in earlier versions, and in any case it is the choice of whomever installed Perl at your site. configure will fail if building PL/Perl is selected but it cannot find a shared libperl. In that case, you will have to rebuild and install Perl manually to be able to build PL/Perl. During the configuration process for Perl, request a shared library.
If you intend to make more than incidental use of PL/Perl, you should ensure that the Perl installation was built with the usemultiplicity option enabled (perl -V will show whether this is the case).
To build the PL/Python server programming language, you need a Python installation with the header files and the sysconfig module. The minimum supported version is Python 3.6.8.
Since PL/Python will be a shared library, the  libpython library must be a shared library also on most platforms. This is not the case in a default Python installation built from source, but a shared library is available in many operating system distributions. configure will fail if building PL/Python is selected but it cannot find a shared libpython. That might mean that you either have to install additional packages or rebuild (part of) your Python installation to provide this shared library. When building from source, run Python's configure with the --enable-shared flag.
To build the PL/Tcl procedural language, you of course need a Tcl installation. The minimum required version is Tcl 8.4.
To enable Native Language Support (NLS), that is, the ability to display a program's messages in a language other than English, you need an implementation of the Gettext API. Some operating systems have this built-in (e.g., Linux, NetBSD, Solaris), for other systems you can download an add-on package from https://www.gnu.org/software/gettext/. If you are using the Gettext implementation in the GNU C library, then you will additionally need the GNU Gettext package for some utility programs. For any of the other implementations you will not need it.
You need OpenSSL, if you want to support encrypted client connections. OpenSSL is also required for random number generation on platforms that do not have /dev/urandom (except Windows). The minimum required version is 1.1.1.
Additionally, LibreSSL is supported using the OpenSSL compatibility layer. The minimum required version is 3.4 (from OpenBSD version 7.0).
You need MIT Kerberos (for GSSAPI), OpenLDAP, and/or PAM, if you want to support authentication using those services.
You need Curl to build an optional module which implements the OAuth Device Authorization flow for client applications.
You need LZ4, if you want to support compression of data with that method; see default_toast_compression and wal_compression.
You need Zstandard, if you want to support compression of data with that method; see wal_compression. The minimum required version is 1.4.0.
To build the PostgreSQL documentation, there is a separate set of requirements; see Section J.2.
If you need to get a GNU package, you can find it at your local GNU mirror site (see https://www.gnu.org/prep/ftp for a list) or at ftp://ftp.gnu.org/gnu/.
Prev Up Next Chapter 17. Installation from Source Code Home
17.2. Getting the Source
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
