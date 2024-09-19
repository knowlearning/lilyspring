local tmpFilename = os.tmpname() .. ".ly"
local outputFilename = tmpFilename:gsub(".ly$", "")

local tmpFile = io.open(tmpFilename, "w")
tmpFile:write(ngx.var.uri:sub(2))
tmpFile:close()

local pipe = io.popen("/lilypond-2.24.4/bin/lilypond --svg -o ".. outputFilename .." ".. tmpFilename, "r")
local result = pipe:read("*a")
pipe:close()

local outputFile = io.open(outputFilename .. ".svg", "rb")
if not outputFile then
  ngx.status = ngx.HTTP_BAD_REQUEST
  ngx.say("Error generating LilyPond output: ", result)
  os.remove(tmpFilename)
  os.remove(outputFilename)
  return
end

local outputContent = outputFile:read("*a")
outputFile:close()

ngx.header.content_type = "image/svg+xml"
ngx.header["Content-Disposition"] = "inline"
ngx.say(outputContent)

-- Clean up the temporary files
os.remove(tmpFilename)
os.remove(outputFilename)
