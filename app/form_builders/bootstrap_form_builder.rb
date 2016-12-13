class BootstrapFormBuilder < ActionView::Helpers::FormBuilder
  def label(object_name, options = {})
    html_class = (options[:class] || "") + " control-label col-xs-#{label_width}"
    options[:class] = html_class
    super(object_name, @options[:locale_base][object_name], options)
  end

  def select(object_name, choices, options = {}, html_options = {})
    html_class = (html_options[:class] || "") + " form-control"
    html_options[:class] = html_class
    super(object_name, choices, options, html_options)
  end

  %i(text_field text_area).each do |method_name|
    define_method(method_name) do |object_name, options={}|
      html_class = (options[:class] || "") + " form-control"
      options[:class] = html_class
      super(object_name, options)
    end
  end

  private
  def label_width
    @options[:width]
  end
end