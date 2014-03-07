module NfeBrasil
	class Certificate
		def initialize(options)
			@options = {
				full_certificate_path: '',
				certificate_path: '',
				key_path: '',
				certificate_password: ''
			}.merge(options)
		end

		def PKCS12
			OpenSSL::PKCS12.new(File.read(full_certificate_path), password)
		end

		def password
			@options[:certificate_password]
		end

		def key_path
			@options[:key_path]
		end

		def certificate_path
			@options[:certificate_path]
		end

		def full_certificate_path
			@options[:full_certificate_path]
		end
	end
end