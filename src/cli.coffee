program = require 'commander'

runCompile = (inputUrl) ->
	odataCompiler = require './odata-compiler'
	sql = odataCompiler(inputUrl, program.engine)

	console.log("Parsing OData URL: #{inputUrl}")
	console.log('')
	console.log(sql)

program
	.version(require('../package.json').version)
	.option('-e, --engine <engine>', 'The target database engine (postgres|websql|mysql), default: postgres', /postgres|websql|mysql/, 'postgres')

program.command('compile <input-URL>')
	.description('compile the input OData Url into SQL')
	.action(runCompile)

program.command('parse <input-URL>')
	.description('parse the input OData Url into an OData AST')
	.action (inputUrl) ->
		odataCompiler = require './odata-compiler'
		ast = odataCompiler.parse(inputUrl)

		console.log("Parsing OData URL: #{inputUrl}")
		console.log('')
		console.log(require('util').inspect(ast, depth: null))

program.command('help')
	.description('print the help')
	.action ->
		program.help()

program
	.arguments('<input-URL>')
	.action(runCompile)

if process.argv.length is 2
	program.help()

program.parse(process.argv)