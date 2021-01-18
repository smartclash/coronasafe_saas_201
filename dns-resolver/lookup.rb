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
    record = dns_records[domain]

    if !record
        return ["Error: record not found for #{domain}"]
    elsif record[:type] == 'CNAME'
        lookup_chain.push(record[:target])
        return resolve(dns_records, lookup_chain, record[:target])
    elsif record[:type] == 'A'
        return lookup_chain.push(record[:target])
    end
end

def parse_dns(dns_raw)
    dns_hash = {}

    dns_raw.reject {|item| item.split().first == '#'}
        .reject {|item| item.split().length <= 0}
        .map {|item| item.strip.split(', ')}
        .each {|item| dns_hash[item[1]] = { :type => item[0], :target => item[2] }}

    dns_hash
end

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)

lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)

puts lookup_chain.join(" => ")
