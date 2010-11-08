sys = require 'sys'
path = require 'path'
fs = require 'fs'

paperboy = ext 'paperboy'

@handle_request =->
	ip = @Request.ip
	
	pb = paperboy.deliver(@Config.public_dir, @Request, @Response)
	pb = pb.addHeader 'Expires', 300
	pb = pb.addHeader 'X-PaperRoute', 'Node'
	pb = pb.before () => @log "Serving static file for #{@Request.url}..."
	pb = pb.after (statCode) => @log statCode
	pb = pb.error (statCode,msg) =>
			@Response.writeHead(statCode, {'Content-Type': 'text/plain'})
			@Response.end("An error occurred.")
			@log statCode
	pb = pb.otherwise (err) =>
			statCode = 404;
			@Response.writeHead(statCode, {'Content-Type': 'text/plain'})
			@Response.end("File not found.")
			@log statCode