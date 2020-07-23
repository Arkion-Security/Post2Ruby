#!/usr/bin/env ruby
#coding:utf-8


file = File.foreach('request.txt').map { |line| line.split(' ') }


#first line of the request
httpmethod = file[0][0].downcase
resource = file[0][1]
httpVersion = file[0][2]

#second line of the request
host = file[1][1]

domain = host + resource


#create the typheous request.
File.write("output.rb", "require \'Typhoeus\'\n\n\#Arkion\n request = Typhoeus::Request.new\(\"http://#{domain}\", followlocation: true, \n method: :#{httpmethod}, \n ", mode: "a")


#create key value pair for headers/
headerHash = file.each { |key, value| 

#iterate through to grab the body. (final line)
$body =  "headers: \{#{key} #{value}\},\n"

}


#change headers to body for request
body = $body.sub("headers:", "body: ")
body = body.sub("{", "\"")
body = body.sub("}", "\"")

#write body to request
File.write("output.rb", "#{body}", mode: "a" )

#open headers bracket
File.write("output.rb", "headers: { ", mode: "a" )


#stript the first two keys/values out as they are host and mehtod line. Print the key and value headers to file.
headerHash[3..-3].each do |key,value| 


 #add headers to file
key = key.to_s.sub(":", "\'=>")
key = key.sub("Content-Length=>", "")

#wirte to file and exclude problem headers
File.write("output.rb", " \'#{key} \"#{value}\",\n", mode: "a" ) unless key.include?('Content-Length') || key.include?('Accept-Encoding')
end



#close the bracket
File.write("output.rb", "}\n", mode: "a" )
#close the typheous object
File.write("output.rb", ")\n", mode: "a" )

#add code to run request
File.write("output.rb", "hydra = Typhoeus::Hydra.hydra                
hydra.queue(request)                                      
hydra.run                                                                  

response = request.response
puts response.code
puts response.body\n", mode: "a" )
