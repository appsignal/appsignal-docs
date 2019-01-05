require "lib/appsignal_markdown"
# TODO: Fixed in middleman 4.3.x. Once it is released we upgrade and remove
# this silencer.
Haml::TempleEngine.disable_option_validator!

DOCS_ROOT   = File.expand_path(File.dirname(__FILE__))
GITHUB_ROOT = "https://github.com/appsignal/appsignal-docs/tree/master"

Time.zone = "Amsterdam"

set :layout, :article
set :markdown_engine, :redcarpet
set :markdown, AppsignalMarkdown::OPTIONS.merge(:renderer => AppsignalMarkdown)
set :haml, :attr_wrapper => %(")
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

activate :syntax,
  :line_numbers => true,
  :css_class => "code-block"
activate :sprockets

helpers do
  def title
    if current_page.data.title
      current_page.data.title.gsub(/<[^>]*>/, '').tap do |title|
        unless current_page.data.title_no_brand
          title << " | AppSignal documentation"
        end
      end
    else
      "AppSignal documentation"
    end
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
      'Create a pull request',
      page_path.gsub(DOCS_ROOT, GITHUB_ROOT),
      :class => 'button tiny outline-white'
    )
  end

  def markdown(content)
    # https://github.com/hashicorp/middleman-hashicorp/blob/14c705614b2f97b5a78903f17b904f767c1fdbe2/lib/middleman-hashicorp/redcarpet.rb
    Redcarpet::Markdown.new(AppsignalMarkdown, AppsignalMarkdown::OPTIONS).render(content)
  end

  def inline_markdown(content)
    markdown(content).sub(/^<p>(.*)<\/p>$/, "\\1")
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
    when "nil"
      "nil (This is unset by default)"
    else
      content_tag :code, default.inspect
    end
  end
end
