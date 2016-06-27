# OData Compiler

An easy way to use the compile chain from OData Url to SQL.

SQL engines supported:

* postgres (default
* websql
* mysql

*Notes:*

* Currently, the OData URL is assumed to refer to a `GET` request.
* The resources are those described in the `client-model.json` in the `odata-to-abstract-sql` package.