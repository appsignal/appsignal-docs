require "lib/appsignal_markdown"
# TODO: Fixed in middleman 4.3.x. Once it is released we upgrade and remove
# this silencer.
Haml::TempleEngine.disable_option_validator!

DOCS_ROOT   = File.expand_path(File.dirname(__FILE__))
GITHUB_ROOT = "https://github.com/appsignal/appsignal-docs/tree/main"

Time.zone = "Amsterdam"

set :protocol, "https://"
set :host, "docs.appsignal.com"
set :layout, :article
set :markdown_engine, :redcarpet
set :markdown, AppsignalMarkdown::OPTIONS.merge(:renderer => AppsignalMarkdown)
set :haml, :attr_wrapper => %(")
set :css_dir, "assets/stylesheets"
set :js_dir, "assets/javascripts"
set :images_dir, "assets/images"

activate :syntax,
  :line_numbers => true,
  :css_class => "code-block"

activate :external_pipeline,
  name: :webpack,
  command: build? ? "yarn build" : "yarn dev",
  source: ".tmp/dist",
  latency: 1

helpers do
  def description_of_page(page)
    if page.data.description
      page.data.description
    else
      auto_description(page)
    end
  end

  # Return and around 200 character description of the given file.
  # It ensures the description is complete lines.
  def auto_description(page)
    source = page.file_descriptor.read
    # Remove YAML frontmatter
    source = source.gsub(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m, "")
    renderer = Redcarpet::Markdown.new(AppsignalMarkdownStripDown)
    content = renderer.render(source)
    description = []
    content.split("\n").each do |line|
      description << line
      if description.sum(&:length) > 200
        break # Keep the description short
      end
    end
    description.join(" ")
  end

  def canonical_url(path)
    path = path.sub("index.html", "")
    path = "/#{path}" unless path.start_with?("/")
    "#{config[:protocol]}#{config[:host]}#{path}"
  end

  def title
    if current_page.data.title
      current_page.data.title.gsub(/<[^>]*>/, "").tap do |title|
        unless current_page.data.title_no_brand
          title << " | #{site_name}"
        end
      end
    else
      site_name
    end
  end

  def site_name
    "AppSignal documentation"
  end

  def path_active?(path)
    if path == "/"
      return current_page.url == "/"
    end

    current_page.url.include?(path)
  end

  def link_with_active(*args, &block)
    if block_given?
      path, options = args
    else
      name, path, options = args
    end
    options ||= {}
    options[:class] = options[:class].to_s
    options[:class] += " active" if path == current_page.url
    if options.delete(:parent_active) && current_page.url.start_with?(path.sub(".html", "/"))
      options[:class] += " active"
    end

    new_args =
      if block_given?
        [path, options]
      else
        [name, path, options]
      end
    link_to(
      *new_args,
      &block
    )
  end

  def edit_link
    page_path = current_page.source_file
    link_to(
      "Create a pull request",
      page_path.gsub(DOCS_ROOT, GITHUB_ROOT),
      :class => "c-button c-button--sm c-button--gray ml-2"
    )
  end

  def markdown(content)
    # https://github.com/hashicorp/middleman-hashicorp/blob/14c705614b2f97b5a78903f17b904f767c1fdbe2/lib/middleman-hashicorp/redcarpet.rb
    Redcarpet::Markdown.new(AppsignalMarkdown, AppsignalMarkdown::OPTIONS).render(content)
  end

  def inline_markdown(content)
    markdown(content).sub(/^<p>(.*)<\/p>$/, "\\1")
  end

  def option_value(key, option, integration)
    option[integration][key] || option[key]
  end

  def link_for_option(option, integration)
    config_key = option_value(:config_key, option, integration)
    if config_key
      link_to config_key, "#option-#{config_key}"
    else
      env_key = option_value(:env_key, option, integration)
      link_to env_key, "#option-#{env_key.downcase}"
    end
  end

  def options_for(integration)
    integration = integration.to_s
    data[:config_options][:options].select do |option|
      option.key? integration
    end
  end

  def option_type_format(option)
    type = option[:type]
    case type
    when Array
      type.map do |t|
        option_type_value_format(t)
      end.join(" / ")
    when Hash
      if type.key? "array"
        option_type_value_format("array", type[:array])
      else
        option_type_value_format("list", type[:list])
      end
    else
      option_type_value_format(type)
    end
  end

  def option_type_value_format(type, sub_types = [])
    case type
    when "bool"
      "Boolean (<code>true</code> / <code>false</code>)"
    when "array"
      sub_types_label = sub_types.map(&:humanize).join(", ")
      type_label = sub_types.length > 1 ? "types" : "type"
      content_tag :code, "Array&lt;#{sub_types_label}&gt;",
        :title => "Array with values of #{type_label} #{sub_types_label}"
    when "list"
      sub_types_label = sub_types.map(&:humanize).join(", ")
      type_label = sub_types.length > 1 ? "types" : "type"
      content_tag :code, "list(#{sub_types_label})",
        :title => "List with values of #{type_label} #{sub_types_label}"
    when NilClass
      "Error: Missing type!"
    else
      content_tag :code, type.humanize
    end
  end

  def option_default_value(option)
    default = option[:default_value]
    case default
    when Hash
      inline_markdown default[:markdown]
    when nil # null in the YAML file
      "nil (This is unset by default)"
    else
      content_tag :code, default.to_s
    end
  end
end
