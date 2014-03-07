# NfeBrasil

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'nfe_brasil'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nfe_brasil

## Usage

	$ certificate = NfeBrasil::Certificate.new ({full_certificate_path: 'certificate/certificado.p12', certificate_path: 'certificate/cert.pem', key_path: 'certificate/key.pem', certificate_password: '1234'})
	$ nfe = NfeBrasil::NfeBuilder.new(NfeBrasil::SampleData::DATA, certificate)

	$ gateway = NfeBrasil::Gateway.new({full_certificate_path: 'certificate/certificado.p12', certificate_path: 'certificate/cert.pem', key_path: 'certificate/key.pem', certificate_password: '1234'}, :homologacao)
	$ gateway.envio_nfe(NfeBrasil::SampleData::DATA)
	$ gateway.retorno_envio(gateway.response.numero_recibo, '2')

## Contributing

1. Fork it ( http://github.com/<my-github-username>/nfe_brasil/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
