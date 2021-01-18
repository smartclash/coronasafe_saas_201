def get_command_line_argument
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end

  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
dns_raw = File.readlines("zone")

def resolve(dns_records, lookup_chain, domain)
    dns_records[:cname].each do |cname_record|
        if cname_record[domain] != nil
            lookup_chain.push(cname_record[domain])
            return resolve(dns_records, lookup_chain, cname_record[domain])
        end
    end

    dns_records[:a].each do |a_record|
        if a_record[domain] != nil
            lookup_chain.push(a_record[domain])
            return lookup_chain
        end
    end

    ["Error: record not found for #{domain}"]
end

def parse_dns(dns_raw)
    parsed_dns = []
    dns_hash = { :a => [], :cname => [] }

    dns_raw.each do |entry| 
        cleaned_entry = entry.chomp
        split_string = cleaned_entry.split('')

        next if split_string.first === '#' || split_string.length <= 0
        split_entry = cleaned_entry.split(', ')
        parsed_dns.push(split_entry)
    end

    parsed_dns.each do |dns| 
        dns_hash[dns.first.downcase.to_sym].push({ dns[1] => dns[2] })
    end

    return dns_hash
end

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)

lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)

puts lookup_chain.join(" => ")
