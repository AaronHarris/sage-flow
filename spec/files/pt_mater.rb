#!/usr/bin/ruby
require 'rubygems'
require 'net/http'
require 'nokogiri'
require 'uri'

# titleize STRING.split(/(\W)/).map(&:capitalize).join
# HASH.keys.grep(/^#{typeahead}/i)
user_tokens = {'aaronharris' => '188f901073b501960bcbf3f5ef756c43'}
if user_tokens.include? ENV['USER']
	$TOKEN = user_tokens[ENV['USER']]
else
	print 'Your name is not in our database. Please visit https://www.pivotaltracker.com/profile, copy the API token, and paste it here:'
	$TOKEN = gets.strip
	user_tokens[ENV['USER']] = $TOKEN
end

$PROJECT_ID = '574033'

  # resource_uri = URI.parse("http://www.pivotaltracker.com/services/v3/projects/#{$PROJECT_ID}/stories?filter=owned_by%3A%22Aaron%20Harris%22%20current_state%3Astarted")
  # response = Net::HTTP.start(resource_uri.host, resource_uri.port) do |http|
  #   http.get(resource_uri.path, {'X-TrackerToken' => '$TOKEN'})
  # end

f = File.open("info.xml")
	@doc = Nokogiri::XML(f)
f.close

@doc = @doc.xpath("//story").first

@story = {
	:id         	=> @doc.css('id').children.first.content,
    :name			=> @doc.css('name').children.first.content,
    :current_state  => @doc.css('current_state').children.first.content,
    :description	=> @doc.css('description').children
}

filename = @story[:name].gsub(/(the |it's|its|now |a |an |of )/i, "").split(" ").map(&:strip).reject(&:empty?)

File.open("../#{@story[:id]}_#{filename.join('_')}_spec.rb", "w") do |file|
	file.puts "require 'spec_helper'"
	file.puts
	file.puts "describe \"#{@story[:id]} #{@story[:name]}\" do"
	file.puts "  before(:each) do"
	file.puts "    class Foo < Sample"
    file.puts "      has_sage_flow_states :foo, :bar"
	file.puts "    end"
	file.puts "  end"
	file.puts "  it \"does something\" do"
	file.puts "    f = Foo.new"
	file.puts "  end"
	file.puts "end"
end

if !@story[:description].empty?
	puts "Note description: #{@story[:description]}" 
end
puts "rspec spec/#{@story[:id]}_#{filename.join('_')}_spec.rb"
puts "Git Commit Message: #{@story[:id]} #{filename.join(' ')}"
