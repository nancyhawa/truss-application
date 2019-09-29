# Environment

If you are working on a modern mac, this tool should work out of the box.

To provide a little more detail, this tool was built and tested using `ruby 2.5.1` on a Mac running OS 10.14. I've tested it with `ruby 2.2.10`, so as long as you've got a version of Ruby at least as new as that, the tool should work. (Check with `ruby -v`.)

# Running normalizer.rb

`normalizer.rb` is a single file tool with minimal dependencies, so there are no build steps.

Run the normalizer tool with the following command, subbing in your input and output file names.
`./normalizer.rb < input_file_name.csv > output_file_name.csv`
