# NfeBrasil

## Preparando o Ambiente

	$ bundle install

## Rodando irb e carregando o módulo NfeBrasil

	$ bundle exec irb
	$ require 'nfe_brasil'


## Primeira forma de testar

# Instancia um Certificado
	$ certificate = NfeBrasil::Certificate.new ({full_certificate_path: 'certificate/nilma_carla_vieira.p12', certificate_path: 'certificate/cert.pem', key_path: 'certificate/key.pem', certificate_password: '1234'})

# Cria uma nota fiscal baseada nos dados da Classe SampleData
	$ nfe = NfeBrasil::NfeBuilder.new(NfeBrasil::SampleData::DATA, certificate)

# Retorna a String com o XML pronto para ser validado
	$ nfe.to_xml

# Copie e cole o que é retornado pelo  método anterior no validador da SEFAZ - RS: https://www.sefaz.rs.gov.br/NFE/NFE-VAL.aspx

## Outra forma de testar

# Instancia o Gateway que vai fazer o envio da nota para a SEFAZ de Sao Paulo
	$ gateway = NfeBrasil::Gateway.new({full_certificate_path: 'certificate/nilma_carla_vieira.p12', certificate_path: 'certificate/cert.pem', key_path: 'certificate/key.pem', certificate_password: '1234'}, :homologacao)

# Chama o método envio_nfe que cria e envia a nota fiscal para a SEFAZ - SampleData é a classe com os dados de exemplo
	$ gateway.envio_nfe(NfeBrasil::SampleData::DATA)

# Por fim o método retorno_envio pergunta a SEFAZ qual é o resultado do processamento da nota fiscal
	$ gateway.retorno_envio(gateway.response.numero_recibo, '2')

