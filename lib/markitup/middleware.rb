require 'yaml'

module Markitup
  class Middleware < Struct.new :app, :options

    def call(env)
      return app.call(env) unless config['enabled']

      # if env["REQUEST_METHOD"] == "POST"
      #   return render(:markdown, env) if env["PATH_INFO"] =~ /^\/markitup\/markdown/
      # end

      status, headers, response = app.call(env)
      return [ status, headers, response ] unless 
        headers["Content-Type"] =~ /text\/html|application\/xhtml\+xml/

      body = ""
      response.each { |part| body << part }
      return [ status, headers, response ] unless
        body =~ /#{config['keyword']}/

      index = body.rindex "</head>"
      if index
        body.insert index, styles + scripts
        headers["Content-Length"] = body.length.to_s
        response = [ body ]
      end
      [ status, headers, response ]
    end

    private

    def default_config
      File.read(File.expand_path('../../../markitup.yml', __FILE__))
    end

    def config
      return @config unless @config.nil?
      conffile = options[:config]
      ::File.open(conffile, 'w') { |out| out.puts default_config } unless ::File.exist?(conffile)
      @config = ::File.open(conffile) { |yf| YAML::load(yf) }
    end

    def styles
      template = '<link rel="stylesheet" type="text/css" href="/stylesheets/%s" />'
      config['stylesheets'].inject('') { |result, file| result + template % file + "\n" }
    end

    def scripts
      template = '<script type="text/javascript" src="/javascripts/%s"></script>'
      config['javascripts'].inject('') { |result, file| result + template % file + "\n" } + init
    end

    def init
      <<-EOB
        <script type="text/javascript">
          $(document).ready(function() {
            $("textarea.#{ config['keyword'] }").markItUp(#{ settings });
          });
        </script>
      EOB
    end

    def settings
      return 'mySettings' if config['settings'].nil? or config['settings'].empty?
      "mySettings, {" + config['settings'].map { |key, val| "'#{key}':'#{val}'" } * ',' + '}'
    end

    # def render(format, env)
    #   case format
    #   when :markdown
    #     require 'maruku'
    #     body = Maruku.new(env['data']).to_html_document
    #     Rack::Response.new body
    #   end
    # end

  end
end
