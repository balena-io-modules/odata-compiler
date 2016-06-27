AbstractSQLCompiler = require '@resin/abstract-sql-compiler'
{ ODataParser } = require '@resin/odata-parser'
{ OData2AbstractSQL } = require '@resin/odata-to-abstract-sql'
clientModel = require '@resin/odata-to-abstract-sql/test/client-model.json'

odataparser = ODataParser.createInstance()
odata2abstractsql = {}
odata2abstractsql['ewa'] = OData2AbstractSQL.createInstance()
odata2abstractsql['ewa'].clientModel = clientModel

module.exports = (url, engine) ->
	try
		parse = odataparser.matchAll(url, 'Process')
	catch e
		e.message = "Error parsing the OData URL: #{e.message}"
		throw e

	try
		result = odata2abstractsql['ewa'].match(parse, 'Process', ['GET', {}])
	catch e
		e.message = "Error transforming OData Url into AbstractSQL: #{e.message}"
		throw e

	try
		sql = AbstractSQLCompiler[engine].compileRule(result)
	catch e
		e.message = "Error compiling AbstractSQL into SQL: #{e.message}"
		throw e

	return sql['query']