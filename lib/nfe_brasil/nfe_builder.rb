require 'nokogiri'

module	NfeBrasil
	class NfeBuilder
		DATA = {

		}
		def initialize(data)
			@data = DATA.merge(data)
			@builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
				xml.NFe(xmlns: "http://www.portalfiscal.inf.br/nfe") {
					xml.infNFe( versao: "2.00", Id: "NFe" ) { #preencher Id com a chave de acesso da nota fiscal precida do literal NFe.
						add_ide(xml)
						add_emit(xml)
						add_dest(xml)
						add_entrega(xml)
						add_loop_det(xml)
						add_total(xml)
						add_transp(xml)
						add_cobr(xml)
						add_infAdic(xml)
					}
				}
			end
			puts "======================"
			puts "XML Gerado"
			puts "======================"
			puts xml = self.to_xml
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

		private

		def add_ide(xml)
			xml.ide { #Informações de identificação da Nota fiscal
				xml.cUF "35" #Código da UF do emitente da nota fiscal. Usar tabela do IBGE. 35 - Sao Paulo
				xml.cNF "01010101" #Código aleatório de 8 dígitos gerado pelo emitente e que comporá a chave de acesso da NF.
				xml.natOp "venda" #Natureza da Operação: venda, compra, transferência, devolução, importação, consignação, remessa
				xml.indPag "0" #Forma de pagamento: 0 - à vista, 1 - à prazo, 2 - outros
				xml.mod "55" #Utilizar o código 55 para identificação da NF-e, emitida em substituição ao modelo 1 ou 1A.
				xml.serie "1" #Preencher com Zeros caso a NF não possuir série.
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
		end

		def add_emit(xml)
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
					xml.cPais "1058" #Código do País. Veja tabel BACEN - 1058 é Brasil.
					xml.xPais "Brasil" #Nome do País.
					xml.fone "1732323232" #Telefone do emitente.
				}
				xml.IE "ISENTO" #Incrição Estadual. Usar o literal 'ISENTO' apenas para contribuintes que são isentos do pagamento de ICMS e estão emitindo nota fiscal avulsa.
				# xml.IEST "" #Informar a IE do substituto tributário (ST) da UF de destino da mercadoria, quando houver a retenção de ICMS ST para a UF de destino
				xml.IM "0101" #Incrição Municipal - Deve ser informado quando houver emissão de nota fiscal conjugada, com prestação de serviços sujeitos a ISSQN e fornecimento de mercadorias sujeitos ao ICMS.
				xml.CNAE "1234567" #CNAE Fiscal - Este campo deve ser informado quando a Incrição Municipal for informada.
				xml.CRT "1" #Código do Regime Tributário - Este campo deve ser preenchido obrigatoriamente com: 1 - Simples Nacional, 2 - Simples Nacional (Excesso de sublimite de receita bruta), 3 - Regime Normal (v2.0)
			}
		end

		def add_dest(xml)
			xml.dest { #Informações do destinatário da NF eletrônica.
				#Escolha entre os dois nós a seguir.
				xml.CNPJ "12345678000199" #CNPJ do Destinatário da Nota Fiscal.
				# xml.CPF "12345678999" #CPF do destinarário - Este campo deve ser usado caso seja pessoa física o destinatário.
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
					xml.cPais "1058" #Usar tabela do BACEN.
					xml.xPais "Brasil" #Nome do País.
					xml.fone "1732323232" #Preencher com código DDD + número de telefone. Nas operação com o exterior é permitido informar o código do país.
				}
				xml.IE "ISENTO" #Incrição Estadual - Informar o literal 'ISENTO' quando o contribuinte for isento de contribuição de ICMS
				# xml.ISUF "" #Incrição no SUFRAMA
				xml.email "email@email.com" #Email do Destinatário
			}
		end

		def add_entrega(xml)
			xml.entrega { #Informações do endereço de entrega quando for diferente do endereço do destinatário.
				#Escolher entre um dos dois nós abaixo.
				xml.CNPJ "12345678000199" #CNPJ do Destinatário.
				# xml.CPF "12345678999" #CPF do Destinatário.
				xml.xLgr "Rua Couves Segunda"
				xml.nro "1234"
				xml.xCpl "Fundos"
				xml.xBairro "Jardim das Hortaliças"
				xml.cMun "3549805" #Verificar o códifo do município na tabela do IBGE.
				xml.xMun "Horta" #Nome do Município - Informar 'EXTERIOR' para envio para o exterior.
				xml.UF "SP" #Sigla do Estado - Colocar 'EX' caso seja enviado para fora do brasil.
			}
		end

		def add_loop_det(xml)
			#TODO - Escrever loop para criar quantos nós de detalhamento forem necessários
			add_det(xml)		
		end

		def add_det(xml)
			xml.det(nItem: "1") { #Detalhamento de produtos e serviços da NF.
				xml.prod { #Informações sobre o produto ou serviço.
					xml.cProd "3" #Código do Produto ou Serviço - Preencher com CFOP caso se trate de itens não relacionados a mercadoria ou produtos e que o contribuinte não possua numeração própria ex: 'CFOP9999'
					xml.cEAN
					xml.xProd "Pé de Alface"
					xml.NCM "07051100"
					# xml.EXTIPI "07"
					xml.CFOP "5102" #Código CFOP: 5102 - Venda de mercadorias adquirida ou recebida de terceiros.
					xml.uCom "Unit" #Unidade Comercial.
					xml.qCom "1" #Quantidade Comercial.
					xml.vUnCom "30.00" #Valor Unitário de Comercialização - Meramente informativo.
					xml.vProd "30.00" #Valor total dos produtos.
					xml.cEANTrib
					xml.uTrib "Unit" #Unidade Tributável.
					xml.qTrib "1" #Quantidade tributável - informar a quantidade de tributação do produto.
					xml.vUnTrib "0" #Valor unitário de tributação.
					xml.indTot "1" #Indica se o campo vProd desse item compõe o valor total da nota: 0 - Não compõe, 1 - Compõe.
				}
				xml.imposto { #Informações sobre os impostos incidentes nesse produto
					#TODO - Fazer o detalhamento dos nós de imposto de cada produto ou serviço que compõe a nota.
					xml.ICMS { #Informações sobre o Importo sobre Circulação de Mercadoria
						xml.ICMSSN102 { #Tributação de ICMS Isenta.
							xml.orig "0" #Origem da Mercadoria: 0 - Nacional, 1 - Importação.
							xml.CSOSN "400" #Tributação do ICMS: 400 - Não tributada pelo simples naciona.
						}
					}
					xml.IPI { #Informações sobre o IPI.
						xml.cEnq "0" #Código do Enquadramento do IPI. Informar: 0.
						xml.IPINT { #IPI não tributado.
							xml.CST "52" #Código da situação tributária do IPI: 52 - Saída Isenta.
						}
					}
					xml.PIS { #Informações sobre o PIS.
						xml.PISNT { #PIS Não tributado.
							xml.CST "07" #Código da situação tributária do PIS: 07 - Operação isenta da contribuição.
						}
					}
					xml.COFINS { #Informações sobre o COFINS.
						xml.COFINSNT { #COFINS não tributado.
							xml.CST "07" #Código da situação tributária do COFINS: 07 - Operação isenta da contribuição.
						}
					}
				}
			}
		end

		def add_total(xml)
			#fim da repetição dos produtos ou serviços que compõe a nota fiscal.
			xml.total { #Informações totais da NF eletrônica.
				xml.ICMSTot { #Informações totais sobre o ICMS.
					xml.vBC "0.00" #Valor utilizado para base de cálculo do ICMS.
					xml.vICMS "0.00" #Valor total do ICMS.
					xml.vBCST "0.00" #Valor utilizado para base de cálculo de ICMS com subsutuição tributária.
					xml.vST "0.00" #Valor total do ICMS com substuição tributária.
					xml.vProd "30.00" #Valor total de produtos e serviços.
					xml.vFrete "0.00" #Valor do frete.
					xml.vSeg "0.00" #Valor total do seguro.
					xml.vDesc "0.00" #Valor total de desconto.
					xml.vII "0.00" #Valor total do II.
					xml.vIPI "0.00" #Valor total do IPI.
					xml.vPIS "0.00" #Valor total do PIS.
					xml.vCOFINS "0.00" #Valor total do COFINS.
					xml.vOutro "0.00" #Valor com outras despesas acessórias.
					xml.vNF "30.00" #Valor total da NF-e.
				}
			}			
		end

		def add_transp(xml)
			xml.transp { #Informações sobre transporte.
				xml.modFrete "0" #Modalidade do Frete: 0 - Por conta do emitente, 1 - Por conta do destinatário, 2 - Por conta de terceiro, 9 - Sem frete.
				xml.transporta { #Informações da transportadora.
					#Escolha entre um dos dois campos abaixo.
					xml.CNPJ "12345678000101" #CNPJ da empresa transportadora.
					# xml.CPF "" #CPF do transportador.
					xml.xNome "Razão Social ou Nome Completo do Transportador" #Razão Social ou Nome Completo do Transportador.
					xml.IE "123456789" #Inscrição Estadual do Transportador.
					xml.xEnder "Rua Nove Horas, 1234, Jardim Relógio" #Endereço completo.
					xml.xMun "Pontualidade" #Nome do município.
					xml.UF "SP" #Sigla do estado. Deve ser informado caso o nó IE seja preenchido.
				}
				xml.vol { #Informações de Volumes a serem transportados.
					xml.qVol "1" #Quantidade de volumes.
					xml.esp "Caixa" #Espécie de volumes transportados.
					xml.pesoL "5.000" #Peso Líquido em Kg.
					xml.pesoB "5.500" #Peso Bruto em Kg.
				}
			}
		end

		def add_cobr(xml)
			xml.cobr { #Informações de Cobrança.
				xml.fat { #Informações de faturamento.
					xml.nFat "12345" #Número da Fatura.
					xml.vOrig "30.00" #Valor Original da Fatura.
					# xml.vDesc "0.00" #Valor de Desconto.
					xml.vLiq "30.00" #Valor líquido da fatura.
				}
				# xml.dup {
				# 	xml.nDup "" #número da duplicata.
				# 	xml.dVenc "" #Data de Vencimento - Formato: AAAA-MM-DD.
				# 	xml.vDup "" #Valor da Duplicata
				# }
			}
		end

		def add_infAdic(xml)
			xml.infAdic { #Informações adicionais da nota fiscal.
				xml.infAdFisco "Olá!" #Informações adicionais de interesse do fisco.
				xml.infCpl "Essa empresa é optante pelo Simples Nacional." #Informações adicionais de interesse do contribuinte.
			}			
		end

	end
end