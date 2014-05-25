class ChocoLogger
	def initialize()
	end

	def log(type, message)
		date = Time.new
		timestamp = date.strftime("%H:%M:%S").to_s
		file = "./logs/" + date.strftime("%m-%d-%y").to_s + "_chocobot.log"
		f = File.new(file, "ab+")
		f.puts "(#{timestamp})-[#{type}] => #{message}"
		f.close
	end
end