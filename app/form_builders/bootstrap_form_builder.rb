class BootstrapFormBuilder < ActionView::Helpers::FormBuilder
  def label(object_name, options = {})
    html_class = (options[:class] || "") + " control-label col-xs-#{label_width}"
    options.merge!(class: html_class)
    super(object_name, @options[:locale_base][object_name], options)
  end

  %i(text_field).each do |method_name|
    define_method(method_name) do |object_name, options={}|
      html_class = (options[:class] || "") + " form-control"
      options.merge!(class: html_class)
      super(object_name, options)
    end
  end

  private
  def label_width
    @options[:width]
  end
end