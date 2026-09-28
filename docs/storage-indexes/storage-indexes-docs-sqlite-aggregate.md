# SQLite lang_aggfunc\n\n来源: sqlite.org/lang_aggfunc.html\n\n

Built-in Aggregate Functions

Small. Fast. Reliable.
Choose any three.

Home

Menu

About

Documentation

Download

License

Support

Purchase

Search

About

Documentation

Download

Support

Purchase

Search Documentation

Search Changelog

Built-in Aggregate Functions

1.
Syntax

aggregate-function-invocation:

hide

aggregate-func

(

DISTINCT

expr

)

filter-clause

,

*

ORDER

BY

ordering-term

,

expr:

show

literal-value

bind-parameter

schema-name

.

table-name

.

column-name

unary-operator

expr

expr

binary-operator

expr

function-name

(

function-arguments

)

filter-clause

over-clause

(

expr

)

,

CAST

(

expr

AS

type-name

)

expr

COLLATE

collation-name

expr

NOT

LIKE

GLOB

REGEXP

MATCH

expr

expr

ESCAPE

expr

expr

ISNULL

NOTNULL

NOT

NULL

expr

IS

NOT

DISTINCT

FROM

expr

expr

NOT

BETWEEN

expr

AND

expr

expr

NOT

IN

(

select-stmt

)

expr

,

schema-name

.

table-function

(

expr

)

table-name

,

NOT

EXISTS

(

select-stmt

)

CASE

expr

WHEN

expr

THEN

expr

ELSE

expr

END

raise-function

function-arguments:

show

DISTINCT

expr

,

*

ORDER

BY

ordering-term

,

literal-value:

show

CURRENT_TIMESTAMP

numeric-literal

string-literal

blob-literal

NULL

TRUE

FALSE

CURRENT_TIME

CURRENT_DATE

over-clause:

show

OVER

window-name

(

base-window-name

PARTITION

BY

expr

,

ORDER

BY

ordering-term

,

frame-spec

)

frame-spec:

show

GROUPS

BETWEEN

UNBOUNDED

PRECEDING

AND

UNBOUNDED

FOLLOWING

RANGE

ROWS

UNBOUNDED

PRECEDING

expr

PRECEDING

CURRENT

ROW

expr

PRECEDING

CURRENT

ROW

expr

FOLLOWING

expr

PRECEDING

CURRENT

ROW

expr

FOLLOWING

EXCLUDE

CURRENT

ROW

EXCLUDE

GROUP

EXCLUDE

TIES

EXCLUDE

NO

OTHERS

raise-function:

show

RAISE

(

ROLLBACK

,

expr

)

IGNORE

ABORT

FAIL

select-stmt:

show

WITH

RECURSIVE

common-table-expression

,

SELECT

DISTINCT

result-column

,

ALL

FROM

table-or-subquery

join-clause

,

WHERE

expr

GROUP

BY

expr

HAVING

expr

,

WINDOW

window-name

AS

window-defn

,

VALUES

(

expr

)

,

,

compound-operator

select-core

ORDER

BY

LIMIT

expr

ordering-term

,

OFFSET

expr

,

expr

common-table-expression:

show

table-name

(

column-name

)

AS

NOT

MATERIALIZED

(

select-stmt

)

,

compound-operator:

show

UNION

UNION

INTERSECT

EXCEPT

ALL

join-clause:

show

table-or-subquery

join-operator

table-or-subquery

join-constraint

join-constraint:

show

USING

(

column-name

)

,

ON

expr

join-operator:

show

NATURAL

LEFT

OUTER

JOIN

,

RIGHT

FULL

INNER

CROSS

result-column:

show

expr

AS

column-alias

*

table-name

.

*

table-or-subquery:

show

schema-name

.

table-name

AS

table-alias

INDEXED

BY

index-name

NOT

INDEXED

table-function-name

(

expr

)

,

<path d="M407.604,304.344L411.579,304.344A1
