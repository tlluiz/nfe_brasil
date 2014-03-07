# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nfe_brasil/version'

Gem::Specification.new do |spec|
  spec.name          = "nfe_brasil"
  spec.version       = NfeBrasil::VERSION
  spec.authors       = ["Thiago L. Luiz"]
  spec.email         = ["thiago.luiz@pardedois.com"]
  spec.summary       = %q{Gerador e Transmissor de Nota Fiscal Eletrônica Brasil}
  spec.description   = %q{Essa gem é capaz de gerar, assinar, transmitir, consultar e cancelar notas fiscais eletrônicas}
  spec.homepage      = "http://www.pardedois.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", "1.5.9"
  spec.add_dependency "savon", "~> 2.3.0"
  spec.add_dependency "signer"
  # spec.add_dependency "httpclient"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
