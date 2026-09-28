# ALTER PACKAGE

## 功能描述

修改PACKAGE的属性或重编译PACKAGE。当PACKAGE因为依赖的引用对象发生改变而变为失效状态后，直接使用PACKAGE中失效的对象可能会导致错误的执行结果。如PACKAGE中定义存储过程的入参依赖自定义的类型或表字段，对自定义类型或表字段添加新属性后，调用原来的存储过程无法向新添加的属性传参，openGauss支持对这种场景下的PACKAGE进行重新编译，恢复其有效状态。

## 注意事项

+ 目前仅支持ALTER PACKAGE OWNER和ALTER PACKAGE COMPILE功能，系统管理员默认拥有该权限，有以下权限约束： + 当前用户必须是该PACKAGE的所有者或者系统管理员，且该用户是新所有者角色的成员。
+ 仅有初始化用户可以修改定义者权限的package的owner。

## 语法格式

- 修改PACKAGE的所属者。

    ```
    ALTER PACKAGE package_name OWNER TO new_owner;
    ```

- 重编译PACKAGE。

    ```
    ALTER PACKAGE package_name COMPILE { compile_pkg_opt } ;
    ```

## 参数说明

- **package\_name**

要修改的PACKAGE名称。

取值范围：已存在的PACKAGE名，仅支持修改单个PACKAGE。

- **new\_owner**

PACKAGE的新所有者。要修改函数的所有者，新所有者必须拥有该PACKAGE所属模式的CREATE权限。

取值范围：已存在的用户角色。

- **compile\_pkg\_opt**

重编译PACKAGE的选项，包括SPECIFICATION, BODY, PACKAGE或不指定，不指定时默认选项为PACKAGE。

## 示例

请参见[CREATE PACKAGE](create_package.md)中示例。

## 相关链接

[CREATE PACKAGE](create_package.md)，[DROP PACKAGE](drop_package.md)
