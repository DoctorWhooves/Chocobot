require "sqlite3"
require_relative "chocobot_logger"

class ChocoDB
	def initialize()
		@logger = ChocoLogger.new()

		@logger.log("DB", "Opening database...")
		begin
			@db = SQLite3::Database.new("./database/chocobot.db")
			@logger.log("DB", "Database opened")
		rescue SQLite3::Exception => e
			@logger.log("Error", e)
		end
	end

	def addRecord(table, cont)
		@logger.log("DB", "Attempting to add record...")
		begin
			@db.prepare("INSERT INTO #{table} VALUES (?,?);") do |stmt|
    			stmt.execute *cont
  			end
			@logger.log("DB", "Record added")
		rescue SQLite3::Exception => e
			@logger.log("Error", e)
		end
	end

	def getRecord(table, column)
		@logger.log("DB", "Attempting to get records from #{column}...")
		begin
			res = @db.execute("SELECT #{column} FROM #{table};")
		rescue SQLite3::Exception => e
			@logger.log("Error", e)
		end
	end
end