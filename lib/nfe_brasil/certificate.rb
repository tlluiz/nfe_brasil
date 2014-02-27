module NfeBrasil
	class Certificate
		def initialize(options = {})
			@options = {
				ssl_cert_p12_path: "",
				ssl_cert_path: "",
				ssl_key_path: "",
				ssl_cert_pass: "",
			}.merge(options)
			@certificate = OpenSSL::PKCS12.new(File.read(@options[:ssl_cert_p12_path]), @options[:ssl_cert_pass])
		end

		def PKCS12
			@certificate
		end
	end
end