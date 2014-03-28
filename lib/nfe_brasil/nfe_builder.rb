require 'nokogiri'
require 'i18n'

module	NfeBrasil
	class NfeBuilder
		DATA = {
			identificacao: {
				nNf: '',
				naturezaOperacao: '',
				formaPagamento: '',
				modelo: '',
				serie: '',
				dataEmissao: '',
				dataSaidaEntrada: '',
				horaSaidaEntrada: '',
				tipoOperacao: '',
				tipoImpressao: '',
				tipoEmissao: '',
				ambienteTransmissao: '',
				finalidade: '',
				processoEmissao: ''
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

		def initialize(data, certificado_nfe)
			@data = DATA.merge(data)
			access_key_generate
			@certificado = certificado_nfe
			builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
				xml.enviNFe("xmlns" => "http://www.portalfiscal.inf.br/nfe", "versao" => '2.00') {
					xml.idLote data[:identificacao][:nNf]
					xml.NFe {
						xml.infNFe("Id" => "NFe#{@accessKey.accessKey}", "versao" => '2.00' ) {
							add_ide(xml)
							add_emit(xml)
							add_dest(xml)
							# add_entrega(xml)
							add_loop_det(xml)
							add_total(xml)
							add_transp(xml)
							add_cobr(xml)
							add_infAdic(xml)
						}					
					}					
				}
			end
			@xml = assinar(builder)
		end

		def to_xml
			puts @xml
		end

		# def builder_to_xml
		# 	@builder.to_xml( save_with: Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION )
		# end

		def validation
			@xsd = Nokogiri::XML::Schema(File.open(File.join('XSD', 'enviNFe_v2.00.xsd')))
			@xsd.validate Nokogiri::XML(@xml, &:noblanks)
		end

		def validation?
			validation == [] ? true : false
		end

		def validation_errors
			puts "============================"
			puts "Erros de Validação da NFe"
			puts "============================"
			validation.each do |error|
				puts error
			end
			puts "============================"
		end

		def signature_info
			@signature_info
		end

		private

		def add_ide(xml)
			xml.ide { #Informações de identificação da Nota fiscal
				xml.cUF @data[:emitente][:endereco][:codigoUF]
				xml.cNF @accessKey.randomCode
				xml.natOp @data[:identificacao][:naturezaOperacao]
				xml.indPag @data[:identificacao][:formaPagamento]
				xml.mod @data[:identificacao][:modelo]
				xml.serie @data[:identificacao][:serie]
				xml.nNF @data[:identificacao][:nNf]
				xml.dEmi @data[:identificacao][:dataEmissao]
				# xml.dSaiEnt @data[:identificacao][:dataSaidaEntrada]
				# xml.hSaiEnt @data[:identificacao][:horaSaidaEntrada]
				xml.tpNF @data[:identificacao][:tipoOperacao]
				xml.cMunFG @data[:emitente][:endereco][:codigoMunicipio]
				xml.tpImp @data[:identificacao][:tipoImpressao]
				xml.tpEmis @data[:identificacao][:tipoEmissao]
				xml.cDV @accessKey.digitoVerificador
				xml.tpAmb @data[:identificacao][:ambienteTransmissao]
				xml.finNFe @data[:identificacao][:finalidade]
				xml.procEmi @data[:identificacao][:processoEmissao]
				xml.verProc NfeBrasil::VERSION
			}
		end

		def add_emit(xml)
			xml.emit { #inofrmações do Emitente da nota fiscal
				xml.CNPJ @data[:emitente][:cnpj]
				xml.xNome I18n.transliterate(@data[:emitente][:razaoSocial])
				xml.xFant @data[:emitente][:nomeFantasia]
				xml.enderEmit {
					xml.xLgr I18n.transliterate(@data[:emitente][:endereco][:logradouro])
					xml.nro @data[:emitente][:endereco][:numero]
					xml.xCpl @data[:emitente][:endereco][:complemento]
					xml.xBairro I18n.transliterate(@data[:emitente][:endereco][:bairro])
					xml.cMun @data[:emitente][:endereco][:codigoMunicipio]
					xml.xMun I18n.transliterate(@data[:emitente][:endereco][:municipio])
					xml.UF @data[:emitente][:endereco][:uf]
					xml.CEP @data[:emitente][:endereco][:cep]
					xml.cPais @data[:emitente][:endereco][:codigoPais]
					xml.xPais @data[:emitente][:endereco][:pais]
					# xml.fone @data[:emitente][:endereco][:fone]
				}
				xml.IE @data[:emitente][:ie]
				xml.CRT @data[:emitente][:crt]
			}
		end

		def add_dest(xml)
			xml.dest { #Informações do destinatário da NF eletrônica.
				#Escolha entre os dois nós a seguir.
				@data[:destinatario][:cnpj] != '' ? (xml.CNPJ @data[:destinatario][:cnpj]) : (xml.CPF @data[:destinatario][:cpf])
				xml.xNome I18n.transliterate(@data[:destinatario][:razaoSocial])
				xml.enderDest {
					xml.xLgr I18n.transliterate(@data[:destinatario][:endereco][:logradouro])
					xml.nro @data[:destinatario][:endereco][:numero]
					# xml.xCpl @data[:destinatario][:endereco][:complemento]
					xml.xBairro I18n.transliterate(@data[:destinatario][:endereco][:bairro])
					xml.cMun @data[:destinatario][:endereco][:codigoMunicipio]
					xml.xMun I18n.transliterate(@data[:destinatario][:endereco][:municipio])
					xml.UF @data[:destinatario][:endereco][:uf]
					xml.CEP @data[:destinatario][:endereco][:cep]
					xml.cPais @data[:destinatario][:endereco][:codigoPais]
					xml.xPais @data[:destinatario][:endereco][:pais]
					xml.fone @data[:destinatario][:endereco][:fone]
				}
				xml.IE @data[:destinatario][:ie]
				(xml.ISUF @data[:destinatario][:inscricaoSuframa]) if @data[:destinatario][:inscricaoSuframa] != ''
				# xml.email I18n.transliterate(@data[:destinatario][:email])
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
					xml.cProd I18n.transliterate(item[:produto][:cProd])
					xml.cEAN
					xml.xProd I18n.transliterate(item[:produto][:xProd])
					xml.NCM I18n.transliterate(item[:produto][:NCM])
					xml.CFOP I18n.transliterate(item[:produto][:CFOP])
					xml.uCom I18n.transliterate(item[:produto][:uCom])
					xml.qCom I18n.transliterate(item[:produto][:qCom])
					xml.vUnCom I18n.transliterate(item[:produto][:vUnCom])
					xml.vProd I18n.transliterate(item[:produto][:vProd])
					xml.cEANTrib
					xml.uTrib I18n.transliterate(item[:produto][:uTrib])
					xml.qTrib I18n.transliterate(item[:produto][:qTrib])
					xml.vUnTrib I18n.transliterate(item[:produto][:vUnTrib])
					xml.indTot I18n.transliterate(item[:produto][:indTot])
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
					xml.xNome I18n.transliterate(@data[:transporte][:transporta][:razaoSocial])
					xml.IE I18n.transliterate(@data[:transporte][:transporta][:ie])
					xml.xEnder I18n.transliterate(@data[:transporte][:transporta][:endereco])
					xml.xMun I18n.transliterate(@data[:transporte][:transporta][:municipio])
					xml.UF I18n.transliterate(@data[:transporte][:transporta][:uf])
				}
				xml.vol { #Informações de Volumes a serem transportados.
					xml.qVol I18n.transliterate(@data[:transporte][:volumes][:quantidade])
					xml.esp I18n.transliterate(@data[:transporte][:volumes][:especie])
					xml.pesoL I18n.transliterate(@data[:transporte][:volumes][:pesoLiquido])
					xml.pesoB I18n.transliterate(@data[:transporte][:volumes][:pesoBruto])
				}
			}
		end

		def add_cobr(xml)
			xml.cobr { #Informações de Cobrança.
				xml.fat { #Informações de faturamento.
					xml.nFat @data[:cobranca][:fatura][:nFat]
					# xml.vOrig @data[:cobranca][:fatura][:vOrig]
					# xml.vDesc "0.00" #Valor de Desconto.
					# xml.vLiq @data[:cobranca][:fatura][:vLiq]
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
				# xml.infAdFisco(@data[:infoAdicional][:infAdFisco]) if @data[:infoAdicional][:infAdFisco] != ""
				xml.infCpl I18n.transliterate(@data[:infoAdicional][:infCpl])
			}			
		end

		def assinar(builder)
			xml_builder = builder.to_xml(save_with: Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION)

			xml = Nokogiri::XML(xml_builder.to_s, &:noblanks)
			puts "=============================="
			puts "XML recebido pelo método Assinar"
			puts "=============================="
			puts xml
			puts "=============================="
			puts "=============================="

			# xml_to_signed = xml.xpath("infNFe").first

			# 1. Digest Hash for infNFe
			xml_infNFe = xml.xpath("//xmlns:infNFe")
			xml_canon = Nokogiri::XML(xml_infNFe.to_s, &:noblanks).canonicalize(Nokogiri::XML::XML_C14N_1_0)
			# xml_canon = xml_infNFe.to_s.gsub(/>\s+</, "><").gsub(/\n/, '')
			puts "=============================="
			puts "Nós InfNFe que será usado para a geração do digest"
			puts "=============================="
			puts xml_canon
			puts "=============================="
			puts "=============================="

			# xml_digest = Base64.encode64(OpenSSL::Digest::SHA1.digest(xml_canon)).strip
			xml_digest = OpenSSL::Digest::SHA1.base64digest(xml_canon)


			# 2. Add Signature Node
			signature = xml.xpath("//ds:Signature", "ds" => "http://www.w3.org/2000/09/xmldsig#").first
			unless signature
				signature = Nokogiri::XML::Node.new('Signature', xml)
				signature.default_namespace = 'http://www.w3.org/2000/09/xmldsig#'
				xml.root().add_child(signature)
			end

			# 3. Add Elements to Signature Node

			# 3.1 Create Signature Info Node
			signature_info = Nokogiri::XML::Node.new('SignedInfo', xml)

			# 3.2 Add CanonicalizationMethod
			child_node = Nokogiri::XML::Node.new('CanonicalizationMethod', xml)
			child_node['Algorithm'] = 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315' #Valor antigo: http://www.w3.org/2001/10/xml-exc-c14n#
			signature_info.add_child child_node

			# 3.3 Add SignatureMethod
			child_node = Nokogiri::XML::Node.new('SignatureMethod', xml)
			child_node['Algorithm'] = 'http://www.w3.org/2000/09/xmldsig#rsa-sha1'
			signature_info.add_child child_node

			# 3.4 Create Reference
			reference = Nokogiri::XML::Node.new('Reference', xml)
			reference['URI'] = "#NFe" + "#{@accessKey.accessKey}"

			# 3.5 Add Transforms
			transforms = Nokogiri::XML::Node.new('Transforms', xml)

			# child_node = Nokogiri::XML('').create_element('Transform')
			child_node  = Nokogiri::XML::Node.new('Transform', xml)
			child_node['Algorithm'] = 'http://www.w3.org/2000/09/xmldsig#enveloped-signature'
			transforms.add_child child_node

			# child_node = Nokogiri::XML('').create_element('Transform')
			child_node  = Nokogiri::XML::Node.new('Transform', xml)
			child_node['Algorithm'] = 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'
			transforms.add_child child_node

			reference.add_child transforms

			# 3.6 Add Digest
			child_node  = Nokogiri::XML::Node.new('DigestMethod', xml)
			child_node['Algorithm'] = 'http://www.w3.org/2000/09/xmldsig#sha1'
			reference.add_child child_node

			# 3.6 Add DigestValue
			child_node  = Nokogiri::XML::Node.new('DigestValue', xml)
			child_node.content = xml_digest
			reference.add_child child_node

			# 3.7 Add Reference and Signature Info
			signature_info.add_child reference
			signature.add_child signature_info

			@signature_info = signature_info

			# 4 Sign Signature
			puts "=============================="
			puts "Nós SignatureInfo antes da Canonicalização"
			puts "=============================="
			puts signature_info.to_s
			puts "=============================="
			puts "=============================="
			sign_canon = signature_info.canonicalize(Nokogiri::XML::XML_C14N_1_0)
			# sign_canon = signature_info.to_s.gsub(/>\s+</, "><").gsub(/\n/, '')
			puts "=============================="
			puts "Nós SignatureInfo que é usado para assinar a nota"
			puts "=============================="
			puts sign_canon
			puts "=============================="
			puts "=============================="

			signature_hash = @certificado.PKCS12.key.sign(OpenSSL::Digest::SHA1.new, sign_canon)
			puts "=============================="
			puts "Signature hash antes do Base Encode 64"
			puts "=============================="
			puts signature_hash
			puts "=============================="

			signature_value = Base64.encode64(signature_hash).gsub("\n", '').strip
			puts "=============================="
			puts "Signature hash com Base Encode 64"
			puts "=============================="
			puts signature_value
			puts "=============================="

			puts "Verificação da Assinatura"
			puts "++++++++++++++++++++++++++++++"
			if @certificado.PKCS12.certificate.public_key.verify(OpenSSL::Digest::SHA1.new, signature_hash, sign_canon)
				puts "Assinatura Verificada com sucesso"
			else
				puts "Problema ao verificar assinatura"
			end
			puts "++++++++++++++++++++++++++++++"

			# 4.1 Add SignatureValue
			child_node = Nokogiri::XML::Node.new('SignatureValue', xml)
			child_node.content = signature_value
			signature.add_child child_node

			# 5 Create KeyInfo
			key_info = Nokogiri::XML::Node.new('KeyInfo', xml)

			# 5.1 Add X509 Data and Certificate
			x509_data = Nokogiri::XML::Node.new('X509Data', xml)
			x509_certificate = Nokogiri::XML::Node.new('X509Certificate', xml)
			x509_certificate.content = @certificado.PKCS12.certificate.to_s.gsub(/\-\-\-\-\-[A-Z]+ CERTIFICATE\-\-\-\-\-/, "").gsub(/\n/,"")

			x509_data.add_child x509_certificate
			key_info.add_child x509_data

			# 5.2 Add KeyInfo
			signature.add_child key_info

			# 7 Add Signature
			xml.xpath("//xmlns:NFe").first.add_child signature


			xml = Nokogiri::XML(xml.to_s, &:noblanks)
			puts "=============================="
			puts "XML enviado para o Gateway"
			puts "=============================="
			puts xml.canonicalize(Nokogiri::XML::XML_C14N_1_0)
			puts "=============================="
			puts "=============================="

			# Return XML
			xml.canonicalize(Nokogiri::XML::XML_C14N_1_0)
			# xml.xpath("//xmlns:enviNFe").to_s.gsub(/>\s+</, "><").gsub(/\n/, '')
		end

		def access_key_generate
			accessKeyData = {
				cnpj: @data[:emitente][:cnpj],
				cUF: @data[:emitente][:endereco][:codigoUF],
				nNf: @data[:identificacao][:nNf]
			}
			@accessKey = NfeBrasil::NfeAccessKey.new(accessKeyData)
		end

	end
end