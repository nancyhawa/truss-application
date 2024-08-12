#!/usr/bin/env ruby
require 'csv'
require 'date'

class Normalizer

	def initialize(input)
		@input = input
	end

	def normalize
		#replace all invalid UTF-8 characters in file with valid unicode replacements
		properly_encoded_input = @input
			.encode('UTF-8', invalid: :replace, undef: :replace)

		# Parse the input file
		@rows = CSV.parse(properly_encoded_input, headers: true)

		# Open a writable output file
		output = []

		# Create a header row for the output file
		output << [
			"Timestamp",
			"Address",
			"ZIP",
			"FullName",
			"FooDuration",
			"BarDuration",
			"TotalDuration",
			"Notes"]

		return CSV.generate do |csv|
			@rows.each_with_index do |row, i|
				normalized_row = []

=begin
				Each of the methods called from lines
				should work for the sample data provided, but given unexpected
				data we want to fail gracefully.  Rescue with a warning
				printed to STDERR and skip to next row.
=end
				begin
					normalized_row << normalize_timestamp(row["Timestamp"])
					normalized_row << normalized_address(row["Address"])
					normalized_row << normalize_zip(row["ZIP"])
					normalized_row << normalized_full_name(row["FullName"])
					foo_duration = parse_duration(row["FooDuration"])
					bar_duration = parse_duration(row["BarDuration"])
					total_duration = foo_duration + bar_duration
					normalized_row << foo_duration
					normalized_row << bar_duration
					normalized_row << total_duration
					normalized_row << normalized_notes(row["Notes"])
				rescue
					STDERR.puts
						"Warning: Failed to parse row #{i + 1}.\n
						Row #{i + 1} dropped from #{@output_file_name}"
					next
				end
				csv << normalized_row
			end
		end
	end

	def normalize_timestamp(timestamp)
		d = DateTime.strptime(timestamp, "%m/%d/%y %l:%M:%S %p")
		d = d.new_offset('+2:00')
		d.strftime("%FT%R") + " -5:00"
	end

	def normalize_zip(zip)
		until zip.length == 5 do
			zip = "0" + zip
		end
		return zip
	end

	def normalized_full_name(name)
		if name
			return name.unicode_normalize.upcase
		end
	end

	def normalized_address(address)
		address.unicode_normalize
	end

	def parse_duration(duration_string)
		components = duration_string.split(":")
		hours = components[0].to_i
		minutes = components[1].to_i
		seconds = components[2].to_f

		(hours * 3600) + (minutes * 60) + seconds
	end

	def normalized_notes(notes)
		if notes
			return notes.unicode_normalize
		end
	end
end

puts Normalizer.new($stdin.read).normalize
#small change
