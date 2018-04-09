require "lib/appsignal_markdown"

DOCS_ROOT   = File.expand_path(File.dirname(__FILE__))
GITHUB_ROOT = "https://github.com/appsignal/appsignal-docs/tree/master"

Time.zone = "Amsterdam"

set :layout, :article
set :markdown_engine, :redcarpet
set :markdown, AppsignalMarkdown::OPTIONS.merge(renderer: AppsignalMarkdown)
set :haml, :attr_wrapper => %(")
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

activate :syntax, :line_numbers => true

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
end
