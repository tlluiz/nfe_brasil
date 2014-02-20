require 'nokogiri'

module	NfeBrasil
	class NfeBuilder
		Default_data = {

		}
		def initialize(data)
			@data = Default_data.merge(data)
			@builder = Nokogiri::XML::Builder.new do |xml|
				xml.send('xmlns:ds': "http://www.w3.org/2000/09/xmldsig#", 'xmlns:xs': "http://www.w3.org/2001/XMLSchema", 'xmlns': "http://www.portalfiscal.inf.br/nfe") {
					xml.NFe {
						xml.infNFe( versao: "2", ) {
							xml.ide {
								xml.cUF "99" #Código da UF do emitente da nota fiscal. Usar tabela do IBGE.
								xml.cNF "01010101" #Código aleatório de 8 dígitos gerado pelo emitente e que comporá a chave de acesso da NF.
								xml.natOp "venda" #Natureza da Operação: venda, compra, transferência, devolução, importação, consignação, remessa
								xml.indPag "0" #Forma de pagamento: 0 - à vista, 1 - à prazo, 2 - outros
								xml.mod "55" #Utilizar o código 55 para identificação da NF-e, emitida em substituição ao modelo 1 ou 1A.
								xml.serie "000" #Preencher com Zeros caso a NF não possuir série.
								xml.nNF "12345" #Número da Nota Fiscal.
								xml.dEmi "2014-02-01" #Data de Emissão da Nota fiscal.
								xml.dSaiEnt "2014-02-01" #Data de Saída ou Entrada de Mercadoria ou Produto.
								xml.hSaiEnt "17:24:30" #Hora de Saída da Mercadoria - Formato: HH:MM:SS.
								xml.tpNF "1" #Tipo de Operação: 0 - Entrada, 1 - Saída.
								xml.cMunFG "999" #Código do Município que originou a operação - Utilize a tabela do IBGE.
								xml.tpImp "1" #Formato de Impressão do DANFE: 1 - retrato, 2 - paisagem
								xml.tpEmis "1" #Tipo de Emissão: 1 - Normal, 2 - Contingência FS, 3 - Contingência SCAN...
								xml.cDV "99" #Dígito Verificador
							}
						}
					}					
				}
			end
			puts "======================"
			puts "XML Gerado"
			puts "======================"
			puts xml = @builder.to_xml
			puts "======================"
		end

		def to_xml
			Nokogiri::XML @builder.to_xml( save_with: Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION )
		end

		def validate
			xsd = Nokogiri::XML::Schema(File.open(File.join('XSD', 'nfe_v2.00.xsd')))
			puts "======================"
			puts "Mensagens de Erro"
			puts "======================"
			xsd.validate(self.to_xml).each do |error|
				puts error.message
			end
			puts "======================"
		end
	end
end