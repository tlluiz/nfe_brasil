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

	$ certificate = NfeBrasil::Certificate.new({ssl_cert_p12_path: 'certificate/certificado.p12', ssl_cert_path: 'certificate/certificate.pem', ssl_key_path: 'certificate/key.pem', ssl_cert_pass: '1234'})
	$ nfe = NfeBrasil::NfeBuilder.new(NfeBrasil::SampleData::DATA, certificate)

## Contributing

1. Fork it ( http://github.com/<my-github-username>/nfe_brasil/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
