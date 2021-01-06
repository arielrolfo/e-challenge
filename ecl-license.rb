#!/usr/bin/ruby

### Author: Ariel Rolfo

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

  ## Below function will check if a valid file name is given
  if !(storage_file.match?(/^[0-9a-zA-Z_\-. ]+$/))
    puts "#{storage_file} doesn't appear to be a valid file name"
    exit 3
  end
  storage_file_validate_given = true
end

storage_file_set = false

if ARGV[0] == "get" && ARGV.length == 2
  $stdout.reopen("/share/stdout", "w")
  $stderr.reopen("/share/stdout", "w")
  storage_file = ARGV[1]

  ## Below function will check if a valid file name is given

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

  ## while loop to create a key based upon the amount and length of the sequences
  while i < sequence_count do
    license_key << SecureRandom.alphanumeric(sequence_length)
    license_key << "-" unless i==sequence_count-1
    i += 1
  end
  license_key.prepend("-") unless (prefix=="" || sequence_count==0)
  license_key.prepend(prefix)
end


def validate_license(license_key="",sequence_count=4,sequence_length=8,prefix="ecl",storage_file="")

  ## make an array from the license provided based  upon "-" separator so every sequence is an array eleement
  a_license_key = license_key.split("-")

  return if license_key == ""

  if storage_file != ""
    ## if file is given will check if the key is present on it
    key_is_present_in_file = File.foreach('/share/' + storage_file).any?{ |l| l[license_key] }
  else
    key_is_present_in_file = true
  end

  ## check if the license to check has a prefix or not
  if a_license_key[0] == prefix
    has_prefix = true
    ## check if the amount of sequences are OK
    sequence_count_ok = sequence_count == a_license_key.count - 1 ? true : false
  else
    has_prefix = false
    ## check if the amount of sequences are OK
    sequence_count_ok = sequence_count == a_license_key.count ? true : false
  end

  if has_prefix
    ## below code will remove the prefix element (first) from the array to prepare for the next verification
    a_license_key.shift
  end

  array_sequence_elements_ok = true

  ## will iterate/check all sequence  individually
  a_license_key.each do |sequence|

    ## consider OK the  sequence if it is comprised of numbers and/or letters (opcase or lower case) AND if length of the secuence is OK
    next if sequence.match?(/^[0-9a-zA-Z]*$/) && sequence.length == sequence_length
    array_sequence_elements_ok = false
  end
  # puts "array_sequence_elements_ok: #{array_sequence_elements_ok}"
  # puts "sequence_count_ok: #{sequence_count_ok}"
  # puts "key_is_present_in_file: #{key_is_present_in_file}"

  ## boolean result of the function:
  ## logic:
  ##    if key provided hast the right amount of sequences AND the sequences are properly formed AND the key provided is already in the file THEN "TRUE", otherwise "FALSE"
  sequence_count_ok && array_sequence_elements_ok && key_is_present_in_file
end


## Main

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

## END
