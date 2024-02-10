#!/usr/bin/env ruby

require './lib/print_receipt_service'

def print_output_header(input_str)
  matched = input_str.match('Input (\d+)')
  file_number = matched.captures.first if matched

  puts file_number ? "Output #{file_number}:" : 'Output:'
end

def input
  @input ||= begin
    filename = ARGV[0]
    lines = File.readlines(filename, chomp: true)

    {
      header: lines[0],
      body: lines[1..-1],
    }
  end
end


receipt_info = ComputeReceiptInfoService.new(input[:body]).call

print_output_header(input[:header])

PrintReceiptService.new(receipt_info).call
