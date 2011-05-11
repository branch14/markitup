require File.expand_path('../helper', __FILE__)
require 'rack/mock'

class TestMarkitup < Test::Unit::TestCase

  PAYLOAD = 'jquery.markitup.js'

  context "Embedding Markitup" do
    should "place the payload at the end of the head section of an HTML request" do
      assert_match EXPECTED_CODE, request.body
    end

    should "place the payload at the end of the head section of an XHTML request" do
      response = request(:content_type => 'application/xhtml+xml')
      assert_match EXPECTED_CODE, response.body
    end

    should "not place the payload in an HTML request without target" do
      response = request(:body => [HTML_WITHOUT_TARGET])
      assert_no_match EXPECTED_CODE, response.body
    end

    should "not place the konami code in a non HTML request" do
      response = request(:content_type => 'application/xml', :body => [XML])
      assert_no_match EXPECTED_CODE, response.body
    end
  end

  private

  EXPECTED_CODE = /#{PAYLOAD}/m
  
  HTML_WITH_TARGET = <<-EOHTML
   <html>
     <head>
       <title>Sample Page</title>
     </head>
     <body>
       <h2>Markitup::Middleware Test</h2>
       <p>This is more test html</p>
       <textarea class='markItUp'></textarea>
     </body>
   </html>
  EOHTML

  HTML_WITHOUT_TARGET = <<-EOHTML
   <html>
     <head>
       <title>Sample Page</title>
     </head>
     <body>
       <h2>Markitup::Middleware Test</h2>
       <p>This is more test html</p>
       <textarea></textarea>
     </body>
   </html>
  EOHTML

  XML = <<-EOXML
   <?xml version="1.0" encoding="ISO-8859-1"?>
   <user>
     <name>Some Name</name>
     <age>Some Age</age>
   </user>
  EOXML

  def request(options={}, path='/')
    @app = app(options)
    request = Rack::MockRequest.new(@app).get(path)
    yield(@app, request) if block_given?
    request
  end

  def app(options={})
    options = options.clone
    options[:content_type] ||= "text/html"
    options[:body]         ||= [HTML_WITH_TARGET]
    rack_app = lambda do |env|
      [ 200,
        { 'Content-Type' => options.delete(:content_type) },
        options.delete(:body) ]
    end
    Markitup::Middleware.new(rack_app,
      :config => File.expand_path('../../markitup.yml', __FILE__))
  end

end
