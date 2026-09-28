# 基于ODBC开发

- **[ODBC包及依赖的库和头文件](odbc_packages_dependent_libraries_and_header_files.md)**

- **[Linux下配置数据源](configuring_a_data_source_in_the_linux_os.md)**

- **[开发流程](development_process_odbc.md)**

- **[示例](example_common_functions_and_batch_binding.md)**

- **[典型应用场景配置](typical_application_scenarios_and_configurations.md)**

- **[ODBC接口参考](odbc_interface_reference.md)**

ODBC（Open Database Connectivity，开放数据库互连）是由Microsoft公司基于X/OPEN CLI提出的用于访问数据库的应用程序编程接口。应用程序通过ODBC提供的API与数据库进行交互，增强了应用程序的可移植性、扩展性和可维护性。

ODBC的系统结构参见[图1](#fig1255101034110)。

**图 1**  ODBC系统机构 ![](figures/ODBC-System-Organization.png)

openGauss目前在以下环境中提供对ODBC3.5的支持。

**表 1**  ODBC支持平台

操作系统 CentOS 6.4/6.5/6.6/6.7/6.8/6.9/7.0/7.1/7.2/7.3/7.4 x86_64位 CentOS 7.6 ARM64位 EulerOS 2.0 SP2/SP3 x86_64位 EulerOS 2.0 SP8 ARM64位 windows 7/8/10 x86_32位

UNIX/Linux系统下的驱动程序管理器主要有unixODBC和iODBC，在这选择驱动管理器unixODBC-2.3.0作为连接数据库的组件。

Windows系统自带ODBC驱动程序管理器，在控制面板-\>管理工具中可以找到数据源（ODBC）选项，可以参考odbc文档。

>[!NOTE]说明
>当前数据库ODBC驱动基于开源版本，对于tinyint、smalldatetime、nvarchar、nvarchar2类型，在获取数据类型的时候，可能会出现不兼容。
