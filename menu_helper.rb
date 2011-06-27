##
# A Simple Menu creating class I often use.
#
PadrinoAppClass.helpers do   
  
  def menu_builder(page, menuitems = nil) 
    if menuitems == nil    
      menu_items = [
          { :name => 'home',     :class  => 'club',     :url => 'http://club.designbreakdown.com', :text => 'Home'}, 
          { :name => 'products', :class  => 'products', :url => '/products',                       :text => 'Products'},  
          { :name => 'pricing',  :class  => 'pricing',  :url => '/pricing',                        :text => 'Pricing'}, 
          { :name => 'support',  :class  => 'support',  :url => '/support',                        :text => 'Support'}, 
          { :name => 'contact',  :class  => 'contact',  :url => '#contact_popup',                  :text => 'Contact'},
        ]                                  
    else
      menu_items = menuitems
    end                              
    content = ""   
    menu_items.each do |item|  
      content << if page == item[:name]       
        tag('li', :content => tag('a',  :content => item[:text], :class => "#{item[:class]}", :href => nil ),  :class => "active #{item[:class]}")   
      else    
        tag('li', :content => tag('a',  :content => item[:text], :class => "#{item[:class]}", :href => "#{item[:url]}" ), :class => "#{item[:class]}")
      end   
    end
    tag(:ul, :content => content, :class => 'menu')    
  end   
end