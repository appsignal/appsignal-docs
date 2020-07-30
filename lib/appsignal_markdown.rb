# From: https://github.com/hashicorp/middleman-hashicorp/blob/master/lib/middleman-hashicorp/redcarpet.rb

require "redcarpet"
require "redcarpet/render_strip"
require "middleman-core"
require "middleman-core/renderers/redcarpet"
require "active_support/core_ext/module/attribute_accessors"

class AppsignalMarkdown < Middleman::Renderers::MiddlemanRedcarpetHTML
  # Make a small wrapper module around a/some Padrino formatting helpers
  # This is not included in the AppsignalMarkdown class to prevent accidental
  # overriding of methods.
  module FormatHelpersWrapper
    include Padrino::Helpers::FormatHelpers
    module_function :strip_tags
  end

  OPTIONS = {
    :autolink           => true,
    :fenced_code_blocks => true,
    :no_intra_emphasis  => true,
    :strikethrough      => true,
    :tables             => true,
  }.freeze

  # Initialize with correct config.
  # Does not get config from `set :markdown` from `config.rb`
  def initialize(options = {})
    super(options.merge(OPTIONS))
  end

  # Parse contents of every paragraph for custom tags and render paragraph.
  def paragraph(text)
    add_custom_tags("<p>#{text.strip}</p>\n")
  end

  # Add anchor tags to every heading.
  # Create a link from the heading.
  #
  # Extra logic added:
  # - Adds an invisible `span` element that is moved up on the page and acts as
  #   an anchor. This makes sure the page header doesn't hide the title once
  #   scrolled to the position on the page.
  # - Anchor prefix: Start a heading with a caret symbol to prefix the
  #   heading's anchor id. `##^prefix My heading` becomes `#prefix-my-heading`.
  # - Anchor override: Start a heading with an equals symbol to override the
  #   heading's anchor id. `##=my-anchor My heading` becomes `#my-anchor`.
  # - Strips out any html tags from titles so that they don't get included in
  #   the generated anchors.
  #
  # @example
  #   <!-- Markdown input -->
  #   ## My heading
  #   <!-- HTML output -->
  #   <h2><span class="anchor" id="my-heading"></span><a href="#my-heading">My heading</a></h2>
  #
  # @example with a anchor prefix
  #   <!-- Markdown input -->
  #   ##^my-prefix My heading
  #   <!-- HTML output -->
  #   <h2><span class="anchor" id="my-prefix-my-heading"></span><a href="#my-prefix-my-heading">My heading</a></h2>
  #
  # @example with a anchor override
  #   <!-- Markdown input -->
  #   ##=my-anchor My heading
  #   <!-- HTML output -->
  #   <h2><span class="anchor" id="my-anchor"></span><a href="#my-anchor">My heading</a></h2>
  #
  # @example with html in the heading
  #   <!-- Markdown input -->
  #   ## My <code>html</code> heading
  #   <!-- Or -->
  #   ## My `html` heading
  #   <!-- HTML output -->
  #   <h2><span class="anchor" id="my-code-heading"></span><a href="#my-code-heading">My code heading</a></h2>
  def header(text, level)
    if text =~ /^\^([a-zA-Z0-9\-_]+) /
      anchor_prefix = $1
      text = text.sub("^#{anchor_prefix} ", "")
      anchor = FormatHelpersWrapper.strip_tags(text).parameterize
      anchor = "#{anchor_prefix}-#{anchor}" if anchor_prefix
    elsif text =~ /^=([a-zA-Z0-9\-_]+) /
      anchor = $1
      text = text.sub("=#{anchor} ", "")
    else
      anchor = FormatHelpersWrapper.strip_tags(text).parameterize
    end
    %(<h%s class="group relative">
      <span class="anchor" id="%s"></span>
      <a href="#%s">
        %s
        <div class="absolute left-0 top-0 transform -translate-x-6 hidden group-hover:block">
          <i class="fa fa-hashtag text-sm font-normal text-gray-600 align-middle -mt-px"></i>
        </div>
      </a>
    </h%s>) % [level, anchor, anchor, text, level]
  end

  private

  # Add custom tags to content
  def add_custom_tags(text)
    map = {
      "-&gt;" => "notice",
      "!&gt;" => "warning"
    }
    regexp = map.map { |k, _| Regexp.escape(k) }.join("|")

    md = text.match(/^<p>(#{regexp})/)
    return text unless md

    key = md.captures[0]
    klass = map[key]
    text.gsub!(/#{Regexp.escape(key)}\s+?/, "")

    <<-EOH.gsub(/^ {8}/, "")
      <div class="custom-wrapper #{klass}">#{text}</div>
    EOH
  end
end

class AppsignalMarkdownStripDown < Redcarpet::Render::StripDown
  def link(link, title, content)
    content
  end
end
