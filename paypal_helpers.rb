# #
# Helpers for working with paypal forms.
#
PadrinoAppClass.helpers do    
  
  def payment_service_for_paypal(order, account, options = {}, &proc)         
    raise ArgumentError, "Missing block" unless block_given?

    integration_module = ActiveMerchant::Billing::Integrations.const_get(options.delete(:service).to_s.camelize)              
    
    return_url = 'joe'
    notify_url = 'bob'

    result = []
    result << "<form action=\"#{ENV['PAYPAL_URL']}\" method=\"post\" id=\"paypal_form\" >"
    
    service_class = integration_module.const_get('Helper')    
    service = service_class.new(order, account, options)

    result << capture_html(service, &proc)

    service.form_fields.each do |field, value|  
      if field == 'cmd'
        result << hidden_field_tag(field, :value => value)  
      end
    end   
      
    encValue = paypal_encrypted(return_url, notify_url, @plan) 
    result <<  hidden_field_tag('encrypted', :value => encValue)   
   
    result << '</form>'
    result= result.join("\n")
    
    concat_content(result.respond_to?(:html_safe) ? result.html_safe : result)
    nil
  end   
   
 # Builds an encrypted payapl submisison
 def paypal_encrypted(return_url, notify_url, plan)
   values = {
     :business => ENV['PAYPAL_ACCOUNT'],
     :cmd => '_xclick-subscriptions', 
     :item_number => 1,
     :currency_code => ENV['PAYPAL_CURRENCY'],
     :a1 => plan.signup_price / 100,
     :p1 => 1,
     :t1 => 'M',
     :a3 => plan.recurring_price / 100,
     :p3 => 1,
     :t3 => 'M',
     :src => 1,
     :srt => 12,
     :upload => 1,
     :return => return_url,
     :notify_url => notify_url,
     :cert_id => ENV['PAYPAL_CERT_ID']
   }                       
   return encrypt_for_paypal(values)
 end     
  
 def encrypt_for_paypal(values)
   signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(APP_CERT_PEM), OpenSSL::PKey::RSA.new(APP_KEY_PEM, ''), values.map { |k, v| "#{k}=#{v}" }.join("\n"), [], OpenSSL::PKCS7::BINARY)
   OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(PAYPAL_CERT_PEM)], signed.to_der, OpenSSL::Cipher::Cipher::new("DES3"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
 end
end