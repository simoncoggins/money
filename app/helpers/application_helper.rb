# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # fix issue with negative numbers
  # would be nice to pass number_to_currency options argument
  # from this function 
  def as_currency(amount)
    if amount >= 0
      number_to_currency(amount)
    else
      '-' + number_to_currency(amount.abs)
    end
  end

  def stylesheet_tags
    stylesheet_link_tag('screen', :media => 'screen')
    #+ stylesheet_link_tag('print', :media => 'print')
  end

  # js includes required for graphing code
  def javascript_tags
    '<!--[if IE]>' + javascript_include_tag('excanvas.min') + '<![endif]-->'+
    javascript_include_tag('jquery.min') + 
    javascript_include_tag('jquery.flot.min') +
    javascript_include_tag('jquery.flot.threshold.min') + 
    javascript_include_tag('jquery.flot.crosshair.min') +
    javascript_include_tag('jquery.flot.selection.min') +
    javascript_include_tag('jquery.flot.stack.min') 
  end

  def nav_links
    link_to("Transactions", :controller=> 'transactions')+' | '+
    link_to("Tags", :controller => 'tags')+' | '+
    link_to("Patterns", :controller => 'patterns')+' | '+  
    link_to("Upload Statement", :controller => 'upload')+' | '+
    link_to("Graphs", :controller => 'view')
  end

end
