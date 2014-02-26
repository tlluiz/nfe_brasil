require 'nokogiri'

module	NfeBrasil
	class NfeBuilder
		DATA = {
			identificacao: {
				nNF: ''
			},
			emitente: {
				cnpj: '',
				razaoSocial: '',
				nomeFantasia: '',
				endereco: {
					logradouro: '',
					numero: '',
					complemento: '',
					bairro: '',
					codigoMunicipio: '',
					municipio: '',
					codigoUF: '',
					uf: '',
					cep: '',
					codigoPais: '',
					pais: '',
					fone: ''
				},
				ie: '',
				crt: ''
			},
			destinatario: {
				cnpj: '',
				cpf: '',
				razaoSocial: '',
				endereco: {
					logradouro: '',
					numero: '',
					complemento: '',
					bairro: '',
					codigoMunicipio: '',
					municipio: '',
					uf: '',
					cep: '',
					codigoPais: '',
					pais: '',
					fone: ''
				},
				ie: '',
				inscricaoSuframa: '',
				email: ''
			},
			entrega: {
				cnpj: '',
				cpf: '',
				logradouro: '',
				numero: '',
				complemento: '',
				bairro: '',
				codigoMunicipio: '',
				municipio: '',
				uf: ''
			},
			detalhes: {

			},
			total: {
				ICMSTot: {
					vBC: '',
					vICMS: '',
					vBCST: '',
					vST: '',
					vProd: '',
					vFrete: '',
					vSeg: '',
					vDesc: '',
					vII: '',
					vIPI: '',
					vPIS: '',
					vCOFINS: '',
					vOutro: '',
					vNF: ''
				}
			},
			transporte: {
				modFrete: '',
				transporta: {
					cnpj: '',
					cpf: '',
					razaoSocial: '',
					ie: '',
					endereco: '',
					municipio: '',
					uf: ''
				},
				volumes: {
					quantidade: '',
					especie: '',
					pesoLiquido: '',
					pesoBruto: ''
				}
			},
			cobranca: {
				fatura: {
					nFat: '',
					vOrig: '',
					vDesc: '',
					vLiq: ''
				}
			},
			infoAdicional: {
				infAdFisco: '',
				infCpl: ''
			}
		}

		def initialize(data)
			@data = DATA.merge(data)
			access_key_generate
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
				xml.CNPJ @data[:emitente][:cnpj]
				xml.xNome @data[:emitente][:razaoSocial]
				xml.xFant @data[:emitente][:nomeFantasia]
				xml.enderEmit {
					xml.xLgr @data[:emitente][:endereco][:logradouro]
					xml.nro @data[:emitente][:endereco][:numero]
					xml.xCpl @data[:emitente][:endereco][:complemento]
					xml.xBairro @data[:emitente][:endereco][:bairro]
					xml.cMun @data[:emitente][:endereco][:codigoMunicipio]
					xml.xMun @data[:emitente][:endereco][:municipio]
					xml.UF @data[:emitente][:endereco][:uf]
					xml.CEP @data[:emitente][:endereco][:cep]
					xml.cPais @data[:emitente][:endereco][:codigoPais]
					xml.xPais @data[:emitente][:endereco][:pais]
					xml.fone @data[:emitente][:endereco][:fone]
				}
				xml.IE @data[:emitente][:ie]
				xml.CRT @data[:emitente][:crt]
			}
		end

		def add_dest(xml)
			xml.dest { #Informações do destinatário da NF eletrônica.
				#Escolha entre os dois nós a seguir.
				@data[:destinatario][:cnpj] != '' ? (xml.CNPJ @data[:destinatario][:cnpj]) : (xml.CPF @data[:destinatario][:cpf])
				xml.xNome @data[:destinatario][:razaoSocial]
				xml.enderDest {
					xml.xLgr @data[:destinatario][:endereco][:logradouro]
					xml.nro @data[:destinatario][:endereco][:numero]
					xml.xCpl @data[:destinatario][:endereco][:complemento]
					xml.xBairro @data[:destinatario][:endereco][:bairro]
					xml.cMun @data[:destinatario][:endereco][:codigoMunicipio]
					xml.xMun @data[:destinatario][:endereco][:municipio]
					xml.UF @data[:destinatario][:endereco][:uf]
					xml.CEP @data[:destinatario][:endereco][:cep]
					xml.cPais @data[:destinatario][:endereco][:codigoPais]
					xml.xPais @data[:destinatario][:endereco][:pais]
					xml.fone @data[:destinatario][:endereco][:fone]
				}
				xml.IE @data[:destinatario][:ie]
				(xml.ISUF @data[:destinatario][:inscricaoSuframa]) if @data[:destinatario][:inscricaoSuframa] != ''
				xml.email @data[:destinatario][:email]
			}
		end

		def add_entrega(xml)
			if @data[:entrega][:logradouro] != ''
				xml.entrega {
					@data[:entrega][:cnpj] != '' ? (xml.CNPJ @data[:entrega][:cnpj]) : (xml.CPF @data[:entrega][:cpf])
					xml.xLgr @data[:entrega][:logradouro]
					xml.nro @data[:entrega][:numero]
					xml.xCpl @data[:entrega][:complemento]
					xml.xBairro @data[:entrega][:bairro]
					xml.cMun @data[:entrega][:codigoMunicipio]
					xml.xMun @data[:entrega][:municipio]
					xml.UF @data[:entrega][:uf]
				}
			end
		end

		def add_loop_det(xml)
			#TODO - Escrever loop para criar quantos nós de detalhamento forem necessários
			nItem = 1
			@data[:detalhes].each_value do |item|
				add_det(xml, item, nItem)
				nItem += 1
			end
		end

		def add_det(xml, item, nItem)
			xml.det(nItem: nItem) {
				xml.prod {
					xml.cProd item[:produto][:cProd]
					xml.cEAN
					xml.xProd item[:produto][:xProd]
					xml.NCM item[:produto][:NCM]
					xml.CFOP item[:produto][:CFOP]
					xml.uCom item[:produto][:uCom]
					xml.qCom item[:produto][:qCom]
					xml.vUnCom item[:produto][:vUnCom]
					xml.vProd item[:produto][:vProd]
					xml.cEANTrib
					xml.uTrib item[:produto][:uTrib]
					xml.qTrib item[:produto][:qTrib]
					xml.vUnTrib item[:produto][:vUnTrib]
					xml.indTot item[:produto][:indTot]
				}
				xml.imposto {
					xml.ICMS {
						xml.ICMSSN102 {
							xml.orig item[:imposto][:ICMS][:ICMSSN102][:orig]
							xml.CSOSN item[:imposto][:ICMS][:ICMSSN102][:CSOSN]
						}
					}
					xml.IPI {
						xml.cEnq item[:imposto][:IPI][:cEnq]
						xml.IPINT {
							xml.CST item[:imposto][:IPI][:IPINT][:CST]
						}
					}
					xml.PIS {
						xml.PISNT {
							xml.CST item[:imposto][:PIS][:PISNT][:CST]
						}
					}
					xml.COFINS {
						xml.COFINSNT {
							xml.CST item[:imposto][:COFINS][:COFINSNT][:CST]
						}
					}
				}
			}
		end

		def add_total(xml)
			#fim da repetição dos produtos ou serviços que compõe a nota fiscal.
			xml.total { #Informações totais da NF eletrônica.
				xml.ICMSTot { #Informações totais sobre o ICMS.
					xml.vBC @data[:total][:ICMSTot][:vBC]
					xml.vICMS @data[:total][:ICMSTot][:vICMS]
					xml.vBCST @data[:total][:ICMSTot][:vBCST]
					xml.vST @data[:total][:ICMSTot][:vST]
					xml.vProd @data[:total][:ICMSTot][:vProd]
					xml.vFrete @data[:total][:ICMSTot][:vFrete]
					xml.vSeg @data[:total][:ICMSTot][:vSeg]
					xml.vDesc @data[:total][:ICMSTot][:vDesc]
					xml.vII @data[:total][:ICMSTot][:vII]
					xml.vIPI @data[:total][:ICMSTot][:vIPI]
					xml.vPIS @data[:total][:ICMSTot][:vPIS]
					xml.vCOFINS @data[:total][:ICMSTot][:vCOFINS]
					xml.vOutro @data[:total][:ICMSTot][:vOutro]
					xml.vNF @data[:total][:ICMSTot][:vNF]
				}
			}			
		end

		def add_transp(xml)
			xml.transp { #Informações sobre transporte.
				xml.modFrete @data[:transporte][:modFrete]
				xml.transporta {
					#Escolha entre um dos dois campos abaixo.
					xml.CNPJ @data[:transporte][:transporta][:cnpj]
					xml.xNome @data[:transporte][:transporta][:razaoSocial]
					xml.IE @data[:transporte][:transporta][:ie]
					xml.xEnder @data[:transporte][:transporta][:endereco]
					xml.xMun @data[:transporte][:transporta][:municipio]
					xml.UF @data[:transporte][:transporta][:uf]
				}
				xml.vol { #Informações de Volumes a serem transportados.
					xml.qVol @data[:transporte][:volumes][:quantidade]
					xml.esp @data[:transporte][:volumes][:especie]
					xml.pesoL @data[:transporte][:volumes][:pesoLiquido]
					xml.pesoB @data[:transporte][:volumes][:pesoBruto]
				}
			}
		end

		def add_cobr(xml)
			xml.cobr { #Informações de Cobrança.
				xml.fat { #Informações de faturamento.
					xml.nFat @data[:cobranca][:fatura][:nFat]
					xml.vOrig @data[:cobranca][:fatura][:vOrig]
					# xml.vDesc "0.00" #Valor de Desconto.
					xml.vLiq @data[:cobranca][:fatura][:vLiq]
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
				xml.infAdFisco @data[:infoAdicional][:infAdFisco]
				xml.infCpl @data[:infoAdicional][:infCpl]
			}			
		end

		def access_key_generate
			accessKeyData = {
				cnpj: @data[:emitente][:cnpj],
				cUF: @data[:emitente][:codigoUF],
				nNF: @data[:identificacao][:nNF]
			}
			@accessKey = NfeBrasil::NfeAccessKey.new(accessKeyData)
		end

	end
end