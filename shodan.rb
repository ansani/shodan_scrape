#!/usr/bin/ruby

require 'optparse'
require 'curb'
require 'digest/md5'
require 'fileutils'
require 'colorize'
require 'open-uri'

$cookies=[]

def scrape_shodan(search_query,filename, debug)

	url =  'https://www.shodan.io/search?query='
	page = 1
	stop = false
	url = url+ URI::encode_www_form_component(search_query)
	FileUtils.rm(filename) if File.exist?(filename)

	while not stop  do

		if page>1
			scrape_url = url + "&page=#{page}"
		else
			scrape_url = url
			puts "Scraping Shodan.io for query '#{search_query}' and save results to #{filename}"
		end

		puts "Processing page ##{page}".yellow

		Curl::Easy.perform(scrape_url) do |curl|
			curl.ssl_verify_peer = false
			curl.ssl_verify_host = false
			curl.verbose = debug
			curl.enable_cookies=true
			curl.headers['Accept-Language'] =  'en-US'
			curl.headers['Upgrade-Insecure-Requests'] =  '1'
			curl.headers['User-Agent'] =  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2767.4 Safari/537.36 OPR/40.0.2280.0 (Edition developer)'
			curl.headers['Cookie'] = $cookies.join('; ');

			curl.on_success {
				if curl.body_str.include?("<div class='alert alert-error'>")
					puts 'An error occurred!'
					stop = true
				elsif curl.body_str.include?('<div class="msg alert alert-info">No results found</div>')
					puts 'No results found!'
					stop = true
				elsif curl.body_str.include?('<p>Please purchase a Shodan membership to access more than 5 pages of results.</p>')
					puts 'All available results for free users retrieved'
					stop = true
				else

					rows = curl.body_str.split("\n")
					rows.keep_if {|x| x.include?'<div class="results-count">' or x.include?'<div class="ip">'}

					total_hosts = rows.shift.split('>')[1].split('<')[0]

					puts "#{total_hosts}".green

					if rows.count > 0
						out_file = File.open(filename, 'a')

						rows.each {
							|x| host=x.split('"')[3]
							if debug
								puts "Found host #{host}"
							end
							out_file.puts host
						}
						out_file.close

						processed_hosts  = File.readlines(filename).uniq.count
						puts "Found #{rows.count} devices - Processed out #{processed_hosts} of #{total_hosts.gsub 'Total results: ', ''}".yellow
					end


					if curl.body_str.include?'class="btn">Next</a>'
						page += 1
						sleep 5
					else
						stop = true
					end

				end
			}
		end
	end

end

def shodan_login(username, password, debug)

	curl = Curl::Easy.new("https://account.shodan.io/login")
	curl.ssl_verify_peer = false
	curl.ssl_verify_host = false
	curl.verbose = debug
	curl.headers['Accept-Language'] =  'en-US'
	curl.headers['Upgrade-Insecure-Requests'] =  '1'
	curl.headers['User-Agent'] =  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2767.4 Safari/537.36 OPR/40.0.2280.0 (Edition developer)'
	curl.http_post(Curl::PostField.content('username', username),Curl::PostField.content('password', password),Curl::PostField.content('grant_type', 'password'),Curl::PostField.content('continue', 'https%3A%2F%2Faccount.shodan.io%2F'),Curl::PostField.content('login_submit', 'Log+in'))
	curl.follow_location = false
	curl.enable_cookies = true
	curl.on_success {
		if curl.body_str.include?("<div class='alert alert-error'>")
			puts 'An error occurred!'
		end
	}

	curl.on_header { |header|
		if header.include?('Set-Cookie:')
			header_cookie = header.split(' ')[1].gsub(';','')
			$cookies << header_cookie
		end
		header.length
	}
	curl.perform
	if debug
		puts $cookies
	end
end

options = {:username => nil, :password =>nil, :output_file =>nil, :query => nil, :debug => false}

parser = OptionParser.new do|opts|
	opts.banner = "shodan.rb (c)2016 Salvatore Ansani <salvatore@ansani.it>\n\nUsage:\n\n"
	opts.on('-U', '--username NAME', 'Your Shodan.io username') do |username|
		options[:username] = username;
	end

	opts.on('-P', '--password PASSWORD', 'Your Shodan.io password') do |password|
		options[:password] = password;
	end

	opts.on('-O', '--output FILENAME', 'Append all output to specified filename') do |output_file|
		options[:output_file] = output_file;
	end

	opts.on('-Q', '--query QUERY', 'Use this query to search Shodan.io. Put your query between " " and use escape sequence \" to use a double quote. For example: --query "title: \"some keywords\" country:IT"') do |query|
		options[:query] = query;
  end

	opts.on('-D', '--debug', 'Enable verbose (debug) output') do
		options[:debug] = true;
	end

	opts.on('-h', '--help', 'Displays Help') do
		puts opts
		exit
	end
end

parser.parse!

if options[:username].nil? and options[:password].nil? and options[:output_file].nil? and options[:query].nil?
	puts parser.help
	exit
end

shodan_login  options[:username], options[:password], options[:debug]
scrape_shodan options[:query], options[:output_file], options[:debug]

