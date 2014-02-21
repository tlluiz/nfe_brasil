require 'nokogiri'

module	NfeBrasil
	class NfeBuilder
		DEFAULT_DATA = {

		}
		def initialize(data)
			@data = DEFAULT_DATA.merge(data)
			@builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
				xml.NFe('xmlns' => "http://www.portalfiscal.inf.br/nfe") {
					xml.infNFe( versao: "2.00", Id: "NFe" ) { #preencher Id com a chave de acesso da nota fiscal precida do literal NFe.
						xml.ide { #Informações de identificação da Nota fiscal
							xml.cUF "35" #Código da UF do emitente da nota fiscal. Usar tabela do IBGE. 35 - Sao Paulo
							xml.cNF "01010101" #Código aleatório de 8 dígitos gerado pelo emitente e que comporá a chave de acesso da NF.
							xml.natOp "venda" #Natureza da Operação: venda, compra, transferência, devolução, importação, consignação, remessa
							xml.indPag "0" #Forma de pagamento: 0 - à vista, 1 - à prazo, 2 - outros
							xml.mod "55" #Utilizar o código 55 para identificação da NF-e, emitida em substituição ao modelo 1 ou 1A.
							xml.serie "0" #Preencher com Zeros caso a NF não possuir série.
							xml.nNF "12345" #Número da Nota Fiscal.
							xml.dEmi "2014-02-01" #Data de Emissão da Nota fiscal.
							xml.dSaiEnt "2014-02-01" #Data de Saída ou Entrada de Mercadoria ou Produto.
							xml.hSaiEnt "17:24:30" #Hora de Saída da Mercadoria - Formato: HH:MM:SS.
							xml.tpNF "1" #Tipo de Operação: 0 - Entrada, 1 - Saída.
							xml.cMunFG "3549805" #Código do Município que originou a operação - Utilize a tabela do IBGE.
							xml.tpImp "1" #Formato de Impressão do DANFE: 1 - retrato, 2 - paisagem
							xml.tpEmis "1" #Tipo de Emissão: 1 - Normal, 2 - Contingência FS, 3 - Contingência SCAN...
							xml.cDV "9" #Dígito Verificador
							xml.tpAmb "2" #Ambiente e transmissão: 1 - Produção, 2 - Homologação
							xml.finNFe "1" #Finalidade de emissão da NF-e: 1 - NFe Normal, 2 - Nfe Complementar, 3 - Nfe de ajuste
							xml.procEmi "0" #Processo de Emissão da Nf-e: 0 - Aplicativo do Contrinuinte, 1 - Pelo fisco, 2 - Aplicativo de Fisco
							xml.verProc "1.0.0" #Versão do aplicativo emissor da nota fiscal.
						}
						xml.emit { #inofrmações do Emitente da nota fiscal
							xml.CNPJ "01999999000199" #CNPJ da empresa emissora da NF.
							xml.xNome "Razão social LTDA" #Razão social da Empresa Emissora.
							xml.xFant "Nome Fantasia" #Noma fantasia da empresa emissora da NF.
							xml.enderEmit { #Informações do endereço do emitente
								xml.xLgr "Rua Das couves"
								xml.nro "123"
								xml.xCpl "Fundos" #Complemento - Remover nó caso não tenha complemento.
								xml.xBairro "Jardim das Hortaliças" #bairro.
								xml.cMun "3549805" #Código do Município.
								xml.xMun "Saao José do Rio Preto" #Nome do Município.
								xml.UF "SP" #Sigla do Estado do Emitente.
								xml.CEP "15000000" #CEP do Emitente.
								xml.cPais "55" #Código do País. Veja tabel BACEN.
								xml.xPais "Brasil" #Nome do País.
								xml.fone "1732323232" #Telefone do emitente.
							}
							xml.IE "ISENTO" #Incrição Estadual. Usar o literal 'ISENTO' apenas para contribuintes que são isentos do pagamento de ICMS e estão emitindo nota fiscal avulsa.
							xml.IEST "" #Informar a IE do substituto tributário (ST) da UF de destino da mercadoria, quando houver a retenção de ICMS ST para a UF de destino
							xml.IM "" #Incrição Municipal - Deve ser informado quando houver emissão de nota fiscal conjugada, com prestação de serviços sujeitos a ISSQN e fornecimento de mercadorias sujeitos ao ICMS.
							xml.CNAE "" #CNAE Fiscal - Este campo deve ser informado quando a Incrição Municipal for informada.
							xml.CRT "1" #Código do Regime Tributário - Este campo deve ser preenchido obrigatoriamente com: 1 - Simples Nacional, 2 - Simples Nacional (Excesso de sublimite de receita bruta), 3 - Regime Normal (v2.0)
						}
						xml.dest { #Informações do destinatário da NF eletrônica.
							#Escolha entre os dois nós a seguir.
							xml.CNPJ "0123456789000199" #CNPJ do Destinatário da Nota Fiscal.
							xml.CPF "12345678999" #CPF do destinarário - Este campo deve ser usado caso seja pessoa física o destinatário.
							xml.xNome "Razão Social o Nome do Destinatário" #Razão Social o Nome do Destinatário.
							xml.enderDest { #Informações do endereço do Destinatário 
								xml.xLgr "Rua Couves Segunda"
								xml.nro "1234"
								xml.xCpl "Fundos"
								xml.xBairro "Jardim das Hortaliças"
								xml.cMun "3549805" #Verificar o códifo do município na tabela do IBGE.
								xml.xMun "Horta" #Nome do Município.
								xml.UF "SP" #Sigla do Estado - Colocar 'EX' caso seja enviado para fora do brasil.
								xml.CEP "15000000" #CEP do destinatário.
								xml.cPais "" #Usar tabela do BACEN.
								xml.xPais "Brasil" #Nome do País.
								xml.fone "1732323232" #Preencher com código DDD + número de telefone. Nas operação com o exterior é permitido informar o código do país.
							}
							xml.IE "ISENTO" #Incrição Estadual - Informar o literal 'ISENTO' quando o contribuinte for isento de contribuição de ICMS
							xml.ISUF "" #Incrição no SUFRAMA
							xml.email "email@email.com" #Email do Destinatário

						}
						xml.entrega { #Informações do endereço de entrega quando for diferente do endereço do destinatário.
							#Escolher entre um dos dois nós abaixo.
							xml.CNPJ "12345678000199" #CNPJ do Destinatário.
							xml.CPF "12345678999" #CPF do Destinatário.
							xml.xLgr "Rua Couves Segunda"
							xml.nro "1234"
							xml.xCpl "Fundos"
							xml.xBairro "Jardim das Hortaliças"
							xml.cMun "3549805" #Verificar o códifo do município na tabela do IBGE.
							xml.xMun "Horta" #Nome do Município - Informar 'EXTERIOR' para envio para o exterior.
							xml.UF "SP" #Sigla do Estado - Colocar 'EX' caso seja enviado para fora do brasil.
						}
						#Podem ocorrer várias ocorrência do nó abaixo. Uma para cada produto ou serviço que será incluso na nota fiscal. Limite máximo é 990.
						xml.det { #Detalhamento de produtos e serviços da NF.
							xml.nItem "" #Número do item.
							xml.prod { #Informações sobre o produto ou serviço.
								xml.cProd "" #Código do Produto ou Serviço - Preencher com CFOP caso se trate de itens não relacionados a mercadoria ou produtos e que o contribuinte não possua numeração própria ex: 'CFOP9999'
								xml.cEAN
								xml.xProd
								xml.NCM
								xml.EXTIPI
								xml.CFOP
								xml.uCom
								xml.qCom
								xml.cUnCom
								xml.vProd
								xml.cEANTrib
								xml.uTrib
								xml.qTrib
								xml.vUnTrib
								xml.vFrete
								xml.vSeg
								xml.vDesc
								xml.vOutro
								xml.indTot
								xml.xPed
								xml.nItemPed
							}
							xml.imposto { #Informações sobre os impostos incidentes nesse produto
								#TODO - Fazer o detalhamento dos nós de imposto de cada produto ou serviço que compõe a nota.
							}
							xml.infAdProd "" #Norma referenciada, informações complementares.
						}
						#fim da repetição dos produtos ou serviços que compõe a nota fiscal.
						xml.total { #Informações totais da NF eletrônica.
							xml.ICMSTot { #Informações totais sobre o ICMS.
								xml.vBC "" #Valor utilizado para base de cálculo do ICMS.
								xml.vICMS "" #Valor total do ICMS.
								xml.vBCST "" #Valor utilizado para base de cálculo de ICMS com subsutuição tributária.
								xml.vST "" #Valor total do ICMS com substuição tributária.
								xml.vProd "" #Valor total de produtos e serviços.
								xml.vFrete "" #Valor do frete.
								xml.vSeg "" #Valor total do seguro.
								xml.vDesc "" #Valor total de desconto.
								xml.vII "" #Valor total do II.
								xml.vIPI "" #Valor total do IPI.
								xml.vPIS "" #Valor total do PIS.
								xml.vCOFINS "" #Valor total do COFINS.
								xml.vOutro "" #Valor com outras despesas acessórias.
								xml.vNF "" #Valor total da NF-e.
							}
							xml.ISSQNtot { #Informações totais referentes ao ISSQN
								xml.vServ "" #Valor total dos serviços sob não-incidência ou não tributados pelo ICMS.
								xml.vBC "" #Valor Base de cálculo do ISS.
								xml.vISS "" #Valor total do ISS.
								xml.cPIS "" #Valor do PIS sobre serviços.
								xml.vCOFINS "" #Valor de COFINS sobre serviços.
							}
							xml.retTrib { #Grupo de retenções de tributos.
								xml.vRetPIS "" #Valor retido do PIS.
								xml.vRetCOFINS "" #Valor retido do COFINS.
								xml.vRetCSLL "" #Valor retido do CSLL.
								xml.vBCIRRF "" #Base de cálculo IRRF.
								xml.vIRRF "" #Valor retido de IRRF.
								xml.vBCRetPrev "" #Base de cálculo da retenção de previdência social.
								xml.vRetPrev "" #Valor retido de previdência social.
							}
						}
						xml.transp { #Informações sobre transporte.
							xml.modFrete "" #Modalidade do Frete: 0 - Por conta do emitente, 1 - Por conta do destinatário, 2 - Por conta de terceiro, 9 - Sem frete.
							xml.transportadora { #Informações da transportadora.
								#Escolha entre um dos dois campos abaixo.
								xml.CNPJ "" #CNPJ da empresa transportadora.
								xml.CPF "" #CPF do transportador.
								xml.xNome "" #Razão Social ou Nome Completo do Transportador.
								xml.IE "" #Inscrição Estadual do Transportador.
								xml.xEnder "" #Endereço completo.
								xml.xMun "" #Nome do município.
								xml.UF "" #Sigla do estado. Deve ser informado caso o nó IE seja preenchido.
							}
							xml.retTransp { #Retenção do ICMS do Transporte.
								xml.vServ "" #Valor do Serviço.
								xml.vBCRet "" #Base de cálculo da retenção do ICMS.
								xml.pICMSRet "" #Alíquota de retenção do ICMS.
								xml.vICMSRet "" #Valor do ICMS Retido.
								xml.CFOP "" #Utilizar a tabela de CFOP.
								xml.cMunFG "" #Código do município de ocorrência do fato gerador do ICMS de transporte.
							}
							xml.vol { #Informações de Volumes a serem transportados.
								xml.qVol "" #Quantidade de volumes.
								xml.esp "" #Espécie de volumes transportados.
								xml.marca "" #Marca dos volumes transportados.
								xml.nVol "" #Numeração dos volumes transportados.
								xml.pesoL "" #Peso Líquido em Kg.
								xml.pesoB "" #Peso Bruto em Kg.
								xml.lacres {
									xml.nLacre "" #Número dos lacres
								}
							}
						}
						xml.cobr { #Informações de Cobrança.
							xml.fat { #Informações de faturamento.
								xml.nFat "" #Número da Fatura.
								xml.vOrig "" #Valor Original da Fatura.
								xml.vDesc "" #Valor de Desconto.
								xml.vLiq "" #Valor líquido da fatura.
							}
							xml.dup {
								xml.nDup "" #número da duplicata.
								xml.dVenc "" #Data de Vencimento - Formato: AAAA-MM-DD.
								xml.vDup "" #Valor da Duplicata
							}
						}
						xml.infAdic { #Informações adicionais da nota fiscal.
							xml.infAdFisco "" #Informações adicionais de interesse do fisco.
							xml.infCpl "" #Informações adicionais de interesse do contribuinte.
							xml.obsCpl { #Informações livre para uso do contribuinte.
								xml.xCampo "" #Nome do campo livre.
								xml.xTexto "" #Conteúdo do campo livre.
							}
							xml.procRef { #Informações do grupo referenciado.
								xml.nProc "" #Identificador do processo ou ato concessório.
								xml.indProc "" #Indicador da origem do processo: 0 - SEFAZ, 1 - Justiça Federal, 2 - Justiça Estadual, 3 - Secex/RFB, 9 - Outros.
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