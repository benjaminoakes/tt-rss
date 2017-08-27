# Purpose: update a GitHub Gist with a backup OPML file for this Tiny Tiny RSS instance.
#
# We could use the `gist` gem, but this simple script avoids adding dependencies.

require 'json'
require 'net/http'
require 'net/https'

def http_patch(url, json)
  uri = URI.parse(url)

  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true

  request = Net::HTTP::Patch.new(uri.path, 'Content-Type' => 'application/json')
  request.basic_auth uri.user, uri.password
  request.body = json.to_json

  response = https.request(request)
  response
end

def format_file_content_for_gist(ttrss_self_url_path, opml_filename)
  safe_instance_name = ttrss_self_url_path.sub(/^https:/, '').gsub('/', '')
  safe_opml_filename = opml_filename.split('/').last
  # Adding `.xml` so GitHub will syntax highlight
  safe_filename = "#{safe_instance_name}.#{safe_opml_filename}.xml"
  raw_content = File.read(opml_filename)

  { safe_filename => { content: raw_content } }
end

def main(gist_credentials:, gist_id:, ttrss_self_url_path:, opml_filename:)
  response = http_patch "https://#{gist_credentials}@api.github.com/gists/#{gist_id}", {
    description: "Tiny Tiny RSS Backup",
    public: false,
    files: format_file_content_for_gist(ttrss_self_url_path, opml_filename)
  }

  if $DEBUG
    puts "#{response.code} #{response.message}"
    puts
    puts response.body
  end
end

main gist_credentials: ENV['GIST_CREDENTIALS'],
  gist_id: ENV['GIST_ID'],
  ttrss_self_url_path: ENV['TTRSS_SELF_URL_PATH'],
  opml_filename: ARGV[0]
