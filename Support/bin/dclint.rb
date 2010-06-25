#!/usr/bin/env ruby
require 'cgi'

lint = `java org.mozilla.javascript.tools.shell.Main ~/Library/JSLint/jslint.js "$TM_FILEPATH"`

lint.gsub!(/^(Lint at line )(\d+)(.+?:)(.+?)\n(?:(.+?)\n\n)?/m) do
  "<li><span class=\"warning\">#{CGI.escapeHTML($1)}<a href=\"txmt://open?url=file://TM_FILEPATH&line=#{CGI.escapeHTML($2)}\">#{CGI.escapeHTML($2)}</a>#{CGI.escapeHTML($3)}</span><span class=\"error\">#{CGI.escapeHTML($4)}</span>" <<
    ($5 ? "<pre>#{CGI.escapeHTML($5)}</pre></li>" : '')
end

lint.gsub!(/^(jslint:)(.+?)$/, '<p><strong>\1</strong>\2</p>')
lint.gsub!(/TM_FILEPATH/, ENV['TM_FILEPATH']) 

print <<HTML
<html>
<head>
  <style type="text/css">
  
    body {
		font-size: 13px;
	}
	
	pre {
        background-color: #eee;
        color: #400;
        margin: 3px 0;
      }
      
      h1, h2 { margin: 0 0 5px;}
      
      h1 { font-size: 20px; }
      h2 { font-size: 16px;}
      span.warning {
        color: #c90;
        text-transform: uppercase;
        font-weight: bold;
      }
      
      span.error {
        color: #900;
        font-style:italic;
      }
      
      ol {
        margin: 10px 0 0 20px;
        padding: 0;
      }
      
      li {
        margin: 0 0 10px;
      }
  </style>
</head>
<body>
<h1>JavaScriptLint</h1>
<h2>Results:</h2>
<ol>
#{lint}
</ol>
</body>
</html>
HTML
