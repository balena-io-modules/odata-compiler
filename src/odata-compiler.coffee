AbstractSQLCompiler = require '@resin/abstract-sql-compiler'
{ ODataParser } = require '@resin/odata-parser'
{ OData2AbstractSQL } = require '@resin/odata-to-abstract-sql'
clientModel = require '@resin/odata-to-abstract-sql/test/client-model.json'

odataParser = ODataParser.createInstance()
odata2AbstractSql = OData2AbstractSQL.createInstance()
odata2AbstractSql.clientModel = clientModel

module.exports = (url, engine) ->
	odataAST = module.exports.parse(url)
	abstractSql = module.exports.translate(odataAST)
	sql = module.exports.translate(abstractSql, engine)

	return sql['query']

module.exports.parse = (url) ->
	if url[0] isnt '/'
		throw new Error('URL must start with a /')
	try
		return odataParser.matchAll(url, 'Process')
	catch e
		e.message = "Error parsing the OData URL: #{e.message}"
		throw e

module.exports.translate = (odataAST) ->
	try
		return odata2AbstractSql.match(odataAST, 'Process', ['GET', {}])
	catch e
		e.message = "Error transforming OData Url into AbstractSQL: #{e.message}"
		throw e

module.exports.compile = (abstractSql, engine) ->
	try
		return AbstractSQLCompiler[engine].compileRule(abstractSql)
	catch e
		e.message = "Error compiling AbstractSQL into SQL: #{e.message}"
		throw e
