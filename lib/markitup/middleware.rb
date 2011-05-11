module Markitup
  class Middleware < Struct.new :app, :options

    def call(env)
      return app.call(env) unless config['enabled']

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
      <<-EOB
---
enabled: true
keyword: markItUp
javascripts:
- markitup/jquery.markitup.js
- markitup/sets/default/set.js   
#- markitup/markdown/set.js
stylesheets:
- markitup/skins/markitup/style.css
- markitup/sets/default/style.css
#- markitup/markdown/style.css
      EOB
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

  end
end
