#!/usr/bin/ruby
require 'securerandom'

## a bit of input params vaidation #########################
if ARGV.length < 1
  puts "at least 1 argument is required"
  exit 1
end

if ARGV[0] == "validate" && ARGV.length < 2
  puts "if you send 'validate' you must provide one extra argument"
  exit 2
end

storage_file_validate_given = false

if ARGV[0] == "validate" && ARGV.length == 3
  storage_file = ARGV[2]
  if !(storage_file.match?(/^[0-9a-zA-Z_\-. ]+$/))
    puts "#{storage_file} doesn't appear to be a valid file name"
    exit 3
  end
  storage_file_validate_given = true
end

storage_file_set = false

if ARGV[0] == "get" && ARGV.length == 2
  storage_file = ARGV[1]
  if !(storage_file.match?(/^[0-9a-zA-Z_\-. ]+$/))
    puts "#{storage_file} doesn't appear to be a valid file name"
    exit 4
  end
  storage_file_set = true
end

############################################################


def gen_key(sequence_count=4,sequence_length=8,prefix="")
  license_key=""
  i=0
  while i < sequence_count do
    license_key << SecureRandom.alphanumeric(sequence_length)
    license_key << "-" unless i==sequence_count-1
    i += 1
  end
  license_key.prepend("-") unless (prefix=="" || sequence_count==0)
  license_key.prepend(prefix)
end


def validate_license(license_key="",sequence_count=4,sequence_length=8,prefix="ecl",storage_file="")
  a_license_key = license_key.split("-")

  return if license_key == ""

  if storage_file != ""
    ## if file is given will check if the key is present on it
    key_is_present_in_file = File.foreach('/share/' + storage_file).any?{ |l| l[license_key] }
  else
    key_is_present_in_file = true
  end


  if a_license_key[0] == prefix
    has_prefix = true
    sequence_count_ok = sequence_count == a_license_key.count - 1 ? true : false
  else
    has_prefix = false
    sequence_count_ok = sequence_count == a_license_key.count ? true : false
  end

  if has_prefix
    a_license_key.shift
  end

  array_sequence_elements_ok = true

  ## will check all sequence numbers individually
  a_license_key.each do |sequence|
    next if sequence.match?(/^[0-9a-zA-Z]*$/) && sequence.length == sequence_length
    array_sequence_elements_ok = false
  end
  # puts "array_sequence_elements_ok: #{array_sequence_elements_ok}"
  # puts "sequence_count_ok: #{sequence_count_ok}"
  # puts "key_is_present_in_file: #{key_is_present_in_file}"

  sequence_count_ok && array_sequence_elements_ok && key_is_present_in_file
end


case ARGV[0]
when "get"
  new_key = gen_key(4,8,"ecl")
  puts new_key
  if storage_file_set
    f = File.open('/share/' + storage_file, 'a')
    f.puts(new_key)
    f.close
  end
when "validate"
  if storage_file_validate_given
    puts validate_license(ARGV[1],4,8,"ecl",storage_file).to_s
  else
    puts validate_license(ARGV[1],4,8,"ecl").to_s
  end
else
  puts "invalid request"
end
