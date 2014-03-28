module NfeBrasil
	class SampleData
		DATA = {
			identificacao: {
				nNf: '1756', #Número da Nota Fiscal
				naturezaOperacao: 'venda', #Natureza da Operação: venda, compra, transferência, devolução, importação, consignação, remessa
				formaPagamento: '1', #Forma de pagamento: 0 - à vista, 1 - à prazo, 2 - outros
				modelo: '55', #Utilizar o código 55 para identificação da NF-e, emitida em substituição ao modelo 1 ou 1A.
				serie: '1', #Preencher com Zeros caso a NF não possuir série.
				dataEmissao: Date.today.to_s, #Date.today.to_s, #Data de Emissão da Nota fiscal.
				dataSaidaEntrada: Date.today.to_s, #Data de Saída ou Entrada de Mercadoria ou Produto.
				horaSaidaEntrada: Time.now.strftime("%H:%M:%S"), #Hora de Saída da Mercadoria - Formato: HH:MM:SS.
				tipoOperacao: '1', #Tipo de Operação: 0 - Entrada, 1 - Saída.
				tipoImpressao: '1', #Formato de Impressão do DANFE: 1 - retrato, 2 - paisagem
				tipoEmissao: '1', #Tipo de Emissão: 1 - Normal, 2 - Contingência FS, 3 - Contingência SCAN...
				ambienteTransmissao: '2', #Ambiente e transmissão: 1 - Produção, 2 - Homologação
				finalidade: '1', #Finalidade de emissão da NF-e: 1 - NFe Normal, 2 - Nfe Complementar, 3 - Nfe de ajuste
				processoEmissao: '3' #Processo de Emissão da Nf-e: 0 - Aplicativo do Contrinuinte, 1 - Pelo fisco, 2 - Aplicativo de Fisco
			},
			emitente: {
				cnpj: '10450992000102', #CNPJ da empresa emissora da NF.
				razaoSocial: 'Nilma Carla Vieira ME', #Razão social da Empresa Emissora.
				nomeFantasia: 'Newbrind', #Noma fantasia da empresa emissora da NF.
				endereco: {
					logradouro: 'Rua Antônio Carlos Oliveira Bottas',
					numero: '1820',
					complemento: 'c15',
					bairro: 'Villa Borguese III',
					codigoMunicipio: '3549805', #Código de São José do Rio Preto
					municipio: 'Sao Jose do Rio Preto',
					codigoUF: '35',
					uf: 'SP',
					cep: '15041570',
					codigoPais: '1058', #Código BACEN do Brasil
					pais: 'BRASIL',
					fone: '1732372261'
				},
				ie: '647544703117',
				crt: '1'
			},
			destinatario: {
				cnpj: '06297971000121',
				cpf: '',
				razaoSocial: 'NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL',
				endereco: {
					logradouro: 'R VOLUNATARIOS DA FRANÇA',
					numero: '1575',
					complemento: '',
					bairro: 'CENTRO',
					codigoMunicipio: '3516200',
					municipio: 'Franca',
					uf: 'SP',
					cep: '14400490',
					codigoPais: '1058',
					pais: 'BRASIL',
					fone: '34028384'
				},
				ie: '310383100112',
				inscricaoSuframa: '',
				email: 'sp.franca@institutoembelleze.com'
			},
			detalhes: {
				det1: {
					produto: { #Informações sobre o produto ou serviço.
						cProd: "65", #Código do Produto ou Serviço - Preencher com CFOP caso se trate de itens não relacionados a mercadoria ou produtos e que o contribuinte não possua numeração própria ex: 'CFOP9999'
						xProd: "Capa de lixa 200 pç",
						NCM: "48196000",
						CFOP: "5102", #Código CFOP: 5102 - Venda de mercadorias adquirida ou recebida de terceiros.
						uCom: "PCTE", #Unidade Comercial.
						qCom: "1.0000", #Quantidade Comercial.
						vUnCom: "109.9000000000", #Valor Unitário de Comercialização - Meramente informativo.
						vProd: "109.90", #Valor total dos produtos.
						uTrib: "PCTE", #Unidade Tributável.
						qTrib: "1.0000", #Quantidade tributável - informar a quantidade de tributação do produto.
						vUnTrib: "109.9000000000", #Valor unitário de tributação.
						indTot: "1" #Indica se o campo vProd desse item compõe o valor total da nota: 0 - Não compõe, 1 - Compõe.
					},
					imposto: { #Informações sobre os impostos incidentes nesse produto
						#TODO - Fazer o detalhamento dos nós de imposto de cada produto ou serviço que compõe a nota.
						ICMS: { #Informações sobre o Importo sobre Circulação de Mercadoria
							ICMSSN102: { #Tributação de ICMS Isenta.
								orig: "0", #Origem da Mercadoria: 0 - Nacional, 1 - Importação.
								CSOSN: "400" #Tributação do ICMS: 400 - Não tributada pelo simples naciona.
							}
						},
						IPI: { #Informações sobre o IPI.
							cEnq: "0", #Código do Enquadramento do IPI. Informar: 0.
							IPINT: { #IPI não tributado.
								CST: "52" #Código da situação tributária do IPI: 52 - Saída Isenta.
							}
						},
						PIS: { #Informações sobre o PIS.
							PISNT: { #PIS Não tributado.
								CST: "07" #Código da situação tributária do PIS: 07 - Operação isenta da contribuição.
							}
						},
						COFINS: { #Informações sobre o COFINS.
							COFINSNT: { #COFINS não tributado.
								CST: "07" #Código da situação tributária do COFINS: 07 - Operação isenta da contribuição.
							}
						}
					}
				},
				det2: {
					produto: { #Informações sobre o produto ou serviço.
						cProd: "71", #Código do Produto ou Serviço - Preencher com CFOP caso se trate de itens não relacionados a mercadoria ou produtos e que o contribuinte não possua numeração própria ex: 'CFOP9999'
						xProd: "Lixeira de Cambio 200peças",
						NCM: "48194000",
						CFOP: "5102", #Código CFOP: 5102 - Venda de mercadorias adquirida ou recebida de terceiros.
						uCom: "Pcte", #Unidade Comercial.
						qCom: "1.0000", #Quantidade Comercial.
						vUnCom: "87.9000000000", #Valor Unitário de Comercialização - Meramente informativo.
						vProd: "87.90", #Valor total dos produtos.
						uTrib: "Pcte", #Unidade Tributável.
						qTrib: "1.0000", #Quantidade tributável - informar a quantidade de tributação do produto.
						vUnTrib: "87.9000000000", #Valor unitário de tributação.
						indTot: "1" #Indica se o campo vProd desse item compõe o valor total da nota: 0 - Não compõe, 1 - Compõe.
					},
					imposto: { #Informações sobre os impostos incidentes nesse produto
						#TODO - Fazer o detalhamento dos nós de imposto de cada produto ou serviço que compõe a nota.
						ICMS: { #Informações sobre o Importo sobre Circulação de Mercadoria
							ICMSSN102: { #Tributação de ICMS Isenta.
								orig: "0", #Origem da Mercadoria: 0 - Nacional, 1 - Importação.
								CSOSN: "400" #Tributação do ICMS: 400 - Não tributada pelo simples naciona.
							}
						},
						IPI: { #Informações sobre o IPI.
							cEnq: "0", #Código do Enquadramento do IPI. Informar: 0.
							IPINT: { #IPI não tributado.
								CST: "52" #Código da situação tributária do IPI: 52 - Saída Isenta.
							}
						},
						PIS: { #Informações sobre o PIS.
							PISNT: { #PIS Não tributado.
								CST: "07" #Código da situação tributária do PIS: 07 - Operação isenta da contribuição.
							}
						},
						COFINS: { #Informações sobre o COFINS.
							COFINSNT: { #COFINS não tributado.
								CST: "07" #Código da situação tributária do COFINS: 07 - Operação isenta da contribuição.
							}
						}
					}
				}
			},
			total: {
				ICMSTot: {
					vBC: "0.00", #Valor utilizado para base de cálculo do ICMS.
					vICMS: "0.00", #Valor total do ICMS.
					vBCST: "0.00", #Valor utilizado para base de cálculo de ICMS com subsutuição tributária.
					vST: "0.00", #Valor total do ICMS com substuição tributária.
					vProd: "197.80", #Valor total de produtos e serviços.
					vFrete: "0.00", #Valor do frete.
					vSeg: "0.00", #Valor total do seguro.
					vDesc: "0.00", #Valor total de desconto.
					vII: "0.00", #Valor total do II.
					vIPI: "0.00", #Valor total do IPI.
					vPIS: "0.00", #Valor total do PIS.
					vCOFINS: "0.00", #Valor total do COFINS.
					vOutro: "0.00", #Valor com outras despesas acessórias.
					vNF: "197.80" #Valor total da NF-e.
				}
			},
			transporte: {
				modFrete: "0", #Modalidade do Frete: 0 - Por conta do emitente, 1 - Por conta do destinatário, 2 - Por conta de terceiro, 9 - Sem frete.
				transporta: { #Informações da transportadora.
					#Escolha entre um dos dois campos abaixo.
					cnpj: "44914992000138", #CNPJ da empresa transportadora.
					cpf: "", #CPF do transportador.
					razaoSocial: "Rodonaves Trans e Encomenda LTDA", #Razão Social ou Nome Completo do Transportador.
					ie: "582249216111", #Inscrição Estadual do Transportador.
					endereco: "Dr Labienio Teixeira de Mendonça 100 Distrito Industrial", #Endereço completo.
					municipio: "Sao Jose do Rio Preto", #Nome do município.
					uf: "SP" #Sigla do estado. Deve ser informado caso o nó IE seja preenchido.
				},
				volumes: { #Informações de Volumes a serem transportados.
					quantidade: "1", #Quantidade de volumes.
					especie: "caixa", #Espécie de volumes transportados.
					pesoLiquido: "4.000", #Peso Líquido em Kg.
					pesoBruto: "4.000" #Peso Bruto em Kg.
				}
			},
			cobranca: {
				fatura: { #Informações de faturamento.
					nFat: "5549", #Número da Fatura.
					# vOrig: "30.00", #Valor Original da Fatura.
					# xml.vDesc "0.00" #Valor de Desconto.
					# vLiq: "30.00", #Valor líquido da fatura.
				}
			},
			infoAdicional: {
				infAdFisco: "", #Informações adicionais de interesse do fisco.
				infCpl: "Essa empresa é opitante pelo simples nacional." #Informações adicionais de interesse do contribuinte.


			}
		}
	end
end