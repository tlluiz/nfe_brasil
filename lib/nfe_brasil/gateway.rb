require 'savon'
# require 'httpclient'

# HTTPI.adapter = :httpclient

module NfeBrasil
	class Gateway
		AMBIENTE = {
			producao: {
				nfe_recepcao_lote2: 'https://nfe.fazenda.sp.gov.br/nfeweb/services/nferecepcao2.asmx?wsdl',
				NfeRetRecepcao: 'https://nfe.fazenda.sp.gov.br/nfeweb/services/nferetrecepcao2.asmx?wsdl'
			},
			homologacao: {
				nfe_recepcao_lote2: "https://homologacao.nfe.fazenda.sp.gov.br/nfeweb/services/NfeRecepcao2.asmx?wsdl",
				nfe_ret_recepcao2: "https://homologacao.nfe.fazenda.sp.gov.br/nfeweb/services/NfeRetRecepcao2.asmx?wsdl",
				NfeStatusServico: "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfestatusservico2.asmx?wsdl"
			}
		}
		def initialize(options, ambiente)
			@ambiente = ambiente
			@certificate = Certificate.new(options)
			@response = Response.new
		end

		def envio_nfe(data)
			@wsdl = AMBIENTE[@ambiente][:nfe_recepcao_lote2]
			nfe = NfeBuilder.new(data, @certificate)
			if nfe.validation?
				builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
					xml.enviNFe(xmlns: "http://www.portalfiscal.inf.br/nfe", versao: '2.00') {
						xml.idLote data[:identificacao][:nNf]
					}
				end
				xml = to_xml builder
				xml.root().add_child nfe.to_xml
				xml = xml.canonicalize Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0
				if envio_nfe_validation?(xml)
					soap_header = {
						"nfeCabecMsg" => {
							"@xmlns" => "http://www.portalfiscal.inf.br/nfe/wsdl/NfeRecepcao2",
							"cUF" => "35",
							"versaoDados" => "2.00"
						}
					}
					resp = request(:nfe_recepcao_lote2, soap_header, xml)
					retorna_xml(xml)
					@response.envio_nfe(resp.body)
				else
					envio_nfe_validation_errors(xml)
				end
			else
				"Validação da NFe falhou"
			end
		end

		def retorna_xml(xml)
			puts "===================================================="
			puts "XML Enviado"
			puts "===================================================="
			puts xml
			puts "===================================================="
			puts "===================================================="
		end

		def envio_nfe_validation?(xml)
			envio_nfe_validation(xml) == [] ? true : false
		end

		def envio_nfe_validation(xml)
			xsd = Nokogiri::XML::Schema(File.open(File.join('XSD', 'enviNFe_v2.00.xsd')))
			xsd.validate(Nokogiri::XML xml)			
		end

		def envio_nfe_validation_errors(xml)
			puts "============================"
			puts "Erros de Validação do XML de Envio da NFe"
			puts "============================"
			envio_nfe_validation(xml).each do |error|
				puts error
			end
			puts "============================"
		end

		def retorno_envio(numero_recibo, ambiente) # 1 - Produção, 2 - Homologação
			@wsdl = AMBIENTE[@ambiente][:nfe_ret_recepcao2]
			builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
				xml.consReciNFe {
					xml.versao '2.00'
					xml.tpAmb ambiente
					xml.nRec numero_recibo
				}
			end
			xml = to_xml builder
			xml = xml.canonicalize Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0
			soap_header = {
				"nfeCabecMsg" => {
					"@xmlns" => "http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetRecepcao2",
					"cUF" => "35",
					"versaoDados" => "2.00"
				}
			}
			resp = request(:nfe_ret_recepcao2, soap_header, xml)
			@response.retorno_envio(resp.body)
		end

		def response
			@response
		end

		def client
			@client
		end

		private

		def to_xml(builder)
			Nokogiri::XML builder.to_xml(save_with: Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION ), &:noblanks
		end


		def request(method, soap_header, xml)
			get_client(soap_header)
			@client.call(method, message: xml)
			rescue Savon::Error => error
		end

		def get_client(soap_header)
			@client = Savon.client(
				wsdl: @wsdl,
				soap_version: 2,
				env_namespace: :soap,
				soap_header: soap_header,
				ssl_version: :SSLv3,
				ssl_verify_mode: :peer,
				ssl_cert_file: @certificate.certificate_path,
				ssl_cert_key_file: @certificate.key_path,
				ssl_ca_cert_file: "certificate/ca.pem",
				ssl_cert_key_password: @certificate.password
			)
		end

	end
end