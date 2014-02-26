module NfeBrasil
	class Certificate
	    def initialize(options = {})
	      @options = {
	        ssl_cert_p12_path: "",
	        ssl_cert_path: "", 
	        ssl_key_path: "", 
	        ssl_cert_pass: "",
	      }.merge(options)
	    end

	end
end