# GS\_PACKAGE

GS\_PACKAGE系统表记录PACKAGE内的信息。

**表 1**  GS\_PACKAGE字段

oid oid 行标识符（隐含属性，必须明确选择）。
pkgnamespace oid package所属schema。
pkgowner oid package的所属者。
pkgname name package的名字。
pkgspecsrc text package specification的内容。
pkgbodydeclsrc text package body的内容。
pkgbodyinitsrc text package init的内容。
pkgacl aclitem 访问权限。
pkgsecdef boolean package是否是定义者权限。
